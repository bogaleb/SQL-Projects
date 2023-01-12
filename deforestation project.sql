project appendix 
DROP 
  VIEW IF EXISTS deforestation;
CREATE VIEW deforestation AS (
  SELECT 
    f.year, 
    f.country_code, 
    f.country_name, 
    f.forest_area_sqkm, 
    l.total_area_sq_mi, 
    r.region, 
    r.income_group, 
    (f.forest_area_sqkm)/(2.59 * l.total_area_sq_mi)* 100 as forest_area_percent 
  FROM 
    forest_area f 
    JOIN land_area l ON l.country_code = f.country_code 
    AND l.year = f.year 
    JOIN regions r ON r.country_code = f.country_code
);
/*total area of forest for world and area of forest in 2016*/
WITH area_1990 AS (
  select 
    forest_area_sqkm AS forest_area_sqkm_1990 
  from 
    deforestation 
  WHERE 
    year = '1990' 
    AND country_name = 'World'
), 
area_2016 AS (
  select 
    forest_area_sqkm AS forest_area_sqkm_2016 
  from 
    deforestation 
  WHERE 
    year = '2016' 
    AND country_name = 'World'
) 
select 
  forest_area_sqkm_2016 
from 
  area_2016 
  /*decline in forest area in absolute terms*/
SELECT 
  (
    select 
      forest_area_sqkm AS forest_area_sqkm_1990 
    from 
      deforestation 
    WHERE 
      year = '1990' 
      AND country_name = 'World'
  ) - (
    select 
      forest_area_sqkm AS forest_area_sqkm_2016 
    from 
      deforestation 
    WHERE 
      year = '2016' 
      AND country_name = 'World'
  ) AS decline_in_forest_area 
  /*decline in forest area in percentage*/
  METHOD 1 
SELECT 
  (
    (
      select 
        forest_area_sqkm AS forest_area_sqkm_2016 
      from 
        deforestation 
      WHERE 
        year = '2016' 
        AND country_name = 'World'
    ) -(
      select 
        forest_area_sqkm AS forest_area_sqkm_1990 
      from 
        deforestation 
      WHERE 
        year = '1990' 
        AND country_name = 'World'
    )
  )* 100 / (
    select 
      forest_area_sqkm AS forest_area_sqkm_1990 
    from 
      deforestation 
    WHERE 
      year = '1990' 
      AND country_name = 'World'
  ) AS perecentage_decline_in_forest_area 
  /*decline in forest area in percentage METHOD 2*/
  WITH area_2016 AS (
    select 
      forest_area_sqkm AS a_2016 
    from 
      deforestation 
    WHERE 
      year = '2016' 
      AND country_name = 'World'
  ), 
  area_1990 AS (
    select 
      forest_area_sqkm AS a_1990 
    from 
      deforestation 
    WHERE 
      year = '1990' 
      AND country_name = 'World'
  ), 
  diffs AS (
    SELECT 
      a_1990, 
      a_2016, 
      a_1990 - a_2016, 
      (a_2016 - a_1990)/ a_1990 * 100 AS percentage_diff 
    from 
      area_1990, 
      area_2016
  ) 
select 
  a_1990, 
  a_2016, 
  ROUND(percentage_diff :: NUMERIC, 2) 
from 
  diffs 
  /*The forest area lost over this time period is slightly more than the entire land area of*/
SELECT 
  country_name, 
  total_area_sq_km 
from 
  deforestation 
where 
  year = '2016' 
  AND total_area_sq_km <= 1324449 
ORDER BY 
  2 DESC 
limit 
  1;
/*the percent of the total land area of the world and regions designated as forest by region
*/
SELECT 
  region, 
  SUM(forest_area_sqkm)* 100 / SUM(total_area_sq_km) AS forest_coverage_by_region_percentage 
from 
  deforestation 
where 
  year = '2016' 
group by 
  1 
order by 
  2 --alternative method for land area of the world and regions designated as forest by region for both year in one table
DROP 
  VIEW IF EXISTS deforestation;
