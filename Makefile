build:
	docker build -t dergachev/screengif .

cmd=/bin/bash
docker-run:
	docker run -t -i \
		-v `pwd`:/srv/screengif \
		dergachev/screengif \
		/bin/bash -c "umask 002; $(cmd) $(args)"

docker-convert:
	$(MAKE) docker-run cmd="ruby screengif.rb" args="$(args)"

docker-shell:
	$(MAKE) docker-run cmd="/bin/bash"
