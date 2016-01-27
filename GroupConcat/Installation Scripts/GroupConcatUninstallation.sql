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
