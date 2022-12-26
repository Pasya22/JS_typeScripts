-- select setval(pe.p"businessEntity_businessEntityID_SEQ",(select max(businessentityid)from pe.p.businessentity));
-- select curval(pe.p"businessEntity_businessEntityID_SEQ");

--------------------------- 01 ---------------------------------
-- create funtion signup using procedure
create procedure person.signup(
	BusinessEntityID	int,
	FirstName 			text,
	MiddleName 			text,
	LastName			text,
	Suffix				text,
	Email				text,
	PhoneNumber			text,
	PersonType			text,
	Password			text
	
)
-- drop procedure person.signup(
-- 	BusinessEntityID,	
-- 	FirstName 	,		
-- 	MiddleName 	,		
-- 	LastName	,		
-- 	Suffix		,		
-- 	Email		,		
-- 	PhoneNumber	,		
-- 	PersonType	,		
-- 	Password)
language plpgsql
as $$
begin 
-- execute to table person/signup
-- metode traksaksi in posgreSql 
-- metode rollBack in posgreSql

-- if exists 
	INSERT INTO pe.be (BusinessEntityID)
		VALUES (BusinessEntityID);
	INSERT INTO pe.p (BusinessEntityID, FirstName, MiddleName, LastName, Suffix, PersonType) 
		VALUES (BusinessEntityID, FirstName, MiddleName, LastName, Suffix, PersonType);
	INSERT INTO pe.pp (BusinessEntityID, PhoneNumber, PhoneNumberTypeID)
		VALUES (BusinessEntityID, PhoneNumber, 1);
	INSERT INTO pe.e (BusinessEntityID, EmailAddress)
		VALUES (BusinessEntityID, Email);
	INSERT INTO pe.pa (BusinessEntityID, PasswordHash, PasswordSalt)
		VALUES (BusinessEntityID, Password, Password);

-- then 
-- raise notice
-- 'berhasil';
-- else 
-- raise notice
-- 'gagal';
-- end if;

	
-- rollback;

commit ;
end ; $$

select * from pe.p  where pe.p.businessentityid = 8000013;
-- call function in procedure methode
call person.signup(800013,
			'Pangestu',
			null,'Septian',
			'sfxAmbigu',
			'pasay@gmail.com',
		   null,
			'EM','pasya');

-- create funtion signin using procedure
create or replace procedure signin(
-- 	businessentityid int,
-- 	email xml,
-- 	passwords varchar
	IN email varchar,
	IN passwords varchar
)

language plpgsql
as $$
begin
-- Perform for person/signin
-- insert into person.signin values(
-- 	businessentityid,
-- 	email,
-- 	passwords);
	
if exists(
	SELECT 1 
	FROM pe.p
	join pe.e using(BusinessEntityID)
	join pe.pa using(BusinessEntityID)
	WHERE email = email AND passwordhash = passwords)
then 
raise notice
'LOGIN BERHASIL YEEUHHH';
else 
raise notice 
'gagal ah euyy';
end if;
commit;
end; $$


-- execute show for person/signin
call signin('pasay@gmail.com','pasyaj');

-------------------------- 02 -----------------------------------
create or replace procedure UpdateProfile(
	p_businessentityid int,
	p_firstname varchar(50),
	p_middlename varchar(50),
	p_lastname varchar(50),
	p_suffix varchar(10),
	p_emailaddress varchar(50),
	p_phonenumber varchar(25),
	p_phonenumbertype varchar(50),
	p_addresstype varchar(60),
	p_province varchar(50),
	p_region varchar(50)
)
language plpgsql as $$

begin
-- 	UPDATE TABLE PERSON
	update person.person set 
		firstname = p_firstname, 
		middlename = p_middlename,
		lastname = p_lastname,
		suffix = p_suffix
	where
		businessentityid = p_businessentityid;
		
-- 	UPDATE TABLE EMAIL
	update person.emailaddress set
		emailaddress = p_emailaddress
	where
		businessentityid = p_businessentityid;
-- UPDATE TABLE PHONE
	update person.PersonPhone set
		phonenumber = p_phonenumber
	where businessentityid = p_businessentityid;
	
-- UPDATE TABLE PHONENUMBERTYPE
	update person.PhoneNumberType set
		name = p_phonenumbertype
	where PhoneNumberTypeID = (
		select phonenumbertypeid from person.personphone where businessentityid = p_businessentityid
		);

-- UPDATE TABLE ADDRESS
	update person.address set
		AddressLine1 = p_addresstype
	where AddressID = (
		select AddressID from person.BusinessEntityAddress where businessentityid = p_businessentityid
	);
	
-- UPDATE TABLE PROVINCE
	update person.StateProvince set
		name = p_province
	where stateprovinceid = (
		select stateprovinceid from person.BusinessEntityAddress 
		join  person.address using(addressid)
		where  businessentityid = p_businessentityid
	);
	
