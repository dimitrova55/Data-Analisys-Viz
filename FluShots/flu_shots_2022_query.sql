/*
Flu shot Dashboard

1. Total % of patients getting flu shots stratified (напластявам) by
	a. age -> at least 6 month old
	b. race
	c. county (on map)
	d. overall % of patients that received flu shots in 2022
2. running total of flu shots over the course of 2022
3. total number of flu shots given in 2022
4. a list of patients that show whether or not they received the flu shots

requirements:
patients must have been "Active at our hospital."
*/


/*
-- така написано, първо съединява двете таблици на база p.id
-- и след това подбира тези, които имат ваксината

select  min(immun.date) as earliest_flu_shot_2022,
		p.birthdate,
		p.race,
		p.county,
		p.id,
		p.first,
		p.last,
		immun.patient
from public.patients as p
left join public.immunizations as immun
	on p.id = immun.patient
---flu shot code = 5302
where immun.code = '5302'		
	and immun.date between '2022-01-01' and '2022-12-31'
group by p.id, p.birthdate, p.race, p.county, p.first, p.last, immun.patient
*/



--- създава временна таблица
--- която съдържа ид-тата само на тези, които имат ваксината
--- и след това е left join с другата таблица
with active_patients as
	(
	select distinct patient
	from encounters as e
	join patients as pat
		on e.patient = pat.id
	where start between '2020-01-01' and '2023-01-01'
		and pat.deathdate is null
		and extract(month from age('2022-12-31', pat.birthdate)) >= 6
	
	),
	
flu_shot as
	(
	select
		min(date) as earliest_flu_shot_2022,
		patient
	from public.immunizations
	where code = '5302'
		and date between '2022-01-01' and '2023-01-01'
	group by patient
	)

select 
	extract(year from age('2022-12-31', p.birthdate)) as Age,
	p.id,
	p.first,
	p.last,
	p.county,
	p.race,
	p.ethnicity,
	p.gender,
	flu.earliest_flu_shot_2022,
	p.zip,
	case 
	when flu.patient is not null then 1
	else 0 	end as flu_shot
from public.patients as p
left join flu_shot as flu
	on p.id = flu.patient
where p.id in (select patient from active_patients)

