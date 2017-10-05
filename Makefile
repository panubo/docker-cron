NAME = panubo/cron

.PHONY: help bash run build push
help:
	@printf "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)\n"

bash: empty ## Runs a bash shell in the docker image
	docker run --rm -it -v $(PWD)/empty:/crontab $(NAME):latest bash

empty:
	touch empty

run: empty ## Runs the docker image in a test mode
	docker run --name cron --rm -it -v $(PWD)/empty:/crontab $(NAME):latest

build: ## Builds docker image latest
	docker build --pull -t $(NAME):latest .

push: ## Pushes the docker image to hub.docker.com
	# Don't --pull here, we don't want any last minute upsteam changes
	docker build -t $(NAME):latest .
	docker tag $(NAME):latest docker.io/$(NAME):latest
	docker push docker.io/$(NAME):latest
