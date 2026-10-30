*This project has been created as part of the 42 curriculum by austunso.*

# Inception

## Description

Inception sets up a small web infrastructure with Docker Compose inside a virtual machine. It consists of three services, each running in its own container.

General view of the project:

```
Browser ──443 (TLS 1.2/1.3)──▶ NGINX ──9000──▶ WordPress + php-fpm ──3306──▶ MariaDB
```

### Use of Docker and sources

Each service has its own Dockerfile in `srcs/requirements/<service>/`, with its configuration in `conf/` and its startup script in `tools/`. `srcs/docker-compose.yml` defines the services, the network, two named volumes and the secrets. The `Makefile` builds and starts everything through Docker Compose.

### Design choices

- **Debian 12 (bookworm)**: the penultimate stable Debian release.
- **One service per container, running in the foreground as PID 1**: no `tail -f` or similar hacks.
- **Setup only on first run**: startup scripts skip steps already done, so restarts keep existing data.
- **Passwords as Docker secrets**, other settings in `.env`; both are kept out of Git.
- **NGINX is the only entry point**, on port 443 only.

### Virtual Machines vs Docker

A VM runs a full operating system with its own kernel. A container is an isolated process sharing the host kernel. Containers are lighter and faster to start; VMs offer stronger isolation.

### Secrets vs Environment Variables

Environment variables are visible through `docker inspect`, so they hold only non-sensitive settings here. Secrets are files mounted in `/run/secrets/` and are used for all passwords.

### Docker Network vs Host Network

With the host network, a container shares the host's network stack and exposes every port it opens. A Docker bridge network isolates containers on a private network where they reach each other by service name; only NGINX publishes a port.

### Docker Volumes vs Bind Mounts

A bind mount maps a host path directly into a container. A named volume is managed by Docker and referenced by name. This project uses named volumes whose data is stored in `/home/austunso/data`.

## Instructions

Requirements:

- Docker, Docker Compose and `make`
- `austunso.42.fr` mapped to `127.0.0.1` in `/etc/hosts`
- A user named `austunso`, since the data path `/home/austunso/data` is hardcoded.

Create `srcs/.env` and the files in `secrets/` first (see DEV_DOC.md), then:

```bash
make          # build and start
make clean    # stop (data is kept)
make fclean   # remove everything, including data
make re       # fclean + make
```

Open <https://austunso.42.fr> and accept the self-signed certificate warning.

## Resources

- <https://docs.docker.com/build/building/best-practices/>
- <https://docs.docker.com/reference/compose-file/>
- <https://docs.docker.com/compose/how-tos/use-secrets/>
- <https://docs.docker.com/engine/storage/volumes/>
- <https://nginx.org/en/docs/http/ngx_http_ssl_module.html>
- <https://www.php.net/manual/en/install.fpm.configuration.php>
- <https://developer.wordpress.org/cli/commands/>
- <https://blog.phusion.nl/docker-and-the-pid-1-zombie-reaping-problem/>

### Use of AI

AI was used to:

- Research and explain concepts such as PID 1, php-fpm, FastCGI, MariaDB authentication, Docker volumes and secrets.
- Explain the underlying Linux mechanisms (namespaces, mounts, Unix sockets, file permissions).
- Provide example Docker container usage and configurations.
- Help interpret errors and suggest test commands (TLS versions, persistence, port checks).
- Edit the documentation.
