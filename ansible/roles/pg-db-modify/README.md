pg-db-modify
=========
- Enable SSL encrypted connection to the database and Open related logs
- Strengthen the password policy of the database.
- Strengthen the requirements for user password length and complexity to reduce the risk of password guessing and unauthorized access.
- Take necessary security measures for login failures, such as automatically logging out when idle.


Requirements
------------
1. Set your role directory
   ```bash
    ansible
    ├── host_vars
    │   └── hostname.yml
    ├── hosts
    └── roles
        ├── pg-db-modify
        │   ├── files
        │   │   ├── server.crt
        │   │   └── server.key
        │   ├── tasks
        │   │   └── main.yml
        │   ├── templates
                └── postgresql.conf.j2

   ```
2. Set up host manifest file( The hosts file below )
   ```bash
       ansible
        ├── host_vars
        │   └── hostname.yml
        └── hosts
   ```
   ```yml
    skylark.wuhou-cyzx.jet.worker
    backend.wuhou-cyzx.jet.worker
    kafka.wuhou-cyzx.jet.worker
   ```

Role Variables
--------------
1.host variable file<br>
- `/etc/ansible/host_vars/hostname.yml`
    - When use the host variable,you should modify the host variable file name  to  correspond to the hostname`.yml`  formats


2.variable name
- `pg_conf_file`:PostgreSQL database configuration file path
- `ssl_cert_position`:ssl certificate storage path
- `postgresql_resource_set`:Resource limits required by PostgreSQL database service



Example Playbook
----------------
An example of how to use your role：
```bash
# hosts值应修改为对应要操作主机名
---
  - name:  Modify PostgreSQL database configuration
    hosts: hostname
    remote_user: root
    roles:
      - pg-db-modify
```
