require 'active_record'
require 'sinatra/activerecord/rake'
require 'yaml'
require 'rake/testtask'

namespace :db do
	desc "Load the environment"
	task :environment do
		env = ENV["SINATRA_ENV"] || "development"
		databases = YAML.load(ERB.new(File.read(File.join("config","database.yml"))).result)
		ActiveRecord::Base.establish_connection(databases[env])
	end

	desc "Migrate the database"
	task :migrate => :environment do
		ActiveRecord::Base.logger = Logger.new(STDOUT)
		ActiveRecord::Migration.verbose = true
		ActiveRecord::Migrator.migrate("db/migrate")
	end
end

task(:test => ["db:migrate", :spec]) do
end

Rake::TestTask.new(:spec) do |t|
	#env = "test"
	t.libs << "spec"
	t.test_files = FileList['spec/**/*_spec.rb']
	t.verbose = true
end

namespace :app do
  desc "Run the app in dev mode"
  task(:run => [:environment, "db:migrate"]) do
    `rackup`
  end
end
