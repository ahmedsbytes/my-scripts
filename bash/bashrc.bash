#!/bin/bash

#https://www.shellhacks.com/tune-command-line-history-bash/
HISTSIZE=5000
HISTFILESIZE=10000
shopt -s histappend

function add_kubectl_context(){
	KUBE_PS1_SYMBOL_IMG=$'\xE2\x98\xB8 '
	KUBECTL_CURRENT_CONTENT=$(kubectl config view | grep current-context | sed -e "s|current-context: ||g" | tr -d "\n\r")
	PS1="${KUBE_PS1_SYMBOL_IMG}${KUBECTL_CURRENT_CONTENT}$PS1"
}

export PROMPT_COMMAND="${PROMPT_COMMAND:-true}; add_kubectl_context;history -a"

#Keep your version of the universe
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

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

#minikube
source <(minikube completion bash)

#kubectl
source <(kubectl completion bash)
#https://raw.githubusercontent.com/ahmetb/kubectl-aliases/master/.kubectl_aliases
source $HOME/.bashrc.d/kubectl_aliases
complete -o default -F __start_kubectl k
