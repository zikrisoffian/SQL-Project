-- AdventureWorks are standard online transaction processing scenarios for a fictitous bicycle manufacturer

-- [Product table]
-- show all product table

SELECT *
FROM AdventureWorks2022.Production.Product


-- count all the product of dataset 

SELECT COUNT(Product.ProductID)
FROM AdventureWorks2022.Production.Product

--[Product Subcategory]
-- show all product subcategory table
SELECT *
FROM AdventureWorks2022.Production.ProductSubcategory

-- [Product Category]

--show all product category table
SELECT *
FROM AdventureWorks2022.Production.ProductCategory

-- show distinct product category

SELECT DISTINCT Name FROM AdventureWorks2022.Production.ProductCategory
SELECT DISTINCT Name FROM AdventureWorks2022.Production.ProductSubcategory

-- [Product based on its category]
-- create product ID, product name, product subcategory and product category table
-- use join to combine the different tables
-- use JOIN 
SELECT 
	Product.ProductID,
	Product.Name as ProductName,
	Subcategory.ProductSubcategoryID as SubcategoryID,
	Subcategory.Name as SubcategoryName,
	Category.ProductCategoryID,
	Category.Name as ProductCategory
FROM AdventureWorks2022.Production.Product AS Product
LEFT JOIN AdventureWorks2022.Production.ProductSubcategory AS Subcategory
ON Product.ProductSubcategoryID = Subcategory.ProductSubcategoryID
LEFT JOIN AdventureWorks2022.Production.ProductCategory AS Category
ON Subcategory.ProductCategoryID = Category.ProductCategoryID


-- Show all Bikes product
WITH product as (
	SELECT 
		Product.ProductID,
		Product.Name as ProductName,
		Subcategory.ProductSubcategoryID as SubcategoryID,
		Subcategory.Name as SubcategoryName,
		Category.ProductCategoryID,
		Category.Name as ProductCategory
	FROM AdventureWorks2022.Production.Product AS Product
	LEFT JOIN AdventureWorks2022.Production.ProductSubcategory AS Subcategory
	ON Product.ProductSubcategoryID = Subcategory.ProductSubcategoryID
	LEFT JOIN AdventureWorks2022.Production.ProductCategory AS Category
	ON Subcategory.ProductCategoryID = Category.ProductCategoryID )

SELECT 
	ProductID,
	ProductName,
	ProductCategory,
	SubcategoryName
FROM product
WHERE ProductCategory = 'Bikes'
ORDER BY 4

-- Show all Accessories product
WITH product as (
	SELECT 
		Product.ProductID,
		Product.Name as ProductName,
		Subcategory.ProductSubcategoryID as SubcategoryID,
		Subcategory.Name as SubcategoryName,
		Category.ProductCategoryID,
		Category.Name as ProductCategory
	FROM AdventureWorks2022.Production.Product AS Product
	LEFT JOIN AdventureWorks2022.Production.ProductSubcategory AS Subcategory
	ON Product.ProductSubcategoryID = Subcategory.ProductSubcategoryID
	LEFT JOIN AdventureWorks2022.Production.ProductCategory AS Category
	ON Subcategory.ProductCategoryID = Category.ProductCategoryID )

SELECT 
	ProductID,
	ProductName,
	ProductCategory,
	SubcategoryName
FROM product
WHERE ProductCategory = 'Accessories'
ORDER BY 4

-- Show all Clothing product
WITH product as (
	SELECT 
		Product.ProductID,
		Product.Name as ProductName,
		Subcategory.ProductSubcategoryID as SubcategoryID,
		Subcategory.Name as SubcategoryName,
		Category.ProductCategoryID,
		Category.Name as ProductCategory
	FROM AdventureWorks2022.Production.Product AS Product
	LEFT JOIN AdventureWorks2022.Production.ProductSubcategory AS Subcategory
	ON Product.ProductSubcategoryID = Subcategory.ProductSubcategoryID
	LEFT JOIN AdventureWorks2022.Production.ProductCategory AS Category
	ON Subcategory.ProductCategoryID = Category.ProductCategoryID )

SELECT 
	ProductID,
	ProductName,
	ProductCategory,
	SubcategoryName
FROM product
WHERE ProductCategory = 'Clothing'
ORDER BY 4

