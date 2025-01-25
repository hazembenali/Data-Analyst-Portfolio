--Percentage of total covid19 cases that died per location
SELECT location, 
	MAX(total_cases) AS total_cases,
	MAX(total_deaths) AS total_deaths,
	ROUND(MAX(total_deaths)::NUMERIC/MAX(total_cases), 2) * 100 AS fatality_percentage
FROM coviddeaths
GROUP BY 1
ORDER BY 1

--percentage of total population that got infected per location
SELECT location, 
	MAX(total_cases) AS total_cases,
	MAX(population) AS population,
	ROUND(MAX(total_cases)::NUMERIC/MAX(population), 2) * 100 AS infection_percentage
FROM coviddeaths
GROUP BY 1
ORDER BY 4 DESC, 1

--Percentage of the population that died of covid19 per location
SELECT location,
	MAX(total_deaths) AS total_deaths,
	MAX(population) AS population, 
	ROUND(MAX(total_deaths)::NUMERIC/MAX(population), 5)*100 AS death_percentage
FROM coviddeaths
GROUP BY 1
ORDER BY 1

--total number of covid19 deaths in countries
SELECT location, 
	MAX(total_deaths) AS total_deaths
FROM coviddeaths
WHERE location NOT IN ('World', 'Europe', 'North America', 'European Union', 'South America', 'Asia', 'Africa')
GROUP BY 1
HAVING MAX(total_deaths) IS NOT NULL
ORDER BY total_deaths DESC

--Total Covid19 Cases Per Continent. Two Possible ways :
--Query 1
SELECT location,
MAX(total_cases) AS total_cases
FROM coviddeaths
WHERE continent IS NULL
GROUP BY location
--Query 2
SELECT continent, 
SUM(total_cases) AS total_cases
FROM(
SELECT continent,
	location,
	MAX(total_cases) AS total_cases
FROM coviddeaths
GROUP BY  continent, location
ORDER BY continent
)
GROUP BY continent

--Percentage of Covid19 Cases out of the World's Population
SELECT location,
	MAX(total_cases) AS total_cases,
	MAX(population) AS population,
	ROUND(MAX(total_cases)::NUMERIC/MAX(population), 3)*100 AS percentage_world_cases
FROM coviddeaths
WHERE location = 'World'
GROUP BY location

--Percentage of deaths out of all Covid19 Cases in the World
SELECT location,
	MAX(total_deaths) AS total_deaths,
	MAX(total_cases) AS total_cases,
	ROUND(MAX(total_deaths)::NUMERIC/MAX(total_cases), 3)*100 AS global_death_percentage
FROM coviddeaths
WHERE location = 'World'
GROUP BY location

--Percentage of population that got vaccinated by country
SELECT location,
	MAX(population) AS population,
	MAX(people_vaccinated) AS people_vaccinated,
	ROUND(MAX(people_vaccinated)::NUMERIC/MAX(population), 3)*100 AS vaccination_percentage
FROM coviddeaths AS deaths
INNER JOIN covidvaccinations AS vaccines
USING(location)
WHERE deaths.continent IS NOT NULL
GROUP BY location
ORDER BY location

--Percentage of World Population That got Vaccinated
SELECT location,
	MAX(population) AS population,
	MAX(people_vaccinated) AS people_vaccinated,
	ROUND(MAX(people_vaccinated)::NUMERIC/MAX(population), 3)*100 AS global_vaccination_percentage
FROM coviddeaths
INNER JOIN covidvaccinations
USING(location)
WHERE location = 'World'
GROUP BY location

--People that Got vaccinated Up To Date per Counrty
WITH vaccines_UTD AS (
	SELECT location,
		date,
		new_vaccinations,
	SUM(new_vaccinations) OVER(PARTITION BY location ORDER BY date) AS vaccinations_UTD
	FROM covidvaccinations
)
SELECT deaths.location,
		deaths.date,
		new_vaccinations,
		vaccinations_UTD,
	ROUND(vaccinations_UTD/population::NUMERIC, 4)*100 AS vaccination_percentage_UTD
FROM coviddeaths AS deaths
INNER JOIN vaccines_UTD
ON deaths.location = vaccines_UTD.location
AND deaths.date = vaccines_UTD.date


--Deaths Up To Date Per Country
DROP TABLE IF EXISTS  deaths_UTD;
CREATE TEMP TABLE deaths_UTD(
	location VARCHAR,
	date DATE,
	new_deaths INTEGER,
	total_deaths_UTD INTEGER	
);
INSERT INTO deaths_UTD
SELECT location,
		date,
		new_deaths,
		SUM(new_deaths) OVER(PARTITION BY location ORDER BY date) AS total_deaths_UTD
FROM coviddeaths;

SELECT deaths.location,
	deaths.date,
	total_cases AS total_cases_UTD,
	deaths_UTD.total_deaths_UTD,
	ROUND(total_deaths_UTD::NUMERIC/total_cases, 2) AS fatality_rate_UTD
FROM deaths_UTD
INNER JOIN coviddeaths AS deaths
ON deaths.location = deaths_UTD.location
AND deaths.date = deaths_UTD.date

--Vaccines Up To Date per Country view
CREATE VIEW vaccines_UTD AS
WITH vaccines_UTD AS (
	SELECT location,
		date,
		new_vaccinations,
	SUM(new_vaccinations) OVER(PARTITION BY location ORDER BY date) AS vaccinations_UTD
	FROM covidvaccinations
)
SELECT deaths.location,
		deaths.date,
		new_vaccinations,
		vaccinations_UTD,
	ROUND(vaccinations_UTD/population::NUMERIC, 4)*100 AS vaccination_percentage_UTD
FROM coviddeaths AS deaths
INNER JOIN vaccines_UTD
ON deaths.location = vaccines_UTD.location
AND deaths.date = vaccines_UTD.date