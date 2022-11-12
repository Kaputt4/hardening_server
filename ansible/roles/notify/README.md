# Ansible `notify` role

This role creates some services that monitor important logs and alert using a Telegram bot.

Role `notify` performs the following actions:

- Install `curl` & `inotify-tools` packages.
- Deploy the scripts that will run in the server, monitor de log files and send requests to the Telegram API.
  - This scripts will be deployed in `/tmp/***_notify.sh`.
- Create one service per script, that will ensure that the scripts are run on each boot.
  - This services will be deployed in `/lib/systemd/system/***_notify.service`.