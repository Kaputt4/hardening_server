# Hardening a Server

Repository with Ansible playbook to harden a server.

[![Hardening](https://github.com/Kaputt4/hardening_server/actions/workflows/hardening.yml/badge.svg)](https://github.com/Kaputt4/hardening_server/actions/workflows/hardening.yml) [![Ansible Lint](https://github.com/Kaputt4/hardening_server/actions/workflows/lint.yml/badge.svg)](https://github.com/Kaputt4/hardening_server/actions/workflows/lint.yml) [![dependabot badge](https://badgen.net/github/dependabot/Kaputt4/hardening_server?icon=dependabot)](https://github.com/Kaputt4/hardening_server/network/updates)

## Roles

Currently, the repository contains two Ansible roles: `crowdsec` and `hardening`.

Changes are produced with a GitHub action named `hardening` that has to be manually triggered from [`actions`](https://github.com/Kaputt4/hardening_server/actions/workflows/hardening.yml) tab.

### `crowdsec` role

Role `crowdsec` performs the following actions:

- Install [CrowdSec agent](https://docs.docker.com/engine/install/).
- Install [`crowdsec-firewall-bouncer-iptables` bouncer](https://docs.crowdsec.net/docs/getting_started/install_crowdsec/#install-a-bouncer).
- Enroll server to [CrowdSec console](https://docs.crowdsec.net/docs/cscli/cscli_console_enroll/).
- Install [Docker Engine](https://docs.docker.com/engine/install/), as it is required for CrowdSec dashboard.
- Setup CrowdSec dashboard, deployed with [Metabase](https://www.metabase.com/) and make it globally reachable.

### `hardening` role

Role `hardening` performs the following actions:

- Upgrade the system using `apt`, `yum` or `dnf`.
- Configure kernel parameters using `sysctl`.
- Install and setup auditd service.
- Install and setup firewalld service and change zone to `dmz`, which is identic to `public` (default) but only allows `SSH` service, removing access to `cockpit` and `dhcpv6-client`, which are allowed by `public` zone.
- Install and setup SELinux enforcing mode.
- Change users configuration:
  - Expire `nobody`/`nfsnobody` user password.
  - Change `nobody`/`nfsnobody` and `sudo` account expiration.
  - Change `root` user password for value in `ROOT_PASSWORD` repository secret (see details in [Requirements](##requirements) section).
  - Limit `/home/user` permissions.
  - Alert of users without passwords.
  - Alert of users with UID 0 that are not `root` user.
  - Disable enabled users that are not in [`root`, `ubuntu`, `centos`, `ec2-user`, `halt`, `shutdown`, <<`current_user`>>].

Audit logs can be seen in `audit.log` file with the following command:

```sh
tail -f /var/log/audit/audit.log
```

> `audit.rules.j2` template file has been obtained from [Neo23x0/auditd repository](https://github.com/Neo23x0/auditd) and used as is, which keeps a large collection of auditd rules applicable to a very wide scope of machines, published under Apacje License 2.0. Refer to that repository for further information.

## Requirements

### GitHub repository secrets

Some __GitHub repository secrets__ must be present in order for the GitHub `hardening` action to work:

- SSH key to allow Ansible establish connection with the host must be defined with name `ANSIBLE_KEY`.
- CrowdSec console enrollment key must be defined with name `CONSOLE_KEY`.
- CrowdSec dashboard login password must be defined with name `DASHBOARD_PASSWORD`.
- System `root` user password must be defined with name `ROOT_PASSWORD`.

The secrets tab should look like follows:

<img src="https://user-images.githubusercontent.com/73181608/200427461-7fcd30dd-d6b4-4647-8aa7-eced20221166.png" width="70%">

### GitHub `hardening` action inputs

Some __string inputs__ are required when manually triggering the `hardening` action:

- Server public IP Address for SSH connection
- Server name for displaying in CrowdSec Console
- SSH username
- Run `crowdsec` role checkbox: this value is embedded in [vars/main.yml](ansible/vars/main.yml) when running the `hardening` action. However, a default `true` value is also defined in [defaults/main.yml](ansible/defaults/main.yml).
- Run `hardening` role checkbox: this value is embedded in [vars/main.yml](ansible/vars/main.yml) when running the `hardening` action. However, a default `true` value is also defined in [defaults/main.yml](ansible/defaults/main.yml).
- _The workflow branch must be `main` in order for the workflow to run. It cannot be changed._

<img src="https://user-images.githubusercontent.com/73181608/200428209-413255e6-3a46-4e43-b95c-18775c09103f.png" width="25%">


> :warning: CrowdSec dashboard will be __globally reachable from any IP address (0.0.0.0)__. Remember to properly limit the exposure surface.

## Supported Operating Systems

- Debian/Ubuntu
- EL/CentOS 7
- EL/CentOS 8
- EL/CentOS 9
- Amazon Linux

## Tested Operating Systems (so far)

| OS version                               | Platform                  | Status             |
|------------------------------------------|---------------------------|--------------------|
| Ubuntu Desktop 22.04 LTS Jammy Jellyfish | Desktop                   | :white_check_mark: |
| Ubuntu Server 22.04 LTS Jammy Jellyfish  | AWS ami-0efda064d1b5e46a5 | :white_check_mark: |
| CentOS 7 x86_64                          | AWS ami-08998a9a61da37c77 | :white_check_mark: |
| CentOS Stream 8 x86_64                   | AWS ami-05eaebdafff627949 | :white_check_mark: |
| CentOS Stream 9 x86_64                   | AWS ami-0269dcaea2eafc196 | :white_check_mark: |
| Amazon Linux 2 Kernel 5.10               | AWS ami-05c42683296709b61 | :white_check_mark: |

## TODO list

- [X] Having problems with Ansible `yum-repository` module while downloading repo files in task [docker_el.yml](ansible/roles/crowdsec/tasks/docker_el.yml) (lines 26-38). It has been replaced with `get_url` module.

- [ ] Check if server has already been enrolled in CrowdSec console, to avoid forcing it to re-enroll in task [main.yml](ansible/roles/crowdsec/tasks/main.yml) (lines 49-52). It doesn't seem to work with file `/etc/crowdsec/console.yaml`.

- [ ] Use `community.general.docker_container_info` module in [`tasks/setup_dashboard.yml`](ansible/roles/crowdsec/tasks/setup_dashboard.yml). More info in [`docker_container_info` module docs](https://docs.ansible.com/ansible/latest/collections/community/docker/docker_container_info_module.html#ansible-collections-community-docker-docker-container-info-module).

- [X] Fix docker repo problem that prevents `docker-ce` from being installed in EL/CentOS 7 and Amazon Linux. The issue is being discussed on [Docker Forum](https://forums.docker.com/t/docker-ce-stable-x86-64-repo-not-available-https-error-404-not-found-https-download-docker-com-linux-centos-7server-x86-64-stable-repodata-repomd-xml/98965/6) and [GitHub](https://github.com/docker/for-linux/issues/1111). [Public workarounds](https://forums.docker.com/t/docker-ce-stable-x86-64-repo-not-available-https-error-404-not-found-https-download-docker-com-linux-centos-7server-x86-64-stable-repodata-repomd-xml/98965) didn't work either. This has been fixed installing `docker` package instead of `docker-ce`, despite what [Docker Docs](https://docs.docker.com/engine/install/centos/) suggest.
