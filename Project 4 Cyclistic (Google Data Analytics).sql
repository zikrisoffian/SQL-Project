-- <<Cyclistic study>>

------------>   1. CREATE TABLE    <-----------
-- Create a dataset of 2021 bicycle rental data
-- table name : #2021bicycle


DROP TABLE IF EXISTS #2021bicycle
;with #2021bicycle_data as
(

SELECT * FROM dbo.[202101-divvy-tripdata]
UNION
SELECT * FROM dbo.[202102-divvy-tripdata]
UNION
SELECT * FROM dbo.[202103-divvy-tripdata]
UNION
SELECT * FROM dbo.[202104-divvy-tripdata]
UNION
SELECT * FROM dbo.[202105-divvy-tripdata]
UNION
SELECT * FROM dbo.[202106-divvy-tripdata]
UNION
SELECT * FROM dbo.[202107-divvy-tripdata]
UNION
SELECT * FROM dbo.[202108-divvy-tripdata]
UNION
SELECT * FROM dbo.[202109-divvy-tripdata]
UNION
SELECT * FROM dbo.[202110-divvy-tripdata]
UNION
SELECT * FROM dbo.[202111-divvy-tripdata]
UNION
SELECT * FROM dbo.[202112-divvy-tripdata]
)

-- 1.1 All 2021 dataset
-- There are more than 5 million rows
SELECT *
INTO #2021bicycle
FROM #2021bicycle_data

--1.2 All 2021 dataset order by start time
SELECT * 
FROM #2021bicycle

--1.3 COUNT DISTINCT 2021 dataset 
-- we have 5,595,063 rows
SELECT COUNT(*)
FROM #2021bicycle

--1.4 COUNT DISTINCT 2021 dataset order by column
-- we have 5595063 rows. All ride_id are distinct
SELECT COUNT(DISTINCT(ride_id))
FROM #2021bicycle

--1.5 Remove "" Data

SELECT COUNT(*)
FROM #2021bicycle
WHERE ride_id = ''


------------>   2. COUNT NA    <-----------

--2.1 COUNT NA by start station name, start station id, end station name, end station id

-- > There are many NULL value for start station name and start station ID 690809
-- > There are many NULL value for end station name and end station ID 739170

SELECT COUNT(* )
FROM #2021bicycle
WHERE start_station_name IS NULL

SELECT COUNT(* )
FROM #2021bicycle
WHERE start_station_id IS NULL

SELECT COUNT(* )
FROM #2021bicycle
WHERE end_station_name IS NULL

SELECT COUNT(* )
FROM #2021bicycle
WHERE end_station_id IS NULL

--2.2 COUNT NA by ride_id and rideable_type
--> NO NULL 
SELECT COUNT(* )
FROM #2021bicycle
WHERE ride_id IS NULL

SELECT COUNT(* )
FROM #2021bicycle
WHERE rideable_type IS NULL

--2.3 COUNT NA by latitude and longitude

--> NULL COUNT in ending lat and long is 4771
SELECT COUNT(* )
FROM #2021bicycle
WHERE start_lat IS NULL

SELECT COUNT(* )
FROM #2021bicycle
WHERE end_lat IS NULL

SELECT COUNT(* )
FROM #2021bicycle
WHERE start_lng IS NULL

SELECT COUNT(* )
FROM #2021bicycle
WHERE end_lng IS NULL

--2.4 COUNT NA by membership type
--> NO NULL for member_casual column
SELECT COUNT(* )
FROM #2021bicycle
WHERE member_casual IS NULL

------------>   3.   DELETE NA    <-----------

-- 3.1 Delete NA rows
-- (1006761 rows affected)
DELETE FROM #2021bicycle
WHERE start_station_name IS NULL OR end_station_name IS NULL OR end_lat IS NULL;

-- 3.2 Query cleaned data
-- Total rows : 4,588,302
SELECT * 
FROM #2021bicycle
ORDER BY 3

------------>   4.  DATA ANALYSIS (SQL QUERY) Basic Count   <-----------

--4.1 Total rows in dataset
SELECT COUNT(*)
FROM #2021bicycle

--4.2 DISTINCT bike type
SELECT DISTINCT(rideable_type)
FROM #2021bicycle

--4.3 DISTINCT membership_type
SELECT DISTINCT(member_casual)
FROM #2021bicycle

--4.3 DISTINCT station name
SELECT DISTINCT(start_station_name)
FROM #2021bicycle

SELECT DISTINCT(end_station_name)
FROM #2021bicycle

-- 4.4 Count by bike type

SELECT 
	rideable_type,
	count(rideable_type) as frequency
FROM #2021bicycle
GROUP BY rideable_type
ORDER BY 2

-- 4.5 Count by membership

SELECT 
	member_casual,
	count(member_casual) as frequency
FROM #2021bicycle 
GROUP BY member_casual
ORDER BY 2

-- 4.6 Count by month_id
SELECT 
	MONTH(started_at) as month_id,
	COUNT(started_at) as frequency
