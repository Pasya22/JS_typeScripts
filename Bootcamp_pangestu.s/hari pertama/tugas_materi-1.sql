-- 1) informasi jumlah department tiap region
select concat(regions.region_name)Region, count(departments.department_id)Departments from departments 
join locations on locations.location_id = departments.location_id
join countries on countries.country_id = locations.country_id
join regions on regions.region_id = countries.region_id
group by Region, departments.department_id

--2)Informasi jumlah department tiap countries
select concat(countries.country_name)Countries, count(departments.department_id)Departments 
from departments 
join locations on departments.location_id = locations.location_id
join countries on locations.country_id = countries.country_id
-- join regions on regions.region_id = countries.region_id
-- group by countries, departments

--3) Informasi jumlah employee tiap department

select count(*)
from employees e
inner join job_history jbh on e.job_id = jbh.job_id
inner join departments d on jbh.department_id = d.department_id

--4) Informasi jumlah employee tiap region

select count(*) 
from regions r 
inner join countries c on r.region_id = c.region_id
inner join locations l on c.country_id=l.country_id
inner join departments d on l.location_id = d.location_id
inner join job_history jbh on d.department_id = jbh.department_id
inner join employees e on jbh.job_id = e.job_id

--5) Informasi jumlah employee tiap countries.
select count(*) 
from countries c 
inner join locations l on c.country_id=l.country_id
inner join departments d on l.location_id = d.location_id
inner join job_history jbh on d.department_id = jbh.department_id
inner join employees e on jbh.job_id = e.job_id

-- 6) Informasi salary tertinggi tiap department
select department_id, max(salary) as salary from employees group by department_id

--7) Informasi salary terendah tiap department
select department_id, min(salary) as salary from employees group by department_id

--8) Informasi salary rata-rata tiap department
select department_id, sum(salary) as salary from employees group by department_id

-- 9) informasi jumlah mutasi pegawai tiap depatrment
select departments.department_name, count(employees.employee_id) from employees 
join departments on departments.department_id = employees.department_id
join job_history on employees.job_id = job_history.job_id
group by departments.department_name

-- 10) informasi jumlah mutasi pegawai berdasarkan role job
select job_title, count(job_history.employee_id) from job_history 
join jobs on jobs.job_id = job_history.job_id 
group by job_title 
order by job_title

-- 11) informasi jumlah employee yang sering di mutasi
select concat(first_name,' ', last_name)fullname, count(e.employee_id) from employees e
join job_history j on e.employee_id = j.employee_id
-- join employees e on e.job_id = j.job_id 
group by fullname having count (e.employee_id) > 1

select * from job_history

-- 12) Informasi jumlah employee berdasarkan role jobs-nya
select concat (first_name,' ',last_name)Fullname,job_title, count(employees.employee_id) from employees 
join jobs on jobs.job_id = employees.job_id
group by Fullname ,job_title 
order by Fullname ASC, job_title DESC

-- 13)Informasi employee paling lama bekerja di tiap department
select concat (departments.department_name)department, min(hire_date)mulai,max(end_date)selesai from employees
join job_history on job_history.job_id = employees.job_id
join departments on departments.department_id = employees.department_id 
group by department

-- 14) Informasi employee baru masuk kerja di tiap department
select concat (departments.department_name)departement,concat(first_name,' ', last_name)fullname, min(hire_date)Mulai_Bekerja from employees
join job_history on job_history.job_id = employees.job_id
join departments on departments.department_id = employees.employee_id 
group by departments.department_name,employees.employee_id

-- 15)Informasi lama bekerja tiap employee dalam tahun dan jumlah mutasi history-nya
select concat(first_name,' ', last_name)fullname,
min(hire_date),max(end_date)Mulai_Bekerja, count(job_history.end_date)
from employees
join job_history on job_history.job_id = employees.job_id
join departments on departments.department_id = employees.department_id 
group by employees.employee_id,job_history.job_id 
