-- http://www.sqlservercentral.com/Forums/Topic1089519-338-1.aspx
SET STATISTICS TIME OFF ;
GO
SET NOCOUNT ON ;
GO

USE test
GO
/*
IF OBJECT_ID(N'test.dbo.OPC3Test') > 0 
    DROP TABLE test.dbo.OPC3Test ;
GO

CREATE TABLE test.dbo.OPC3Test
(
 DocID INT NOT NULL,
 FieldType NVARCHAR(20) NOT NULL,
 ErrorDetail NVARCHAR(400) NULL
) ;
GO

CREATE CLUSTERED INDEX [dbo.OPC3Test_DocID__INC_FieldType] 
ON test.dbo.OPC3Test (DocID,FieldType)
GO

INSERT  INTO test.dbo.OPC3Test
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
*/

DECLARE @ct INT ;
SELECT  @ct = COUNT(*)
FROM    test.dbo.OPC3Test ;
RAISERROR('%d rows in test.dbo.OPC3Test',10,1,@ct) ;
GO

PRINT ''
PRINT '-----------------------------------------------------------------------'
PRINT ' DISTINCT, unsorted'
PRINT '-----------------------------------------------------------------------'

--PRINT ''
--PRINT '========== XML Method ================================================='
--SET STATISTICS TIME ON ;
--SELECT  DocID,
--        STUFF((SELECT   DISTINCT
--                        N',' + ErrorDetail
--               FROM     test.dbo.OPC3Test s2
--               WHERE    s2.DocID = s1.DocID
--              FOR
--               XML PATH('')
--              ), 1, 1, '') AS [Skills]
--FROM    test.dbo.OPC3Test s1
--GROUP BY s1.DocID
--ORDER BY s1.DocID ;
--SET STATISTICS TIME OFF ;
--WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '========== XML Method (escaped characters) ============================'
SET STATISTICS TIME ON ;
SELECT  DocID,
        STUFF(
        (SELECT N',' + n
         FROM   (SELECT   DISTINCT
                        ErrorDetail AS n
                 FROM   test.dbo.OPC3Test s2
                 WHERE  s2.DocID = s1.DocID
                ) r
        FOR   XML PATH(''),
                  TYPE
         ).value('.[1]', 'nvarchar(max)'), 1, 1, '') AS [Skills]
FROM    test.dbo.OPC3Test s1
GROUP BY s1.DocID
ORDER BY s1.DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

--PRINT ''
--PRINT '========== CLR group_concat_list (no custom inputs) ========================'
--SET STATISTICS TIME ON ;
--SELECT  DocID,
--        test.dbo.group_concat_list(DISTINCT ErrorDetail) AS FieldTypeDetail
--FROM    test.dbo.OPC3Test
--GROUP BY DocID
--ORDER BY DocID ;
--SET STATISTICS TIME OFF ;
--WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '========== CLR group_concat_dictionary (no custom inputs) ============='
SET STATISTICS TIME ON ;
SELECT  DocID,
        test.dbo.group_concat_dictionary(DISTINCT ErrorDetail) AS FieldTypeDetail
FROM    test.dbo.OPC3Test
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '========== CLR group_concat_string (no custom inputs) ========================'
SET STATISTICS TIME ON ;
SELECT  DocID,
        test.dbo.group_concat_string(DISTINCT ErrorDetail) AS FieldTypeDetail
FROM    test.dbo.OPC3Test
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

--PRINT ''
--PRINT '========== CLR group_concat_list_delim (custom inputs) ====================='
--SET STATISTICS TIME ON ;
--SELECT  DocID,
--        test.dbo.group_concat_list_delim(DISTINCT ErrorDetail, N',') AS FieldTypeDetail
--FROM    test.dbo.OPC3Test
--GROUP BY DocID
--ORDER BY DocID ;
--SET STATISTICS TIME OFF ;
--WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '========== CLR group_concat_dictionary_delim (custom inputs) ======='
SET STATISTICS TIME ON ;
SELECT  DocID,
        test.dbo.group_concat_dictionary_delim(DISTINCT ErrorDetail, N',') AS FieldTypeDetail
FROM    test.dbo.OPC3Test
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '========== CLR group_concat_string_delim (custom inputs) ======='
SET STATISTICS TIME ON ;
SELECT  DocID,
        test.dbo.group_concat_string_delim(DISTINCT ErrorDetail, N',') AS FieldTypeDetail
FROM    test.dbo.OPC3Test
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '-----------------------------------------------------------------------'
PRINT ' DISTINCT, sorted ASC'
PRINT '-----------------------------------------------------------------------'

