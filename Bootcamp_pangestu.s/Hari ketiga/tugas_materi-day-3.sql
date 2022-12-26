-- 01)
select persontype , 
	case when persontype = 'IN'
	then 'individual customers'
	end, count(person.businessentityid)total
	from person.person 
group by persontype



select *from person.person
-- 02)
select 
