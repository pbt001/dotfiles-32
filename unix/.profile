#!/bin/bash
# Initialization file for login, non-interactive shell
# Maintainer: Faris Chugthai


# Python
# https://pip.pypa.io/en/stable/user_guide/#command-completion
eval "`pip completion --bash`"

# Set PATH so it includes user's private bin directories
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"


# Go
# Add the Go std lib to the PATH if that's where it was put
if [[ -d "/usr/local/go" ]]; then
    export PATH="/usr/local/go/bin:$PATH"
elif [[ -d "$PREFIX/local/go" ]]; then
    export PATH="$PREFIX/local/go/bin:$PATH"
fi

# Utilize GOPATH. 
export GOPATH=$(go env GOPATH)

#Use gofmt as a check for whether Go is installed or not.
if [[ $(which gofmt) ]]; then
    export PATH="$PATH:$(go env GOPATH)/bin"
fi


## JavaScript
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"


# Environment Variables
#
# -J displays a status column at the left edge of the screen
# -R is what we need for ansi colors
export PAGER="less -JR"

# Man pages are difficult to read on Termux with line numbers
export MANPAGER="less -R"

# Allow a color terminal
export COLORTERM="colorterm"

# These are the defaults but for the sake of being explicit rather than implicit
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"


# cheat.py
if [[ $(which cheat) ]]; then
    export CHEATCOLORS=true
fi


# kinda hacky but this is a real easy way to determine
# if were using termux or ubuntu. termux defines prefix.
if [[ -n "$PREFIX" ]]; then
    export SHELL="$PREFIX/bin/bash"
    export BROWSER="w3m"
else
    export SHELL="/bin/bash"
    export BROWSER="firefox"
fi

# Set locale if it isn't explicitly stated elsewhere
export LC_ALL=en_US.UTF-8
