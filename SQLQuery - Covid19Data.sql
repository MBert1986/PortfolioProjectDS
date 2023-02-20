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

 -- PROMEDIOS TOTALES GLOBALES
SELECT location, AVG(total_deaths) Promedio_total_muertes, AVG(total_cases) Promedio_total_casos
FROM PortfolioProject..CovidDataDeaths 
GROUP BY location
ORDER BY 2 DESC

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

-- TOTAL POBLACION VS VACUNADOS
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDataDeaths dea
Join PortfolioProject..CovidDataVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- USANDO CTE
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDataDeaths dea
Join PortfolioProject..CovidDataVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


-- APLICANDO TABLA TEMPORAL
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDataDeaths dea
Join PortfolioProject..CovidDataVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- CREANDO UNA VISTA (VIEW)
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDataDeaths dea
Join PortfolioProject..CovidDataVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
