require 'pg'
conn = PG::Connection.open(:dbname => 'test')

res = conn.exec("select 1;")

puts res.hash()
