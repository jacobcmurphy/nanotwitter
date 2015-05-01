require 'sequel'

module Database
  def DB
    @store ||= Sequel.connect(adapter: 'postgres', host: 'localhost', database: 'postgres', user: 'edenzik')
    @store
  end
end
