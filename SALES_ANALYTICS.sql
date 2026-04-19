-- using sales_intelligence_db for the project
USE sales_intelligence_db;

-- UNDERSTANDING DATA

-- 1. checking for the tables imported, table schema, table name
SELECT *
FROM INFORMATION_SCHEMA.TABLES

--raw_Sales_table
--raw_Customer_table
--raw_Return_table
--raw_Product_table

-- 2. checking for the table data, column names, column's data types of the respective table

--Sales_table
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'raw_Sales_table';

--Order_ID
--Order_Date
--Delivery_Date
--Customer_ID
--Product_ID
--Order_Qty

SELECT *
FROM raw_Sales_table;

--Customer_table
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'raw_Customer_table';

--Customer_ID
--Customer_Full_Name
--Customer_Date_of_Birth
--Gender
--Location
--Contact_no
--Email_ID
--Customer_Segment

SELECT *
FROM raw_Customer_table;

--Return_table
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'raw_Return_table';

--Return_ID
--Return_Date
--Order_ID
--Return_Qty
--Return_Amount
--Return_Reason

SELECT *
FROM raw_Return_table;

--Product_table
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'raw_Product_table';

--Product_ID
--Product_Name
--Product_Category
--Cost_Price
--Selling_Price
--Discount

SELECT *
FROM raw_Product_table;


-- DATA CLEANING

-- 1. working copy of all the raw table

SELECT *
INTO cleaned_sales_table
FROM raw_Sales_table;

SELECT *
INTO cleaned_customer_table
FROM raw_Customer_table;

SELECT *
INTO cleaned_return_table
FROM raw_Return_table;

SELECT *
INTO cleaned_product_table
FROM raw_Product_table;

-- 2. fixing data types

--altering order date from VARCHAR to DATE in sales table
ALTER TABLE cleaned_sales_table
ALTER COLUMN Order_Date DATE;

--altering delivery date from VARCHAR to DATE in sales table
ALTER TABLE cleaned_sales_table
ALTER COLUMN Delivery_Date DATE;

--altering order quantity from FLOAT to INT in sales table
ALTER TABLE cleaned_sales_table
ALTER COLUMN Order_Qty INT;

--altering return date from VARCHAR to DATE in return table
ALTER TABLE cleaned_return_table
ALTER COLUMN Return_Date DATE;

--altering return quantity from FLOAT to INT in return table
ALTER TABLE cleaned_return_table
ALTER COLUMN Return_Qty INT;

--altering customer date of birth from VARCHAR to DATE in customer table
ALTER TABLE cleaned_customer_table
ALTER COLUMN Customer_Date_of_Birth DATE;

---------------------------------------------------------------------------------------------------------------------------
-- Q1. TABLE MERGING

-- Q1.1 Merge Sales_Order_Table and Customer_Table

SELECT
	s.*,
	c.*
FROM cleaned_sales_table AS s
LEFT JOIN cleaned_customer_table AS c
ON s.Customer_ID = c.Customer_ID;

-- Q1.2 Merge Sales_Order_Table and Product_Table

SELECT
	s.*,
	p.*
FROM cleaned_sales_table AS s
LEFT JOIN cleaned_product_table AS p
ON SOT.Product_ID = PT.Product_ID;

-- Q1.3 Merge Sales_Order_Table and Order_Return_Table

SELECT
	s.*,
	r.*
FROM cleaned_sales_table AS s
LEFT JOIN cleaned_return_table AS r
ON s.Order_ID = r.Order_ID;

----------------------------------------------------------------------------------------------------------------------------

-- merging all the 4 clean tables into one master table for analysis
SELECT
	s.Order_ID,
	s.Order_Date,
	s.Delivery_Date,
	s.Customer_ID,
	c.Customer_Full_Name,
	c.Customer_Date_of_Birth,
	c.Gender,
	c.Location,
	c.Contact_no,
	c.Email_ID,
	c.Customer_Segment,
	s.Product_ID,
	p.Product_Name,
	p.Product_Category,
	p.Cost_Price,
	p.Selling_Price,
	p.Discount,
	s.Order_Qty,
	r.Return_ID,
	r.Return_Date,
	r.Return_Qty,
	r.Return_Amount,
	r.Return_Reason
INTO sales_master_table
FROM cleaned_sales_table AS s
LEFT JOIN cleaned_customer_table AS c
ON s.Customer_ID = c.Customer_ID
LEFT JOIN cleaned_product_table AS p
ON s.Product_ID = p.Product_ID
LEFT JOIN cleaned_return_table AS r
ON s.Order_ID = r.Order_ID;

--viewing the final merged table
SELECT *
FROM sales_master_table;

-- validating data logic post merging

-- checking if any delivery date is before order date
SELECT *
FROM sales_master_table
WHERE Delivery_Date < Order_Date;

-- checking if return quantity is mentioned more than the order quantity
SELECT *
FROM sales_master_table
WHERE Return_Qty > Order_Qty;

-- checking if null exists post merging
SELECT *
FROM sales_master_table
WHERE 
	Customer_ID IS NULL
	OR
	Product_ID IS NULL
	OR
	Return_ID IS NULL;
-- turns out the return table post merging contains nulls

-- handling missing values
UPDATE sales_master_table
SET Return_Qty = (CASE
					WHEN Return_Qty IS NULL THEN 0
					ELSE Return_Qty
				END);

UPDATE sales_master_table
SET Return_Amount = (CASE
					WHEN Return_Amount IS NULL THEN 0
					ELSE Return_Amount
				END);

--------------------------------------------------------------------------------------------------------------------------
-- Q2. DATA TRANSFORMATION

-- Q2.1 Convert Order_Date and Delivery_Date into proper date format 

SELECT
	CAST(Order_Date AS DATE) AS Order_Date,
	CAST(Delivery_Date AS DATE) AS Delivery_Date
FROM sales_master_table;

-- Q2.2 Extract Year, Month, Quarter from Order_Date

SELECT
	YEAR(Order_Date) AS Year_Order_Date,
	MONTH(Order_Date) AS Month_Order_Date,
	CONCAT('Q', DATEPART(QUARTER, Order_Date)) AS Quarter_Order_Date
FROM sales_master_table;

-- Q2.3 Order_Delivery_Days = Delivery_Date – Order_Date

SELECT
	DATEDIFF(DAY, Order_Date, Delivery_Date) AS Order_Delivery_Days
FROM sales_master_table;

-- Q2.4 Create Age column from Customer_Date_of_Birth

SELECT
	DATEDIFF(YEAR, Customer_Date_of_Birth, GETDATE()) AS Age
FROM sales_master_table;

-- Q2.5 Create Age Group

SELECT
	CASE
		WHEN DATEDIFF(YEAR, Customer_Date_of_Birth, GETDATE()) > 60 THEN 'Senior'
		WHEN DATEDIFF(YEAR, Customer_Date_of_Birth, GETDATE()) > 40 THEN 'Mid_Age'
		WHEN DATEDIFF(YEAR, Customer_Date_of_Birth, GETDATE()) > 25 THEN 'Adult'
		ELSE 'Youth'
	END AS Age_Group
FROM sales_master_table;

-- Q2.6 Net Selling Price = Selling Price – Discount

SELECT
	FORMAT((Selling_Price - Discount), 'C0', 'INR-IN') AS net_selling_price
FROM sales_master_table;

-- 2.7 Total Sales Revenue= Order_Qty × Net Selling Price

SELECT
	FORMAT((Order_Qty * (Selling_Price - Discount)), 'C0', 'INR-IN') AS total_sales_revenue
FROM sales_master_table;