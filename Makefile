YML_FILE := ./srcs/docker-compose.yml

all: prepare up

prepare:
	sudo mkdir -p /home/user/inception/data/mariadb
	sudo mkdir -p /home/user/inception/data/wordpress

up:
	sudo docker compose -f $(YML_FILE) up -d --build

down:
	sudo docker compose -f $(YML_FILE) down

clean: down
	sudo docker rm -f $$(sudo docker ps -aq) 2>/dev/null || true

fclean: clean
	sudo docker image rm $$(sudo docker images -aq) 2>/dev/null || true
	sudo docker volume rm $$(sudo docker volume ls -q) 2>/dev/null || true

re: fclean all

.PHONY: all prepare up down clean fclean re