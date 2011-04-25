USE master
GO

IF NOT EXISTS ( SELECT  *
                FROM    sys.databases
                WHERE   name = 'GroupConcatTest' ) 
    CREATE DATABASE [GroupConcatTest]
GO

USE GroupConcatTest
GO

-- Turn advanced options on
EXEC sys.sp_configure @configname = 'show advanced options', @configvalue = 1 ;
GO
RECONFIGURE ;
GO
-- Enable CLR
EXEC sys.sp_configure @configname = 'clr enabled', @configvalue = 1 ;
GO
RECONFIGURE ;
GO
