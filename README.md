# install.surrealdb.com

SurrealDB is designed to be simple to install and simple to run - using just one command from your terminal. In addition to traditional installation, SurrealDB can be installed and run with HomeBrew, Docker, or using any other container orchestration tool such as Docker Compose, Docker Swarm, Rancher, or in Kubernetes. Visit the [SurrealDB install page](https://surrealdb.com/install) for more information.

This repository houses the unix install script located at [install.surrealdb.com](https://install.surrealdb.com). It installs the SurrealDB command-line tools and database server,  automatically detecting the host operating platform, and cpu architecture type, and downloading the latest binary for the relevant platform.

The easiest and preferred way to get going with SurrealDB on Unix operating systems is to run the following command in your terminal and follow any on-screen instructions.

```bash
curl -sSf https://install.surrealdb.com | sh
```