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

include .env

ROOT_DIR=$(patsubst %/,%,$(dir $(realpath $(firstword $(MAKEFILE_LIST)))))
DIR_BASENAME=$(shell basename $(ROOT_DIR))

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
.PHONY: local-info local-ownership local-ownership-set

local_ip ?= $(word 1,$(shell hostname -I))
local-info: ## shows local machine ip and container ports set
	echo ${C_BLU}"Local IP / Hostname:"${C_END} ${C_YEL}"$(local_ip)"${C_END}

user ?= ${USER}
group ?= root
local-ownership: ## shows local ownership
	echo $(user):$(group)

local-ownership-set: ## sets recursively local root directory ownership
	$(SUDO) chown -R ${user}:${group} $(ROOT_DIR)/

# -------------------------------------------------------------------------------------------------
#  Networking
# -------------------------------------------------------------------------------------------------
.PHONY: network-exists network-create network-info network-destroy

network-exists: ## lists all local networks
	$(DOCKER) network ls

network-create: ## creates network
	$(DOCKER) network create --driver bridge $(PROJECT_LEAD)-$(PROJECT_CNET)

network-info: ## shows network information
	$(DOCKER) network inspect $(PROJECT_LEAD)-$(PROJECT_CNET) --format '{{json .Containers}}'

network-destroy: ## destroys network
	$(DOCKER) network rm $(PROJECT_LEAD)-$(PROJECT_CNET)

# -------------------------------------------------------------------------------------------------
#  Backend API Service
# -------------------------------------------------------------------------------------------------
.PHONY: apirest-hostcheck apirest-info apirest-set apirest-create apirest-network apirest-ssh apirest-start apirest-stop apirest-destroy

apirest-hostcheck: ## shows this project ports availability on local machine for apirest container
	cd platforms/$(APIREST_PLTF) && $(MAKE) port-check

apirest-info: ## shows the apirest docker related information
	cd platforms/$(APIREST_PLTF) && $(MAKE) info

apirest-set: ## sets the apirest enviroment file to build the container
	cd platforms/$(APIREST_PLTF) && $(MAKE) env-set

apirest-build: ## builds and ensures changes in the Dockerfile, build steps, or copied-in files are applied
	cd platforms/$(APIREST_PLTF) && $(MAKE) build

apirest-create: ## starts up or creates the container for running in detached mode
	cd platforms/$(APIREST_PLTF) && $(MAKE) up

apirest-network: ## starts up into an existing custom network for container-to-container communication, runnning in detached mode
	cd platforms/$(APIREST_PLTF) && $(MAKE) clear network

apirest-host-gateway: ## starts up for container-to-host communication, runnning in detached mode
	$(MAKE) apirest-stop
	cd platforms/$(APIREST_PLTF) && $(MAKE) clear host-gateway

apirest-ssh: ## enters the apirest container shell
	cd platforms/$(APIREST_PLTF) && $(MAKE) ssh

apirest-start: ## starts the apirest container running
	cd platforms/$(APIREST_PLTF) && $(MAKE) start

apirest-stop: ## stops the apirest container but its assets will not be destroyed
	cd platforms/$(APIREST_PLTF) && $(MAKE) stop

apirest-restart: ## restarts the running apirest container
	cd platforms/$(APIREST_PLTF) && $(MAKE) restart

apirest-destroy: ## destroys completly the apirest container
	echo ${C_RED}"Attention!"${C_END};
	echo ${C_YEL}"You're about to remove the "${C_BLU}"$(APIREST_PLTF)"${C_END}" container and delete its image resource."${C_END};
	@echo -n ${C_RED}"Are you sure to proceed? "${C_END}"[y/n]: " && read response && if [ $${response:-'n'} != 'y' ]; then \
        echo ${C_GRN}"K.O.! container has been stopped but not destroyed."${C_END}; \
    else \
		cd platforms/$(APIREST_PLTF) && $(MAKE) stop clear destroy; \
		echo -n ${C_GRN}"Do you want to clear DOCKER cache? "${C_END}"[y/n]: " && read response && if [ $${response:-'n'} != 'y' ]; then \
			echo ${C_YEL}"The following command is delegated to be executed by user:"${C_END}; \
			echo "$$ $(DOCKER) system prune"; \
		else \
			$(DOCKER) system prune; \
			echo ${C_GRN}"O.K.! DOCKER cache has been cleared up."${C_END}; \
		fi \
	fi

