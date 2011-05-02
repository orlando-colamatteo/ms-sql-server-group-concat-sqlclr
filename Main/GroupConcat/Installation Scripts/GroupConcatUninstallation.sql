/*
Uninstallation script for GROUP_CONCAT functions. Tested in SSMS 2008R2.
*/
SET NOCOUNT ON ;
GO

-- !! MODIFY TO SUIT YOUR TEST ENVIRONMENT !!
USE GroupConcatTest
GO

-------------------------------------------------------------------------------------------------------------------------------

IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[GROUP_CONCAT]')
                    AND type = N'AF' ) 
    DROP AGGREGATE [dbo].[GROUP_CONCAT]
GO

IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[GROUP_CONCAT_D]')
                    AND type = N'AF' ) 
    DROP AGGREGATE [dbo].[GROUP_CONCAT_D]
GO

IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[GROUP_CONCAT_DS]')
                    AND type = N'AF' ) 
    DROP AGGREGATE [dbo].[GROUP_CONCAT_DS]
GO

IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[GROUP_CONCAT_S]')
                    AND type = N'AF' ) 
    DROP AGGREGATE [dbo].[GROUP_CONCAT_S]
GO

IF EXISTS ( SELECT  *
            FROM    sys.assemblies asms
            WHERE   asms.name = N'GroupConcat'
                    AND is_user_defined = 1 ) 
    DROP ASSEMBLY [GroupConcat]
GO
