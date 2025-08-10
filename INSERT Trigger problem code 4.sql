USE [TermProject]
GO

/****** Object:  Trigger [dbo].[InsertShippers]    Script Date: 2023-03-23 10:40:14 PM ******/
CREATE TRIGGER [dbo].[InsertShippers]
ON [TermProject].[dbo].[Shippers]
INSTEAD OF INSERT
AS
DECLARE @id INT = (SELECT [ShipperID] FROM INSERTED)
DECLARE @name NVARCHAR(40) = (SELECT [CompanyName] FROM INSERTED)
BEGIN
	IF NOT EXISTS(SELECT s.[CompanyName] FROM [TermProject].[dbo].[Shippers] AS s WHERE s.[CompanyName] = @name)
	BEGIN
		INSERT INTO [TermProject].[dbo].[Shippers] ([ShipperID], [CompanyName]) VALUES (@id, @name)
	END
	ELSE
	BEGIN
		DELETE FROM [TermProject].[dbo].[Shippers] WHERE [ShipperID] = @id
	END
END;



