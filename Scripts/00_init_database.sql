/* 
======================================================================
Create Database and Schemas
======================================================================
Script Purpose: 
    This script creates a new database named 'Data_Analytics_Project' after checking if it already exisits.
    if the database exists, it is dropped and recreated. Aditionally,the script sets up three schema within the database: 'gold', 'silver' , 'gold'
WARNING: 
    Running this sript will drop the entire 'Data_Analytics_Project' database if it exists
    All data in the database will be deleted permanently. Proceed with caution.
    and ensure you have proper backups before running th scripts.
*/

USE master;
GO

-- DROP AND RECREATE THE DATABASE 'Data_Analytics_Project' IF IT EXISTS (force disconnect)
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'Data_Analytics_Project')
BEGIN
    ALTER DATABASE Data_Analytics_Project SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Data_Analytics_Project;
END
GO
CREATE DATABASE Data_Analytics_Project;
GO

USE Data_Analytics_Project;
GO

--- CREATE SCHEMAS FOR GOLD for analysis 
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'GOLD')
    EXEC('CREATE SCHEMA GOLD');
GO

--- Run this query after running the above query---
CREATE OR ALTER PROCEDURE gold.load_gold
AS
BEGIN
    DECLARE @start_time DATETIME,@end_time DATETIME, @batch_start_time DATETIME,@batch_end_time DATETIME;
    BEGIN TRY 
        SET @start_time = GETDATE();
        PRINT 'Data Load into gold Tables Started at: ' + CONVERT(NVARCHAR, @start_time, 120);

        -- BULK INSERT commands to load data into gold tables can be added here

        SET @end_time = GETDATE();
        PRINT 'Data Load into gold Tables Completed at: ' + CONVERT(NVARCHAR, @end_time, 120);
        PRINT 'Total Duration (seconds): ' + CONVERT(NVARCHAR, DATEDIFF(SECOND, @start_time, @end_time));
        PRINT 'loading dim Tables into Gold Tables;'

/*
===============================================================================
DDL Script: Create gold Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'gold' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'gold' Tables
===============================================================================
*/

/* BULK INSERT COMMANDS CAN BE ADDED BELOW TO LOAD DATA INTO THE gold.dim_customers */

    SET @batch_start_time = GETDATE();
    PRINT '  Loading gold.dim_customers started at: ' + CONVERT(NVARCHAR, @batch_start_time, 120);
    PRINT '>> Truncating Table: gold.dim_customers';

    IF OBJECT_ID('gold.dim_customers', 'U') IS NOT NULL
    DROP TABLE gold.dim_customers;

    CREATE TABLE gold.dim_customers (
        customer_key int,
        customer_id int,
        customer_number nvarchar(50),
        first_name nvarchar(50),
        last_name nvarchar(50),
        country nvarchar(50),
        marital_status nvarchar(50),
        gender nvarchar(50),
        birthdate date,
        create_date date
    );
    PRINT '>> Inserting Data Into: gold.dim_customers';
    TRUNCATE TABLE gold.dim_customers;
    BULK INSERT gold.dim_customers
    FROM '/var/opt/mssql/data/datasets/source_gold_layer/dim_customers.csv'
    WITH(
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );
    
    SET @batch_end_time = GETDATE();
        PRINT '  Loading gold.dim_customers completed at: ' + CONVERT(NVARCHAR, @batch_end_time, 120);    
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';


/* BULK INSERT COMMANDS CAN BE ADDED BELOW TO LOAD DATA INTO THE gold TABLES gold.dim_products */

    SET @batch_start_time = GETDATE();
    PRINT '  Loading gold.dim_products started at: ' + CONVERT(NVARCHAR, @batch_start_time, 120);
    PRINT '>> Truncating Table: gold.dim_products';

    IF OBJECT_ID('gold.dim_products', 'U') IS NOT NULL
    DROP TABLE gold.dim_products;

    CREATE TABLE gold.dim_products (
        product_key int ,
        product_id int ,
        product_number nvarchar(50) ,
        product_name nvarchar(50) ,
        category_id nvarchar(50) ,
        category nvarchar(50) ,
        subcategory nvarchar(50) ,
        maintenance nvarchar(50) ,
        cost int,
        product_line nvarchar(50),
        start_date date 
    );
    PRINT '>> Inserting Data Into: gold.dim_products';
    TRUNCATE TABLE gold.dim_products;
    BULK INSERT gold.dim_products
    FROM '/var/opt/mssql/data/datasets/source_gold_layer/dim_products.csv'
    WITH(
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );
    
    SET @batch_end_time = GETDATE();
        PRINT '  Loading gold.dim_products completed at: ' + CONVERT(NVARCHAR, @batch_end_time, 120);    
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

/* BULK INSERT COMMANDS CAN BE ADDED BELOW TO LOAD DATA INTO THE gold TABLES gold.fact_sales */

    SET @batch_start_time = GETDATE();
    PRINT '  Loading gold.fact_sales started at: ' + CONVERT(NVARCHAR, @batch_start_time, 120);
    PRINT '>> Truncating Table: gold.fact_sales';

    IF OBJECT_ID('gold.fact_sales', 'U') IS NOT NULL
    DROP TABLE gold.fact_sales;

    CREATE TABLE gold.fact_sales (
      	order_number nvarchar(50),
        product_key int,
        customer_key int,
        order_date date,
        shipping_date date,
        due_date date,
        sales_amount int,
        quantity tinyint,
        price int 
    );
    PRINT '>> Inserting Data Into: gold.fact_sales';
    TRUNCATE TABLE gold.fact_sales;
    BULK INSERT gold.fact_sales
    FROM '/var/opt/mssql/data/datasets/source_gold_layer/fact_sales.csv'
    WITH(
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );
    
    SET @batch_end_time = GETDATE();
        PRINT '  Loading gold.fact_sales completed at: ' + CONVERT(NVARCHAR, @batch_end_time, 120);    
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

END TRY 
    BEGIN CATCH 
        PRINT '=========================================='
            PRINT 'ERROR OCCURED DURING LOADING gold LAYER'
            PRINT 'Error Message' + ERROR_MESSAGE();
            PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
            PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
            PRINT '=========================================='
	END CATCH
END


--- Run this query after running the above query---
EXEC gold.load_gold;

--- Validating Tables ---
SELECT * FROM gold.fact_sales;

SELECT * FROM gold.dim_products;

SELECT * FROM gold.dim_customers;


