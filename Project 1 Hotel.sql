--< Dataset Info>

--select the all data
SELECT *
FROM dbo.[2018]

SELECT *
FROM dbo.[2019]

SELECT *
FROM dbo.[2020]


-- check unique values on each columns

SELECT DISTINCT dbo.[2018].arrival_date_month FROM dbo.[2018]
SELECT DISTINCT dbo.[2018].hotel FROM dbo.[2018]
SELECT DISTINCT dbo.[2018].market_segment FROM dbo.[2018]
SELECT DISTINCT dbo.[2018].meal FROM dbo.[2018]
SELECT DISTINCT dbo.[2018].customer_type FROM dbo.[2018]


-- count the reservation count based on hotel type

SELECT 
	dbo.[2018].hotel,
	COUNT(dbo.[2018].hotel) as ReservationCountbyHotel
FROM dbo.[2018]
GROUP BY dbo.[2018].hotel


-- count the reservation count based on month

SELECT 
	dbo.[2018].arrival_date_month,
	COUNT(dbo.[2018].hotel) as ReservationCountbyMonth
FROM dbo.[2018]
GROUP BY dbo.[2018].arrival_date_month


-- count the reservation count based on hotel type

SELECT 
	dbo.[2018].market_segment,
	COUNT(dbo.[2018].hotel) as ReservationCountbyMarketSegment
FROM dbo.[2018]
GROUP BY dbo.[2018].market_segment


-- count the customer count based on hotel type

SELECT 
	dbo.[2018].hotel,
	sum(dbo.[2018].adults+dbo.[2018].children) as CustomerCountbyHotel
FROM dbo.[2018]
GROUP BY dbo.[2018].hotel


-- count the customer count based on month

SELECT 
	dbo.[2018].arrival_date_month,
	sum(dbo.[2018].adults+dbo.[2018].children) as CustomerCountbyMonth
FROM dbo.[2018]
GROUP BY dbo.[2018].arrival_date_month


--<Add new column for OrderSegment>

ALTER TABLE [Hotel Project].dbo.[2018]
DROP COLUMN order_segment

alter table [Hotel Project].dbo.[2018]
add order_segment varchar(300)

UPDATE [Hotel Project].dbo.[2018] 
SET [Hotel Project].dbo.[2018].order_segment = 
CASE
	WHEN (dbo.[2018].adults + dbo.[2018].children) < 3 THEN 'Small Group'
	WHEN (dbo.[2018].adults + dbo.[2018].children) BETWEEN 3 AND 6 THEN 'Medium Group'
	WHEN (dbo.[2018].adults + dbo.[2018].children) > 6 THEN 'Large Group'
	ELSE 'Unknown'
END

SELECT 
	dbo.[2018].order_segment,
	count(dbo.[2018].order_segment) as Frequency
FROM dbo.[2018]
GROUP BY dbo.[2018].order_segment

-- <Combine the dataset>
-- use union to unite 3 years of dataset
SELECT *FROM [Hotel Project].dbo.[2018]
UNION
SELECT *FROM [Hotel Project].dbo.[2019]
UNION
SELECT *FROM [Hotel Project].dbo.[2020]

-- create table named 'hotels' to combine three dataset
WITH hotels AS (
SELECT * FROM [Hotel Project].dbo.[2018]
UNION
SELECT * FROM [Hotel Project].dbo.[2019]
UNION
SELECT * FROM [Hotel Project].dbo.[2020] )

-- calculate the revenue based on the numbers of night
SELECT arrival_date_year,
sum( (stays_in_week_nights + stays_in_weekend_nights) * adr ) as revenue
FROM hotels
group by arrival_date_year


