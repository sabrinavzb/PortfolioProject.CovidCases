/*

Queries used for Tableau Project

*/

-- 1. Global numbers

Select SUM(new_cases) as total_cases, SUM(new_deaths ) as total_deaths, SUM(new_deaths)/SUM(New_Cases)*100 as DeathPercentage
From test_sabri.covid_deaths
--Where location like '%states%'
where continent is not null
--Group By date
order by 1,2;


-- 2.
--Showing continents with the highest death count

Select location, SUM(new_deaths) as Total_death_count
From test_sabri.covid_deaths
--Where location like '%states%'
Where continent is null
and location not in ('World', 'European Union', 'International', 'High income', 'Upper middle income', 'Lower middle income', 'Low income')
Group by location
order by Total_death_count desc;

--This should be the correct one but it is not

--SELECT continent, MAX(total_deaths) as total_death_count
--FROM test_sabri.covid_deaths
--WHERE continent is not null
--GROUP BY continent
--ORDER BY total_death_count DESC;

-- 3.
-- Looking at Total Cases vs Population. Shows what percentage of population got Covid

-- Looking at Countries with Highest Infection rate compared to Population
Select Location, Population, MAX(total_cases) as Highest_infection_count,  Max((total_cases/population))*100 as Percent_population_infected
From test_sabri.covid_deaths
--Where location like '%states%'
Group by Location, Population
order by Percent_population_infected desc;

-- 4.
-- Looking at Countries with Highest Infection rate compared to Population by date

Select Location, Population, date, MAX(total_cases) as Highest_infection_count,  Max((total_cases/population))*100 as Percent_population_infected
From test_sabri.covid_deaths
--Where location like '%states%'
Group by Location, Population, date
order by Percent_population_infected desc;

