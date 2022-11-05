# Hardening a Server
Repository with Ansible playbook to harden a server.

Changes are produced with a GitHub action that has to be manually triggered from [`actions`](actions/) directory.

SSH key to allow Ansible establish connection with the host must be defined as a GitHub repository secret with name `ANSIBLE_KEY`.
Remember to set the IP address of the host when triggering the GitHub action.