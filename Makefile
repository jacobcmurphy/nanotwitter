pull:
	git pull

stop:
	thin stop

start: thin
	echo "NanoTwitter Started"
	
gitpush:
	git add --all
	git commit -m 'added something automatically'
	git push

unicorn: pull stop
	unicorn -D

puma: pull stop
	rackup -s puma -p 8080 --host 0.0.0.0 -D

webrick: pull stop
	rackup -s webrick -p 8080 --host 0.0.0.0 -D

thin: pull stop
	thin start -p 8080 -d
