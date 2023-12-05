#! /bin/bash

function hotreload_bashrc() {
    rm "${workspace_dir}"/.devcontainer/.bashrc ~/.bashrc
    ln -sf ~/.bashrc "${workspace_dir}"/.devcontainer/.bashrc
    cat "${dotfiles_dir}"/bashrcs/* >>~/.bashrc
    cat "${workspace_dir}"/.devcontainer/additional.bashrc >>~/.bashrc
    source ~/.bashrc
    echo "Reloaded .bashrc"
}

function hr() {
    watchexec \
        -w "${workspace_dir}"/.devcontainer/additional.bashrc \
        -w "${dotfiles_dir}"/bashrcs \
        "bash -c 'source ~/.bashrc && hotreload_bashrc'"
}
