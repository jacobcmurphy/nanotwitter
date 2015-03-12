configure :production, :development do

	db = URI.parse(ENV['DATABASE_URL'])
 
	ActiveRecord::Base.establish_connection(
			:adapter => db.scheme,
			:host     => db.host,
			:database => db.path[1..-1],
			:encoding => 'utf8'
	)
end

configure :test do

	db = URI.parse('db/test.sqlite3')
 
	ActiveRecord::Base.establish_connection(
			:adapter => db.scheme,
			:host     => db.host,
			:database => db.path[1..-1],
			:encoding => 'utf8'
	)
end
