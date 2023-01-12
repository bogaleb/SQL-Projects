--SQL MURDER CASE

select * 
from crime_scene_report
where type ='murder' AND city='SQL City' AND date=20180115

--Security footage shows that there were 2 witnesses. 
--The first witness lives at the last house on "Northwestern Dr". 
--The second witness, named Annabel, lives somewhere on "Franklin Ave".
select * 
from person
where name LIKE '%Annabel%'AND address_street_name='Franklin Ave'
 
---d	name	license_id	address_number	address_street_name	ssn
--16371	Annabel Miller	490173	103	Franklin Ave	318771143

select *
from person 
where address_street_name= 'Northwestern Dr'
order by address_number DESC
LIMIT 1
-- id	name	license_id	address_number	address_street_name	ssn
14887	Morty Schapiro	118009	4919	Northwestern Dr	111564949*/

SELECT * 
FROM interview
where person_id IN (14887,16371)
/*person_id	transcript
14887	I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. 
The membership number on the bag started with "48Z". Only gold members have those bags. 
The man got into a car with a plate that included "H42W".*/

/*16371	I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th*/

SELECT *
FROM get_fit_now_member
where id LIKE '48Z%'


/*id	person_id	name	membership_start_date	membership_status
48Z38	49550	Tomas Baisley	20170203	silver
48Z7A	28819	Joe Germuska	20160305	gold
48Z55	67318	Jeremy Bowers	20160101	gold*/

select * 
from get_fit_now_check_in
where membership_id IN ("48Z38","48Z7A","48Z55") AND check_in_date=20180109*/

select *
from person
where id IN ("28819","67318")

/*id	name	license_id	address_number	address_street_name	ssn
28819	Joe Germuska	173289	111	Fisk Rd	138909730
67318	Jeremy Bowers	423327	530	Washington Pl, Apt 3A	871539279*/

select * 
from drivers_license
where id IN ("173289", "423327") AND plate_number LIKE '%H42W%'

SELECT * 
FROM person
WHERE license_id=423327

/*id	name	license_id	address_number	address_street_name	ssn
67318	Jeremy Bowers	423327	530	Washington Pl, Apt 3A	871539279*/


SELECT *, count(event_id) as event_count
from drivers_license d
join person p
on d.id=p.license_id
join facebook_event_checkin f
on f.person_id=p.id
where car_make='Tesla' AND car_model='Model S' AND gender='female' AND hair_color='red'
AND event_name= 'SQL Symphony Concert' AND date LIKE '201712%';

/*car_model	id	name	license_id	address_number	address_street_name	ssn	person_id	event_id	event_name	date	event_count
202298	68	66	green	red	female	500123	Tesla	Model S	99716	Miranda Priestly	202298	1883	Golden Ave	987756388	99716	1143	SQL Symphony Concert	20171229	3
*/