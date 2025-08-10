USE [TermProject]
GO

/****** Object:  Trigger [dbo].[InsertShippers]    Script Date: 2023-03-22 6:26:23 PM ******/
CREATE TRIGGER [dbo].[InsertShippers]
ON [TermProject].[dbo].[Shippers]
INSTEAD OF INSERT
AS
BEGIN
	--INSERT INTO [TermProject].[dbo].[Shippers] (CompanyName)
	--SELECT IIF(i.[CompanyName] IN (SELECT [CompanyName] FROM [TermProject].[dbo].[Shippers]), 'CompanyName already exists', i.[CompanyName])
	--FROM INSERTED i;
	IF (SELECT [CompanyName] FROM INSERTED) IN (SELECT [CompanyName] FROM [TermProject].[dbo].[Shippers]) ROLLBACK TRANSACTION
END;