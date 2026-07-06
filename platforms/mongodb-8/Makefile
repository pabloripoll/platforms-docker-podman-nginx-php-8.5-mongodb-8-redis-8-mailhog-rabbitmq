# This Makefile requires GNU Make.
MAKEFLAGS += --silent

# Settings

ifeq ($(strip $(OS)),Windows_NT) # is Windows_NT on XP, 2000, 7, Vista, 10...
	DETECTED_OS := Windows
	C_BLU=''
	C_GRN=''
	C_RED=''
	C_YEL=''
	C_END=''
else
	DETECTED_OS := $(shell uname) # same as "uname -s"
	C_BLU='\033[0;34m'
	C_GRN='\033[0;32m'
	C_RED='\033[0;31m'
	C_YEL='\033[0;33m'
	C_END='\033[0m'
endif

include ../../.env

DOCKER_PLTF="MONGODB 8+"
DOCKER_LEAD=$(PROJECT_LEAD)
DOCKER_CNET=$(PROJECT_CNET)
DOCKER_HOST=$(PROJECT_HOST)
DOCKER_IMGK=$(MONGODB_IMGK)
DOCKER_CAAS=$(MONGODB_CAAS)
DOCKER_DATA=$(MONGODB_DATA)
DOCKER_PORT=$(MONGODB_PORT)
DOCKER_CPUS=$(MONGODB_CPUS)
DOCKER_MEMO=$(MONGODB_MEMO)
DOCKER_SWAP=$(MONGODB_SWAP)
DOCKER_CLIENT_IMGK=$(MONGODB_CLIENT_IMGK)
DOCKER_CLIENT_PORT=$(MONGODB_CLIENT_PORT)
DOCKER_CLIENT_CPUS=$(MONGODB_CLIENT_CPUS)
DOCKER_CLIENT_MEMO=$(MONGODB_CLIENT_MEMO)
DOCKER_CLIENT_SWAP=$(MONGODB_CLIENT_SWAP)

ROOT_DIR=$(patsubst %/,%,$(dir $(realpath $(firstword $(MAKEFILE_LIST)))))
DIR_BASENAME=$(shell basename $(ROOT_DIR))

DOCKER_CONTAINER:=$(addsuffix -$(DOCKER_CAAS), $(DOCKER_LEAD))
DOCKER_COMPOSE_RUN=$(DOCKER_COMPOSE) run -v --rm
DOCKER_EXEC_SSH=$(DOCKER) exec -it $(DOCKER_CONTAINER) sh

# -------------------------------------------------------------------------------------------------
#  Help
# -------------------------------------------------------------------------------------------------
.PHONY: help

help: ## shows this Makefile help message
	echo "Usage: $$ make "${C_GRN}"[target]"${C_END}
	echo ${C_GRN}"Targets:"${C_END}
	awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "$$ make \033[0;33m%-30s\033[0m %s\n", $$1, $$2}' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

# -------------------------------------------------------------------------------------------------
#  System
# -------------------------------------------------------------------------------------------------
.PHONY: ports-check

ports-check: ## shows this project port availability on local machine
	echo "Checking configuration for "${C_YEL}"$(DOCKER_PLTF)"${C_END}" service:";
	if [ -z "$($(DOCKER) lsof -i :$(DOCKER_PORT))" ]; then \
		echo ${C_BLU}"$(DOCKER_PLTF)"${C_END}" > localhost:"${C_GRN}"$(DOCKER_PORT) is free to use."${C_END}; \
    else \
		echo ${C_BLU}"$(DOCKER_PLTF)"${C_END}" > localhost:"${C_RED}"$(DOCKER_PORT) is busy. Update ./.env file."${C_END}; \
	fi
	echo "Checking configuration for "${C_YEL}"$(DOCKER_PLTF) CLIENT"${C_END}" service:";
	if [ -z "$($(DOCKER) lsof -i :$(DOCKER_CLIENT_PORT))" ]; then \
		echo ${C_BLU}"$(DOCKER_PLTF) CLIENT"${C_END}" > localhost:"${C_GRN}"$(DOCKER_CLIENT_PORT) is free to use."${C_END}; \
    else \
		echo ${C_BLU}"$(DOCKER_PLTF) CLIENT"${C_END}" > localhost:"${C_RED}"$(DOCKER_CLIENT_PORT) is busy. Update ./.env file."${C_END}; \
	fi

# -------------------------------------------------------------------------------------------------
#  Environment
# -------------------------------------------------------------------------------------------------
.PHONY: env env-set

