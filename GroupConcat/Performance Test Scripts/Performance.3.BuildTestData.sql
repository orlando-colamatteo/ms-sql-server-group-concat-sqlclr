-- http://www.sqlservercentral.com/Forums/Topic1089519-338-1.aspx
SET STATISTICS TIME OFF ;
GO
SET NOCOUNT ON ;
GO

USE GroupConcatTest
GO

IF OBJECT_ID(N'dbo.TestData') > 0 
    DROP TABLE dbo.TestData ;
GO

CREATE TABLE dbo.TestData
(
 DocID INT NOT NULL,
 FieldType NVARCHAR(20) NOT NULL,
 ErrorDetail NVARCHAR(400) NULL
) ;
GO

CREATE CLUSTERED INDEX [dbo.OPC3Test_DocID__INC_FieldType] 
ON dbo.TestData (DocID,FieldType)
GO

INSERT  INTO dbo.TestData
        (
         DocID,
         FieldType,
         ErrorDetail
        )
        SELECT  1,
                'Sale Date',
                'Invalid Sale & Date'
        UNION ALL
        SELECT  1,
                'DocumentNumber',
                'DocumentNumber not a number'
        UNION ALL
        SELECT  1,
                'Sale Date',
                'Sale Date Before Open Date'
        UNION ALL
        SELECT  2,
                'First Name',
                'Empty First Name'
        UNION ALL
        SELECT  3,
                'Last Name',
                'Last Name cannot be NULL'
        UNION ALL
        SELECT  3,
                'DocumentNumber',
                'DocumentNumber not a number'
        UNION ALL
        SELECT  8,
                'City',
                'City not found in <State>'
        UNION ALL
        SELECT  999,
                'IsAllocated',
                NULL
        UNION ALL
        SELECT  3330,
                'IsUtilized',
                NULL
        UNION ALL
        SELECT  3330,
                'World',
                'Hello!'
GO 30000 -- << SSMS feature to repeat batches multiple times

DECLARE @ct INT ;
SELECT  @ct = COUNT(*)
FROM    dbo.TestData ;
RAISERROR('%d rows in dbo.TestData',10,1,@ct) ;
GO
