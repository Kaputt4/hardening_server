# Ansible `hardening` role

This Ansible role performs the following actions in order to harden a server:

- Upgrade the system using `apt`, `yum` or `dnf`.
- Configure kernel parameters using `sysctl`.
- Install and setup auditd service.
- Install and setup firewalld service and change zone to `dmz`, which is identic to `public` (default) but only allows `SSH` service, removing access to `cockpit` and `dhcpv6-client`, which are allowed by `public` zone.
- Install and setup SELinux enforcing mode.
- Change users configuration:
  - Expire `nobody`/`nfsnobody` user password.
  - Change `nobody`/`nfsnobody` and `sudo` account expiration.
  - Change `root` user password for value in `ROOT_PASSWORD` repository secret (see details in the [Requirements](https://github.com/Kaputt4/hardening_server/blob/main/README.md#Requirements) section of the repository `README.md`).
  - Limit `/home/user` permissions.
  - Alert of users without passwords.
  - Alert of users with UID 0 that are not `root` user.
  - Disable enabled users that are not in [`root`, `ubuntu`, `centos`, `ec2-user`, `halt`, `shutdown`, <<`current_user`>>].

Audit logs can be seen in `audit.log` file with the following command:

```sh
tail -f /var/log/audit/audit.log
```

> `audit.rules.j2` template file has been obtained from [Neo23x0/auditd repository](https://github.com/Neo23x0/auditd) and used as is, which keeps a large collection of auditd rules applicable to a very wide scope of machines, published under Apacje License 2.0. Refer to that repository for further information.
