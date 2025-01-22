/*****************************************************************************************************************
NAME:   IT134 3-4 
PURPOSE: Answer questions

MODIFICATION LOG:
Ver      Date        Author        Description
-----   ----------   -----------   -------------------------------------------------------------------------------
1.0     01/21/2025   EHOBBS       Built this script for EC IT440

RUNTIME: 
Xm Xs

NOTES: 
This is where I talk about what this script is, why I built it, and other stuff...
******************************************************************************************************************/

-- Q1: Where do most of our customers reside?
-- A1: 
SELECT TOP 1 Address.City, COUNT(*) AS NumberOfCustomers
FROM Person.Address
JOIN Person.BusinessEntityAddress ON Address.AddressID = BusinessEntityAddress.AddressID
JOIN Person.BusinessEntity ON BusinessEntityAddress.BusinessEntityID = BusinessEntity.BusinessEntityID
JOIN Sales.Customer ON BusinessEntity.BusinessEntityID = Customer.CustomerID
GROUP BY Address.City
ORDER BY NumberOfCustomers DESC;

-- Q2: What product did we sell the most?
-- A2:
SELECT TOP 1 Product.Name, SUM(SalesOrderDetail.OrderQty) AS TotalSold
FROM Sales.SalesOrderDetail
JOIN Production.Product ON SalesOrderDetail.ProductID = Product.ProductID
GROUP BY Product.Name
ORDER BY TotalSold DESC;

-- Q3: What was our profit margin like? The total sum of our sales with the total sum of products cost. What are the top three most profitable products?
-- A3:
-- Total sum of sales and total sum of product costs
SELECT SUM(SalesOrderDetail.LineTotal) AS TotalSales, 
       SUM(Product.StandardCost * SalesOrderDetail.OrderQty) AS TotalCost, 
       SUM(SalesOrderDetail.LineTotal) - SUM(Product.StandardCost * SalesOrderDetail.OrderQty) AS ProfitMargin
FROM Sales.SalesOrderDetail
JOIN Production.Product ON SalesOrderDetail.ProductID = Product.ProductID;

-- Top three most profitable products
SELECT TOP 3 Product.Name, 
              SUM(SalesOrderDetail.LineTotal) - SUM(Product.StandardCost * SalesOrderDetail.OrderQty) AS Profit
FROM Sales.SalesOrderDetail
JOIN Production.Product ON SalesOrderDetail.ProductID = Product.ProductID
GROUP BY Product.Name
ORDER BY Profit DESC;

-- Q4: Keeping up with the inventory, what is the quantity of the most sold products in the inventory at this time period?
-- A4:
SELECT Product.Name, 
       SUM(SalesOrderDetail.OrderQty) AS TotalSold, 
       ProductInventory.Quantity
FROM Sales.SalesOrderDetail
JOIN Production.Product ON SalesOrderDetail.ProductID = Product.ProductID
JOIN Production.ProductInventory ON Product.ProductID = ProductInventory.ProductID
GROUP BY Product.Name, ProductInventory.Quantity
ORDER BY TotalSold DESC;

-- Q5: How many mountain bikes were sold in Q3 2011 by frame color?
-- A5:
SELECT Product.Color, 
       SUM(SalesOrderDetail.OrderQty) AS QuantitySold, 
       Product.ListPrice, 
       Product.StandardCost, 
       SUM((Product.ListPrice - Product.StandardCost) * SalesOrderDetail.OrderQty) AS EstimatedNetRevenue
FROM Sales.SalesOrderDetail
JOIN Production.Product ON SalesOrderDetail.ProductID = Product.ProductID
JOIN Sales.SalesOrderHeader ON SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesOrderID
WHERE Product.ProductSubcategoryID = (SELECT ProductSubcategoryID FROM Production.ProductSubcategory WHERE Name = 'Mountain Bikes')
AND SalesOrderHeader.OrderDate BETWEEN '2011-07-01' AND '2011-09-30'
GROUP BY Product.Color, Product.ListPrice, Product.StandardCost;

-- Q6: How much has each sales representative sold in the past five years?
-- A6:
SELECT SalesOrderHeader.SalesPersonID, 
       COUNT(*) AS NumberOfOrders, 
       SUM(SalesOrderHeader.TotalDue) AS TotalSalesAmount, 
       AVG(SalesOrderHeader.TotalDue) AS AverageSalesPerOrder
FROM Sales.SalesOrderHeader
WHERE SalesOrderHeader.OrderDate BETWEEN DATEADD(YEAR, -5, GETDATE()) AND GETDATE()
GROUP BY SalesOrderHeader.SalesPersonID;

-- Q7: How many columns in total are in the AdventureWorks Database?
-- A7:
SELECT COUNT(*) AS TotalColumns
FROM INFORMATION_SCHEMA.COLUMNS;

-- Q8: How many tables in total are in the AdventureWorks Database?
-- A8:
SELECT COUNT(*) AS TotalTables
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';
