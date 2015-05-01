rerun: 
	killall unicorn
	run
run:
	git pull
	unicorn config.ru &

gitpush:
	git add --all
	git commit -m 'added something automatically'
	git push
