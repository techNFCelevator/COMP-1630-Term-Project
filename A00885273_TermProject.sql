USE [TermProject];
GO

PRINT('===== B1')
PRINT('OrderID     Quantity ProductID   ReorderLevel SupplierID ')
PRINT('----------- -------- ----------- ------------ -----------')
SET NOCOUNT ON
GO
DROP TABLE IF EXISTS #Output
GO
CREATE TABLE #Output ([rowID] INT IDENTITY(1,1) PRIMARY KEY CLUSTERED, [OrderID] INT NOT NULL, [Quantity] SMALLINT NOT NULL, [ProductID] INT NOT NULL, [ReorderLevel] SMALLINT, [SupplierID] INT NOT NULL)
INSERT INTO #Output ([OrderID], [Quantity], [ProductID], [ReorderLevel], [SupplierID])
	SELECT od.[OrderID], od.[Quantity], p.[ProductID], p.[ReorderLevel], s.[SupplierID]
	FROM [TermProject].[dbo].[OrderDetails] AS od
	JOIN [TermProject].[dbo].[Products] AS p ON od.[ProductID] = p.[ProductID]
	JOIN [TermProject].[dbo].[Suppliers] AS s ON p.[SupplierID] = s.[SupplierID]
	WHERE od.[Quantity] BETWEEN 90 AND 100
	ORDER BY od.[OrderID]
DECLARE @row INT = 1
DECLARE @order_id INT
DECLARE @qty SMALLINT
DECLARE @product_id INT
DECLARE @reorder SMALLINT
DECLARE @supplier_id INT
DECLARE @col1_width INT = 11
DECLARE @col2_width INT = 8
DECLARE @col3_width INT = 11
DECLARE @col4_width INT = 12
DECLARE @col5_width INT = 11
WHILE (@row <= (SELECT COUNT(*) FROM [TermProject].[dbo].[OrderDetails] WHERE [Quantity] BETWEEN 90 AND 100))
BEGIN
	SELECT @order_id = o.[OrderID], @qty = o.[Quantity], @product_id = o.[ProductID], @reorder = o.[ReorderLevel], @supplier_id = o.[SupplierID]
	FROM #Output AS o
	WHERE o.[rowID] = @row
	ORDER BY o.[OrderID]
	PRINT(RIGHT(SPACE(@col1_width) + CAST(@order_id AS VARCHAR), @col1_width) + ' ' + RIGHT(SPACE(@col2_width) + CAST(@qty AS VARCHAR), @col2_width) + ' ' + RIGHT(SPACE(@col3_width) + CAST(@product_id AS VARCHAR), @col3_width) + ' ' + RIGHT(SPACE(@col4_width) + CAST(@reorder AS VARCHAR), @col4_width) + ' ' + RIGHT(SPACE(@col5_width) + CAST(@supplier_id AS VARCHAR), @col5_width))
	SET @row += 1
END
SET NOCOUNT OFF
GO
SELECT od.[OrderID], od.[Quantity], p.[ProductID], p.[ReorderLevel], s.[SupplierID]
FROM [TermProject].[dbo].[OrderDetails] AS od
JOIN [TermProject].[dbo].[Products] AS p ON od.[ProductID] = p.[ProductID]
JOIN [TermProject].[dbo].[Suppliers] AS s ON p.[SupplierID] = s.[SupplierID]
WHERE od.[Quantity] BETWEEN 90 AND 100
ORDER BY od.[OrderID]
PRINT('')
PRINT('===== B2')
PRINT('ProductID   ProductName                         EnglishName                         UnitPrice                          ')
PRINT('----------- ----------------------------------- ----------------------------------- -----------------------------------')
SET NOCOUNT ON
GO
DROP TABLE IF EXISTS #Output
GO
CREATE TABLE #Output ([rowID] INT IDENTITY(1,1) PRIMARY KEY CLUSTERED, [ProductID] INT NOT NULL, [ProductName] NVARCHAR(40) NOT NULL, [EnglishName] NVARCHAR(40), [UnitPrice] MONEY)
INSERT INTO #Output ([ProductID], [ProductName], [EnglishName], [UnitPrice])
	SELECT p.[ProductID], p.[ProductName], p.[EnglishName], p.[UnitPrice]
	FROM [TermProject].[dbo].[Products] AS p
	WHERE p.[UnitPrice] < 10.00
	ORDER BY p.[ProductID]
