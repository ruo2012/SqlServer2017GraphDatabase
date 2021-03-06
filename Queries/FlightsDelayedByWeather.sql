SET STATISTICS TIME ON
SET STATISTICS IO ON

SELECT Name, DelayedByWeather, Total, 100.0 * DelayedByWeather / Total as Percentage
FROM 
	(SELECT a.Name as Name, 
		(SELECT Count(*)
			FROM Flight, Airport, Reason, origin, delayedBy
			WHERE MATCH(Airport<-(origin)-Flight-(delayedBy)->Reason)
			AND Reason.Code = 'B'
			AND Airport.Name = a.Name) as DelayedByWeather,
		(SELECT COUNT(*)
			FROM Flight, Airport, origin
			WHERE MATCH(Flight-(origin)->Airport)
			AND Airport.Name = a.Name) as Total
FROM Airport a) as AirportStatistics
WHERE Total > 0
ORDER BY Percentage DESC