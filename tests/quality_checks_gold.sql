/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency, 
    and accuracy of the Gold Layer. These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'gold.dim_companies'
-- ====================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results 
SELECT 
    company_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_companies
GROUP BY company_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.dim_contacts'
-- ====================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results 
SELECT 
    contact_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_contacts
GROUP BY contact_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.dim_articles'
-- ====================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results 
SELECT 
    article_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_articles
GROUP BY article_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.dim_date'
-- ====================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results 
SELECT 
    date_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_date
GROUP BY date_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.fact_visits'
-- ====================================================================
-- Check the data model connectivity between fact and dimensions
SELECT *
FROM gold.fact_visits f
LEFT JOIN gold.dim_companies dc
    ON f.company_id = dc.company_id
LEFT JOIN gold.dim_contacts dct
    ON f.contact_id = dct.contact_id
LEFT JOIN gold.dim_date dd
    ON f.date = dd.date
LEFT JOIN gold.dim_articles da1
    ON f.shortlist_article_1 = da1.article_id
LEFT JOIN gold.dim_articles da2
    ON f.shortlist_article_2 = da2.article_id
LEFT JOIN gold.dim_articles da3
    ON f.shortlist_article_3 = da3.article_id
WHERE dc.company_id IS NULL
   OR dct.contact_id IS NULL
   OR dd.date IS NULL
   OR (f.shortlist_article_1 IS NOT NULL AND da1.article_id IS NULL)
   OR (f.shortlist_article_2 IS NOT NULL AND da2.article_id IS NULL)
   OR (f.shortlist_article_3 IS NOT NULL AND da3.article_id IS NULL);