--PRINT ''
--PRINT '========== XML Method ================================================='
--SET STATISTICS TIME ON ;
--SELECT  DocID,
--        STUFF((SELECT   DISTINCT
--                        N',' + ErrorDetail
--               FROM     test.dbo.OPC3Test s2
--               WHERE    s2.DocID = s1.DocID
--               ORDER BY N',' + ErrorDetail ASC
--              FOR
--               XML PATH('')
--              ), 1, 1, '') AS [Skills]
--FROM    test.dbo.OPC3Test s1
--GROUP BY s1.DocID
--ORDER BY s1.DocID ;
--SET STATISTICS TIME OFF ;
--WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '========== XML Method (escaped characters) ============================'
SET STATISTICS TIME ON ;
SELECT  DocID,
        STUFF(
        (SELECT N',' + n
         FROM   (SELECT   DISTINCT
                        ErrorDetail AS n
                 FROM   test.dbo.OPC3Test s2
                 WHERE  s2.DocID = s1.DocID
                ) r
         ORDER BY n ASC
        FOR   XML PATH(''),
                  TYPE
         ).value('.[1]', 'nvarchar(max)'), 1, 1, '') AS [Skills]
FROM    test.dbo.OPC3Test s1
GROUP BY s1.DocID
ORDER BY s1.DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '========== CLR group_concat_list_sorted (custom inputs) ==============='
SET STATISTICS TIME ON ;
SELECT  DocID,
        test.dbo.group_concat_list_sorted(DISTINCT ErrorDetail, N'ASC') AS FieldTypeDetail
FROM    test.dbo.OPC3Test
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '========== CLR group_concat_dictionary_sorted (custom inputs) ========='
SET STATISTICS TIME ON ;
SELECT  DocID,
        test.dbo.group_concat_dictionary_sorted(DISTINCT ErrorDetail, N'ASC') AS FieldTypeDetail
FROM    test.dbo.OPC3Test
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '========== CLR group_concat_list_delim_sorted (custom inputs) ========='
SET STATISTICS TIME ON ;
SELECT  DocID,
        test.dbo.group_concat_list_delim_sorted(DISTINCT ErrorDetail, N',', N'ASC') AS FieldTypeDetail
FROM    test.dbo.OPC3Test
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '========== CLR group_concat_dictionary_delim_sorted (custom inputs) ==='
SET STATISTICS TIME ON ;
SELECT  DocID,
        test.dbo.group_concat_dictionary_delim_sorted(DISTINCT ErrorDetail, N',', N'ASC') AS FieldTypeDetail
FROM    test.dbo.OPC3Test
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '-----------------------------------------------------------------------'
PRINT ' DISTINCT, sorted DESC'
PRINT '-----------------------------------------------------------------------'

--PRINT ''
--PRINT '========== XML Method ================================================='
--SET STATISTICS TIME ON ;
--SELECT  DocID,
--        STUFF((SELECT   DISTINCT
--                        N',' + ErrorDetail
--               FROM     test.dbo.OPC3Test s2
--               WHERE    s2.DocID = s1.DocID
--               ORDER BY N',' + ErrorDetail DESC
--              FOR
--               XML PATH('')
--              ), 1, 1, '') AS [Skills]
--FROM    test.dbo.OPC3Test s1
--GROUP BY s1.DocID
--ORDER BY s1.DocID ;
--SET STATISTICS TIME OFF ;

PRINT ''
PRINT '========== XML Method (escaped characters) ============================'
SET STATISTICS TIME ON ;
SELECT  DocID,
        STUFF(
        (SELECT N',' + n
         FROM   (SELECT   DISTINCT
                        ErrorDetail AS n
                 FROM   test.dbo.OPC3Test s2
                 WHERE  s2.DocID = s1.DocID
                ) r
         ORDER BY n DESC
        FOR   XML PATH(''),
                  TYPE
         ).value('.[1]', 'nvarchar(max)'), 1, 1, '') AS [Skills]
FROM    test.dbo.OPC3Test s1
GROUP BY s1.DocID
ORDER BY s1.DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '========== CLR group_concat_list_sorted (custom inputs) ==============='
SET STATISTICS TIME ON ;
SELECT  DocID,
        test.dbo.group_concat_list_sorted(DISTINCT ErrorDetail, N'DESC') AS FieldTypeDetail
