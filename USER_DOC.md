# User Documentation

## Services

| Service | Role |
|---|---|
| **NGINX** | HTTPS web server and the only entry point (port 443) |
| **WordPress + php-fpm** | Runs the website |
| **MariaDB** | Stores the website's database |

## Starting and stopping

From the root of the repository:

```bash
make          # start
make clean    # stop (website content is kept)
```

After `make`, wait a few seconds before opening the site. If it shows `403` or `502`, WordPress is still starting.

`make fclean` deletes everything, including all website content.

## Accessing the website

- Website: <https://austunso.42.fr>
- Administration panel: <https://austunso.42.fr/wp-admin>

The certificate is self-signed, so the browser shows a warning. Choose **Advanced**, then **Accept the risk and continue**.

## Credentials

User names are in `srcs/.env`, passwords in `secrets/`:

| Account | User name | Password file |
|---|---|---|
| WordPress administrator | `WP_ADMIN_USER` | `secrets/wp_admin_password.txt` |
| WordPress second user | `WP_USER` | `secrets/wp_user_password.txt` |
| Database user | `MYSQL_USER` | `secrets/db_password.txt` |
| Database root | `root` | `secrets/db_root_password.txt` |

These files are not in Git. Passwords are applied only on the first install. Later, WordPress passwords can be changed from the administration panel; to apply new values from `secrets/` to everything, reinstall with `make re` (this erases all content).

## Checking that everything works

```bash
docker compose -f srcs/docker-compose.yml ps   # all three "Up", mariadb "(healthy)"
curl -kI https://austunso.42.fr                # HTTP/1.1 200 OK
```

To check the database:

```bash
docker exec -it mariadb mariadb -u root -p
```

```sql
USE mysqldb;
SHOW TABLES;
SELECT ID, user_login FROM wp_users;
```
