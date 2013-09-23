/*
Each test is to be run in its own batch. In testing performance of each method I noticed different results, sometimes
drastically different, when running many queries in the same batch versus each statement in a separate batch.

Performance results were compiled by running each statement 10 times and recording the CPU and Elapsed time mesurements
output by having STATISTICS IO ON. The average of those 10 measurements was then taken to decide which method was most 
efficient and performed fastest in each category.
*/
SET NOCOUNT ON ;
SET STATISTICS TIME OFF ;
GO

PRINT '---------- DISTINCT, unsorted: XML PATH ---------------------------------------------------'
GO
DECLARE @res TABLE (DocID INT, Skills NVARCHAR(MAX));
SET STATISTICS TIME ON ;
INSERT INTO @res ( DocID, Skills )
SELECT  DocID,
        STUFF((SELECT   DISTINCT
                        N',' + ErrorDetail
               FROM     GroupConcatTest.dbo.TestData s2
               WHERE    s2.DocID = s1.DocID
              FOR
               XML PATH('')
              ), 1, 1, '') AS [Skills]
FROM    GroupConcatTest.dbo.TestData s1
GROUP BY s1.DocID
ORDER BY s1.DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'
GO 5

PRINT '---------- DISTINCT, unsorted: XML PATH,TYPE ----------------------------------------------'
GO
DECLARE @res TABLE (DocID INT, Skills NVARCHAR(MAX));
SET STATISTICS TIME ON ;
INSERT INTO @res ( DocID, Skills )
SELECT  DocID,
        STUFF(
        (SELECT N',' + n
         FROM   (SELECT   DISTINCT
                        ErrorDetail AS n
                 FROM   GroupConcatTest.dbo.TestData s2
                 WHERE  s2.DocID = s1.DocID
                ) r
        FOR   XML PATH(''),
                  TYPE
         ).value('.[1]', 'nvarchar(max)'), 1, 1, '') AS [Skills]
FROM    GroupConcatTest.dbo.TestData s1
GROUP BY s1.DocID
ORDER BY s1.DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'
GO 5

PRINT '---------- DISTINCT, unsorted: CLR GROUP_CONCAT -------------------------------------------'
GO
DECLARE @res TABLE (DocID INT, Skills NVARCHAR(MAX));
SET STATISTICS TIME ON ;
INSERT INTO @res ( DocID, Skills )
SELECT  DocID,
        GroupConcatTest.dbo.GROUP_CONCAT(DISTINCT ErrorDetail) AS FieldTypeDetail
FROM    GroupConcatTest.dbo.TestData
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'
GO 5

PRINT '---------- DISTINCT, unsorted: CLR GROUP_CONCAT_D -----------------------------------------'
GO
DECLARE @res TABLE (DocID INT, Skills NVARCHAR(MAX));
SET STATISTICS TIME ON ;
INSERT INTO @res ( DocID, Skills )
SELECT  DocID,
        GroupConcatTest.dbo.GROUP_CONCAT_D(DISTINCT ErrorDetail, N',') AS FieldTypeDetail
FROM    GroupConcatTest.dbo.TestData
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'
GO 5

PRINT '---------- DISTINCT, sorted ASC: XML PATH -------------------------------------------------'
GO
DECLARE @res TABLE (DocID INT, Skills NVARCHAR(MAX));
SET STATISTICS TIME ON ;
INSERT INTO @res ( DocID, Skills )
SELECT  DocID,
        STUFF((SELECT   DISTINCT
                        N',' + ErrorDetail
               FROM     GroupConcatTest.dbo.TestData s2
               WHERE    s2.DocID = s1.DocID
               ORDER BY N',' + ErrorDetail ASC
              FOR
               XML PATH('')
              ), 1, 1, '') AS [Skills]
FROM    GroupConcatTest.dbo.TestData s1
GROUP BY s1.DocID
ORDER BY s1.DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'
GO 5

