/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/
-- ====================================================================
-- Checking 'silver.companies'
-- ====================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT k_company, COUNT(*) 
FROM silver.companies
GROUP BY k_company
HAVING COUNT(*)>1

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT 
    name,country 
FROM silver.companies
WHERE name != TRIM(name) AND country != TRIM(country);


-- ====================================================================
-- Checking 'silver.contacts'
-- ====================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT k_contact, COUNT(*) 
FROM silver.contacts
GROUP BY k_contact
HAVING COUNT(*)>1

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT 
    country 
FROM silver.contacts
WHERE country != TRIM(country);

-- Check for Invalid date ranges
-- Expectation: No Results
SELECT creation_date 
FROM silver.contacts
WHERE creation_date > '2023-12-31' 
    OR creation_date < '2023-01-01';
-- ====================================================================
-- Checking 'silver.comp_cont'
-- ====================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT k_company, k_contact, COUNT(*) AS duplicate_count
FROM silver.comp_cont
GROUP BY k_company, k_contact
HAVING COUNT(*) > 1;

-- Check for Data standardization and consistency
-- Expectation: No Results
SELECT DISTINCT main_company
FROM silver.comp_cont;

-- Check for Data consistency between related fields
-- Expectation: No Results
SELECT cc.*, c.k_company
FROM silver.comp_cont cc
LEFT JOIN silver.companies c
    ON cc.k_company = c.k_company
WHERE c.k_company IS NULL;

SELECT cc.*
FROM silver.comp_cont cc
LEFT JOIN silver.contacts ct
    ON cc.k_contact = ct.k_contact
WHERE ct.k_contact IS NULL;

-- ====================================================================
-- Checking 'silver.visit_results'
-- ====================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT k_visit_result, COUNT(*) 
FROM silver.visit_results
GROUP BY k_visit_result
HAVING COUNT(*)>1;

-- ====================================================================
-- Checking 'silver.visit_articles'
-- ====================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT k_article, COUNT(*) 
FROM silver.articles
GROUP BY k_article
HAVING COUNT(*)>1;


-- ====================================================================
-- Checking 'silver.visits'
-- ====================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT k_visit, COUNT(*) 
FROM silver.visits
GROUP BY k_visit
HAVING COUNT(*)>1;

-- Check for Invalid date ranges
-- Expectation: No Results
SELECT * FROM
(SELECT
		k_visit,
		f_company,
		f_contact,
		visit_date,
		CASE 
            WHEN visit_date <= GETDATE() THEN 1 
            ELSE 0 
        END as is_valid,
		duration
FROM silver.visits) AS t
WHERE is_valid = 1
  AND visit_date > GETDATE();

