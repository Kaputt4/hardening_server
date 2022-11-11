# Ansible `crowdsec` role

This role is related to [CrowdSec](https://www.crowdsec.net/), an open-source Intrusion Prevention System (IPS) that protects online services by acting upon threats.

Role `crowdsec` performs the following actions:

- Install [CrowdSec agent](https://docs.docker.com/engine/install/).
- Install [`crowdsec-firewall-bouncer-iptables` bouncer](https://docs.crowdsec.net/docs/getting_started/install_crowdsec/#install-a-bouncer).

- Install [`base-http-scenarios` collection](https://hub.crowdsec.net/author/crowdsecurity/collections/base-http-scenarios).
- Install [`http-cve` collection](https://hub.crowdsec.net/author/crowdsecurity/collections/http-cve).
- Install [`whitelist-good-actors` collection](https://hub.crowdsec.net/author/crowdsecurity/collections/whitelist-good-actors).
- Install [`apache2` collection](https://hub.crowdsec.net/author/crowdsecurity/collections/apache2).
- Install [`nginx` collection](https://hub.crowdsec.net/author/crowdsecurity/collections/nginx).
- Install [`smb` collection](https://hub.crowdsec.net/author/crowdsecurity/collections/smb).
- Install [`linux-lpe` collection](https://hub.crowdsec.net/author/crowdsecurity/collections/linux-lpe).
- Install [`mail-generic-bf` scenario](https://hub.crowdsec.net/author/hitech95/configurations/mail-generic-bf).
- Enroll server to [CrowdSec console](https://docs.crowdsec.net/docs/cscli/cscli_console_enroll/).
- Install [Docker Engine](https://docs.docker.com/engine/install/), as it is required for CrowdSec dashboard.
- Setup CrowdSec dashboard, deployed with [Metabase](https://www.metabase.com/) and make it globally reachable.

These are some useful CrowdSec commands. You can see [cscli](https://docs.crowdsec.net/docs/cscli/cscli/) docs for more information.

```console
# Check CrowdSec logs
tail -f /var/log/crowdsec.log

# List decisions and alerts
cscli decisions list
cscli alerts list

# List CrowdSec metrics
cscli metrics

# List installed parsers, collections, scenarios and postoverflows
cscli hub list
```

<br>

> :warning: __WARNING__: CrowdSec dashboard will be __globally reachable from any IP address (0.0.0.0)__. Remember to properly limit the exposure surface.
