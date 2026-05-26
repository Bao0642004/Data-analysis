SELECT * FROM covid19;

UPDATE covid19
SET population = (
    SELECT TOP 1 population
    FROM covid19
	 WHERE population IS NOT NULL
    GROUP BY population
    ORDER BY COUNT(*) DESC
)
WHERE population IS NULL;

UPDATE covid19
SET continent = (
    SELECT TOP 1 continent
    FROM covid19
	 WHERE continent IS NOT NULL
    GROUP BY continent
    ORDER BY COUNT(*) DESC
)
WHERE population IS NULL;


UPDATE covid19
SET cases_new = (
    SELECT TOP 1 cases_new
    FROM covid19
    WHERE cases_new IS NOT NULL
    GROUP BY cases_new
    ORDER BY COUNT(*) DESC
)
WHERE cases_new IS NULL;

UPDATE covid19
SET cases_critical = (
    SELECT TOP 1 cases_critical
    FROM covid19
    WHERE cases_critical IS NOT NULL
    GROUP BY cases_critical
    ORDER BY COUNT(*) DESC
)
WHERE cases_critical IS NULL;

UPDATE covid19
SET cases_recovered = (
    SELECT TOP 1 cases_recovered
    FROM covid19
    WHERE cases_recovered IS NOT NULL
    GROUP BY cases_recovered
    ORDER BY COUNT(*) DESC
)
WHERE cases_recovered IS NULL;


UPDATE covid19
SET deaths_new = (
    SELECT TOP 1 deaths_new 
    FROM covid19
    WHERE deaths_new  IS NOT NULL
    GROUP BY deaths_new 
    ORDER BY COUNT(*) DESC
)
WHERE deaths_new  IS NULL;

UPDATE covid19
SET deaths_1M_pop = (
    SELECT TOP 1 deaths_1M_pop
    FROM covid19
    WHERE deaths_1M_pop IS NOT NULL
    GROUP BY deaths_1M_pop
    ORDER BY COUNT(*) DESC
)
WHERE deaths_1M_pop IS NULL;

UPDATE covid19
SET deaths_total = (
    SELECT TOP 1  deaths_total 
    FROM covid19
    WHERE  deaths_total  IS NOT NULL
    GROUP BY deaths_total 
    ORDER BY COUNT(*) DESC
)
WHERE  deaths_total  IS NULL;

UPDATE covid19
SET tests_1M_pop = (
    SELECT TOP 1   tests_1M_pop 
    FROM covid19
    WHERE   tests_1M_pop  IS NOT NULL
    GROUP BY  tests_1M_pop 
    ORDER BY COUNT(*) DESC
)
WHERE  tests_1M_pop  IS NULL;

UPDATE covid19
SET tests_total = (
    SELECT TOP 1   tests_total  
    FROM covid19
    WHERE   tests_total   IS NOT NULL
    GROUP BY  tests_total 
    ORDER BY COUNT(*) DESC
)
WHERE  tests_total  IS NULL;
/*
WITH CTE
AS
(	--mean
	SELECT AVG(cases_active) AS sleep
	FROM covid19Vietnam
	UNION 
	--mode
	select Top 1 cases_active
	from covid19Vietnam
	group by cases_active
	Order by count(*) desc
	UNION
	--median
	SELECT AVG(cases_active)
	FROM covid19Vietnam
	WHERE Index IN (500,501)
)
update covid19Vietnam
set cases_active = (SELECT MIN(cases_active) FROM CTE)
Where cases_active is null*/

WITH CTE AS
(
    -- Median calculation for even or odd number of rows
    SELECT AVG(cases_active * 1.0) AS value
    FROM (
        SELECT cases_active,
               ROW_NUMBER() OVER (ORDER BY cases_active) AS row_num,
               COUNT(*) OVER () AS total_rows
        FROM covid19
        WHERE cases_active IS NOT NULL
    ) AS ranked
    WHERE row_num IN ((total_rows / 2), (total_rows / 2) + 1)
)
UPDATE covid19
SET cases_active = (SELECT value FROM CTE)
WHERE cases_active IS NULL;

WITH CTE AS (
    SELECT TOP 1 continent, COUNT(*) AS continent_count
    FROM covid19
    WHERE continent IS NOT NULL
    GROUP BY continent
    ORDER BY continent_count DESC
)
UPDATE covid19
SET continent = (SELECT continent FROM CTE)
WHERE continent IS NULL;


WITH CTE AS
(
    -- Median calculation for even or odd number of rows
    SELECT AVG(cases_new * 1.0) AS value
    FROM (
        SELECT cases_new,
               ROW_NUMBER() OVER (ORDER BY cases_active) AS row_num,
               COUNT(*) OVER () AS total_rows
        FROM covid19
        WHERE cases_new IS NOT NULL
    ) AS ranked
    WHERE row_num IN ((total_rows / 2), (total_rows / 2) + 1)
)
UPDATE covid19
SET cases_new = (SELECT value FROM CTE)
WHERE cases_new IS NULL;
 
 SELECT * FROM covid19;

 WITH CTE AS
