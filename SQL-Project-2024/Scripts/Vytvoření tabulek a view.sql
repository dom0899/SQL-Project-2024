-- SQL Project



-- views payroll
 


CREATE VIEW v_payroll_by_category AS 
SELECT 	
	name AS category_name,
	round(avg(value), 2) AS average_salary_by_category,
	payroll_year AS 'year',
	industry_branch_code AS category_code
FROM czechia_payroll 
JOIN czechia_payroll_industry_branch  
	ON czechia_payroll.industry_branch_code = czechia_payroll_industry_branch.code 
WHERE value_type_code = '5958'
GROUP BY industry_branch_code, payroll_year, name 
ORDER BY payroll_year;


 
CREATE VIEW v_payroll AS 
SELECT 
	payroll_year AS 'year',
	round(avg(value), 2) AS average_salary
FROM czechia_payroll 
WHERE value_type_code = '5958'
GROUP BY payroll_year
ORDER BY payroll_year;


-- views prices

CREATE VIEW v_price_by_category AS
SELECT
		YEAR(date_from) AS 'year',
		category_code,
		CONCAT(name, '   ', price_unit) AS category_name,
		AVG(value) AS average_price_by_category
FROM czechia_price
INNER JOIN czechia_price_category
      ON czechia_price.category_code = czechia_price_category.code
WHERE YEAR(date_from) BETWEEN 2006 AND 2018 AND YEAR(date_to) BETWEEN 2006 AND 2018
GROUP BY 'year', category_code, name
ORDER BY 'year';




CREATE VIEW v_price AS
SELECT
		YEAR(date_from) AS 'year',
		AVG(value) AS average_price
FROM czechia_price
WHERE YEAR(date_from) BETWEEN 2006 AND 2018 AND YEAR(date_to) BETWEEN 2006 AND 2018
GROUP BY 'year'
ORDER BY 'year';

-- view GDP

CREATE VIEW v_gdp AS 
SELECT	
	year,
	country,
	GDP
FROM economies e 
WHERE country LIKE '%czech%' AND year BETWEEN 2006 AND 2018
ORDER BY year;




















