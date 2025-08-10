USE [TermProject]
GO

/****** Object:  Trigger [dbo].[CheckQuantity]    Script Date: 2023-03-23 11:41:49 PM ******/
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
		UPDATE [TermProject].[dbo].[OrderDetails]
		SET [Quantity] = @queriedOrderAmt
		WHERE [OrderID] = @queriedOrderID AND [ProductID] = @queriedProductID
	END
	ELSE
	BEGIN
		UPDATE [TermProject].[dbo].[OrderDetails]
		SET [Quantity] = @inputamt
		WHERE [OrderID] = @queriedOrderID AND [ProductID] = @queriedProductID
	END
END;
GO