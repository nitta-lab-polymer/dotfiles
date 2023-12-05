#! /bin/bash

source ~/.git-prompt.sh
PS1='\n\[\e[92m\]\w \[\e[3;4;95m\]$(__git_ps1 "(%s)")\[\e[0m\] > '
