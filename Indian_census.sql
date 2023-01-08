
create database Projects;

select * from census;
select * from census1;

## Total count of rows in our data set

select count(*) from census;
select count(*) from census1;

## data only for bihar and jharkhand state
select * from census
where state = 'jharkhand' or state = 'bihar';

## Population of india
select * from census1;
select sum(population) from census1;

## Avg Growth 
select state , round(avg(Growth)*100,2) from census
group by state;
select * from census;

## avg sex ratio
select state, round(avg(sex_ratio),2) as avg_sex_ratio from census
group by state
order by avg_sex_ratio desc,state asc;

## Avg_literacy_rate
select state , round(avg(literacy),2) from census
group by state
having round(avg(literacy),2) > 90 
order by round(avg(literacy),2) desc;

## top 3 states showing highest Growth ratio

select state, round(sum(growth),2) from census
group by state
order by sum(growth) desc
limit 3;

## bottom 3 states showing lowest sex ratio

select state, round(sum(sex_ratio),2) from census
group by state
order by sum(sex_ratio) asc
limit 3;


create table top_states
( state varchar(255), topstate float);

insert into top_states
select state, round(avg(literacy),2) from census
group by state
order by round(avg(literacy),2) desc
limit 3;
select * from top_states;
truncate top_states;

 
create table bottom_state 
( state varchar(255), bottom_state float);
insert into bottom_states
select state, round(avg(literacy),2) from census
group by state
order by round(avg(literacy),2) asc
limit 3;

##union

select * from bottom_states
union
select * from top_states;


##
select * from census;

select * from census1;

# Total Males and females
with new_table as (
select census.district , census.state , census.sex_ratio,census1.population from census join census1 on census.District = census1.district)
select district , state ,population , round((population/sex_ratio+1),0) as males , round((population*sex_ratio)/(sex_ratio+1),0) as females from new_table;


# total literacy rate

with  literate_count as (
select census.district , census.state , census.Literacy,census1.population
from census join census1 on census.District = census1.district)
select state  ,sum(round(literacy*population/100,0)) as total_literacy_population,sum( round((1 - literacy/100)*population,0)) as total_illiterate_population from literate_count
group by state
order by state;


# Growth_calculation
with growth_calculation as (
select census.district , census.state , census.Growth,census1.population
from census join census1 on census.District = census1.district)
select *, sum(round(population/(1+growth),0))  as previous_census from  growth_calculation
group by state; 