(
    -- Median calculation for even or odd number of rows
    SELECT AVG( cases_total * 1.0) AS value
    FROM (
        SELECT  cases_total,
               ROW_NUMBER() OVER (ORDER BY cases_active) AS row_num,
               COUNT(*) OVER () AS total_rows
        FROM covid19
        WHERE   cases_total IS NOT NULL
    ) AS ranked
    WHERE row_num IN ((total_rows / 2), (total_rows / 2) + 1)
)
UPDATE covid19
SET  cases_total = (SELECT value FROM CTE)
WHERE  cases_total IS NULL;


 WITH CTE AS
(
    -- Median calculation for even or odd number of rows
    SELECT AVG( tests_1M_pop * 1.0) AS value
    FROM (
        SELECT  tests_1M_pop,
               ROW_NUMBER() OVER (ORDER BY cases_active) AS row_num,
               COUNT(*) OVER () AS total_rows
        FROM covid19
        WHERE   tests_1M_pop IS NOT NULL
    ) AS ranked
    WHERE row_num IN ((total_rows / 2), (total_rows / 2) + 1)
)
UPDATE covid19
SET  tests_1M_pop = (SELECT value FROM CTE)
WHERE  tests_1M_pop IS NULL;

WITH CTE AS (
    SELECT day, time, deaths_total, AVG(deaths_new) As TB
    FROM covid19
    GROUP BY day, time, deaths_total
)
UPdate covid19
SET deaths_new  = (select top 1 TB from CTE INNER join covid19 X on X.day=CTE.day and
						X.time = CTE.time 
						ANd X.deaths_total = CTE.deaths_total )
WHERE deaths_new IS NULL;

WITH CTE AS (
    SELECT country, time, cases_new, AVG(cases_critical) AS TB
    FROM covid19
    GROUP BY country, time, cases_new
)
UPDATE covid19
SET cases_critical = (
    SELECT TOP 1 TB
    FROM CTE
    INNER JOIN covid19 X 
        ON X.country = CTE.country 
        AND X.time = CTE.time
        AND X.cases_new = CTE.cases_new
    ORDER BY X.time 
)
WHERE cases_critical IS NULL;

SELECT * FROM covid19;


With CTE500A
AS(
SELECT top 500 cases_new 
from covid19
Group by  cases_new 
)
SELECT top 1 cases_new 
from CTE500A
ORDER BY cases_new 


With CTE500A
AS(
SELECT top 500 continent 
from covid19
Group by  continent 
)
SELECT top 1 continent 
from CTE500A
ORDER BY continent 


With CTE500A
AS(
SELECT top 500 cases_active
from covid19
Group by  cases_active 
)
SELECT top 1 cases_active
from CTE500A
ORDER BY cases_active 


SELECT 
    MIN(cases_new) AS Min_Work_Hours, 
    MAX(cases_new) AS Max_Work_Hours
FROM covid19;

SELECT 
    MIN(cases_active) AS Min_Work_Hours, 
    MAX(cases_active) AS Max_Work_Hours
FROM covid19;

SELECT 
    MIN(cases_critical) AS Min_Work_Hours, 
    MAX(cases_critical) AS Max_Work_Hours
FROM covid19;

SELECT 
    MIN(cases_recovered) AS Min_Work_Hours, 
    MAX(cases_recovered) AS Max_Work_Hours
FROM covid19;

SELECT 
    MIN(cases_1M_pop) AS Min_Work_Hours, 
    MAX(cases_1M_pop) AS Max_Work_Hours
FROM covid19;
 
SELECT 
    MIN(cases_total) AS Min_Work_Hours, 
    MAX(cases_total) AS Max_Work_Hours
FROM covid19;

SELECT 
    MIN(deaths_new) AS Min_Work_Hours, 
    MAX(deaths_new) AS Max_Work_Hours
FROM covid19;

SELECT 
    MIN(deaths_1M_pop) AS Min_Work_Hours, 
    MAX(cases_1M_pop) AS Max_Work_Hours
FROM covid19;

SELECT 
    MIN(deaths_total) AS Min_Work_Hours, 
    MAX(deaths_total) AS Max_Work_Hours
FROM covid19;

SELECT 
    MIN(population) AS Min_Work_Hours, 
    MAX(population) AS Max_Work_Hours
FROM covid19;

SELECT 
    MIN(tests_1M_pop) AS Min_Work_Hours, 
    MAX(tests_1M_pop) AS Max_Work_Hours
FROM covid19;

SELECT 
    MIN( continent) AS Min_Work_Hours, 
    MAX( continent) AS Max_Work_Hours
