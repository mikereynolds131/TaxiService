

USE [DWTaxiService-mjr186]
go


ALTER TABLE dbo.DimLocation DROP CONSTRAINT [FK_DimLocations_DimCity]

ALTER TABLE dbo.FactTrips DROP CONSTRAINT [FK_FactTrips_DimLocations]

ALTER TABLE dbo.FactTrips DROP CONSTRAINT [FK_FactTrips_DimDriver]

ALTER TABLE dbo.FactTrips DROP CONSTRAINT [FK_FactTrips_DimDates]


Go



TRUNCATE TABLE [dbo].[DimCity]
TRUNCATE TABLE [dbo].[DimDriver]
TRUNCATE TABLE [dbo].[DimLocations]
TRUNCATE TABLE [dbo].[DimDates]
TRUNCATE TABLE [dbo].[FactTrip]



Alter Table dbo.DimLocations With Check 
	Add Constraint [FK_DimLocations_DimCity] 
		Foreign Key (CityKey) References dbo.DimCity (CityKey)


Alter Table dbo.FactTrip With Check 
	Add Constraint [FK_FactTrip_DimLocation] 
		Foreign Key (LocationKey) References dbo.DimLocations (LocationKey)


Alter Table dbo.FactTrip With Check 
	Add Constraint [FK_FactTrip_DimDriver] 
		Foreign Key (DriverKey) References dbo.DimDriver (DriverKey)


Alter Table dbo.FactTrips With Check 
	Add Constraint [FK_FactTrips_DimDates] 
		Foreign Key (DateKey) References dbo.DimDates (DateKey)



INSERT INTO dbo.DimCity
(	 
	[CityId],
	[CityName]
	 
) 
(
	SELECT 
		[CityId]  =  CAST ( [City_Code] AS nchar(10) ),
		[CityName] = CAST ( [CountryName] as nvarchar(50) )
		
	From [TaxiServiceDB-mjr186].[dbo].[City]
)

go

INSERT INTO dbo.DimDriver
(	
	[DriverId] , 
	[DriverName]

)
(
	SELECT 
		[DriverId]  =  CAST ( [Driver_Id] AS nchar(8) ),
		[DriverName] = CAST ( isNull( FirstName + ' '+ LastName, 'Unknown') as nvarchar(50) )
	FROM [TaxiServiceDB-mjr186].[dbo].[Driver]
)
go




use [DWTaxiService-mjr186]
go

Declare @StartDate datetime = '01/01/1900'   
Declare @EndDate datetime = '12/31/2019' 


Declare @DateInProcess datetime                
Set @DateInProcess = @StartDate

While @DateInProcess <= @EndDate
 Begin

 Insert Into DimDates
 ( 
	[Date], 
	[DateName], 
	[Month],
	[MonthName], 
	[Year], 
	[YearName]
 )
 Values 
 ( 
  @DateInProcess,
   DateName ( weekday, @DateInProcess ) , 
   Month( @DateInProcess ) , 
   DateName( month, @DateInProcess ) ,
   Year( @DateInProcess ),
   Cast( Year(@DateInProcess ) as nVarchar(50) ) 
  )  
 
 Set @DateInProcess = DateAdd(d, 1, @DateInProcess)
 End



Set Identity_Insert [DWTaxiService-mjr186].[dbo].[DimDates] On
Insert Into [DWTaxiService-mjr186].[dbo].[DimDates] 
  ( [DateKey],
   [Date],
   [DateName],
   [Month],
   [MonthName], 
   [Year],
   [YearName] )
  Select 
   [DateKey] = -1,
   [Date] =  Cast('01/01/1900' as datetime ),
   [DateName] = Cast('Unknown Day' as nVarchar(50) ),
   [Month] = -1,
   [MonthName] = Cast('Unknown Month' as nVarchar(50) ) ,
   [Year] = -1,
   [YearName] = Cast('Unknown Year' as nVarchar(50) )
  Union
  Select 
   [DateKey] = -2,
   [Date] = Cast('01/01/1900' as datetime ),
   [DateName] = Cast('Corrupt Day' as nVarchar(50) ),
   [Month] = -2,
   [MonthName] = Cast('Corrupt Month' as nVarchar(50) ),
   [Year] = -2,
   [YearName] = Cast('Corrupt Year' as nVarchar(50) )
Go
  Set Identity_Insert [DWTaxiService-mjr186].[dbo].[DimDates] off

INSERT INTO [dbo].[DimLocation]
(	
	[CityKey], 
	[StreetId],
	[Street]
)
(
	SELECT  
		[CityKey]  =  [DWTaxiService-mjr186].[dbo].[DimCity].[CityKey],
		[StreetId] = CAST( [Street_Code] as nchar (10) ),
		[Street] =   CAST(isNull ([StreetName], 'Unknown') as nvarchar(50)
								

)	
	FROM [TaxiServiceDB-mjr186].[dbo].[Street] inner JOIN  [DWTaxiService-mjr186].[dbo].[DimCity]
		ON [TaxiServiceDB-mjr186].[dbo].[Street].[City_Code] = [DWTaxiService-mjr186].[dbo].[DimCity].[CityId])
		

go
	

INSERT INTO [dbo].[FactTrips]
(
	[TripNumber],
	[DateKey],
	[LocationKey],
	[DriverKey],
	[LocationKey],
	[DriverKey],
	[TripMileage],
	[TripCharge]
)
(
	Select
	[TripNumber] = Cast( [number] as nvarchar(50)),
	[DateKey] = [DWTaxiService-mjr186].[dbo].[DimDates].[DateKey],
	[LocationKey] = [DWTaxiService-mjr186].[dbo].[DimLocation].[LocationKey],
	[DriverKey] = [DWTaxiService-mjr186].[dbo].[DimDriver].[DriverKey],
	[TripMileage] = Cast( [milage] as decimal(18,4)),
	[TripCharge] = Cast ([charge] as decimal(18,4))
	



	FROM [TaxiServiceDB-mjr186].[dbo].[Trip] left JOIN  [DWTaxiService-mjr186].[dbo].[DimDates]
		ON [TaxiServiceDB-mjr186].[dbo].[Trip].[Date] = [DWTaxiService-mjr186].[dbo].[DimDates].[DateKey]
		inner join  [DWTaxiService-mjr186].[dbo].[DimDriver]
		on [TaxiServiceDB-mjr186].[dbo].[Trip].[Driver_Id] = [DWTaxiService-mjr186].[dbo].[DimDriver].[DriverKey]
		inner Join [DWTaxiService-mjr186].[dbo].[DimLocation]
		on  [TaxiServiceDB-mjr186].[dbo].[Trip].[Street_Code] = [DWTaxiService-mjr186].[dbo].[DimLocation].[LocationKey]
)

		





