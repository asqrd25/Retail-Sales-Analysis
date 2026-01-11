-- SQL Retail Sales Analysis

-- Create Database for Project
DROP DATABASE IF EXISTS sql_project_p1;
CREATE DATABASE sql_project_p1;

-- Create Table in sql_project_p1
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
	(
		transactions_id	INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,
		customer_id INT,
		gender TEXT,
		age INT,
		category TEXT,	
		quantiy	INT,
		price_per_unit DECIMAL(10,2),
		cogs DECIMAL(10,2),
		total_sale DECIMAL(10,2)
	);

-- Import data, in MySQL blank numerical values does not import. Manipulate raw data, turn blanks to NULL
SELECT *
FROM retail_sales;

-- Create a staging table duplicate to the raw data imported and make this your manipulable data
DROP TABLE IF EXISTS retail_sales_staging;
CREATE TABLE retail_sales_staging
LIKE retail_sales;

INSERT retail_sales_staging
SELECT *
FROM retail_sales;

SELECT *
FROM retail_sales_staging;

-- Check the data
SELECT COUNT(*)
FROM retail_sales_staging;

SELECT *
FROM retail_sales_staging
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
    OR
    sale_time IS NULL
    OR
    customer_id IS NULL
    OR
    gender IS NULL
    OR
    age IS NULL
    OR
    category IS NULL
    OR
    quantiy IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL
;

-- Delete unusable data
SELECT *
FROM retail_sales_staging
WHERE 
	transactions_id IS NULL
	OR
    quantiy IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL
;

DELETE
FROM retail_sales_staging
WHERE
	transactions_id IS NULL
	OR
    quantiy IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL
;

SELECT COUNT(*)
FROM retail_sales_staging;

SELECT *
FROM retail_sales_staging;

-- Data Exploration

-- How many record of sales do we have?
SELECT COUNT(transactions_id) AS total_sale
FROM retail_sales_staging;

-- How many customers do we have?
SELECT COUNT(DISTINCT customer_id) AS no_of_customers
FROM retail_sales_staging;

-- How many categories do we have?
SELECT COUNT(DISTINCT category) AS no_of_categories
FROM retail_sales_staging;

-- What are the categories that we have?
SELECT DISTINCT category
FROM retail_sales_staging;

-- Data Analysis & Business Key Problems & Answers

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is greater than or equal to 4 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT *
FROM retail_sales_staging
WHERE sale_date = '2022-11-05';

-- Q.2 Write an SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is greater than or equal to 4 in the month of Nov-2022
SELECT *
FROM retail_sales_staging
WHERE 
	category = 'Clothing'
    AND
    quantiy >= 4
    AND
    DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category, SUM(total_sale) as gross_sales
FROM retail_sales_staging
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT category, AVG(age)
FROM retail_sales_staging
GROUP by category
	HAVING
		category = 'Beauty';
        
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM retail_sales_staging
WHERE
	total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category, gender, COUNT(transactions_id)
FROM retail_sales_staging
GROUP BY category, gender
ORDER BY category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
WITH monthly_sales_ranking AS
	(
		SELECT 
		YEAR(sale_date) as `year`,
		MONTH(sale_date) as `month`,
		avg(total_sale) as monthly_sale,
		RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY avg(total_sale) desc) as ranking
		FROM retail_sales_staging
		GROUP BY `year`, `month`
		ORDER BY 1,3 desc
	)
SELECT *
FROM monthly_sales_ranking
WHERE ranking = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
	customer_id,
    SUM(total_sale),
    RANK() OVER(ORDER BY SUM(total_sale) desc) as ranking
FROM retail_sales_staging
GROUP BY customer_id
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
	category,
	COUNT(DISTINCT customer_id)
FROM retail_sales_staging
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH order_count_per_shift AS
	(
		SELECT *,
			CASE
				WHEN HOUR(sale_time) < 12 THEN 'Morning'
				WHEN HOUR(sale_time)  BETWEEN 12 AND 17 THEN 'Afternoon'
				WHEN HOUR(sale_time) > 17 THEN 'Evening'
			END AS shift
		FROM retail_sales_staging
	)
SELECT 
	shift, 
    COUNT(transactions_id) as order_count
FROM order_count_per_shift
GROUP BY shift;

-- End of Project