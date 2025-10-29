/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';

        -- Loading silver.companies
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.companies';
		TRUNCATE TABLE silver.companies;
		PRINT '>> Inserting Data Into: silver.companies';
        INSERT INTO silver.companies (
			k_company,
			name,
			country
		)
		SELECT 
		    k_company,
			name,
			country
		FROM bronze.companies
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		-- Loading silver.contacts
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.contacts';
		TRUNCATE TABLE silver.contacts;
		PRINT '>> Inserting Data Into: silver.contacts';
		INSERT INTO silver.contacts (
			k_contact,
			creation_date,
			country
		)
		SELECT
		    k_contact,
			creation_date,
			COALESCE(NULLIF(LTRIM(RTRIM(country)), ''), 'N/A') AS country
		FROM bronze.contacts
		 SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		-- Loading silver.comp_cont
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.comp_cont';
		TRUNCATE TABLE silver.comp_cont;
		PRINT '>> Inserting Data Into: silver.comp_cont';
		INSERT INTO silver.comp_cont (
			k_company,
			k_contact,
			main_company
		)
		SELECT
		    k_company,
			k_contact,
		    main_company
		FROM bronze.comp_cont
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		-- Loading silver.visits
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.visits';
		TRUNCATE TABLE silver.visits;
		PRINT '>> Inserting Data Into: silver.visits';
		INSERT INTO silver.visits (
			k_visit,
			f_company,
			f_contact,
			visit_date,
			duration,
			is_valid
		)
		SELECT
		    k_visit,
			f_company,
			f_contact,
			visit_date,
		    duration,
			CASE 
                WHEN visit_date <= GETDATE() THEN 1 
                ELSE 0 
            END as is_valid
			
		FROM bronze.visits
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		-- Loading silver.visit_results
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.visit_results';
		TRUNCATE TABLE silver.visit_results;
		PRINT '>> Inserting Data Into: silver.visit_results';
		INSERT INTO silver.visit_results (
		    k_visit_result,
			f_visit,
			shortlisted_reference1,
			shortlisted_reference2,
			shortlisted_reference3
		)
		SELECT
		    k_visit_result,
			f_visit,
			shortlisted_reference1,
			shortlisted_reference2,
			shortlisted_reference3
		FROM bronze.visit_results
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		-- Loading silver.articles
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.articles';
		TRUNCATE TABLE silver.articles;
		PRINT '>> Inserting Data Into: silver.articles';
		INSERT INTO silver.articles (
		    k_article,
			family
		)
		SELECT
		    k_article,
			family
		FROM bronze.articles
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

			SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Silver Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
		
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END
