# SQL-Project 
<small>*ENGETO - DATA ACADEMY*</small> 

-------------------------------------------------------------------------------------------
*V projektu se zabývám životní úrovní občanů. Odpovídám tu na 5 výzkumných otázek, které se týkají dostupností základních potravin široké veřejnosti a průměrných příjmů za určité časové období.* 


-------------------------------------------------------------------------------------------


*    První částí projektu je primární tabulka: ***t_dominik_drazan_project_sql_primary_final*** , kterou jsem vytvořil za účelem zjištění dostupností základních potravin. Poté k tomu byl vydefinován podklad příjmů k danému časovému období. Dále jsem do této primární tabulky spojil kategorie potravin a odvětví v průmyslu.

Pro získání vhodného datového podkladu jsem využil <u>*primární tabulky*</u>:
<mark>**czechia_payroll**</mark>, <mark>**czechia_price**</mark>, **<mark>czechia_price_category</mark>** a **<mark>czechia_payroll_industry_branch</mark>**.


*   Následně mnou byla vytvořena tabulka: ***t_dominik_drazan_project_SQL_secondary_final*** k určení HDP, GINI koeficientu, roku, populace a evropských států.

Po nahrání dat do nově vytvořené tabulky jsem použil data z <u>dodatečných tabulek</u>: **<mark>economies</mark>** a **<mark>countries</mark>**.

-------------------------------------------------------------------------------------------


<u>**Výzkumné Otázky**</u>

1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?

-------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------


<u>**Výstupní odpovědi na výzkumné otázky**</u>

1. Trend zvyšování mezd od roku 2006 do roku 2018 platí pro všechna odvětví. Nejrychleji vzrostly mzdy v informační a komunikační činnosti. Nejpomaleji v ubytování, stravování a pohostinství. U ojedinělých případech se kolísavým způsobem snižuje(např. v peněžnictví a pojišťovnictví). Platy mezi kraji jsou rozdílné. 
* [ ] U této otázky jsem přistupoval tak, že jsem si vnořenými dotazy pospojoval tabulky s jednotlivými roky. Přes klauzule **LEFT JOIN**.
Vložil jsem do vnořeného select klauzuli **DISTINCT**, která mi vyhledala pouze unikátní data.

* [ ] Nad tyto poddotazy jsem do **SELECTU** napsal odvětví a agregační funkci **AVG** za každý daný rok. K tomu funkci **CASE**, která mi vyhodnocovala, zda jsou roky předešlé slabší ve zvyšování mezd nebo silnější. Následně jsem roky a odvětví seskupil pomocí **GROUP by**. 

* [ ] V poslední řadě jsem vytvořil v tabulce t_dominik_drazan_project_sql_primary_final indexy, které mi urychlily proces spuštění dotazu.


-------------------------------------------------------------------------------------------

2. Dle mé analýzi si občané v průměru za rok 2006 koupili 1 437 litrů mléka a 1 287 kg chleba. Za rok 2018 si koupili 1 642 litrů mléka a 1 342 kg chleba.
* [ ] Postup k této otázce byl takový, že jsem si otevřel dotaz pomocí primární tabulky. 

* [ ] Do **SELECTU** jsem napsal názvy potravin. Poté samotné průměry mezd a cen potravin. Nakonec množství koupených druhů a rok.

* [ ] Množství bylo získáno vydělením průměrné mzdy cenou potravin.

* [ ] Dotaz byl omezen přes **WHERE**, kde jsem zadal požadované názvy a roky. To celé jsem seskupil skrze **GROUP BY**

-------------------------------------------------------------------------------------------

3. Nejnižší percentuální meziroční narůst proběhl u Rajských jablek červených kulatých. U této potraviny se cena pohybovala nejpomaleji. V letech 2007 a  2011.


* [ ] K odpovědi na otázku pomocí SQL dotazu jsem přistoupil takto.

* [ ] Nejdříve jsem si zjistil průměrný meziroční nárust cen potravin pomocí fuknce **AVG**.

* [ ] Použil jsem klauzuli **WITH** na spojení kategorií potravin s cenami a jeho názvu. Vytvořil jsem si dvě tabulky s nárustem cen potravin za dané roky. V druhé tabulce *i_last_year* jsem omezil příkazem **IS NOT NULL**, abych předešel nulovým záznamům. 

* [ ] Seskupil jsem kategorie potravin a roky díky **GROUP BY**.


