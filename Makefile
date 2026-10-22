COMPOSE = docker compose -f srcs/docker-compose.yml
DATA    = /home/austunso/data

all:
	@mkdir -p $(DATA)/mariadb $(DATA)/wordpress
	@$(COMPOSE) up -d --build

clean:
	@$(COMPOSE) down

fclean:
	@$(COMPOSE) down -v --rmi all
	@sudo rm -rf $(DATA)

re: fclean all

.PHONY: all clean fclean re
