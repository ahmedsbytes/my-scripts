#!/bin/bash


# get current status of git repo
function _parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}


function _ps1_nonzero_return() {
	RETVAL=$?
	echo "$RETVAL"
}

KUBE_PS1_SYMBOL_IMG=$'\xE2\x98\xB8 '		
function _ps1_kubectl() {
	KUBECTL_CURRENT_CONTENT=$(kubectl config view | grep current-context | sed -e "s|current-context: ||g" | tr -cd '[:alnum:]._-')
}


# get current branch in git repo
function _parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`_parse_git_dirty`
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
}

test $(id -u) -eq 0 && UCOLOR=31m || UCOLOR=32m


PS1="\[\e[0;33m\][\[\e[${UCOLOR}\]\u\[\e[m\]\[\e[0;33m\]@\[\e[m\]\[\e[0;35m\]\H\[\e[m\]\[\e[0;33m\]][\[\e[m\]\[\e[32m\]\w\[\e[m\]\[\e[0;33m\]][\[\e[m\]\[\e[32m\]? \`_ps1_nonzero_return\`\[\e[m\]\[\e[0;33m\]]"
PS1="$PS1[\[\e[m\]\[\e[0;35m\]${KUBE_PS1_SYMBOL_IMG}\`_ps1_kubectl\`\[\e[0;33m\]]\`_parse_git_branch\`"
export PS1="$PS1 \[\e[m\] \r\n→ "
