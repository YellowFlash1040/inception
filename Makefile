YML_FILE 			:= ./srcs/docker-compose.yml
WP_DATA_FOLDER		:= /home/akovtune/data/wordpress
MARIADB_DATA_FOLDER	:= /home/akovtune/data/mariadb

all: up

prepare:
	mkdir -p ${MARIADB_DATA_FOLDER}
	mkdir -p ${WP_DATA_FOLDER}

up:
	docker compose -f $(YML_FILE) up -d --build

down:
	docker compose -f $(YML_FILE) down

clean: down
	docker rm -f $$(docker ps -aq) 2>/dev/null || true

fclean: clean
	docker image rm $$(docker images -aq) 2>/dev/null || true
	docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	rm -rf ${WP_DATA_FOLDER}/*
	rm -rf ${MARIADB_DATA_FOLDER}/*

re: fclean all

.PHONY: all prepare up down clean fclean re