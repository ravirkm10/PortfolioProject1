--select * from dbo.CovidDeaths

-- Lookinga at Death against cases

select location,date,Population,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage from dbo.CovidDeaths
where location like 'India'
order by 1,2



-- Looking for Total cases vs population i.e. what percentage of population got covid infected

select location,date,Population,total_cases,total_deaths,(total_cases/Population)*100 as PopulationInfected from dbo.CovidDeaths
where continent is not NULL
where location like 'India'
order by 1,2

-- To see which country is most infected proportionally

select location,population,MAX(total_cases),MAX((total_cases/Population))*100 as PopulationInfected from dbo.CovidDeaths
where continent is not NULL
group by location,Population
order by PopulationInfected desc


-- Countries with highest death rates

select location,population,MAX(total_deaths) as TotalDeaths,MAX((total_deaths/Population))*100 as DeathRate from dbo.CovidDeaths
where continent is not NULL
group by location,Population
order by DeathRate desc


--Counties sorted by Max deaths

select location,population,MAX(total_deaths) as TotalDeaths from dbo.CovidDeaths
where continent is not NULL
group by location,Population
order by TotalDeaths desc


--- Global Numbers


Select date,sum(new_cases) TotalCases,sum(new_deaths) TotalDeaths,(sum(new_deaths)/sum(new_cases)) *100 as DeathPercentage from dbo.CovidDeaths
where continent is not null
group by date
order by date


-- Global vaccinations

select d.continent,d.location,d.date,d.Population,v.new_vaccinations
,sum(cast(new_vaccinations as int)) OVER(Partition by d.location order by d.location) as RollingPeopleVaccinated
--,RollingPeopleVaccinated/d.Population * 100 as CountryVaccinationRate
from dbo.CovidDeaths d
Join dbo.CovidVaccinations v
on d.location = v.location and d.date = v.date
where d.continent is not null
order by 1,2,3



-- USE CTE


With PopvsVac (continent,location,date,population,NewVaccinations,RollingPeopleVaccinated)
as
(
select d.continent,d.location,d.date,d.Population,v.new_vaccinations
,sum(cast(new_vaccinations as int)) OVER(Partition by d.location order by d.location) as RollingPeopleVaccinated
--,RollingPeopleVaccinated/d.Population * 100 as CountryVaccinationRate
from dbo.CovidDeaths d
Join dbo.CovidVaccinations v
on d.location = v.location and d.date = v.date
where d.continent is not null
--order by 1,2,3
)
select *,RollingPeopleVaccinated/Population * 100 as CountryVaccinationRate from PopvsVac
