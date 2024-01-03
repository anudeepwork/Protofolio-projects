--CLEAN DATA 

--Dropping TaxID and NAICS from H1b Table
SELECT * FROM [h1bdata].[dbo].[H1Bdata2021] WHERE [Fiscal Year] IS NULL OR Employer IS NULL
ALTER TABLE [H1Bdata2021]
DROP COLUMN [Tax ID]
ALTER TABLE [H1Bdata2021]
DROP COLUMN NAICS

------------------------------------------------------------------------------------------------------

-- Updating the Abbrevations of states 

UPDATE [h1bdata].[dbo].[H1Bdata2021]
SET State = 
   CASE 
      WHEN State = 'AL' THEN 'Alabama'
      WHEN State = 'AK' THEN 'Alaska'
      WHEN State = 'AZ' THEN 'Arizona'
      WHEN State = 'AR' THEN 'Arkansas'
      WHEN State = 'CA' THEN 'California'
      WHEN State = 'CO' THEN 'Colorado'
      WHEN State = 'CT' THEN 'Connecticut'
      WHEN State = 'DE' THEN 'Delaware'
      WHEN State = 'FL' THEN 'Florida'
      WHEN State = 'GA' THEN 'Georgia'
      WHEN State = 'HI' THEN 'Hawaii'
      WHEN State = 'ID' THEN 'Idaho'
      WHEN State = 'IL' THEN 'Illinois'
      WHEN State = 'IN' THEN 'Indiana'
      WHEN State = 'IA' THEN 'Iowa'
      WHEN State = 'KS' THEN 'Kansas'
      WHEN State = 'KY' THEN 'Kentucky'
      WHEN State = 'LA' THEN 'Louisiana'
      WHEN State = 'ME' THEN 'Maine'
      WHEN State = 'MD' THEN 'Maryland'
      WHEN State = 'MA' THEN 'Massachusetts'
      WHEN State = 'MI' THEN 'Michigan'
      WHEN State = 'MN' THEN 'Minnesota'
      WHEN State = 'MS' THEN 'Mississippi'
      WHEN State = 'MO' THEN 'Missouri'
      WHEN State = 'MT' THEN 'Montana'
      WHEN State = 'NE' THEN 'Nebraska'
      WHEN State = 'NV' THEN 'Nevada'
      WHEN State = 'NH' THEN 'New Hampshire'
      WHEN State = 'NJ' THEN 'New Jersey'
      WHEN State = 'NM' THEN 'New Mexico'
      WHEN State = 'NY' THEN 'New York'
      WHEN State = 'NC' THEN 'North Carolina'
      WHEN State = 'ND' THEN 'North Dakota'
      WHEN State = 'OH' THEN 'Ohio'
      WHEN State = 'OK' THEN 'Oklahoma'
      WHEN State = 'OR' THEN 'Oregon'
      WHEN State = 'PA' THEN 'Pennsylvania'
      WHEN State = 'RI' THEN 'Rhode Island'
      WHEN State = 'SC' THEN 'South Carolina'
      WHEN State = 'SD' THEN 'South Dakota'
      WHEN State = 'TN' THEN 'Tennessee'
      WHEN State = 'TX' THEN 'Texas'
      WHEN State = 'UT' THEN 'Utah'
      WHEN State = 'VT' THEN 'Vermont'
      WHEN State = 'VA' THEN 'Virginia'
      WHEN State = 'WA' THEN 'Washington'
      WHEN State = 'WV' THEN 'West Virginia'
      WHEN State = 'WI' THEN 'Wisconsin'
      WHEN State = 'WY' THEN 'Wyoming'
	  WHEN State = 'MP' THEN 'Northern Mariana Islands'
	  WHEN State = 'VI' THEN 'Virgin Islands'
      ELSE State
   END

Update [h1bdata].[dbo].[H1Bdata2021]
SET State = 
CASE
     WHEN State = 'DC' THEN 'Washington D.C.'
	 ELSE State
END

--Deleting Null values of the states
DELETE FROM [h1bdata].[dbo].[H1Bdata2021] 
WHERE State IS NULL;

--Changing the ZIP code from a float type to VARCHAR data type

ALTER TABLE [h1bdata].[dbo].[H1Bdata2021]
ADD ZIPCODE VARCHAR(5)

UPDATE [h1bdata].[dbo].[H1Bdata2021]
SET ZIPCODE = RIGHT('00000' + CAST(ZIP AS VARCHAR(5)), 5)

