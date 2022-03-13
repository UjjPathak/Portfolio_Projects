# CovidDeath Table
select * from CovidDeath;

select * 
from CovidDeath 
order by 3,4;

select * 
from Vaccanation 
order by 3,4;

select Location , date, total_cases, total_deaths, population
from CovidDeath
order by 1,2;

# Total Cases vs Total Deaths
# Dipicts likelihood of death when you get covid in Australia
select Location , date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercent
from CovidDeath
where location like '%Australia%'
order by 1,2;

# Total Cases vs population
# Shows of population who got COVID
# Dipicts likelihood of death when you get covid in Australia
select Location , date, total_cases, population, (total_cases/population)*100 as CovidPercent
from CovidDeath
where location like '%Australia%'
order by 1,2;

# Countries with highest infection rate compared to population
select location, population, MAX(total_cases) as highinfectioncount, MAX((total_cases/population))*100 as CovidPercentPopulation
from CovidDeath
where continent is not null
group by location, population
order by CovidPercentPopulation desc;


# Showing Countries with highest death count per population
select location, MAX(total_deaths) as totaldeathcount
from CovidDeath
where continent is not null
group by location
order by Totaldeathcount desc;

# Continent with highest infection rate compared to population
select continent, population, MAX(total_cases) as highinfectioncount, MAX((total_cases/population))*100 as CovidPercentPopulation
from CovidDeath
where continent is not null
group by continent, population
order by CovidPercentPopulation desc;


# Showing Continent with highest death count per population
select continent, MAX(total_deaths) as totaldeathcount
from CovidDeath
where continent is not null
group by continent
order by Totaldeathcount desc;

# Global Numbers
select date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, 100*sum(new_deaths)/sum(new_cases) as DeathPercent
from CovidDeath
group by date
order by 1,2;

# Total Global Death Percent
select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, 100*sum(new_deaths)/sum(new_cases) as DeathPercent
from CovidDeath;

# Covid Vaccanation Table
select * from Vaccanation;

# Renaming columns for convinence
ALTER TABLE vaccanation 
rename column total_tests to continent,
rename column total_tests_per_thousand to location,
rename column new_tests_per_thousand to date;

select * from Vaccanation;

# Exploring total population and Vaccanation
#Joining CovidDeath table and Vaccanation table on location and date columns
select coviddeath.continent, coviddeath.location, coviddeath.date, coviddeath.population, vaccanation.new_vaccinations
, sum(vaccanation.new_vaccinations) over (partition by coviddeath.location order by coviddeath.location, coviddeath.date)
as rollingpeoplevaccinated 
from coviddeath
join vaccanation
on coviddeath.location = vaccanation.location
and coviddeath.date = vaccanation.date
where coviddeath.continent is not null
order by 2,3;

# Using CTE
with popvac (continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)
as
(select coviddeath.continent, coviddeath.location, coviddeath.date, coviddeath.population, vaccanation.new_vaccinations
, sum(vaccanation.new_vaccinations) over (partition by coviddeath.location order by coviddeath.location, coviddeath.date)
as rollingpeoplevaccinated 
from coviddeath
join vaccanation
on coviddeath.location = vaccanation.location
and coviddeath.date = vaccanation.date
where coviddeath.continent is not null)
select *, (rollingpeoplevaccinated/population)*100 as popvac_percent
from popvac;

# Creating View
create view percentpopulationvaccinated as
select coviddeath.continent, coviddeath.location, coviddeath.date, coviddeath.population, vaccanation.new_vaccinations
, sum(vaccanation.new_vaccinations) over (partition by coviddeath.location order by coviddeath.location, coviddeath.date)
as rollingpeoplevaccinated 
from coviddeath
join vaccanation
on coviddeath.location = vaccanation.location
and coviddeath.date = vaccanation.date
where coviddeath.continent is not null;



