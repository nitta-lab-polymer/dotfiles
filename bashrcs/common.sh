#! /bin/bash

if [ ! "${REMOTE_CONTAINERS}" ]; then
    echo "not remote container"
    exit 0
fi

workspace_dir=$(ls -d /workspaces/*)
dotfiles_dir="${workspace_dir}/dotfiles"
alias c="clear"
alias e="exit"
alias ..="cd .."
alias ...="cd ../.."
alias .2="cd ../../"
alias .3="cd ../../../"
alias .4="cd ../../../../"
alias .5="cd ../../../../../"

alias ls="exa"
alias la="exa -a"
alias ll="exa -l"
alias tre="exa -T"
alias tra="exa -Ta"
alias rmrf="rm -rfi"
alias xx="chmod +x"

function install_bottom() {
    case "$(uname -m)" in
    "aarch64")
        curl -LO https://github.com/ClementTsang/bottom/releases/download/0.9.6/bottom_0.9.6_arm64.deb
        dpkg -i bottom_0.9.6_arm64.deb
        rm bottom_0.9.6_arm64.deb
        ;;
    "x86_64")
        curl -LO https://github.com/ClementTsang/bottom/releases/download/0.9.6/bottom_0.9.6_amd64.deb
        dpkg -i bottom_0.9.6_amd64.deb
        rm bottom_0.9.6_amd64.deb
        ;;
    *)
        echo "not supported"
        exit 1
        ;;
    esac
}

alias btm="( btm -h >/dev/null || install_bottom ) && btm"

function install_watchexec() {
    curl -fsSL https://apt.cli.rs/pubkey.asc | tee -a /usr/share/keyrings/rust-tools.asc
    curl -fsSL https://apt.cli.rs/rust-tools.list | tee /etc/apt/sources.list.d/rust-tools.list
    apt update
    apt install -y watchexec-cli
}

alias watchexec="( watchexec -h >/dev/null || install_watchexec ) && watchexec --poll 100"

function reset-dotfiles() {
    rm "${workspace_dir}"/.vscode/remote-settings.json "${workspace_dir}"/.devcontainer/.bashrc
    rm -rf "${dotfiles_dir}"
}

function jsonc2json() {
    input=$1
    output=$2
    temp="temp.json"
    temp2="temp2.json"
    oldline=""

    while IFS= read -r newline; do
        echo "newline : $newline"
        echo "oldline : $oldline"
        echo ""
        if echo "$newline" | grep -q "\s*//"; then
            echo "$newline"
            continue
        fi
        if (echo "$oldline" | grep -q ",$" && echo "$newline" | grep -q "\s*}"); then
            echo "${oldline//,/}" >>$temp
        else
            echo "$oldline" >>$temp
        fi

        oldline=$newline
    done <"$input"

    echo "${oldline}" >>$temp
    sed '1d' $temp >$temp2
    cp -f $temp2 "$output"
    rm -r $temp $temp2
}

alias yq="( yq -h >/dev/null || apt install -y yq ) && yq"
