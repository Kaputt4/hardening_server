# Hardening a Server
Repository with Ansible playbook to harden a server.

[![Hardening](https://github.com/Kaputt4/hardening_server/actions/workflows/hardening.yml/badge.svg)](https://github.com/Kaputt4/hardening_server/actions/workflows/hardening.yml) [![dependabot badge](https://badgen.net/github/dependabot/Kaputt4/hardening_server?icon=dependabot)](https://github.com/Kaputt4/hardening_server/network/updates)

Currently, the repository only contains one Ansible role named `crowdsec` that performs the following actions:

- Install [CrowdSec agent](https://docs.docker.com/engine/install/).
- Install [`crowdsec-firewall-bouncer-iptables` bouncer](https://docs.crowdsec.net/docs/getting_started/install_crowdsec/#install-a-bouncer).
- Enroll server to [CrowdSec console](https://docs.crowdsec.net/docs/cscli/cscli_console_enroll/).
- Install [Docker Engine](https://docs.docker.com/engine/install/), as it is required for CrowdSec dashboard.
- Setup CrowdSec dashboard, deployed with [Metabase](https://www.metabase.com/) and make it globally reachable.

Changes are produced with a GitHub action that has to be manually triggered from [`actions`](https://github.com/Kaputt4/hardening_server/actions) tab.

## Requirements

Some __GitHub repository secrets__ must be present in order for the GitHub action to work:

- SSH key to allow Ansible establish connection with the host must be defined with name `ANSIBLE_KEY`.
- CrowdSec console enrollment key must be defined with name `CONSOLE_KEY`.
- CrowdSec dashboard login password must be defined with name `DASHBOARD_PASSWORD`.

Some __inputs__ are required when manually triggering the action:

- Server public IP Address
- Server name for CrowdSec Console
- SSH username

> :warning: CrowdSec dashboard will be __globally reachable from any IP address (0.0.0.0)__. Remember to properly limit the exposure surface.

## Supported Operating Systems

- Debian/Ubuntu
- EL/CentOS 7
- EL/CentOS 8
- Amazon Linux

## Tested Operating Systems (so far)

- [X] Ubuntu Desktop 22.04 LTS Jammy Jellyfish :white_check_mark:
- [X] Ubuntu Server 22.04 LTS Jammy Jellyfish (AWS ami-0efda064d1b5e46a5) :white_check_mark:
- [X] CentOS 7 x86_64 (AWS ami-08998a9a61da37c77) :x: 
  - Fails to install `docker-ce` due to a problem with docker repo. [Public workarounds](https://forums.docker.com/t/docker-ce-stable-x86-64-repo-not-available-https-error-404-not-found-https-download-docker-com-linux-centos-7server-x86-64-stable-repodata-repomd-xml/98965) didn't work either. For this reason, `setup_dashboard.yml` task is only run when OS is Debian, Ubuntu or EL/CentOS 8.
- [ ] CentOS 8
- [ ] Amazon Linux 2

## TODO list

- [ ] Use `community.general.docker_container_info` module in [`tasks/setup_dashboard.yml`](ansible/roles/crowdsec/tasks/setup_dashboard.yml). More info in [https://docs.ansible.com/ansible/latest/collections/community/docker/docker_container_info_module.html#ansible-collections-community-docker-docker-container-info-module](https://docs.ansible.com/ansible/latest/collections/community/docker/docker_container_info_module.html#ansible-collections-community-docker-docker-container-info-module).
