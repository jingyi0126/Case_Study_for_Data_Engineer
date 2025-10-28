/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/
-- =============================================================================
-- Create Dimension: gold.dim_companies
-- =============================================================================
IF OBJECT_ID('gold.dim_companies', 'V') IS NOT NULL
    DROP VIEW gold.dim_companies;
GO

CREATE VIEW gold.dim_companies AS
SELECT
    ROW_NUMBER() OVER (ORDER BY k_company) AS company_key,    -- surrogate key
    k_company                              AS company_id,
    name                                   AS company_name,
    country                                AS contry  
FROM silver.companies

GO
-- =============================================================================
-- Create Dimension: gold.dim_contacts
-- =============================================================================
IF OBJECT_ID('gold.dim_contacts', 'V') IS NOT NULL
    DROP VIEW gold.dim_contacts;
GO

CREATE VIEW gold.dim_contacts AS
SELECT
    ROW_NUMBER() OVER (ORDER BY ct.k_contact) AS contact_key,    -- surrogate key
    ct.k_contact                              AS contact_id,
    ct.country                                AS contact_country,
    ct.creation_date,
    cc.k_company                              AS main_company
FROM silver.contacts AS ct
LEFT JOIN silver.comp_cont AS cc
    ON ct.k_contact = cc.k_contact AND cc.main_company = 1;

GO
-- =============================================================================
-- Create Dimension: gold.dim_articles
-- =============================================================================
IF OBJECT_ID('gold.dim_articles', 'V') IS NOT NULL
    DROP VIEW gold.dim_articles;
GO

CREATE VIEW gold.dim_articles AS
SELECT
    ROW_NUMBER() OVER (ORDER BY k_article) AS article_key,    -- surrogate key
    k_article                              AS article_id,
    family
FROM silver.articles;

GO
-- =============================================================================
-- Create Dimension: gold.dim_date
-- =============================================================================
IF OBJECT_ID('gold.dim_date', 'V') IS NOT NULL
    DROP VIEW gold.dim_date;
GO

CREATE VIEW gold.dim_date AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY d.full_date) AS date_key,    -- surrogate key
    d.full_date                              AS date,
    YEAR(d.full_date)                        AS year,
    MONTH(d.full_date)                       AS month,
    DATENAME(MONTH, d.full_date)             AS month_name,
    DATEPART(QUARTER, d.full_date)           AS quarter,
    DATEPART(WEEKDAY, d.full_date)           AS weekday_number,
    DATENAME(WEEKDAY, d.full_date)           AS weekday_name
FROM (
    SELECT visit_date AS full_date
    FROM silver.visits
    UNION
    SELECT creation_date
    FROM silver.contacts
) AS d
WHERE d.full_date IS NOT NULL;
-- =============================================================================
-- Create Dimension: gold.fact_visits
-- =============================================================================
IF OBJECT_ID('gold.fact_visits', 'V') IS NOT NULL
    DROP VIEW gold.fact_visits;
GO

CREATE VIEW gold.fact_visits AS
SELECT
    ROW_NUMBER() OVER (ORDER BY v.k_visit) AS visit_key,    -- surrogate key
    v.k_visit                              AS visit_id,
    COALESCE(dc.company_id, -1)            AS company_id,
    dct.contact_id                         AS contact_id,
    dd.date                                AS date,
    v.duration                             AS visit_duration,
    da1.article_id                         AS shortlist_article_1,
    da2.article_id                         AS shortlist_article_2,
    da3.article_id                         AS shortlist_article_3

FROM silver.visits AS v
LEFT JOIN gold.dim_companies AS dc 
    ON v.f_company = dc.company_id
LEFT JOIN gold.dim_contacts AS dct 
    ON v.f_contact = dct.contact_id
LEFT JOIN silver.visit_results AS vr
    ON v.k_visit = vr.f_visit

LEFT JOIN gold.dim_date AS dd 
    ON v.visit_date = dd.date


LEFT JOIN gold.dim_articles AS da1 
    ON vr.shortlisted_reference1 = da1.article_id
LEFT JOIN gold.dim_articles AS da2 
    ON vr.shortlisted_reference2 = da2.article_id
LEFT JOIN gold.dim_articles AS da3 
    ON vr.shortlisted_reference3 = da3.article_id
