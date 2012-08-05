-- *** Triple Paycheck Months ***
-- Assume that Aug 12th 2011 is the start payday. (Which happens to be dateID = 94456)
 
-- Drop if already there. NOTE: this is not needed when using temp tables in a stored procedure
IF  EXISTS (SELECT Table_Catalog, Table_Name FROM TEMPDB.information_schema.tables WHERE table_name like '%#2WKs%')
drop table #2WKs
GO
--
CREATE TABLE #2WKs (COL1 INT)
GO
DECLARE @loop int
SET @Loop = 94456 -- Startdate Aug 12th 2011
WHILE @Loop <= 96100 -- Some future date
BEGIN
insert into #2WKs values (@Loop)
SET @Loop = (@Loop+14)
END
select Month_Name,Year
      from [data].dbo.vCalendar
      where DateID in (select * from #2WKs)
      group by Month_Name, Year
      having COUNT(*) > 2

--Possible adjustment to query: Use a table variable instead of a Temp table.