FROM    test.dbo.OPC3Test
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '========== CLR group_concat_dictionary_sorted (custom inputs) ========='
SET STATISTICS TIME ON ;
SELECT  DocID,
        test.dbo.group_concat_dictionary_sorted(DISTINCT ErrorDetail, N'DESC') AS FieldTypeDetail
FROM    test.dbo.OPC3Test
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '========== CLR group_concat_list_delim_sorted (custom inputs) ========='
SET STATISTICS TIME ON ;
SELECT  DocID,
        test.dbo.group_concat_list_delim_sorted(DISTINCT ErrorDetail, N',', N'DESC') AS FieldTypeDetail
FROM    test.dbo.OPC3Test
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '========== CLR group_concat_dictionary_delim_sorted (custom inputs) ==='
SET STATISTICS TIME ON ;
SELECT  DocID,
        test.dbo.group_concat_dictionary_delim_sorted(DISTINCT ErrorDetail, N',', N'DESC') AS FieldTypeDetail
FROM    test.dbo.OPC3Test
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '-----------------------------------------------------------------------'
PRINT ' NON-DISTINCT, unsorted'
PRINT '-----------------------------------------------------------------------'

--PRINT ''
--PRINT '========== XML Method ================================================='
--SET STATISTICS TIME ON ;
--SELECT  DocID,
--        STUFF((SELECT   N',' + ErrorDetail
--               FROM     test.dbo.OPC3Test s2
--               WHERE    s2.DocID = s1.DocID
--              FOR
--               XML PATH('')
--              ), 1, 1, '') AS [Skills]
--FROM    test.dbo.OPC3Test s1
--GROUP BY s1.DocID
--ORDER BY s1.DocID ;
--SET STATISTICS TIME OFF ;

PRINT ''
PRINT '========== XML Method (escaped characters) ============================'
SET STATISTICS TIME ON ;
SELECT  DocID,
        STUFF(
        (SELECT N',' + n
         FROM   (SELECT ErrorDetail AS n
                 FROM   test.dbo.OPC3Test s2
                 WHERE  s2.DocID = s1.DocID
                ) r
        FOR   XML PATH(''),
                  TYPE
         ).value('.[1]', 'nvarchar(max)'), 1, 1, '') AS [Skills]
FROM    test.dbo.OPC3Test s1
GROUP BY s1.DocID
ORDER BY s1.DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '========== CLR group_concat_list (no custom inputs) ==================='
SET STATISTICS TIME ON ;
SELECT  DocID,
        test.dbo.group_concat_list(ErrorDetail) AS FieldTypeDetail
FROM    test.dbo.OPC3Test
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '========== CLR group_concat_string (no custom inputs) ================='
SET STATISTICS TIME ON ;
SELECT  DocID,
        test.dbo.group_concat_string(ErrorDetail) AS FieldTypeDetail
FROM    test.dbo.OPC3Test
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '========== CLR group_concat_dictionary (no custom inputs) ============='
SET STATISTICS TIME ON ;
SELECT  DocID,
        test.dbo.group_concat_dictionary(ErrorDetail) AS FieldTypeDetail
FROM    test.dbo.OPC3Test
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '========== CLR group_concat_list_delim (custom inputs) ====================='
SET STATISTICS TIME ON ;
SELECT  DocID,
        test.dbo.group_concat_list_delim(ErrorDetail, N',') AS FieldTypeDetail
FROM    test.dbo.OPC3Test
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '========== CLR group_concat_dictionary_delim (custom inputs) =========='
SET STATISTICS TIME ON ;
SELECT  DocID,
        test.dbo.group_concat_dictionary_delim(ErrorDetail, N',') AS FieldTypeDetail
FROM    test.dbo.OPC3Test
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '-----------------------------------------------------------------------'
PRINT ' NON-DISTINCT, sorted ASC'
PRINT '-----------------------------------------------------------------------'

--PRINT ''
--PRINT '========== XML Method ================================================='
--SET STATISTICS TIME ON ;
--SELECT  DocID,
--        STUFF((SELECT   N',' + ErrorDetail
--               FROM     test.dbo.OPC3Test s2
--               WHERE    s2.DocID = s1.DocID
--               ORDER BY ErrorDetail ASC
--              FOR
--               XML PATH('')
--              ), 1, 1, '') AS [Skills]
--FROM    test.dbo.OPC3Test s1
--GROUP BY s1.DocID
--ORDER BY s1.DocID ;
--SET STATISTICS TIME OFF ;

PRINT ''
PRINT '========== XML Method (escaped characters) ============================'
SET STATISTICS TIME ON ;
SELECT  DocID,
        STUFF(
        (SELECT N',' + n
         FROM   (SELECT ErrorDetail AS n
                 FROM   test.dbo.OPC3Test s2
                 WHERE  s2.DocID = s1.DocID
                ) r
         ORDER BY n ASC
        FOR   XML PATH(''),
                  TYPE
         ).value('.[1]', 'nvarchar(max)'), 1, 1, '') AS [Skills]
FROM    test.dbo.OPC3Test s1
GROUP BY s1.DocID
ORDER BY s1.DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '========== CLR group_concat_list_sorted (custom inputs) ===================='
SET STATISTICS TIME ON ;
SELECT  DocID,
        test.dbo.group_concat_list_sorted(ErrorDetail, N'ASC') AS FieldTypeDetail
FROM    test.dbo.OPC3Test
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '========== CLR group_concat_dictionary_sorted (custom inputs) ========='
SET STATISTICS TIME ON ;
SELECT  DocID,
        test.dbo.group_concat_dictionary_sorted(ErrorDetail, N'ASC') AS FieldTypeDetail
FROM    test.dbo.OPC3Test
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '========== CLR group_concat_list_delim_sorted (custom inputs) =============='
SET STATISTICS TIME ON ;
SELECT  DocID,
        test.dbo.group_concat_list_delim_sorted(ErrorDetail, N',', N'ASC') AS FieldTypeDetail
FROM    test.dbo.OPC3Test
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '========== CLR group_concat_dictionary_delim_sorted (custom inputs) ==='
SET STATISTICS TIME ON ;
SELECT  DocID,
        test.dbo.group_concat_dictionary_delim_sorted(ErrorDetail, N',', N'ASC') AS FieldTypeDetail
FROM    test.dbo.OPC3Test
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '-----------------------------------------------------------------------'
PRINT ' NON-DISTINCT, sorted DESC'
PRINT '-----------------------------------------------------------------------'

--PRINT ''
--PRINT '========== XML Method ================================================='
--SET STATISTICS TIME ON ;
--SELECT  DocID,
--        STUFF((SELECT   N',' + ErrorDetail
--               FROM     test.dbo.OPC3Test s2
--               WHERE    s2.DocID = s1.DocID
--               ORDER BY ErrorDetail DESC
--              FOR
--               XML PATH('')
--              ), 1, 1, '') AS [Skills]
--FROM    test.dbo.OPC3Test s1
--GROUP BY s1.DocID
--ORDER BY s1.DocID ;
--SET STATISTICS TIME OFF ;
--WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '========== XML Method (escaped characters) ============================'
SET STATISTICS TIME ON ;
SELECT  DocID,
        STUFF(
        (SELECT N',' + n
         FROM   (SELECT ErrorDetail AS n
                 FROM   test.dbo.OPC3Test s2
                 WHERE  s2.DocID = s1.DocID
                ) r
         ORDER BY n DESC
        FOR   XML PATH(''),
                  TYPE
         ).value('.[1]', 'nvarchar(max)'), 1, 1, '') AS [Skills]
FROM    test.dbo.OPC3Test s1
GROUP BY s1.DocID
ORDER BY s1.DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '========== CLR group_concat_list_sorted (custom inputs) ===================='
SET STATISTICS TIME ON ;
SELECT  DocID,
        test.dbo.group_concat_list_sorted(ErrorDetail, N'DESC') AS FieldTypeDetail
FROM    test.dbo.OPC3Test
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '========== CLR group_concat_dictionary_sorted (custom inputs) ========='
SET STATISTICS TIME ON ;
SELECT  DocID,
        test.dbo.group_concat_dictionary_sorted(ErrorDetail, N'DESC') AS FieldTypeDetail
FROM    test.dbo.OPC3Test
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '========== CLR group_concat_list_delim_sorted (custom inputs) =============='
SET STATISTICS TIME ON ;
SELECT  DocID,
        test.dbo.group_concat_list_delim_sorted(ErrorDetail, N',', N'DESC') AS FieldTypeDetail
FROM    test.dbo.OPC3Test
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

PRINT ''
PRINT '========== CLR group_concat_dictionary_delim_sorted (custom inputs) ==='
SET STATISTICS TIME ON ;
SELECT  DocID,
        test.dbo.group_concat_dictionary_delim_sorted(ErrorDetail, N',', N'DESC') AS FieldTypeDetail
FROM    test.dbo.OPC3Test
GROUP BY DocID
ORDER BY DocID ;
SET STATISTICS TIME OFF ;
WAITFOR DELAY '00:00:01'

GO
