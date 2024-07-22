NAME = inception

all : $(NAME)
$(NAME) :
	sudo mkdir -p /home/hyunjunk/vol_inception/data/db
	sudo mkdir -p /home/hyunjunk/vol_inception/data/wp
	sudo chmod 777 /etc/hosts
	sudo echo "127.0.0.1 hyunjunk.42.fr" >> /etc/hosts
	docker compose --env-file srcs/.env -f srcs/docker-compose.yml up --detach


build :
	sudo mkdir -p /home/hyunjunk/vol_inception/data/db
	sudo mkdir -p /home/hyunjunk/vol_inception/data/wp
	docker compose --env-file srcs/.env -f srcs/docker-compose.yml up --build --detach

clean :
	docker compose -f srcs/docker-compose.yml down --remove-orphans --volumes --rmi all

ps :
	docker compose -f srcs/docker-compose.yml ps

logs :
	docker compose -f srcs/docker-compose.yml logs --follow

fclean : clean
	sudo rm -rf /home/hyunjunk/vol_inception/data
	docker system prune --volumes --all --force
	docker network prune --force
	docker volume prune --force
	sudo sed -i "/127.0.0.1 hyunjunk.42.fr/d" /etc/hosts

re : fclean all

restart :
	docker compose -f srcs/docker-compose.yml restart


.PHONY : all clean ps log fclean re restart build
