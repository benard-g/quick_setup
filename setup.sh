#!/usr/bin/env bash

if [ -z "${GIT_EMAIL}" ]; then echo Error: You must define GIT_EMAIL before running this script; exit 1; fi
if [ -z "${GIT_NAME}" ]; then echo Error: You must define GIT_NAME before running this script; exit 1; fi

ADD() {
  sudo apt install -y $@
}

# Update registry
true \
&& sudo apt update \
&& sudo apt upgrade -y \
|| exit 1

# Common software
true \
&& ADD software-properties-common vim htop neofetch \
|| exit 1

# GIT
true \
&& ADD git \
&& git config --global user.name "$GIT_NAME" \
&& git config --global user.email "$GIT_EMAIL" \
&& git config --global core.editor vim \
&& git config --global pager.branch false \
&& ssh-keygen -t rsa -b 4096 -C "$GIT_EMAIL" -f "$HOME/.ssh/id_rsa" -N "" \
|| exit 1

# GCC / G++
true \
&& ADD gcc g++ make cmake gcc-10 g++-10 \
&& sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 50 \
&& sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 50 \
|| exit 1

# NODE.JS through nvm
true \
&& curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash \
&& . $HOME/.nvm/nvm.sh \
&& nvm install --lts \
&& npm install -g yarn \
|| exit 1

# PYTHON
true \
&& ADD python python3 python3-pip \
&& python3 -m pip install --user --upgrade pip \
&& python3 -m pip install --user --upgrade virtualenv \
|| exit 1

# FISH
true \
&& ADD fish \
&& curl -sL https://get.oh-my.fish | env NONINTERACTIVE=1 fish \
&& fish -c "omf install robbyrussell" \
&& fish -c "omf install nvm" \
&& echo -n "# PATH
set -x PATH \$HOME/.local/bin \$PATH
set -x PATH \$HOME/.cargo/bin \$PATH
" > "$HOME/.config/fish/config.fish" \
&& echo -n "
function setAlias
    alias \$argv[1] \$argv[2]
    funcsave \$argv[1]
end
funcsave setAlias

function update
    sudo apt update && sudo apt upgrade && sudo apt autoremove
end
funcsave update

setAlias ls exa
setAlias ll 'ls -l'
setAlias la 'ls -la'
setAlias lls 'clear; ls'
setAlias lll 'clear; ll'
setAlias lla 'clear; la'
setAlias tree 'exa --tree'
setAlias .. 'cd ..'
setAlias ... 'cd ../..'
setAlias .... 'cd ../../..'
setAlias ..... 'cd ../../../..'
setAlias ...... 'cd ../../../../..'
setAlias ....... 'cd ../../../../../..'
setAlias ........ 'cd ../../../../../../..'
setAlias fishrc 'vim ~/.config/fish/config.fish'
" | fish \
|| exit 1

# EXA (a prettier ls)
true \
&& ADD cargo \
&& cargo install exa \
|| exit 1

# Post-install cleaning
sudo apt-autoremove
