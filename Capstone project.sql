--Capstone project 1

--Monday, February 20, 2023

select count(customer_id)
from customers;


--2.

SELECT orders.shipping_city, SUM(order_details.order_profits) AS total_profits
FROM order_details
JOIN orders
ON orders.order_id = order_details.order_id
WHERE order_date >= CAST('2015-01-01' AS DATE) AND order_date < CAST('2016-01-01' AS DATE)
GROUP BY orders.shipping_city
ORDER BY total_profits DESC
LIMIT 1;

--ALTERNATIVELY

SELECT orders.shipping_city, SUM(order_details.order_profits) AS total_profits
FROM order_details
JOIN orders
ON orders.order_id = order_details.order_id
WHERE date_part('year', order_date)='2015'
GROUP BY orders.shipping_city
ORDER BY total_profits DESC
LIMIT 1;


--How many different cities do we have in the data?   

select COUNT(DISTINCT shipping_city)
from orders;

-- Show the total spent by customers from low to high.

SELECT customers.customer_id,
    SUM(order_sales) AS total_spent
from orders
    join customers on customers.customer_id = orders.customer_id
    join order_details on order_details.order_id = orders.order_id
group by 1
order by total_spent ASC;

-- What is the most profitable city in the State of Tennessee?
 
SELECT SUM(order_details.order_profits), orders.shipping_city
from orders
join order_details
on order_details.order_id=orders.order_id
where shipping_state ='Tennessee'
group by 2
order by 1 desc
limit 1;


--What’s the average annual profit for that city across all years?

SELECT ROUND(AVG(order_details.order_profits),2)
from orders
join order_details
on order_details.order_id=orders.order_id
where shipping_state ='Tennessee' and shipping_city='Lebanon';

--What is the distribution of customer types in the data?

SELECT customer_segment, count(customer_segment)
from customers
group by 1

-- What’s the most profitable product category on average in Iowa across all years?
  
SELECT ROUND(AVG(order_profits),2), product_category
FROM order_details
JOIN product
ON order_details.product_id=product.product_id
JOIN orders
ON order_details.order_id=orders.order_id
where shipping_state='Iowa'
group by 2;

-- What is the most popular product in that category across all states in 2016?



SELECT SUM(order_details.order_sales) AS total_sales, product.product_name, COUNT(order_details.order_id) AS num_orders
FROM order_details
JOIN product
ON order_details.product_id=product.product_id
JOIN orders
ON order_details.order_id=orders.order_id
WHERE product.product_category='Furniture' AND date_part('year', order_date)='2016'
GROUP BY product.product_name
ORDER BY num_orders DESC;

-- Which customer got the most discount in the data? (in total amount)

SELECT sum((order_discount*order_sales/(1-order_discount))) AS overall_discount_amount, customer_name
FROM order_details
JOIN orders
ON order_details.order_id=orders.order_id
JOIN customers
ON orders.customer_id=customers.customer_id
group by customer_name
order by overall_discount_amount desc;


--How widely did monthly profits vary in 2018?

SELECT  (MAX(order_details.order_profits)-MIN(order_details.order_profits)) AS profit_range
FROM order_details
JOIN orders
ON order_details.order_id=orders.order_id
WHERE DATE_TRUNC('month',orders.order_date) >= CAST('2018-01-01' AS DATE) AND DATE_TRUNC('month',orders.order_date) < CAST('2019-01-01' AS DATE);

--Modified below

SELECT DATEDIFF(MAX(order_details.order_profits), MIN(order_details.order_profits)) AS profit_range
FROM order_details
JOIN orders ON order_details.order_id = orders.order_id
WHERE DATE_TRUNC('month', orders.order_date) >= CAST('2018-01-01' AS DATE) AND DATE_TRUNC('month', orders.order_date) < CAST('2019-01-01' AS DATE);


--We can also able to show the standard deviation for the whole year as follows 


SELECT STDDEV_POP(order_details.order_profits) AS profit_stddev
FROM order_details
JOIN orders ON order_details.order_id = orders.order_id
WHERE DATE_TRUNC('year', orders.order_date) = CAST('2018-01-01' AS DATE);

--ALTERNATIVELY

