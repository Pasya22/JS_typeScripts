-- Regions Table
create table master.regions(
region_code serial,
region_name varchar(35) unique,
constraint region_code_pk primary key (region_code)
)

-- country table
create table master.country(
country_id serial,
country_name varchar(55) unique,
country_region_id int,
constraint country_id_pk primary key (country_id),
constraint country_region_id_fk foreign key (country_region_id) references master.regions (region_code)

)

-- provinces table
create table master.provinces(
prov_id serial,
prov_name varchar(90),
prov_country_id int,
constraint prov_id_pk primary key (prov_id),
constraint prov_country_id_fk foreign key (prov_country_id) references master.country (country_id)

)

-- address table 
create table master.address(
add_id serial,
add_line1 varchar(255),
add_line2 varchar(255),
add_postal_code varchar(5),
add_spatial_location json,
add_prov_id int,
constraint add_id primary key (add_id),
constraint add_prov_id_fk foreign key (add_prov_id) references master.provinces (prov_id)

)
-- category_grup table
create table master.category_grup(
cargo_id serial,
cargo_name varchar(25) unique,
cargo_description varchar (255),
cargo_type varchar(25),
cargo_icon varchar(255),
cargo_icon_url varchar(255),
constraint cargo_id_pk primary key (cargo_id)
);


-- policy table
create table master.policy(
poli_id serial,
poli_name varchar(55),
poli_description varchar(255),
constraint poli_id_pk primary key (poli_id)
);

-- policy_category_group

create table master.policy_category_group(
poca_poli_id serial,
poca_cargo_id int,
constraint poca_poli_id_pk primary key (poca_poli_id,poca_cargo_id),
constraint poca_poli_id_fk foreign key (poca_poli_id) references master.policy (poli_id),
constraint poca_cargo_id_fk foreign key (poca_cargo_id) references master.category_grup (cargo_id)

);


-- price_items

create table master.price_items(
prit_id serial,
prit_name varchar(55) unique,
prit_description varchar (255),
prit_price money,
prit_type varchar(25),
prit_modified_date timestamp,
constraint prit_id_pk primary key (prit_id)
);

-- members table

create table master.members(
memb_name varchar(15),
memb_description varchar(100),
constraint memb_name primary key (memb_name)
);

-- service_task table
create table master.service_task(
seta_id serial,
seta_name varchar(85) unique,
seta_seq smallint,
constraint seta_id_pk primary key(seta_id)

);

-- masukan data category group
insert into master.category_grup (cagro_name) values('Room'),
('Restaurant'),('Meeting Room'),('Gym'),('SwimmingPool'),('Balroom');
select *from master.category_grup 