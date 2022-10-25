select *
from Portfolio..covidDeaths 
where continent is not null
order by 3,4

--select *
--from Portfolio..CovidVaccinations
--order by 3,4

--seleccionar los datos que vamos a usar

select location,date,total_cases,new_cases,total_deaths, population
from Portfolio..covidDeaths 
where continent is not null
order by 1,2

-- explorando la totalidad de personas infectadas vs la totalidad de muertes por infeccion 
select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from Portfolio..covidDeaths 
where continent is not null
order by 1,2

-- explorando la cantidad de casos vs la cantidad de población por país
--muestra el porcentaje de la población que contrajo el virus
select location,date,population,total_cases,(total_cases/population)*100 as InfectionPercentage
from Portfolio..covidDeaths
where location like '%states' and continent is not null
order by 1,2

-- explorando países con mayor índice de infección
select location,population,MAX(total_cases) as HighestInfectionCount,Max((total_cases/population))*100 as PercentofPopulatuonInfected
from Portfolio..covidDeaths
--where location like '%states'
where continent is not null
Group by location,population
order by PercentofPopulatuonInfected desc

-- explorando los países con mayores muertes por población
Select location, MAX(CAST(total_deaths as INT)) as TotalDeathCount
From Portfolio..CovidDeaths
Where continent is not null
Group by location
Order by TotalDeathCount desc

--muertes por continente
Select location, MAX(CAST(total_deaths as INT)) as TotalDeathCount
From Portfolio..CovidDeaths
Where continent is null
Group by location
Order by TotalDeathCount desc

-- explorando numeros mundiales por día
Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as totaldeaths,SUM(cast(new_deaths as int))/SUM(cast(new_cases as int))*100 as Deathpercentage
From Portfolio..CovidDeaths
Where continent is not null
Group by date
order by 1,2

-- explorando numeros mundiales al día de hoy
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as totaldeaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Deathpercentage
From Portfolio..CovidDeaths
Where continent is not null
--Group by date
order by 1,2

---		uniendo tabla de vacunaciones con tabla de muertes
-- explorando cuantas personas fueron vacunadas de la población mundial
With PopvsVac (continent,location, date,population,new_vaccinations, RollingPeopleVaccinated) as
(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as float)) OVER (partition by dea.location order by dea.location, dea.date)as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From Portfolio..CovidDeaths dea
Join Portfolio..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
from PopvsVac

-- Hago una temp Table
Drop table if exists #percentPopulationVaccinated
Create table #percentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric,
)

Insert into #percentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as float)) OVER (partition by dea.location order by dea.location, dea.date)as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From Portfolio..CovidDeaths dea
Join Portfolio..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
--Where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/population)*100
from #percentPopulationVaccinated

-- Creando una View
Create View  VaccinatedPopulationPercentage as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as float)) OVER (partition by dea.location order by dea.location, dea.date)as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From Portfolio..CovidDeaths dea
Join Portfolio..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
--order by 2,3

select * 
from VaccinatedPopulationPercentage




