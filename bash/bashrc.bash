#!/bin/bash

#https://www.shellhacks.com/tune-command-line-history-bash/
HISTSIZE=5000
HISTFILESIZE=10000
shopt -s histappend
PROMPT_COMMAND="history -a"

#Keep your version of the universe
PATH="$HOME/.local/bin:$HOME/bin:$PATH"
PATH="$PATH:/home/amaabdou/.cargo/bin"
PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
PATH=$PATH:$(go env GOPATH)/bin
PATH=$PATH:/var/lib/snapd/snap/bin
PATH=$PATH:~/.local/flutter/bin
PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator
export PATH

## my git short functions
function git_branch_name() { 
        branch_name=$(git symbolic-ref -q HEAD) && branch_name=${branch_name##refs/heads/} && branch_name=${branch_name:-HEAD} && echo $branch_name;
}
function gco(){
        git fetch origin $1 && git checkout $1
}
alias gho='git_branch_name && git push origin $(git_branch_name)'
alias glo='git_branch_name && git pull origin $(git_branch_name)'
alias glu='git_branch_name && git pull upstream $(git_branch_name)'
alias glom='git pull origin master'
alias glum='git pull upstream master'
alias gmom='git fetch origin master && git merge origin/master'
alias gmum='git fetch upstream master && git merge upstream/master'

#fzf https://github.com/junegunn/fzf/blob/master/shell/completion.bash
source /usr/share/fzf/shell/key-bindings.bash 
source <(minikube completion bash) #minikube
source <(kubectl completion bash) #kubectl
#https://raw.githubusercontent.com/ahmetb/kubectl-aliases/master/.kubectl_aliases
source $HOME/.bashrc.d/kubectl_aliases
complete -o default -F __start_kubectl k
