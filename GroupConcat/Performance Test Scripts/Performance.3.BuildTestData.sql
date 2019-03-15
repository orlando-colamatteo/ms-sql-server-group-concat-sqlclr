/*
GROUP_CONCAT string aggregate for SQL Server - https://github.com/orlando-colamatteo/ms-sql-server-group-concat-sqlclr
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

-- http://www.sqlservercentral.com/Forums/Topic1089519-338-1.aspx
SET STATISTICS TIME OFF ;
GO
SET NOCOUNT ON ;
GO

USE GroupConcatTest
GO

--      Create and populate the test tables.  This is NOT a part of the solution.
DECLARE @RowsInTable INT ;
SET @RowsInTable = 500000 ;

-- Conditionally drop the test tables to make reruns in SSMS easier
IF OBJECT_ID('dbo.TestData', 'U') IS NOT NULL 
    DROP TABLE dbo.TestData ;
--Used to build a lot of test data
IF OBJECT_ID('tempdb..#FieldType', 'U') IS NOT NULL 
    DROP TABLE #FieldType ;
IF OBJECT_ID('tempdb..#ErrorDetail', 'U') IS NOT NULL 
    DROP TABLE #ErrorDetail ;

--===== Create a list of HobbyNames so we can randomly populate the test tables.
SELECT  FieldTypeID = IDENTITY( INT,1,1),
        FieldType = CAST(d.FieldType AS VARCHAR(25))
INTO    #FieldType
FROM    (
         SELECT 'Sale Date'
         UNION ALL
         SELECT 'Document Number'
         UNION ALL
         SELECT 'First Name'
         UNION ALL
         SELECT 'Last Name'
         UNION ALL
         SELECT 'Address'
         UNION ALL
         SELECT 'City'
         UNION ALL
         SELECT 'State'
         UNION ALL
         SELECT 'Postal Code'
         UNION ALL
         SELECT 'IsAllocated'
         UNION ALL
         SELECT 'IsUtilized'
UNION ALL
         SELECT 'Sale Date 2'
         UNION ALL
         SELECT 'Document Number 2'
         UNION ALL
         SELECT 'First Name 2'
         UNION ALL
         SELECT 'Last Name 2'
         UNION ALL
         SELECT 'Address 2'
         UNION ALL
         SELECT 'City 2'
         UNION ALL
         SELECT 'State 2'
         UNION ALL
         SELECT 'Postal Code 2'
         UNION ALL
         SELECT 'IsAllocated 2'
         UNION ALL
         SELECT 'IsUtilized 2'
        ) d (FieldType) ;

ALTER TABLE #FieldType ADD PRIMARY KEY CLUSTERED (FieldTypeID) WITH FILLFACTOR = 100 ;

--===== Create a list of HobbyNames so we can randomly populate the test tables.
SELECT  ErrorDetailID = IDENTITY( INT,1,1),
        ErrorDetail = CAST(d.ErrorDetail AS VARCHAR(25))
INTO    #ErrorDetail
FROM    (
         SELECT 'Invalid data.'
         UNION ALL
         SELECT 'Invalid number.'
         UNION ALL
         SELECT 'Invalid string.'
         UNION ALL
         SELECT 'Incomplete data.'
         UNION ALL
         SELECT 'Missing identifier.'
         UNION ALL
         SELECT 'Missing data.'
         UNION ALL
         SELECT 'Missing number.'
         UNION ALL
         SELECT 'Undefined.'
         UNION ALL
         SELECT 'Unknown error occurred.'
         UNION ALL
         SELECT 'Value out of range.'
         UNION ALL
         SELECT 'Invalid data.'
         UNION ALL
         SELECT 'Invalid number.'
         UNION ALL
         SELECT 'Invalid string.'
         UNION ALL
         SELECT 'Incomplete data.'
         UNION ALL
         SELECT 'Missing identifier.'
         UNION ALL
         SELECT 'Missing data.'
         UNION ALL
         SELECT 'Missing number.'
         UNION ALL
         SELECT 'Undefined.'
         UNION ALL
         SELECT 'Unknown error occurred.'
         UNION ALL
         SELECT 'Value out of range.'
        ) d (ErrorDetail) ;
ALTER TABLE #ErrorDetail ADD PRIMARY KEY CLUSTERED (ErrorDetailID) WITH FILLFACTOR = 100 ;

--===== Create the "first" table and populate it on the fly
SELECT DISTINCT
        *
INTO    dbo.TestData
FROM    (
         SELECT TOP (@RowsInTable)
                DocID = ABS(CHECKSUM(NEWID())) % 999 + 1,
                FieldType = (
                             SELECT TOP 1
                                    FieldType
                             FROM   #FieldType
                             WHERE  FieldTypeID = ABS(CHECKSUM(NEWID())) % 20 + 1
                            ),
                ErrorDetail = (
                               SELECT TOP 1
                                        ErrorDetail
                               FROM     #ErrorDetail
                               WHERE    ErrorDetailID = ABS(CHECKSUM(NEWID())) % 20 + 1
                              )
         FROM   sys.all_columns ac1,
                sys.all_columns ac2
        ) x ;
        
--===== Add PK
ALTER TABLE dbo.TestData ALTER COLUMN DocID INT NOT NULL ;
ALTER TABLE dbo.TestData ALTER COLUMN FieldType VARCHAR(25) NOT NULL ;
ALTER TABLE dbo.TestData ALTER COLUMN ErrorDetail VARCHAR(25) NOT NULL ;
GO
ALTER TABLE dbo.TestData ADD PRIMARY KEY CLUSTERED (DocID,FieldType,ErrorDetail) WITH FILLFACTOR = 100 ;
GO

SELECT TOP 100
        *
FROM    dbo.TestData
ORDER BY DocID,
        FieldType
GO
        
DECLARE @ct INT ;
SELECT  @ct = COUNT(*)
FROM    dbo.TestData ;
RAISERROR('%d rows in dbo.TestData',10,1,@ct) ;
GO