SELECT
  DATE_TRUNC('month', order_date) AS month,
  SUM(order_profits) AS total_profit,
  LAG(SUM(order_profits), 1) OVER (ORDER BY DATE_TRUNC('month', order_date)) AS previous_month_sales,
  (SUM(order_profits) - LAG(SUM(order_profits), 1) OVER (ORDER BY DATE_TRUNC('month', order_date))) AS profit_variation
FROM
  order_details
JOIN orders
ON order_details.order_id=orders.order_id
WHERE
  EXTRACT(year FROM order_date) = 2018
GROUP BY
  DATE_TRUNC('month', order_date)
ORDER BY
  DATE_TRUNC('month', order_date)


--Which order was the highest in 2015? Date_part or date_trunc


SELECT order_details.order_id, order_details.product_id, order_details_id, *
FROM order_details
JOIN orders ON order_details.order_id = orders.order_id
WHERE order_date >= CAST('2015-01-01' AS DATE) 
  AND order_date < CAST('2016-01-01' AS DATE)
  AND order_details.order_sales = (
    SELECT MAX(order_sales) 
    FROM order_details
    WHERE order_date >= CAST('2015-01-01' AS DATE) 
      AND order_date < CAST('2016-01-01' AS DATE)
  )

SELECT order_details.order_id, order_details.product_id, order_details_id, *
FROM order_details
JOIN orders ON order_details.order_id = orders.order_id
WHERE DATE_PART ('year', order_date) ='2015'  AND order_details.order_sales = (
    SELECT MAX(order_sales) 
    FROM order_details
    WHERE DATE_PART ('year', order_date) ='2015' 
  )

--What was the rank of each city in the East region in 2015

SELECT
  shipping_city,
  shipping_region,
  sum(quantity),
  RANK() OVER (ORDER BY sum(quantity) DESC) AS rank
FROM
  order_details
JOIN orders
ON order_details.order_id=orders.order_id
WHERE shipping_region='East' AND DATE_PART('year', order_date)='2015'
GROUP BY
  1, 2;


--Display customer names for customers who are in the segment ‘Consumer’ or ‘Corporate.’ How many customers are there in total?


SELECT 
  customer_name 
FROM 
  customers 
WHERE 
  customer_segment IN ('Consumer', 'Corporate');

SELECT 
  COUNT(DISTINCT customer_id) AS num_customers 
FROM 
  customers 
WHERE 
  customer_segment IN ('Consumer', 'Corporate');



--Calculate the difference between the largest and smallest order quantities for product id ‘100.’

SELECT (MAX(order_details.quantity)-MIN(order_details.quantity)) AS range_100
from order_details
where product_id=100;


--Calculate the percent of products that are within the category ‘Furniture.’ 

WITH t1 AS (
    SELECT COUNT(product_id) AS total_product
FROM product),
t2 AS (SELECT count(product_id) AS total_furniture
from product
where product_category = 'Furniture' )
select (total_furniture/CAST(total_product AS float))*100 as percentage
from t1, t2;

--Display the number of duplicate products based on their product manufacturer. 
Example: A product with an identical product manufacturer can be considered a duplicate.

SELECT 
  product_manufacturer, 
  COUNT(*) AS num_duplicates 
FROM 
  product 
GROUP BY 
  product_manufacturer 
HAVING 
  COUNT(*) > 1;


--Show the product_subcategory and the total number of products in the subcategory. Show the order from most to least products and then by product_subcategory name ascending.


select product_subcategory, count(*) AS count_product
from product
group by product_subcategory
order by count_product DESC, product_subcategory ASC;


--Show the product_id(s), the suproductm of quantities, where the total sum of its product quantities is greater than or equal to 100.


SELECT product_id, SUM(quantity) AS total
FROM order_details
GROUP BY product_id
HAVING SUM(quantity) >= 100

--⭐
--Join all database tables into one dataset that includes all unique columns and download it as a .csv file.

SELECT customers.customer_id, customer_name,customer_segment,order_details_id,order_details.order_id,
order_details.product_id,quantity,order_discount,order_profits,order_profit_ratio,order_sales,
order_date,shipping_city,shipping_state,shipping_state,shipping_region,shipping_country,shipping_postal_code,
shipping_date,shipping_mode,product_name,product_category,product_subcategory,product_manufacturer
FROM customers
JOIN orders
ON customers.customer_id=orders.customer_id
JOIN order_details
ON orders.order_id=order_details.order_id
JOIN product
ON order_details.product_id=product.product_id

