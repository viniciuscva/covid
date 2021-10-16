use covid;
select * from covid_vaccinations order by 4,3 limit 100;
select * from covid_deaths order by 4,3 limit 300;

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid_deaths 
ORDER BY 1,2 LIMIT 300;

-- TOTAL CASES VS TOTAL DEATHS
SELECT location, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as death_perc
FROM covid_deaths 
WHERE location LIKE 'brazil';

-- TOTAL CASES VS POPULATION
SELECT location, date, total_cases, population, (total_cases/population)*100 as cases_per_100
FROM covid_deaths
WHERE location LIKE 'brazil';

-- COUNTRIES WITH HIGHEST INFECTION RATES
SELECT location, date, (total_cases/population)*100 as infection_rate
FROM covid_deaths
WHERE date = '2021-10-13' 
ORDER BY infection_rate DESC;

SELECT location, population, max(total_cases) as max_cases_count, max(total_deaths) as max_death_count, max(total_cases*100/population) as infection_rate
FROM covid_deaths
GROUP BY location,population
ORDER BY infection_rate DESC;

-- COUNTRIES WITH HIGHTEST DEATH COUNT 
SELECT location, max(total_cases) as totalcasescount, max(total_deaths) as totaldeathcount
FROM covid_deaths
-- WHERE continent <> ''
GROUP BY location
ORDER BY totaldeathcount DESC;

-- COUNTRIES WITH HIGHTEST DEATH COUNT PER POPULATION
SELECT location, population, max(total_deaths), max(total_deaths*100/population) as death_rate_pop
FROM covid_deaths
GROUP BY location, population
ORDER BY death_rate_pop DESC;

-- DEATH COUNT BY CONTINENT
SELECT continent, sum(total_death_count) as deaths_per_continent
FROM
	(SELECT location, continent, max(total_deaths) as total_death_count
	FROM covid_deaths
	WHERE continent <> ''
	GROUP BY location, continent) dpc
GROUP BY continent
ORDER BY deaths_per_continent DESC;

SELECT location, max(total_deaths) as total_death_count
FROM covid_deaths
WHERE continent = ''
GROUP BY location
ORDER BY total_death_count DESC;

-- Totais de vacinações por países
SELECT
  location, sum(new_vaccinations)
FROM
  covid_vaccinations
WHERE
  continent <> ''
GROUP BY location
ORDER BY 2 DESC;

-- Média de testes por dia nos países
WITH totais_linhas_paises(location,total) AS
(SELECT location, count(location) FROM covid_vaccinations GROUP BY location)
SELECT covid_vaccinations.location, max(total_tests)/totais_linhas_paises.total as avg_tests_per_day
FROM covid_vaccinations JOIN totais_linhas_paises ON covid_vaccinations.location = totais_linhas_paises.location
WHERE continent <> ''
GROUP BY location,totais_linhas_paises.total
ORDER BY 2 DESC;

-- Comparando se o percentual da população vacinada tem relação com o percentual de mortes na população
SELECT d.location, max(d.total_deaths)*100/d.population as perc_pop_death, max(v.people_vaccinated)*100/d.population as perc_pop_vaccinated
FROM covid_deaths d 
JOIN covid_vaccinations v
ON d.location = v.location AND d.date = v.date
WHERE d.continent <> ''
GROUP BY d.location, d.population
ORDER BY 2 DESC;
