--  migration database (postgreSql)
create extension dblink

-- create wrapper postgres
create foreign data wrapper postgres;

--  create server 
create server localhost 
	foreign data wrapper postgres
		options (hostaddr '127.0.0.1' , dbname 'NorthwindDB');

-- create server user wrpper
create user mapping for postgres
	server localhost
		options (user 'postgres', password 'pgadmin')

-- connection 
select dblink_connect('localhost')

-- input data 
insert into shippers(ship_id,ship_name,ship_phone)

-- GET DATA 
select * from dblink(
'localhost',
'select shipper_id,
company_name,
phone from shippers'
) AS DATA (
	ship_id integer,
	ship_name varchar(60),
	ship_phone varchar(26)
)
select * from shippers