FROM #2021bicycle
GROUP BY MONTH(started_at)
ORDER BY 1

-- 4.7 Count by hour_id
SELECT 
	DATEPART(HOUR,started_at) as hour_id,
	COUNT(started_at) as frequency
FROM #2021bicycle
GROUP BY DATEPART(HOUR,started_at)
ORDER BY 2

-- 4.8 Count start_station_name

SELECT
	start_station_name ,
	count(*) as frequency 
FROM #2021bicycle
GROUP BY start_station_name
ORDER BY 2 DESC

-- 4.9 Count end_station_name

SELECT
	end_station_name ,
	count(*) as frequency 
FROM #2021bicycle
GROUP BY end_station_name
ORDER BY 2 DESC

------------>   5.  DATA ANALYSIS (SQL QUERY) BY member_casual    <-----------

-- 5.1 Count rideable_type

SELECT 
	member_casual,
	rideable_type,
	count(member_casual) as frequency
FROM #2021bicycle
GROUP BY member_casual, rideable_type
ORDER BY 1,2

-- 5.2 Count month_id

SELECT 
	member_casual,
	MONTH(started_at) as month_id,
	count(started_at) as frequency
FROM #2021bicycle
GROUP BY member_casual, MONTH(started_at)
ORDER BY 1,2

-- 5.3 Count hour_id

SELECT 
	member_casual,
	DATEPART(HOUR,started_at) as hour_id,
	count(started_at) as frequency
FROM #2021bicycle
GROUP BY member_casual, DATEPART(HOUR,started_at)
ORDER BY 1,2

------------>   6.  DATA ANALYSIS (SQL QUERY) rental_period    <-----------

-- 6.1 SELECT TOP 100 for rental period 
SELECT TOP(100)
	started_at,
	ended_at,
	DATEDIFF(minute,started_at,ended_at) as rental_period
FROM #2021bicycle

-- 6.2 select sum, count, average and max of rental period
SELECT 
	member_casual,
	SUM(DATEDIFF(minute,started_at,ended_at)) as total_rental_period_min,
	COUNT(member_casual) as rental_count,
	SUM(DATEDIFF(minute,started_at,ended_at))/COUNT(member_casual) as average_rental_period_min,
	MAX(DATEDIFF(day,started_at,ended_at)) as max_rental_period_in_days
FROM #2021bicycle
GROUP BY member_casual

------------>   7.  DATA ANALYSIS (SQL QUERY) rental_route <-----------

-- 7.1 Count start_station_name

SELECT
	start_station_name ,
	count(*) as frequency 
FROM #2021bicycle
GROUP BY start_station_name
ORDER BY 2 DESC

-- 7.2 Count end_station_name

SELECT
	end_station_name ,
	count(*) as frequency 
FROM #2021bicycle
GROUP BY end_station_name
ORDER BY 2 DESC

-- 7.3 SELECT TOP 100 for rental_route

SELECT TOP(100)
	start_station_name,
	end_station_name,
	CONCAT(start_station_name,' to ', end_station_name) as rental_route
FROM #2021bicycle

-- 7.4 count all route 

SELECT 
	CONCAT(start_station_name,' to ', end_station_name) as rental_route,
	COUNT(*) as route_count
FROM #2021bicycle
GROUP BY CONCAT(start_station_name,' to ', end_station_name)
ORDER BY 2 DESC

-- 7.5 Count top start station and end station
SELECT
	start_station_name ,
	count(start_station_name) as frequency 
FROM #2021bicycle
GROUP BY start_station_name
ORDER BY 2 DESC

SELECT
	end_station_name ,
	count(end_station_name) as frequency 
FROM #2021bicycle
GROUP BY end_station_name
ORDER BY 2 DESC



-- Create new table in MS SQL
SELECT *
INTO [Cyclistic].[dbo].[2021CyclisticData]
FROM #2021bicycle


-- Query using MS Power BI 

WITH rawdata AS (
SELECT * FROM dbo.[202101-divvy-tripdata]
UNION
SELECT * FROM dbo.[202102-divvy-tripdata]
UNION
SELECT * FROM dbo.[202103-divvy-tripdata]
UNION
SELECT * FROM dbo.[202104-divvy-tripdata]
UNION
SELECT * FROM dbo.[202105-divvy-tripdata]
UNION
SELECT * FROM dbo.[202106-divvy-tripdata]
UNION
SELECT * FROM dbo.[202107-divvy-tripdata]
UNION
SELECT * FROM dbo.[202108-divvy-tripdata]
UNION
SELECT * FROM dbo.[202109-divvy-tripdata]
UNION
SELECT * FROM dbo.[202110-divvy-tripdata]
UNION
SELECT * FROM dbo.[202111-divvy-tripdata]
UNION
SELECT * FROM dbo.[202112-divvy-tripdata]
)

SELECT *
FROM rawdata
WHERE start_station_name IS NOT NULL AND end_station_name IS NOT NULL AND end_lat IS NOT NULL;
ORDER BY 3


