#!/usr/bin/env bash
# Initialization file for non-login, interactive shell
# Maintainer: Faris Chugthai

# Don't run if not interactive: {{{1
case $- in
    *i*);;
    *) return 0;;
esac

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
# TODO: Figure out the correct invocation of this directive
# *shellcheck disable SC2128*
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

# TODO: i think i forgot to glob the -f loop. Debug this.
if [[ -d /data/data/com.termux/files/usr/share/bash-completion/completions ]]; then
    if [[ -f "$PREFIX/share/bash-completion/completions" ]]; then
        . "$COMPLETEFILE"
    fi
    unset COMPLETEFILE
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

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# Colors: {{{1
# TODO: Get other escape codes in a refactor the prompt.
export Color_Off="\[\033[0m\]"
export Yellow="\[\033[0;33m\]"

# export BRIGHT = "\x1b[1m"
# export BLACK = '\x1b[30m'
# export RED = '\x1b[31m'
# export CYAN = '\x1b[36m'
# export GREEN = '\x1b[32m'
# export BLUE = '\x1b[34m'

# Prompt: {{{1

force_color_prompt=yes

if [[ -n "$force_color_prompt" ]]; then
    if [[ -x "$PREFIX/bin/tput" ]] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# https://www.unix.com/shell-programming-and-scripting/207507-changing-ps1.html
# if [ "$color_prompt" = yes ]; then
# TMP_PS1="\[\033[0;31m\]\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"[\[\033[0;31m\]\342\234\227\[\033[0;37m\]]\342\224\200\") \
# [$(if [[ ${EUID} == 0 ]]; then
# echo '\[\033[01;31m\]root\[\033[01;33m\]@\[\033[01;96m\]\h' \
# else
# echo '\[\033[0;39m\]\u\[\033[01;33m\]@\[\033[01;96m\]\h' \
# fi) \
# \[\033[0;31m\]]\342\224\200[\[\033[0;32m\]\w\[\033[0;31m\]]\n\[\033[0;31m\]\342\224\224\342\224\200\342\224\200\342\225\274 \[\033[0m\]\[\e[01;33m\]\\$\[\e[0m\] " \
# else
#     TMP_PS1='┌──[\u@\h]─[\w]\n└──╼ \$ '
# fi


