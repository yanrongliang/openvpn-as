export OPENVPN_CONTAINER_NAME=openvpn
export OPENVPN_BASE_DIR=.
export OPENVPN_CONFIG_DIR=${OPENVPN_BASE_DIR}/config
export OPENVPN_CLIENT_DIR=${OPENVPN_BASE_DIR}/client
export OPENVPN_SERVERNAME=ssl.example.com
export OPENVPN_COMPOSE_FILE=docker-compose.yaml
export OPENVPN_IMAGE_NAME=kylemanna/openvpn
export OPENVPN_EXPOSE_PORT=8888

.PHONY: init up down logs exec gen-client del-client

# 准备工作 仅第一次部署时使用
init: 
	mkdir -p $(OPENVPN_CONFIG_DIR) $(OPENVPN_CLIENT_DIR)
	docker run -v ${OPENVPN_CONFIG_DIR}:/etc/openvpn --rm ${OPENVPN_IMAGE_NAME} ovpn_genconfig -u udp://${OPENVPN_SERVERNAME}
	docker run -v ${OPENVPN_CONFIG_DIR}:/etc/openvpn --rm -it ${OPENVPN_IMAGE_NAME} ovpn_initpki 

# 启动容器
up:
	docker compose -p ${OPENVPN_CONTAINER_NAME} -f ${OPENVPN_COMPOSE_FILE} up -d

# 停止容器
down:
	docker compose -p ${OPENVPN_CONTAINER_NAME} -f ${OPENVPN_COMPOSE_FILE} down

# 查看容器日志
logs:
	docker compose -f ${OPENVPN_COMPOSE_FILE} logs -f ${OPENVPN_CONTAINER_NAME}

# 进入容器
exec:
	docker exec -it ${OPENVPN_CONTAINER_NAME} sh

# 删除容器和数据目录
clean:
	docker compose -p ${OPENVPN_CONTAINER_NAME} -f ${OPENVPN_COMPOSE_FILE} down -v
	rm -rf ${OPENVPN_CONFIG_DIR} ${OPENVPN_CLIENT_DIR}
	unset OPENVPN_CONTAINER_NAME OPENVPN_BASE_DIR OPENVPN_CONFIG_DIR OPENVPN_CLIENT_DIR OPENVPN_SERVERNAME OPENVPN_COMPOSE_FILE OPENVPN_IMAGE_NAME OPENVPN_EXPOSE_PORT

# 生成客户端证书
gen-client:
	docker run -v ${OPENVPN_CONFIG_DIR}:/etc/openvpn --rm -it ${OPENVPN_IMAGE_NAME} easyrsa build-client-full $(client_name) nopass; \
	docker run -v ${OPENVPN_CONFIG_DIR}:/etc/openvpn --rm ${OPENVPN_IMAGE_NAME} ovpn_getclient $(client_name) > ${OPENVPN_CLIENT_DIR}/${client_name}.ovpn

# 删除客户端证书
del-client:
	docker run -v ${OPENVPN_CONFIG_DIR}:/etc/openvpn --rm -it ${OPENVPN_IMAGE_NAME} ovpn_revokeclient $(client_name); \
	rm -f ${OPENVPN_CLIENT_DIR}/$(client_name).ovpn

