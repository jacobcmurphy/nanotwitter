#!/usr/bin/env ruby 

exec('(cd frontend; ./cors-serve &) && (cd follow_service; rackup -p 4569 &) && (cd user_service; rackup -p 4567 &) && (cd tweet_service; rake app:run &)')
