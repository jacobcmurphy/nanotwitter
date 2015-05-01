require 'sequel'

module Database
  DB = Sequel.connect(adapter: 'postgres', host: 'localhost', database: 'postgres', user: 'edenzik')
end
