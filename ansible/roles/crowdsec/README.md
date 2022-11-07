# Ansible `crowdsec` role

This Ansible role performs the following actions in order to install and setup CrowdSec:

- Install [CrowdSec agent](https://docs.docker.com/engine/install/).
- Install [`crowdsec-firewall-bouncer-iptables` bouncer](https://docs.crowdsec.net/docs/getting_started/install_crowdsec/#install-a-bouncer).
- Enroll server to [CrowdSec console](https://docs.crowdsec.net/docs/cscli/cscli_console_enroll/).
- Install [Docker Engine](https://docs.docker.com/engine/install/), as it is required for CrowdSec dashboard.
- Setup CrowdSec dashboard, deployed with [Metabase](https://www.metabase.com/) and make it globally reachable.