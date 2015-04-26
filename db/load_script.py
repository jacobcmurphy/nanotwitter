import csv
import psycopg2

print 'hello'


users = csv.DictReader(open("seed_data/users.csv"), ["id","username"])

users_mock = csv.DictReader(open("seed_data/mock_users.csv"), ["email","password"])

output_users = csv.writer(open("seed_data/users_output.csv", 'w'), delimiter=',')


hey = 0
for row in users:
    row.update(users_mock.next())
    output_users.writerow(row['username'])
    #print users_mock.next()






