-- zepto_sql_project database/schema
USE zepto_sql_project;

-- check if the table already exist
DROP TABLE IF EXISTS zepto;

-- Create a table and import all the data into this table from the csv file
CREATE TABLE zepto(
	sku_id INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp NUMERIC(8,2),
    discountPercent NUMERIC(4,2),
    availableQuantity INT,
    discountedSellingPrice NUMERIC(8,2),
	weightInGms INT,
    outOfStock BOOLEAN,
    quantity INT
);


-- Data Exploration-----------------------------------------------------------------------------------

-- 1. count the total num of rows in database
SELECT COUNT(*) FROM zepto;

-- 2. look at 10 rows of data from the column zepto (sample data)
SELECT * FROM zepto LIMIT 10;

-- 3. check for the null values
SELECT * FROM zepto
WHERE name IS NULL 
OR 
discountPercent IS NULL
OR 
availableQuantity IS NULL
OR 
discountedSellingPrice IS NULL
OR 
weightInGms IS NULL
OR 
outOfStock IS NULL
OR 
quantity IS NULL
OR
category IS NULL;

-- 4. Check explore the category col
-- 4.1 check the distinct category

SELECT DISTINCT category FROM zepto ORDER BY category;

-- 4.2 Lets check how many product are in stock and out of stock
SELECT outOfStock, COUNT(sku_id)
FROM zepto 
GROUP BY outOfStock;

-- 4.3 products names present multiple times
SELECT name, COUNT(sku_id) as "Number of SKUs"
FROM zepto 
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;


-- Data Cleaning--------------------------------------------------------------------------------
-- 1. check if any product price is tagged zero or the selling price is zero
SELECT * FROM zepto 
WHERE mrp = 0 or discountedSellingPrice = 0;

-- Lets delete this row with price zero
-- a. Turn off safe updates mode
SET SQL_SAFE_UPDATES = 0;
-- b. Delete the row
DELETE FROM zepto 
WHERE mrp = 0;
-- c. Turn on the safe updates mode back
SET SQL_SAFE_UPDATES = 1;


-- 3. solve the currency problem :
-- The prices are in indian paisa we need to convert this to rupees :- 1 rupee = 100 paisa

SET SQL_SAFE_UPDATES = 0; 

UPDATE zepto
SET mrp = mrp/100,
discountedSellingPrice = discountedSellingPrice/100;

SET SQL_SAFE_UPDATES = 1;

-- Delivering Business Insights ---------------------------------------------

-- Q1. Find the top 10 best value product based on the discount percentage.
SELECT DISTINCT name, discountPercent
FROM zepto 
ORDER BY discountPercent DESC
LIMIT 10;

-- Q2. What are the product with high MRP but Out of Stock - This can be missed revenue opportunity 
--     and company might want to restock this if the customer are buying it frequently
SELECT DISTINCT name,mrp,outOfStock FROM zepto
WHERE outOfStock = True and mrp > (SELECT AVG(MRP) FROM zepto)
ORDER BY mrp DESC
LIMIT 10;

-- Q3. Calculate the estimate revenue for each category
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto 
GROUP BY category
ORDER BY total_revenue;

-- Q4 Find all products where MRP is greater than Rupees 500 and discount percentage < 10%.
-- this type of items already sell well without giving discounts
SELECT DISTINCT name, mrp, discountPercent
FROM zepto 
WHERE mrp > 500 and discountPercent < 10
ORDER BY mrp DESC;

-- Q5 Identify the top 5 categories offering the highest avg discount percentage
-- help understand where price cuts are happening the most
SELECT category, AVG(discountPercent) AS avg_discount_percentage
FROM zepto 
GROUP BY category
ORDER BY avg_discount_percentage DESC
LIMIT 5;

-- Q6. Find the price per gram for products that weigh over 100g and sort by best value.
-- helpful for customer comparing money for value for product and for internal pricing strategies

SELECT DISTINCT name, (discountedSellingPrice/weightInGms) as price_per_gms
FROM zepto 
WHERE weightInGms > 100
ORDER BY price_per_gms DESC;

-- Q7. Group products into categories Light, Medium, Bulky based on their weight in grams
-- This help products to decide what to packaging, delivery planning and bulk order strategy
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN "Light"
	WHEN weightInGms < 5000 THEN "Medium"
    ELSE "Bulky"
END AS weight_category
FROM zepto;

-- Q8. What is the total Inventory Weight Per Category
-- Helps for warehouse planning and identifing bulky categories
SELECT category, SUM(weightInGms * availableQuantity) AS total_weigth_by_category_available
FROM zepto 
GROUP BY category
ORDER BY total_weigth_by_category_available;