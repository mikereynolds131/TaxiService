USE [DWTaxiService-mjr186]
GO


Create PROCEDURE [dbo].[spPopulateDimDates1]
	
AS
BEGIN
	
	SET NOCOUNT ON;
Declare @StartDate datetime = '01/01/2010'   
Declare @EndDate datetime = '12/31/2020' 


Declare @DateInProcess datetime                
Set @DateInProcess = @StartDate

While @DateInProcess <= @EndDate
 Begin
 
 Insert Into DimDates
 (	[Date], 
	[DateName], 
	[Month], 
	[MonthName], 
	[Year], 
	[YearName] 
 )
 Values 
 ( 
	  @DateInProcess,										-- [Date]
	  DateName ( weekday, @DateInProcess ),					-- [DateName]  
	  Month( @DateInProcess ),								-- [Month]   
	  DateName( month, @DateInProcess ),					-- [MonthName]
	  Year( @DateInProcess),
	  Cast( Year(@DateInProcess ) as nVarchar(50) )			 -- [Year] 
 )  
 
 Set @DateInProcess = DateAdd(d, 1, @DateInProcess)

 End  

 

Set Identity_Insert [DWTaxiService-mjr186].[dbo].[DimDates] On

Insert Into [dbo].[DimDates] 
  ( [DateKey],
	[Date],
	[DateName], 
	[Month],
	[MonthName],
	[Year], 
	[YearName] 
  )
  (
	  Select 
		[DateKey] = -1,
		[Date] =  '01/01/1989',
		[DateName] = Cast('Unknown Day' as nVarchar(50)),
		[Month] = -1,
		[MonthName] = Cast('Unknown Month' as nVarchar(50)),
		[Year] = -1,
		[YearName] = Cast('Unknown Year' as nVarchar(50))
  )
  Insert Into [dbo].[DimDates] 
  ( 
		[DateKey],
		[Date],
		[DateName], 
		[Month],
		[MonthName],
		[Year], 
		[YearName] 
  )
  (
	  Select 
		[DateKey] = -2, 
		[Date] = '01/02/1989', 
		[DateName] = Cast('Corrupt Day' as nVarchar(50)),
		[Month] = -2, 
		[MonthName] = Cast('Corrupt Month' as nVarchar(50)),
		[Year] = -2,
		[YearName] = Cast('Corrupt Year' as nVarchar(50))
  )
 

  Set Identity_Insert [DWTaxiService-mjr186].[dbo].[DimDates] off  
 
	 
END
