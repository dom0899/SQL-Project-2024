-- SQL Project



-- views payroll
 


CREATE VIEW v_payroll_by_category AS 
SELECT 	
	name AS category_name,
	round(avg(value), 2) AS average_salary_by_category,
	payroll_year AS rok,
	industry_branch_code AS category_code
FROM czechia_payroll 
JOIN czechia_payroll_industry_branch  
	ON czechia_payroll.industry_branch_code = czechia_payroll_industry_branch.code 
WHERE value_type_code = '5958'
GROUP BY industry_branch_code, payroll_year, name 
ORDER BY payroll_year;

 
CREATE VIEW v_payroll AS 
SELECT 
	payroll_year AS rok,
	round(avg(value), 2) AS average_salary
FROM czechia_payroll 
WHERE value_type_code = '5958'
GROUP BY payroll_year
ORDER BY payroll_year;


-- views prices

CREATE VIEW v_price_by_category AS
SELECT
		YEAR(date_from) AS rok,
		category_code,
		CONCAT(name, '   ', price_unit) AS category_name,
		AVG(value) AS average_price_by_category
FROM czechia_price
INNER JOIN czechia_price_category
      ON czechia_price.category_code = czechia_price_category.code
WHERE YEAR(date_from) BETWEEN 2006 AND 2018 AND YEAR(date_to) BETWEEN 2006 AND 2018
GROUP BY rok, category_code, name
ORDER BY rok;




CREATE VIEW v_price AS
SELECT
		YEAR(date_from) AS rok,
		AVG(value) AS average_price
FROM czechia_price
WHERE YEAR(date_from) BETWEEN 2006 AND 2018 AND YEAR(date_to) BETWEEN 2006 AND 2018
GROUP BY rok
ORDER BY rok;

-- view GDP

CREATE VIEW v_gdp AS 
SELECT	
	year,
	country,
	GDP
FROM economies e 
WHERE country LIKE '%czech%' AND year BETWEEN 2006 AND 2018
ORDER BY year;










-- Vytvoření tabulky t_dominik_drazan_project_SQL_primary_final

CREATE TABLE t_dominik_drazan_project_SQL_primary_final AS 
	SELECT 
		cpc.name AS food_category,
		cp.value AS food_price,
		cpay.value AS average_salary,
		cpay.payroll_year AS 'year',
		cpib.name AS industry
	FROM czechia_price cp 
	JOIN czechia_payroll cpay
		ON cpay.payroll_year = year(cp.date_from)
		AND cpay.value_type_code = 5958 
		AND cp.region_code IS NULL 
	JOIN czechia_price_category cpc 
		ON cp.category_code = cpc.code
	JOIN czechia_payroll_industry_branch cpib 
		ON cpay.industry_branch_code = cpib.code;





-- Vytvoření tabulky t_dominik_drazan_project_SQL_secondary_final 




	
CREATE TABLE t_dominik_drazan_project_SQL_secondary_final AS (
	SELECT hc.country AS territory, 
		 	hc.continent AS main_territory,
		 	he.GDP,
		 	he.`year`,
		 	he.population,
		 	he.gini
	FROM (
				SELECT 	
					country, 
					GDP,
					`year`,
					population,
					gini 
				FROM economies e
				WHERE `year` BETWEEN 2006 AND 2018)he
	LEFT JOIN (
				SELECT 
				country,
				continent 
			FROM countries c
			WHERE continent = 'Europe')hc
		ON he.country = hc.country);
			

	
	
	
	

-- Sada SQL dotazů na VÝZKUMNÉ OTÁZKY	

	

	
-- 1) Rostou v průběhu let mzdy ve všech odvětvích,
--  nebo v některých klesají?	
	


SELECT 
	s_2006.industry,
	avg(s_2006.average_salary_2006) AS avg_salary_2006,
	avg(s_2008.average_salary_2008) AS avg_salary_2008,
	avg(s_2010.average_salary_2010) AS avg_salary_2010,
	avg(s_2012.average_salary_2012) AS avg_salary_2012,
	avg(s_2014.average_salary_2014) AS avg_salary_2014,
	avg(s_2018.average_salary_2018) AS avg_salary_2018,
CASE WHEN avg(s_2018.average_salary_2018) > avg(s_2014.average_salary_2014) THEN 'increased_in_2018'
		WHEN avg(s_2014.average_salary_2014) > avg(s_2012.average_salary_2012) THEN 'increased_in_2014'
		WHEN avg(s_2012.average_salary_2012) > avg(s_2010.average_salary_2010) THEN 'increased_in_2012'
		WHEN avg(s_2010.average_salary_2010) > avg(s_2008.average_salary_2008) THEN 'increased_in_2010'
		WHEN avg(s_2008.average_salary_2008) > avg(s_2006.average_salary_2006) THEN 'increased_in_2008'
		ELSE 'reduced'
		END AS 'course of years'
FROM (			
			SELECT DISTINCT industry,
					average_salary AS average_salary_2006, 
					`year` 
			FROM t_dominik_drazan_project_sql_primary_final pfl
			WHERE YEAR = '2006') s_2006
LEFT JOIN (
			SELECT DISTINCT industry,
								average_salary AS average_salary_2008, 
								`year` 
						FROM t_dominik_drazan_project_sql_primary_final pfl
						WHERE YEAR = '2008') s_2008
	ON s_2006.industry = s_2008.industry
LEFT JOIN (
			SELECT DISTINCT industry,
								average_salary AS average_salary_2010, 
								`year` 
						FROM t_dominik_drazan_project_sql_primary_final pfl
						WHERE YEAR = '2010') s_2010
	ON s_2008.industry = s_2010.industry
LEFT JOIN (
			SELECT DISTINCT industry,
								average_salary AS average_salary_2012, 
								`year` 
						FROM t_dominik_drazan_project_sql_primary_final pfl
						WHERE YEAR = '2012') s_2012
	ON s_2010.industry = s_2012.industry
LEFT JOIN (
			SELECT DISTINCT industry,
								average_salary AS average_salary_2014, 
								`year` 
						FROM t_dominik_drazan_project_sql_primary_final pfl
						WHERE YEAR = '2014') s_2014
	ON s_2012.industry = s_2014.industry
LEFT JOIN (
			SELECT DISTINCT industry,
								average_salary AS average_salary_2018, 
								`year` 
						FROM t_dominik_drazan_project_sql_primary_final pfl
						WHERE YEAR = '2018') s_2018
	ON s_2014.industry = s_2018.industry
GROUP BY s_2006.`year`,
		s_2006.industry;


	
-- vytvořeny indexy pro rychlejší spuštění dotazu



