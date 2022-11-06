# Hardening a Server
Repository with Ansible playbook to harden a server.

[![Hardening](https://github.com/Kaputt4/hardening_server/actions/workflows/hardening.yml/badge.svg)](https://github.com/Kaputt4/hardening_server/actions/workflows/hardening.yml)

Changes are produced with a GitHub action that has to be manually triggered from [`actions`](https://github.com/Kaputt4/hardening_server/actions) tab.

* SSH key to allow Ansible establish connection with the host must be defined as a GitHub repository secret with name `ANSIBLE_KEY`.
* CrowdSec console enrollment key must be defined as a GitHub repository secret with name `CONSOLE_KEY`.
* CrowdSec dashboard login password must be defined as a GitHub repository secret with name `DASHBOARD_PASSWORD`.

> Remember to set the IP address of the host and the CrowdSec console machine name when manually triggering the GitHub action.

> CrowdSec dashboard will be __accesible globally from any IP address (0.0.0.0)__. Remember to properly limit the exposure surface.

### TODO list

- [ ] Use `community.general.docker_container_info` module in `tasks/setup_dashboard.yml`. More info in [https://docs.ansible.com/ansible/latest/collections/community/docker/docker_container_info_module.html#ansible-collections-community-docker-docker-container-info-module](https://docs.ansible.com/ansible/latest/collections/community/docker/docker_container_info_module.html#ansible-collections-community-docker-docker-container-info-module).

- [ ] Expect module is not working in `tasks/setup_dashboard.yml` even after `pip3 install docker`, so dashboard is not started.