env: ## checks if docker .env file exists
	if [ -f ./docker/.env ]; then \
		echo ${C_BLU}"$(PROJECT_NAME)"${C_END}" - $(DOCKER_PLTF) "${C_YEL}"docker-compose.yml"${C_END}" .env file "${C_GRN}"is set."${C_END}; \
	else \
		echo ${C_BLU}"$(PROJECT_NAME)"${C_END}" - $(DOCKER_PLTF) "${C_YEL}"docker-compose.yml"${C_END}" .env file "${C_RED}"is not set."${C_END}" \
		Create it by executing "${C_YEL}"$$ make env-set"${C_END}; \
	fi

env-set: ## sets docker .env file
ifeq ($(DETECTED_OS), Windows)
	echo "Recipe do not support for Windows NT at this moment - You have to manually create .env file from ./docker/.env.example";
else
	echo "COMPOSE_LEAD=\"$(DOCKER_LEAD)\"\r\n\
	COMPOSE_CNET=\"$(DOCKER_CNET)\"\r\n\
	COMPOSE_IMGK=\"$(DOCKER_IMGK)\"\r\n\
	COMPOSE_NAME=\"$(DOCKER_CAAS)\"\r\n\
	COMPOSE_HOST=$(DOCKER_HOST)\r\n\
	COMPOSE_DATA=\"$(DOCKER_DATA)\"\r\n\
	COMPOSE_CPUS=$(DOCKER_CPUS)\r\n\
	COMPOSE_MEMO=$(DOCKER_MEMO)\r\n\
	COMPOSE_SWAP=$(DOCKER_SWAP)\r\n\
	COMPOSE_PORT=$(DOCKER_PORT)\r\n\
	MONGODB_INITDB_DATABASE=$(MONGODB_NAME)\r\n\
	MONGODB_INITDB_ROOT_USERNAME=$(MONGODB_USER)\r\n\
	MONGODB_INITDB_ROOT_PASSWORD=\"$(MONGODB_PASS)\"\r\n\
	COMPOSE_CLIENT_IMGK=\"$(DOCKER_CLIENT_IMGK)\"\r\n\
	COMPOSE_CLIENT_CPUS=$(DOCKER_CLIENT_CPUS)\r\n\
	COMPOSE_CLIENT_MEMO=$(DOCKER_CLIENT_MEMO)\r\n\
	COMPOSE_CLIENT_SWAP=$(DOCKER_CLIENT_SWAP)\r\n\
	COMPOSE_CLIENT_PORT=$(DOCKER_CLIENT_PORT)\r\n\
	MONGODB_EXPRESS_USERNAME=$(MONGODB_CLIENT_USER)\r\n\
	MONGODB_EXPRESS_PASSWORD=\"$(MONGODB_CLIENT_PASS)\"\r\n\
	COMPOSE_IGNORE_ORPHANS="true"" > ./docker/.env; \
	echo ${C_BLU}"$(PROJECT_NAME)"${C_END}" DOCUMENT DB "${C_YEL}$(DOCKER_PLTF)${C_END}" - "${C_YEL}"docker-compose.yml"${C_END}" .env file "${C_GRN}"has been set."${C_END};
	echo ${C_BLU}"$(PROJECT_NAME)"${C_END}" DOCUMENT DB "${C_YEL}$(DOCKER_PLTF)${C_END}" - Container name: "${C_GRN}$(DOCKER_CONTAINER)${C_END}
	echo ${C_BLU}"$(PROJECT_NAME)"${C_END}" DOCUMENT DB "${C_YEL}$(DOCKER_PLTF)${C_END}" - Container image: "${C_GRN}$(DOCKER_IMGK)${C_END}
	echo ${C_BLU}"$(PROJECT_NAME)"${C_END}" DOCUMENT DB "${C_YEL}$(DOCKER_PLTF)${C_END}" - Max. CPUs: "${C_GRN}$(DOCKER_CPUS)${C_END}
	echo ${C_BLU}"$(PROJECT_NAME)"${C_END}" DOCUMENT DB "${C_YEL}$(DOCKER_PLTF)${C_END}" - Max. memory usage: "${C_GRN}$(DOCKER_MEMO)${C_END}" - swap: "${C_GRN}$(DOCKER_SWAP)${C_END}
	echo ${C_BLU}"$(PROJECT_NAME)"${C_END}" DOCUMENT DB "${C_YEL}$(DOCKER_PLTF)${C_END}" - DB connection at: "${C_GRN}http://127.0.0.1:$(DOCKER_PORT)${C_END}
	echo ${C_BLU}"$(PROJECT_NAME)"${C_END}" DOCUMENT DB "${C_YEL}$(DOCKER_PLTF)${C_END}" CLIENT - "${C_YEL}"docker-compose.client.yml"${C_END}" .env.client file "${C_GRN}"has been set."${C_END};
	echo ${C_BLU}"$(PROJECT_NAME)"${C_END}" DOCUMENT DB "${C_YEL}$(DOCKER_PLTF)${C_END}" CLIENT - Container name: "${C_GRN}$(DOCKER_CONTAINER)-client${C_END}
	echo ${C_BLU}"$(PROJECT_NAME)"${C_END}" DOCUMENT DB "${C_YEL}$(DOCKER_PLTF)${C_END}" CLIENT - Container image: "${C_GRN}$(DOCKER_CLIENT_IMGK)${C_END}
	echo ${C_BLU}"$(PROJECT_NAME)"${C_END}" DOCUMENT DB "${C_YEL}$(DOCKER_PLTF)${C_END}" CLIENT - Max. CPUs: "${C_GRN}$(DOCKER_CLIENT_CPUS)${C_END}
	echo ${C_BLU}"$(PROJECT_NAME)"${C_END}" DOCUMENT DB "${C_YEL}$(DOCKER_PLTF)${C_END}" CLIENT - Max. memory usage: "${C_GRN}$(DOCKER_CLIENT_MEMO)${C_END}" - swap: "${C_GRN}$(DOCKER_CLIENT_SWAP)${C_END}
	echo ${C_BLU}"$(PROJECT_NAME)"${C_END}" DOCUMENT DB "${C_YEL}$(DOCKER_PLTF)${C_END}" CLIENT - DB connection at: "${C_GRN}http://127.0.0.1:$(DOCKER_CLIENT_PORT)${C_END}
	echo ${C_BLU}"$(PROJECT_NAME)"${C_END}" DOCUMENT DB "${C_YEL}$(DOCKER_PLTF)${C_END}" CLIENT - DB client at: "${C_GRN}http://127.0.0.1:$(DOCKER_CLIENT_PORT)${C_END}
