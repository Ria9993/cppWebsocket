NAME = inception

all : $(NAME)
$(NAME) :
	sudo mkdir -p /home/hyunjunk/data/db
	sudo mkdir -p /home/hyunjunk/data/wp
	sudo chmod 777 /etc/hosts
	docker compose --env-file srcs/.env -f srcs/docker-compose.yml up --build -d

clean :
	docker compose -f srcs/docker-compose.yml down --remove-orphans --volumes --rmi all

ps :
	docker compose -f srcs/docker-compose.yml ps

logs :
	docker compose -f srcs/docker-compose.yml logs --follow

fclean : clean
	sudo rm -rf /home/hyunjunk/data
	docker system prune --volumes --all --force
	docker network prune --force
	docker volume prune --force

re : fclean all

restart :
	docker compose -f srcs/docker-compose.yml restart


.PHONY : all clean ps log fclean re restart