if [ "$color_prompt" = yes ]; then
    TMP_PS1="\[\033[0;31m\]\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"[\[\033[0;31m\]\342\234\227\[\033[0;37m\]]\342\224\200\")[$(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]root\[\033[01;33m\]@\[\033[01;96m\]\h'; else echo '\[\033[0;39m\]\u\[\033[01;33m\]@\[\033[01;96m\]\h'; fi)\[\033[0;31m\]]\342\224\200[\[\033[0;32m\]\w\[\033[0;31m\]]\n\[\033[0;31m\]\342\224\224\342\224\200\342\224\200\342\225\274 \[\033[0m\]\[\e[01;33m\]\\$\[\e[0m\] "
else
    TMP_PS1='┌──[\u@\h]─[\w]\n└──╼ \$ '
fi

# just noticed this in the venv activate script. i like it!
# if [ -z "${VIRTUAL_ENV_DISABLE_PROMPT-}" ] ; then
#     _OLD_VIRTUAL_PS1="$PS1"
#     if [ "x" != x ] ; then
#         PS1="$PS1"
#     else
#         PS1="(`basename \"$VIRTUAL_ENV\"`) $PS1"
#     fi
#     export PS1
# fi

if [[ -f "$HOME/.bashrc.d/git-prompt.sh" ]]; then
    . "$HOME/.bashrc.d/git-prompt.sh";
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWCOLORHINTS=1
    export GIT_PS1_SHOWSTASHSTATE=1
    export GIT_PS1_SHOWUPSTREAM="auto"
    PROMPT_COMMAND='__git_ps1 "${VIRTUAL_ENV:+[$Yellow`basename $VIRTUAL_ENV`$Color_Off]}" "$TMP_PS1" "[%s]"'
fi

unset color_prompt force_color_prompt

# Refactoring Prompt: {{{2
# CUSTOM BASH COLOR PROMPT
# 30m - Black
# 31m - Red
# 32m - Green
# 33m - Yellow
# 34m - Blue
# 35m - Purple
# 36m - Cyan
# 37m - White
# 0 - Normal
# 1 - Bold
prompt() {
    local BLACK="\[\033[0;30m\]"
    local BLACKBOLD="\[\033[1;30m\]"
    local RED="\[\033[0;31m\]"
    local REDBOLD="\[\033[1;31m\]"
    local GREEN="\[\033[0;32m\]"
    local GREENBOLD="\[\033[1;32m\]"
    local YELLOW="\[\033[0;33m\]"
    local YELLOWBOLD="\[\033[1;33m\]"
    local BLUE="\[\033[0;34m\]"
    local BLUEBOLD="\[\033[1;34m\]"
    local PURPLE="\[\033[0;35m\]"
    local PURPLEBOLD="\[\033[1;35m\]"
    local CYAN="\[\033[0;36m\]"
    local CYANBOLD="\[\033[1;36m\]"
    local WHITE="\[\033[0;37m\]"
    local WHITEBOLD="\[\033[1;37m\]"
    export PS1="\n$CYAN\T\n$GREENBOLD \u$YELLOWBOLD@$PURPLEBOLD\h\[\033[00m\]:$CYANBOLD[\w]\[\033[00m\] \\$ "
}

# Intentionally not calling this function

# Vim: {{{1
set -o vi
if [[ "$(command -v nvim)" ]]; then
    export VISUAL="nvim"
else
    export VISUAL="vim"
fi
export EDITOR="$VISUAL"

# JavaScript: {{{1
# Source npm completion if its installed
if [[ "$(command -v npm)" ]]; then
    source ~/.bashrc.d/npm-completion.bash
fi

# Export nvm if the directory exists
if [[ -d "$HOME/.nvm" ]]; then
    export NVM_DIR="$HOME/.nvm"
    # Load nvm and bash completion
    [[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh" # This loads nvm
    [[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion"
fi

# FZF: {{{1
# Remember to keep this below set -o vi or else FZF won't inherit vim keybindings!
if [[ -f ~/.fzf.bash ]]; then
    . "$HOME/.fzf.bash"
fi

# Loops for the varying backends for fzf. ag is my fave.
if [[ "$(command -v ag)" ]]; then
    export FZF_CTRL_T_COMMAND='ag  --hidden --nocolor --noheading --nobreak --nonumbers --follow -l'
    export FZF_CTRL_T_OPTS='--multi --cycle --color=bg+:24 --border --history-size=5000 --layout=reverse --preview "head -100 {}" --preview-window=right:50%:wrap  --header Add\ binds'
    export FZF_DEFAULT_COMMAND="$FZF_CTRL_T_COMMAND"
    export FZF_DEFAULT_OPTS="$FZF_CTRL_T_OPTS"

    alias Ag="$FZF_DEFAULT_COMMAND"+"FZF_DEFAULT_OPTS"

# Junegunn's current set up per his bashrc with an added check for fd.
elif [[ "$(command -v rg)" ]]; then
    export FZF_CTRL_T_COMMAND='rg --hidden --max-count 10 --follow '
    export FZF_CTRL_T_OPTS='--multi --color=bg+:24 --bind "enter:execute(less {})" --preview-window=right:50%:wrap --cycle'

elif [[ "$(command -v fd)" ]]; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND='fd --type f --type d --hidden --follow --exclude .git'

    if [[ -x ~/.vim/plugged/fzf.vim/bin/preview.rb ]]; then
        export FZF_CTRL_T_OPTS="--preview '~/.vim/plugged/fzf.vim/bin/preview.rb {} | head -200'"
    fi
else
    export FZF_DEFAULT_COMMAND='find * -type f'
fi

# Options for FZF no matter what. Should set only if these vars are unset
# though because this is gonna clobber.
export FZF_DEFAULT_OPTS='--multi --cycle --color=bg+:24 --border --history-size=5000 --layout=reverse'
# You can't give a preview window as a default. FZF takes so many different inputs
# that it periodically borks it. In nvim if you run Snippets, it tries to echo 100 lines
# but is only receiving 1 line at a time.
# --preview "head -100 {}" --preview-window=right:50%:wrap'

[[ -n "$NVIM_LISTEN_ADDRESS" ]] && export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS: --bind 'enter:execute(nvim {})' "

# termux doesnt have xclip or xsel
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --bind 'ctrl-y:execute-silent(echo -n {2..} | xclip)+abort' --header 'Press CTRL-Y to copy command into clipboard' "

command -v tree > /dev/null && export FZF_ALT_C_OPTS="--preview 'tree -aI .git -C {} | head -200'"

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.

_fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1"
}
# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
}

complete -F _fzf_path_completion -o default -o bashdefault ag
complete -F _fzf_dir_completion -o default -o bashdefault tree

# Python: {{{1
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
if [[ "$(command -v pip)" ]]; then
    eval "$(pip completion --bash)"
fi

export PYTHONDONTWRITEBYTECODE=1

# gcloud: {{{2
#TODO: Jump in the shell, and run the following to ensure it works,
# then reduce this section to 1 line!
# if [[ -f {~/bin,$PREFIX}/google-cloud-sdk/{path,completion}.bash.inc ]]; then source {~/bin,$PREFIX}/google-cloud-sdk/{path,completion}.bash.inc, fi

# The next line updates PATH for the Google Cloud SDK.
if [[ -f ~/bin/google-cloud-sdk/path.bash.inc ]]; then source ~/bin/google-cloud-sdk/path.bash.inc; fi
# The next line enables shell command completion for gcloud.
if [[ -f ~/bin/google-cloud-sdk/completion.bash.inc ]]; then source ~/bin/google-cloud-sdk/completion.bash.inc; fi

if [[ -f "$HOME/bin/google-cloud-sdk/path.bash.inc" ]]; then source "$HOME/bin/google-cloud-sdk/path.bash.inc"; fi

# Ruby: {{{1
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
if [[ -d "$HOME/.rvm/bin" ]]; then
    export PATH="$PATH:$HOME/.rvm/bin"
fi

# Sourced files: {{{1
if [[ -d ~/.bashrc.d/ ]]; then
    for config in ~/.bashrc.d/*.bash; do
        source "$config"
    done
    unset -v config
fi

# Secrets: {{{1
if [[ -f "$HOME/.bashrc.local" ]]; then
    . "$HOME/.bashrc.local"
fi

# [[ -z "$TMUX"  ]] && exec tmux
# [[ -n "$TMUX" ]] && export FZF_TMUX=1 && export FZF_TMUX_HEIGHT=80%

# add some cool colors to ls
eval $( dircolors -b ~/.dircolors )
