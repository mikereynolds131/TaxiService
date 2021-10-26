use [DWTaxiService-mjr186]
go
 Create View vwDataForDimLocations
 As
 Select 
	dbo.DimCity.CityKey, 
	[StreetId] = Cast(isNull([TaxiServiceDB-mjr186].dbo.Street.Street_Code,'unknown') as nvarchar(10)), 
	[Street] =Cast(isNull([TaxiServiceDB-mjr186].dbo.Street.StreetName,'unknown') as nvarchar(50))


From 
	  dbo.DimCity CROSS JOIN
     [TaxiServiceDB-mjr186].dbo.Street