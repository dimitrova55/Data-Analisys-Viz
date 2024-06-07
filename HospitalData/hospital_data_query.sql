create table "postgres"."Hospital_Data".hospital_data_table as 

with hospital_beds_prep as 
	(
	select 
		lpad(cast(provider_cnn as text), 6, '0') as provider_cnn,
		hospital_name,
		to_date(fiscal_year_begin_date, 'MM/DD/YYYY') as fiscal_year_begin_date,
		to_date(fiscal_year_end_date, 'MM/DD/YYYY') as fiscal_year_end_date,
		number_of_beds,
		row_number() over (partition by provider_cnn order by to_date(fiscal_year_end_date, 'MM/DD/YYYY') desc) as nth_row
	from "postgres"."Hospital_Data".hospital_beds
	)

/*	
select provider_cnn, count(*) as count_of_rows
from hospital_beds_prep
where nth_row = 1
group by provider_cnn
order by count(*) desc
*/


select 
	lpad(cast(facility_id as text), 6, '0') as provider_cnn,
	to_date(start_date, 'MM/DD/YYYY') as start_date_conv,
	to_date(end_date, 'MM/DD/YYYY') as end_date_conv,
	hcahps.*,
	beds.number_of_beds,
	beds.fiscal_year_begin_date,
	beds.fiscal_year_end_date	
from "postgres"."Hospital_Data".hcahps_data as hcahps
left join hospital_beds_prep as beds
	on lpad(cast(facility_id as text), 6, '0') = beds.provider_cnn
	and beds.nth_row = 1





