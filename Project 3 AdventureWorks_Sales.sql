---- AdventureWorks are standard online transaction processing scenarios for a fictitous bicycle manufacturer

-- [Order table]
-- show all order table

SELECT *
FROM AdventureWorks2022.Sales.SalesOrderDetail
ORDER BY 1

-- show sales order header
SELECT *
FROM AdventureWorks2022.Sales.SalesOrderHeader

-- count all orders
SELECT 
	COUNT(SalesOrderID) AS TotalOrderMade
FROM AdventureWorks2022.Sales.SalesOrderDetail

-- show SalesOrderID, ProductID, ProductName, ProductCategoryn ProducSubcategory, Unit Price and LineTotal

SELECT
	SalesOrder.SalesOrderID,
	Product.Name,
	Product.ProductID,
	Category.ProductCategoryID,
	Category.Name as CategoryName,
	Subcategory.ProductSubcategoryID,
	Subcategory.Name as SubcategoryName,
	Product.ListPrice,
	Product.StandardCost,
	SalesOrder.UnitPrice,
	SalesOrder.OrderQty,
	SalesOrder.LineTotal
FROM AdventureWorks2022.Sales.SalesOrderDetail AS SalesOrder
LEFT JOIN AdventureWorks2022.Production.Product AS Product
ON SalesOrder.ProductID = Product.ProductID
LEFT JOIN AdventureWorks2022.Production.ProductSubcategory as Subcategory
ON Product.ProductSubcategoryID = Subcategory.ProductSubcategoryID 
LEFT JOIN AdventureWorks2022.Production.ProductCategory as Category
ON Subcategory.ProductCategoryID = Category.ProductCategoryID
ORDER BY 1

-- show order count by ProductCategory

WITH sales AS (
	SELECT
		SalesOrder.SalesOrderID,
		Product.Name,
		Product.ProductID,
		Category.ProductCategoryID,
		Category.Name as CategoryName,
		Subcategory.ProductSubcategoryID,
		Subcategory.Name as SubcategoryName,
		Product.ListPrice,
		Product.StandardCost,
		SalesOrder.UnitPrice,
		SalesOrder.OrderQty,
		SalesOrder.LineTotal
	FROM AdventureWorks2022.Sales.SalesOrderDetail AS SalesOrder
	LEFT JOIN AdventureWorks2022.Production.Product AS Product
	ON SalesOrder.ProductID = Product.ProductID
	LEFT JOIN AdventureWorks2022.Production.ProductSubcategory as Subcategory
	ON Product.ProductSubcategoryID = Subcategory.ProductSubcategoryID 
	LEFT JOIN AdventureWorks2022.Production.ProductCategory as Category
	ON Subcategory.ProductCategoryID = Category.ProductCategoryID
)

SELECT 
	CategoryName,
	COUNT(SalesOrderID) AS OrderCount
FROM sales
GROUP BY CategoryName
ORDER BY 1

-- show order count by ProductSubcategory

WITH sales AS (
	SELECT
		SalesOrder.SalesOrderID,
		Product.Name,
		Product.ProductID,
		Category.ProductCategoryID,
		Category.Name as CategoryName,
		Subcategory.ProductSubcategoryID,
		Subcategory.Name as SubcategoryName,
		Product.ListPrice,
		Product.StandardCost,
		SalesOrder.UnitPrice,
		SalesOrder.OrderQty,
		SalesOrder.LineTotal
	FROM AdventureWorks2022.Sales.SalesOrderDetail AS SalesOrder
	LEFT JOIN AdventureWorks2022.Production.Product AS Product
	ON SalesOrder.ProductID = Product.ProductID
	LEFT JOIN AdventureWorks2022.Production.ProductSubcategory as Subcategory
	ON Product.ProductSubcategoryID = Subcategory.ProductSubcategoryID 
	LEFT JOIN AdventureWorks2022.Production.ProductCategory as Category
	ON Subcategory.ProductCategoryID = Category.ProductCategoryID
)

SELECT 
	CategoryName,
	SubcategoryName,
	COUNT(SalesOrderID) AS OrderCount
FROM sales
GROUP BY CategoryName, SubcategoryName
ORDER BY 1,2


-- show sales total amount by Productcategory

WITH sales AS (
	SELECT
		SalesOrder.SalesOrderID,
		Product.Name,
		Product.ProductID,
		Category.ProductCategoryID,
		Category.Name as CategoryName,
		Subcategory.ProductSubcategoryID,
		Subcategory.Name as SubcategoryName,
		Product.ListPrice,
		Product.StandardCost,
		SalesOrder.UnitPrice,
		SalesOrder.OrderQty,
		SalesOrder.LineTotal
	FROM AdventureWorks2022.Sales.SalesOrderDetail AS SalesOrder
	LEFT JOIN AdventureWorks2022.Production.Product AS Product
	ON SalesOrder.ProductID = Product.ProductID
	LEFT JOIN AdventureWorks2022.Production.ProductSubcategory as Subcategory
	ON Product.ProductSubcategoryID = Subcategory.ProductSubcategoryID 
	LEFT JOIN AdventureWorks2022.Production.ProductCategory as Category
	ON Subcategory.ProductCategoryID = Category.ProductCategoryID
)

