<div id="top-header" style="with:100%;height:auto;text-align:right;">
    <img src="./resources/docs/images/pr-banner-long.png">
</div>

# INFRASTRUCTURE PLATFORMS

[![Generic badge](https://shields.io/badge/version-1.0-blue.svg)](https://shields.io/)
[![Open Source? Yes!](https://badgen.net/badge/Open%20Source%20%3F/Yes%21/blue?icon=github)](./)
[![MIT license](https://shields.io/badge/License-MIT-blue.svg)](./LICENSE)

# NGINX, PHP 8.5, MONGODB 8+ & REDIS 8 +
<br>

This repository serves as a multi-engine containerized infrastructure boilerplate designed to streamline local development and remote services for back-end or front-end applications. It provides a set of pre-configured, loosely coupled platform services optimized to work interchangeably with either Docker or Podman.

It abstracts complex orchestration down to simple automation layers, allowing you to instantly spin up independent, ready-to-scale platform components.

By decoupling the runtime services, this boilerplate ensures your primary application layer connects seamlessly to its supporting infrastructure components via standard local orchestration.

## Included Platform Services

- API: [NGINX + PHP 8.5](./platforms/nginx-php-8.5/README.md)
- Document DB: [MONGODB 8+](./platforms/mongodb-8/README.md)
- Memory DB: [REDIS 8+](./platforms/redis-8/README.md)
- Mail Sandbox: [MAILHOG 1+](./platforms/mailhog-1/README.md)
- Message Broker: [RABBITMQ 4+](./platforms/rabbitmq-4/README.md)
<br><br>


## Index

- [Repository Objectives](#repository-objectives)
- [Orchestration & Platform Specifics](#orchestration)
- [Containers Networking](#container-networking)
- [Platforms Setup](#platforms-setup)
- [Platforms Startup](#platforms-startup)
- [Using this Repository for Custom Project](#platform-usage)
<br><br>


## <a id="repository-objectives"></a>Repositoy Objectives

### Key principles and goals

This repository provides a consistent framework for local development that mirrors production environments. In production, APIs run on cloud instances (AWS, Azure, GCP) or Kubernetes pods. Meanwhile, the database layer resides on managed services like AWS RDS, Azure Database, or GCP Cloud SQL, utilizing Multi-AZ deployments for high availability and read replicas to scale performance. This structure ensures network connections between application and database tiers remain decoupled.

By leveraging Platform Engineering principles, this project reduces cognitive load for developers. It treats the Internal Developer Platform (IDP) as a product, offering self-service tools and automated workflows. This streamlines the entire lifecycle—from building to monitoring—allowing teams to innovate faster.

- **Self-service:** Provide developers with easy-to-use tools and automated workflows to manage their own infrastructure needs without having to file tickets or rely on other teams.

- **Standardization:** Use standardized tools and environments to ensure consistency, reliability, and security across projects.

- **Reduced cognitive load:** Abstract away underlying complexity so developers can focus on writing code and delivering business value rather than managing infrastructure details.

- **Developer experience:** Build a positive and productive environment for developers, making them feel empowered and less frustrated.

- **Operational efficiency:** Automate repetitive tasks and standardize processes to improve the speed and reliability of software delivery.

### How it works

- Internal Developer Platform (IDP): A dedicated platform built by the platform engineering team that provides a curated set of tools, services, and infrastructure.

- Golden Paths: Predefined, optimized workflows and best practices that developers can follow to accomplish common tasks quickly and easily.

- Treating the platform as a product: Platform engineers treat their IDP like a product, with developers as their customers, to ensure it meets the needs of the organization.

### Read more:

- [What is platform engineering? - IBM](https://www.ibm.com/think/topics/platform-engineering)
- [Understanding platform engineering - Red Hat](https://www.redhat.com/en/topics/platform-engineering)
- [Platform engineering - Prescriptive Guidance - AWS](https://docs.aws.amazon.com/prescriptive-guidance/latest/aws-caf-platform-perspective/platform-eng.html)
- [What is an internal developer platform (IDP)? - Google Cloud](https://cloud.google.com/solutions/platform-engineering)
- [What is platform engineering? - Microsoft](https://learn.microsoft.com/en-us/platform-engineering/what-is-platform-engineering)
- [What is Platform engineering? - Github](https://github.com/resources/articles/what-is-platform-engineering)
<br><br>


## <a id="orchestration"></a>Orchestration & Platform Specifics

### Supported Operating Systems

![Linux](https://shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![MacOS](https://shields.io/badge/MacOS-f0f0f0?logo=apple&logoColor=black&style=for-the-badge)
![Windows](https://shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![Windows WSL2](https://shields.io/badge/Windows-WSL2-4E9A06?style=for-the-badge&logo=windows&logoColor=white)

* **Linux** (Native)
* **macOS** (Intel & Apple Silicon M1–M5)
* **Windows 10 / 11** (Most recommended via WSL2 or Hyper-V)

### Minimum Hardware Requirements

By default, local development environments run a minimal stack and do not process live production traffic. Therefore, resource utilization remains low. 

| Machine       | Machine's minimum characteristics to run this repository                                          |
| ------------- | ------------------------------------------------------------------------------------------------- |
| CPU           | x86_64 / ARM64 - Supports modern Intel, AMD, and Apple Silicon chips.                             |
| RAM           | 1 GB - Scale up if compiling memory-heavy stacks (e.g., Java, Angular).                           |
| DISK          | 5 GB available space - Actual usage depends on downloaded container images and project cache.     |

💡 **Tip 1 - Resource Management:** Properly restricting container CPU and memory allocations prevents resource starvation on your local host machine and closely mirrors production security best practices.

💡 **Tip 2 - Environment Separation:** The automation commands provided in this repository are optimized for local development. In production or staging environments, standard cloud infrastructure designs typically distribute these platforms across separate VPS or cloud instances rather than running them all via a single local orchestration layer. To see how these components are isolated for production, you can find the individual single-service platforms listed under my [GitHub Repositories Profile](https://github.com/pabloripoll?tab=repositories).
<br>

### Task Automation (GNU Make)

![GNU](https://shields.io/badge/gnu-%23A42E2B.svg?style=for-the-badge&logo=gnu&logoColor=white)

It is highly recommended to use **GNU Make** on local to manage automated workflows from the root directory. On remote, you most probably choose bash script with or without a instance personalized Makefile.

* **Recommended:** Ensure make is installed on your host system to use shortened convenience commands.
* **Alternative:** If make is unavailable, commands must be executed manually within their respective subdirectories.

### Environment Variables for Automation

The automation layer dynamically adapts commands using variables defined in your root `.env` file. These variables control how your environment invokes the runtime engine.

This repository supports local development using either **Docker** or **Podman**. You can configure your preferred container engine in your root `.env` file *(copied from `.env.example`)*: 

```sh
# ENGINE DEFINITION (docker or podman)
CONTAINER_ENGINE=docker                                 # <- must define container engine system ------------------------------------------------------------> #

# CONTAINER VARIABLES FOR AUTOMATION
SUDO=sudo                                               # <- user priviledge for running engine commands, left blank if for running without sudo ------------> #
DOCKER=$(SUDO) $(CONTAINER_ENGINE)                      # <- engine core command generator ------------------------------------------------------------------> #
DOCKER_COMPOSE=$(SUDO) $(CONTAINER_ENGINE) compose      # <- targets "docker compose" / "docker-compose" or "podman compose" --------------------------------> #
```

These abstractions allow the root Makefile to trigger standard shortcuts (e.g., `make up`, `make down`) seamlessly across different setups.

⚠️ **A Note on Variable Naming:** To preserve backward compatibility with previous releases, this repository retains the use of `DOCKER` and `DOCKER_COMPOSE` as variable names throughout the codebase, scripts, and automation files. Rest assured, if you set `CONTAINER_ENGINE=podman`, these variables will correctly map to your **Podman setup** behind the scenes.

## Multi-Engine Architecture

![Docker](https://shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Podman](https://shields.io/badge/-Podman-892CA0?style=for-the-badge&logo=podman&logoColor=white)

The magic happens because modern Podman builds natively include the podman compose subcommand. It intercepts your standard, unmodified multi-container docker-compose.yml blueprints and automatically translates them down to Podman specifications.

Because this repository abstracts commands like `$ sudo docker compose up -d` via the root `Makefile` using the environment variables like `($(DOCKER_COMPOSE))`, the custom automation orchestration *(gmake/make recipes)* will point cleanly to **Podman** behind the scenes. No translation layers or custom rewrites needed.

This repository relies on a standard multi-container design (docker-compose.yml). You do not need to maintain multiple orchestration blueprints to switch engines:

- **Docker Native:** Runs commands through the standard dockerd daemon.

- **Podman Compatibility:** Modern versions of Podman include a built-in podman compose engine. When CONTAINER_ENGINE=podman is selected, Podman intercepts the docker-compose.yml specifications and automatically translates them into a Podman native configuration. No third-party translation tools are required.

### Platform-Specific Setup Notes

#### Linux & Windows (WSL2)

Ensure your chosen container daemon is installed and running. If your local user account belongs to the docker or podman security group (allowing rootless container operations), you should set SUDO= to a blank value in your .env file.

#### macOS

Because macOS does not natively run Linux containers, both Docker and Podman spin up a background Linux Virtual Machine (VM) to host your workloads. If you choose to use Podman on macOS, execute the following steps once to initialize your engine environment:

#### Docker

Despite Docker’s cross-platform compatibility, for intermediate to advanced software development on environments other than Windows NT or macOS, automating the platform build and streamlining the process of starting feature development is crucial. This automation enables a more dynamic and efficient software development lifecycle.

- [Docker Documentation](https://docs.docker.com/engine/)
- [Docker Installation](https://docs.docker.com/engine/install/)

#### Podman

Because macOS with cannot natively run Linux containers, there are two quick command-line commands you must run exactly once right after your brew install to initialize the engine. Open your terminal and run these commands to set up the Podman virtual machine:
```sh
# 1. Install Podman via Homebrew
$ brew install podman

# 2. Create the lightweight Apple Silicon Linux VM (Run once)
$ podman machine init

# 3. Fire up the Podman engine VM
$ podman machine start
```

- [Podman Documentation](https://podman.io/docs)
- [Podman Installation](https://podman.io/docs/installation)
<br><br>

## <a id="containers-networking"></a>Containers Networking - Access Modes

- If no application is on `./api-rest` directory *(or your custom binded directory name)* once container is up it wont provide a application and therefore NGINX will respond with an error. Copy an start-up example application or create a parking page.

- Each container have a directory to set the required environment values in `./docker/.env` from `./docker/.env.example` if no GNU Make will be applied.

- Also, each container may need to set the required configuration files by coping and updating them depending on your project requirements.

- Containers availability by building the container with `docker-composer.yml` in separated configuration layers
    - Stand-alone
        - The container is intended to be published directly and accessed from the host network, typically via `0.0.0.0:<port>`. It does not require a shared Docker network. It is a common setting for local development.
    - Inside a Custom Network
        - The container is attached to a custom Docker network and is intended to be accessed through a reverse proxy or other containers on the same network.
        - This network setting is useful for isolating services while still allowing container-to-container communication.
        - It is a strongly recommended setting for remote deployment to avoid exposing the localhost port in used and protect by firewall.
        - <b>Connect from one container to another inside the custom network, by container name and its own exposed port</b>.
    - Host-Gateway
        - The container can reach services running on the host machine using the Docker host gateway mapping. This is useful when the container must access local services on the VPS/host, while public access is still handled through a reverse proxy. It is a recommended setting for remote deployment too.
    - Public exposure is controlled by the `ports` mapping.
    - `0.0.0.0:<port>` means externally accessible.
    - `127.0.0.1:<port>` means local-only access on the host and requires a reverse proxy, e.g. NGINX.
    - Docker network attachment controls container-to-container communication.
    - Host-gateway controls container-to-host communication.
<br><br>

## <a id="platforms-setup"></a>Platforms Setup

Create the root `./.env` file from the [./.env.example](./.env.example) and follow its description to configure the platforms required environment variables.

Also create the root `./Makefile` file from [./resources/automation/local/Makefile](./resources/automation/local/Makefile) so it will be easy to manage the platforms from one location in the project.

Each recipe from this root `Makefile` has its own action description and can be read to remember on terminal by executing `make help` command to see them all. This streamlines the workflow for managing containers with mnemonic recipe names, avoiding the effort of remembering and typing each bash command line:
```bash
$ make help
```

⚠️ **Important Setup Requirement:** Core platform components require independent configuration prior to initialization. Ensure you review the specific setup guidance in each sub-directory's `README.md` before starting up the container orchestration layer.

Once variables are set, each Docker platform container environment variables can be set by GNU Make recipes placed in the root of this repository:

- Setup the API container
  ```bash
  $ make apirest-set
  ```
  **Remember**: *the `./api-rest` directory name is custimizable for binding between the container and local machine.*

- Setup the database container
  ```bash
  $ make db-set
  ```

- Setup the mail service container
  ```bash
  $ make mailer-set
  ```

- Setup the message broker service container
  ```bash
  $ make broker-set
  ```
<br>

## <a id="platforms-startup"></a>Platforms Startup

Create and startup the API container
```bash
$ make apirest-create
```
<br>

Testing container visiting localhost with the assigned port, but with no database connection established or failed because of wrong configuration
<br>

Create and startup the database container
```bash
$ make db-create
```
<br>

Once database service is up and running, status message will show successful connection
<br>

Create and startup the mail service container
```bash
$ make mailer-create
```
<br>

Create and startup the message broker service container
```bash
$ make broker-create
```
<br>

Test mail sandobox service container by clicking "Direct Test MAIL" link
<br>

Docker information of both cointer up and running
```bash
$ sudo docker ps
```
<br>

Despite each container can be stop or restarted, they can be stopped and destroyed both containers simultaneously to clean up Docker generated cache, without affecting other containers running on the same machine.
```bash
$ yes | make apirest-destroy db-destroy mailer-destroy broker-destroy
```
<br><br>

## <a id="platform-usage"></a>Use this Platform Repository for your own projects

Repository directories structure overview
```sh
.
├── api-rest                    # detached repository
│   ├── src
│   ├── .env
│   ├── vendor
│   └── ...etc
│
├── platforms                   # remote infrastructure platforms
│   ├── nginx-php-8.5
│   │   ├── docker
│   │   │   ├── config
│   │   │   ├── .env
│   │   │   ├── docker-compose.yml
│   │   │   └── Dockerfile
│   │   └── Makefile
│   │
│   ├── mongodb-8
│   │   ├── docker
│   │   │   ├── .env
│   │   │   ├── docker-compose.yml
│   │   │   └── ...etc
│   │   └── Makefile
│   │
│   ├── mailhog-1.0
│   │   ├── docker
│   │   │   ├── .env
│   │   │   ├── docker-compose.yml
│   │   │   └── ...etc
│   │   └── Makefile
│   │
│   └── rabbitmq-4.2
│       ├── docker
│       │   ├── .env
│       │   ├── docker-compose.yml
│       │   └── ...etc
│       └── Makefile
│
├── resources                   # orientative documentation
│   ├── automation
│   │   ├── local
│   │   │   ├── Makefile        # root ./
│   │   │   └── Makefile.child  # this goes inside ./api-rest
│   │   └── remote
│   ├── databases
│   │   ├── example-init.sql
│   │   └── example-backup.sql
│   └── docs
│       └── ...
│
├── .env
├── Makefile
└── README.md
```
<br>

Set up platforms
- Copy `.env.example` to `.env` and adjust settings (rest api port, database port, mail service port, container RAM usage, etc.)
<br>

### Managing the `./api-rest` directory: Submodule vs Detached Repository

To remove the `./api-rest` the default installation content and install your desired repository inside it, there are two alternatives for managing both the platform and apirest repositories independently:

Here’s a step-by-step guide for using this Platform repository along with your own REST API repository:

- Remove the existing `./api-rest` directory contents from local and from git cache
- Install your desired repository inside `./api-rest`
- Choose between Git submodule and detached repository approaches

#### 1. **GIT Detached Repository (Recommended)**

> Git commands can be executed **whether from inside the container or on the local machine**.

- Remove `./api-rest` from local and git cache:
  ```bash
  $ git rm -r --cached -- "api-rest/*" ":(exclude)api-rest/.gitkeep"
  $ git clean -fd
  $ git reset --hard
  $ git commit -m "maint: api-rest directory and its default installation removed"
  ```

- Clone the desired repository as a detached repository:
  ```bash
  $ git clone git@[vcs]:[account]/[repository].git ./api-rest
  ```

- The `./api-rest` directory is now an **independent repository**, not tracked as a submodule in your main repo. You can use `git` commands freely inside `./api-rest` directory from anywhere.
<br>

#### 2. **GIT Sub-module**

> Git commands can be executed **only from inside the container**.

- Remove `./api-rest` content from local and git cache:
  ```bash
  $ rm -rfv ./api-rest/* ./api-rest/.[!.]*$
  $ git rm -r --cached apirest
  $ git commit -m "maint: apirest directory and its default installation removed"
  ```

- Add the desired repository as a submodule:
  ```bash
  $ git submodule add git@[vcs]:[account]/[repository].git ./api-rest
  $ git commit -m "maint: apirest as a git submodule added"
  ```

- To update submodule contents:
  ```bash
  $ cd ./api-rest
  $ git pull origin main  # or desired branch
  ```

- To initialize/update submodules after `git clone`:
  ```bash
  $ git submodule update --init --recursive
  ```

#### **Summary Table**

| Approach         | Repo independence | Where to run git commands | Use case                        |
|------------------|------------------|--------------------------|----------------------------------|
| Submodule        | Tracked by main  | Inside container         | Main repo controls webapp version|
| Detached (rec.)  | Fully independent| Local or container       | Maximum flexibility              |

> **Note**: After new project cloned inside `./api-rest`, consider adding `./api-rest/.gitkeep` in it to prevent accidental tracking *(especially for detached repository)*.
<br><br>

<br>

## Contributing

Contributions are very welcome! Please open issues or submit PRs for improvements, new features, or bug fixes.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/YourFeature`)
3. Commit your changes (`git commit -am 'feat: Add new feature'`)
4. Push to the branch (`git push origin feature/YourFeature`)
5. Create a new Pull Request
<br><br>

## License

This project is open-sourced under the [MIT license](LICENSE).

<!-- FOOTER -->
<br>

---

<br>

- [GO TOP ⮙](#top-header)

<div style="with:100%;height:auto;text-align:right;">
    <img src="./resources/docs/images/pr-banner-long.png">
</div>