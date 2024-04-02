SELECT *
FROM test_sabri.covid_deaths
WHERE continent is not null
ORDER BY location, date;

-- Select Data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM test_sabri.covid_deaths
ORDER BY location, date;

-- Looking at Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract covid in your country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
FROM test_sabri.covid_deaths
WHERE location = 'United States'
ORDER BY location, date;

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

SELECT location, date, population, total_cases, (total_cases/population)*100 as percent_population_infected
FROM test_sabri.covid_deaths
WHERE location = 'United States'
ORDER BY location, date;

-- Looking at Countries with Highest Infection rate compared to Population

SELECT location, population, MAX(total_cases) as highest_infection_counT, MAX((total_cases/population)*100) as percent_population_infected
FROM test_sabri.covid_deaths
-- WHERE location = 'United States'
GROUP BY location, population
ORDER BY percent_population_infected DESC;

-- Showing Contries with Highest Death Count

SELECT location, MAX(total_deaths) as total_death_count
FROM test_sabri.covid_deaths
-- WHERE location = 'United States'
WHERE continent is not null
GROUP BY location
ORDER BY total_death_count DESC;

-- LET'S BREAK THINGS DOWN BY CONTINENT
--Showing continents with the highest death count

SELECT continent, MAX(total_deaths) as total_death_count
FROM test_sabri.covid_deaths
WHERE continent is not null
GROUP BY continent
ORDER BY total_death_count DESC;

-- esta es la mas correcta
SELECT location, MAX(total_deaths) as total_death_count
FROM test_sabri.covid_deaths
WHERE continent is null
GROUP BY location
ORDER BY total_death_count DESC;

	SELECT *
FROM test_sabri.covid_deaths
	where location in ('Asia','Europe');

--Showing continents with the highest infection rate

SELECT location, population, MAX(total_cases) as highest_infection_counT, MAX((total_cases/population)*100) as percent_population_infected
FROM test_sabri.covid_deaths
WHERE continent is null
GROUP BY location, population
ORDER BY percent_population_infected DESC;


--GLOBAL NUMBERS

SELECT date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as death_percentage
FROM test_sabri.covid_deaths
--WHERE location = 'United States'
WHERE continent is NOT null	and new_cases != 0
GROUP BY date
ORDER BY date, SUM(new_cases);


SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as death_percentage
FROM test_sabri.covid_deaths
--WHERE location = 'United States'
WHERE continent is NOT null	and new_cases != 0;

--Other data set

--Looking at Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as rolling_people_vaccinated
	--(rolling_people_vaccinated/population)*100
FROM test_sabri.covid_deaths as dea
JOIN test_sabri.covid_vaccinations as vac
 ON dea.location = vac.location
 and dea.date = vac.date
WHERE dea.continent is not null
order by dea.location, dea.date;

--Use CTE

With PopvsVac (continent, location, date, population, new_vaccinations, rolling_people_vaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as rolling_people_vaccinated
	--(rolling_people_vaccinated/population)*100
FROM test_sabri.covid_deaths AS dea
JOIN test_sabri.covid_vaccinations AS vac
 ON dea.location = vac.location
 and dea.date = vac.date
WHERE dea.continent is not null
)
SELECT *, (rolling_people_vaccinated/population)*100
FROM PopvsVac;


--Temp table -- REVISAR

Drop table if exists Percent_population_vaccinated ;

Create temp table Percent_population_vaccinated
(continent varchar(255),
Location varchar(255),
Date date,
Population numeric,
New_vaccinations numeric,
Rolling_people_vaccinated numeric
);

INSERT INTO Percent_population_vaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as rolling_people_vaccinated
	--(rolling_people_vaccinated/population)*100
FROM test_sabri.covid_deaths as dea
JOIN test_sabri.covid_vaccinations as vac
 ON dea.location = vac.location
 and dea.date = vac.date
WHERE dea.continent is not null	 and vac.new_vaccinations is not null
order by dea.location, dea.date ;

SELECT *, (rolling_people_vaccinated/population)*100
FROM Percent_population_vaccinated;


--Creating View