* [ ] Výsledný dotaz byl k vyjádření kategorie potravin, roku, předchozího roku a společným výpočtem k získání potřebných dat k zjištění procentuálního nárustu potravin. Tabulky jsem spojil skrze **JOIN** přes kategorie potravin a roky.

* [ ] Nakonec jsem to celé seřadil dle procentuálního navýšení.

-------------------------------------------------------------------------------------------

4. Dle mých přezkoumaných dat jsem vyhodnotil, že v žádných těchto rocích od 2007 až do 2018 nedošlo k výraznému navýšení cen potravin, které by byly výrazně vyšší než růst mezd nad 10%.


* [ ] Nejvhodněji mi přišlo použít klauzuli **WITH**, které mi umožnilo vytvořit dvě dočasné tabulky *i_year* a *i_last_year*.

* [ ] Potřeboval jsem zjistit průměrnou cenu potravin a průměrnou mzdu. Přes agregační funkci **AVG** jsem k tomu došel.

* [ ] Do každé z této tabulek jsem dodal sloupec **year**. V tabulce *i_last_year* jsem přidal k **year** +1, aby mi z toho byl vytvořen meziroční rozdíl.

* [ ] Tabulky jsem omezil pomocí **WHERE**, kde jsem připsal k ceně potravin a mzdě, že nesmí být nula.

* [ ] Poté jsem roky seskupil přes **GROUP BY**.

* [ ] Ve výstupním **SELECTU** jsem tabulku *i_year* a *i_last_year* spojil díky **JOIN**. Nejvhodněji mi připadalo k úvahu najít spojení v rocích.

* [ ]Nad tímto spojením jsem vypsal rok a předešlý rok. K tomu jsem matematickým výpočtem odečetl od sebe průměrné ceny potravin a mzdy. To celé jsem vydělil cenou/mzdou, vynásobil 100 a celé zaokrouhlil pomocí funkce **ROUND**. Zjistilo mi to navýšení ceny potravin a mzdy(v %).

* [ ] Nakonec bylo potřeba vyfiltrovat výstupní data a to tím způsobem, že jsem použil funkci **CASE** a do ní jsem celé výpočty od sebe odečetl a za ně dal symbol **>**. Když to větší než tyto výpočty tak mi to mělo vypsat 'procentuální navýšení větší než 10'. Ostatní 'snížení pod 10'. Konec jsem popsal jako navýšení. 

-------------------------------------------------------------------------------------------

5. Po spuštění dotazu a při zobrazení výstupních dat jsem zjistil, že v některých letech byl vzrůst cen potravin a mezd ovlivněn vzrůstem HDP, ale ne výrazně. V dalších letech došlo k ovlivnění spíše poklesem HDP a to se pak projevovalo výrazněji než vzrůstem  cen potravin a mezd. Ve výsledném shrnutí je výše cen potravin a mezd ovlivněn poklesem HDP a při vrůstu HDP jen pouhým lehkým zvýšením cen potravin a mezd.

* [ ] U tohoto dotazu jsem využil klauzuli **WITH**. Ten pro mne byl velmi užitečným. Vytvořil jsem dočasné tabulky *i_year*, *i_last_year*, *i_year_GDP* a  *i_last_year_GDP*.

* [ ] Do těchto tabulek jsem skrz funkci **AVG** vypsal průměrnou cenu potravin, mezd a roků.

* [ ] U tabulek *i_last_year* a *i_last_year_GDP* jsem připsal k rokům +1 pro předešlý léta.

* [ ] Omezoval jsem u tabulek *i_year* a *i_last_year* přes WHERE průměrnou cenu potravin a průměrné mzdy. Další omezení proběhlo u tabulek *i_year_GDP* a *i_last_year_GDP*, kde jsem zadal, GDP nesmí být nula.

* [ ] Použil jsem vytvořený pohled s HDP a upravený ke zjištění, a to  jen u státu České republiky.

* [ ] Seskupil jsem u všech tabulek roky a ty předešlé.

* [ ] Ve výstupu jsem díky **JOIN** spojil všechny dané tabulky.
Sepsal jsem rok a ten předešlý. S funkcí **ROUND**, která mi tři výpočty s cenou potravin, mzdou a HDP zaokrouhlila. Odečetl jsem vždy průměrný rok s tím předešlým, vydělil s rokem a celé vynásobil 100 na výpočet procent.
