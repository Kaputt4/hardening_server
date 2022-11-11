# Ansible `hardening` role

This role develops some common hardening tasks that are recommended to carry out in Linux servers or desktop machines.

Role `hardening` performs the following actions:

- Upgrade the system using `apt`, `yum` or `dnf`.
- Remove all permissions for _group_ and _others_ of `cron` files.
- Minimize permissions of special files such as `/etc/passwd`, `/etc/passwd` and `/bin/su`.
- Configure kernel parameters using `sysctl`.
- Install and setup auditd service.
- Install and setup firewalld service and change zone to `dmz`, which is identic to `public` (default) but __only allows `SSH` service__, removing access to `cockpit` and `dhcpv6-client`, which are allowed by `public` zone.
- Install and setup SELinux enforcing mode.
- Change users configuration:
  - Expire `nobody`/`nfsnobody` user password.
  - Change `nobody`/`nfsnobody` and `sudo` account expiration.
  - Change `root` user password for value in `ROOT_PASSWORD` repository secret (see details in [Requirements](##requirements) section).
  - Limit `/home/user` permissions.
  - Alert of users without passwords.
  - Alert of users with UID 0 that are not `root` user.
  - Disable enabled users that are not in [`root`, `ubuntu`, `centos`, `ec2-user`, `halt`, `shutdown`, <<`current_user`>>], being <<`current_user`>> the user that is used for the SSH connection.

<br>

It's recommended that `cron` jobs, stored in `/etc` directory, are manually checked to ensure that no strange job is defined, because it could allow a malicious user to gain elevated privileges. The following files should be checked:

```
/
└── etc
    ├── cron.hourly
    ├── cron.daily
    ├── cron.weekly
    ├── cron.monthly
    ├── cron.d
    └── crontab
```

<br>

Audit logs can be seen in `audit.log` file with the following command:

```console
tail -f /var/log/audit/audit.log
```

<br>

> :clap: __Attribution__: `audit.rules.j2` template file has been obtained from [Neo23x0/auditd repository](https://github.com/Neo23x0/auditd) and used as is. It keeps a large collection of auditd rules applicable to a very wide scope of machines, published under Apache License 2.0. Refer to that repository for further information.