DECLARE @row INT = 1
DECLARE @id INT
DECLARE @name NVARCHAR(40)
DECLARE @eng_name NVARCHAR(40)
DECLARE @price MONEY
DECLARE @col1_width INT = 11
DECLARE @col2_width INT = 35
DECLARE @col3_width INT = 35
WHILE (@row <= (SELECT COUNT(*) FROM #Output))
BEGIN
	SELECT @id = o.[ProductID], @name = o.[ProductName], @eng_name = o.[EnglishName], @price = o.[UnitPrice]
	FROM #Output AS o
	WHERE o.[rowID] = @row
	ORDER BY o.[ProductID]
	PRINT(RIGHT(SPACE(@col1_width) + CAST(@id AS VARCHAR), @col1_width) + ' ' + LEFT(@name + SPACE(@col2_width), @col2_width) + ' ' + LEFT(@eng_name + SPACE(@col3_width), @col3_width) + ' ' + FORMAT(@price, 'C'))
	SET @row += 1
END
SET NOCOUNT OFF
GO
DROP TABLE IF EXISTS #Output
GO
SELECT p.[ProductID], p.[ProductName], p.[EnglishName], p.[UnitPrice]
FROM [TermProject].[dbo].[Products] AS p
WHERE p.[UnitPrice] < 10.00
ORDER BY p.[ProductID]
PRINT('')
PRINT('===== B3')
PRINT('CustomerID CompanyName                         Country         Phone                   ')
PRINT('---------- ----------------------------------- --------------- ------------------------')
SET NOCOUNT ON
GO
DROP TABLE IF EXISTS #Output
GO
CREATE TABLE #Output ([rowID] INT IDENTITY(1,1) PRIMARY KEY CLUSTERED, [CustomerID] NVARCHAR(5) NOT NULL, [CompanyName] NVARCHAR(40) NOT NULL, [Country] NVARCHAR(15), [Phone] NVARCHAR (24))
INSERT INTO #Output ([CustomerID], [CompanyName], [Country], [Phone])
	SELECT c.[CustomerID], c.[CompanyName], c.[Country], c.[Phone]
	FROM [TermProject].[dbo].[Customers] AS c
	WHERE c.[Country] = 'Canada' OR c.[Country] = 'USA'
	ORDER BY c.[CompanyName]
DECLARE @custID NVARCHAR(5)
DECLARE @name NVARCHAR(40)
DECLARE @country NVARCHAR(15)
DECLARE @phone NVARCHAR(24)
DECLARE @row INT = 1
DECLARE @col1_width INT = 10
DECLARE @col2_width INT = 35
DECLARE @col3_width INT = 15
WHILE (@row <= (SELECT COUNT(*) FROM #Output))
BEGIN
	SELECT @custID = o.[CustomerID], @name = o.[CompanyName], @country = o.[Country], @phone = o.[Phone]
	FROM #Output AS o
	WHERE o.[rowID] = @row
	ORDER BY o.[CompanyName]
	PRINT(LEFT(@custID + SPACE(@col1_width), @col1_width) + ' ' + LEFT(@name + SPACE(@col2_width), @col2_width) + ' ' + LEFT(@country + SPACE(@col3_width), @col3_width) + ' ' + @phone)
	SET @row += 1
END
SET NOCOUNT OFF
GO
SELECT c.[CustomerID], c.[CompanyName], c.[Country], c.[Phone]
FROM [TermProject].[dbo].[Customers] AS c
WHERE c.[Country] = 'Canada' OR c.[Country] = 'USA'
ORDER BY c.[CompanyName]
PRINT('')
PRINT('===== B4')
PRINT('SupplierID  Name                                ProductName                         ReorderLevel UnitsInStock')
PRINT('----------- ----------------------------------- ----------------------------------- ------------ ------------')
SET NOCOUNT ON
GO
DROP TABLE IF EXISTS #Output
GO
CREATE TABLE #Output ([rowID] INT IDENTITY(1,1) PRIMARY KEY CLUSTERED, [SupplierID] INT NOT NULL, [Name] NVARCHAR(50), [ProductName] NVARCHAR(40), [ReorderLevel] SMALLINT, [UnitsInStock] SMALLINT)
INSERT INTO #Output ([SupplierID], [Name], [ProductName], [ReorderLevel], [UnitsInStock])
	SELECT s.[SupplierID], s.[Name], p.[ProductName], p.[ReorderLevel], p.[UnitsInStock]
	FROM [TermProject].[dbo].[Suppliers] AS s
	JOIN [TermProject].[dbo].[Products] AS p ON p.[SupplierID] = s.[SupplierID]
	WHERE p.[UnitsInStock] > p.[ReorderLevel] AND p.[UnitsInStock] <= [ReorderLevel] + 10
	ORDER BY p.[ProductName]
DECLARE @id INT
DECLARE @name NVARCHAR(50)
DECLARE @product_name NVARCHAR(40)
DECLARE @reorder SMALLINT
DECLARE @stock SMALLINT
DECLARE @col1_width INT = 11
DECLARE @col2_width INT = 35
DECLARE @col3_width INT = 35
DECLARE @col4_width INT = 12
DECLARE @col5_width INT = 12
DECLARE @row INT = 1
WHILE (@row <= (SELECT COUNT(*) FROM #Output))
BEGIN
	SELECT @id = o.[SupplierID], @name = o.[Name], @product_name = o.[ProductName], @reorder = o.[ReorderLevel], @stock = o.[UnitsInStock]
	FROM #Output AS o
	WHERE o.[rowID] = @row
	ORDER BY o.[ProductName]
	PRINT(RIGHT(SPACE(@col1_width) + CAST(@id AS VARCHAR), @col1_width) + ' ' + LEFT(@name + SPACE(@col2_width), @col2_width) + ' ' + LEFT(@product_name + SPACE(@col3_width), @col3_width) + ' ' + RIGHT(SPACE(@col4_width) + CAST(@reorder AS VARCHAR), @col4_width) + ' ' + RIGHT(SPACE(@col5_width) + CAST(@stock AS VARCHAR), @col5_width))
	SET @row += 1
END
SET NOCOUNT OFF
GO
SELECT s.[SupplierID], s.[Name], p.[ProductName], p.[ReorderLevel], p.[UnitsInStock]
FROM [TermProject].[dbo].[Suppliers] AS s
JOIN [TermProject].[dbo].[Products] AS p ON p.[SupplierID] = s.[SupplierID]
WHERE p.[UnitsInStock] > p.[ReorderLevel] AND p.[UnitsInStock] <= [ReorderLevel] + 10
ORDER BY p.[ProductName]
PRINT('')
PRINT('===== B5')
PRINT('CompanyName                         Amount     ')
PRINT('----------------------------------- -----------')
SET NOCOUNT ON
GO
DROP TABLE IF EXISTS #Output
GO
CREATE TABLE #Output ([rowID] INT IDENTITY(1,1) PRIMARY KEY CLUSTERED, [CompanyName] NVARCHAR(40) NOT NULL, [AmtOfDec1993Orders] INT)
INSERT INTO #Output ([CompanyName], [AmtOfDec1993Orders])
	SELECT c.[CompanyName], COUNT(ALL o.[OrderID]) AS [AmtOfDec1993Orders]
	FROM [TermProject].[dbo].[Orders] AS o
	JOIN [TermProject].[dbo].[Customers] AS c ON c.[CustomerID] = o.[CustomerID]
	WHERE o.[OrderDate] BETWEEN '1993-12-01' AND '1993-12-31'
	GROUP BY c.[CompanyName]
	ORDER BY c.[CompanyName]
DECLARE @name NVARCHAR(40)
DECLARE @amount INT
DECLARE @col1_width INT = 35
DECLARE @col2_width INT = 11
DECLARE @row INT = 1
WHILE (@row <= (SELECT COUNT(*) FROM #Output))
BEGIN
	SELECT @name = o.[CompanyName], @amount = o.[AmtOfDec1993Orders]
	FROM #Output AS o
	WHERE o.[rowID] = @row
	ORDER BY o.[CompanyName]
	PRINT(LEFT(@name + SPACE(@col1_width), @col1_width) + ' ' + RIGHT(SPACE(@col2_width) + CAST(@amount AS VARCHAR), @col2_width))
	SET @row += 1
END
SET NOCOUNT OFF
GO
SELECT c.[CompanyName], COUNT(ALL o.[OrderID]) AS [AmtOfDec1993Orders]
FROM [TermProject].[dbo].[Orders] AS o
JOIN [TermProject].[dbo].[Customers] AS c ON c.[CustomerID] = o.[CustomerID]
WHERE o.[OrderDate] BETWEEN '1993-12-01' AND '1993-12-31'
GROUP BY c.[CompanyName]
ORDER BY c.[CompanyName]
PRINT('')
PRINT('===== B6')
PRINT('ProductName                         Amount     ')
PRINT('----------------------------------- -----------')
SET NOCOUNT ON
GO
DROP TABLE IF EXISTS #Output
GO
CREATE TABLE #Output ([rowID] INT IDENTITY(1,1) PRIMARY KEY CLUSTERED, [ProductName] NVARCHAR(40) NOT NULL, [AmtOfOrders] INT)
INSERT INTO #Output ([ProductName], [AmtOfOrders])
	SELECT TOP (10) p.[ProductName], COUNT(DISTINCT o.[OrderID]) AS [AmtOfOrders]
	FROM [TermProject].[dbo].[OrderDetails] AS o
	JOIN [Products] AS p ON o.[ProductID] = p.[ProductID]
	GROUP BY p.[ProductName]
	ORDER BY [AmtOfOrders] DESC
DECLARE @name NVARCHAR(40)
DECLARE @amount INT
DECLARE @col1_width INT = 35
DECLARE @col2_width INT = 11
DECLARE @row INT = 1
WHILE (@row <= (SELECT COUNT(*) FROM #Output))
BEGIN
	SELECT @name = o.[ProductName], @amount = o.[AmtOfOrders]
	FROM #Output AS o
	WHERE o.[rowID] = @row
	ORDER BY o.[AmtOfOrders]
	PRINT(LEFT(@name + SPACE(@col1_width), @col1_width) + ' ' + RIGHT(SPACE(@col2_width) + CAST(@amount AS VARCHAR), @col2_width))
	SET @row += 1
END
SET NOCOUNT OFF
GO
SELECT TOP (10) p.[ProductName], p.[EnglishName], COUNT(DISTINCT o.[OrderID]) AS [AmtOfOrders]
FROM [TermProject].[dbo].[OrderDetails] AS o
JOIN [Products] AS p ON o.[ProductID] = p.[ProductID]
GROUP BY p.[ProductName], p.[EnglishName]
ORDER BY [AmtOfOrders] DESC
PRINT('')
PRINT('===== B7')
PRINT('ProductName                         Quantity   ')
PRINT('----------------------------------- -----------')
SET NOCOUNT ON
GO
DROP TABLE IF EXISTS #Output
GO
CREATE TABLE #Output ([rowID] INT IDENTITY(1,1) PRIMARY KEY CLUSTERED, [ProductName] NVARCHAR(40) NOT NULL, [Quantity] SMALLINT NOT NULL)
INSERT INTO #Output ([ProductName], [Quantity])
	SELECT TOP (10) p.[ProductName], od.[Quantity]
	FROM [TermProject].[dbo].[Products] AS p
	JOIN [TermProject].[dbo].[OrderDetails] AS od ON od.ProductID = p.ProductID
	ORDER BY od.[Quantity] DESC
DECLARE @name NVARCHAR(40)
DECLARE @qty SMALLINT
DECLARE @col1_width INT = 35
DECLARE @col2_width INT = 11
DECLARE @row INT = 1
WHILE (@row <= (SELECT COUNT(*) FROM #Output))
BEGIN
	SELECT @name = o.[ProductName], @qty = o.[Quantity]
	FROM #Output AS o
	WHERE o.[rowID] = @row
	PRINT(LEFT(@name + SPACE(@col1_width), @col1_width) + ' ' + RIGHT(SPACE(@col2_width) + CAST(@qty AS VARCHAR), @col2_width))
	SET @row += 1
END
SET NOCOUNT OFF
GO
SELECT TOP (10) p.[ProductName], p.[EnglishName], od.[Quantity]
FROM [TermProject].[dbo].[Products] AS p
JOIN [TermProject].[dbo].[OrderDetails] AS od ON od.ProductID = p.ProductID
ORDER BY od.[Quantity] DESC
PRINT('')
PRINT('===== B8')
PRINT('OrderID     UnitPrice                           Quantity')
PRINT('----------- ----------------------------------- --------')
SET NOCOUNT ON
GO
DROP TABLE IF EXISTS #Output
GO
CREATE TABLE #Output ([rowID] INT IDENTITY(1,1) PRIMARY KEY CLUSTERED, [OrderID] INT NOT NULL, [UnitPrice] MONEY NOT NULL, [Quantity] SMALLINT NOT NULL)
INSERT INTO #Output ([OrderID], [UnitPrice], [Quantity])
	SELECT o.[OrderID], od.[UnitPrice], od.[Quantity]
	FROM [TermProject].[dbo].[Orders] AS o
	JOIN [TermProject].[dbo].[OrderDetails] AS od ON o.[OrderID] = od.[OrderID]
	WHERE o.[ShipCity] = 'Vancouver'
	ORDER BY o.[OrderID]
DECLARE @id INT
DECLARE @price MONEY
DECLARE @qty SMALLINT
DECLARE @col1_width INT = 11
DECLARE @col2_width INT = 35
DECLARE @col3_width INT = 8
DECLARE @row INT = 1
WHILE (@row <= (SELECT COUNT(*) FROM #Output))
BEGIN
	SELECT @id = o.[OrderID], @price = o.[UnitPrice], @qty = o.[Quantity]
	FROM #Output AS o
	WHERE o.[rowID] = @row
	ORDER BY o.[OrderID]
	PRINT(RIGHT(SPACE(@col1_width) + CAST(@id AS VARCHAR), @col1_width) + ' ' + LEFT(FORMAT(@price, 'C') + SPACE(@col2_width), @col2_width) + RIGHT(SPACE(@col3_width) + CAST(@qty AS VARCHAR), @col3_width))
	SET @row += 1
END
SET NOCOUNT OFF
GO
SELECT o.[OrderID], od.[UnitPrice], od.[Quantity]
FROM [TermProject].[dbo].[Orders] AS o
JOIN [TermProject].[dbo].[OrderDetails] AS od ON o.[OrderID] = od.[OrderID]
WHERE o.[ShipCity] = 'Vancouver'
ORDER BY o.[OrderID]
PRINT('')
PRINT('===== B9')
PRINT('CustomerID CompanyName                         OrderID     OrderDate                          ')
PRINT('---------- ----------------------------------- ----------- -----------------------------------')
SET NOCOUNT ON
GO
DROP TABLE IF EXISTS #Output
GO
CREATE TABLE #Output ([rowID] INT IDENTITY(1,1) PRIMARY KEY CLUSTERED, [CustomerID] NVARCHAR(5) NOT NULL, [CompanyName] NVARCHAR(40) NOT NULL, [OrderID] INT NOT NULL, [OrderDate] SMALLDATETIME)
INSERT INTO #Output ([CustomerID], [CompanyName], [OrderID], [OrderDate])
	SELECT c.[CustomerID], c.[CompanyName], o.[OrderID], o.[OrderDate]
	FROM [TermProject].[dbo].[Customers] AS c
	JOIN [TermProject].[dbo].[Orders] AS o ON c.[CustomerID] = o.[CustomerID]
	WHERE o.[ShippedDate] IS NULL
	ORDER BY c.[CustomerID], o.[OrderDate]
DECLARE @custID NVARCHAR(5)
DECLARE @name NVARCHAR(40)
DECLARE @orderID INT
DECLARE @order_date SMALLDATETIME
DECLARE @col1_width INT = 10
DECLARE @col2_width INT = 35
DECLARE @col3_width INT = 11
DECLARE @col4_width INT = 35
DECLARE @row INT = 1
WHILE (@row <= (SELECT COUNT(*) FROM #Output))
BEGIN
	SELECT @custID = o.[CustomerID], @name = o.[CompanyName], @orderID = o.[OrderID], @order_date = o.[OrderDate]
	FROM #Output AS o
	WHERE o.[rowID] = @row
	ORDER BY o.[CustomerID], o.[OrderDate]
	PRINT(LEFT(@custID + SPACE(@col1_width), @col1_width) + ' ' + LEFT(@name + SPACE(@col2_width), @col2_width) + ' ' + RIGHT(SPACE(@col3_width) + CAST(@orderID AS VARCHAR), @col3_width) + ' ' + FORMAT(@order_date, 'MMMM d, yyyy'))
	SET @row += 1
END
SET NOCOUNT OFF
GO
SELECT c.[CustomerID], c.[CompanyName], o.[OrderID], o.[OrderDate]
FROM [TermProject].[dbo].[Customers] AS c
JOIN [TermProject].[dbo].[Orders] AS o ON c.[CustomerID] = o.[CustomerID]
WHERE o.[ShippedDate] IS NULL
ORDER BY c.[CustomerID], o.[OrderDate]
PRINT('')
PRINT('===== B10')
PRINT('ProductID   ProductName                         QuantityPerUnit      UnitPrice                          ')
PRINT('----------- ----------------------------------- -------------------- -----------------------------------')
SET NOCOUNT ON
GO
DROP TABLE IF EXISTS #Output
GO
CREATE TABLE #Output ([rowID] INT IDENTITY(1,1) PRIMARY KEY CLUSTERED, [ProductID] INT NOT NULL, [ProductName] NVARCHAR(40) NOT NULL, [QuantityPerUnit] NVARCHAR(20), [UnitPrice] MONEY)
INSERT INTO #Output ([ProductID], [ProductName], [QuantityPerUnit], [UnitPrice])
	SELECT p.[ProductID], p.[ProductName], p.[QuantityPerUnit], p.[UnitPrice]
	FROM [TermProject].[dbo].[Products] AS p
	WHERE p.[ProductName] LIKE '%choc%' OR p.[ProductName] LIKE '%chok%'
	ORDER BY p.[ProductName]
DECLARE @id INT
DECLARE @name NVARCHAR(40)
DECLARE @unit_rate NVARCHAR(20)
DECLARE @price MONEY
DECLARE @col1_width INT = 11
DECLARE @col2_width INT = 35
DECLARE @col3_width INT = 20
DECLARE @row INT = 1
WHILE (@row <= (SELECT COUNT(*) FROM #Output))
BEGIN
	SELECT @id = o.[ProductID], @name = o.[ProductName], @unit_rate = o.[QuantityPerUnit], @price = o.[UnitPrice]
	FROM #Output AS o
	WHERE o.[rowID] = @row
	PRINT(RIGHT(SPACE(@col1_width) + CAST(@id AS VARCHAR), @col1_width) + ' ' + LEFT(@name + SPACE(@col2_width), @col2_width) + ' ' + LEFT(@unit_rate + SPACE(@col3_width), @col3_width) + ' ' + FORMAT(@price, 'C'))
	SET @row += 1
END
SET NOCOUNT OFF
GO
SELECT p.[ProductID], p.[ProductName], p.[QuantityPerUnit], p.[UnitPrice]
FROM [TermProject].[dbo].[Products] AS p
WHERE p.[ProductName] LIKE '%choc%' OR p.[ProductName] LIKE '%chok%'
ORDER BY p.[ProductName]
PRINT('')
PRINT('===== B11')
PRINT('Character Total      ')
PRINT('--------- -----------')
SET NOCOUNT ON
GO
DROP TABLE IF EXISTS #Output
GO
CREATE TABLE #Output ([rowID] INT IDENTITY(1,1) PRIMARY KEY CLUSTERED, [character] NVARCHAR(1), [total] INT)
INSERT INTO #Output ([character], [total])
	SELECT LEFT(p.[ProductName], 1), COUNT(LEFT(p.[ProductName], 1))
	FROM [TermProject].[dbo].[Products] AS p
	GROUP BY LEFT(p.[ProductName], 1)
	HAVING COUNT(LEFT(p.[ProductName], 1)) > 1
DECLARE @char NVARCHAR(1)
DECLARE @total INT
DECLARE @col1_width INT = 9
DECLARE @col2_width INT = 11
DECLARE @row INT = 1
WHILE (@row <= (SELECT COUNT(*) FROM #Output))
BEGIN
	SELECT @char = o.[character], @total = o.[total]
	FROM #Output AS o
	WHERE o.[rowID] = @row
	PRINT(LEFT(@char + SPACE(@col1_width), @col1_width) + ' ' + RIGHT(SPACE(@col2_width) + CAST(@total AS VARCHAR), @col2_width))
	SET @row += 1
END
SET NOCOUNT OFF
GO
SELECT LEFT(p.[ProductName], 1), COUNT(LEFT(p.[ProductName], 1))
FROM [TermProject].[dbo].[Products] AS p
GROUP BY LEFT(p.[ProductName], 1)
HAVING COUNT(LEFT(p.[ProductName], 1)) > 1
PRINT('')
PRINT('===== C1')
DROP VIEW IF EXISTS vProductsUnder10
GO
CREATE VIEW vProductsUnder10
AS
SELECT p.[ProductName], p.[UnitPrice], s.[SupplierID], s.[Name]
FROM [Products] AS p
JOIN [Suppliers] AS s ON p.[SupplierID] = s.[SupplierID]
WHERE p.[UnitPrice] < 10.00
GO
PRINT('ProductName                         UnitPrice                           SupplierID  Name                               ')
PRINT('----------------------------------- ----------------------------------- ----------- -----------------------------------')
SET NOCOUNT ON
GO
DROP TABLE IF EXISTS #Output
GO
CREATE TABLE #Output ([rowID] INT IDENTITY(1,1) PRIMARY KEY CLUSTERED, [ProductName] NVARCHAR(40) NOT NULL, [UnitPrice] MONEY, [SupplierID] INT NOT NULL, [Name] NVARCHAR(50))
INSERT INTO #Output ([ProductName], [UnitPrice], [SupplierID], [Name])
	SELECT * FROM [TermProject].[dbo].[vProductsUnder10]
	ORDER BY [ProductName]
DECLARE @product_name NVARCHAR(40)
DECLARE @price MONEY
DECLARE @supplier_id INT
DECLARE @supplier_name NVARCHAR(50)
DECLARE @col1_width INT = 35
DECLARE @col2_width INT = 35
DECLARE @col3_width INT = 11
DECLARE @row INT = 1
WHILE (@row <= (SELECT COUNT(*) FROM #Output))
BEGIN
	SELECT @product_name = o.[ProductName], @price = o.[UnitPrice], @supplier_id = o.[SupplierID], @supplier_name = o.[Name]
	FROM #Output AS o
	WHERE o.[rowID] = @row
	PRINT (LEFT(@product_name + SPACE(@col1_width), @col1_width) + ' ' + LEFT(FORMAT(@price, 'C') + SPACE(@col2_width), @col2_width) + ' ' + RIGHT(SPACE(@col3_width) + CAST(@supplier_id AS VARCHAR), @col3_width) + ' ' + @supplier_name)
	SET @row += 1
END
SET NOCOUNT OFF
GO
SELECT * FROM [TermProject].[dbo].[vProductsUnder10]
ORDER BY [ProductName]
PRINT('')
PRINT('===== C2')
DROP VIEW IF EXISTS vOrdersByEmployee
GO
CREATE VIEW vOrdersByEmployee
AS
SELECT CONCAT_WS(' ', e.[FirstName], e.[LastName]) AS [Name], COUNT(o.[OrderID]) AS [Orders]
FROM [Employees] AS e
JOIN [Orders] AS o ON e.[EmployeeID] = o.[EmployeeID]
GROUP BY e.[FirstName], e.[LastName]
GO
PRINT('Name                                Orders     ')
PRINT('----------------------------------- -----------')
SET NOCOUNT ON
GO
DROP TABLE IF EXISTS #Output
GO
CREATE TABLE #Output ([rowID] INT IDENTITY(1,1) PRIMARY KEY CLUSTERED, [Name] VARCHAR(35), [Orders] INT)
INSERT INTO #Output
	SELECT * FROM [TermProject].[dbo].[vOrdersByEmployee]
	ORDER BY [Orders] DESC
DECLARE @name VARCHAR(35)
DECLARE @orders INT
DECLARE @col1_width INT = 35
DECLARE @col2_width INT = 11
DECLARE @row INT = 1
WHILE (@row <= (SELECT COUNT(*) FROM #Output))
BEGIN
	SELECT @name = o.[Name], @orders = o.[Orders]
	FROM #Output AS o
	WHERE o.[rowID] = @row
	PRINT(LEFT(@name + SPACE(@col1_width), @col1_width) + ' ' + RIGHT(SPACE(@col2_width) + CAST(@orders AS VARCHAR), @col2_width))
	SET @row += 1
END
SET NOCOUNT OFF
GO
SELECT * FROM [TermProject].[dbo].[vOrdersByEmployee]
ORDER BY [Orders] DESC
PRINT('')
PRINT('===== C3')
DECLARE @rows_affected INT
DECLARE @col_width INT = 13
UPDATE [dbo].[Customers]
SET [Fax] = 'Unknown'
WHERE [Fax] IS NULL
SET @rows_affected = @@ROWCOUNT
PRINT('Rows Affected')
PRINT('-------------')
PRINT RIGHT(SPACE(@col_width) + CAST(@rows_affected AS VARCHAR), @col_width)
SELECT @rows_affected AS [Rows Affected]
GO
PRINT('')
PRINT('===== C4')
DROP VIEW IF EXISTS vOrderCost
GO
CREATE VIEW vOrderCost
AS
SELECT o.[OrderID], o.[OrderDate], c.[CompanyName], od.[Quantity] * od.[UnitPrice] AS [OrderCost]
FROM [dbo].[Orders] AS o
JOIN [dbo].[Customers] AS c ON c.[CustomerID] = o.[CustomerID]
JOIN [dbo].[OrderDetails] AS od ON o.[OrderID] = od.[OrderID]
GO
PRINT('OrderID     OrderDate                           CompanyName                         Cost                               ')
PRINT('----------- ----------------------------------- ----------------------------------- -----------------------------------')
SET NOCOUNT ON
GO
DROP TABLE IF EXISTS #Output
GO
CREATE TABLE #Output ([rowID] INT IDENTITY(1,1) PRIMARY KEY CLUSTERED, [OrderID] INT NOT NULL, [OrderDate] SMALLDATETIME, [CompanyName] NVARCHAR(40), [OrderCost] MONEY NOT NULL)
INSERT INTO #Output ([OrderID], [OrderDate], [CompanyName], [OrderCost])
	SELECT TOP(5) [OrderID]
		,[OrderDate]
		,[CompanyName]
		,[OrderCost]
	FROM [TermProject].[dbo].[vOrderCost]
	ORDER BY [OrderCost] DESC;
DECLARE @id INT
DECLARE @date SMALLDATETIME
DECLARE @co_name NVARCHAR(40)
DECLARE @cost MONEY
DECLARE @col1_width INT = 11
DECLARE @col2_width INT = 35
DECLARE @col3_width INT = 35
DECLARE @row INT = 1
WHILE (@row <= (SELECT COUNT(*) FROM #Output))
BEGIN
	SELECT @id = o.[OrderID], @date = o.[OrderDate], @co_name = o.[CompanyName], @cost = o.[OrderCost]
	FROM #Output AS o
	WHERE o.[rowID] = @row
	PRINT(RIGHT(SPACE(@col1_width) + CAST(@id AS VARCHAR), @col1_width) + ' ' + LEFT(FORMAT(@date, 'MMMM d, yyyy') + SPACE(@col2_width), @col2_width) + ' ' + LEFT(@co_name + SPACE(@col3_width), @col3_width) + ' ' + FORMAT(@cost, 'C'))
	SET @row += 1
END
SET NOCOUNT OFF
GO
SELECT TOP(5) [OrderID]
		,[OrderDate]
		,[CompanyName]
		,FORMAT([OrderCost], 'C2') AS [Cost]
	FROM [TermProject].[dbo].[vOrderCost]
	ORDER BY [OrderCost] DESC;
PRINT('')
PRINT('===== C5')
INSERT INTO [dbo].[Suppliers]([SupplierID], [Name])
	VALUES(16, 'Supplier P')
GO
PRINT('SupplierID  Name                               ')
PRINT('----------- -----------------------------------')
SET NOCOUNT ON
GO
DROP TABLE IF EXISTS #Output
GO
CREATE TABLE #Output ([rowID] INT IDENTITY(1,1) PRIMARY KEY CLUSTERED, [SupplierID] INT NOT NULL, [Name] NVARCHAR(50))
INSERT INTO #Output ([SupplierID], [Name])
	SELECT [SupplierID], [Name] FROM [TermProject].[dbo].[Suppliers]
	WHERE [SupplierID] > 10
	ORDER BY [SupplierID]
DECLARE @id INT
DECLARE @name NVARCHAR(50)
DECLARE @col1_width INT = 11
DECLARE @row INT = 1
WHILE (@row <= (SELECT COUNT(*) FROM #Output))
BEGIN
	SELECT @id = o.[SupplierID], @name = o.[Name]
	FROM #Output AS o
	WHERE o.[rowID] = @row
	PRINT(RIGHT(SPACE(@col1_width) + CAST(@id AS VARCHAR), @col1_width) + ' ' + @name)
	SET @row += 1
END
SET NOCOUNT OFF
GO
SELECT [SupplierID], [Name] FROM [TermProject].[dbo].[Suppliers]
WHERE [SupplierID] > 10
ORDER BY [SupplierID]
PRINT('')
PRINT('===== C6')
DECLARE @rows_affected INT
DECLARE @col_width INT = 13
UPDATE [dbo].[Products]
SET [UnitPrice] *= 1.15
WHERE [UnitPrice] < 5.00
SET @rows_affected = @@ROWCOUNT
PRINT('Rows Affected')
PRINT('-------------')
PRINT RIGHT(SPACE(@col_width) + CAST(@rows_affected AS VARCHAR), @col_width)
SELECT @rows_affected AS [Rows Affected]
GO
PRINT('')
PRINT('===== D1')
DROP FUNCTION IF EXISTS CustomersByCountry
GO
CREATE FUNCTION CustomersByCountry(@country VARCHAR(15))
RETURNS TABLE
AS
RETURN
	SELECT c.[CustomerID], c.[CompanyName], c.[City], c.[Address]
	FROM [TermProject].[dbo].[Customers] AS c
	WHERE c.[Country] = @country
GO
PRINT('CustomerID CompanyName                         City            Address                            ')
PRINT('---------- ----------------------------------- --------------- -----------------------------------')
SET NOCOUNT ON
GO
DROP TABLE IF EXISTS #Output
GO
CREATE TABLE #Output ([rowID] INT IDENTITY(1,1) PRIMARY KEY CLUSTERED, [CustomerID] NVARCHAR(5) NOT NULL, [CompanyName] NVARCHAR(40) NOT NULL, [City] NVARCHAR(15), [Address] NVARCHAR(60))
INSERT INTO #Output ([CustomerID], [CompanyName], [City], [Address])
	SELECT * FROM [TermProject].[dbo].[CustomersByCountry]('Germany')
	ORDER BY [CompanyName]
DECLARE @id NVARCHAR(5)
DECLARE @co_name NVARCHAR(40)
DECLARE @city NVARCHAR(15)
DECLARE @address NVARCHAR(60)
DECLARE @col1_width INT = 10
DECLARE @col2_width INT = 35
DECLARE @col3_width INT = 15
DECLARE @row INT = 1
WHILE (@row <= (SELECT COUNT(*) FROM #Output))
BEGIN
	SELECT @id = o.[CustomerID], @co_name = o.[CompanyName], @city = o.[City], @address = o.[Address]
	FROM #Output AS o
	WHERE o.[rowID] = @row
	PRINT(LEFT(@id + SPACE(@col1_width), @col1_width) + ' ' + LEFT(@co_name + SPACE(@col2_width), @col2_width) + ' ' + LEFT(@city + SPACE(@col3_width), @col3_width) + ' ' + @address)
	SET @row += 1
END
SET NOCOUNT OFF
GO
SELECT * FROM [TermProject].[dbo].[CustomersByCountry]('Germany')
ORDER BY [CompanyName]
PRINT('')
PRINT('===== D2')
DROP FUNCTION IF EXISTS ProductsInRange
GO
CREATE FUNCTION ProductsInRange(@min MONEY, @max MONEY)
RETURNS TABLE
AS
RETURN
	SELECT p.[ProductID], p.[ProductName], p.[EnglishName], p.[UnitPrice]
	FROM [TermProject].[dbo].[Products] AS p
	WHERE p.[UnitPrice] BETWEEN @min AND @max
GO
PRINT('ProductID   ProductName                         EnglishName                         UnitPrice                          ')
PRINT('----------- ----------------------------------- ----------------------------------- -----------------------------------')
SET NOCOUNT ON
GO
DROP TABLE IF EXISTS #Output
GO
CREATE TABLE #Output ([rowID] INT IDENTITY(1,1) PRIMARY KEY CLUSTERED, [ProductID] INT NOT NULL, [ProductName] NVARCHAR(40) NOT NULL, [EnglishName] NVARCHAR(40), [UnitPrice] MONEY)
INSERT INTO #Output ([ProductID], [ProductName], [EnglishName], [UnitPrice])
	SELECT * FROM [TermProject].[dbo].[ProductsInRange](30, 50)
	ORDER BY [UnitPrice];
DECLARE @id INT
DECLARE @name NVARCHAR(40)
DECLARE @eng_name NVARCHAR(40)
DECLARE @price MONEY
DECLARE @col1_width INT = 11
DECLARE @col2_width INT = 35
DECLARE @col3_width INT = 35
DECLARE @row INT = 1
WHILE (@row <= (SELECT COUNT(*) FROM #Output))
BEGIN
	SELECT @id = o.[ProductID], @name = o.[ProductName], @eng_name = o.[EnglishName], @price = o.[UnitPrice]
	FROM #Output AS o
	WHERE o.[rowID] = @row
	PRINT(RIGHT(SPACE(@col1_width) + CAST(@id AS VARCHAR), @col1_width) + ' ' + LEFT(@name + SPACE(@col2_width), @col2_width) + ' ' + LEFT(@eng_name + SPACE(@col3_width), @col3_width) + ' ' + FORMAT(@price, 'C'))
	SET @row += 1
END
SET NOCOUNT OFF
GO
SELECT * FROM [TermProject].[dbo].[ProductsInRange](30, 50)
ORDER BY [UnitPrice];
PRINT('')
PRINT('===== D3')
DROP PROCEDURE IF EXISTS EmployeeInfo
GO
CREATE PROCEDURE EmployeeInfo(@id INT)
AS
	SET NOCOUNT ON
	DECLARE @last_name NVARCHAR(30)
	DECLARE @first_name NVARCHAR(15)
	DECLARE @address NVARCHAR(30)
	DECLARE @city NVARCHAR(20)
	DECLARE @province NVARCHAR(2)
	DECLARE @zip NVARCHAR(7)
	DECLARE @phone NVARCHAR(14)
	DECLARE @age INT
	DECLARE @col1_width INT = 11
	DECLARE @col2_width INT = 30
	DECLARE @col3_width INT = 15
	DECLARE @col4_width INT = 30
	DECLARE @col5_width INT = 20
	DECLARE @col6_width INT = 8
	DECLARE @col7_width INT = 10
	DECLARE @col8_width INT = 14
	DECLARE @col9_width INT = 11
	SET NOCOUNT OFF
	SELECT @last_name = e.[LastName], @first_name = e.[FirstName], @address = e.[Address], @city = e.[City], @province = e.[Province], @zip = e.[PostalCode], @phone = e.[Phone], @age = DATEDIFF(YY, e.[BirthDate], '1994-01-01')
	FROM [TermProject].[dbo].[Employees] AS e
	WHERE e.[EmployeeID] = @id
	PRINT('EmployeeID  LastName                       FirstName       Address                        City                 Province PostalCode Phone          Age        ')
	PRINT('----------- ------------------------------ --------------- ------------------------------ -------------------- -------- ---------- -------------- -----------')
	PRINT(RIGHT(SPACE(@col1_width) + CAST(@id AS VARCHAR), @col1_width) + ' ' + LEFT(@last_name + SPACE(@col2_width), @col2_width) + ' ' + LEFT(@first_name + SPACE(@col3_width), @col3_width) + ' ' + LEFT(@address + SPACE(@col4_width), @col4_width) + ' ' + LEFT(@city + SPACE(@col5_width), @col5_width) + ' ' + LEFT(@province + SPACE(@col6_width), @col6_width) + ' ' + LEFT(@zip + SPACE(@col7_width), @col7_width) + ' ' + LEFT(@phone + SPACE(@col8_width), @col8_width) + ' ' + RIGHT(SPACE(@col9_width) + CAST(@age AS VARCHAR), @col9_width))
	SET NOCOUNT OFF
	SELECT e.[EmployeeID], e.[LastName], e.[FirstName], e.[Address], e.[City], e.[Province], e.[PostalCode], e.[Phone], DATEDIFF(YY, e.[BirthDate], '1994-01-01') AS [Age as of 1994-Jan-01]
	FROM [TermProject].[dbo].[Employees] AS e
	WHERE e.[EmployeeID] = @id
GO
EXEC [TermProject].[dbo].[EmployeeInfo] 9;
PRINT('')
PRINT('===== D4')
DROP PROCEDURE IF EXISTS CustomersByCity
GO
CREATE PROCEDURE CustomersByCity(@city VARCHAR(15))
AS
	SET NOCOUNT ON
	DECLARE @id NVARCHAR(5)
	DECLARE @co_name NVARCHAR(40)
	DECLARE @address NVARCHAR(60)
	DECLARE @phone NVARCHAR(24)
	DECLARE @col1_width INT = 10
	DECLARE @col2_width INT = 35
	DECLARE @col3_width INT = 35
	DECLARE @col4_width INT = 15
	PRINT('CustomerID CompanyName                         Address                             City            Phone                   ')
	PRINT('---------- ----------------------------------- ----------------------------------- --------------- ------------------------')
	DECLARE @row INT = 1
	WHILE (@row <= (SELECT COUNT(*) FROM [TermProject].[dbo].[Customers] AS c WHERE c.[City] = @city))
	BEGIN
		SELECT @id = o.[CustomerID], @co_name = o.[CompanyName], @address = o.[Address], @city = o.[City], @phone = o.[Phone]
		FROM (
			SELECT ROW_NUMBER() OVER(ORDER BY c.[CustomerID]) AS [rowID], c.[CustomerID], c.[CompanyName], c.[Address], c.[City], c.[Phone]
			FROM [TermProject].[dbo].[Customers] AS c
			WHERE c.[City] = @city) o
		WHERE o.[rowID] = @row
		PRINT(LEFT(@id + SPACE(@col1_width), @col1_width) + ' ' + LEFT(@co_name + SPACE(@col2_width), @col2_width) + ' ' + LEFT(@address + SPACE(@col3_width), @col3_width) + ' ' + LEFT(@city + SPACE(@col4_width), @col4_width) + ' ' + @phone)
		SET @row += 1
	END
	SET NOCOUNT OFF
	SELECT c.[CustomerID], c.[CompanyName], c.[Address], c.[City], c.[Phone]
	FROM [TermProject].[dbo].[Customers] AS c
	WHERE c.[City] = @city
	ORDER BY c.[CustomerID]
GO
EXEC [TermProject].[dbo].[CustomersByCity] 'London';
PRINT('')
PRINT('===== D5')
DROP PROCEDURE IF EXISTS UnitPriceByRange
GO
CREATE PROCEDURE UnitPriceByRange(@min MONEY, @max MONEY)
AS
	SET NOCOUNT ON
	PRINT('ProductID   ProductName                         EnglishName                                                            ')
	PRINT('----------- ----------------------------------- ----------------------------------- -----------------------------------')
	DECLARE @id INT
	DECLARE @name NVARCHAR(40)
	DECLARE @eng_name NVARCHAR(40)
	DECLARE @price MONEY
	DECLARE @col1_width INT = 11
	DECLARE @col2_width INT = 35
	DECLARE @col3_width INT = 35
	DECLARE @row INT = 1
	WHILE (@row <= (SELECT COUNT(*) FROM [TermProject].[dbo].[Products] AS p WHERE p.[UnitPrice] BETWEEN @min AND @max))
	BEGIN
		SELECT @id = o.[ProductID], @name = o.[ProductName], @eng_name = o.[EnglishName], @price = o.[UnitPrice]
		FROM (
			SELECT ROW_NUMBER() OVER (ORDER BY p.[UnitPrice]) AS [rowID], p.[ProductID], p.[ProductName], p.[EnglishName], p.[UnitPrice]
			FROM [TermProject].[dbo].[Products] AS p
			WHERE p.[UnitPrice] BETWEEN @min AND @max) o
		WHERE o.[rowID] = @row
		PRINT(RIGHT(SPACE(@col1_width) + CAST(@id AS VARCHAR), @col1_width) + ' ' + LEFT(@name + SPACE(@col2_width), @col2_width) + ' ' + LEFT(@eng_name + SPACE(@col3_width), @col3_width) + FORMAT(@price, 'C'))
		SET @row += 1
	END
	SET NOCOUNT OFF
	SELECT p.[ProductID], p.[ProductName], p.[EnglishName], p.[UnitPrice]
	FROM [TermProject].[dbo].[Products] AS p
	WHERE p.[UnitPrice] BETWEEN @min AND @max
	ORDER BY p.[UnitPrice]
GO
EXEC [TermProject].[dbo].[UnitPriceByRange] 6.00, 12.00;
PRINT('')
PRINT('===== D6')
DROP PROCEDURE IF EXISTS OrdersByDates
GO
CREATE PROCEDURE OrdersByDates(@earliest SMALLDATETIME, @latest SMALLDATETIME)
AS
	SET NOCOUNT ON
	PRINT('OrderID     Customer                            Shipper                             ShippedDate                        ')
	PRINT('----------- ----------------------------------- ----------------------------------- -----------------------------------')
	DECLARE @id INT
	DECLARE @cust NVARCHAR(40)
	DECLARE @ship NVARCHAR(40)
	DECLARE @ship_date SMALLDATETIME
	DECLARE @col1_width INT = 11
	DECLARE @col2_width INT = 35
	DECLARE @col3_width INT = 35
	DECLARE @row INT = 1
	WHILE (@row < (SELECT COUNT(*) FROM [TermProject].[dbo].[Orders] AS o WHERE o.[ShippedDate] BETWEEN @earliest AND @latest))
	BEGIN
		SELECT @id = o.[OrderID], @cust = o.[Customer], @ship = o.[Shipper], @ship_date = o.[ShippedDate]
		FROM (
			SELECT ROW_NUMBER() OVER (ORDER BY o.[ShippedDate]) AS [rowID], o.[OrderID], c.[CompanyName] AS [Customer], s.[CompanyName] AS [Shipper], o.[ShippedDate]
			FROM [TermProject].[dbo].[Orders] AS o
			JOIN [TermProject].[dbo].[Customers] AS c ON c.[CustomerID] = o.[CustomerID]
			JOIN [TermProject].[dbo].[Shippers] AS s ON o.[ShipperID] = s.[ShipperID]
			WHERE o.[ShippedDate] BETWEEN @earliest AND @latest) o
		WHERE o.[rowID] = @row
		PRINT(RIGHT(SPACE(@col1_width) + CAST(@id AS VARCHAR), @col1_width) + ' ' + LEFT(@cust + SPACE(@col2_width), @col2_width) + ' ' + LEFT(@ship + SPACE(@col3_width), @col3_width) + ' ' + FORMAT(@ship_date, 'MMMM d, yyyy'))
		SET @row += 1
	END
	SET NOCOUNT OFF
	SELECT o.[OrderID], c.[CompanyName] AS [Customer], s.[CompanyName] AS [Shipper], o.[ShippedDate]
	FROM [TermProject].[dbo].[Orders] AS o
	JOIN [TermProject].[dbo].[Customers] AS c ON c.[CustomerID] = o.[CustomerID]
	JOIN [TermProject].[dbo].[Shippers] AS s ON o.[ShipperID] = s.[ShipperID]
	WHERE o.[ShippedDate] BETWEEN @earliest AND @latest
	ORDER BY o.[ShippedDate]
GO
EXEC [TermProject].[dbo].[OrdersByDates] '1991-05-15', '1991-05-31';
PRINT('')
PRINT('===== D7')
DROP PROCEDURE IF EXISTS ProductsByMonthAndYear
GO
CREATE PROCEDURE ProductsByMonthAndYear(@engquery VARCHAR(40), @month VARCHAR(25), @year INT)
AS
	SET NOCOUNT ON
	PRINT('EnglishName                                                             UnitsInStock Name                               ')
	PRINT('----------------------------------- ----------------------------------- ------------ -----------------------------------')
	DECLARE @eng_name NVARCHAR(40)
	DECLARE @price MONEY
	DECLARE @stock SMALLINT
	DECLARE @supplier_name NVARCHAR(50)
	DECLARE @col1_width INT = 35
	DECLARE @col2_width INT = 35
	DECLARE @col3_width INT = 12
	DECLARE @row INT = 1
	WHILE (@row <= (
		SELECT COUNT(DISTINCT pr.[EnglishName])
		FROM [TermProject].[dbo].[Products] AS pr
		JOIN [TermProject].[dbo].[Suppliers] AS su ON pr.[SupplierID] = su.[SupplierID]
		JOIN [TermProject].[dbo].[OrderDetails] AS od ON od.[ProductID] = pr.[ProductID]
		JOIN [TermProject].[dbo].[Orders] AS o ON o.[OrderID] = od.[OrderID]
		WHERE pr.[EnglishName] LIKE @engquery AND YEAR(o.[OrderDate]) = @year AND 
			MONTH(o.[OrderDate]) = CASE UPPER(@month)
				WHEN 'JANUARY' THEN 1
				WHEN 'FEBRUARY' THEN 2
				WHEN 'MARCH' THEN 3
				WHEN 'APRIL' THEN 4
				WHEN 'MAY' THEN 5
				WHEN 'JUNE' THEN 6
				WHEN 'JULY' THEN 7
				WHEN 'AUGUST' THEN 8
				WHEN 'SEPTEMBER' THEN 9
				WHEN 'OCTOBER' THEN 10
				WHEN 'NOVEMBER' THEN 11
				WHEN 'DECEMBER' THEN 12
			END))
		BEGIN
			SELECT @eng_name = o.[EnglishName], @price = o.[UnitPrice], @stock = o.[UnitsInStock], @supplier_name = o.[Name]
			FROM (
				SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY o.[OrderDate]) AS [rowID], pr.[EnglishName], pr.[UnitPrice], pr.[UnitsInStock], su.[Name]
				FROM [TermProject].[dbo].[Products] AS pr
				JOIN [TermProject].[dbo].[Suppliers] AS su ON pr.[SupplierID] = su.[SupplierID]
				JOIN [TermProject].[dbo].[OrderDetails] AS od ON od.[ProductID] = pr.[ProductID]
				JOIN [TermProject].[dbo].[Orders] AS o ON o.[OrderID] = od.[OrderID]
				WHERE pr.[EnglishName] LIKE @engquery AND YEAR(o.[OrderDate]) = @year AND 
					MONTH(o.[OrderDate]) = CASE UPPER(@month)
						WHEN 'JANUARY' THEN 1
						WHEN 'FEBRUARY' THEN 2
						WHEN 'MARCH' THEN 3
						WHEN 'APRIL' THEN 4
						WHEN 'MAY' THEN 5
						WHEN 'JUNE' THEN 6
						WHEN 'JULY' THEN 7
						WHEN 'AUGUST' THEN 8
						WHEN 'SEPTEMBER' THEN 9
						WHEN 'OCTOBER' THEN 10
						WHEN 'NOVEMBER' THEN 11
						WHEN 'DECEMBER' THEN 12
					END) o
			WHERE o.[rowID] = @row
			PRINT(LEFT(@eng_name + SPACE(@col1_width), @col1_width) + ' ' + LEFT(FORMAT(@price, 'C') + SPACE(@col2_width), @col2_width) + ' ' + RIGHT(SPACE(@col3_width) + CAST(@stock AS VARCHAR), @col3_width) + ' ' + @supplier_name)
			SET @row += 1
		END
	SET NOCOUNT OFF
	SELECT DISTINCT pr.[EnglishName], pr.[UnitPrice], pr.[UnitsInStock], su.[Name]
	FROM [TermProject].[dbo].[Products] AS pr
	JOIN [TermProject].[dbo].[Suppliers] AS su ON pr.[SupplierID] = su.[SupplierID]
	JOIN [TermProject].[dbo].[OrderDetails] AS od ON od.[ProductID] = pr.[ProductID]
	JOIN [TermProject].[dbo].[Orders] AS o ON o.[OrderID] = od.[OrderID]
	WHERE pr.[EnglishName] LIKE @engquery AND YEAR(o.[OrderDate]) = @year AND 
		MONTH(o.[OrderDate]) = CASE UPPER(@month)
			WHEN 'JANUARY' THEN 1
			WHEN 'FEBRUARY' THEN 2
			WHEN 'MARCH' THEN 3
			WHEN 'APRIL' THEN 4
			WHEN 'MAY' THEN 5
			WHEN 'JUNE' THEN 6
			WHEN 'JULY' THEN 7
			WHEN 'AUGUST' THEN 8
			WHEN 'SEPTEMBER' THEN 9
			WHEN 'OCTOBER' THEN 10
			WHEN 'NOVEMBER' THEN 11
			WHEN 'DECEMBER' THEN 12
		END
GO
EXEC [TermProject].[dbo].[ProductsByMonthAndYear] '%cheese', 'December', 1992;
PRINT('')
PRINT('===== D8')
DROP PROCEDURE IF EXISTS ReorderQuantity
GO
CREATE PROCEDURE ReorderQuantity(@quantity SMALLINT)
AS
	SET NOCOUNT ON
	PRINT('ProductID   ProductName                         Name                                UnitsInStock ReorderLevel')
	PRINT('----------- ----------------------------------- ----------------------------------- ------------ ------------')
	DECLARE @id INT
	DECLARE @name NVARCHAR(40)
	DECLARE @supplier NVARCHAR(50)
	DECLARE @stock SMALLINT
	DECLARE @reorder SMALLINT
	DECLARE @col1_width INT = 11
	DECLARE @col2_width INT = 35
	DECLARE @col3_width INT = 35
	DECLARE @col4_width INT = 12
	DECLARE @col5_width INT = 12
	DECLARE @row INT = 1
	WHILE(@row <= (SELECT COUNT(*) FROM [TermProject].[dbo].[Products] AS p WHERE p.[ReorderLevel] < @quantity))
	BEGIN
		SELECT @id = o.[ProductID], @name = o.[ProductName], @supplier = o.[Name], @stock = o.[UnitsInStock], @reorder = o.[ReorderLevel]
		FROM (
			SELECT ROW_NUMBER() OVER (ORDER BY p.[ProductName]) AS [rowID], p.[ProductID], p.[ProductName], p.[UnitsInStock], p.[ReorderLevel], s.[Name]
			FROM [TermProject].[dbo].[Products] AS p
			JOIN [TermProject].[dbo].[Suppliers] AS s ON p.[SupplierID] = s.[SupplierID]
			WHERE p.[ReorderLevel] < @quantity) o
		WHERE o.[rowID] = @row
		PRINT(RIGHT(SPACE(@col1_width) + CAST(@id AS VARCHAR), @col1_width) + ' ' + LEFT(@name + SPACE(@col2_width), @col2_width) + ' ' + LEFT(@supplier + SPACE(@col3_width), @col3_width) + ' ' + RIGHT(SPACE(@col4_width) + CAST(@stock AS VARCHAR), @col4_width) + ' ' + RIGHT(SPACE(@col5_width) + CAST(@reorder AS VARCHAR), @col5_width))
		SET @row += 1
	END
	SET NOCOUNT OFF
	SELECT p.[ProductID], p.[ProductName], p.[UnitsInStock], p.[ReorderLevel], s.[Name]
	FROM [TermProject].[dbo].[Products] AS p
	JOIN [TermProject].[dbo].[Suppliers] AS s ON p.[SupplierID] = s.[SupplierID]
	WHERE p.[ReorderLevel] < @quantity
	ORDER BY p.[ProductName]
GO
EXEC [TermProject].[dbo].[ReorderQuantity] 5;
PRINT('')
PRINT('===== D9')
DROP PROCEDURE IF EXISTS ShippingDelay
GO
CREATE PROCEDURE ShippingDelay(@cutoffDate SMALLDATETIME)
AS
	SET NOCOUNT ON
	PRINT('OrderID     CustomerName                        ShipperName                         OrderDate                           RequiredDate                        ShippedDate                         DaysDelayedBy')
	PRINT('----------- ----------------------------------- ----------------------------------- ----------------------------------- ----------------------------------- ----------------------------------- -------------')
	DECLARE @order_id INT
	DECLARE @cust_name NVARCHAR(40)
	DECLARE @ship_name NVARCHAR(40)
	DECLARE @order_date SMALLDATETIME
	DECLARE @expect_date SMALLDATETIME
	DECLARE @ship_date SMALLDATETIME
	DECLARE @delay INT
	DECLARE @col1_width INT = 11
	DECLARE @col2_width INT = 35
	DECLARE @col3_width INT = 35
	DECLARE @col4_width INT = 35
	DECLARE @col5_width INT = 35
	DECLARE @col6_width INT = 35
	DECLARE @col7_width INT = 13
	DECLARE @row INT = 1
	WHILE (@row <= (SELECT COUNT(*) FROM [TermProject].[dbo].[Orders] AS o WHERE o.[OrderDate] > @cutoffDate AND o.[ShippedDate] > o.[RequiredDate]))
	BEGIN
		SELECT @order_id = o.[OrderID], @cust_name = o.[CustomerName], @ship_name = o.[ShipperName], @order_date = o.[OrderDate], @expect_date = o.[RequiredDate], @ship_date = o.[ShippedDate], @delay = o.[DaysDelayedBy]
		FROM (SELECT ROW_NUMBER() OVER (ORDER BY o.[OrderDate]) AS [rowID], o.[OrderID], o.[OrderDate], o.[RequiredDate], o.[ShippedDate], c.[CompanyName] AS [CustomerName], s.[CompanyName] AS [ShipperName], DATEDIFF(dd, o.[RequiredDate], o.[ShippedDate]) AS [DaysDelayedBy]
			FROM [TermProject].[dbo].[Orders] AS o
			JOIN [TermProject].[dbo].[Customers] AS c ON c.[CustomerID] = o.[CustomerID]
			JOIN [TermProject].[dbo].[Shippers] AS s ON o.[ShipperID] = s.[ShipperID]
			WHERE o.[OrderDate] > @cutoffDate AND o.[ShippedDate] > o.[RequiredDate]) o
		WHERE o.[rowID] = @row
		PRINT(RIGHT(SPACE(@col1_width) + CAST(@order_id AS VARCHAR), @col1_width) + ' ' + LEFT(@cust_name + SPACE(@col2_width), @col2_width) + ' ' + LEFT(@ship_name + SPACE(@col3_width), @col3_width) + ' ' + LEFT(FORMAT(@order_date, 'MMMM d, yyyy') + SPACE(@col4_width), @col4_width) + ' ' + LEFT(FORMAT(@expect_date, 'MMMM d, yyyy') + SPACE(@col5_width), @col5_width) + ' ' + LEFT(FORMAT(@ship_date, 'MMMM d, yyyy') + SPACE(@col6_width), @col6_width) + ' ' + RIGHT(SPACE(@col7_width) + CAST(@delay AS VARCHAR), @col7_width))
		SET @row += 1
	END
	SET NOCOUNT OFF
	SELECT o.[OrderID], o.[OrderDate], o.[RequiredDate], o.[ShippedDate], c.[CompanyName] AS [CustomerName], s.[CompanyName] AS [ShipperName], DATEDIFF(dd, o.[RequiredDate], o.[ShippedDate]) AS [DaysDelayedBy]
	FROM [TermProject].[dbo].[Orders] AS o
	JOIN [TermProject].[dbo].[Customers] AS c ON c.[CustomerID] = o.[CustomerID]
	JOIN [TermProject].[dbo].[Shippers] AS s ON o.[ShipperID] = s.[ShipperID]
	WHERE o.[OrderDate] > @cutoffDate AND o.[ShippedDate] > o.[RequiredDate]
	ORDER BY o.[OrderDate]
GO
SET NOCOUNT ON
GO
DROP TABLE IF EXISTS #Output
GO
CREATE TABLE #Output ([rowID] INT IDENTITY(1,1) PRIMARY KEY CLUSTERED)
DECLARE @row INT = 1
WHILE (@row <= (SELECT COUNT(*) FROM #Output))
BEGIN
	SELECT *
	FROM #Output AS o
	WHERE o.[rowID] = @row
	SET @row += 1
END
SET NOCOUNT OFF
GO
EXEC [TermProject].[dbo].[ShippingDelay] '1993-12-01';
PRINT('')
PRINT('===== D10')
DROP PROCEDURE IF EXISTS DeleteInactiveCustomers
GO
CREATE PROCEDURE DeleteInactiveCustomers
AS
	DELETE FROM [TermProject].[dbo].[Customers]
	WHERE [CustomerID] NOT IN (
		SELECT [CustomerID]
		FROM [TermProject].[dbo].[Orders])
GO
EXEC DeleteInactiveCustomers;
GO
PRINT('ActiveCustomers')
PRINT('---------------')
DECLARE @col_width INT = 15
DECLARE @active_cust INT = (SELECT COUNT(*) FROM [TermProject].[dbo].[Customers])
PRINT RIGHT(SPACE(@col_width) + CAST(@active_cust AS VARCHAR), @col_width)
SELECT COUNT(*) AS [ActiveCustomers] FROM [TermProject].[dbo].[Customers]
GO

CREATE TRIGGER [dbo].[InsertShippers]
ON [TermProject].[dbo].[Shippers]
INSTEAD OF INSERT
AS
DECLARE @id INT = (SELECT [ShipperID] FROM INSERTED)
DECLARE @name NVARCHAR(40) = (SELECT [CompanyName] FROM INSERTED)
BEGIN
	IF (SELECT COUNT([CompanyName]) FROM [TermProject].[dbo].[Shippers] WHERE [CompanyName] = @name) = 0
	BEGIN
		INSERT INTO [TermProject].[dbo].[Shippers] ([ShipperID], [CompanyName]) VALUES (@id, @name)
	END
END;
GO
PRINT('')
PRINT('===== D11')
INSERT INTO [TermProject].[dbo].[Shippers]
VALUES (4, 'Federal Shipping');
GO
PRINT('ShipperID   CompanyName                        ')
PRINT('----------- -----------------------------------')
DECLARE @col1_width INT = 11
DECLARE @row INT = 1
DECLARE @id INT
DECLARE @name NVARCHAR(40)
WHILE (@row <= (SELECT COUNT(*) FROM [TermProject].[dbo].[Shippers]))
BEGIN
	SELECT @id = [ShipperID], @name = [CompanyName] FROM [TermProject].[dbo].[Shippers] WHERE [ShipperID] = @row
	PRINT(RIGHT(SPACE(@col1_width) + CAST(@id AS VARCHAR), @col1_width) + ' ' + @name)
	SET @row += 1
END
SELECT * FROM [TermProject].[dbo].[Shippers];
GO
INSERT INTO [TermProject].[dbo].[Shippers]
VALUES (4, 'On-Time Delivery');
GO
PRINT('ShipperID   CompanyName                        ')
PRINT('----------- -----------------------------------')
DECLARE @col1_width INT = 11
DECLARE @row INT = 1
DECLARE @id INT
DECLARE @name NVARCHAR(40)
WHILE (@row <= (SELECT COUNT(*) FROM [TermProject].[dbo].[Shippers]))
BEGIN
	SELECT @id = [ShipperID], @name = [CompanyName] FROM [TermProject].[dbo].[Shippers] WHERE [ShipperID] = @row
	PRINT(RIGHT(SPACE(@col1_width) + CAST(@id AS VARCHAR), @col1_width) + ' ' + @name)
	SET @row += 1
END
SELECT * FROM [TermProject].[dbo].[Shippers];
GO

CREATE TRIGGER [CheckQuantity]
ON [TermProject].[dbo].[OrderDetails]
INSTEAD OF INSERT, UPDATE
AS
DECLARE @inputamt SMALLINT
DECLARE @inputOrderID INT
DECLARE @inputProductID INT
DECLARE @queriedquantity SMALLINT
DECLARE @queriedOrderID INT
DECLARE @queriedProductID INT
DECLARE @queriedOrderAmt SMALLINT
BEGIN
	SELECT @inputamt = i.[Quantity], @inputOrderID = i.[OrderID], @inputProductID = i.[ProductID], @queriedquantity = p.[UnitsInStock], @queriedOrderAmt = o.[Quantity] FROM INSERTED AS i JOIN [Products] AS p ON i.[ProductID] = p.[ProductID] JOIN [OrderDetails] AS o ON o.[ProductID] = p.[ProductID]
	IF @inputamt > @queriedquantity
	BEGIN
		PRINT('Error')
		PRINT('-----------------------------------')
		PRINT('Ordered: ' + CAST(@inputamt AS VARCHAR) + '; available: ' + CAST(@queriedquantity AS VARCHAR))
	END
	ELSE
	BEGIN
		UPDATE [TermProject].[dbo].[OrderDetails]
		SET [Quantity] = @inputamt
		WHERE [OrderID] = @inputOrderID AND [ProductID] = @inputProductID
	END
END;
GO
PRINT('')
PRINT('===== D12')
UPDATE [TermProject].[dbo].[OrderDetails]
SET [Quantity] = 50
WHERE [OrderID] = 10044 AND [ProductID] = 77;
GO
DECLARE @col_width INT = 8
DECLARE @qty1 SMALLINT
PRINT('Quantity')
PRINT('--------')
SELECT @qty1 = [Quantity] FROM [TermProject].[dbo].[OrderDetails]
WHERE [OrderID] = 10044 AND [ProductID] = 77
PRINT RIGHT(SPACE(@col_width) + CAST(@qty1 AS VARCHAR), @col_width)
SELECT @qty1 AS [Quantity]
GO
UPDATE [TermProject].[dbo].[OrderDetails]
SET [Quantity] = 30
WHERE [OrderID] = 10044 AND [ProductID] = 77;
GO
DECLARE @col_width INT = 8
DECLARE @qty2 SMALLINT
PRINT('Quantity')
PRINT('--------')
SELECT @qty2 = [Quantity] FROM [TermProject].[dbo].[OrderDetails]
WHERE [OrderID] = 10044 AND [ProductID] = 77
PRINT RIGHT(SPACE(@col_width) + CAST(@qty2 AS VARCHAR), @col_width)
SELECT @qty2 AS [Quantity]
GO