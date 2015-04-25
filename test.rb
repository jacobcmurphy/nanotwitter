require 'sequel'
require 'json'

DB = Sequel.connect('sqlite://db/development.sqlite3')
puts DB[:users].first.to_json

Sequel.migration do
  up do
    create_table(:artists) do
      primary_key :id
      String :name, :null=>false
    end
  end

  down do
    drop_table(:artists)
  end
end
