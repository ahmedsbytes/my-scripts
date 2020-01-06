#!/bin/bash

#https://www.shellhacks.com/tune-command-line-history-bash/
HISTSIZE=5000
HISTFILESIZE=10000
shopt -s histappend
export PROMPT_COMMAND="$PROMPT_COMMAND; history -a"

#fzf https://github.com/junegunn/fzf/blob/master/shell/completion.bash
source /usr/share/fzf/shell/key-bindings.bash 

#Keep your version of the universe
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

#minikube
source <(minikube completion bash)
alias kubectl='minikube kubectl'

#kubectl
source <(kubectl completion bash)
#https://raw.githubusercontent.com/ahmetb/kubectl-aliases/master/.kubectl_aliases
source $HOME/.bashrc.d/kubectl_aliases
complete -o default -F __start_kubectl k
