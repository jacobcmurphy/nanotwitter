
COPY users(id, username, email, password) FROM '/Users/edenzik/nanotwitter/db/seed_data/users_output.csv' DELIMITER ',' CSV;

COPY tweets(user_id, text, created) FROM '/Users/edenzik/nanotwitter/db/seed_data/tweets.csv' DELIMITER ',' CSV;

COPY following(follower,followee) FROM '/Users/edenzik/nanotwitter/db/seed_data/follows.csv' DELIMITER ',' CSV;
