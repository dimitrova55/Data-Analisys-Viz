SELECT distinct encounterclass
FROM public.encounters

SELECT * 
FROM  public.encounters
WHERE encounterclass = 'inpatient' and description = 'ICU Admission'

SELECT * 
FROM  public.encounters
WHERE encounterclass = 'inpatient'
	and description = 'ICU Admission'


SELECT * 
FROM  public.encounters
WHERE encounterclass in ('outpatient', 'ambulatory')


SELECT *
FROM public.conditions

	
--- The number of patients of every medical condition, sorted in a descending order.
	
SELECT 
	description, 
	count(*) as number_of_occurances
FROM public.conditions
group by description
having count(*) > 2000
order by number_of_occurances desc


--- select all the patients from Boston
	
SELECT * FROM public.patients
WHERE city like 'Boston'


--- All patients who have been diagnosed with Chronic Kidney Disease
SELECT p.id, c.code, c.description
FROM public.patients as p
INNER JOIN public.conditions as c
	ON p.id = c.patient
WHERE c.code in ('585.1', '585.2', '585.3', '585.4')


---------------------------------------------------------------------------
--- Count the number of patients for every city with at least 100 patients
--- excluding Boston, sorted in descending order
---------------------------------------------------------------------------
SELECT city, count(*)
FROM public.patients
WHERE city not like 'Boston'
GROUP by city
having count(*) >= 100
order by count(*) desc


select 
	i.*, p.first, p.last, p.birthdate
from public.immunizations as i
left join public.patients as p
	on i.patient = p.id









