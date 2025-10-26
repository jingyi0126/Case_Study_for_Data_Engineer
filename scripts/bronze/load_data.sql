/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema. 
    
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

===============================================================================
*/
-- Create Companies in Bronze Layer 
IF OBJECT_ID('bronze.companies', 'U') IS NOT NULL
    DROP TABLE bronze.companies;
GO

CREATE TABLE bronze.companies (
    k_company INT,
    name VARCHAR(255),
    country VARCHAR(255)
);
GO
PRINT 'Created bronze.companies table';

-- Create Contacts in Bronze Layer 
IF OBJECT_ID('bronze.contacts', 'U') IS NOT NULL
    DROP TABLE bronze.contacts;
GO

CREATE TABLE bronze.contacts (
    k_contact VARCHAR(255),
    creation_date DATE,
    country VARCHAR(255)
);
GO
PRINT 'Created bronze.contacts table';

-- Create Comp-Cont in Bronze Layer 

IF OBJECT_ID('bronze.comp_cont', 'U') IS NOT NULL
    DROP TABLE bronze.comp_cont;
GO

CREATE TABLE bronze.comp_cont (
    k_company INT,
    k_contact VARCHAR(255),
    main_company BIT
);
GO
PRINT 'Created bronze.comp_cont table';

-- Create Articles in Bronze Layer 
IF OBJECT_ID('bronze.articles', 'U') IS NOT NULL
    DROP TABLE bronze.articles;
GO

CREATE TABLE bronze.articles (
    k_article VARCHAR(10),
    family VARCHAR(255)
);
GO
PRINT 'Created bronze.articles table';

-- Create Visit in Bronze Layer 
IF OBJECT_ID('bronze.visits', 'U') IS NOT NULL
    DROP TABLE bronze.visits;
GO

CREATE TABLE bronze.visits (
    k_visit INT,
    f_company INT,
    f_contact VARCHAR(255),
    visit_date DATE,
    duration INT
);
GO
PRINT 'Created bronze.visits table';

-- Create Visit Results in Bronze Layer 
IF OBJECT_ID('bronze.visit_results', 'U') IS NOT NULL
    DROP TABLE bronze.visit_results;
GO

CREATE TABLE bronze.visit_results (
    k_visit_result INT,
    f_visit INT,
    shortlisted_reference1 VARCHAR(10),
    shortlisted_reference2 VARCHAR(10),
    shortlisted_reference3 VARCHAR(10)
);
GO
PRINT 'Created bronze.visit_results table';

PRINT 'All Bronze layer tables created successfully';
GO

