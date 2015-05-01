pull:
	git pull

stop:
	killall unicorn 2> /dev/null; true
	killall puma 2> /dev/null; true
	killall ruby; true
gitpush:
	git add --all
	git commit -m 'added something automatically'
	git push

unicorn: pull stop
	unicorn -D

puma: pull stop
	rackup -s puma -p 8080 --host 0.0.0.0 &> /dev/null &

webrick: pull stop
	rackup -s webrick -p 8080 --host 0.0.0.0 &> /dev/null &

thin: pull stop
	rackup -s thin -p 8080 --host 0.0.0.0 &> /dev/null &
