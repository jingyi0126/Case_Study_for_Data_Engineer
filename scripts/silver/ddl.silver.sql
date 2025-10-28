/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'silver' Tables
===============================================================================
*/
IF OBJECT_ID('silver.companies', 'U') IS NOT NULL
    DROP TABLE silver.companies;
GO

CREATE TABLE silver.companies (
    k_company INT,
    name VARCHAR(255),
    country VARCHAR(255),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO
PRINT 'Created silver.companies table';

IF OBJECT_ID('silver.contacts', 'U') IS NOT NULL
    DROP TABLE silver.contacts;
GO

CREATE TABLE silver.contacts (
    k_contact VARCHAR(255),
    creation_date DATE,
    country VARCHAR(255),
    dwh_create_date DATETIME2 DEFAULT GETDATE()

);
GO
PRINT 'Created silver.contacts table';

IF OBJECT_ID('silver.comp_cont', 'U') IS NOT NULL
    DROP TABLE silver.comp_cont;
GO

CREATE TABLE silver.comp_cont (
    k_company INT,
    k_contact VARCHAR(255),
    main_company BIT,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO
PRINT 'Created silver.comp_cont table';

IF OBJECT_ID('silver.articles', 'U') IS NOT NULL
    DROP TABLE silver.articles;
GO

CREATE TABLE silver.articles (
    k_article VARCHAR(10),
    family VARCHAR(255),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO
PRINT 'Created silver.articles table';

IF OBJECT_ID('silver.visits', 'U') IS NOT NULL
    DROP TABLE silver.visits;
GO

CREATE TABLE silver.visits (
    k_visit INT,
    f_company INT,
    f_contact VARCHAR(255),
    visit_date DATE,
    duration INT,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO
PRINT 'Created silver.visits table';

IF OBJECT_ID('silver.visit_results', 'U') IS NOT NULL
    DROP TABLE silver.visit_results;
GO

CREATE TABLE silver.visit_results (
    k_visit_result INT,
    f_visit INT,
    shortlisted_reference1 VARCHAR(10),
    shortlisted_reference2 VARCHAR(10),
    shortlisted_reference3 VARCHAR(10),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO
PRINT 'Created silver.visit_results table';

PRINT 'All silver layer tables created successfully';
GO