FROM covid19;


SELECT 
    MIN(tests_total) AS Min_Work_Hours, 
    MAX(tests_total) AS Max_Work_Hours
FROM covid19;

select * from covid19;

UPDATE covid19
SET cases_new = 
    CASE 
        WHEN cases_new < (SELECT MIN(cases_new) FROM covid19) THEN (SELECT MIN(cases_new) FROM covid19)
        WHEN cases_new > (SELECT MAX(cases_new) FROM covid19) THEN (SELECT MAX(cases_new) FROM covid19)
        ELSE cases_new
    END

UPDATE covid19
SET cases_active = 
    CASE 
        WHEN cases_active < (SELECT MIN(cases_active) FROM covid19) THEN (SELECT MIN(cases_active) FROM covid19)
        WHEN cases_active > (SELECT MAX(cases_active) FROM covid19) THEN (SELECT MAX(cases_active) FROM covid19)
        ELSE cases_active
    END;

UPDATE covid19
SET  continent = 
    CASE 
        WHEN  continent < (SELECT MIN( continent) FROM covid19) THEN (SELECT MIN( continent) FROM covid19)
        WHEN  continent > (SELECT MAX( continent) FROM covid19) THEN (SELECT MAX( continent) FROM covid19)
        ELSE  continent
    END;


UPDATE covid19
SET cases_critical = 
    CASE 
        WHEN cases_critical < (SELECT MIN(cases_critical) FROM covid19) THEN (SELECT MIN(cases_critical) FROM covid19)
        WHEN cases_critical > (SELECT MAX(cases_critical) FROM covid19) THEN (SELECT MAX(cases_critical) FROM covid19)
        ELSE cases_critical
    END;
	
UPDATE covid19
SET cases_recovered = 
    CASE 
        WHEN cases_recovered < (SELECT MIN(cases_recovered) FROM covid19) THEN (SELECT MIN(cases_recovered) FROM covid19)
        WHEN cases_recovered > (SELECT MAX(cases_recovered) FROM covid19) THEN (SELECT MAX(cases_recovered) FROM covid19)
        ELSE cases_recovered
    END;

UPDATE covid19
SET cases_1M_pop = 
    CASE 
        WHEN cases_1M_pop < (SELECT MIN(cases_1M_pop) FROM covid19) THEN (SELECT MIN(cases_1M_pop) FROM covid19)
        WHEN cases_1M_pop > (SELECT MAX(cases_1M_pop) FROM covid19) THEN (SELECT MAX(cases_1M_pop) FROM covid19)
        ELSE cases_1M_pop
    END;

	
UPDATE covid19
SET cases_total = 
    CASE 
        WHEN cases_total < (SELECT MIN(cases_total) FROM covid19) THEN (SELECT MIN(cases_total) FROM covid19)
        WHEN cases_total > (SELECT MAX(cases_total) FROM covid19) THEN (SELECT MAX(cases_total) FROM covid19)
        ELSE cases_total
    END;
	
UPDATE covid19
SET deaths_new = 
    CASE 
        WHEN deaths_new < (SELECT MIN(deaths_new) FROM covid19) THEN (SELECT MIN(deaths_new) FROM covid19)
        WHEN deaths_new > (SELECT MAX(deaths_new) FROM covid19) THEN (SELECT MAX(deaths_new) FROM covid19)
        ELSE deaths_new
    END;
	
UPDATE covid19
SET deaths_1M_pop = 
    CASE 
        WHEN deaths_1M_pop < (SELECT MIN(deaths_1M_pop) FROM covid19) THEN (SELECT MIN(deaths_1M_pop) FROM covid19)
        WHEN deaths_1M_pop > (SELECT MAX(deaths_1M_pop) FROM covid19) THEN (SELECT MAX(deaths_1M_pop) FROM covid19)
        ELSE deaths_1M_pop
    END;
		
UPDATE covid19
SET deaths_total = 
    CASE 
        WHEN deaths_total < (SELECT MIN(deaths_total) FROM covid19) THEN (SELECT MIN(deaths_new) FROM covid19)
        WHEN deaths_total > (SELECT MAX(deaths_total) FROM covid19) THEN (SELECT MAX(deaths_new) FROM covid19)
        ELSE deaths_total
    END;
		
UPDATE covid19
SET tests_1M_pop = 
    CASE 
        WHEN tests_1M_pop < (SELECT MIN(tests_1M_pop) FROM covid19) THEN (SELECT MIN(tests_1M_pop) FROM covid19)
        WHEN tests_1M_pop > (SELECT MAX(tests_1M_pop) FROM covid19) THEN (SELECT MAX(tests_1M_pop) FROM covid19)
        ELSE tests_1M_pop
    END;
		
