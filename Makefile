run:
	killall unicorn 2>/dev/null
	git pull
	unicorn config.ru &

gitpush:
	git add --all
	git commit -m 'added something automatically'
	git push
