# install.surrealdb.com

SurrealDB is designed to be simple to install and simple to run - using just one command from your terminal. In addition to traditional installation, SurrealDB can be installed and run with HomeBrew, Docker, or using any other container orchestration tool such as Docker Compose, Docker Swarm, Rancher, or in Kubernetes. Visit the [SurrealDB install page](https://surrealdb.com/install) for more information.

This repository houses the install script located at [install.surrealdb.com](https://install.surrealdb.com). It installs the SurrealDB command-line tools and database server, automatically detecting the host operating platform, and cpu architecture type - then downloads the latest binary for the relevant platform.

If you prefer not using a package manager or Docker, then the easiest and preferred way to get going with SurrealDB is to run one of the following commands in your terminal.

### Latest release

#### Install on macOS / Unix / Linux

```bash
curl --proto '=https' --tlsv1.2 -sSf https://install.surrealdb.com | sh
```

### Beta release

#### Install on macOS / Unix / Linux

```bash
curl --proto '=https' --tlsv1.2 -sSf https://install.surrealdb.com | sh -s -- --beta
```

### Alpha release

#### Install on macOS / Unix / Linux

```bash
curl --proto '=https' --tlsv1.2 -sSf https://install.surrealdb.com | sh -s -- --alpha
```

### Nightly release

#### Install on macOS / Unix / Linux

```bash
curl --proto '=https' --tlsv1.2 -sSf https://install.surrealdb.com | sh -s -- --nightly
```