# -------------------------------------------------------------------------------------------------
#  Mongo DB & Client
# -------------------------------------------------------------------------------------------------
.PHONY: mongo-host-check mongo-set

mongo-host-check: ## shows container service requirements status on local machine
	cd platforms/$(MONGODB_PLTF) && $(MAKE) ports-check

mongo-set: ## sets the database and client enviroment file to build both container
	cd platforms/$(MONGODB_PLTF) && $(MAKE) env-set

# --- #

.PHONY: mongo-info mongo-build mongo-create mongo-ssh mongo-start mongo-stop mongo-destroy

mongo-info: ## shows docker related information
	cd platforms/$(MONGODB_PLTF) && $(MAKE) info

mongo-build: ## builds and ensures changes in the Dockerfile, build steps, or copied-in files are applied
	cd platforms/$(MONGODB_PLTF) && $(MAKE) build

mongo-create: ## starts up or creates the container for running in detached mode
	cd platforms/$(MONGODB_PLTF) && $(MAKE) up

mongo-network: ## starts up into an existing custom network for container-to-container communication, runnning in detached mode
	cd platforms/$(MONGODB_PLTF) && $(MAKE) clear network

mongo-ssh: ## enters the apirest container shell
	cd platforms/$(MONGODB_PLTF) && $(MAKE) ssh

mongo-start: ## starts the database container running
	cd platforms/$(MONGODB_PLTF) && $(MAKE) start

mongo-stop: ## stops the database container but its assets will not be destroyed
	cd platforms/$(MONGODB_PLTF) && $(MAKE) stop

mongo-restart: ## restarts the running database container
	cd platforms/$(MONGODB_PLTF) && $(MAKE) restart

mongo-destroy: ## destroys completly the database container with its data
	echo ${C_RED}"Attention!"${C_END};
	echo ${C_YEL}"You're about to remove the "${C_BLU}"$(MONGODB_PLTF)"${C_END}" container and delete its image resource and persistance data."${C_END};
	@echo -n ${C_RED}"Are you sure to proceed? "${C_END}"[y/n]: " && read response && if [ $${response:-'n'} != 'y' ]; then \
        echo ${C_GRN}"K.O.! container has been stopped but not destroyed."${C_END}; \
    else \
		cd platforms/$(MONGODB_PLTF) && $(MAKE) stop clear destroy; \
		echo -n ${C_GRN}"Do you want to clear DOCKER cache? "${C_END}"[y/n]: " && read response && if [ $${response:-'n'} != 'y' ]; then \
			echo ${C_YEL}"The following commands are delegated to be executed by user:"${C_END}; \
			echo "$$ $(DOCKER) system prune"; \
			echo "$$ $(DOCKER) volume prune"; \
		else \
			$(DOCKER) system prune; \
			$(DOCKER) volume prune; \
			echo ${C_GRN}"O.K.! DOCKER cache has been cleared up."${C_END}; \
		fi \
	fi

# --- #

.PHONY: mongo-client-info mongo-client-build mongo-client-create mongo-client-ssh mongo-client-start mongo-client-stop mongo-client-destroy

mongo-client-info: ## shows docker related information
	cd platforms/$(MONGODB_PLTF) && $(MAKE) info-client

mongo-client-build: ## builds and ensures changes in the Dockerfile, build steps, or copied-in files are applied
	cd platforms/$(MONGODB_PLTF) && $(MAKE) build-client

mongo-client-create: ## starts up or creates the container for running in detached mode
	cd platforms/$(MONGODB_PLTF) && $(MAKE) up-client

mongo-client-network: ## starts up into an existing custom network for container-to-container communication, runnning in detached mode
	cd platforms/$(MONGODB_PLTF) && $(MAKE) clear-client network-client

mongo-client-ssh: ## enters the apirest container shell
	cd platforms/$(MONGODB_PLTF) && $(MAKE) ssh-client

mongo-client-start: ## starts the database container running
	cd platforms/$(MONGODB_PLTF) && $(MAKE) start-client

