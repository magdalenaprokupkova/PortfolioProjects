SELECT *
FROM [Portfolio Project ] ..CovidDeaths$
ORDER BY 3,4;

SELECT *
FROM [Portfolio Project ] ..CovidVaccinations$ 
ORDER BY 3,4;

-- select data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population 
FROM CovidDeaths$
ORDER BY 1,2;

-- Looking at Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract covid in the UK
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidDeaths$
WHERE location LIKE '%Kingdom%'
ORDER BY 1,2;

--Looking at Total Cases vs Population
-- Shows what percentage of population got Covid in the UK
SELECT location, date, population, total_cases, (total_cases/population)*100 AS CasesPercentage
FROM CovidDeaths$
WHERE location LIKE '%Kingdom%'
ORDER BY 1,2;
-- 19% of UK population got confirmed case of Covid


-- Looking at countries with the highest infection rates compared to population
SELECT location, population, MAX (total_cases) AS max_covid_cases, MAX((total_cases/population))*100 AS MaxCasesPercentage
FROM CovidDeaths$
GROUP BY location, population
ORDER BY MaxCasesPercentage DESC;

--How many people died of Covid?
-- Showing countries with the highest death count per population
SELECT location, MAX (cast(total_deaths as int)) AS TotalDeathCount --converting total deaths (nvarchar) to integer
FROM CovidDeaths$
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- 'world' and continent names under location -> explore data
SELECT *
FROM [Portfolio Project ] ..CovidDeaths$
WHERE continent is not null
ORDER BY 3,4;


--LET'S BREAK THINGS DOWN BY CONTINENT

SELECT continent, MAX (cast(total_deaths as int)) AS TotalDeathCount --converting total deaths (nvarchar) to integer
FROM CovidDeaths$
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC;


--  GLOBAL NUMBERS --
SELECT sum(new_cases) AS total_cases, SUM(cast(new_deaths as int)) AS total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
FROM CovidDeaths$
WHERE continent IS NOT NULL
ORDER BY 1,2;


-- LET'S JOIN THE VACCINATIONS TABLE 
-- Looking at Total Population vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM (cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) AS PeopleVaccinated
--(PeopleVaccinated/population)*100
FROM [Portfolio Project ]..CovidDeaths$ AS dea
JOIN [Portfolio Project ]..CovidVaccinations$ AS vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3;

--USE CTE
With PopvsVac (continent, location, date, population, new_vaccinations, PeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM (cast(vac.new_vaccinations as bigint)) 
OVER (Partition by dea.location order by dea.location, dea.date) 
AS PeopleVaccinated
--,(PeopleVaccinated/population)*100
FROM [Portfolio Project ]..CovidDeaths$ AS dea
JOIN [Portfolio Project ]..CovidVaccinations$ AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT *, (PeopleVaccinated/population)*100
FROM PopvsVac
--ABOVE HAS TO RUN WITH THE CTE

--TEMP TABLE
DROP TABLE IF EXISTS #PercentPopulationVaccinated -- in case table alterations are needed
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255), 
location nvarchar(255), 
date datetime,
population numeric,
new_vaccinations numeric,
PeopleVaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM (cast(vac.new_vaccinations as bigint)) 
OVER (Partition by dea.location order by dea.location, dea.date) 
AS PeopleVaccinated
--,(PeopleVaccinated/population)*100
FROM [Portfolio Project ]..CovidDeaths$ AS dea
JOIN [Portfolio Project ]..CovidVaccinations$ AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT *, (PeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated

--creating view to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM (cast(vac.new_vaccinations as bigint)) 
OVER (Partition by dea.location order by dea.location, dea.date) 
AS PeopleVaccinated
--,(PeopleVaccinated/population)*100
FROM [Portfolio Project ]..CovidDeaths$ AS dea
JOIN [Portfolio Project ]..CovidVaccinations$ AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated
