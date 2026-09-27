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

DOCKER_PLTF="RABBITMQ 4+"
DOCKER_LEAD=$(PROJECT_LEAD)
DOCKER_CNET=$(PROJECT_CNET)
DOCKER_HOST=$(PROJECT_HOST)
DOCKER_IMGK=$(BROKER_IMGK)
DOCKER_PORT=$(BROKER_PORT)
DOCKER_DATA=$(BROKER_DATA)
DOCKER_LOGS=$(BROKER_LOGS)
DOCKER_CAAS=$(BROKER_CAAS)
DOCKER_CPUS=$(BROKER_CPUS)
DOCKER_MEMO=$(BROKER_MEMO)
DOCKER_SWAP=$(BROKER_SWAP)
DOCKER_APP_PORT=$(BROKER_APP_PORT)
DOCKER_APP_USER=$(BROKER_APP_USER)
DOCKER_APP_PASS=$(BROKER_APP_PASS)
DOCKER_APP_COOKIE=$(BROKER_APP_COOKIE)
DOCKER_APP_NODENAME=$(BROKER_APP_NODENAME)

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
.PHONY: port-check

port-check: ## shows this project port availability on local machine
	echo "Checking configuration for "${C_YEL}"$(DOCKER_PLTF)"${C_END}" container:";
	if [ -z "$($(DOCKER) lsof -i :$(DOCKER_PORT))" ]; then \
		echo ${C_BLU}"$(DOCKER_PLTF)"${C_END}" > localhost:"${C_GRN}"$(DOCKER_PORT) is free to use."${C_END}; \
    else \
		echo ${C_BLU}"$(DOCKER_PLTF)"${C_END}" > localhost:"${C_RED}"$(DOCKER_PORT) is busy. Update ./.env file."${C_END}; \
	fi

# -------------------------------------------------------------------------------------------------
#  Enviroment
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
	@echo "COMPOSE_PROJECT_LEAD=$(DOCKER_LEAD)" > ./docker/.env
	@echo "COMPOSE_PROJECT_CNET=$(DOCKER_CNET)" >> ./docker/.env
	@echo "COMPOSE_PROJECT_IMGK=$(DOCKER_IMGK)" >> ./docker/.env
	@echo "COMPOSE_PROJECT_HOST=$(DOCKER_HOST)" >> ./docker/.env
	@echo "COMPOSE_PROJECT_PORT=$(DOCKER_PORT)" >> ./docker/.env
	@echo "COMPOSE_PROJECT_DATA=\"$(DOCKER_DATA)\"" >> ./docker/.env
	@echo "COMPOSE_PROJECT_LOGS=\"$(DOCKER_LOGS)\"" >> ./docker/.env
	@echo "COMPOSE_PROJECT_NAME=$(DOCKER_CAAS)" >> ./docker/.env
	@echo "COMPOSE_PROJECT_CPUS=$(DOCKER_CPUS)" >> ./docker/.env
	@echo "COMPOSE_PROJECT_MEMO=$(DOCKER_MEMO)" >> ./docker/.env
	@echo "COMPOSE_PROJECT_SWAP=$(DOCKER_SWAP)" >> ./docker/.env
	@echo "COMPOSE_PROJECT_APP_PORT=$(DOCKER_APP_PORT)" >> ./docker/.env
	@echo "COMPOSE_PROJECT_APP_USER=$(DOCKER_APP_USER)" >> ./docker/.env
	@echo "COMPOSE_PROJECT_APP_PASS=\"$(DOCKER_APP_PASS)\"" >> ./docker/.env
	@echo "COMPOSE_PROJECT_APP_COOKIE=\"$(DOCKER_APP_COOKIE)\"" >> ./docker/.env
	@echo "COMPOSE_PROJECT_APP_NODENAME=\"$(DOCKER_APP_NODENAME)\"" >> ./docker/.env
	echo ${C_BLU}"$(PROJECT_NAME)"${C_END}" MESSAGE BROKER "${C_YEL}$(DOCKER_PLTF)${C_END}" - "${C_YEL}"docker-compose.yml"${C_END}" .env file "${C_GRN}"has been set."${C_END};
	echo ${C_BLU}"$(PROJECT_NAME)"${C_END}" MESSAGE BROKER "${C_YEL}$(DOCKER_PLTF)${C_END}" - Container: "${C_GRN}$(DOCKER_CONTAINER)${C_END}
	echo ${C_BLU}"$(PROJECT_NAME)"${C_END}" MESSAGE BROKER "${C_YEL}$(DOCKER_PLTF)${C_END}" - Max. CPUs: "${C_GRN}$(DOCKER_CPUS)${C_END}
	echo ${C_BLU}"$(PROJECT_NAME)"${C_END}" MESSAGE BROKER "${C_YEL}$(DOCKER_PLTF)${C_END}" - Max. memory usage: "${C_GRN}$(DOCKER_MEMO)${C_END}" - swap: "${C_GRN}$(DOCKER_SWAP)${C_END}
	echo ${C_BLU}"$(PROJECT_NAME)"${C_END}" MESSAGE BROKER "${C_YEL}$(DOCKER_PLTF)${C_END}" - AMQP is served at: http://"${C_GRN}$(word 1,$(shell hostname -I)):$(DOCKER_PORT)${C_END}
	echo ${C_BLU}"$(PROJECT_NAME)"${C_END}" MESSAGE BROKER "${C_YEL}$(DOCKER_PLTF)${C_END}" - APP is served at: http://127.0.0.1:"${C_GRN}$(DOCKER_APP_PORT)${C_END}
