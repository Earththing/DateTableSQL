/******************************************
**        Creating a date table          **
**                                       **
**          by Aaron Johnson             **
** 08/01/2011 http://blog.earththing.com **
*******************************************/

-- USE databasename

/******************************************
** Drop Table and index if already there **
******************************************/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[dDateTable]') AND name = N'PK_Dates')
ALTER TABLE [dbo].[DateTable] DROP CONSTRAINT [PK_Dates]
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND ID = OBJECT_ID('[dbo].[dDateTable]'))
DROP TABLE [dbo].[dDateTable]
GO

/**********************
** Create date table **
**********************/

CREATE TABLE dbo.dDateTable ( -- Define table
	DateID			int NOT NULL IDENTITY(1, 1),
	[Date]			date NOT NULL,
	[Year]			smallint NOT NULL, 
	[MonthofYear]	tinyint NOT NULL,
	[DayofWeek]		tinyint NOT NULL,
	[DayofMonth]	tinyint NOT NULL,
	[DayofYear]		smallint NOT NULL,
	[Quarter]		tinyint NOT NULL,
	[WeekofYear]	tinyint NOT NULL,
--	[WeekofMonth]	tinyint NOT NULL, -- Still need to define (probably first partial week of month) 
 CONSTRAINT PK_Dates PRIMARY KEY CLUSTERED (DateID)
)
GO

/*******************
** Populate table **
*******************/

-- declare variables to hold the start and end date
DECLARE @StartDate date
DECLARE @EndDate date

-- assign values to the start date and end date we 
-- want our reports to cover (this should also take
-- into account any future reporting needs)
SET @StartDate = '01/01/1753'
SET @EndDate = '12/31/2020' 

-- using a while loop increment from the start date 
-- to the end date
DECLARE @LoopDate datetime
SET @LoopDate = @StartDate

WHILE @LoopDate <= @EndDate
BEGIN
 -- add a record into the date dimension table for this date
	INSERT INTO dDateTable VALUES(
		@LoopDate,
		Year(@LoopDate),
		Month(@LoopDate),
		datepart(weekday,@LoopDate),
		Day(@LoopDate),
		datepart(dayOfYear,@LoopDate),
		datepart(quarter,@LoopDate),
		datepart(week,@LoopDate)
		--'Week of Month'
	)
	
 -- increment the LoopDate by 1 day before
 -- we start the loop again
 SET @LoopDate = DateAdd(d, 1, @LoopDate)
END
GO

-- now we have inserted the data we can check how it appears in our table
SELECT TOP 100 * FROM dDateTable
GO

/***************************************************************************
Supporting Tables
****************************************************************************/

-- Drop Tables if they already exist
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND ID = OBJECT_ID('[dbo].[dWeekTable]'))
DROP TABLE [dbo].[dWeekTable]
GO
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND ID = OBJECT_ID('[dbo].[dMonthTable]'))
DROP TABLE [dbo].[dMonthTable]
GO

CREATE TABLE dbo.dWeekTable ( -- Define table
	[DayofWeek]	tinyint NOT NULL,
	[Day_Name]	varchar(10) NOT NULL
)
GO
INSERT INTO [dWeekTable] VALUES 
	 (1, 'Sunday')
	,(2, 'Monday')
	,(3, 'Tuesday')
	,(4, 'Wednesday')
	,(5, 'Thursday')
	,(6, 'Friday')
	,(7, 'Saturday')
--	,(8, '1234567890')
;
GO

CREATE TABLE dbo.dMonthTable ( -- Define table
      [MonthofYear]           tinyint NOT NULL,
      [Month_Name]            varchar(10) NOT NULL,
      [Month_Abrv]            varchar(3) NOT NULL
)
GO
INSERT INTO [dMonthTable] VALUES
       ( 1, 'January'     ,'Jan')
      ,( 2, 'Febuary'   ,'Feb')
      ,( 3, 'March'       ,'Mar')
      ,( 4, 'April'       ,'Apr')
      ,( 5, 'May'         ,'May')
      ,( 6, 'June'        ,'Jun')
      ,( 7, 'July'        ,'Jul')
      ,( 8, 'August'      ,'Aug')
      ,( 9, 'September' ,'Sep')
      ,(10, 'October'     ,'Oct')
      ,(11, 'November'  ,'Nov')
      ,(12, 'December'  ,'Dec')
--    ,(13, '1234567890')
;
GO
 
/***************************************************************************
Create View
****************************************************************************/
-- If view is already there then drop it
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vCalendar]'))
DROP VIEW [dbo].[vCalendar]
GO
 
-- Create view
CREATE VIEW [dbo].[vCalendar]
AS
SELECT d.[DateID]
      ,d.[Date]
      ,d.[Year]
      ,d.[MonthofYear]
      ,m.[Month_Name]
      ,m.[Month_Abrv]
      ,d.[DayofWeek]
      ,w.[Day_Name]
      ,d.[DayofMonth]
      ,d.[DayofYear]
      ,d.[Quarter]
      ,d.[WeekofYear]
  FROM [dbo].[dDateTable] d
  JOIN dbo.dMonthTable m on d.[MonthofYear] = m.[MonthofYear]
  JOIN dbo.dWeekTable w on d.[DayofWeek] = w.[DayofWeek]
GO
 
-- Check to see how the view looks
Select top 100 * from [dbo].[vCalendar]