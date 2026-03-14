-- ==========================================
-- PROJECT: Advanced Trend Analysis
-- Dataset: layoffs.csv
-- Objective: - a) Analyzing layoff trends over time
                b) Measuring cumulative workforce impact
                c) Ranking companies within industries
                d) Comparing year-over-year layoff patterns
                e) Calculating industry contribution per year 
-- ==========================================

-- 1️⃣ Monthly Layoffs with Cumulative Total

WITH monthly_layoffs AS (
    SELECT 
        DATE_FORMAT(date, '%Y-%m') AS month,
        SUM(total_laid_off) AS total_layoffs
    FROM layoffs_staging
    GROUP BY DATE_FORMAT(date, '%Y-%m')
)

SELECT 
    month,
    total_layoffs,
    SUM(total_layoffs) OVER (ORDER BY month) AS cumulative_layoffs
FROM monthly_layoffs;



-- 2️⃣ Ranking Companies Within Each Industry (PARTITION BY)

WITH company_industry_totals AS (
    SELECT 
        industry,
        company,
        SUM(total_laid_off) AS total_layoffs
    FROM layoffs_staging
    GROUP BY industry, company
)

SELECT 
    industry,
    company,
    total_layoffs,
    RANK() OVER (
        PARTITION BY industry 
        ORDER BY total_layoffs DESC
    ) AS industry_rank
FROM company_industry_totals;



-- 3️⃣ Year-wise Layoffs Per Company with Previous Year Comparison

WITH yearly_company_layoffs AS (
    SELECT 
        company,
        YEAR(date) AS year,
        SUM(total_laid_off) AS yearly_layoffs
    FROM layoffs_staging
    GROUP BY company, YEAR(date)
)

SELECT 
    company,
    year,
    yearly_layoffs,
    LAG(yearly_layoffs) OVER (
        PARTITION BY company
        ORDER BY year
    ) AS previous_year_layoffs
FROM yearly_company_layoffs;



-- 4️⃣ Industry Contribution Percentage Per Year

WITH yearly_industry AS (
    SELECT 
        YEAR(date) AS year,
        industry,
        SUM(total_laid_off) AS total_layoffs
    FROM layoffs_staging
    GROUP BY YEAR(date), industry
)

SELECT 
    year,
    industry,
    total_layoffs,
    ROUND(
        total_layoffs * 100.0 /
        SUM(total_layoffs) OVER (PARTITION BY year),
        2
    ) AS percentage_of_year_total
FROM yearly_industry
ORDER BY year, percentage_of_year_total DESC;
