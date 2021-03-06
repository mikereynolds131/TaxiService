USE [DWTaxiService-mjr186]
GO

Create PROCEDURE [dbo].[spPopulateDimDriver]
	
AS
BEGIN
	
	SET NOCOUNT ON;
	INSERT INTO dbo.DimDriver
	(
		DriverId,
		DriverName
	)
	(
	Select
		[DriverId] = Cast([Driver_Id] As nchar(8)),
		[DriverName] = Cast((FirstName + '' + LastName) as nvarchar(50))
	FROM [TaxiServiceDB-mjr186].[dbo].[Driver]   
	)
	 
END
