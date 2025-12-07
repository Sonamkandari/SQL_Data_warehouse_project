/*

============================================
Create database and schemas
============================================

Script purpose:
This script creates a new database named 'dataWarehouse' after checking if it already exists.
If the database exists, it drops and recreated. Additionally, the script sets up the three schemas
within the database: bronze, silver, and gold.

Warning:
Running this script will drop the entire data warehouse database if it exists. 
All data in the database will permanently be deleted. Proceed with caution 
and ensure you have proper backups before running this script 

*/


-- create Database 'DataWarehouse'
USE master;
go

-- Drop and recreate the 'DataWarehouse' database
if EXISTS (SELECT 1 From sys.databases where name='DataWarehouse')
BEGIN 
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;

END;
GO

CREATE DATABASE DataWarehouse;
Go

USE DataWarehouse;
GO

-- here we are going to start creating schema for Bronze layer, Silver Layer and Gold Layer
CREATE SCHEMA bronze;
GO
-- Go separate batches when working with multiple SQL statements
CREATE SCHEMA silver;
GO 

CREATE SCHEMA gold;
