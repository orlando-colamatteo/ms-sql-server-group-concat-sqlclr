/*
Excercise GROUP_CONCAT functions along with XML methods that they can be used to replace. Tested in SSMS 2008R2.
*/
SET NOCOUNT ON ;
GO

-- !! MODIFY TO SUIT YOUR TEST ENVIRONMENT !!
USE GroupConcatTest
GO

-------------------------------------------------------------------------------------------------------------------------------

PRINT '-------------------------------------------------------------------------------------------'
PRINT '---------- DISTINCT, unsorted: XML PATH ---------------------------------------------------'
SELECT  DocID,
        STUFF((SELECT   DISTINCT
                        N',' + ErrorDetail
               FROM     dbo.GroupConcatTestData s2
               WHERE    s2.DocID = s1.DocID
              FOR
               XML PATH('')
              ), 1, 1, '') AS [Skills]
FROM    dbo.GroupConcatTestData s1
GROUP BY s1.DocID
ORDER BY s1.DocID ;

PRINT '---------- DISTINCT, unsorted: XML PATH,TYPE ----------------------------------------------'
SELECT  DocID,
        STUFF(
        (SELECT N',' + n
         FROM   (SELECT   DISTINCT
                        ErrorDetail AS n
                 FROM   dbo.GroupConcatTestData s2
                 WHERE  s2.DocID = s1.DocID
                ) r
        FOR   XML PATH(''),
                  TYPE
         ).value('.[1]', 'nvarchar(max)'), 1, 1, '') AS [Skills]
FROM    dbo.GroupConcatTestData s1
GROUP BY s1.DocID
ORDER BY s1.DocID ;

PRINT '---------- DISTINCT, unsorted: CLR GROUP_CONCAT -------------------------------------------'
SELECT  DocID,
        dbo.GROUP_CONCAT(DISTINCT ErrorDetail) AS FieldTypeDetail
FROM    dbo.GroupConcatTestData
GROUP BY DocID
ORDER BY DocID ;

PRINT '---------- DISTINCT, unsorted: CLR GROUP_CONCAT_D -----------------------------------------'
SELECT  DocID,
        dbo.GROUP_CONCAT_D(DISTINCT ErrorDetail, N',') AS FieldTypeDetail
FROM    dbo.GroupConcatTestData
GROUP BY DocID
ORDER BY DocID ;

PRINT '---------- DISTINCT, unsorted: CLR GROUP_CONCAT_D (multi-byte delimiter) ------------------'
SELECT  DocID,
        dbo.GROUP_CONCAT_D(DISTINCT ErrorDetail, N'~~~~') AS FieldTypeDetail
FROM    dbo.GroupConcatTestData
GROUP BY DocID
ORDER BY DocID ;

PRINT '-------------------------------------------------------------------------------------------'
PRINT '---------- DISTINCT, sorted ASC: XML PATH -------------------------------------------------'
SELECT  DocID,
        STUFF((SELECT   DISTINCT
                        N',' + ErrorDetail
               FROM     dbo.GroupConcatTestData s2
               WHERE    s2.DocID = s1.DocID
               ORDER BY N',' + ErrorDetail ASC
              FOR
               XML PATH('')
              ), 1, 1, '') AS [Skills]
FROM    dbo.GroupConcatTestData s1
GROUP BY s1.DocID
ORDER BY s1.DocID ;

PRINT '---------- DISTINCT, sorted ASC: XML PATH,TYPE --------------------------------------------'
SELECT  DocID,
        STUFF(
        (SELECT N',' + n
         FROM   (SELECT   DISTINCT
                        ErrorDetail AS n
                 FROM   dbo.GroupConcatTestData s2
                 WHERE  s2.DocID = s1.DocID
                ) r
         ORDER BY n ASC
        FOR   XML PATH(''),
                  TYPE
         ).value('.[1]', 'nvarchar(max)'), 1, 1, '') AS [Skills]
FROM    dbo.GroupConcatTestData s1
GROUP BY s1.DocID
ORDER BY s1.DocID ;

PRINT '---------- DISTINCT, sorted ASC: CLR GROUP_CONCAT_S ---------------------------------------'
SELECT  DocID,
        dbo.GROUP_CONCAT_S(DISTINCT ErrorDetail, 1) AS FieldTypeDetail
FROM    dbo.GroupConcatTestData
GROUP BY DocID
ORDER BY DocID ;

PRINT '---------- DISTINCT, sorted ASC: CLR GROUP_CONCAT_DS --------------------------------------'
SELECT  DocID,
        dbo.GROUP_CONCAT_DS(DISTINCT ErrorDetail, N',', 1) AS FieldTypeDetail
FROM    dbo.GroupConcatTestData
GROUP BY DocID
ORDER BY DocID ;

PRINT '---------- DISTINCT, sorted ASC: CLR GROUP_CONCAT_DS (multi-byte delimiter) ---------------'
SELECT  DocID,
        dbo.GROUP_CONCAT_DS(DISTINCT ErrorDetail, N'~~~~', 1) AS FieldTypeDetail
FROM    dbo.GroupConcatTestData
GROUP BY DocID
ORDER BY DocID ;

PRINT '-------------------------------------------------------------------------------------------'
PRINT '---------- DISTINCT, sorted DESC: XML PATH ------------------------------------------------'
SELECT  DocID,
        STUFF((SELECT   DISTINCT
                        N',' + ErrorDetail
               FROM     dbo.GroupConcatTestData s2
               WHERE    s2.DocID = s1.DocID
               ORDER BY N',' + ErrorDetail DESC
              FOR
               XML PATH('')
              ), 1, 1, '') AS [Skills]
FROM    dbo.GroupConcatTestData s1
GROUP BY s1.DocID
ORDER BY s1.DocID ;

PRINT '---------- DISTINCT, sorted DESC: XML PATH,TYPE -------------------------------------------'
SELECT  DocID,
        STUFF(
        (SELECT N',' + n
         FROM   (SELECT   DISTINCT
                        ErrorDetail AS n
                 FROM   dbo.GroupConcatTestData s2
                 WHERE  s2.DocID = s1.DocID
                ) r
         ORDER BY n DESC
        FOR   XML PATH(''),
                  TYPE
         ).value('.[1]', 'nvarchar(max)'), 1, 1, '') AS [Skills]
FROM    dbo.GroupConcatTestData s1
GROUP BY s1.DocID
ORDER BY s1.DocID ;

PRINT '---------- DISTINCT, sorted DESC: CLR GROUP_CONCAT_S --------------------------------------'
SELECT  DocID,
        dbo.GROUP_CONCAT_S(DISTINCT ErrorDetail, 2) AS FieldTypeDetail
FROM    dbo.GroupConcatTestData
GROUP BY DocID
ORDER BY DocID ;

PRINT '---------- DISTINCT, sorted DESC: CLR GROUP_CONCAT_DS -------------------------------------'
SELECT  DocID,
        dbo.GROUP_CONCAT_DS(DISTINCT ErrorDetail, N',', 2) AS FieldTypeDetail
FROM    dbo.GroupConcatTestData
GROUP BY DocID
ORDER BY DocID ;

PRINT '-------------------------------------------------------------------------------------------'
PRINT '---------- NON-DISTINCT, unsorted: XML PATH -----------------------------------------------'
SELECT  DocID,
        STUFF((SELECT   N',' + ErrorDetail
               FROM     dbo.GroupConcatTestData s2
               WHERE    s2.DocID = s1.DocID
              FOR
               XML PATH('')
              ), 1, 1, '') AS [Skills]
FROM    dbo.GroupConcatTestData s1
GROUP BY s1.DocID
ORDER BY s1.DocID ;

PRINT '---------- NON-DISTINCT, unsorted: XML PATH,TYPE ------------------------------------------'
SELECT  DocID,
        STUFF(
        (SELECT N',' + n
         FROM   (SELECT ErrorDetail AS n
                 FROM   dbo.GroupConcatTestData s2
                 WHERE  s2.DocID = s1.DocID
                ) r
        FOR   XML PATH(''),
                  TYPE
         ).value('.[1]', 'nvarchar(max)'), 1, 1, '') AS [Skills]
FROM    dbo.GroupConcatTestData s1
GROUP BY s1.DocID
ORDER BY s1.DocID ;

PRINT '---------- NON-DISTINCT, unsorted: CLR GROUP_CONCAT ---------------------------------------'
SELECT  DocID,
        dbo.GROUP_CONCAT(ErrorDetail) AS FieldTypeDetail
FROM    dbo.GroupConcatTestData
GROUP BY DocID
ORDER BY DocID ;

