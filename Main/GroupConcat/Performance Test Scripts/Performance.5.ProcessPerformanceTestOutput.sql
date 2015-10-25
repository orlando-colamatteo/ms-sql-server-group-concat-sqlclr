/*
GROUP_CONCAT string aggregate for SQL Server - https://groupconcat.codeplex.com
Copyright (C) 2011  Orlando Colamatteo

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or 
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

See http://www.gnu.org/licenses/ for a copy of the GNU General Public 
License.
*/

USE GroupConcatTest
GO

IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'dbo.clr_xml_test_results')
                    AND type IN (N'U') ) 
    DROP TABLE dbo.clr_xml_test_results ;
GO

CREATE TABLE dbo.clr_xml_test_results
(
 id INT PRIMARY KEY,
 method VARCHAR(100),
 dataset_row_count INT,
 uniqueness VARCHAR(100),
 sort_order VARCHAR(100),
 cpu_time_ms SMALLINT,
 elapsed_time_ms SMALLINT,
 created DATETIME NOT NULL
                  DEFAULT (GETDATE())
) ;
GO

-- parse text output from script 4 and insert into table
--INSERT INTO dbo.clr_xml_test_results
--        (
--         id,
--         method,
--         dataset_row_count,
--         uniqueness,
--         sort_order,
--         cpu_time_ms,
--         elapsed_time_ms,
--         created
--        )



----------------------------------------------------------------------------------------------------------------------------------
-- POC code from SSC

--========================================================================================
--      Build the test data.  Only the extra column we added is a part of the solution.
--========================================================================================
--===== Conditionally drop the test table to make reruns easier.
IF OBJECT_ID('tempdb..#Elements', 'U') IS NOT NULL 
    DROP TABLE #Elements ;
--===== Declare how many rows we want in the test table.
DECLARE @RowsToTest INT ;
SELECT  @RowsToTest = 1000000 ;

--===== Now, build the test table and populate it on the fly.
     -- Not to worry... this takes less than 5 seconds.
WITH    cteGenRows
          AS ( SELECT TOP ( @RowsToTest )
                        Number = CAST(ROW_NUMBER() OVER ( ORDER BY ( SELECT NULL
                                                                   ) ) AS INT) ,
                        [Value] = CAST(ABS(CHECKSUM(NEWID())) % 1000 AS VARCHAR(3)) + ',' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS VARCHAR(3))
               FROM     sys.all_columns ac1
                        CROSS JOIN sys.all_columns ac2
             )
    SELECT  Number = ISNULL(Number, 0) ,  --The ISNULL makes this column NOT NULL
            [Value] = CASE WHEN ( Number - 1 ) % ( @RowsToTest / 25 ) <> 0 THEN [Value]
                           ELSE 'Category ' + CHAR(( Number - 1 ) / ( @RowsToTest / 25 ) + 65)
                      END 
            --          ,
            --Category = CAST(NULL AS VARCHAR(100)) , --This creates an empty column
            --SomeMeasurement = CAST(NULL AS INT) ,          --This creates an empty column
            --SomeOtherMeasurement = CAST(NULL AS INT)           --This creates an empty column
    INTO    #Elements
    FROM    cteGenRows ;
--===== Add the quintessential Clustered Index
     -- This adds about 4 seconds to the job.
ALTER TABLE #Elements
ADD PRIMARY KEY CLUSTERED (Number) WITH FILLFACTOR = 100
GO

IF OBJECT_ID('tempdb..#categories', 'U') IS NOT NULL 
    DROP TABLE #categories ;
GO
IF OBJECT_ID('tempdb..#Results', 'U') IS NOT NULL 
    DROP TABLE #Results ;
GO

SELECT  Number ,
        VALUE
INTO    #categories
FROM    #Elements
WHERE   VALUE LIKE 'Cat%' ;

CREATE UNIQUE CLUSTERED INDEX ix1 ON #categories(Number) ;

SELECT  cat.Category ,
        SUBSTRING(e.value, 1, CHARINDEX(',', e.Value, 1) - 1) AS Value1 ,
        SUBSTRING(e.Value, CHARINDEX(',', e.Value, 1) + 1, 100) AS Value2
INTO    #Results
FROM    #Elements AS e
        CROSS APPLY ( SELECT TOP 1
                                VALUE
                      FROM      #categories AS categories
                      WHERE     categories.Number < e.Number
                      ORDER BY  categories.Number DESC
                    ) AS cat ( Category )
WHERE   e.VALUE LIKE '[0-9]%' ;

SELECT  TOP 1000 *
FROM    #Results ;