mongo-client-stop: ## stops the database container but its assets will not be destroyed
	cd platforms/$(MONGODB_PLTF) && $(MAKE) stop-client

mongo-client-restart: ## restarts the running database container
	cd platforms/$(MONGODB_PLTF) && $(MAKE) restart-client

mongo-client-destroy: ## destroys completly the database container with its data
	echo ${C_RED}"Attention!"${C_END};
	echo ${C_YEL}"You're about to remove the "${C_BLU}"$(MONGODB_PLTF)"${C_END}" container and delete its image resource and persistance data."${C_END};
	@echo -n ${C_RED}"Are you sure to proceed? "${C_END}"[y/n]: " && read response && if [ $${response:-'n'} != 'y' ]; then \
        echo ${C_GRN}"K.O.! container has been stopped but not destroyed."${C_END}; \
    else \
		cd platforms/$(MONGODB_PLTF) && $(MAKE) stop-client clear-client destroy-client; \
		echo -n ${C_GRN}"Do you want to clear DOCKER cache? "${C_END}"[y/n]: " && read response && if [ $${response:-'n'} != 'y' ]; then \
			echo ${C_YEL}"The following commands are delegated to be executed by user:"${C_END}; \
			echo "$$ $(DOCKER) system prune"; \
			echo "$$ $(DOCKER) volume prune"; \
		else \
			$(DOCKER) system prune; \
			$(DOCKER) volume prune; \
			echo ${C_GRN}"O.K.! DOCKER cache has been cleared up."${C_END}; \
		fi \
	fi

# -------------------------------------------------------------------------------------------------
#  Mailer Service
# -------------------------------------------------------------------------------------------------
.PHONY: mailer-hostcheck mailer-info mailer-set mailer-create mailer-network mailer-ssh mailer-start mailer-stop mailer-destroy

mailer-hostcheck: ## shows this project ports availability on local machine for mailer container
	cd platforms/$(MAILER_PLTF) && $(MAKE) port-check

mailer-info: ## shows the mailer docker related information
	cd platforms/$(MAILER_PLTF) && $(MAKE) info

mailer-set: ## sets the mailer enviroment file to build the container
	cd platforms/$(MAILER_PLTF) && $(MAKE) env-set

mailer-build: ## builds mailer and ensures changes in the Dockerfile, build steps, or copied-in files are applied
	cd platforms/$(MAILER_PLTF) && $(MAKE) build

mailer-create: ## starts up mailer or creates the container for running in detached mode
	cd platforms/$(MAILER_PLTF) && $(MAKE) up

mailer-network: ## starts up mailer into an existing custom network for container-to-container communication, runnning in detached mode
	cd platforms/$(MAILER_PLTF) && $(MAKE) clear network

mailer-ssh: ## enters the mailer container shell
	cd platforms/$(MAILER_PLTF) && $(MAKE) ssh

mailer-start: ## starts the mailer container running
	cd platforms/$(MAILER_PLTF) && $(MAKE) start

mailer-stop: ## stops the mailer container but its assets will not be destroyed
	cd platforms/$(MAILER_PLTF) && $(MAKE) stop

mailer-restart: ## restarts the running mailer container
	cd platforms/$(MAILER_PLTF) && $(MAKE) restart

mailer-destroy: ## destroys completly the mailer container
	echo ${C_RED}"Attention!"${C_END};
	echo ${C_YEL}"You're about to remove the "${C_BLU}"$(MAILER_PLTF)"${C_END}" container and delete its image resource."${C_END};
	@echo -n ${C_RED}"Are you sure to proceed? "${C_END}"[y/n]: " && read response && if [ $${response:-'n'} != 'y' ]; then \
        echo ${C_GRN}"K.O.! container has been stopped but not destroyed."${C_END}; \
    else \
		cd platforms/$(MAILER_PLTF) && $(MAKE) stop clear destroy; \
		echo -n ${C_GRN}"Do you want to clear DOCKER cache? "${C_END}"[y/n]: " && read response && if [ $${response:-'n'} != 'y' ]; then \
			echo ${C_YEL}"The following command is delegated to be executed by user:"${C_END}; \
			echo "$$ $(DOCKER) system prune"; \
		else \
			$(DOCKER) system prune; \
			echo ${C_GRN}"O.K.! DOCKER cache has been cleared up."${C_END}; \
		fi \
	fi

