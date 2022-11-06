# Hardening a Server
Repository with Ansible playbook to harden a server.

Changes are produced with a GitHub action that has to be manually triggered from [`actions`](https://github.com/Kaputt4/hardening_server/actions) tab.

* SSH key to allow Ansible establish connection with the host must be defined as a GitHub repository secret with name `ANSIBLE_KEY`.
* CrowdSec console enrollment key must be defined as a GitHub repository secret with name `CONSOLE_KEY`.
* Remember to set the IP address of the host and the CrowdSec console machine name when manually triggering the GitHub action.