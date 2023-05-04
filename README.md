# openvpn-as
`openvpn-as`主要是对`openvpn`进行`docker`封装，方便部署使用

## 用途
一般我们个人开发者在云服务器厂商买了一台服务器，一般只会暴露`443`和`80`端口。诸如后台管理页面，数据库，`redis`等服务等就不太方便连接了。
为了方便管理，需要部署一个`VPN`服务，这样通过连接`VPN`就可以管理这些服务了，也增加了安全性

### 资源地址
- openvpn: https://openvpn.net/
- github：https://github.com/kylemanna/docker-openvpn
- dockerhub: https://hub.docker.com/r/kylemanna/openvpn/

## 使用说明
使用前请修改`Makefile`开头的环境变量为实际值
```bash
export OPENVPN_CONTAINER_NAME=openvpn
export OPENVPN_BASE_DIR=.
export OPENVPN_CONFIG_DIR=${OPENVPN_BASE_DIR}/config
export OPENVPN_CLIENT_DIR=${OPENVPN_BASE_DIR}/client
export OPENVPN_SERVERNAME=ssl.example.com
export OPENVPN_COMPOSE_FILE=docker-compose.yaml
export OPENVPN_IMAGE_NAME=kylemanna/openvpn
export OPENVPN_EXPOSE_PORT=8888
```

以下命令需要再当前目录下执行
### 1.初始化
> 只在openvpn部署时执行一次
```bash
make init
```
> 这执行这一步会提示输入整数密码和服务器名称
> 例如：密码就写`123456`，服务器名称：`ssl.example.com`

### 2. 启动openvpn
```bash
make up
```

### 3. 生成客户端证书
> 执行以下命令会在当前目录的`client`目录中找到`test1.ovpn`文件

```bash
make gen-client client_name=test1
```

#### 4. 修改客户端配置文件
> 需要修改下面这行中的`16888`为实际值
> 也就是跟`export OPENVPN_EXPOSE_PORT=16888`保持一致
```text
remote xxxxxxx 16888 udp
```

## 其他命令
### 停止opnvpn
```bash
make down
```

### 查看日志
```bash
make logs
```

### 删除客户端配置
```bash
make del-client client_name=test1
```

### 清楚整个openvpn
```bash
make clean
```

### 进入容器
```bash
make exec
```













