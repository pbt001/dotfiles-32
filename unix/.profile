#!/usr/bin/env bash
# Initialization file for login, non-interactive shell
# Maintainer: Faris Chugthai

# TODO: For everything that modifies path, run a check to ensure it's not already an entry.

# Set PATH so it includes user's private bin directories
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# Platform_Dependant: {{{1
# Tooo many of these are simply based on the weird path Termux gives.

if [[ -n "$PREFIX" ]]; then
    _ROOT="$PREFIX"
else
    _ROOT="/usr"
fi

export SHELL="$_ROOT/bin/bash"
export XDG_CONFIG_DIRS="/etc/xdg:/usr/share/xsessions"
export XDG_DATA_DIRS="$PREFIX/local/share:$PREFIX/share"
export MANPATH="$PREFIX/share/man:$HOME/.fzf/man"
export NVIMRUNTIME="$PREFIX/share/nvim/runtime"

if [[ -f "$_ROOT/share/bash_completion" ]] && source "$_ROOT/share/bash_completion"; then
    continue
fi

if [[ -n "$PREFIX" ]]; then
    export PATH="$PREFIX/local/bin/:$PATH"
else
    export BROWSER="firefox-nightly --profile-manager"
fi

# Ruby: {{{1
# This is gonna need a for loop soon.

if [[ -d ~/.gem/ruby/2.5.0/bin ]]; then
    export PATH="$PATH:$HOME/.gem/ruby/2.5.0/bin"
fi

if [[ -d ~/.gem/ruby/2.6.0/bin ]]; then
    export PATH="$PATH:$HOME/.gem/ruby/2.6.0/bin"
fi

if [[ -d "$HOME/.rvm" ]]; then
    # Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
    export PATH="$PATH:$HOME/.rvm/bin"
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
fi

# Go: {{{1
# Add the Go std lib to the PATH if that's where it was put
if [[ -d "/usr/local/go" ]]; then
    export PATH="$PATH:/usr/local/go/bin"
elif [[ -d "$PREFIX/local/go" ]]; then
    export PATH="$PATH:$PREFIX/local/go/bin"
fi

# Utilize GOPATH.
if [[ "$(command -v go)" ]]; then
    export GOPATH="$(go env GOPATH)"
    export PATH="$PATH:$GOPATH/bin"
fi

# JavaScript: {{{1
if [[ "$(command -v yarn)" ]]; then
    YARNPATH="$HOME/.yarn/bin:$HOME/.local/share/yarn/global/node_modules/.bin"
    export PATH="$PATH:$YARNPATH"

    if [[ -f "$HOME/.local/share/yarn/global/node_modules/tldr/bin/autocompletion.bash" ]]; then
        source "$HOME/.local/share/yarn/global/node_modules/tldr/bin/autocompletion.bash"
    fi
fi

# Lisp:{{{1
if [[ -d "$HOME/.racket/7.1/bin" ]]; then
    export PATH="$PATH:$HOME/.racket/7.1/bin"
fi

# Environment Variables: {{{1
# -J displays a status column at the left edge of the screen
# -R is what we need for ansi colors
# -K: exit less in response to Ctrl-C
# -M: Verbose prompt
# -L: Line numbers. Open a man page and hit 'G' to see what you're getting into
export PAGER="less -JRKML"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

if [[ "$(command -v cheat)" ]];then
    export CHEATCOLORS=true;
    export CHEATPATH="$HOME/python/tutorials:$HOME/python/tutorials/site-packages:$HOME/.cheat"
fi

# Set locale if it isn't explicitly stated elsewhere
export LANG=en_US.UTF-8                 # gathered from localectl
export LC_MESSAGES=C                    # man i3: Prevents program output translation
export LANGUAGE=en                      # nvim complains us region not supported
# export LC_CTYPE=utf-8
export PYTHONDONTWRITEBYTECODE=1

# Enough vim plugins use either $TMPDIR or $TMP that this became necessary
if [[ -n "$TMPDIR" ]]; then
    export TMP="$TMPDIR"
else
    if [[ -d "/tmp" ]]; then
        export TMP="/var/tmp,/usr/tmp,/tmp"
        export TMPDIR="/var/tmp"
    fi
fi

export TMUXP_CONFIGDIR='$HOME/.tmux'

# As this was placed here because Termux didn't have a manpath set
# Here's the one I currently have from KDE Neon. Nov 07, 2018
# /home/faris/miniconda3/share/man:/usr/local/man:/usr/local/share/man:/usr/share/man:/home/faris/.local/kitty.app/share/man:/home/faris/.fzf/man
# if [ "$(command -v manpath)" ] ; then MANPATH="$(manpath)"; export MANPATH; fi

export CURL_HOME="$HOME/.config/curl/curlrc"

# Rust: {{{1
if [[ -d "$HOME/.cargo/bin" ]]; then
    export PATH="$HOME/.cargo/bin:$PATH";
fi

# Sourced Files: {{{1

# Setup completions correctly.

# Help find your dotfiles faster
export DOT="$HOME/projects/dotfiles"
export VICONF="$HOME/projects/viconf/.config/nvim"
export NVIM="$HOME/.config/nvim"

# Source the bashrc last.
if [[ -f "$HOME/.bashrc" ]]; then
    . "$HOME/.bashrc" ;
fi

if [[ "$(command -v bat)" ]]; then
    export BAT_THEME=OneHalfDark
    export BAT_PAGER=''
fi
