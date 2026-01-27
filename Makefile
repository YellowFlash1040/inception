YML_FILE := ./srcs/docker-compose.yml

all: up

up:
	sudo docker compose -f $(YML_FILE) up -d