# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `sql_project_p1`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project_p1`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE sql_project_p1;

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
```
- **Staging Table Creation**: A table named `retail_sales_staging` is created, this is where the data will be manipulated and retaining the original table `retail_sales` as raw data to lessen the risk of doing complex queries.
- 
### 2. Data Exploration & Cleaning

- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.
```sql
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
```
- **Record Count**: Determine the total number of records in the dataset.
```sql
SELECT COUNT(*)
FROM retail_sales_staging;
```
- **Customer Count**: Find out how many unique customers are in the dataset.
```sql
SELECT COUNT(DISTINCT customer_id) AS no_of_customers
FROM retail_sales_staging;
```
- **Category Count**: Identify all unique product categories in the dataset.
```sql
SELECT DISTINCT category
FROM retail_sales_staging;
```


### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05'**:
```sql
SELECT *
FROM retail_sales_staging
WHERE sale_date = '2022-11-05';
```

2. **Write an SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is greater than or equal to 4 in the month of Nov-2022**:
```sql
SELECT *
FROM retail_sales_staging
WHERE 
	category = 'Clothing'
    AND
    quantiy >= 4
    AND
    DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT
	category, 
	SUM(total_sale) as gross_sales
FROM retail_sales_staging
GROUP BY
	category;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT 
	category, 
    AVG(age)
FROM retail_sales_staging
GROUP by
	category
HAVING
	category = 'Beauty';
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT *
FROM retail_sales_staging
WHERE
	total_sale > 1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT 
	category, 
    gender, 
    COUNT(transactions_id)
FROM retail_sales_staging
GROUP BY
	category,
	gender
ORDER BY
	category;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT 
	customer_id,
    SUM(total_sale),
    RANK() OVER(ORDER BY SUM(total_sale) desc) as ranking
FROM retail_sales_staging
GROUP BY
	customer_id
LIMIT 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT 
	category,
	COUNT(DISTINCT customer_id)
FROM retail_sales_staging
GROUP BY 
	category;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
GROUP BY 
	shift;
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## Author - Asqrd

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

