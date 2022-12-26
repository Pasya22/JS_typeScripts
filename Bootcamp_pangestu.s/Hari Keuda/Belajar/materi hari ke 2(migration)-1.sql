-- create categories
create table categories(
	category_id smallint,
	category_name varchar(15),
	description text,
	picture bytea,
	constraint category_id_pk primary key (category_id)
	
)
-- create supplier
create table supplier(
	supplier_id smallint,
	company_name varchar(45),
	contact_name varchar(30),
	contact_title varchar(30),
	address text,
	city varchar(30),
	region varchar(30),
	postal_code varchar(30),
	country varchar(30),
	phone varchar(30),
	fax varchar(30),
	homepage text,
	constraint supplier_id_pk primary key (supplier_id)
) 

-- create products 
create table products(
	product_id smallint,
	product_name varchar(40),
	quantity_per_unit varchar(30),
	unit_price real,
	unit_in_stock smallint,
	unit_in_order smallint,
	reorder_level smallint,
	discountinued int,
	supplier_id smallint,
	category_id smallint,
	constraint product_id_pk primary key (product_id),
	constraint category_id_fk foreign key (category_id) references categories (category_id),
	constraint supplier_id_fk foreign key (supplier_id) references supplier (supplier_id)
)
-- create employees 
create table employees(
	employee_id smallint,
	last_name varchar(20),
	fisrt_name varchar(50),
	title varchar(50),
	title_of_courtesy varchar(50),
	birth_date date,
	hire_date date,
	address varchar(50),
	city varchar(50),
	region varchar(50),
	postal_code varchar(50),
	country varchar(50),
	home_phone varchar(50),
	extension varchar(50),
	photo bytea,
	notes text,
	reports_to smallint,
	photo_path varchar(255),

	constraint employee_id_pk primary key (employee_id)
	-- constraint employee_id_fk foreign key (employee_id) references employees (employee_id),
	-- constraint customer_id_fk foreign key (customer_id) references customers (customer_id),
	-- constraint shipper_id_fk foreign key (shipper_id) references shippers (shipper_id)
)

-- create shippers
create table shippers(
	shipper_id smallint,
	company_name varchar(59),
	phone varchar(26),

	constraint shipper_id_pk primary key (shipper_id)

)

-- create customers
create table customers(
	customer_id char(5),
	company_name varchar(40),
	contact_name varchar(40),
	contact_title varchar(40),
	address varchar(89),
	city varchar(40),
	region varchar(40),
	postal_code varchar(40),
	country varchar(40),
	phone varchar(40),
	fax varchar(40),

	constraint customer_id_pk primary key (customer_id)
)
-- alter table customers add column contact_title varchar(50)
-- create orders 
create table orders(
	order_id smallint,
	required_date date,
	shipped_date date,
	freight real,
	ship_name varchar(50),
	ship_address varchar(50),
	ship_city varchar(50),
	ship_region varchar(50),
	ship_postal_code varchar(50),
	ship_country varchar(50),
	employee_id smallint,
	customer_id char(5),
	ship_via smallint,
	constraint order_id_pk primary key (order_id),
	constraint employee_id_fk foreign key (employee_id) references employees (employee_id),
	constraint customer_id_fk foreign key (customer_id) references customers (customer_id),
	constraint ship_via_fk foreign key (ship_via) references shippers (shipper_id)
)


-- create order_detail
create table order_detail(
	order_id smallint,
	product_id smallint,
	unit_price real,
	discount real,
	constraint order_id_product_id_pk primary key (order_id,product_id),
	constraint order_id_fk foreign key (order_id) references orders (order_id) on delete cascade on update cascade,
	constraint product_id_fk foreign key (product_id) references products (product_id)on delete cascade on update cascade	
)


