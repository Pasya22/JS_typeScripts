Create extension dblink

create foreign data wrapper postgres;
create server localhost foreign data wrapper postgres options (hostaddr '127.0.0.1', dbname 'NorthwindDB');

--Create User Mapping Nama User Bebas, password sesuai dengan login server postgre--
create user mapping for postgres server localhost options(user 'postgres', password '11111111');
select dblink_connect('localhost');


--Migration Shippers--
insert into shippers (ship_id, ship_name, ship_phone)
select * from dblink
('localhost', 'select shipper_id, company_name, phone from shippers')
as data(ship_id integer, ship_name varchar(40), ship_phone varchar(24))

select * from shippers

--Migration Categories--
insert into categories (cate_id, cate_name, cate_description)
select * from dblink
('localhost', 'select category_id, category_name, description from categories')
as data(cate_id integer, cate_name varchar(15), cate_description text)

select * from categories

--Migration Supplier--
insert into suppliers(supr_id, supr_name, supr_contact_name, supr_city)
select * from dblink
('localhost', 'select supplier_id, company_name, contact_name, city from suppliers')
as data(supr_id int, supr_name varchar(40), supr_contact_name varchar(30), supr_city varchar(15))

select * from suppliers

--Migration Customer--
insert into customers(cust_id, cust_name, cust_city)
select * from dblink
('localhost', 'select customer_id, contact_name, city from customers')
as data(cust_id char(5), cust_name varchar(40), cust_city varchar(15))

select * from customers
alter table products add column prod_discontinued int

--Migration Products--
insert into products(prod_id, prod_name, prod_quantity, prod_price,
					 prod_in_stock, prod_on_order, prod_reorder_level, prod_discontinued,
					 prod_cate_id, prod_supr_id)
select * from dblink
('localhost', 'select product_id, product_name, quantity_per_unit, unit_price, units_in_stock, units_on_order,
 reorder_level, discontinued, category_id, supplier_id from products')
 as data(prod_id int, prod_name varchar(40), prod_quantity varchar(20), prod_price money,
					 prod_in_stock int, prod_on_order int, prod_reorder_level int, prod_discontinued int,
					 prod_cate_id int, prod_supr_id int)

select * from products

--Migration Orders--
insert into orders(order_id, order_date, order_required_date, order_shipped_date, order_freight,
				  order_subtotal, order_total_qty, order_ship_city, order_ship_address, order_employee_id, 
				  order_cust_id, order_ship_id)
select * from dblink
('localhost', 'select o.order_id, order_date, required_date, shipped_date, freight, (sum(unit_price) * sum(quantity)) subtotal,
 sum(quantity), ship_city, ship_address, employee_id, customer_id, ship_via from orders o inner join order_details od on
 o.order_id = od.order_id group by o.order_id')
 as data(order_id int, order_date timestamp, order_required_date timestamp, order_shipped_date timestamp, order_freight money,
				  order_subtotal money, order_total_qty smallint, order_ship_city varchar(15), order_ship_address varchar(60),
		 		  order_employee_id int, order_cust_id char(5), order_ship_id int)
				  
select * from orders

--Migration Order_details--
insert into orders_detail(ordet_order_id, ordet_prod_id, order_price, ordet_quantity, ordet_discount)
select * from dblink
('localhost', 'select order_id, product_id, unit_price, quantity, discount from order_details')
as data(ordet_order_id int, ordet_prod_id int, order_price money, ordet_quantity smallint, ordet_discount real)

select * from orders_detail


Alter table orders add column order_employee_id int