# -------------------------------------------------------------------------------------------------
#  Broker Service
# -------------------------------------------------------------------------------------------------
.PHONY: broker-hostcheck broker-info broker-set broker-create broker-network broker-ssh broker-start broker-stop broker-destroy

broker-hostcheck: ## shows this project ports availability on local machine for broker container
	cd platforms/$(BROKER_PLTF) && $(MAKE) port-check

broker-info: ## shows the broker docker related information
	cd platforms/$(BROKER_PLTF) && $(MAKE) info

broker-set: ## sets the broker enviroment file to build the container
	cd platforms/$(BROKER_PLTF) && $(MAKE) env-set

broker-build: ## builds broker and ensures changes in the Dockerfile, build steps, or copied-in files are applied
	cd platforms/$(BROKER_PLTF) && $(MAKE) build

broker-create: ## starts up broker or creates the container for running in detached mode
	cd platforms/$(BROKER_PLTF) && $(MAKE) up

broker-network: ## starts up broker into an existing custom network for container-to-container communication, runnning in detached mode
	cd platforms/$(BROKER_PLTF) && $(MAKE) clear network

broker-ssh: ## enters the broker container shell
	cd platforms/$(BROKER_PLTF) && $(MAKE) ssh

broker-start: ## starts the broker container running
	cd platforms/$(BROKER_PLTF) && $(MAKE) start

broker-stop: ## stops the broker container but its assets will not be destroyed
	cd platforms/$(BROKER_PLTF) && $(MAKE) stop

broker-restart: ## restarts the running broker container
	cd platforms/$(BROKER_PLTF) && $(MAKE) restart

broker-destroy: ## destroys completly the broker container
	echo ${C_RED}"Attention!"${C_END};
	echo ${C_YEL}"You're about to remove the "${C_BLU}"$(BROKER_PLTF)"${C_END}" container and delete its image resource."${C_END};
	@echo -n ${C_RED}"Are you sure to proceed? "${C_END}"[y/n]: " && read response && if [ $${response:-'n'} != 'y' ]; then \
        echo ${C_GRN}"K.O.! container has been stopped but not destroyed."${C_END}; \
    else \
		cd platforms/$(BROKER_PLTF) && $(MAKE) stop clear destroy; \
		echo -n ${C_GRN}"Do you want to clear DOCKER cache? "${C_END}"[y/n]: " && read response && if [ $${response:-'n'} != 'y' ]; then \
			echo ${C_YEL}"The following command is delegated to be executed by user:"${C_END}; \
			echo "$$ $(DOCKER) system prune"; \
		else \
			$(DOCKER) system prune; \
			echo ${C_GRN}"O.K.! DOCKER cache has been cleared up."${C_END}; \
		fi \
	fi

# -------------------------------------------------------------------------------------------------
#  Repository Helper
# -------------------------------------------------------------------------------------------------
.PHONY: repo-flush repo-commit

repo-flush: ## echoes clearing commands for git repository cache on local IDE and sub-repository tracking remove
	echo ${C_YEL}"Clear repository for untracked files:"${C_END}
	echo ${C_YEL}"$$"${C_END}" git rm -rf --cached .; git add .; git commit -m \"maint: cache cleared for untracked files\""
	echo ""
	echo ${C_YEL}"Detach REST/GRPC API repository from platforms repository:"${C_END}
	echo ${C_YEL}"$$"${C_END}" git rm -r --cached -- \"api-rest/*\" \":(exclude)api-rest/.gitkeep\""
	echo ${C_YEL}"$$"${C_END}" git rm -r --cached -- \"api-grpc/*\" \":(exclude)api-grpc/.gitkeep\""

repo-commit: ## echoes common git commands
	echo ${C_YEL}"Common commiting commands:"${C_END}
	echo ${C_YEL}"$$"${C_END}" git add . && git commit -m \"feat: ... \""
	echo ""
	echo ${C_YEL}"For fixing pushed commit comment:"${C_END}
	echo ${C_YEL}"$$"${C_END}" git commit --amend"
	echo ${C_YEL}"$$"${C_END}" git push --force origin [branch]"
