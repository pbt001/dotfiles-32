#!/usr/bin/env bash
# Initialization file for non-login, interactive shell
# Maintainer: Faris Chugthai

# Don't run if not interactive: {{{1
case $- in
    *i*);;
    *) return 0;;
esac

# Python: {{{1
# Put python first because we need conda initialized right away
if [[ -d "$HOME/miniconda3/bin/" ]]; then
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('$HOME/miniconda3/bin/conda' shell.bash hook 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
fi

# https://pip.pypa.io/en/stable/user_guide/#command-completion
if [[ -n "$(command -v pip)" ]]; then
    eval "$(pip completion --bash)"
fi

export PYTHONDONTWRITEBYTECODE=1

# gcloud: {{{2
# TODO: Jump in the shell, and run the following to ensure it works,
# then reduce this section to 1 line!
# if [[ -f {~/bin,$PREFIX}/google-cloud-sdk/{path,completion}.bash.inc ]]; then source {~/bin,$PREFIX}/google-cloud-sdk/{path,completion}.bash.inc, fi
if [[ -f ~/google-cloud-sdk/path.bash.inc ]]; then source ~/google-cloud-sdk/path.bash.inc; fi

if [[ -f ~/google-cloud-sdk/completion.bash.inc ]]; then source ~/google-cloud-sdk/completion.bash.inc; fi

if [[ -f "$PREFIX/google-cloud-sdk/path.bash.inc" ]]; then source "$PREFIX/google-cloud-sdk/path.bash.inc"; fi

if [[ -f "$PREFIX/google-cloud-sdk/completion.bash.inc" ]]; then source "$PREFIX/google-cloud-sdk/completion.bash.inc"; fi

# History: {{{1
# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=50000
# TODO: What are the units on either of these?
# Still don't know but fc maxes out at 32767
HISTFILESIZE=50000
# https://unix.stackexchange.com/a/174902
HISTTIMEFORMAT="%F %T: "
# Ignore all the damn cds, ls's its a waste to have pollute the history
HISTIGNORE='exit:ls:cd:history:ll:la:gs'

# Shopt: {{{1
# Be notified of asynchronous jobs completing in the background
set -o notify
# Append to the history file, don't overwrite it
shopt -s histappend
# Check the window size after each command and, if necessary,
# Update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
# Disabled because BASH_VERSINFO isn't even an array it's the 0th element
# of BASH_VERSION and a simple int
# shellcheck disable=SC2128
if [[ $BASH_VERSINFO -gt 3 ]]; then
    shopt -s globstar
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    . /usr/share/bash-completion/bash_completion
  elif [[ -f /etc/bash_completion ]]; then
    . /etc/bash_completion
  fi
fi

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob
set -o noclobber        # Still dont want to clobber things
shopt -s xpg_echo       # Allows echo to read backslashes like \n and \t
shopt -s dirspell       # Autocorrect the spelling if it can
shopt -s cdspell

# Defaults in Ubuntu bashrcs: {{{1
# make less more friendly for non-text input files, see lesspipe(1)
# Also lesspipe is described in Input Preprocessors in man 1 less.
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [[ -z "${debian_chroot:-}" ]] && [[ -r /etc/debian_chroot ]]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# GBT:
if [[ -n "$(command -v gbt)" ]]; then
    prompt_tmp=$(gbt $?)
    export PS1=$prompt_tmp

    export GBT_CARS='Status, Os, Hostname, Dir, Git, Sign'
    export GBT_CAR_STATUS_FORMAT=' {{ Code }} {{ Signal }} '
    unset prompt_tmp
fi

# Vim: {{{1
set -o vi
if [[ "$(command -v nvim)" ]]; then
    export VISUAL="nvim"
else
    export VISUAL="vim"
fi
export EDITOR="$VISUAL"

# JavaScript: {{{1

# Source npm completion if its installed.
if [[ -n "$(command -v npm)" ]]; then
    # shellcheck source=/home/faris/.bashrc.d/npm-completion.bash
    source ~/.bashrc.d/npm-completion.bash
fi

# Export nvm if the directory exists
if [[ -d "$HOME/.nvm" ]]; then
    export NVM_DIR="$HOME/.nvm"
    # Load nvm and bash completion
    [[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh" # This loads nvm
    [[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion"
fi

# Testing out the language servers to see if they'll link up with neovim
if [[ -d "$HOME/.local/share/nvim/site/node_modules/.bin" ]]; then
    export PATH="$PATH:$HOME/.local/share/nvim/site/node_modules/.bin"
fi

# FZF: {{{1

# Remember to keep this below set -o vi or else FZF won't inherit vim keybindings!
if [[ -f ~/.fzf.bash ]]; then
    . "$HOME/.fzf.bash"
fi

# Loops for the varying backends for fzf.
if [[ "$(command -v ag)" ]]; then
    # Doesn't work.
    Ag() {
        "$FZF_DEFAULT_COMMAND $@" | fzf -
    }
fi

# Junegunn's current set up per his bashrc with an added check for fd.
if [[ "$(command -v rg)" ]]; then

    export FZF_DEFAULT_COMMAND='rg --hidden --max-count 10 --follow --smart-case --no-messages '
    export FZF_CTRL_T_COMMAND='rg --hidden --count-matches --follow --smart-case --no-messages '

    export FZF_CTRL_T_OPTS='--multi --cycle --border --reverse --color=bg+:24 --preview "head -100 {}" --preview-window=down:50%:wrap --ansi --bind ?:toggle-preview --header "Press ? to toggle preview." '
    export FZF_DEFAULT_OPTS='--multi --cycle --color=bg+:24 --border --ansi'


elif [[ "$(command -v fd)" ]]; then

    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow -j 8 -d 6 --exclude .git'
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow -j 8 -e --exclude .git'
    export FZF_CTRL_T_COMMAND='fd --type f --type d --hidden --follow -j 8 -d 6 --exclude .git'

    export FZF_CTRL_T_OPTS='--multi --cycle --border --reverse --preview "head -100 {}" --preview-window=down:50%:wrap --ansi --bind ?:toggle-preview --header "Press ? to toggle preview."'

    if [[ -x ~/.vim/plugged/fzf.vim/bin/preview.rb ]]; then
        export FZF_CTRL_T_OPTS="--preview '~/.vim/plugged/fzf.vim/bin/preview.rb {} | head -200'"
    fi


else
    export FZF_DEFAULT_COMMAND='find * -type f'

    # Options for FZF no matter what.
    export FZF_DEFAULT_OPTS='--multi --cycle --color=bg+:24 --border --reverse'
fi

# termux doesnt have xclip or xsel
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window=down:hidden:wrap --bind '?:toggle-preview' --bind 'ctrl-y:execute-silent(echo -n {2..} | xclip)+abort' --header 'Press CTRL-Y to copy command into clipboard' "

command -v tree > /dev/null && export FZF_ALT_C_OPTS="--preview 'tree -aF -I .git -I __pycache__ -C {} | head -200'"

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.

if [[ -n "$(command -v fd)" ]]; then
    _fzf_compgen_path() {
        fd --hidden --follow --exclude ".git" . "$1"
    }
    # Use fd to generate the list for directory completion
    _fzf_compgen_dir() {
        fd --type d --hidden --follow --exclude ".git" . "$1"
    }
fi

complete -F _fzf_path_completion -o default -o bashdefault ag
complete -F _fzf_dir_completion -o default -o bashdefault tree

# Ruby: {{{1
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
if [[ -d "$HOME/.rvm/bin" ]]; then
    export PATH="$PATH:$HOME/.rvm/bin"
fi

# Sourced files: {{{1

# Feb 16, 2019: tmux botches this on termux

test -f "$_ROOT/share/bash-completion/bash_completion" && source "$_ROOT/share/bash-completion/bash_completion"

# This needs updating since so many of the files are already stated and a handful add completion
# for commands i don't hace on every device.
if [[ -d ~/.bashrc.d/ ]]; then
    for config in ~/.bashrc.d/*.bash; do
        # shellcheck source=/home/faris/.bashrc.d/*.bash
        source "$config"
    done
    unset -v config
fi

# add some cool colors to ls
eval $( dircolors -b ~/.dircolors )


# Here's one for the terminal
if [[ -n "$(command -v kitty)" ]]; then
    source <(kitty + complete setup bash)
fi

# Secrets: {{{1
if [[ -f "$HOME/.bashrc.local" ]]; then
    # shellcheck source=/home/faris/.bashrc.local
    . "$HOME/.bashrc.local"
fi
