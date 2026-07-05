<div id="top-header" style="with:100%;height:auto;text-align:right;">
    <img src="./../../resources/docs/images/pr-banner-long.png">
</div>

# MONGODB 8+

- [./main](../../README.md)
- [Features](#features)
- [Configuration](#configuration)
- [Management](#management)
<br>

## <a id="features"></a>Features

![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=Ubuntu&logoColor=white)
![MongoDB](https://img.shields.io/badge/-MongoDB-13aa52?style=for-the-badge&logo=mongodb&logoColor=white)

MongoDB is a popular, open-source NoSQL database that stores data in flexible, JSON-like documents rather than traditional rigid tables. It allows developers to store complex and varied data types easily, making it highly adaptable and scalable for modern web and mobile applications.

Content:
- Linux Ubuntu 24.04
- MongoDB 8+
- Mongo Express
<br><br>

Sources:
- https://www.mongodb.com/docs/
- https://github.com/mongodb
- https://hub.docker.com/_/mongo
- https://github.com/docker-library/mongo/tree/master/8.2

### Key Differences from Traditional Databases

To understand MongoDB, it helps to see how it differs from traditional relational databases (like MySQL or PostgreSQL):
```
Feature             Relational (e.g., MySQL)                            MongoDB (NoSQL)
Data Structure      Tables with strict rows and columns                 Collections of flexible documents (similar to JSON objects)
Schema              Rigid: All rows must have the same columns          Dynamic: Documents in the same collection can have different fields
Scalability         Usually scaled vertically                           Scaled horizontally
Best For            Highly structured data with strict relationships    Unstructured/semi-structured data that changes often
```

### Core Components of MongoDB
- Database: The primary container that houses all your collections of data.
- Collections: The equivalent of a "table" in a SQL database. It is a grouping of MongoDB documents.
- Documents: The fundamental unit of data in MongoDB, stored as BSON (Binary JSON). They consist of key-value pairs. For example:
    ```json
        {
            "_id": "12345",
            "name": "Alice",
            "age": 28,
            "interests": ["coding", "hiking"]
        }
    ```
### Why Developers Use It

- Rapid Development: The document model maps directly to objects in application code, eliminating the need to write complex "joins" to piece data together
- Scalability: It handles massive amounts of traffic and data growth effortlessly by distributing the workload across multiple machines.
- Flexibility: You can add, remove, or change fields in documents without having to migrate or alter the entire database.
<br><br>


## <a id="configuration"></a>Service Configuration

There is a `./Makefile` to manege Docker container/s from outside `./docker` directory. Inside `./docker` there are the required scripts to build the platform service.

This service platform is also developed to be managed by a parent `Makefile` by its own `./../../.env` that feeds this `./docker/.env` and others for the infrastructure platforms. Repository directories structure overview:
```sh
.
├── platforms                   # infrastructure platforms
│   │
│   ├── mongodb-8               # this platform
│   │   ├── docker
│   │   │   ├── .env            # this platform environment
│   │   │   ├── docker-compose.yml
│   │   │   └── ...etc
│   .   └── Makefile            # this platform automation
│
├── .env                        # infrastructure platforms environments
├── Makefile                    # infrastructure platforms automations
.
```

If no GNU Make is in used, create a copy from the example `./docker/.env.example` into `./docker/.env`.

Required environment variables from `./docker/.env.example` for Docker Compose:
```bash
COMPOSE_LEAD="myproj"                           # <- lead abbreviation or acronym as part of related containers naming rule -------------------------> #
COMPOSE_CNET="mp-dev"                           # <- useful for networking to connect between containers --------------------------------------------> #
COMPOSE_IMGK="alpine-3.22-mongodb-8.22"         # <- main container property for pulling and caching image into docker ------------------------------> #
COMPOSE_NAME="mp-mongodb-dev"                   # <- container name to build the service - it is important to set the environment in this variable --> #
COMPOSE_DATA="../data"                          # <- platform broker data storage in local ----------------------------------------------------------> #
COMPOSE_HOST=127.0.0.1                          # <- machine hostname referrer - not necessary for this project -------------------------------------> #
COMPOSE_CPUS=2.00                               # <- container's maximum CPUs usage to apply by docker-compose - leave it empty for full usage ------> #
COMPOSE_MEM=512M                                # <- container's maximum RAM usage to apply by docker-compose ---------------------------------------> #
COMPOSE_SWAP=1G                                 # <- container's RAM swap space in storage executed by automation command ---------------------------> #
COMPOSE_PORT=7711                               # <- local machine port opened for container service ------------------------------------------------> #
COMPOSE_APP_IMGK="mongo-express"                # <- container property for the database client for pulling and caching image into docker -----------> #
COMPOSE_APP_PORT=7712                           # <- database client port ---------------------------------------------------------------------------> #
MONGO_INITDB_DATABASE=dev_local                 # <- database name ----------------------------------------------------------------------------------> #
MONGO_INITDB_ROOT_USERNAME=devuser              # <- database root user -----------------------------------------------------------------------------> #
MONGO_INITDB_ROOT_PASSWORD="devpass"            # <- database root password -------------------------------------------------------------------------> #
COMPOSE_APP_IMGK="mongo-express"                # <- container property for the database client for pulling and caching image into docker -----------> #
COMPOSE_APP_CPUS=1.00                           # <- client's container maximum CPUs usage to apply by docker-compose - empty for full usage --------> #
COMPOSE_APP_MEMO=128M                           # <- client's container maximum RAM usage to apply by docker-compose --------------------------------> #
COMPOSE_APP_SWAP=256M                           # <- client's container RAM swap space in storage executed by automation command --------------------> #
COMPOSE_APP_PORT=7712                           # <- local machine port opened for client's container service client --------------------------------> #
MONGODB_EXPRESS_USERNAME=admuser                # <- database client first user account -------------------------------------------------------------> #
MONGODB_EXPRESS_PASSWORD="admpass"              # <- database client first user password ------------------------------------------------------------> #
COMPOSE_IGNORE_ORPHANS=true                     # <- ignore docker warnings messages when client is in used -----------------------------------------> #
```

* **Ignore Orphans**:<br>
This Mongo DB platform has been developed for optionally using it with a database client like Mongo Express. By avoiding the usage of `--remove-orphans` flag while building the container, it prevents to remove Mongo DB container but terminal will show a warning message. To prevent that known message, the `.env` file has a constant value set to true `COMPOSE_IGNORE_ORPHANS=true` by default if using `./Makefile` for automation

### Containers Access Modes

- Set the required environment values in `./docker/.env` from `./docker/.env.example` if no GNU Make will be applied.
- Set the required configuration files by coping and updating them depending on your project requirements.
- Container availability by building the container with `docker-composer.yml` in separated configuration layers
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

## <a id="management"></a>Service Management

To manage the container, run the GNU Make recipes
```bash
$ make help
Usage: $ make [target]
Targets:
$ make help                           shows this Makefile help message
# -------------------------------------------------------------------------------------------------
#  Environment for Mongo DB and Mongo DB Client
# -------------------------------------------------------------------------------------------------
$ make ports-check                    shows this project port availability on local machine
$ make env                            checks if docker .env file exists
$ make env-set                        sets docker .env file
# -------------------------------------------------------------------------------------------------
#  Mongo DB Container
# -------------------------------------------------------------------------------------------------
$ make info                           shows container information
$ make ssh                            enters the container shell
$ make up                             starts and recreates containers if compose config or image changed, runnning in detached mode
$ make build                          builds and ensures changes in the Dockerfile, build steps, or copied-in files are applied. Not --no-recreate
$ make network                        starts up into an existing custom network for container-to-container communication, runnning in detached mode
$ make start                          starts the container and put on running
$ make stop                           stops the running container but data will not be destroyed
$ make restart                        restarts the running container
$ make clear                          removes container from Docker running containers
$ make destroy                        delete container image from Docker cache
$ make dev                            sets a development enviroment
# -------------------------------------------------------------------------------------------------
#  Mongo DB Container
# -------------------------------------------------------------------------------------------------
$ make info-client                    shows client container information
$ make ssh-client                     enters the client container shell
$ make up-client                      starts and recreates containers if compose config or image changed, runnning in detached mode
$ make build-client                   builds and ensures changes in the Dockerfile, build steps, or copied-in files are applied. Not --no-recreate
$ make network-client                 starts up into an existing custom network for container-to-container communication, runnning in detached mode
$ make start-client                   starts the client container and put on running
$ make stop-client                    stops the running client container but data will not be destroyed
$ make restart-client                 restarts the running client container
$ make clear-client                   removes client container from Docker running containers
$ make destroy-client                 delete client container image from Docker cache
$ make dev-client                     sets a development enviroment
```
<br><br>

---

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
    <img src="./../../resources/docs/images/pr-banner-long.png">
</div>