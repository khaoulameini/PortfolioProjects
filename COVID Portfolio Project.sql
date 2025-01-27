
Select * from PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4

Select location, date, total_cases_per_million*1000000 as total_cases, new_cases, population
From PortfolioProject..CovidDeaths
order by 1,2

--looking at total cases vs total deaths
Select location, date, total_cases_per_million*1000000 as total_cases, total_deaths, (total_deaths/(total_cases_per_million*1000000))*100 as Death_Percentage
From PortfolioProject..CovidDeaths
Where location = 'Algeria'
and continent is not null
order by 1,2

--looking at total cases vs population
Select location, date, total_cases_per_million*1000000 as total_cases, population, ROUND(((total_cases_per_million*1000000)/population)*100,3) as total_cases_per_population
FROM PortfolioProject..CovidDeaths
where location='Algeria'
and continent is not null
order by 1,2


--looking at countries whith highest infection rate compared to population
Select location, population, MAX(total_cases_per_million*1000000) as highest_Infection_Count, MAX(ROUND(((total_cases_per_million*1000000)/population)*100,3)) as Percent_of_population_infected
FROM PortfolioProject..CovidDeaths
Where continent is not null
Group by location, population
order by Percent_of_population_infected desc

--showing countries with highest death count per population
Select location, MAX(cast(total_deaths as int)) as highest_death_count
FROM PortfolioProject..CovidDeaths
Where continent is not null
group by location
order by highest_death_count desc

--showing results by continent
Select continent, MAX(cast(total_deaths as int)) as highest_death_count
FROM PortfolioProject..CovidDeaths
Where continent is not null
group by continent
order by highest_death_count desc

/*Select location, MAX(cast(total_deaths as int)) as highest_death_count
FROM PortfolioProject..CovidDeaths
Where continent is null
group by location
order by highest_death_count desc*/

--showing the continents with highest death count
Select continent, MAX(cast(total_deaths as int)) as highest_death_count
FROM PortfolioProject..CovidDeaths
where continent is not null
group by continent 
order by highest_death_count desc

--Global numbers
Select /*date,*/(SUM(total_cases_per_million*1000000)+ SUM(new_cases)) as total_cases, (SUM(cast(total_deaths as int))+SUM(cast(new_deaths as int))) as total_deaths, ((SUM(total_cases_per_million*1000000)+ SUM(new_cases))/(SUM(cast(total_deaths as int))+SUM(cast(new_deaths as int))))*100 as Death_Percentage
From PortfolioProject..CovidDeaths
where continent is not null
--group by date
order by 1,2,3

--_____________________________________________________--

--looking at total population vs vaccinations

--using CTE (Common Table Expression)
with PopulvsVacc(continent, location, date, population, new_vaccination, people_vaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location,
 dea.date) as people_vaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
  On dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (people_vaccinated/population)*100 From 
PopulvsVacc 


--temp table

DROP Table if exists PencentPopulationVaccinated
Create table PencentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
date datetime,
Population numeric,
New_vaccinations numeric,
People_vaccinated numeric
)
Insert into PencentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location,
 dea.date) as people_vaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
  On dea.location = vac.location
  and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select *, (People_vaccinated/population)*100 From 
PencentPopulationVaccinated order by 2,3 


--Creating view to store data for later visualization

--DROP VIEW IF EXISTS PercentPopulationVaccinatedd
/*Create View PencentPopulationVaccinatedd as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location,
 dea.date) as people_vaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
  On dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null  */
