# Developer Documentation

## Setting up the environment

### Prerequisites

- A Linux virtual machine with a user named `austunso` and `sudo` rights
- Docker, Docker Compose and `make`
- The domain mapped to the local machine:

```bash
echo "127.0.0.1 austunso.42.fr" | sudo tee -a /etc/hosts
```

### Configuration file

`srcs/.env` holds the non-secret settings. It is not in Git, so create it after cloning:

```bash
cat > srcs/.env << 'EOF'
DOMAIN_NAME=austunso.42.fr

MYSQL_DATABASE=your_database_name
MYSQL_USER=your_database_user

WP_TITLE=Inception
WP_ADMIN_USER=your_admin_name
WP_ADMIN_EMAIL=admin@example.com
WP_USER=your_second_user
WP_USER_EMAIL=user@example.com
EOF
```

- `WP_ADMIN_USER` must not contain `admin` or `administrator`.
- The two e-mail addresses must be different.

### Secrets

Each file in `secrets/` holds one password. The folder is not in Git, so create it after cloning:

```bash
mkdir -p secrets
printf '%s' 'your-db-root-password'  > secrets/db_root_password.txt
printf '%s' 'your-db-password'       > secrets/db_password.txt
printf '%s' 'your-wp-admin-password' > secrets/wp_admin_password.txt
printf '%s' 'your-wp-user-password'  > secrets/wp_user_password.txt
chmod 600 secrets/*.txt
```

## Building and launching

```bash
make          # create the data folders, build the images and start the containers
make clean    # stop and remove the containers (data is kept)
make fclean   # remove containers, images, volumes and all data
make re       # fclean + make
```

`make` runs `docker compose -f srcs/docker-compose.yml up -d --build`. On the first start, MariaDB creates the database and its users, and WordPress downloads, configures and installs the site. Later starts skip these steps.

## Managing containers and volumes

```bash
docker compose -f srcs/docker-compose.yml ps                      # status of the containers
docker compose -f srcs/docker-compose.yml stop                    # stop all containers
docker compose -f srcs/docker-compose.yml start                   # start them again
docker compose -f srcs/docker-compose.yml restart <service>       # restart one service
docker compose -f srcs/docker-compose.yml up -d --build <service> # rebuild one service after a change
docker exec -it <container-name> <executable-name>                # start a new process in a container
docker exec -it mariadb mariadb -u root -p                        # database shell
docker inspect <container-name>                                   # container details (mounts, network, env)
docker volume ls                                                  # list volumes
docker volume inspect <volume-name>                               # volume details
```

## Data storage and persistence

| Data | Named volume | Container path | Host path |
|---|---|---|---|
| Database | `mariadb_data` | `/var/lib/mysql` | `/home/austunso/data/mariadb` |
| WordPress files | `wordpress_data` | `/var/www/html` | `/home/austunso/data/wordpress` |

- Both are named volumes whose data is stored in `/home/austunso/data` on the host.
- Data is kept after `make clean`, container restarts and VM reboots.
- Only `make fclean` (and `make re`) deletes the data.
