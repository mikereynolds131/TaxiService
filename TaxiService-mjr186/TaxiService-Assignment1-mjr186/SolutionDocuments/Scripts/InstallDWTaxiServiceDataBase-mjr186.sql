USE [master]
GO


if EXISTS (SELECT name from sys.databases WHERE name = N'DWTaxiService-mjr186')
	BEGIN
		
		ALTER DATABASE [DWTaxiService-mjr186] SET SINGLE_USER WITH ROLLBACK IMMEDIATE 
		DROP DATABASE [DWTaxiService-mjr186]
	END
GO

CREATE DATABASE [DWTaxiService-mjr186]
GO





USE [DWTaxiService-mjr186]    
GO



CREATE TABLE dbo.DimCity
(
	CityKey		int NOT NULL Identity,
	CityId		nchar(10) NOT NULL,
	CityName	nvarchar(50) NOT NULL,
	
	CONSTRAINT [PK_DimCity] PRIMARY KEY ([CityKey] ASC) 
)
	
GO

CREATE TABLE dbo.DimDriver
(
	DriverKey 	int NOT NULL Identity,
	DriverId	nchar(8) NOT NULL,
	DriverName	nvarchar(50) NOT NULL,	
	CONSTRAINT [PK_DimDriver] PRIMARY KEY ([DriverKey] ASC)
) 
GO



CREATE TABLE dbo.DimLocation
(
	LocationKey		int NOT NULL Identity,
	CityKey			int	 NOT NULL,
	StreetId		nchar(10) NOT NULL,
	Street			nvarchar(50) NOT NULL,	
	CONSTRAINT [PK_DimLocation] PRIMARY KEY ([LocationKey] ASC)
)
GO


CREATE TABLE dbo.DimDates 
(
  	DateKey		int NOT NULL IDENTITY, 
  	[Date]		datetime NOT NULL,
  	[DateName]	nvarchar(50) NOT NULL,
  	[Month]		int NOT NULL,
  	[MonthName]	nvarchar(50) NOT NULL,  	
  	[Year]		int NOT NULL,
  	[YearName]	nvarchar(50) NOT NULL,
	CONSTRAINT [PK_DimDates] PRIMARY KEY ([DateKey] ASC)
)


CREATE TABLE dbo.FactTrips
(
	TripKey		int NOT NULL,
	TripNumber	nvarchar(50) NOT NULL,
	DateKey		int NOT NULL,
	LocationKey	int Not Null,
	DriverKey	int Not Null,
	TripMileage decimal(18,4) Not Null,
	TripCharge decimal(18,4) Not Null,
 	CONSTRAINT [PK_FactTrips] PRIMARY KEY ([TripKey])
	
)
GO





Alter Table dbo.DimLocations With Check 
	Add Constraint [FK_DimLocations_DimCity] 
		Foreign Key (CityKey) References dbo.DimCity (CityKey)
Go

Alter Table dbo.FactTrip With Check 
	Add Constraint [FK_FactTrip_DimLocation] 
		Foreign Key (LocationKey) References dbo.DimLocations (LocationKey)
Go

Alter Table dbo.FactTrip With Check 
	Add Constraint [FK_FactTrip_DimDriver] 
		Foreign Key (DriverKey) References dbo.DimDriver (DriverKey)
Go

Alter Table dbo.FactTrips With Check 
	Add Constraint [FK_FactTrips_DimDates] 
		Foreign Key (DateKey) References dbo.DimDates (DateKey)
Go



 