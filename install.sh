#! /bin/bash
cd ..

# dotfiles for devcontainer, bash
workspace_dir=$(ls -d /workspaces/*)
dotfiles_dir="${workspace_dir}/dotfiles"
apt update
apt install -y git exa curl jq

# remote container settingsのリンクを作成
touch ~/.vscode-server/data/Machine/settings.json
cp "${dotfiles_dir}"/.vscode/settings.json ~/.vscode-server/data/Machine/settings.json
mkdir -p "${workspace_dir}"/.vscode
ln -sf ~/.vscode-server/data/Machine/settings.json "${workspace_dir}"/.vscode/remote-settings.json
cp -n "${dotfiles_dir}"/.vscode/extensions.json "${workspace_dir}"/.vscode/extensions.json

rm -r "${workspace_dir}"/.devcontainer/.config

# git-promptのダウンロード
curl -o ~/.git-prompt.sh \
    https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
# [bashrc] source ~/.git-prompt.sh

curl -o ~/.git-completion.sh \
    https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
# [bashrc] source ~/.git-completion.sh

# gitの設定
cp -n "${dotfiles_dir}"/.env.template "${workspace_dir}"/.env
source "${workspace_dir}"/.env
git config --global user.name "${GIT_USER_NAME}"
git config --global user.email "${GIT_USER_EMAIL}"

# .bashrcのリンクを作成
rm "${workspace_dir}"/.devcontainer/.bashrc ~/.bashrc
ln -sf ~/.bashrc "${workspace_dir}"/.devcontainer/.bashrc

cat "${dotfiles_dir}"/bashrcs/* >>~/.bashrc

if ! test -f "${workspace_dir}"/.devcontainer/additional.bashrc; then
    echo "#! /bin/bash" >>"${workspace_dir}"/.devcontainer/additional.bashrc
fi

cat "${workspace_dir}"/.devcontainer/additional.bashrc >>~/.bashrc

source ~/.bashrc

go help >/dev/null && install_go_tools

# .gitignoreでdotfilesを無視
if ! test -f "${workspace_dir}"/.gitignore; then
    cat "${dotfiles_dir}"/.gitignore.init >>"${workspace_dir}"/.gitignore
fi

# 作業用ディレクトリの作成
mkdir -p "${workspace_dir}"/project
