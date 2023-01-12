UDACITY EXCERISES


--Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.--

SELECT a.name, o.occurred_at
FROM accounts a
JOIN orders o
ON a.id = o.account_id
ORDER BY occurred_at
LIMIT 1;

/*Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders in usd and the company name.*/


SELECT a.name, SUM(total_amt_usd) total_sales
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name;

--Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? Your query should return only three values - the date, channel, and account name.
SELECT a.name, w.channel, w.occurred_at
FROM web_events w
JOIN accounts a
ON a.id = w.id
order by w.occurred_at DESC
LIMIT 1;



--Find the total number of times each type of channel from the web_events was used. Your final table should have two columns - the channel and the number of times the channel was used.

SELECT w.channel, COUNT(*)
FROM web_events w
GROUP BY w.channel

--Who was the primary contact associated with the earliest web_event?

SELECT a.primary_poc
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
ORDER BY w.occurred_at
LIMIT 1;
--What was the smallest order placed by each account in terms of total usd. Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.



SELECT a.name, MIN(total_amt_usd) smallest_order
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY smallest_order;

--Find the number of sales reps in each region. Your final table should have two columns - the region and the number of sales_reps. Order from the fewest reps to most reps.

SELECT r.name, COUNT(s.id)
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
GROUP BY r.name
--

--SUBQUERIES
SELECT DATE_TRUNC('month', MIN(occurred_at)) 
FROM orders;


SELECT AVG(standard_qty) avg_std, AVG(gloss_qty) avg_gls, AVG(poster_qty) avg_pst
FROM orders 
WHERE DATE_TRUNC('month', occurred_at) = 
     (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);

SELECT SUM(total_amt_usd)
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
      (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);



--LEFT, RIGHT, POSITION


      select LEFT(a.primary_poc, POSITION(' ' IN a.primary_poc)-1) AS first_name, RIGHT(a.primary_poc, LENGTH(primary_poc)-POSITION(' ' IN a.primary_poc)) AS last_name
from accounts a
limit 10

select LEFT(name, POSITION(' ' IN name)-1) AS first_name, RIGHT(name, LENGTH(name)-POSITION(' ' IN name)) AS last_name
from sales_reps 
limit 10



CONCAT POSITION LEFT RIGHT UPPER LOWER

WITH email AS
(SELECT LEFT(a.primary_poc, POSITION(' ' IN a.primary_poc)-1) AS first_name, RIGHT(a.primary_poc, LENGTH(a.primary_poc)-POSITION(' ' IN a.primary_poc)) AS last_name, a.name as company
from accounts a)
    SELECT first_name, last_name, CONCAT(first_name,'.',last_name,'@',REPLACE(company,' ',''),'.','com') AS email,
   CONCAT( LOWER(LEFT(first_name,1)),RIGHT(first_name,1), LOWER(LEFT(last_name,1)),LOWER(RIGHT(last_name,1)),LENGTH(first_name),LENGTH(last_name),UPPER(REPLACE(company,' ',''))) AS password         FROM email;


to see the existing tables and columns in  a database
select table_name,
STRING_AGG(column_name, ',') 
from information_schema.columns
where table_schema='public'
group by 1



/*SELECT RIGHT(a.website,3) AS web_type, count(RIGHT(a.website,3)) AS website_type_count
FROM accounts a
GROUP BY 1;*/
                                                   

/*SELECT LEFT(a.name, 1) AS company_name, COUNT(LEFT(a.name, 1)) AS company_first_letter_count
 FROM accounts a
 GROUP BY 1
ORDER BY 2 desc*/

/*SELECT groups, count(*)
FROM (SELECT name,
      CASE WHEN LEFT(name, 1) IN ('0','2','3','4','5','6','7','7','8','9','0') THEN 'NUMBERS' ELSE 
        'LETTERS' END AS groups
 FROM accounts) t1
 group by 1*/
 
 
 SELECT name_vowel, count(*)
FROM (SELECT name,
      CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') THEN 'VOWELS' ELSE 
        'OTHER' END AS name_vowel
 FROM accounts) t2
 group by 1
 
CAST FUNCTION

-- Select (CONCAT(SUBSTR(date,7,4),'-',SUBSTR(date,1,2),'-',SUBSTR(date,4,2)))::DATE newdate
-- from sf_crime_data

-- SELECT date orig_date, (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2))::DATE new_date
-- FROM sf_crime_data;


/*select primary_poc, LEFT(primary_poc, POSITION(' ' IN primary_poc)) AS first_name,
RIGHT(primary_poc, LENGTH(primary_poc) -POSITION(' ' IN primary_poc)) AS last_name
 from accounts*/
 
select name, LEFT(name, POSITION(' ' IN name)) AS first_name,
RIGHT(name, LENGTH(name) -POSITION(' ' IN name)) AS last_name
 from sales_reps


-----create email
 select CONCAT(LEFT(primary_poc, POSITION(' ' IN primary_poc)-1),'.',RIGHT(primary_poc, LENGTH(primary_poc) -POSITION(' ' IN primary_poc)),'@',REPLACE(name,' ',''),'.',RIGHT(website,3)) AS email
from accounts
order by email


---create password
WITH T1 AS(
SELECT LOWER(LEFT((LEFT(primary_poc, POSITION(' ' IN primary_poc)-1)),1)) AS firstletter1,
  LOWER(RIGHT((LEFT(primary_poc, POSITION(' ' IN primary_poc)-1)),1)) AS lastletter1,                      
 LOWER(LEFT(RIGHT(primary_poc, LENGTH(primary_poc) -POSITION(' ' IN primary_poc)),1)) AS firstletter2,
 LOWER(RIGHT(RIGHT(primary_poc, LENGTH(primary_poc) -POSITION(' ' IN primary_poc)),1)) AS lastletter2,
  LENGTH(LEFT(primary_poc, POSITION(' ' IN primary_poc)-1)) AS len1,
  LENGTH(RIGHT(primary_poc, LENGTH(primary_poc) -POSITION(' ' IN primary_poc))) AS len2,
 REPLACE(UPPER(name),' ','') AS company_name                          
 FROM accounts ) 
   SELECT CONCAT(firstletter1, lastletter1, firstletter2,lastletter2,len1,len2, company_name) AS password 
 FROM T1;       
          