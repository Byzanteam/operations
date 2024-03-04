Separation of permissions
=========
According to user roles and responsibilities, grant each user the minimum permissions required for their job responsibilities, and realize the separation of three powers (system administrator, security administrator, and audit administrator)

Requirements
------------
1. Set your role directory

   ```bash
   separate-permissions
    ├── tasks
    │   └── main.yml
    └── vars
         └── main.yml
   ```
2. Set up host manifest file( The hosts file below )
   ```bash
    ansible
      └──hosts
   ```
   ```ini
   [permissions]
   skylark.wuhou-cyzx.jet.worker
   backend.wuhou-cyzx.jet.worker
   kafka.wuhou-cyzx.jet.worker
   ```

Role Variables
--------------

1.variable file
- `separate-permissions/vars/main.yml`<br>
     The variable file is encrypted by ansible-vault, When you execute the playbook, you need to use the --ask-vault-pass parameter and enter the file encryption password（encryption password：1234）
  
  ```bash
  #查看加密文件（需要输入文件的加密密码）
      ansible-vault view main.yml
  
  #解密文件（需要输入文件的加密密码），解密之后，你可以根据需要修改用户密码！
      ansible-vault decrypt main.yml 
  ```


2.variable name
- `sysadm_pass`      :system administrator password
- `audit_adm_pass`      :audit administrator password
- `secadm_pass`      : security administrator password



Example Playbook
----------------
An example of how to use your role：
```yml
---
  - name:  realize the separation of three powers
    hosts: permissions 
    remote_user: root
    roles:
      - separate-permissions
```
