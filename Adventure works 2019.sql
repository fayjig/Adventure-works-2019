--
--Retrieve information about the products with colour values except null, red, silver/black, white and list price
--between £75 and £750. Rename the column StandardCost to Price. Also, sort the results in descending order by list
--price. 
SELECT *  FROM Production.Product
WHERE color != null AND color!='red' AND color != 'silver' AND color != 'black'
AND ListPrice BETWEEN 75 AND 750 
ORDER BY ListPrice DESC
EXEC sp_rename 'Production.Product.StandardCost' ,'Price','COLUMN';

--Find all the male employees born between 1962 to 1970 and with hire date greater than 2001 and female employees
--born between 1972 and 1975 and hire date between 2001 and 2002. 
SELECT BusinessEntityID, NationalIDNumber,Gender, HireDate
FROM HumanResources.Employee
WHERE Gender ='M' AND Hiredate > '2001'
(SELECT BusinessEntityID, NationalIDNumber,Gender, HireDate
FROM HumanResources.Employee
WHERE Gender = 'F' AND HireDate BETWEEN '2001' AND  '2002');

--Create a list of 10 most expensive products that have a product number beginning with ‘BK’. Include only the
--product ID, Name and colour. 
SELECT TOP(10) ProductID,Name, Color,ListPrice, ProductNumber
FROM Production.Product
WHERE ProductNumber like 'BK%'
ORDER BY ListPrice DESC;	

--Return all product subcategories that take an average of 3 days or longer to manufacture. 
SELECT ProductID,DaysToManufacture,ProductSubcategoryID
FROM Production.Product
WHERE DaysToManufacture >= 3;

--Create a list of product segmentation by defining criteria that places each item in a predefined segment as follows. If
--price gets less than £200 then low value. If price is between £201 and £750 then mid value. If between £750 and
--£1250 then mid to high value else higher value. Filter the results only for black, silver and red color products. 
SELECT ProductID,ListPrice,Color,
CASE
WHEN Listprice < 200 THEN 'Low Value'
WHEN Listprice BETWEEN 201 AND 750 THEN 'Mid Value'
WHEN Listprice BETWEEN 750 AND 1250 THEN 'Mid to High Value'
ELSE 'Higher Value'
END 
AS 'Product Segmentation'
FROM Production.Product
WHERE Color='black' or color='silver' or color='red';

--How many Distinct Job title is present in the Employee table?
SELECT COUNT(DISTINCT JobTitle)
FROM HumanResources.Employee
go;

--Use employee table and calculate the ages of each employee at the time of hiring. 
SELECT BusinessEntityID,NationalIDNumber,
DATEDIFF(YY, BirthDate, HireDate) AS Age
FROM HumanResources.Employee;

--How many employees will be due a long service award in the next 5 years, if long service is 20 years? 
SELECT COUNT (CASE 
WHEN DATEDIFF(YY,HireDate, GETDATE()) + 5 = 20 then 1 end) AS 'Number of Employees due a Long Service Award'
FROM HumanResources.Employee;

--How many more years does each employee have to work before reaching sentiment, if sentiment age is 65?
SELECT BusinessEntityID,NationalIDNumber,
DATEDIFF(YY, BirthDate, HireDate) AS Age,
65 - DATEDIFF(YY,BirthDate, HireDate) AS 'Work Years Before Sentiment Age'
FROM HumanResources.Employee;

--Print the information about all the Sales.Person and their sales quota. For every Sales person you should provide
--their FirstName, LastName, HireDate, SickLeaveHours and Region where they work. 
SELECT FirstName,LastName, HireDate,SickLeaveHours, SalesQuota, Name AS Region
FROM Person.Person p
INNER JOIN Sales.SalesPerson s
on p.BusinessEntityID =s.BusinessEntityID
INNER JOIN HumanResources.Employee h
ON s.BusinessEntityID = h.BusinessEntityID
INNER JOIN Person.StateProvince sp
ON s.TerritoryID = sp.TerritoryID ;

--Display the information about the details of an order i.e. order number, order date, amount of order, which customer
--gives the order and which salesman works for that customer and how much commission he gets for an order. 
SELECT PurchaseOrderNumber AS 'Order Number',OrderDate, OrderQty AS 'Amount Of Order',
CustomerID,SalesPersonID,Commissionpct AS 'Commission Per Order'
FROM Sales.SalesOrderDetail sod
INNER JOIN Sales.SalesOrderHeader soh
ON soh.SalesOrderID = sod.SalesOrderID
INNER JOIN Sales.SalesPerson sp
ON soh.TerritoryID = sp.TerritoryID;

--Create a view to find out the top 5 most expensive products for each color. 	
WITH CTE AS (
SELECT ProductID, Color, ListPrice, ROW_NUMBER() 
OVER (PARTITION BY Color ORDER BY ListPrice DESC) AS RowNo
FROM Production.Product
)
SELECT * FROM CTE
WHERE RowNo <=5 ;
