--ditulis di db yg mau nerima data dari database lain

create extension dblink


--awalnya ini tapi kita ubah ke foreign yg baru
create foreign data wrapper postgres; --ini nama postgres bebas namanya apa aja sesuai dgn kebutuhan
create server localhost foreign data wrapper postgres 
options (hostaddr '127.0.0.1', dbname 'nortwindb');

create foreign data wrapper ps_tamu; --ini nama postgres bebas namanya apa aja sesuai dgn kebutuhan
create server localhost foreign data wrapper ps_tamu 
options (hostaddr '127.0.0.1', dbname 'nortwindb');


create user mapping for postgres server localhost 
options(user 'postgres', password '1818')

select dblink_connect('localhost');

INSERT INTO shippers (ship_id, ship_name, ship_phone) --TABEL SINI
SELECT * FROM dblink ('localhost', 
	'SELECT shipper_id, company_name, phone from shippers') --TABEL SANA
AS DATA (ship_id integer, ship_name varchar(40), ship_phone varchar(24));

select * from shippers;

--insert ke suppliers
INSERT INTO suppliers (supr_id, supr_name, supr_contact_name, supr_city)
SELECT * FROM dblink ('localhost', 
	'SELECT supplier_id, company_name, contact_name, city FROM supplier')
AS DATA (supr_id INT, supr_name VARCHAR(40), supr_contact_name VARCHAR(30), supr_city VARCHAR (15));

SELECT * FROM suppliers


-- customers

--ubah dulu cust idnya jadi varchar(5) dan hal yg aku ubah
ALTER TABLE customers ALTER COLUMN cust_id TYPE VARCHAR(5);

ALTER TABLE customers ALTER COLUMN cust_id TYPE CHAR(5);

ALTER TABLE orders ALTER COLUMN order_cust_id TYPE CHAR(5);


ALTER TABLE orders ADD 
CONSTRAINT fk_order_cust_id FOREIGN KEY (order_cust_id) REFERENCES customers(cust_id);



INSERT INTO customers (cust_id, cust_name, cust_city)
SELECT * FROM dblink ('localhost', 
	'SELECT customer_id, contact_name, city 
					  FROM customers')
AS DATA (cust_id varchar(5), cust_name VARCHAR(40), cust_city VARCHAR(15));

SELECT * FROM customers;



-- insert categories
INSERT INTO categories (cate_id, cate_name, cate_description)
SELECT * FROM dblink ('localhost',
					 'SELECT category_id, category_name, description
					  FROM categories' )
AS DATA (cate_id INT , cate_name VARCHAR(15), cate_description TEXT);

SELECT * FROM categories;



--PRODUCT
--hal yang aku ubah
price dan discountinued

ALTER TABLE products ALTER COLUMN prod_discontinued TYPE INTEGER;

INSERT INTO products (prod_id,prod_name,prod_quantity,prod_price,prod_in_stock,prod_on_order,
					 prod_reorder_level,prod_discontinued,prod_cate_id, prod_supr_id)
SELECT * FROM dblink ('localhost',
					 'SELECT product_id,product_name,quantity_per_unit,unit_price,unit_in_stock,unit_in_order,
					  reorder_level,discontinued, category_id,supplier_id
					  FROM products' )
AS DATA (prod_id INT,prod_name VARCHAR(40),prod_quantity VARCHAR(20), prod_price MONEY,prod_in_stock SMALLINT,prod_on_order SMALLINT,
		prod_reorder_level SMALLINT,prod_discontinued INT,prod_cate_id INT, prod_supr_id INT);

SELECT * FROM products;

--ORDER
INSERT INTO orders (order_id, order_date, order_required_date, order_shipped_date,
				   order_freight, 
					order_subtotal, 
					order_total_qty, 
					order_ship_city, order_ship_address,order_employee_id, order_cust_id, order_ship_id)
SELECT * FROM dblink ('localhost',
					 'SELECT orders.order_id, orders.order_date, orders.required_date, orders.shipped_date,orders.freight, 
					  SUM(order_detail.unit_price) as order_subtotal, 
					  SUM(order_detail.quantity) as order_total_qty, 
					  orders.ship_city,orders.ship_address,orders.employee_id, orders.customer_id, orders.shipper_id
					  FROM orders, order_detail
					  group by orders.order_id
					  ' )
AS DATA (order_id int, order_date TIMESTAMP, order_required_date TIMESTAMP, order_shipped_date TIMESTAMP,
	     order_freight MONEY, order_subtotal MONEY, order_total_qty INT, order_ship_city VARCHAR(15),
		 order_ship_address VARCHAR(60),order_employee_id INT, order_cust_id char(5), order_ship_id INT);

SELECT * FROM orders;




--insert ke orders detail
ALTER TABLE orders_detail DROP CONSTRAINT fk_order_id;
ALTER TABLE orders_detail ADD CONSTRAINT fk_ordet_order_id
FOREIGN KEY (ordet_order_id)
REFERENCES orders(order_id);

INSERT INTO orders_detail (ordet_order_id, ordet_prod_id, ordet_price, ordet_quantity, ordet_discount)
SELECT * FROM dblink ('localhost', 
	'SELECT order_id, product_id, unit_price, quantity, discount 
					  FROM order_detail')
AS DATA (ordet_order_id SMALLINT, ordet_prod_id SMALLINT, ordet_price MONEY, ordet_quantity SMALLINT, ordet_discount REAL)
;

SELECT * FROM orders_detail;


