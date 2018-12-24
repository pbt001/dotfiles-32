#!/usr/bin/env bash
# Maintainer: Faris Chugthai

# Functions to make the day a little easier
# Create a new directory and enter it
mk() {
    mkdir -pv "$@" && cd "$@" || exit
}

# Handy Extract Program
extract() {
if [ -f "$1" ]; then
    case "$1" in
        *.tar.bz2) tar xvjf "$1" ;;
        *.tar.gz) tar xvzf "$1" ;;
        *.bz2) bunzip2 "$1" ;;
        *.rar) unrar x "$1" ;;
        *.gz) gunzip "$1" ;;
        *.tar) tar xvf "$1" ;;
        *.tbz2) tar xvjf "$1" ;;
        *.tgz) tar xvzf "$1" ;;
        *.zip) unzip "$1" ;;
        *.Z) uncompress "$1" ;;
        *.7z) 7z x "$1" ;;
        *.tar.xz) tar xvf "$1" ;;
    # Alternatively you could run xz -d file.tar.xz; tar xvf file.tar
        *) echo "'$1' cannot be extracted via >extract<" ;;
    esac
else
    echo "'$1' is not a valid file!"
fi
}

# Run cd and ls at once
cs () {
    cd "$@" && ls -F
}

# Decrypt the ssh priv key for the day
ssh-day () {
    if [[ -z "$SSH_AUTH_SOCK" ]]; then
        eval "$(ssh-agent -s)"
    else
        export SSH_AUTH_SOCK=''
        eval "$(ssh-agent -s)"
    fi
    ssh-add
}

# Adds an alias to the current shell and to ~/.bashrc.d/alias
add-alias () {
   local name=$1 value="$2"
   echo alias "$name"="$value" >> ~/.bashrc.d/alias.bash
   eval alias "$name"="$value"
   alias "$name"
}

# Update the python packages you care about most
update-pip () {
    local pu="pip install -Uq"
    $pu pip
    $pu ipython
    $pu virtualenv
    $pu jedi
    $pu flake8
}

# I really don't like anything that smells like Emacs keybindings
infovi () {
    info "$1" | "$PAGER"
}

# From byobu
byobu_prompt_status() { local e=$?; [ $e != 0 ] && echo -e "$e "; }

# FZF: {{{

fzf-down() {
  fzf --height 50% "$@" --border
}

# commits in a repo
fzf_commits() {
  git log --pretty=oneline --abbrev-commit | fzf --preview-window=right:50% --preview 'echo {} | cut -f 1 -d " " | xargs git show --color=always' | cut -f 1 -d " "
}

# for existing man pages
fzf_apropos() {
  apropos '' | fzf --preview-window=right:50% --preview 'echo {} | cut -f 1 -d " " | xargs man' | cut -f 1 -d " "
}

# view EVERYTHING set in your env
fzf_env() {
    set | tr = "\t" | fzf | cut -f 1
}

fzf_nvim() {
  local file
  file=$(fzf --query="$1" --select-1 --exit-0)
  [ -n "$file" ] && ${EDITOR:-nvim} "$file"
}

tldrbox_cheat() {
    tldr -m "$1" >> "$HOME/.cheat/$1" && termux-share "$1"
}

tldropbox_dir() {
    tldr -m "$1" >> "$PWD/$1" && termux-share "$1"
}

conda_switch() {
    conda deactivate && conda activate "$1"
}

gpip() {
    export PIP_REQUIRE_VIRTUALENV=0;
    pip "$@";
    export PIP_REQUIRE_VIRTUALENV=1 > /dev/null
}

# Honestly just pull up junegunns blog post on this, sit down,
# hack away and make a new file.
# TODO:
# fstash - easier way to deal with stashes
# type fstash to get a list of your stashes
# enter shows you the contents of the stash
# ctrl-d shows a diff of the stash against your current HEAD
# ctrl-b checks the stash out as a branch, for easier merging
# fstash() {
#   local out q k sha
#   while out=$(
#     git stash list --pretty="%C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs" |
#     fzf --ansi --no-sort --query="$q" --print-query \
#         --expect=ctrl-d,ctrl-b);
#   do
#     mapfile -t out <<< "$out"
#     q="${out[0]}"
#     k="${out[1]}"
#     sha="${out[-1]}"
#     sha="${sha%% *}"
#     [[ -z "$sha" ]] && continue
#     if [[ "$k" == 'ctrl-d' ]]; then
#       git diff $sha
#     elif [[ "$k" == 'ctrl-b' ]]; then
#       git stash branch "stash-$sha" $sha
#       break;
#     else
#       git stash show -p $sha
#     fi
#   done
# }

# Oct 04, 2018
# in a manner similar to __fzf__history__ display all of hist to std out
# noninteractive tho
hist_std_out() {
    fc -nl 1 "$HISTFILESIZE"
}


# Other TODO: Possibly rewrite the man function here. IE if nvim then do that,
# elif most, else less

# Back up a file using bracket expansion I.E. mv foo.py foo.py.bak
bak() {
    mv $1{,.bak}
}