UPDATE covid19
SET tests_total = 
    CASE 
        WHEN tests_total < (SELECT MIN(tests_total) FROM covid19Vietnam) THEN (SELECT MIN(tests_total) FROM covid19Vietnam)
        WHEN tests_total > (SELECT MAX(tests_total) FROM covid19Vietnam) THEN (SELECT MAX(tests_total) FROM covid19Vietnam)
        ELSE tests_total
    END;


--day,time


SELECT country, day, time, SUM(cases_critical) AS total_cases_critical
FROM covid19
GROUP BY country, day, time
ORDER BY country, day, time;

SELECT country, day, AVG(cases_new) AS average_cases_new
FROM covid19
GROUP BY country, day
ORDER BY country, day;

WITH CTE AS (
    SELECT country, day, time, AVG(cases_new) AS avg_cases_new
    FROM covid19
    GROUP BY country, day, time
)
UPDATE covid19
SET cases_new = (SELECT avg_cases_new FROM CTE WHERE CTE.country = covid19.country 
													AND CTE.day = covid19.day
													AND CTE.time = covid19.time)
WHERE cases_new IS NULL;

WITH RankedData AS (
    SELECT country, day, time, cases_new,
           ROW_NUMBER() OVER (PARTITION BY country, day, time ORDER BY cases_new) AS RowAsc,
           ROW_NUMBER() OVER (PARTITION BY country, day, time ORDER BY cases_new DESC) AS RowDesc
    FROM covid19
)
SELECT country, day, time, cases_new
FROM RankedData
WHERE RowAsc = RowDesc
ORDER BY country, day, time;

SELECT country, day, time, SUM(deaths_new) AS total_deaths_new
FROM covid19
GROUP BY country, day, time
ORDER BY country, day, time;

SELECT TOP 1 country, day, time, SUM(cases_new) AS total_cases_new
FROM covid19
GROUP BY country, day, time
ORDER BY total_cases_new DESC;

select * from covid19;
-- bệnh nhân mất nhiều nhất

SELECT TOP 1 country, day, time, SUM(deaths_new) AS total_deaths_new
FROM covid19
GROUP BY country, day, time
ORDER BY total_deaths_new DESC;
--
SELECT TOP 1 country, day, time, SUM(cases_new) AS total_cases_new
FROM covid19
GROUP BY country, day, time
ORDER BY total_cases_new DESC;

SELECT continent, 
       SUM(cases_new) AS total_cases_new, 
       SUM(deaths_new) AS total_deaths_new
FROM covid19
GROUP BY continent
ORDER BY total_cases_new DESC;

SELECT continent, country, SUM(deaths_new) AS total_deaths_new
FROM covid19
GROUP BY continent, country
ORDER BY continent, country;


CREATE TABLE covid19Grouped (
    day DATE,
    time TIME,
    cases_new INT,
    group_cases_new VARCHAR(50),
    cases_active INT,
    group_cases_active VARCHAR(50),
    cases_critical INT,
    group_cases_critical VARCHAR(50)
);

INSERT INTO covid19Grouped (day, time, 
							cases_new,
							group_cases_new,	
							cases_active,
							group_cases_active, 
							cases_critical, group_cases_critical)
SELECT 
    day,
    time,
    cases_new,
    CASE 
        WHEN cases_new BETWEEN 1 AND 1000 THEN '1'
        WHEN cases_new BETWEEN 1001 AND 5000 THEN '2'
        WHEN cases_new BETWEEN 5001 AND 10000 THEN '3'
        WHEN cases_new BETWEEN 10001 AND 15000 THEN ' 4'
        ELSE cases_new 
    END AS group_cases_new,
    cases_active,
    CASE 
         WHEN cases_new BETWEEN 1 AND 1000 THEN '1'
        WHEN cases_new BETWEEN 1001 AND 5000 THEN '2'
        WHEN cases_new BETWEEN 5001 AND 10000 THEN '3'
        WHEN cases_new BETWEEN 10001 AND 15000 THEN ' 4'
        ELSE cases_active
    END AS group_cases_active,
    cases_critical,
    CASE 
         WHEN cases_new BETWEEN 1 AND 1000 THEN '1'
        WHEN cases_new BETWEEN 1001 AND 50000 THEN '2'
        WHEN cases_new BETWEEN 5001 AND 10000 THEN '3'
        WHEN cases_new BETWEEN 10001 AND 15000 THEN ' 4'
        ELSE cases_critical
    END AS group_cases_critical
FROM covid19
WHERE cases_new IS NOT NULL AND
	  cases_active IS NOT NULL AND 
	  cases_critical IS NOT NULL;

SELECT * FROM covid19Grouped;
----
SELECT  continent, country, day[MONTH],  SUM(cases_new) AS total_cases_new
FROM covid19
GROUP BY  continent, country, day
ORDER BY  continent, country, day;