YML_FILE := ./srcs/docker-compose.yml

all: prepare up

prepare:
	mkdir -p /home/akovtune/inception/data/mariadb
	mkdir -p /home/akovtune/inception/data/wordpress

up:
	docker compose -f $(YML_FILE) up -d --build

down:
	docker compose -f $(YML_FILE) down

clean: down
	docker rm -f $$(docker ps -aq) 2>/dev/null || true

fclean: clean
	docker image rm $$(docker images -aq) 2>/dev/null || true
	docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	rm -rf data/wordpress/*
	rm -rf data/mariadb/*

re: fclean all

.PHONY: all prepare up down clean fclean re