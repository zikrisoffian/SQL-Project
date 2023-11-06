-- < Info of dataset>
-- select all data from the table
SELECT *
FROM dbo.sales_data_sample

-- count the data based on productline
SELECT PRODUCTLINE,
COUNT(PRODUCTLINE) as COUNT_BY_PRODUCTLINE
FROM dbo.sales_data_sample
GROUP BY PRODUCTLINE

-- calculate the sales
SELECT PRODUCTLINE,
ROUND(SUM(SALES),2) as SALES_BY_PRODUCTLINE
FROM dbo.sales_data_sample
GROUP BY PRODUCTLINE

-- check unique values on each columns
SELECT DISTINCT status FROM dbo.sales_data_sample --nice to plot
SELECT DISTINCT year_id FROM dbo.sales_data_sample
SELECT DISTINCT productline FROM dbo.sales_data_sample --nice to plot
SELECT DISTINCT productcode FROM dbo.sales_data_sample --nice to plot
SELECT DISTINCT dealsize FROM dbo.sales_data_sample -- nice to plot
SELECT DISTINCT country FROM dbo.sales_data_sample --nice to plot

-- check unique value of sales period (months)
SELECT DISTINCT month_id 
FROM dbo.sales_data_sample
WHERE year_id = 2003

-- <Analysis>
-- Group the sales by productline
-- Order by descending value of revenue
SELECT productline, 
round(sum(sales),2) as Revenue
FROM dbo.sales_data_sample
GROUP BY productline
ORDER BY Revenue DESC

-- Group the sales by productline and productcode
-- Order by descending value of revenue
SELECT productline,
productcode, 
round(sum(sales),2) as Revenue
FROM dbo.sales_data_sample
GROUP BY productline, productcode
ORDER BY Revenue DESC

--Group the sales based on the year
-- Order by descending value of revenue
SELECT year_id, 
round(sum(sales),2) as Revenue
FROM dbo.sales_data_sample
GROUP BY year_id
ORDER BY Revenue DESC

--Group the sales based on the country
-- Order by descending value of revenue
SELECT country, 
round(sum(sales),2) as Revenue
FROM dbo.sales_data_sample
GROUP BY country
ORDER BY Revenue DESC

--Group the sales based on the dealsize
-- Order by descending value of revenue
SELECT dealsize, 
round(sum(sales),2) as Revenue
FROM dbo.sales_data_sample
GROUP BY dealsize
ORDER BY Revenue DESC

-- <Asking the right question> 
-- Q1: What was the best month for sales in a specific year? How much was earned?
-- 2003
SELECT month_id,
round(sum(sales),2) as Revenue,
count(ordernumber) as Frequency
FROM dbo.sales_data_sample
WHERE year_id = 2003
GROUP BY month_id
ORDER BY 1 

-- 2004
SELECT month_id,
round(sum(sales),2) as Revenue,
count(ordernumber) as Frequency
FROM dbo.sales_data_sample
WHERE year_id = 2004
GROUP BY month_id
ORDER BY 1 

-- 2005
SELECT month_id,
round(sum(sales),2) as Revenue,
count(ordernumber) as Frequency
FROM dbo.sales_data_sample
WHERE year_id = 2005
GROUP BY month_id
ORDER BY 1 

-- How much revenue group by productline does they make in specific month
-- November 2003
SELECT month_id,
productline,
round(sum(sales),2) as Revenue,
count(ordernumber) as Frequency
FROM dbo.sales_data_sample
WHERE year_id = 2003 and month_id = 11
GROUP BY month_id, productline
ORDER BY 3 DESC

--November 2004
SELECT 
	month_id,
	productline,
	round(sum(sales),2) as Revenue,
	count(ordernumber) as Frequency
FROM dbo.sales_data_sample
WHERE year_id = 2004 and month_id = 11
GROUP BY month_id, productline
ORDER BY 3 DESC

-- Q2: Who is the best customers? 
-- RFM : Recency-frequency_monetory
-- RFM is an indexing technique that uses past purchase bahavior to segment customers 
-- RFM report is a way of segmenting using three key metrics:
-- 1. Recency (how long ago the purchase was made) -> last order data
-- 2. Frequency (how often the customer purchase) -> count of total orders
-- 3. Monetary value (how much the customer spent) -> total spend

DROP TABLE IF EXISTS #rfm
;with rfm as
(
	SELECT 
		customername, 
		round(sum(sales),2) as MonetaryValue,
		round(avg(sales),2) as AverageMonetaryValue,
		count(ordernumber) as Frequency,
		max(orderdate) as LastOrderDate, -- max order date based on each customer
		(SELECT max(orderdate) FROM dbo.sales_data_sample ) as MaxOrderDate, -- max order date of the whole dateset
		DATEDIFF(DD,max(orderdate), (SELECT max(orderdate) FROM dbo.sales_data_sample )) as Recency -- difference between last order date and whole dataset
	FROM dbo.sales_data_sample
	GROUP BY customername
),

rfm_calc as  
(
	SELECT r.*,
		NTILE(4) OVER (ORDER BY Recency desc) as rfm_recency, --create the number of bucket we want to create
		NTILE(4) OVER (ORDER BY Frequency) as rfm_frequency,
		NTILE(4) OVER (ORDER BY MonetaryValue) as rfm_monetary
	FROM rfm as r
)

SELECT 
	c.*, 
	rfm_recency + rfm_frequency + rfm_monetary as rfm_cell,
	cast(rfm_recency as varchar) + cast(rfm_frequency as varchar) + cast(rfm_monetary as varchar) as rfm_cell_string
INTO #rfm
FROM rfm_calc as c

-- call our table that we created above #rfm
SELECT *
FROM #rfm
ORDER BY 2 desc

SELECT 
	customername,
	rfm_recency,
	rfm_monetary,
	rfm_frequency,
		case 
			when rfm_cell_string in (111, 112 , 121, 122, 123, 132, 211, 212, 114, 141) then 'lost_customers'  --lost customers
			when rfm_cell_string in (133, 134, 143, 244, 334, 343, 344, 144) then 'slipping away, cannot lose' -- (Big spenders who havenÅft purchased lately) slipping away
			when rfm_cell_string in (311, 411, 331) then 'new customers'
			when rfm_cell_string in (222, 223, 233, 322) then 'potential churners'
			when rfm_cell_string in (323, 333,321, 422, 332, 432) then 'active' --(Customers who buy often & recently, but at low price points)
			when rfm_cell_string in (433, 434, 443, 444) then 'loyal'
		end rfm_segment
FROM #rfm

-- Q2: What is the best combination of products? 

-- the order number is not unique
-- there are lots of rows for one ordernumber
SELECT
	ordernumber,
	count(*) as totalbuy
FROM dbo.sales_data_sample
WHERE status = 'Shipped'
GROUP BY ordernumber

-- take one example of order number (eg:10411)
SELECT *
FROM dbo.sales_data_sample
WHERE ordernumber = 10411

-- best combintation of two product

SELECT distinct OrderNumber , stuff(
	(SELECT ',' + PRODUCTCODE
	FROM dbo.sales_data_sample as p 
	WHERE ORDERNUMBER in
		(
		SELECT ordernumber
		FROM (
			SELECT
				ordernumber,
				count(*) as totalbuy
			FROM dbo.sales_data_sample
			WHERE status = 'Shipped'
			GROUP BY ordernumber
		) as m
		WHERE totalbuy = 2
	)
	and p.ORDERNUMBER = s.ORDERNUMBER
		for xml path(''))
		,1, 1,'') as ProductCode

FROM dbo.sales_data_sample as s 
ORDER BY 2 desc