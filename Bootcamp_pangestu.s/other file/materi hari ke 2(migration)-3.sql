--  migration database (postgreSql)
create extension dblink;

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

input data shippers salesDB 
insert into shippers (ship_id,ship_name,ship_phone)
Get Data Migration Northwind to sales 
select * from dblink('localhost',
					 'select shipper_id,
					 company_name,
					 phone from shippers') 
AS DATA (
	ship_id integer,
	ship_name varchar(60),
	ship_phone varchar(26)
)

-- input data shippers salesDB 
insert into suppliers (supr_id,supr_name,supr_contact_name,supr_city)

-- Get Data Migration Northwind to sales 
select * from dblink('localhost',
					 'select supplier_id,company_name,
					 contact_name,
					 city from suppliers')
as data (supr_id integer,
		 supr_name varchar(45),
		 supr_contact_name varchar(45),
		 supr_city varchar(45))

-- input data customers salesDB 
insert into customers (cust_id,cust_name,cust_city)

-- Get Data Migration Northwind to sales 
select * from dblink('localhost',
					 'select customer_id,contact_name,city from customers ')
as data (cust_id char(5),
		 cust_name varchar(45),
		 cust_city varchar(18) )

-- input data customers salesDB 
insert into customers (cust_id,cust_name,cust_city)

-- Get Data Migration Northwind to sales 
select * from dblink('localhost',
					 'select customer_id,contact_name,city from customers ')
as data (cust_id char(5),
		 cust_name varchar(45),
		 cust_city varchar(18) )
		 
-- input data NortwindDB to salesDB 
insert into categories (cate_id,cate_name,cate_description)

-- Get Data Migration Northwind to sales 
select * from dblink('localhost',
					 'select category_id,category_name,description from categories ')
as data (cate_id smallint,
		 cate_name varchar(45),
		 cate_description text )

-- GET DATA 
select * from categories