-- UPDATE TABLE CountryRegion
	update person.CountryRegion set
		name = p_region
	where CountryRegionCode = (
		select CountryRegionCode from person.BusinessEntityAddress 
		join person.address using(addressid)
		join person.StateProvince using(StateProvinceID)
		where  businessentityid = p_businessentityid
	);
	
end;$$

call UpdateProfile(20777, 'Moch', 'Rifqi', 'Ramdhani', 'Junior.Phd', 
				   'rifqiramdhani8@gmail.com', '081393003129', 'Office', 'Bukit  berlian C72', 'Jawa Barat', 'Indonesia');

-------------------------- 03 -----------------------------------
-- create function return recursor for show person dashbord
CREATE OR REPLACE FUNCTION count_person_type()
RETURNS TABLE (
	PersonType text,
	TotalPerson int)
AS $$

DECLARE
	-- cursor
	cur_persontype CURSOR FOR
		-- CTE to add PersonType description
		WITH person_desc AS (
			SELECT 
				*,
				CASE
					WHEN p.persontype = 'SC' THEN 'Store Contact'
					WHEN p.persontype = 'IN' THEN 'Individual Customer'
					WHEN p.persontype = 'SP' THEN 'Sales Person'
					WHEN p.persontype = 'EM' THEN 'Employee'
					WHEN p.persontype = 'VC' THEN 'Vendor Contact'
					ELSE 'General Contact'
				END AS PersonTypeDesc
			FROM pe.p p
		)
		
		SELECT
			CONCAT(PersonTypeDesc, ' (', p.PersonType, ')') PersonType,
			COUNT(*) TotalPerson
		FROM person_desc p
		GROUP BY PersonTypeDesc, p.PersonType;

BEGIN
	OPEN cur_persontype; -- open cursor
	LOOP -- iterate over rows of the cursor
		FETCH NEXT FROM cur_persontype INTO PersonType, TotalPerson;
		EXIT WHEN NOT FOUND;
		RETURN NEXT ; -- return each rows
	END LOOP;
	CLOSE cur_persontype;
END; $$
LANGUAGE plpgsql;

select * from count_person_type();

-- Individual Customer Group by Region (Region, TotalPerson)
CREATE OR REPLACE FUNCTION cust_by_region()
RETURNS TABLE (
	Region text,
	TotalPerson int
) AS $$

DECLARE
	my_cursor CURSOR FOR
		WITH address_info AS (
			SELECT
				bea.BusinessEntityID,
				bea.AddressID,
				at.Name AddressTypeDesc,
				a.AddressLine1,
				a.AddressLine2,
				a.City,
				a.StateProvinceID,
				a.PostalCode,
				sp.Name ProvinceName,
				sp.StateProvinceCode,
				sp.CountryRegionCode,
				cr.Name CountryRegionName
			FROM pe.bea bea
			LEFT JOIN pe.a a USING(AddressID)
			LEFT JOIN pe.at at USING (AddressTypeID)
			INNER JOIN pe.sp sp USING(StateProvinceID)
			INNER JOIN pe.cr cr USING(CountryRegionCode)
		)
		
		SELECT
			CountryRegionName,
			COUNT(*)
		FROM address_info
		GROUP BY CountryRegionName;

BEGIN
	OPEN my_cursor;
	LOOP
		FETCH NEXT FROM my_cursor INTO Region, TotalPerson;
		EXIT WHEN NOT FOUND;
		RETURN NEXT;
	END LOOP;
	CLOSE my_cursor;
END; $$
LANGUAGE plpgsql;

SELECT * FROM cust_by_region()

------------------------------------------------------------
select * from person.signin
-- INSERT INTO Person.BusinessEntity(rowguid) VALUES (default)
-- SELECT IDENT_CURRENT('PERSON.BUSINESSENTITY') AS [IDENT_CURRENT]



------------------------- create table ----------------------
-- create table signup in person shcema
	create table person.signup(
	businessentityid int,
	firstnames varchar(30),
	middlenames varchar(30),
	lastnames varchar (40),
	surfix varchar (10),
	email xml,
	phonenumber varchar(24),
	persontype varchar(20),
	
constraint businessentityid_pk primary key (businessentityid)
);
-- create table signin in person shcema
create table person.signin(
	businessentityid int,
	email xml,
	passwords varchar (30),
-- 	firstnames varchar(30),
-- 	middlenames varchar(30),
-- 	lastnames varchar (40),
-- 	surfix varchar (10),
-- 	phonenumber varchar(24),
-- 	persontype varchar(20),
	
constraint businessentity_id_pk primary key (businessentityid)
);
-- iiii
drop table person.signup 

select *from person.signup