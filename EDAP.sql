SELECT *
FROM amazon_sales;

-- The minumum and maximum of Sales, Profit and Discount
SELECT MIN(Sales), MAX(Sales) , MIN(Profit), MAX(Profit), MIN(Discount), MAX(Discount)
FROM amazon_sales;

-- The total sales of each City
SELECT City, SUM(Sales)
FROM amazon_sales
GROUP BY City
ORDER BY 2 DESC;

-- From when and till the orders started to end
SELECT MIN(Purchase_Date), MAX(Purchase_Date)
FROM amazon_sales;

-- Most common Ship_Mode
SELECT Ship_Mode, COUNT(*) AS Total_Usage
FROM amazon_sales
GROUP BY Ship_Mode
ORDER BY Total_Usage DESC;

-- Highest sales in each Category
SELECT Category, SUM(Sales) AS Highest_Sales
FROM amazon_sales
GROUP BY Category
ORDER BY Highest_Sales DESC;

--  Highest sales in each Sub_Category
SELECT Sub_Category, SUM(Sales) AS Highest_Sales_Sub
FROM amazon_sales
GROUP BY Sub_Category
ORDER BY Highest_Sales_Sub DESC;

-- Which states bought the most items
SELECT State, COUNT(*) AS Common_State
FROM amazon_sales
GROUP BY State
ORDER BY Common_State DESC;

-- Gave Sales a type and then gave me a total of that type
SELECT 
CASE
	WHEN Sales > 1000 THEN 'High Sales'
    WHEN Sales BETWEEN 100 AND 1000 THEN 'Medium Sales' 
    WHEN Sales < 100 THEN 'Low Sales'
END AS Sales_Type,
COUNT(*) AS Order_Total
FROM amazon_sales
GROUP BY Sales_Type;

-- Gave the different Categories and Sub-Categories
SELECT DISTINCT Category, Sub_Category
FROM amazon_sales
ORDER BY Category;

-- The top 3 Sub-Categories with the most sales 
SELECT Sub_Category, SUM(Sales) AS Total_Sales
FROM amazon_sales
WHERE Category = 'Office Supplies'
GROUP BY Sub_Category
ORDER BY Total_Sales DESC
LIMIT 3;

-- Which products in the Furniture category had sales greater than 500 AND profit less than 50?
SELECT Sub_Category, Sales, Profit
FROM amazon_sales
WHERE Category = 'Furniture' AND Sales > 500 AND Profit < 50;

-- Which Sub-Categories start with anything and end is 'es'?
SELECT DISTINCT Sub_Category
FROM amazon_sales
WHERE Sub_Category LIKE '%es';

-- Which states have an average discount greater than 20?
SELECT State
FROM amazon_sales
GROUP BY State
HAVING AVG(Discount) > 20;

-- Which year had the highest sales?
SELECT
SUBSTRING(Purchase_Date,1,4) AS Year,
SUM(Sales) AS Total_Sales
FROM amazon_sales
GROUP BY SUBSTRING(Purchase_Date,1,4)
ORDER BY Total_Sales DESC
LIMIT 1;

-- Categorise profit as ‘Loss’, ‘Low Profit’, or ‘High Profit’ using thresholds of your choice
SELECT Profit,
    CASE
        WHEN Profit < 0 THEN 'Loss'
        WHEN Profit BETWEEN 0 AND 100 THEN 'Low Profit'
        ELSE 'High Profit'
END AS Profit_Category
FROM amazon_sales;

-- Rolling total of sales by purchase_date
SELECT SUBSTRING(Purchase_Date,1,7) AS `MONTH`, SUM(Sales) AS total_sales
FROM amazon_sales
WHERE SUBSTRING(Purchase_Date,1,7) IS NOT NULL
GROUP BY `MONTH` 
ORDER BY 1 ASC; 
							
WITH rolling_total AS
(
SELECT SUBSTRING(Purchase_Date,1,7) AS `MONTH`, SUM(Sales) AS total_sales
FROM amazon_sales
WHERE SUBSTRING(Purchase_Date,1,7) IS NOT NULL
GROUP BY `MONTH`  		   
ORDER BY 1 ASC							
)
SELECT `MONTH`, total_sales,
SUM(total_sales) OVER(ORDER BY `MONTH`) AS rolling_total_column
FROM rolling_total;
