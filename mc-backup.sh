#!/bin/bash

_author="cedroid09"
_desc="Automatic Minecraft backup script"
_version="1.0"

repo_path="/your/cloned/git/repo/path" #Path to your git repo
game_path="/opt/sw/games/minecraft/" #Path to your minecraft Installation
rem_repo="github.com/<username|organisation>/<your_repo>.git" #Git remote repo url
date="$(date)"

#Git authentication
git_usr="your_username" 
git_pwd="your_gittoken"
config_list="config_backup.txt" #Additional files to backup

# Check prerequisite

check_git="$(which git 2>>/dev/null; echo $?)"

if [[ $check_git == 1 ]]
then
        echo "[error] Git not install, please install git first"
        exit 1

fi

# Backup minecraft world

update_world () {

        echo "[info] Deleting old local files..."

        if [[ "$(rm -rf ${repo_path}/world 2>>/dev/null; echo $?)" == 0 ]]
        then
                echo "[info] Copying files to local repo..."
                if [[ "$(cp -r ${game_path}/world ${repo_path} 2>>/dev/null; echo $?)" == 0 ]]
                then
                        echo "[info] Local repo updated."
                else
                        echo "[error] Failed to updated local repo, exiting..."
                        exit 1
                fi
        fi

        return 0
}

# Backup all files in - config_list -

update_conf () {

        echo "[info] Saving configuration files..."

        if [[ -d "${repo_path}/configuration" ]]
        then
                if [[ "$(rm -rf ${repo_path}/configuration 2>>/dev/null; echo $?)" == 1 ]]
                then
                        echo "[error] Failed to update settings"
                        exit 1
                fi
        fi

        create_conf_dir="$(mkdir ${repo_path}/configuration 2>>/dev/null; echo $?)"
        if [[ $create_conf_dir == 1 ]]
        then
                echo "[error] Failed to update settings"
                exit 1
        fi

        for _file in `cat $config_list`; do
                if [[ "$(cp ${game_path}/${_file} ${repo_path}/configuration 2>>/dev/null; echo $?)" == 0 ]]
                then
                        echo "[info] Copied file: $game_path/$_file"
                else
                        echo "[error] Failed to copy: $game_path/$_file"
                fi
        done

        return 1

}

# Commit & push all changes to remote git repo

update_repo () {

        echo "[info] Updating remote repo at: ${rem_repo}"
        cd ${repo_path}
        update_repo="$(git add -A 2>>/dev/null; echo $?)"

        if [[ $update_repo == 0 ]]
        then
                echo "[info] Commiting changes..."
                commit="$(git commit -m "feat: auto-backup, $date" 2>>/dev/null; echo $?)"

                if [[ $commit == 1 ]]
                then
                        echo "[error] Commit failed, exiting..."
                        exit 1
                fi

                echo "[info] Uploading files..."
                upload="$(git push https://${git_usr}:${git_pwd}@${rem_repo} --all 2>>/dev/null; echo $?)"

                if [[ $upload == 1 ]]
                then
                        echo "[error] Upload failed..."
                        exit 1
                else
                        echo "[info] Backup successful"
                fi
        fi

        return 0
}


# Start all actions

echo "[info] Starting operations..."

update_world
update_conf
update_repo

