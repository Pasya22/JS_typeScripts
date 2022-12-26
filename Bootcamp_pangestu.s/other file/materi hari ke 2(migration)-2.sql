-- create locations
create table locations(
	location_id serial,
	constraint location_id_pk 
	primary key (location_id) 
)

-- create suppliers
create table suppliers(
	supr_id serial,
	supr_name varchar(40),
	supr_contact_name varchar(30),
	supr_city varchar(15),
	supr_location_id int,

	constraint supr_id_pk primary key (supr_id),
	constraint supr_location_id_fk foreign key (supr_location_id) references locations (location_id)
)
-- create customers
create table customers(
	cust_id serial,
	cust_name varchar(40),
	cust_city varchar(15),
	cust_location_id int,

	constraint cust_id_pk primary key (cust_id),
	constraint cust_location_id_fk foreign key (cust_location_id) references locations (location_id) 
)
-- create employees
create table employees(
employee_id serial,
constraint employee_id_pk primary key (employee_id)

)

-- create shippers
create table shippers(
	ship_id serial,
	ship_name varchar(45),
	ship_phone varchar(26),
	constraint ship_id_pk primary key (ship_id)
)

-- create orders
create table orders(
	order_id serial,
	order_date date,
	order_required_date date,
	order_shipped_date date,
	order_freight money,
	order_subtotal money,
	order_total_qty smallint,
	order_ship_qty varchar(18),
	order_ship_address varchar(60),
	order_status varchar(18),
	order_employee_id int,
	order_cust_id int,
	order_ship_id int,
	
	constraint order_id_pk primary key (order_id),
	constraint order_employee_id_pk foreign key (order_id) references employees(employee_id) ,
	constraint order_cust_id_fk foreign key (cust_id) references customers(cust_id),
	constraint order_ship_id_fk foreign key (ship_id) references shippers(ship_id)
)

-- create products
create table products(
	prod_id int,
	prod_name varchar(40),
	prod_quantity varchar(25),
	prod_price money,
	prod_in_stock smallint,
	prod_on_order smallint,
	prod_reorder_level smallint,
	prod_discontuned bit,
	prod_cate_id int,
	prod_supr_id int,

	constraint prod_id_pk primary key(prod_id),
	constraint prod_cate_id_fk foreign key(prod_cate_id) references categories(cate_id) ,
	constraint prod_supr_id_fk foreign key(prod_supr_id) references suppliers(supr_id)
)

-- create orders_detail
create table orders_detail(
	ordet_order_id int,
	ordet_prod_id int,
	ordet_price money,
	ordet_quantity smallint,
	ordet_discount real,
	constraint ordet_prod_order_id_pk primary key(ordet_order_id,ordet_prod_id),
	constraint ordet_order_id_fk foreign key(ordet_order_id) references orders(order_id) on delete cascade on update cascade ,
	constraint ordet_prod_id_fk foreign key(ordet_prod_id) references products(prod_id) on delete cascade on update cascade
)

-- create categories
create table categories(
	cate_id serial,
	cate_name varchar,
	cate_description text,

	constraint cate_id_pk primary key(cate_id)
)