-- Deleting the Old Column ZIP
ALTER TABLE [h1bdata].[dbo].[H1Bdata2021]
DROP COLUMN ZIP;

--Making all the 3 and 4 digit zipcodes a 5 digit by adding the missing zeros.
UPDATE [h1bdata].[dbo].[H1Bdata2021]
SET ZIPCODE = CONCAT('00', ZIPCODE)
WHERE LEN(ZIPCODE) = 3

UPDATE [h1bdata].[dbo].[H1Bdata2021]
SET ZIPCODE = CONCAT('0', ZIPCODE)
WHERE LEN(ZIPCODE) = 4


------------------------------------------------------------------------------------------------------

-- Adding Total Approval and Total Denial Column

ALTER TABLE [h1bdata].[dbo].[H1Bdata2021]
ADD TotalApproval INT,
    TotalDenial INT

UPDATE [h1bdata].[dbo].[H1Bdata2021]
SET TotalApproval = ISNULL([Initial Approval], 0) + ISNULL([Continuing Approval], 0),
    TotalDenial = ISNULL([Initial Denial], 0) + ISNULL([Continuing Denial], 0)

------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------
--DATA EXPLORING
Select * FROM [h1bdata].[dbo].[H1Bdata2021]

--Number of total Employers with approvals
SELECT Employer,COUNT(Employer) AS NumberOFApproval FROM [h1bdata].[dbo].[H1Bdata2021] 
WHERE [Initial Approval] > 0 OR [Continuing Approval] > 0
GROUP BY Employer

------------------------------------------------------------------------------------------------------

--Differentiating WA and DC
SELECT State,COUNT(Employer) AS NumberOFEmployers FROM [h1bdata].[dbo].[H1Bdata2021]
Where State = 'Washington D.C.' OR State = 'Washington'  
Group BY State

------------------------------------------------------------------------------------------------------

--List of Employers with more than 10 Approvals in the first try in the year of 2021
SELECT [Fiscal Year],Employer,COUNT([Initial Approval]) AS ApprovalCount
FROM [h1bdata].[dbo].[H1Bdata2021]
GROUP BY Employer,[Fiscal Year]
HAVING COUNT([Initial Approval]) > 10
ORDER BY ApprovalCount DESC
-------------------------------------------------------------------------------------------------------

--List of employers with more than 10 Continuing denials for the first try in the year 2021
SELECT [Fiscal Year],Employer,COUNT([Continuing Denial]) AS DenialCount
FROM [h1bdata].[dbo].[H1Bdata2021]
GROUP BY Employer,[Fiscal Year]
HAVING COUNT([Continuing Denial]) > 10
ORDER BY DenialCount DESC

----List of employers with more than 10 Initial denials for the first try in the year 2021
SELECT [Fiscal Year],Employer,COUNT([Initial Denial]) AS DenialCount
FROM [h1bdata].[dbo].[H1Bdata2021]
GROUP BY Employer,[Fiscal Year]
HAVING COUNT([Initial Denial]) > 10
ORDER BY DenialCount DESC

--Top 10 US State with highest intial approvals.
SELECT TOP 10 State, Count([Initial Approval]) AS TotalInitialApprovals
FROM [h1bdata].[dbo].[H1Bdata2021]
GROUP BY State
ORDER BY TotalInitialApprovals DESC;

--Top 10 US cities with highest intial approvals.
SELECT TOP 10 City, Count([Initial Approval]) AS TotalInitialApprovals
FROM [h1bdata].[dbo].[H1Bdata2021]
GROUP BY City
ORDER BY TotalInitialApprovals DESC;

--Last 10 US States with Least intial approvals.
SELECT TOP 10 State, Count([Initial Approval]) AS TotalInitialApprovals
FROM [h1bdata].[dbo].[H1Bdata2021]
GROUP BY State
ORDER BY TotalInitialApprovals ASC;

--Last 10 US City with Least intial approvals.
SELECT TOP 100 City, Count([Initial Approval]) AS TotalInitialApprovals
FROM [h1bdata].[dbo].[H1Bdata2021]
GROUP BY City
ORDER BY TotalInitialApprovals ASC

--Total number of cities with only 1 intial approvals
SELECT City, COUNT(*) AS ApprovalCount
FROM [h1bdata].[dbo].[H1Bdata2021]
WHERE [Initial Approval] = 1
GROUP BY City
HAVING COUNT(*) = 1;







