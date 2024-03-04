update servers config
=========
- Modify servers password complexity.<br>
- Regular modification policies.<br>
- Implement login failure handling function.<br>
- Automatic exit after connection timeout.<br>
- Clear remaining information.

Requirements
--------------

1. Set your role directory
   ```bash
   update-servers
   ├── tasks
   │     └── main.yml
   └── templates
         ├── login.defs_template.j2
         ├── profile_template.j2
         ├── sshd_template.j2
         └── system_auth_template.j2
   ```

  2. Set up host manifest file( The hosts file below )
     ```bash
     ansible
      ├── hosts
     ```

     ```ini
     [updateservers]
     skylark.wuhou-cyzx.jet.worker
     backend.wuhou-cyzx.jet.worker
     kafka.wuhou-cyzx.jet.worker
     ```


Example Playbook
----------------

An example of how to use your role：
```yml
---
  - name: 更新服务器配置
    hosts:  updateservers
    remote_user: root
    roles:
      - update-server
```
