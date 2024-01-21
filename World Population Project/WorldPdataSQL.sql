select * FROM [wpopulation].[dbo].[world_population_data$]

--Top 10 Countries with highest population in 2023 vs 1970 with growth status
SELECT TOP 10 
    country,
    [2023_population] / 1000000.0 AS [2023_population_million],
    [1970_population] / 1000000.0 AS [1970_population_million],
    CASE
        WHEN [2023_population] > [1970_population] THEN 'Grown'
        WHEN [2023_population] < [1970_population] THEN 'Declined'
        ELSE 'No Change'
    END AS Growth_Status
FROM [wpopulation].[dbo].[world_population_data$]
ORDER BY [2023_population] DESC;


--Bottom 10 Countries with Lowest population in 2023 vs 1970 comparision with growth status
SELECT top 10 country,[1970_population],[2023_population],
    CASE
        WHEN [2023_population] > [1970_population] THEN 'Grown'
        WHEN [2023_population] < [1970_population] THEN 'Declined'
        ELSE 'No Change'
    END AS Growth_Status
FROM [wpopulation].[dbo].[world_population_data$]
ORDER BY [2023_population] 

--Top 10 Densely populated countries
SELECT top 10 country, [density_sq_km],[area_sq_km]
FROM [wpopulation].[dbo].[world_population_data$] 
ORDER BY density_sq_km DESC

--Top 5 Loosely populated countries
SELECT top 5 country, [density_sq_km],[2023_population]
FROM [wpopulation].[dbo].[world_population_data$] 
ORDER BY density_sq_km 

SELECT TOP 5 
    country,[area_sq_km],
    CAST([density_sq_km] AS decimal(12,7)) AS Density_in_Decimals,
    [2023_population]
FROM [wpopulation].[dbo].[world_population_data$] 
ORDER BY Density_in_Decimals 

--Top 10 countries with highest population growth perecentage 
SELECT TOP 10 country, growth_rate * 100 AS percentage_growth 
FROM [wpopulation].[dbo].[world_population_data$] 
ORDER BY growth_rate DESC

--Bottom 10 countries with lowest population growth perecentage 
SELECT TOP 10 country, growth_rate * 100 AS percentage_growth 
FROM [wpopulation].[dbo].[world_population_data$] 
ORDER BY growth_rate 

--2023 population of all continents
SELECT continent, CAST(SUM([2023_population]) AS decimal(12,2)) AS Total_population
FROM [wpopulation].[dbo].[world_population_data$]  
GROUP BY continent
ORDER BY Total_population DESC


-- Continents Population growth difference from 1970 to 2023 in millions
SELECT 
    continent,
    CAST(SUM([2023_population]) / 1000000.0 AS decimal(12,2)) AS Total_population_2023_million,
    CAST(SUM([1970_population]) / 1000000.0 AS decimal(12,2)) AS Total_population_1970_million,
    CAST(ABS(SUM([2023_population]) - SUM([1970_population])) / 1000000.0 AS decimal(12,2)) AS Population_difference_million,
    CAST(
        CASE
            WHEN SUM([1970_population]) = 0 THEN 100.00  -- Handle division by zero
            ELSE 
                (((SUM([2023_population]) - SUM([1970_population])) / SUM([1970_population])) * 100)
        END
        AS decimal(12,2)
    ) AS Growth_percentage
FROM [wpopulation].[dbo].[world_population_data$]  
GROUP BY continent
ORDER BY Growth_percentage DESC;


--Average growth of density per sqkm by each continent in years
SELECT 
    continent,
    CAST(SUM([2023_population]) / SUM([area_sq_km])AS decimal(12,2)) AS Avg_density_2023,
    CAST(SUM([2022_population]) / SUM([area_sq_km])AS decimal(12,2)) AS Avg_density_2022,
    CAST(SUM([2020_population]) / SUM([area_sq_km])AS decimal(12,2)) AS Avg_density_2020,
	CAST(SUM([2010_population]) / SUM([area_sq_km])AS decimal(12,2)) AS Avg_density_2010,
	CAST(SUM([1990_population]) / SUM([area_sq_km])AS decimal(12,2)) AS Avg_density_1990,
	CAST(SUM([1970_population]) / SUM([area_sq_km])AS decimal(12,2)) AS Avg_density_1970
FROM [wpopulation].[dbo].[world_population_data$]  
GROUP BY continent

--world population percentage share by countries
SELECT country,
    MAX(world_percentage) AS world_percentage,
    CASE
        WHEN MAX(world_percentage) < 0.1 THEN 'Below 0.1%'
        WHEN MAX(world_percentage) >= 0.1 AND MAX(world_percentage) < 0.5 THEN '0.1% - 0.5%'
        WHEN MAX(world_percentage) >= 0.5 AND MAX(world_percentage) < 1.0 THEN '0.5% - 1%'
        ELSE 'Above 1%'
    END AS Percentage_Range
FROM [wpopulation].[dbo].[world_population_data$] 
GROUP BY country
Order by world_percentage DESC

-- Replaced the density of Falkland Islands from 0 to the right value in decimals
UPDATE [wpopulation].[dbo].[world_population_data$]
SET [density_sq_km] = 0.311  
WHERE country = 'Falkland Islands'

-- Replaced the density of Greenland from 0 to the right value in decimals
UPDATE [wpopulation].[dbo].[world_population_data$]
SET [density_sq_km] = 0.026 
WHERE country = 'Greenland'
