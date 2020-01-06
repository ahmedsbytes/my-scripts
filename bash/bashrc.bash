#!/bin/bash

#https://www.shellhacks.com/tune-command-line-history-bash/
HISTSIZE=5000
HISTFILESIZE=10000
shopt -s histappend
PROMPT_COMMAND='$PROMPT_COMMAND; history -a'

#minikube
source <(minikube completion bash)
#kubectl
source <(kubectl completion bash)
#https://raw.githubusercontent.com/ahmetb/kubectl-aliases/master/.kubectl_aliases
source $HOME/.bashrc.d/kubectl_aliases
complete -o default -F __start_kubectl k