endif

# -------------------------------------------------------------------------------------------------
#  Database Container
# -------------------------------------------------------------------------------------------------
.PHONY: info ssh build up dev start stop restart clear destroy

info: ## shows container information
	echo ${C_BLU}"$(PROJECT_NAME)"${C_END}" - DATABASE: "${C_GRN}"$(DOCKER_PLTF)"${C_END};
	printf ${C_YEL}"Container ID.: "${C_END}; $(DOCKER) ps -aqf "name=^$(DOCKER_CONTAINER)$$"; printf "%s";
	echo ${C_YEL}"Name.........: "${C_END}$(DOCKER_CONTAINER);
	echo ${C_YEL}"Image........: "${C_END}"$(DOCKER_IMGK)";
	echo ${C_YEL}"CPUs.........: "${C_END}"$(DOCKER_CPUS)";
	echo ${C_YEL}"Memory.......: "${C_END}"$(DOCKER_MEMO)";
	echo ${C_YEL}"Swap.........: "${C_END}"$(DOCKER_SWAP)";
	echo ${C_YEL}"Host.........: "${C_END}"$(DOCKER_HOST):$(DOCKER_PORT)";
	echo ${C_YEL}"Hostname.....: "${C_END}"$(word 1,$(shell hostname -I)):"$(DOCKER_PORT);
	printf ${C_YEL}"Docker.Host..: "${C_END};$(DOCKER) inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(DOCKER_CONTAINER);
	printf ${C_YEL}"NetworkID....: "${C_END};$(DOCKER) inspect -f '{{range.NetworkSettings.Networks}}{{.NetworkID}}{{end}}' $(DOCKER_CONTAINER);

ssh: ## enters the container shell
	$(DOCKER_EXEC_SSH)

