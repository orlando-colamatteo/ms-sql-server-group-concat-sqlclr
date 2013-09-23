/*
Build sample data for use with testing GROUP_CONCAT functions. Tested in SSMS 2008R2.
*/
SET NOCOUNT ON ;
GO

-- !! MODIFY TO SUIT YOUR TEST ENVIRONMENT !!
USE GroupConcatTest
GO

-------------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID(N'dbo.GroupConcatTestData') > 0 
    DROP TABLE dbo.GroupConcatTestData ;
GO

CREATE TABLE dbo.GroupConcatTestData
    (
      DocID INT NOT NULL ,
      FieldType NVARCHAR(20) NOT NULL ,
      ErrorDetail NVARCHAR(400) NULL
    ) ;
GO

INSERT  INTO dbo.GroupConcatTestData
        (
          DocID ,
          FieldType ,
          ErrorDetail
        )
        SELECT  1 ,
                'Sale Date' ,
                'Invalid Sale & Date'
        UNION ALL
        SELECT  1 ,
                'DocumentNumber' ,
                'DocumentNumber not a number'
        UNION ALL
        SELECT  1 ,
                'Sale Date' ,
                'Sale Date Before Open Date'
        UNION ALL
        SELECT  2 ,
                'First Name' ,
                'Empty First Name'
        UNION ALL
        SELECT  3 ,
                'Last Name' ,
                'Last Name cannot be NULL'
        UNION ALL
        SELECT  3 ,
                'DocumentNumber' ,
                'DocumentNumber not a number'
        UNION ALL
        SELECT  8 ,
                'City' ,
                'City not found in <State>'
        UNION ALL
        SELECT  999 ,
                'IsAllocated' ,
                NULL
        UNION ALL
        SELECT  3330 ,
                'IsUtilized' ,
                NULL
        UNION ALL
        SELECT  3330 ,
                'World' ,
                'Hello!'
GO 1000 -- << SSMS feature to repeat batches multiple times

CREATE CLUSTERED INDEX [dbo.GroupConcatTestData.DocID,FieldType] ON dbo.GroupConcatTestData (DocID,FieldType)
GO

DECLARE @ct INT ;
SELECT  @ct = COUNT(*)
FROM    dbo.GroupConcatTestData ;
RAISERROR('%d rows in dbo.GroupConcatTestData',10,1,@ct) ;
GO
