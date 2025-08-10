CREATE TRIGGER [CheckQuantity]
ON [TermProject].[dbo].[OrderDetails]
INSTEAD OF INSERT, UPDATE
AS
DECLARE @inputamt SMALLINT
DECLARE @queriedquantity SMALLINT
BEGIN
	SELECT @inputamt = i.[Quantity], @queriedquantity = p.[UnitsInStock] FROM INSERTED AS i JOIN [Products] AS p ON i.[ProductID] = p.[ProductID]
	IF @inputamt > @queriedquantity ROLLBACK TRANSACTION
END;
GO