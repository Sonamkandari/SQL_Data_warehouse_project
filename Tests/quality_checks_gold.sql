
/*
=====================================================
Quality Checks – Gold Layer
=====================================================

Script Purpose:
This script performs quality checks to validate the integrity,
consistency, and accuracy of the Gold Layer. These checks ensure:

- Uniqueness of surrogate keys in dimension tables
- Referential integrity between fact and dimension tables
- Validity of relationships in the star schema for analytics

Usage Notes:
- Run after Silver → Gold transformations are completed
- Any returned rows indicate data quality issues that must be resolved
=====================================================
*/

-----------------------------------------------------
-- Checking 'gold.dim_customers'
-----------------------------------------------------
-- Check for uniqueness of customer_key
-- Expectation: No results
SELECT
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;


-----------------------------------------------------
-- Checking 'gold.dim_products'
-----------------------------------------------------
-- Check for uniqueness of product_key
-- Expectation: No results
SELECT
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;


-----------------------------------------------------
-- Checking 'gold.fact_sales' → Dimensional Connectivity
-----------------------------------------------------
-- Check for orphan records between fact and dimensions
-- Expectation: No results
SELECT
    f.*
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
WHERE c.customer_key IS NULL
   OR p.product_key IS NULL;


-----------------------------------------------------
-- Optional: Null Checks on Critical Fact Columns
-----------------------------------------------------
-- Expectation: No results
SELECT *
FROM gold.fact_sales
WHERE customer_key IS NULL
   OR product_key IS NULL
   OR order_date IS NULL;


-----------------------------------------------------
-- Optional: Row Count Sanity Checks
-----------------------------------------------------
-- Compare Silver vs Gold volumes (manual review)
SELECT 'silver.crm_sales_details' AS table_name, COUNT(*) AS row_count
FROM silver.crm_sales_details
UNION ALL
SELECT 'gold.fact_sales', COUNT(*)
FROM gold.fact_sales;
