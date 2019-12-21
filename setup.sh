#!/usr/bin/env bash

#
# CONFIG
#
NODE_VERSION=12
PYTHON3_VERSION=8
FISH_VERSION=3
GCC_VERSION=8

GIT_EDITOR="vim"


#
# INSTALL
#
function main() {
    true \
    && update \
    && pre_install \
    && install_git \
    && install_gcc \
    && install_node \
    && install_python3 \
    && install_fish \
    && install_exa \
    && post_install
}


#
# HELPERS
#
function msg() {
    echo "===== Installing $1 ... ====="
}

function APT() {
    sudo apt-get $@
}

function update() {
    echo "===== UPDATE ====="
    true \
    && APT update \
    && APT upgrade -y
}

function pre_install() {
    true \
    && install \
        software-properties-common \
        vim
}

function install() {
    APT install -y $@
}

function install_git() {
    msg "GIT"
    true \
    && APT install -y git \
    && git config --global user.name $GIT_USERNAME \
    && git config --global user.email $GIT_EMAIL \
    && git config --global core.editor $GIT_EDITOR \
    && ssh-keygen -t rsa -b 4096 -C "$GIT_EMAIL" -f "$HOME/.ssh/id_rsa" -N ""
}

function install_gcc() {
    msg "GCC $GCC_VERSION"
    true \
    && install "gcc-$GCC_VERSION" "g++-$GCC_VERSION" make cmake \
    && sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-$GCC_VERSION 50 \
    && sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-$GCC_VERSION 50
}

function install_node() {
    msg "NODE $NODE_VERSION.x"
    true \
    && curl -sL "https://deb.nodesource.com/setup_$NODE_VERSION.x" | sudo -E bash - \
    && install nodejs \
    && mkdir "$HOME/.npm-packages" \
    && npm config set prefix "$HOME/.npm-packages" \
    && npm install -g npm yarn typescript
}

function install_python3() {
    msg "PYTHON 3.$PYTHON3_VERSION"
    true \
    && install python3.$PYTHON3_VERSION python3.$PYTHON3_VERSION-dev python3-pip \
    && python3.$PYTHON3_VERSION -m pip install --user --upgrade pip \
    && python3.$PYTHON3_VERSION -m pip install --user --upgrade virtualenv
}

function install_fish() {
    msg "FISH $FISH_VERSION"
    true \
    && sudo apt-add-repository -y "ppa:fish-shell/release-$FISH_VERSION" \
    && install fish \
    && curl -sL https://get.oh-my.fish | env NONINTERACTIVE=1 fish \
    && fish -c "omf install robbyrussell"
}

function install_exa() {
    msg "EXA"
    true \
    && install cargo \
    && cargo install exa
}

function post_install() {
    echo "===== POST INSTALL ====="
    true \
    && APT autoremove -y \
    && chsh -s /usr/bin/fish
}

main



function fiiiiiisssshhhhh() {
    # NODE
    set NPM_PACKAGES "$HOME/.npm-packages"
    set -x PATH $NPM_PACKAGES/bin $PATH
    set -x MANPATH $NPM_PACKAGES/share/man $MANPATH

    # PYTHON
    set -x PATH $HOME/.local/bin .cargo/bin $PATH

    # Rust
    set -x PATH $HOME/.cargo/bin $PATH
}
