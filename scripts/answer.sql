/*
===============================================================================
Question 1: What is the average number of references a contact shortlists?
Analysis Purpose:
    Calculate the average number of watch references that contacts typically 
    shortlist during sales visits to understand customer decision patterns.
    
Analysis Approach:
    - For each visit, count how many of the three shortlist slots are used
    - Calculate the average across all contacts
    - Multiplied by 1.0 to ensure decimal precision in averaging
===============================================================================
*/
SELECT 
    AVG(shortlist_count * 1.0) AS avg_shortlisted_references_per_contact
FROM (
    SELECT 
        contact_id,
        (CASE WHEN shortlist_article_1 IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN shortlist_article_2 IS NOT NULL THEN 1 ELSE 0 END +
         CASE WHEN shortlist_article_3 IS NOT NULL THEN 1 ELSE 0 END) AS shortlist_count
    FROM gold.fact_visits
) t;

SELECT * FROM gold.fact_visits

/*
===============================================================================
Question 2: Can we identify clients who only visit their main company?
Analysis Purpose:
    Identify loyal customers who exclusively conduct business with their 
    designated main company to understand customer loyalty patterns.
    
Analysis Approach:
    - Join visits with contact information to get main company designation
    - Count distinct companies visited by each contact
    - Filter for contacts who visited only one company AND that company matches their main company
    - This identifies truly loyal customers vs those who shop around
===============================================================================
*/
SELECT 
    dct.contact_id,
    dct.main_company,
    COUNT(DISTINCT fv.company_id) AS distinct_companies_visited
FROM gold.fact_visits fv
JOIN gold.dim_contacts dct 
    ON fv.contact_id = dct.contact_id  
GROUP BY 
    dct.contact_id,
    dct.main_company
HAVING 
    COUNT(DISTINCT fv.company_id) = 1
    AND MIN(fv.company_id) = dct.main_company;


/*
===============================================================================
Question 3: Which watch family is most commonly shortlisted per company?
Analysis Purpose:
    Identify the most popular watch family for each company to enable 
    targeted sales strategies and inventory planning.
    
Analysis Approach:
    - Unpivot the three shortlist columns into a single list of articles
    - Join with articles dimension to get family information
    - Count occurrences of each family per company
    - Use window function to rank families within each company
    - Select only the top-ranked (most popular) family per company
===============================================================================
*/
WITH ranked_families AS (
    SELECT 
        f.company_id,
        da.family,
        COUNT(*) AS shortlist_count,
        ROW_NUMBER() OVER (PARTITION BY f.company_id ORDER BY COUNT(*) DESC) as rank
    FROM (
        SELECT company_id, shortlist_article_1 AS article_id FROM gold.fact_visits WHERE shortlist_article_1 IS NOT NULL
        UNION ALL
        SELECT company_id, shortlist_article_2 AS article_id FROM gold.fact_visits WHERE shortlist_article_2 IS NOT NULL
        UNION ALL
        SELECT company_id, shortlist_article_3 AS article_id FROM gold.fact_visits WHERE shortlist_article_3 IS NOT NULL
    ) AS f
    LEFT JOIN gold.dim_articles AS da ON f.article_id = da.article_id
    GROUP BY f.company_id, da.family
)
SELECT 
    company_id,
    family,
    shortlist_count
FROM ranked_families
WHERE rank = 1
ORDER BY company_id, shortlist_count DESC;
