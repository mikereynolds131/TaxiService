use [DWTaxiService-mjr186]
go
 Create View vwDataForFactTrips1
 As
 SELECT        
	DateKey = [DimDates].[DateKey],
		LocationKey = [DimLocation].[LocationKey], 
		DriverKey = [DimDriver].[DriverKey],
		TripNumber = Cast([number] as nVarchar(50)),
		TripMileage = Cast( isNull([milage], -1) as decimal(18,4)),
		TripCharge = Cast( isNull([charge], -1) as decimal(18,4))

FROM (([TaxiServiceDB-mjr186].[dbo].[Trip] as T INNER JOIN DimLocation
			ON T.Street_Code = DimLocation.StreetId)
			  inner join DimDriver on DimDriver.DriverID = T.Driver_Id)
				inner join DimDates on DimDates.[Date] = T.[Date]