# WSL quick setup

This guide contains my personal installation steps to configure a new WSL environment.

These commands are intended to be copied & pasted in a freshly created `Ubuntu-20` WSL.

> You are free to follow these steps but be aware that they are tightly related to my personal needs.

## Setup

### Update system

```sh
sudo apt update && sudo apt upgrade -y
```

### Install common softwares

```sh
sudo apt install -y software-properties-common vim htop neofetch
```

### Install `git`

Consider exporting the following variables before running the shell commands (or replace them manually).
```sh
export GIT_NAME="My Name"
export GIT_EMAIL="my-email@example.net"
export SSH_NAME="my-host-name"
```

```sh
sudo apt install -y git

git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global core.editor vim
git config --global pull.ff only
git config --global pager.branch false

ssh-keygen -t rsa -b 4096 -f "$HOME/.ssh/id_rsa.pub" -N "" -C "$SSH_NAME"
```

### Install `gcc` & `g++`

```sh
sudo apt install -y gcc g++ make cmake gcc-10 g++-10
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 50
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 50
```

### Install NodeJS through `nvm`

```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash
. $HOME/.nvm/nvm.sh
nvm install --lts
npm install -g yarn
```

### Install `python`

```sh
sudo apt install -y python python3 python3-pip pipenv
python3 -m pip install --user --upgrade pip
python3 -m pip install --user --upgrade virtualenv
```

### Install the `fish` shell

```sh
sudo apt install -y fish
curl -sL https://get.oh-my.fish | env NONINTERACTIVE=1 fish
fish -c "omf install robbyrussell"
fish -c "omf install nvm"
# Set the fish shell as default (you will need to enter your password)
chsh -s /usr/bin/fish
```

### Install `exa` (an alternative to `ls`)

```sh
sudo apt install -y cargo
cargo install exa
```

### Cleanup

```sh
sudo apt autoremove
```

> 💡 You should now close the current session by closing the terminal and start a new one.


## Post cleanup steps

At this step, you should be inside the `fish` shell, you can verify this by running the `ps` command.

### Fish customization

Create a fish configuration at the following path `~/.config/fish/config.fish`.

It should have the following content.

```sh
# Move to WSL home directory on start-up
switch $PWD
  case '/mnt/c/Users/*'
    cd $HOME
end

# PATH
set -x PATH $HOME/.local/bin $PATH
set -x PATH $HOME/.cargo/bin $PATH

# Configure x-client
set -x DISPLAY (grep 'nameserver' /etc/resolv.conf | sed 's/nameserver //'):0
```

> 💡 You should install the [VcXsrv](https://sourceforge.net/projects/vcxsrv) x-server for Windows.

You can also add these useful aliases and functions.

```sh
function setAlias
  alias $argv[1] $argv[2]
  funcsave $argv[1]
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

setAlias fishrc 'vim ~/.config/fish/config.fish'

setAlias .. 'cd ..'
setAlias ... 'cd ../..'
setAlias .... 'cd ../../..'
setAlias ..... 'cd ../../../..'
setAlias ...... 'cd ../../../../..'
setAlias ....... 'cd ../../../../../..'
setAlias ........ 'cd ../../../../../../..'
```

Close your terminal to conclude the installation.