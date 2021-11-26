%%sql
postgresql:///animal_shelters
    
select *,
case
    when n.weight <= 10 and n.animaltype ='Dog' then 'Small'
    when n.weight <= 5 and n.animaltype ='Cat' then 'Small'
    when n.weight <= 0.7 and n.animaltype ='Bird' then 'Small'
    
    when n.weight > 10 and n.weight <= 30 and n.animaltype ='Dog' then 'Medium'
    when n.weight > 5 and n.weight <= 7 and n.animaltype ='Cat' then 'Medium'
    when n.weight > 0.7 and n.weight <= 1.1 and n.animaltype ='Bird' then 'Medium'
    
    when n.weight > 30 and n.animaltype ='Dog' then 'Large'
    when n.weight > 7 and n.animaltype ='Cat' then 'Large'
    when n.weight > 1.1 and n.animaltype ='Bird' then 'Large'
End as size

from animals as n 
join age_costs 
on date_part('year',age(to_timestamp('12/31/2021', 'yy-mm-dd HH24:MI:SS.MS'),to_timestamp(n.birthdate, 'yy-mm-dd HH24:MI:SS.MS'))) = age_costs.age::int
join location_costs as l_c
on n.location = l_c.location
join size_costs as s
on n.animaltype = s.animaltype
and size = s.size
where n.animalid not in (select sponsorid from sponsored_animals)
order by animalid

