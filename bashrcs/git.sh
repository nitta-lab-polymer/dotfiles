#! /bin/bash

source ~/.git-completion.sh

function default_branch() {
    git branch -l | cut -d ' ' -f 2 | tr -d '\n'
}

function gd() {
    git fetch --prune
    number_of_branches=$(git branch | wc -l)
    current_branch=$(git branch --show-current)
    if [ "${number_of_branches}" -eq 1 ]; then
        echo 'only one branch'
    else
        if [ "${current_branch}" = "$(default_branch)" ]; then
            git branch | grep -v "$(default_branch)" | xargs git branch -D
        else
            git checkout main &&
                git branch | grep -v "$(default_branch)" | xargs git branch -d &&
                git checkout "${current_branch}"
        fi
    fi
}

function make_github_template() {
    if [ ! -d .github ]; then
        mkdir .github
        cp "${dotfiles_dir}"/.github-template/* ./.github
    fi
}

function gpf() {
    git push --force-with-lease
}

function gpr() {
    git pull --rebase origin main
    echo -n "execute 'git push force-with-lease' ? [Y/n]: "
    read -r ANS

    case $ANS in
    "" | [Yy]*)
        gpf
        ;;
    *)
        # 「No」の場合の処理
        ;;
    esac
}
