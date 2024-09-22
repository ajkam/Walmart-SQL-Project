-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales;

-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct DECIMAL(6,4) NOT NULL,  -- Changed FLOAT(6,4) to DECIMAL(6,4)
    total DECIMAL(12,4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct DECIMAL(11,9), -- Changed FLOAT(11,9) to DECIMAL(11,9)
    gross_income DECIMAL(12,4),
    rating DECIMAL(2,1) -- Changed FLOAT(2,1) to DECIMAL(2,1)
);

-- Total revenue by branch
SELECT branch, city, SUM(total) AS total_revenue
FROM sales
GROUP BY branch, city
ORDER BY total_revenue DESC;

-- Gross profit by branch
SELECT branch, SUM(gross_income) AS total_gross_profit
FROM sales
GROUP BY branch
ORDER BY total_gross_profit DESC;

-- Number of products sold by branch
SELECT branch, COUNT(invoice_id) AS total_sales
FROM sales
GROUP BY branch
ORDER BY total_sales DESC;

-- Revenue by customer type
SELECT customer_type, SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- Average spending by customer type
SELECT customer_type, AVG(total) AS avg_spending
FROM sales
GROUP BY customer_type;

-- Total sales by gender
SELECT gender, COUNT(invoice_id) AS total_sales
FROM sales
GROUP BY gender;

-- Revenue by gender
SELECT gender, SUM(total) AS total_revenue
FROM sales
GROUP BY gender
ORDER BY total_revenue DESC;

-- Total revenue by product line
SELECT product_line, SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- Average product rating by product line
SELECT product_line, AVG(rating) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- Total products sold by product line
SELECT product_line, COUNT(invoice_id) AS total_sold
FROM sales
GROUP BY product_line
ORDER BY total_sold DESC;

-- Adding a new column for time of day (morning, afternoon, evening)
SELECT invoice_id, time,
CASE
  WHEN HOUR(time) BETWEEN 6 AND 12 THEN 'Morning'
  WHEN HOUR(time) BETWEEN 12 AND 18 THEN 'Afternoon'
  ELSE 'Evening'
END AS time_of_day
FROM sales;

-- Sales by time of day
SELECT 
    CASE 
        WHEN HOUR(time) BETWEEN 6 AND 12 THEN 'Morning'
        WHEN HOUR(time) BETWEEN 12 AND 18 THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day, 
    SUM(total) AS total_revenue
FROM sales
GROUP BY time_of_day
ORDER BY total_revenue DESC;


-- Adding a new column for day of the week
SELECT invoice_id, DAYNAME(date) AS day_of_week
FROM sales;

-- Total sales by day of the week
SELECT DAYNAME(date) AS day_of_week, COUNT(invoice_id) AS total_sales, SUM(total) AS total_revenue
FROM sales
GROUP BY day_of_week
ORDER BY total_revenue DESC;

-- Average ratings by time of day
SELECT time_of_day, AVG(rating) AS avg_rating
FROM (
  SELECT invoice_id, rating, 
  CASE
    WHEN HOUR(time) BETWEEN 6 AND 12 THEN 'Morning'
    WHEN HOUR(time) BETWEEN 12 AND 18 THEN 'Afternoon'
    ELSE 'Evening'
  END AS time_of_day
  FROM sales
) AS rating_time
GROUP BY time_of_day;

-- Gross margin by product line
SELECT product_line, 
    SUM(gross_income) AS total_gross_profit, 
    SUM(total) AS total_revenue, 
    (SUM(gross_income) / SUM(total)) * 100 AS gross_margin_percentage
FROM sales
GROUP BY product_line
ORDER BY gross_margin_percentage DESC;