endif

# -------------------------------------------------------------------------------------------------
#  Container
# -------------------------------------------------------------------------------------------------
.PHONY: info ssh up build network start stop restart clear destroy dev

info: ## shows container information
	echo ${C_BLU}"$(PROJECT_NAME)"${C_END}" - BROKER: "${C_GRN}"$(DOCKER_PLTF)"${C_END};
	printf ${C_YEL}"Container ID.: "${C_END}; $(DOCKER) ps -aqf "name=^$(DOCKER_CONTAINER)$$"; printf "%s";
	echo ${C_YEL}"Name.........: "${C_END}$(DOCKER_CONTAINER);
	echo ${C_YEL}"Image........: "${C_END}"$(DOCKER_CONTAINER):$(DOCKER_IMGK)";
	echo ${C_YEL}"CPUs.........: "${C_END}"$(DOCKER_CPUS)";
	echo ${C_YEL}"Memory.......: "${C_END}"$(DOCKER_MEMO)";
	echo ${C_YEL}"Host.........: "${C_END}"$(DOCKER_HOST):$(DOCKER_PORT)";
	echo ${C_YEL}"Hostname.....: "${C_END}"$(word 1,$(shell hostname -I)):"$(DOCKER_PORT);
	echo ${C_YEL}"App.Host.....: "${C_END}"http://127.0.0.1:$(DOCKER_APP_PORT)";
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

start: ## starts the container and put on running from latest configuration
	cd docker && $(DOCKER_COMPOSE) start

stop: ## stops the running container but data won't be destroyed
	cd docker && $(DOCKER_COMPOSE) stop

restart: ## restarts the running container
	cd docker && $(DOCKER) restart $(DOCKER_CONTAINER)

clear: ## removes container from Docker running containers with its network and volume established
	cd docker && $(DOCKER_COMPOSE) kill || true
	cd docker && $(DOCKER_COMPOSE) down --volumes --remove-orphans || true

destroy: ## delete container image from Docker cache
	cd docker && $(DOCKER) rmi -f $(DOCKER_IMGK)
	$(SUDO) rm -rf $(BROKER_DATA)
	$(SUDO) rm -rf $(BROKER_LOGS)

dev: ## sets a development enviroment
	echo ${C_YEL}"\"dev\" recipe has not usage in this project"${C_END};
