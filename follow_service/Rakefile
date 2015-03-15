require 'active_record'
require 'sinatra/activerecord/rake'
require 'yaml'
require 'rake/testtask'

namespace :db do
	desc "Load the environment"
	task :environment do
		env = ENV["SINATRA_ENV"] || "development"
		databases = YAML.load_file("config/database.yml")
		ActiveRecord::Base.establish_connection(databases[env])
	end

	desc "Migrate the database"
	task :migrate => :environment do
		ActiveRecord::Base.logger = Logger.new(STDOUT)
		ActiveRecord::Migration.verbose = true
		ActiveRecord::Migrator.migrate("db/migrate")
	end
end


Rake::TestTask.new do |t|
	ENV['RACK_ENV']="test"
	t.libs << "test"
	t.test_files = FileList['test/test*.rb']
	t.verbose = true
end