PRINT '---------- NON-DISTINCT, unsorted: CLR GROUP_CONCAT_D -------------------------------------'
SELECT  DocID,
        dbo.GROUP_CONCAT_D(ErrorDetail, N',') AS FieldTypeDetail
FROM    dbo.GroupConcatTestData
GROUP BY DocID
ORDER BY DocID ;

PRINT '-------------------------------------------------------------------------------------------'
PRINT '---------- NON-DISTINCT, sorted ASC: XML PATH ---------------------------------------------'
SELECT  DocID,
        STUFF((SELECT   N',' + ErrorDetail
               FROM     dbo.GroupConcatTestData s2
               WHERE    s2.DocID = s1.DocID
               ORDER BY ErrorDetail ASC
              FOR
               XML PATH('')
              ), 1, 1, '') AS [Skills]
FROM    dbo.GroupConcatTestData s1
GROUP BY s1.DocID
ORDER BY s1.DocID ;

PRINT '---------- NON-DISTINCT, sorted ASC: XML PATH,TYPE ----------------------------------------'
SELECT  DocID,
        STUFF(
        (SELECT N',' + n
         FROM   (SELECT ErrorDetail AS n
                 FROM   dbo.GroupConcatTestData s2
                 WHERE  s2.DocID = s1.DocID
                ) r
         ORDER BY n ASC
        FOR   XML PATH(''),
                  TYPE
         ).value('.[1]', 'nvarchar(max)'), 1, 1, '') AS [Skills]
FROM    dbo.GroupConcatTestData s1
GROUP BY s1.DocID
ORDER BY s1.DocID ;

PRINT '---------- NON-DISTINCT, sorted ASC: CLR GROUP_CONCAT_S -----------------------------------'
SELECT  DocID,
        dbo.GROUP_CONCAT_S(ErrorDetail, 1) AS FieldTypeDetail
FROM    dbo.GroupConcatTestData
GROUP BY DocID
ORDER BY DocID ;

PRINT '---------- NON-DISTINCT, sorted ASC: CLR GROUP_CONCAT_DS ----------------------------------'
SELECT  DocID,
        dbo.GROUP_CONCAT_DS(ErrorDetail, N',', 1) AS FieldTypeDetail
FROM    dbo.GroupConcatTestData
GROUP BY DocID
ORDER BY DocID ;

PRINT '-------------------------------------------------------------------------------------------'
PRINT '---------- NON-DISTINCT, sorted DESC: XML PATH --------------------------------------------'
SELECT  DocID,
        STUFF((SELECT   N',' + ErrorDetail
               FROM     dbo.GroupConcatTestData s2
               WHERE    s2.DocID = s1.DocID
               ORDER BY ErrorDetail DESC
              FOR
               XML PATH('')
              ), 1, 1, '') AS [Skills]
FROM    dbo.GroupConcatTestData s1
GROUP BY s1.DocID
ORDER BY s1.DocID ;

PRINT '---------- NON-DISTINCT, sorted DESC: XML PATH,TYPE ---------------------------------------'
SELECT  DocID,
        STUFF(
        (SELECT N',' + n
         FROM   (SELECT ErrorDetail AS n
                 FROM   dbo.GroupConcatTestData s2
                 WHERE  s2.DocID = s1.DocID
                ) r
         ORDER BY n DESC
        FOR   XML PATH(''),
                  TYPE
         ).value('.[1]', 'nvarchar(max)'), 1, 1, '') AS [Skills]
FROM    dbo.GroupConcatTestData s1
GROUP BY s1.DocID
ORDER BY s1.DocID ;

PRINT '---------- NON-DISTINCT, sorted DESC: CLR GROUP_CONCAT_S ----------------------------------'
SELECT  DocID,
        dbo.GROUP_CONCAT_S(ErrorDetail, 2) AS FieldTypeDetail
FROM    dbo.GroupConcatTestData
GROUP BY DocID
ORDER BY DocID ;

PRINT '---------- NON-DISTINCT, sorted DESC: CLR GROUP_CONCAT_DS ---------------------------------'
SELECT  DocID,
        dbo.GROUP_CONCAT_DS(ErrorDetail, N',', 2) AS FieldTypeDetail
FROM    dbo.GroupConcatTestData
GROUP BY DocID
ORDER BY DocID ;
GO
