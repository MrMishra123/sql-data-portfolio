-- 1. Create Table

CREATE TABLE layoffs_raw (
company TEXT,
location TEXT,
industry TEXT,
total_laid_off INT,
percentage_laid_off TEXT,
date TEXT,
stage TEXT,
country TEXT
);

-- 2. Remove Duplicates using ROW_NUMBER()

WITH duplicates AS (
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off
ORDER BY company
) AS rn
FROM layoffs_raw
)

DELETE
FROM duplicates
WHERE rn > 1;


-- 3. Standardize Text

UPDATE layoffs_raw
SET country = 'United States'
WHERE country LIKE 'United States%';


-- 4. TRIM SPACES

UPDATE layoffs_raw
SET company = TRIM(company);


-- 5. Fix Date Format

UPDATE layoffs_raw
SET date = STR_TO_DATE(date,'%m/%d/%Y');


-- 6. Remove Rows With No Information

UPDATE layoffs_raw
SET industry = 'Unknown'
WHERE industry IS NULL;


-- 7. Final Clean Table

CREATE TABLE layoffs_clean AS
SELECT *
FROM layoffs_raw;


