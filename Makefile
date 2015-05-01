pull:
	git pull

stop:
	killall unicorn 2> /dev/null
	killall puma 2> /dev/null
	killall ruby
gitpush:
	git add --all
	git commit -m 'added something automatically'
	git push

unicorn: pull
	unicorn -D

puma: pull stop
	rackup -s puma -p 8080 --host 0.0.0.0 -D

webrick: pull stop
	rackup -s webrick -p 8080 --host 0.0.0.0 -D

thin: pull stop
	rackup -s thin -p 8080 --host 0.0.0.0 -D
