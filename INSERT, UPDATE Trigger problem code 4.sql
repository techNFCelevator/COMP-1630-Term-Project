USE [TermProject]
GO

/****** Object:  Trigger [dbo].[CheckQuantity]    Script Date: 2023-03-24 1:23:37 AM ******/
CREATE TRIGGER [dbo].[CheckQuantity]
ON [TermProject].[dbo].[OrderDetails]
INSTEAD OF INSERT, UPDATE
AS
DECLARE @inputamt SMALLINT
DECLARE @queriedquantity SMALLINT
DECLARE @queriedOrderID INT
DECLARE @queriedProductID INT
DECLARE @queriedOrderAmt SMALLINT
BEGIN
	SELECT @inputamt = i.[Quantity], @queriedquantity = p.[UnitsInStock], @queriedProductID = p.[ProductID], @queriedOrderID = o.[OrderID], @queriedOrderAmt = o.[Quantity] FROM INSERTED AS i JOIN [Products] AS p ON i.[ProductID] = p.[ProductID] JOIN [OrderDetails] AS o ON o.[ProductID] = p.[ProductID]
	IF @inputamt > @queriedquantity
	BEGIN
		PRINT('Error')
		PRINT('-----------------------------------')
		PRINT('Ordered: ' + CAST(@inputamt AS VARCHAR) + '; available: ' + CAST(@queriedquantity AS VARCHAR))
		--UPDATE [TermProject].[dbo].[OrderDetails]
		--SET [Quantity] = @queriedOrderAmt
		--WHERE [OrderID] = @queriedOrderID AND [ProductID] = @queriedProductID
	END
	ELSE
	BEGIN
		UPDATE [TermProject].[dbo].[OrderDetails]
		SET [Quantity] = @inputamt
		WHERE [OrderID] = @queriedOrderID AND [ProductID] = @queriedProductID
	END
END;
GO