SELECT 
	CategoryName,
	SUM(LineTotal) AS TotalSales
FROM sales
GROUP BY CategoryName
ORDER BY 2

-- show sales total amount by ProductSubcategory

WITH sales AS (
	SELECT
		SalesOrder.SalesOrderID,
		Product.Name,
		Product.ProductID,
		Category.ProductCategoryID,
		Category.Name as CategoryName,
		Subcategory.ProductSubcategoryID,
		Subcategory.Name as SubcategoryName,
		Product.ListPrice,
		Product.StandardCost,
		SalesOrder.UnitPrice,
		SalesOrder.OrderQty,
		SalesOrder.LineTotal
	FROM AdventureWorks2022.Sales.SalesOrderDetail AS SalesOrder
	LEFT JOIN AdventureWorks2022.Production.Product AS Product
	ON SalesOrder.ProductID = Product.ProductID
	LEFT JOIN AdventureWorks2022.Production.ProductSubcategory as Subcategory
	ON Product.ProductSubcategoryID = Subcategory.ProductSubcategoryID 
	LEFT JOIN AdventureWorks2022.Production.ProductCategory as Category
	ON Subcategory.ProductCategoryID = Category.ProductCategoryID
)

SELECT 
	CategoryName,
	SubcategoryName,
	SUM(LineTotal) AS TotalSales
FROM sales
GROUP BY CategoryName, SubcategoryName
ORDER BY 1,2


-- show order table with dates

SELECT
		SalesOrder.SalesOrderID,
		Product.Name,
		Product.ProductID,
		Category.ProductCategoryID,
		Category.Name as CategoryName,
		Subcategory.ProductSubcategoryID,
		Subcategory.Name as SubcategoryName,
		Product.ListPrice,
		Product.StandardCost,
		SalesOrder.UnitPrice,
		SalesOrder.OrderQty,
		SalesOrder.LineTotal,
		SalesOrderHeader.OrderDate
	FROM AdventureWorks2022.Sales.SalesOrderDetail AS SalesOrder
	LEFT JOIN AdventureWorks2022.Production.Product AS Product
	ON SalesOrder.ProductID = Product.ProductID
	LEFT JOIN AdventureWorks2022.Production.ProductSubcategory as Subcategory
	ON Product.ProductSubcategoryID = Subcategory.ProductSubcategoryID 
	LEFT JOIN AdventureWorks2022.Production.ProductCategory as Category
	ON Subcategory.ProductCategoryID = Category.ProductCategoryID
	LEFT JOIN AdventureWorks2022.sales.SalesOrderHeader as SalesOrderHeader
	ON SalesOrder.SalesOrderID = SalesOrderHeader.SalesOrderID


-- show order date NA value of all the orders

WITH sales AS (
	SELECT
		SalesOrder.SalesOrderID,
		Product.Name,
		Product.ProductID,
		Category.ProductCategoryID,
		Category.Name as CategoryName,
		Subcategory.ProductSubcategoryID,
		Subcategory.Name as SubcategoryName,
		Product.ListPrice,
		Product.StandardCost,
		SalesOrder.UnitPrice,
		SalesOrder.OrderQty,
		SalesOrder.LineTotal,
		SalesOrderHeader.OrderDate
	FROM AdventureWorks2022.Sales.SalesOrderDetail AS SalesOrder
	LEFT JOIN AdventureWorks2022.Production.Product AS Product
	ON SalesOrder.ProductID = Product.ProductID
	LEFT JOIN AdventureWorks2022.Production.ProductSubcategory as Subcategory
	ON Product.ProductSubcategoryID = Subcategory.ProductSubcategoryID 
	LEFT JOIN AdventureWorks2022.Production.ProductCategory as Category
	ON Subcategory.ProductCategoryID = Category.ProductCategoryID
	LEFT JOIN AdventureWorks2022.sales.SalesOrderHeader as SalesOrderHeader
	ON SalesOrder.SalesOrderID = SalesOrderHeader.SalesOrderID
)

SELECT 
	*
FROM sales
WHERE CategoryName IS NULL


-- get year and month of sales
-- YearID -> sales year
-- MonthID -> sales months

SELECT
		SalesOrder.SalesOrderID,
		Product.Name,
		Product.ProductID,
		Category.ProductCategoryID,
		Category.Name as CategoryName,
		Subcategory.ProductSubcategoryID,
		Subcategory.Name as SubcategoryName,
		Product.ListPrice,
		Product.StandardCost,
		SalesOrder.UnitPrice,
		SalesOrder.OrderQty,
		SalesOrder.LineTotal,
		SalesOrderHeader.OrderDate as OrderDate,
		YEAR(OrderDate) as YearID,
		MONTH(OrderDate) as MonthID
	FROM AdventureWorks2022.Sales.SalesOrderDetail AS SalesOrder
	LEFT JOIN AdventureWorks2022.Production.Product AS Product
	ON SalesOrder.ProductID = Product.ProductID
	LEFT JOIN AdventureWorks2022.Production.ProductSubcategory as Subcategory
	ON Product.ProductSubcategoryID = Subcategory.ProductSubcategoryID 
	LEFT JOIN AdventureWorks2022.Production.ProductCategory as Category
	ON Subcategory.ProductCategoryID = Category.ProductCategoryID
	LEFT JOIN AdventureWorks2022.sales.SalesOrderHeader as SalesOrderHeader
	ON SalesOrder.SalesOrderID = SalesOrderHeader.SalesOrderID

-- sales by category and by month in 2012

with sales as (
	SELECT
		SalesOrder.SalesOrderID,
		Product.Name,
		Product.ProductID,
		Category.ProductCategoryID,
		Category.Name as CategoryName,
		Subcategory.ProductSubcategoryID,
		Subcategory.Name as SubcategoryName,
		Product.ListPrice,
		Product.StandardCost,
		SalesOrder.UnitPrice,
		SalesOrder.OrderQty,
		SalesOrder.LineTotal,
		SalesOrderHeader.OrderDate as OrderDate,
		YEAR(OrderDate) as YearID,
		MONTH(OrderDate) as MonthID
	FROM AdventureWorks2022.Sales.SalesOrderDetail AS SalesOrder
	LEFT JOIN AdventureWorks2022.Production.Product AS Product
	ON SalesOrder.ProductID = Product.ProductID
	LEFT JOIN AdventureWorks2022.Production.ProductSubcategory as Subcategory
	ON Product.ProductSubcategoryID = Subcategory.ProductSubcategoryID 
	LEFT JOIN AdventureWorks2022.Production.ProductCategory as Category
	ON Subcategory.ProductCategoryID = Category.ProductCategoryID
	LEFT JOIN AdventureWorks2022.sales.SalesOrderHeader as SalesOrderHeader
	ON SalesOrder.SalesOrderID = SalesOrderHeader.SalesOrderID
)

SELECT 
	MonthID,
	CategoryName,
	SUM(LineTotal) as SalesTotal
From sales
WHERE YearID = 2012
GROUP BY CategoryName,MonthID
ORDER BY 3 -- order by sales amount


-- create new table for important column of sales data

DROP TABLE IF EXISTS #salestable;
WITH #salestable1 AS
(
	SELECT
		SalesOrder.SalesOrderID,
		Product.Name,
		Product.ProductID,
		Category.ProductCategoryID,
		Category.Name as CategoryName,
		Subcategory.ProductSubcategoryID,
		Subcategory.Name as SubcategoryName,
		Product.ListPrice,
		Product.StandardCost,
		SalesOrder.UnitPrice,
		SalesOrder.OrderQty,
		SalesOrder.LineTotal,
		SalesOrderHeader.OrderDate as OrderDate,
		YEAR(OrderDate) as YearID,
		MONTH(OrderDate) as MonthID
	FROM AdventureWorks2022.Sales.SalesOrderDetail AS SalesOrder
	LEFT JOIN AdventureWorks2022.Production.Product AS Product
	ON SalesOrder.ProductID = Product.ProductID
	LEFT JOIN AdventureWorks2022.Production.ProductSubcategory as Subcategory
	ON Product.ProductSubcategoryID = Subcategory.ProductSubcategoryID 
	LEFT JOIN AdventureWorks2022.Production.ProductCategory as Category
	ON Subcategory.ProductCategoryID = Category.ProductCategoryID
	LEFT JOIN AdventureWorks2022.sales.SalesOrderHeader as SalesOrderHeader
	ON SalesOrder.SalesOrderID = SalesOrderHeader.SalesOrderID )

SELECT *
INTO #salestable  -- create table #salestable and inject data into it
FROM #salestable1

-- now we can use #salestable 

SELECT *
FROM #salestable

-- select the most ordered product (OrderFrequency)

SELECT 
	Name,
	CategoryName,
	COUNT(SalesOrderID) as OrderFrequency
FROM #salestable
GROUP BY CategoryName,Name
ORDER BY 3

-- select total order (ItemSoldFrequency)

SELECT 
	Name,
	CategoryName,
	Sum(OrderQty) as TotalItemSold
FROM #salestable
GROUP BY CategoryName,Name
ORDER BY 3

-- select total sale generated (ItemSoldValue) by ProductName and Category

SELECT 
	Name,
	CategoryName,
	Sum(LineTotal) as ItemSoldValue
FROM #salestable
GROUP BY CategoryName,Name
ORDER BY 3

-- select total sale generated (ItemSoldValue) by ProductName and Subcategory

SELECT 
	Name,
	SubcategoryName,
	Sum(LineTotal) as ItemSoldValue
FROM #salestable
GROUP BY SubcategoryName,Name
ORDER BY 3