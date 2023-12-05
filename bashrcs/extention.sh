#! /bin/bash

function ext__list_install() {
    path=".extensions.$1[]"
    for item in $(jq -r "${path}" extensions.json); do
        code --install-extension "${item}"
    done
}

function ext() {
    cd "${dotfiles_dir}" || return
    extlist=$(jq <extensions.json -r '.extensions | keys | .[] ')
    list=${extlist[*]}

    if (($# == 0)); then
        echo "Usage: ext [-l | --list] [-h | --help] [extension name]"
        return
    fi

    while (($# > 0)); do
        case $1 in
        -l | --list)
            echo "${extlist[@]}"
            ;;
        -h | --help)
            echo "Usage: ext [-l | --list] [-h | --help] [extension name]"
            ;;
        esac
        for str in $list; do
            if [[ "$1" == "$str" ]]; then
                ext__list_install "$1"
            fi
        done
        shift
    done
    cd - >/dev/null || return
}