PRINT '---------- DISTINCT, sorted ASC: XML PATH,TYPE --------------------------------------------'
GO
DECLARE @res TABLE (DocID INT, Skills NVARCHAR(MAX));
SET STATISTICS TIME ON ;
INSERT INTO @res ( DocID, Skills )
SELECT  DocID,
        STUFF(
        (SELECT N',' + n
         FROM   (SELECT   DISTINCT
                        ErrorDetail AS n
                 FROM   GroupConcatTest.dbo.TestData s2
                 WHERE  s2.DocID = s1.DocID
                ) r
         ORDER BY n ASC
        FOR   XML PATH(''),
                  TYPE
         ).value('.[1]', 'nvarchar(max)'), 1, 1, '') AS [Skills]
FROM    GroupConcatTest.dbo.TestData s1
GROUP BY s1.DocID
ORDER BY s1.DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'
GO 5

PRINT '---------- DISTINCT, sorted ASC: CLR GROUP_CONCAT_S ---------------------------------------'
GO
DECLARE @res TABLE (DocID INT, Skills NVARCHAR(MAX));
SET STATISTICS TIME ON ;
INSERT INTO @res ( DocID, Skills )
SELECT  DocID,
        GroupConcatTest.dbo.GROUP_CONCAT_S(DISTINCT ErrorDetail, 1) AS FieldTypeDetail
FROM    GroupConcatTest.dbo.TestData
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'
GO 5

PRINT '---------- DISTINCT, sorted ASC: CLR GROUP_CONCAT_DS --------------------------------------'
GO
DECLARE @res TABLE (DocID INT, Skills NVARCHAR(MAX));
SET STATISTICS TIME ON ;
INSERT INTO @res ( DocID, Skills )
SELECT  DocID,
        GroupConcatTest.dbo.GROUP_CONCAT_DS(DISTINCT ErrorDetail, N',', 1) AS FieldTypeDetail
FROM    GroupConcatTest.dbo.TestData
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'
GO 5

PRINT '---------- DISTINCT, sorted DESC: XML PATH ------------------------------------------------'
GO
DECLARE @res TABLE (DocID INT, Skills NVARCHAR(MAX));
SET STATISTICS TIME ON ;
INSERT INTO @res ( DocID, Skills )
SELECT  DocID,
        STUFF((SELECT   DISTINCT
                        N',' + ErrorDetail
               FROM     GroupConcatTest.dbo.TestData s2
               WHERE    s2.DocID = s1.DocID
               ORDER BY N',' + ErrorDetail DESC
              FOR
               XML PATH('')
              ), 1, 1, '') AS [Skills]
FROM    GroupConcatTest.dbo.TestData s1
GROUP BY s1.DocID
ORDER BY s1.DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'
GO 5

PRINT '---------- DISTINCT, sorted DESC: XML PATH,TYPE -------------------------------------------'
GO
DECLARE @res TABLE (DocID INT, Skills NVARCHAR(MAX));
SET STATISTICS TIME ON ;
INSERT INTO @res ( DocID, Skills )
SELECT  DocID,
        STUFF(
        (SELECT N',' + n
         FROM   (SELECT   DISTINCT
                        ErrorDetail AS n
                 FROM   GroupConcatTest.dbo.TestData s2
                 WHERE  s2.DocID = s1.DocID
                ) r
         ORDER BY n DESC
        FOR   XML PATH(''),
                  TYPE
         ).value('.[1]', 'nvarchar(max)'), 1, 1, '') AS [Skills]
FROM    GroupConcatTest.dbo.TestData s1
GROUP BY s1.DocID
ORDER BY s1.DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'
GO 5

PRINT '---------- DISTINCT, sorted DESC: CLR GROUP_CONCAT_S --------------------------------------'
GO
DECLARE @res TABLE (DocID INT, Skills NVARCHAR(MAX));
SET STATISTICS TIME ON ;
INSERT INTO @res ( DocID, Skills )
SELECT  DocID,
        GroupConcatTest.dbo.GROUP_CONCAT_S(DISTINCT ErrorDetail, 2) AS FieldTypeDetail
FROM    GroupConcatTest.dbo.TestData
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'
GO 5

PRINT '---------- DISTINCT, sorted DESC: CLR GROUP_CONCAT_DS -------------------------------------'
GO
DECLARE @res TABLE (DocID INT, Skills NVARCHAR(MAX));
SET STATISTICS TIME ON ;
INSERT INTO @res ( DocID, Skills )
SELECT  DocID,
        GroupConcatTest.dbo.GROUP_CONCAT_DS(DISTINCT ErrorDetail, N',', 2) AS FieldTypeDetail
FROM    GroupConcatTest.dbo.TestData
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'
GO 5

PRINT '---------- NON-DISTINCT, unsorted: XML PATH -----------------------------------------------'
GO
DECLARE @res TABLE (DocID INT, Skills NVARCHAR(MAX));
SET STATISTICS TIME ON ;
INSERT INTO @res ( DocID, Skills )
SELECT  DocID,
        STUFF((SELECT   N',' + ErrorDetail
               FROM     GroupConcatTest.dbo.TestData s2
               WHERE    s2.DocID = s1.DocID
              FOR
               XML PATH('')
              ), 1, 1, '') AS [Skills]
FROM    GroupConcatTest.dbo.TestData s1
GROUP BY s1.DocID
ORDER BY s1.DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'
GO 5

PRINT '---------- NON-DISTINCT, unsorted: XML PATH,TYPE ------------------------------------------'
GO
DECLARE @res TABLE (DocID INT, Skills NVARCHAR(MAX));
SET STATISTICS TIME ON ;
INSERT INTO @res ( DocID, Skills )
SELECT  DocID,
        STUFF(
        (SELECT N',' + n
         FROM   (SELECT ErrorDetail AS n
                 FROM   GroupConcatTest.dbo.TestData s2
                 WHERE  s2.DocID = s1.DocID
                ) r
        FOR   XML PATH(''),
                  TYPE
         ).value('.[1]', 'nvarchar(max)'), 1, 1, '') AS [Skills]
FROM    GroupConcatTest.dbo.TestData s1
GROUP BY s1.DocID
ORDER BY s1.DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'
GO 5

PRINT '---------- NON-DISTINCT, unsorted: CLR GROUP_CONCAT ---------------------------------------'
GO
DECLARE @res TABLE (DocID INT, Skills NVARCHAR(MAX));
SET STATISTICS TIME ON ;
INSERT INTO @res ( DocID, Skills )
SELECT  DocID,
        GroupConcatTest.dbo.GROUP_CONCAT(ErrorDetail) AS FieldTypeDetail
FROM    GroupConcatTest.dbo.TestData
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'
GO 5

PRINT '---------- NON-DISTINCT, unsorted: CLR GROUP_CONCAT_D -------------------------------------'
GO
DECLARE @res TABLE (DocID INT, Skills NVARCHAR(MAX));
SET STATISTICS TIME ON ;
INSERT INTO @res ( DocID, Skills )
SELECT  DocID,
        GroupConcatTest.dbo.GROUP_CONCAT_D(ErrorDetail, N',') AS FieldTypeDetail
FROM    GroupConcatTest.dbo.TestData
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'
GO 5

PRINT '---------- NON-DISTINCT, sorted ASC: XML PATH ---------------------------------------------'
GO
DECLARE @res TABLE (DocID INT, Skills NVARCHAR(MAX));
SET STATISTICS TIME ON ;
INSERT INTO @res ( DocID, Skills )
SELECT  DocID,
        STUFF((SELECT   N',' + ErrorDetail
               FROM     GroupConcatTest.dbo.TestData s2
               WHERE    s2.DocID = s1.DocID
               ORDER BY ErrorDetail ASC
              FOR
               XML PATH('')
              ), 1, 1, '') AS [Skills]
FROM    GroupConcatTest.dbo.TestData s1
GROUP BY s1.DocID
ORDER BY s1.DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'
GO 5

PRINT '---------- NON-DISTINCT, sorted ASC: XML PATH,TYPE ----------------------------------------'
GO
DECLARE @res TABLE (DocID INT, Skills NVARCHAR(MAX));
SET STATISTICS TIME ON ;
INSERT INTO @res ( DocID, Skills )
SELECT  DocID,
        STUFF(
        (SELECT N',' + n
         FROM   (SELECT ErrorDetail AS n
                 FROM   GroupConcatTest.dbo.TestData s2
                 WHERE  s2.DocID = s1.DocID
                ) r
         ORDER BY n ASC
        FOR   XML PATH(''),
                  TYPE
         ).value('.[1]', 'nvarchar(max)'), 1, 1, '') AS [Skills]
