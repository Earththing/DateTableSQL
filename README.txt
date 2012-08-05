How do you create a table in SQL in your database that contains the many details about a particular date? 

I have encountered tables like this at various places I have worked and found then to be convenient ways to do many date operations that otherwise would require some intricate manipulation of SQL date functions. These tables have several uses such as making date manipulation available to people who may not be experts in SQL, and allowing for some date details that may vary from one company to another like determining the fiscal year and standardizing on the ways dates are formatted.

I thought creating such a table would be an interesting exercise. Using what was available to me at the time, MS SQL, I have created a few date related tables, a view to display them, and an example of a T-SQL query that was made easier with the creation of the date table.

To ease the re-running of the query so that tweaks and changes can be made I look for the existence of the tables and indexes I create and drop them if there are there, thus avoiding "already exists" error messages as I make modifications and re-run the query.