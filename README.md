# WSL quick setup

This guide contains my personal installation steps to configure a new WSL environment.

Most of these commands are intended to be copied & pasted in a freshly created `Ubuntu-22` WSL.

> You are free to follow these steps but be aware that they are tightly related to my personal needs.

## Setup

### Update system

```sh
sudo apt update && sudo apt upgrade -y
```

### Install common softwares

```sh
sudo apt install -y software-properties-common vim htop neofetch zip unzip
```

### Install `git`

```sh
sudo apt install -y git

git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global core.editor vim
git config --global pull.ff only
git config --global pager.branch false

ssh-keygen -t ed25519 -C "$SSH_NAME"
```

### Install `zsh` shell

```sh
sudo apt install -y zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Install `NodeJS` through [fnm](https://github.com/Schniz/fnm)

```sh
curl -fsSL https://fnm.vercel.app/install | bash
```

### Install `exa` (an alternative to `ls`)

```sh
sudo apt install -y exa
```

### Cleanup

```sh
sudo apt autoremove
```

> 💡 You should now close the current session by closing the terminal and start a new one.


## Post cleanup steps

### Main folders

```sh
mkdir -p ~/Projects
```

### ZSH customization

Install some useful plugins
```sh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

Copy the following content inside your `~/.zshrc` file.

```sh
#
# OH-MY-ZSH
#
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
  docker
  docker-compose
  fnm
  gcloud
  git
  kubectl
  node
  npm
  yarn
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

#
# NODE-JS
#
export PATH=/home/beubeu/.fnm:$PATH
eval "$(fnm env --use-on-cd)"

#
# ALIASES
#
alias update="sudo apt update && sudo apt upgrade && sudo apt autoremove"

alias ls="exa"
alias ll="ls -l"
alias la="ls -la"
alias lls="clear; ls"
alias lll="clear; ll"
alias lla="clear; la"

alias tree="exa --tree"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."
alias ........="cd ../../../../../../.."

alias pro="cd ~/Projects"

function tmp {
  local tmp_dir="/tmp/tmp-"`date +"%s"`"-$(((RANDOM % 89999) + 10000))"
  mkdir -p $tmp_dir
  cd $tmp_dir
}

alias zshrc="vim ~/.zshrc; source ~/.zshrc"
```

Close your terminal to conclude the installation.
