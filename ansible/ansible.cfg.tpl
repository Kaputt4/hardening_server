[defaults]
remote_user = ${SSH_USER}
private_key_file = ./config/ansible.key
host_key_checking = False
roles_path = ./roles

[ssh_connection]
control_path = %(directory)s/%%r@%%h:%%p