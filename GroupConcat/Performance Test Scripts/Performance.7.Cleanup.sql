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

USE [master]
GO
ALTER DATABASE GroupConcatTest SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
DROP DATABASE GroupConcatTest
GO
