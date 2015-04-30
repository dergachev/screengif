build:
	docker build -t dergachev/screengif .

cmd=/bin/bash
docker-run:
	docker run -t -i \
		-v `pwd`:/srv/screengif \
		dergachev/screengif \
		/bin/bash -c "umask 002; $(cmd) $(args)"

docker-bash:
	$(MAKE) docker-run cmd="/bin/bash"

docker-convert:
	$(MAKE) docker-run cmd="bin/screengif" args="$(args)"

docker-shell:
	$(MAKE) docker-run cmd="/bin/bash"

.PHONY: build docker-run docker-convert docker-shell