CREATE VIEW deforestation AS (
  SELECT 
    f.year, 
    f.country_code, 
    f.country_name, 
    f.forest_area_sqkm, 
    l.total_area_sq_mi, 
    l.total_area_sq_mi * 2.59 as total_area_sq_km, 
    r.region, 
    r.income_group, 
    (f.forest_area_sqkm)/(2.59 * l.total_area_sq_mi)* 100 as forest_area_percent 
  FROM 
    forest_area f 
    JOIN land_area l ON l.country_code = f.country_code 
    AND l.year = f.year 
    JOIN regions r ON r.country_code = f.country_code
);
WITH t3 AS (
  SELECT 
    region, 
    SUM(forest_area_sqkm)* 100 / SUM(total_area_sq_km) AS forest_percentage_1990 
  from 
    deforestation 
  where 
    year = '1990' 
  group by 
    1
), 
t4 AS (
  SELECT 
    region, 
    SUM(forest_area_sqkm)* 100 / SUM(total_area_sq_km) AS forest_percentage_2016 
  from 
    deforestation 
  where 
    year = '2016' 
  group by 
    1
) 
SELECT 
  * 
from 
  t3 
  join t4 on t3.region = t4.region 
  /*country level detail*/
DROP 
  VIEW IF EXISTS deforestation;
CREATE VIEW deforestation AS (
  SELECT 
    f.year, 
    f.country_code, 
    f.country_name, 
    f.forest_area_sqkm, 
    l.total_area_sq_mi, 
    l.total_area_sq_mi * 2.59 as total_area_sq_km, 
    r.region, 
    r.income_group, 
    (f.forest_area_sqkm)/(2.59 * l.total_area_sq_mi)* 100 as forest_area_percent 
  FROM 
    forest_area f 
    JOIN land_area l ON l.country_code = f.country_code 
    AND l.year = f.year 
    JOIN regions r ON r.country_code = f.country_code
);
WITH t1 AS (
  SELECT 
    country_name, 
    region, 
    forest_area_sqkm AS total_forest_area_2016 
  from 
    deforestation 
  where 
    year = '2016' 
  group by 
    1, 
    2, 
    3 
  order by 
    3
), 
t2 AS (
  SELECT 
    country_name, 
    region, 
    forest_area_sqkm AS total_forest_area_1990 
  from 
    deforestation 
  where 
    year = '1990' 
  group by 
    1, 
    2, 
    3 
  order by 
    3
) 
select 
  *, 
  (
    total_forest_area_2016 - total_forest_area_1990
  ) as Absolute_diff, 
  (
    total_forest_area_2016 - total_forest_area_1990
  )* 100 /(total_forest_area_1990) as percentage_change 
from 
  t1 
  join t2 on t1.country_name = t2.country_name 
order by 
  percentage_change 
limit 
  5;
/*QUARTILES*/
DROP 
  VIEW IF EXISTS deforestation;
CREATE VIEW deforestation AS (
  SELECT 
    f.year, 
    f.country_code, 
    f.country_name, 
    f.forest_area_sqkm, 
    l.total_area_sq_mi, 
    l.total_area_sq_mi * 2.59 as total_area_sq_km, 
    r.region, 
    r.income_group, 
    (f.forest_area_sqkm)/(2.59 * l.total_area_sq_mi)* 100 as forest_area_percent 
  FROM 
    forest_area f 
    JOIN land_area l ON l.country_code = f.country_code 
    AND l.year = f.year 
    JOIN regions r ON r.country_code = f.country_code
);
WITH table_quartile AS (
  select 
    region, 
    country_name, 
    forest_area_percent, 
    CASE WHEN forest_area_percent >= 75 THEN '75%-100%' WHEN forest_area_percent >= 50 THEN '50%-75%' WHEN forest_area_percent >= 25 THEN '25%-50%' ELSE '0-25%' END AS quartiles 
  from 
    deforestation 
  where 
    year = 2016 
    AND forest_area_percent IS NOT NULL 
    AND country_name != 'World'
) 
select 
  country_name, 
  region, 
  ROUND(forest_area_percent :: NUMERIC, 2) AS Q4 
from 
  table_quartile 
where 
  quartiles = '75%-100%' 
order by 
  1 DESC


