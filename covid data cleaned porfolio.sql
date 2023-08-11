create database Portfolio;
select *
FROM [Portfolio Project].[dbo].[Covid_data_cleaned]
where continent is not null
order by 3,5

select location,date,total_cases,new_cases,total_deaths
FROM [Portfolio Project].[dbo].[Covid_data_cleaned]
order by 1,3

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage
FROM [Portfolio Project].[dbo].[Covid_data_cleaned]
where location like '%states%'
and continent is not null
order by 1,3

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage
FROM [Portfolio Project].[dbo].[Covid_data_cleaned]
where location like '%nigeria%'
and continent is not null
order by 1,3

select continent, location,max(total_deaths) as TotalDeathCount
FROM [Portfolio Project].[dbo].[Covid_data_cleaned]
where continent is not null
group by continent, location
order by TotalDeathCount desc

select Continent,max(total_deaths) as TotalDeathCount
FROM [Portfolio Project].[dbo].[Covid_data_cleaned]
where continent is not null
group by continent
order by TotalDeathCount desc

select location,max(total_deaths) as TotalDeathCount
FROM [Portfolio Project].[dbo].[Covid_data_cleaned]
where continent is null
group by location
order by TotalDeathCount desc


select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage
FROM [Portfolio Project].[dbo].[Covid_data_cleaned]
--where location like '%states%'
where continent is not null
order by 1,3

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage
FROM [Portfolio Project].[dbo].[Covid_data_cleaned]
where location like '%nigeria%'
and continent is not null
order by 1,3

select date,sum(new_cases) as total_cases, sum(new_deaths)as Total_deaths,sum(new_deaths)/sum(new_cases)*100 as Deathpercentage
FROM [Portfolio Project].[dbo].[Covid_data_cleaned]
--where location like '%states%'
where continent is not null
group by date
order by 1,2

select continent,location,date, new_vaccinations, sum(new_vaccinations) over (partition by location,date)as RollingPeopleVaccinated
FROM [Portfolio Project].[dbo].[Covid_data_cleaned]
where continent is not null
order by 2,3

--use cte(continent, location,date, new_vaccinations,RolingPeopleVaccinated)

with NewvsVac (continent, location,date, new_vaccinations,RollingPeopleVaccinated)
as
(
select continent,location,date, new_vaccinations, sum(new_vaccinations) over (partition by location,date)as RollingPeopleVaccinated
FROM [Portfolio Project].[dbo].[Covid_data_cleaned]
where continent is not null)
--order by 2,3
Select *
from NewvsVac


--temp table
drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
new_vaccination numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select continent,location,date, new_vaccinations, sum(new_vaccinations) over (partition by location,date)as RollingPeopleVaccinated
FROM [Portfolio Project].[dbo].[Covid_data_cleaned]
where continent is not null
order by 2,3
Select *
from #PercentPopulationVaccinated

--creating view to store data for visualization
create view PercentPopulationVaccinated as
select continent,location,date, new_vaccinations, sum(new_vaccinations) over (partition by location,date)as RollingPeopleVaccinated
FROM [Portfolio Project].[dbo].[Covid_data_cleaned]
where continent is not null
--order by 2,3