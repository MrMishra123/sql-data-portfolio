
--   1. CREATE STAGING TABLE
  

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT INTO layoffs_staging
SELECT *
FROM layoffs;



--   2. REMOVE DUPLICATES
   

WITH duplicate_cte AS (
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry,
total_laid_off, percentage_laid_off,
date, stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging
)

DELETE
FROM duplicate_cte
WHERE row_num > 1;



--   3. TRIM COMPANY NAMES
  

UPDATE layoffs_staging
SET company = TRIM(company);



--   4. STANDARDIZE INDUSTRY
   

UPDATE layoffs_staging
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';



--   5. CLEAN COUNTRY COLUMN


UPDATE layoffs_staging
SET country = TRIM(TRAILING '.' FROM country);


/* ===============================
   6. FIX DATE FORMAT
   =============================== */

UPDATE layoffs_staging
SET date = STR_TO_DATE(date,'%m/%d/%Y');

ALTER TABLE layoffs_staging
MODIFY COLUMN date DATE;



--   7. FILL NULL INDUSTRY VALUES
   

UPDATE layoffs_staging t1
JOIN layoffs_staging t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;



--   8. REMOVE USELESS ROWS
   

DELETE
FROM layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;



--   9. CREATE FINAL CLEAN TABLE
   

CREATE TABLE layoffs_clean AS
SELECT *
FROM layoffs_staging;