-- ==================================================
-- Create Load Procedure
-- ==================================================
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '================================================';
		PRINT 'Loading Bronze Layer - From Existing Database';
		PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading Companies Data';
		PRINT '------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.companies';
		TRUNCATE TABLE bronze.companies;
		
		PRINT '>> Inserting Data Into: bronze.companies';
		INSERT INTO bronze.companies (
			k_company, name, country
		)
		SELECT 
			k_company, name, country
		FROM dbo.companies;
		
		SET @end_time = GETDATE();
		PRINT '>> Records Loaded: ' + CAST(@@ROWCOUNT AS NVARCHAR);
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		PRINT '------------------------------------------------';
		PRINT 'Loading Contacts Data';
		PRINT '------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.contacts';
		TRUNCATE TABLE bronze.contacts;
		
		PRINT '>> Inserting Data Into: bronze.contacts';
		INSERT INTO bronze.contacts (
			k_contact, creation_date, country
		)
		SELECT 
			k_contact, creation_date, country
		FROM dbo.contacts;
		
		SET @end_time = GETDATE();
		PRINT '>> Records Loaded: ' + CAST(@@ROWCOUNT AS NVARCHAR);
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		PRINT '------------------------------------------------';
		PRINT 'Loading Company-Contact Relationships';
		PRINT '------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.comp_cont';
		TRUNCATE TABLE bronze.comp_cont;
		
		PRINT '>> Inserting Data Into: bronze.comp_cont';
		INSERT INTO bronze.comp_cont (
			k_company, k_contact, main_company
		)
		SELECT 
			k_company, k_contact, main_company
		FROM dbo.comp_cont;
		
		SET @end_time = GETDATE();
		PRINT '>> Records Loaded: ' + CAST(@@ROWCOUNT AS NVARCHAR);
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		PRINT '------------------------------------------------';
		PRINT 'Loading Articles Data';
		PRINT '------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.articles';
		TRUNCATE TABLE bronze.articles;
		
		PRINT '>> Inserting Data Into: bronze.articles';
		INSERT INTO bronze.articles (
			k_article, family
		)
		SELECT 
			k_article, family
		FROM dbo.articles;
		
		SET @end_time = GETDATE();
		PRINT '>> Records Loaded: ' + CAST(@@ROWCOUNT AS NVARCHAR);
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		PRINT '------------------------------------------------';
		PRINT 'Loading Visits Data';
		PRINT '------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.visits';
		TRUNCATE TABLE bronze.visits;
		
		PRINT '>> Inserting Data Into: bronze.visits';
		INSERT INTO bronze.visits (
			k_visit, f_company, f_contact, visit_date, duration
		)
		SELECT 
			k_visit, f_company, f_contact, visit_date, duration
		FROM dbo.visits;
		
		SET @end_time = GETDATE();
		PRINT '>> Records Loaded: ' + CAST(@@ROWCOUNT AS NVARCHAR);
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		PRINT '------------------------------------------------';
		PRINT 'Loading Visit Results Data';
		PRINT '------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.visit_results';
		TRUNCATE TABLE bronze.visit_results;
		
		PRINT '>> Inserting Data Into: bronze.visit_results';
		INSERT INTO bronze.visit_results (
			k_visit_result, f_visit, shortlisted_reference1, shortlisted_reference2, shortlisted_reference3
		)
		SELECT 
			k_visit_result, f_visit, shortlisted_reference1, shortlisted_reference2, shortlisted_reference3
		FROM dbo.visit_results;
		
		SET @end_time = GETDATE();
		PRINT '>> Records Loaded: ' + CAST(@@ROWCOUNT AS NVARCHAR);
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		-- Data Completeness Validation
		PRINT '------------------------------------------------';
		PRINT 'Data Integrity Verification';
		PRINT '------------------------------------------------';
		
		DECLARE @verification_table TABLE (
			table_name NVARCHAR(50),
			bronze_count INT,
			source_count INT
		);
		
		INSERT INTO @verification_table
		SELECT 'companies' as table_name,
			   (SELECT COUNT(*) FROM bronze.companies) as bronze_count,
			   (SELECT COUNT(*) FROM dbo.companies) as source_count
		UNION ALL
		SELECT 'contacts', 
			   (SELECT COUNT(*) FROM bronze.contacts), 
			   (SELECT COUNT(*) FROM dbo.contacts)
		UNION ALL
		SELECT 'comp_cont', 
			   (SELECT COUNT(*) FROM bronze.comp_cont), 
			   (SELECT COUNT(*) FROM dbo.comp_cont)
		UNION ALL
		SELECT 'articles', 
			   (SELECT COUNT(*) FROM bronze.articles), 
			   (SELECT COUNT(*) FROM dbo.articles)
		UNION ALL
		SELECT 'visits', 
			   (SELECT COUNT(*) FROM bronze.visits), 
			   (SELECT COUNT(*) FROM dbo.visits)
		UNION ALL
		SELECT 'visit_results', 
			   (SELECT COUNT(*) FROM bronze.visit_results), 
			   (SELECT COUNT(*) FROM dbo.visit_results);

		SELECT * FROM @verification_table;

		SET @batch_end_time = GETDATE();
		PRINT '==========================================';
		PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '==========================================';
	END TRY
	BEGIN CATCH
		PRINT '==========================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT 'Error Procedure: ' + ISNULL(ERROR_PROCEDURE(), 'N/A');
		PRINT 'Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR);
		PRINT '==========================================';
	END CATCH
END
GO

-- ==================================================
-- Execution Bronze Layer Loading
-- ==================================================
PRINT '================================================';
PRINT 'Starting Data Loading Process...';
PRINT '================================================';
GO

EXEC bronze.load_bronze;
GO

PRINT '================================================';
PRINT 'Bronze Layer Setup Completed Successfully!';
PRINT '================================================';
