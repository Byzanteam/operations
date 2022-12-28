> 若需要更改警报阈值，请设置 `critical` 变量：
> 
> `curl -fsSL <URL> | critical='' webhook='' tag='' sh -`

## 1. 使用以下命令部署硬盘监控报警脚本，`webhook` 在飞书中获取 bot 的 webhook 链接
```bash
curl -fsSL https://raw.githubusercontent.com/Byzanteam/operations/main/disk_check/install.sh | webhook='' tag='' sh -
```

## 2. 使用以下命令卸载硬盘监控报警脚本
```bash
curl -fsSL https://raw.githubusercontent.com/Byzanteam/operations/main/disk_check/install.sh | deploy=uninstall sh -
```