FROM    GroupConcatTest.dbo.TestData s1
GROUP BY s1.DocID
ORDER BY s1.DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'
GO 5

PRINT '---------- NON-DISTINCT, sorted ASC: CLR GROUP_CONCAT_S -----------------------------------'
GO
DECLARE @res TABLE (DocID INT, Skills NVARCHAR(MAX));
SET STATISTICS TIME ON ;
INSERT INTO @res ( DocID, Skills )
SELECT  DocID,
        GroupConcatTest.dbo.GROUP_CONCAT_S(ErrorDetail, 1) AS FieldTypeDetail
FROM    GroupConcatTest.dbo.TestData
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'
GO 5

PRINT '---------- NON-DISTINCT, sorted ASC: CLR GROUP_CONCAT_DS ----------------------------------'
GO
DECLARE @res TABLE (DocID INT, Skills NVARCHAR(MAX));
SET STATISTICS TIME ON ;
INSERT INTO @res ( DocID, Skills )
SELECT  DocID,
        GroupConcatTest.dbo.GROUP_CONCAT_DS(ErrorDetail, N',', 1) AS FieldTypeDetail
FROM    GroupConcatTest.dbo.TestData
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'
GO 5

PRINT '---------- NON-DISTINCT, sorted DESC: XML PATH --------------------------------------------'
GO
DECLARE @res TABLE (DocID INT, Skills NVARCHAR(MAX));
SET STATISTICS TIME ON ;
INSERT INTO @res ( DocID, Skills )
SELECT  DocID,
        STUFF((SELECT   N',' + ErrorDetail
               FROM     GroupConcatTest.dbo.TestData s2
               WHERE    s2.DocID = s1.DocID
               ORDER BY ErrorDetail DESC
              FOR
               XML PATH('')
              ), 1, 1, '') AS [Skills]
FROM    GroupConcatTest.dbo.TestData s1
GROUP BY s1.DocID
ORDER BY s1.DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'
GO 5

PRINT '---------- NON-DISTINCT, sorted DESC: XML PATH,TYPE ---------------------------------------'
GO
DECLARE @res TABLE (DocID INT, Skills NVARCHAR(MAX));
SET STATISTICS TIME ON ;
INSERT INTO @res ( DocID, Skills )
SELECT  DocID,
        STUFF(
        (SELECT N',' + n
         FROM   (SELECT ErrorDetail AS n
                 FROM   GroupConcatTest.dbo.TestData s2
                 WHERE  s2.DocID = s1.DocID
                ) r
         ORDER BY n DESC
        FOR   XML PATH(''),
                  TYPE
         ).value('.[1]', 'nvarchar(max)'), 1, 1, '') AS [Skills]
FROM    GroupConcatTest.dbo.TestData s1
GROUP BY s1.DocID
ORDER BY s1.DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'
GO 5

PRINT '---------- NON-DISTINCT, sorted DESC: CLR GROUP_CONCAT_S ----------------------------------'
GO
DECLARE @res TABLE (DocID INT, Skills NVARCHAR(MAX));
SET STATISTICS TIME ON ;
INSERT INTO @res ( DocID, Skills )
SELECT  DocID,
        GroupConcatTest.dbo.GROUP_CONCAT_S(ErrorDetail, 2) AS FieldTypeDetail
FROM    GroupConcatTest.dbo.TestData
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'
GO 5

PRINT '---------- NON-DISTINCT, sorted DESC: CLR GROUP_CONCAT_DS ---------------------------------'
GO
DECLARE @res TABLE (DocID INT, Skills NVARCHAR(MAX));
SET STATISTICS TIME ON ;
INSERT INTO @res ( DocID, Skills )
SELECT  DocID,
        GroupConcatTest.dbo.GROUP_CONCAT_DS(ErrorDetail, N',', 2) AS FieldTypeDetail
FROM    GroupConcatTest.dbo.TestData
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'
GO 5
