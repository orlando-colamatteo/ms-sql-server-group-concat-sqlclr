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
