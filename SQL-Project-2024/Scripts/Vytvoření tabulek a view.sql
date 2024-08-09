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























