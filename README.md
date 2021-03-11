# What is this?
A bash script that automatically backups your Minecraft World to github

# What you do you need?

* A minecraft server running on any Linux distribution having BASH.
* A github/gitlab account and repo
* Read and Write access token to the repo.

Learn how to create a personal Github access token [here](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)

# How to Install?
 1. Clone this repo on you Linux Minecraft server `https://github.com/cedroid09/minecraft-backup-script.git`
 Edit the following parameters with your own

 ``

    repo_path="/your/cloned/git/repo/path" #Path to your git repo
    game_path="/opt/sw/games/minecraft/" #Path to your minecraft Installation
    rem_repo="github.com/<username|organisation>/<your_repo>.git" #Git remote repo url
    date="$(date)"

    #Git authentication
    git_usr="your_username" 
    git_pwd="your_gittoken"
    config_list="config_backup.txt" #Additional files to backup
``

2. Setup a cron job to automatically run the backup at a specified interval
* Copy `minecraft.cron` to `/etc/cron.d/`
* This sets the backup to run at 4:00 A.M every day.
* Use [Crontab Guru](https://crontab.guru/) to help you update the time