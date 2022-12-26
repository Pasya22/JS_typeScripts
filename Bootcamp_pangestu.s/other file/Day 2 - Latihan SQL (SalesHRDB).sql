create table Suppliers (
	supr_id serial,
	supr_name varchar (40),
	supr_contact_name varchar(30),
	supr_city varchar (15),
	constraint pk_supr_id primary key (supr_id)
);

create table Customers (
	cust_id serial,
	cust_name varchar(40),
	cust_city varchar(15),
	constraint pk_cust_id primary key (cust_id)
);

create table Shippers (
	ship_id serial,
	ship_name varchar(40),
	ship_phone varchar(24),
	constraint pk_ship_id primary key (ship_id)
);

create table Categories (
	cate_id serial,
	cate_name varchar (15),
	cate_description text,
	constraint pk_cate_id primary key (cate_id)
);

create table Products (
	prod_id serial,
	prod_name varchar (40),
	prod_quantity varchar (20),
	prod_price money,
	prod_in_stock smallInt,
	prod_on_order smallInt,
	prod_reorder_level smallInt,
	prod_discontinued bit,
	prod_cate_id int,
	prod_supr_id int,
	constraint pk_prod_id primary key (prod_id),
	constraint fk_prod_cate_id foreign key (prod_cate_id) references Categories (cate_id) on delete cascade on update cascade,
	constraint fk_prod_supr_id foreign key (prod_supr_id) references Suppliers (supr_id) on delete cascade on update cascade
);

create table Orders (
	order_id serial,
	order_date timestamp,
	order_required_date timestamp,
	order_shipped_date timestamp,
	order_freight money,
	order_subtotal money,
	order_total_qty smallInt,
	order_ship_city varchar(15),
	order_ship_address varchar(60),
	order_status varchar(15),
	order_cust_id int,
	order_ship_id int,
	constraint pk_order_id primary key (order_id),
	constraint fk_order_cust_id foreign key (order_cust_id) references Customers(cust_id) on delete cascade on update cascade,
	constraint fk_order_ship_id foreign key (order_ship_id) references Shippers(ship_id) on delete cascade on update cascade
);

create table Orders_detal (
	ordet_order_id int,
	ordet_prod_id int,
	ordet_price money,
	ordet_quantity smallInt,
	ordet_discount real,
	constraint pk_ordet_id primary key (ordet_order_id, ordet_prod_id),
	constraint fk_ordet_order_id foreign key (ordet_order_id) references Orders(order_id) on delete cascade on update cascade,
	constraint fk_ordet_prod_id foreign key (ordet_prod_id) references Products(prod_id) on delete cascade on update cascade
)
	

create extension dblink

create foreign data wrapper postgres;
create server localhost foreign data wrapper postgres options (hostaddr '127.0.0.1', dbname 'NorthwindDB')

create user mapping for postgres server localhost options (user 'postgres', password 'cokiesiagian')

select dblink_connect('localhost')

insert into shippers(ship_id,ship_name,ship_phone)
select * from dblink
('localhost', 'select shipper_id,company_name,phone from shippers')
as data (ship_id Int,ship_name varchar(40), ship_phone varchar(24))
select * from shippers

insert into customers(cust_id, cust_name, cust_city)
select * from dblink
('localhost', 'select customer_id, company_name, city from customers ')
as data (cust_id char(5), cust_name varchar(40), cust_city varchar(15))
select * from customers

insert into Suppliers(supr_id, supr_name, supr_contact_name, supr_city)
select * from dblink
('localhost', 'select supplier_id, company_name, contact_name, city from suppliers')
as data (supr_id int, supr_name varchar(40), supr_contact_name varchar(30), supr_city varchar(15))
select * from suppliers

insert into categories(cate_id, cate_name, cate_description)
select * from dblink
('localhost', 'select category_id, category_name, description from categories')
as data (cate_id int, cate_name varchar(15), cate_description text)
select * from categories

insert into products(prod_id, prod_name, prod_quantity, prod_price, prod_in_stock, prod_on_order, prod_reorder_level, prod_discontinued, prod_cate_id, prod_supr_id)
select * from dblink
('localhost', 'select product_id, product_name, quantity_per_unit, unit_price, units_in_stock, units_on_order, reorder_level, discontinued, category_id, supplier_id from products')
as data (prod_id int, prod_name varchar (40), prod_quantity varchar (20), prod_price money, prod_in_stock smallInt, prod_on_order smallInt, prod_reorder_level smallInt, prod_discontinued bit, prod_cate_id int, prod_supr_id int)
select * from products

insert into orders(order_id, order_date, order_required_date, order_shipped_Date, order_freight, order_subtotal, order_total_qty, order_ship_city, order_ship_address, order_employee_id, order_ship_id, order_cust_id)
select * from dblink
('localhost', 'select o.order_id, order_date, required_date, shipped_date, freight, (sum(unit_price)*sum(quantity))as order_subtotal, sum(quantity) as order_total_qty, ship_city, ship_address, employee_id, ship_via, customer_id from orders o inner join order_details r on o.order_id=r.order_id
group by o.order_id')
as data (order_id int , order_date timestamp, order_required_date timestamp, order_shipped_Date timestamp, order_freight money, order_subtotal money, order_total_qty smallInt, order_ship_city varchar(15), order_ship_address varchar(60), order_employee_id smallInt,  order_ship_id smallInt, order_cust_id char(5))
select * from orders

insert into orders_detail (ordet_order_id, ordet_prod_id, ordet_price, ordet_quantity, ordet_discount)
select * from dblink
('localhost', 'select order_id, product_id, unit_price, quantity, discount from order_details')
as data (ordet_order_id int, ordet_prod_id int, ordet_price money, ordet_quantity smallInt, ordet_discount real)
select * from orders_detail



