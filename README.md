# ms-sql-server-group-concat-sqlclr
See /docs/documentation.html & /docs/home.html

Please, visit my GitHub Pages site for more information 
http://orlando-colamatteo.github.io/ms-sql-server-group-concat-sqlclr/

#### Installation on AWS RDS
Installation of GROUP_CONCAT requires an advanced SQL Server option "clr enabled" to be set to 1. 
While this option is available on local installations of SQL Server, it is not available on 
Amazon's RDS Service. 

##### To install GROUP_CONCAT on AWS RDS you must: 

* Create a custom DB Parameters Group
* Set the 'clr enable' value to 1 in the custom DB Parameter Group
* Configure your RDS instance to use the custom DB Parameter Group
* Connect to the RDS SQL Server using SSMS with the RDS Instance Master User 
* Create a new query and paste in the RDSGroupConcatInstallation.sql script
* Modify the 'USE' line to set the target DB to install GROUP_CONCAT
* Execute the query to run the RDSGroupConcatInstallation.sql script
* The GroupConcat assembly is installed to the target database > programability > assemblies
