--SELECT * FROM PortfolioProject..CovidDataDeaths ORDER BY 3,4

--SELECT * FROM PortfolioProject..CovidDataVacinations ORDER BY 3,4

 -- LETALIDAD
SELECT location, date, total_cases, total_deaths, (total_deaths /total_cases)*100 as death_percentage
FROM PortfolioProject..CovidDataDeaths 
WHERE location = 'Argentina'
ORDER BY 1,2

 -- PORCENTAJE DE CONTAGIO
SELECT location, date, total_cases, population, (total_cases /population)*100 as contagious_percentage
FROM PortfolioProject..CovidDataDeaths 
WHERE location = 'Argentina'
ORDER BY 1,2

 -- ICU
SELECT location, date, total_cases, icu_patients, (icu_patients /total_cases)*100 as icu_percentage
FROM PortfolioProject..CovidDataDeaths 
WHERE location = 'Argentina'
ORDER BY 1,2

 -- PAISES CON ALTA INFECCION

SELECT location, MAX(total_cases) as High_cases, population, MAX(total_cases /population)*100 as HighContagious
FROM PortfolioProject..CovidDataDeaths 
GROUP BY location, population
ORDER BY HighContagious desc

 -- PAISES CON ALTA MORTALIDAD

SELECT location, MAX(total_deaths) as High_death, population, MAX(total_deaths /population)*100 as HighDeathPercentage
FROM PortfolioProject..CovidDataDeaths 
WHERE continent is not null
GROUP BY location, population
ORDER BY High_death desc

 -- POR CONTINENTE

SELECT continent, MAX(total_deaths) as High_death
FROM PortfolioProject..CovidDataDeaths 
WHERE continent is not null
GROUP BY continent
ORDER BY High_death desc