-- Show all Components product
WITH product as (
	SELECT 
		Product.ProductID,
		Product.Name as ProductName,
		Subcategory.ProductSubcategoryID as SubcategoryID,
		Subcategory.Name as SubcategoryName,
		Category.ProductCategoryID,
		Category.Name as ProductCategory
	FROM AdventureWorks2022.Production.Product AS Product
	LEFT JOIN AdventureWorks2022.Production.ProductSubcategory AS Subcategory
	ON Product.ProductSubcategoryID = Subcategory.ProductSubcategoryID
	LEFT JOIN AdventureWorks2022.Production.ProductCategory AS Category
	ON Subcategory.ProductCategoryID = Category.ProductCategoryID )

SELECT 
	ProductID,
	ProductName,
	ProductCategory,
	SubcategoryName
FROM product
WHERE ProductCategory = 'Components'
ORDER BY 4

-- Count product based on the product category

WITH product as (
	SELECT 
		Product.ProductID,
		Product.Name as ProductName,
		Subcategory.ProductSubcategoryID as SubcategoryID,
		Subcategory.Name as SubcategoryName,
		Category.ProductCategoryID,
		Category.Name as ProductCategory
	FROM AdventureWorks2022.Production.Product AS Product
	LEFT JOIN AdventureWorks2022.Production.ProductSubcategory AS Subcategory
	ON Product.ProductSubcategoryID = Subcategory.ProductSubcategoryID
	LEFT JOIN AdventureWorks2022.Production.ProductCategory AS Category
	ON Subcategory.ProductCategoryID = Category.ProductCategoryID )

SELECT 
	ProductCategory,
	COUNT(ProductID) as TotalProductCount
FROM product
GROUP BY ProductCategory

-- count product based on the product subcategory
WITH product as (
	SELECT 
		Product.ProductID,
		Product.Name as ProductName,
		Subcategory.ProductSubcategoryID as SubcategoryID,
		Subcategory.Name as SubcategoryName,
		Category.ProductCategoryID,
		Category.Name as ProductCategory
	FROM AdventureWorks2022.Production.Product AS Product
	LEFT JOIN AdventureWorks2022.Production.ProductSubcategory AS Subcategory
	ON Product.ProductSubcategoryID = Subcategory.ProductSubcategoryID
	LEFT JOIN AdventureWorks2022.Production.ProductCategory AS Category
	ON Subcategory.ProductCategoryID = Category.ProductCategoryID )

SELECT 
	ProductCategory,
	SubcategoryName,
	COUNT(ProductID) as TotalProductCount
FROM product
GROUP BY ProductCategory,SubcategoryName
ORDER BY 1


-- Show ProductID, ProductName, ProductCategory StandardCost and ListPrice
WITH product as (
	SELECT 
		Product.ProductID,
		Product.Name as ProductName,
		Subcategory.ProductSubcategoryID as SubcategoryID,
		Subcategory.Name as SubcategoryName,
		Category.ProductCategoryID,
		Category.Name as ProductCategory,
		Product.ListPrice as ProductPrice,
		Product.StandardCost as ProductCost
	FROM AdventureWorks2022.Production.Product AS Product
	LEFT JOIN AdventureWorks2022.Production.ProductSubcategory AS Subcategory
	ON Product.ProductSubcategoryID = Subcategory.ProductSubcategoryID
	LEFT JOIN AdventureWorks2022.Production.ProductCategory AS Category
	ON Subcategory.ProductCategoryID = Category.ProductCategoryID )

SELECT 
	ProductID,
	ProductName,
	ProductCategoryID,
	ProductCategory,
	SubcategoryID,
	SubcategoryName,
	ProductPrice,
	ProductCost
FROM product
ORDER BY 5,4


-- Show ProductID, ProductName, ProductCategory StandardCost and ListPrice (INNER JOIN)
WITH product as (
	SELECT 
		Product.ProductID,
		Product.Name as ProductName,
		Subcategory.ProductSubcategoryID as SubcategoryID,
		Subcategory.Name as SubcategoryName,
		Category.ProductCategoryID,
		Category.Name as ProductCategory,
		Product.ListPrice as ProductPrice,
		Product.StandardCost as ProductCost
	FROM AdventureWorks2022.Production.Product AS Product
	JOIN AdventureWorks2022.Production.ProductSubcategory AS Subcategory
	ON Product.ProductSubcategoryID = Subcategory.ProductSubcategoryID
	JOIN AdventureWorks2022.Production.ProductCategory AS Category
	ON Subcategory.ProductCategoryID = Category.ProductCategoryID )

SELECT 
	ProductID,
	ProductName,
	ProductCategoryID,
	ProductCategory,
	SubcategoryID,
	SubcategoryName,
	ProductPrice,
	ProductCost
FROM product
ORDER BY 5,4