up: ## starts and recreates containers if compose config or image changed, runnning in detached mode
	cd docker && $(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.public.yml up -d

build: ## builds and ensures changes in the Dockerfile, build steps, or copied-in files are applied. Not --no-recreate
	cd docker && $(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.public.yml up --build -d

network: ## starts up into an existing custom network for container-to-container communication, runnning in detached mode
	cd docker && $(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.network.yml up -d

start: ## starts the container and put on running
	cd docker && $(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.network.yml start

stop: ## stops the running container but data will not be destroyed
	cd docker && $(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.network.yml stop

restart: ## restarts the running container
	cd docker && $(DOCKER) restart $(DOCKER_CONTAINER)

clear: ## removes container from Docker running containers
	cd docker && $(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.network.yml kill || true
	cd docker && $(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.network.yml rm --force || true
	cd docker && $(DOCKER_COMPOSE) -f docker-compose.yml -f docker-compose.network.yml down -v --remove-orphans || true

destroy: ## delete container image from Docker cache
	cd docker && $(DOCKER) rmi -f $(DOCKER_IMGK)
	cd docker && $(SUDO) rm -rf $(DOCKER_DATA)

dev: ## sets a development enviroment
	echo ${C_YEL}"\"dev\" recipe has not usage in this project"${C_END};

# -------------------------------------------------------------------------------------------------
#  Database Client Container
# -------------------------------------------------------------------------------------------------
.PHONY: ssh-client build-client up-client dev-client start-client stop-client restart-client clear-client destroy-client

info-client: ## shows client container information
	echo ${C_BLU}"$(PROJECT_NAME)"${C_END}" - DATABASE CLIENT: "${C_GRN}"$(DOCKER_PLTF)"${C_END};
	printf ${C_YEL}"Container ID.: "${C_END}; $(DOCKER) ps -aqf "name=^$(DOCKER_CONTAINER)-client$$"; printf "%s";
	echo ${C_YEL}"Name.........: "${C_END}$(DOCKER_CONTAINER)-client;
	echo ${C_YEL}"Image........: "${C_END}"$(DOCKER_CLIENT_IMGK)";
	echo ${C_YEL}"CPUs.........: "${C_END}"$(DOCKER_CLIENT_CPUS)";
	echo ${C_YEL}"Memory.......: "${C_END}"$(DOCKER_CLIENT_MEMO)";
	echo ${C_YEL}"Swap.........: "${C_END}"$(DOCKER_CLIENT_SWAP)";
	echo ${C_YEL}"Host.........: "${C_END}"$(DOCKER_HOST):$(DOCKER_CLIENT_PORT)";
	echo ${C_YEL}"Hostname.....: "${C_END}"$(word 1,$(shell hostname -I)):"$(DOCKER_CLIENT_PORT);
	printf ${C_YEL}"Docker.Host..: "${C_END};$(DOCKER) inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(DOCKER_CONTAINER)-client;
	printf ${C_YEL}"NetworkID....: "${C_END};$(DOCKER) inspect -f '{{range.NetworkSettings.Networks}}{{.NetworkID}}{{end}}' $(DOCKER_CONTAINER)-client;

ssh-client: ## enters the client container shell
	$(DOCKER_EXEC_SSH)

up-client: ## starts and recreates client containers if compose config or image changed, runnning in detached mode
	cd docker && $(DOCKER_COMPOSE) -f docker-compose.client.yml -f docker-compose.client.public.yml up -d

build-client: ## builds and ensures changes in the Dockerfile, build steps, or copied-in files are applied. Not --no-recreate
	cd docker && $(DOCKER_COMPOSE) -f docker-compose.client.yml -f docker-compose.client.public.yml up --build -d

network-client: ## starts up into an existing custom network for container-to-container communication, runnning in detached mode
	cd docker && $(DOCKER_COMPOSE) -f docker-compose.client.yml -f docker-compose.client.network.yml up -d

start-client: ## starts the client container and put on running
	cd docker && $(DOCKER_COMPOSE) -f docker-compose.client.yml -f docker-compose.client.public.yml start

stop-client: ## stops the running client container but data will not be destroyed
	cd docker && $(DOCKER_COMPOSE) -f docker-compose.client.yml -f docker-compose.client.public.yml stop

restart-client: ## restarts the running client container
	cd docker && $(DOCKER) restart $(DOCKER_CONTAINER)-client

clear-client: ## removes client container from Docker running containers
	cd docker && $(DOCKER_COMPOSE) -f docker-compose.client.yml -f docker-compose.client.public.yml kill || true
	cd docker && $(DOCKER_COMPOSE) -f docker-compose.client.yml -f docker-compose.client.public.yml rm --force || true
	cd docker && $(DOCKER_COMPOSE) -f docker-compose.client.yml -f docker-compose.client.public.yml down -v --remove-orphans || true

destroy-client: ## delete client container image from Docker images cache
	cd docker && $(DOCKER) rmi -f $(DOCKER_CLIENT_IMGK)

dev-client: ## sets a development enviroment
	echo ${C_YEL}"\"dev\" recipe has not usage in this project"${C_END};