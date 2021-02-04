/*create database gis_occurrence_data;*/


--1. Western Maharashtra data 

create table mh_data (
species_name varchar(150),
locality varchar(150),
Latitude numeric ,
Longitude numeric
)
;

/*copy mh_data(species_name,locality,Latitude,Longitude)
from 'C:\Research_data\Research data\Large Branchiopoda\All Large Branchiopod data\western_mh.csv' DELIMITER ',' CSV HEADER;*/

select *
from 
mh_data;

--2. Arid region maharashtra data

create table arid_mh (
locality varchar(150),
Latitude numeric ,
Longitude numeric,
S_dichotomus int,
S_simplex int,
L_denticulatus int,
E_indocylindrova int,
E_michaeli int,
C_annandalei int,
C_hislopi int )
;
);

copy arid_mh(locality,Latitude,Longitude,S_dichotomus,S_simplex,L_denticulatus,E_indocylindrova,E_michaeli,C_annandalei,C_hislopi)
from 'C:\Research_data\Research data\Large Branchiopoda\All Large Branchiopod data\arid_mh.csv' DELIMITER ',' CSV HEADER;

select 
*
from 
public.arid_mh ;

-- Since the data is in wide format, the data is pivoted and converted into a long format

create table arid_long_mh (
species_name varchar(150),
locality varchar(150),
Latitude numeric ,
Longitude numeric)
;

insert into arid_long_mh
select 
case when s_dichotomus = 1 then 'S_dichotomus'
when s_simplex = 1 then 'S_simplex'
when l_denticulatus = 1 then 'L_denticulatus'
when e_indocylindrova = 1 then 'E_indocylindrova'
when e_michaeli = 1 then 'E_michaeli'
when c_annandalei = 1 then 'C_annandalei'
when c_hislopi = 1 then 'C_hislopi'
else 'no_branchi' end as species_name,
locality,
latitude,
longitude
from 
arid_mh;

select 
*
from 
public.arid_long_mh ;

--3. Fairy shrimps data of India

create table ind_fairy_shrimps (
species_name varchar(150),
locality varchar(150),
Latitude numeric ,
Longitude numeric
);

/*copy ind_fairy_shrimps(species_name,locality,Latitude,Longitude)
from 'C:\Research_data\Research data\Large Branchiopoda\All Large Branchiopod data\fairy_shrimps_india.csv' DELIMITER ',' CSV HEADER;*/

select 
*
from 
ind_fairy_shrimps
;

--4. Indian Tadpole shrimps data

create table ind_tadpole_shrimps (
species_name varchar(150),
locality varchar(150),
Latitude numeric ,
Longitude numeric
);

/*copy ind_tadpole_shrimps(species_name,locality,Latitude,Longitude)
from 'C:\Research_data\Research data\Large Branchiopoda\All Large Branchiopod data\triops_india.csv' DELIMITER ',' CSV HEADER;*/

select 
*
from 
ind_tadpole_shrimps
;

--5. Clam shrimps India data

create table ind_clam_shrimps (
species_name varchar(150),
locality varchar(150),
Latitude numeric ,
Longitude numeric
);

/*copy ind_clam_shrimps(species_name,locality,Latitude,Longitude)
from 'C:\Research_data\Research data\Large Branchiopoda\All Large Branchiopod data\clam_shrimps_india.csv' DELIMITER ',' CSV HEADER;*/

select 
*
from 
ind_clam_shrimps
;

-- Importing a table having family of each genus

create table family_data (
genus varchar (200),
family varchar (200)
);

copy family_data(genus,family)
from 'C:\Research_data\Research data\Large Branchiopoda\All Large Branchiopod data\branchi_families.csv' DELIMITER ',' CSV HEADER;*/

-- Combining all the datasets (except family) to generate a Indian large branchiopod crustacean data

drop table if exists combined_species_data;

create table combined_species_data (
species_name varchar(150),
locality varchar(150),
Latitude numeric ,
Longitude numeric
)
;
insert into public.combined_species_data
select
*
from mh_data 
union all 
select 
*
from public.arid_long_mh 
union all
select
*
from ind_fairy_shrimps
union all
select
*
from ind_tadpole_shrimps
union all
select
*
from ind_clam_shrimps 
;

-- Editing some of the records
 
update combined_species_data
set species_name = 'Streptocephalus_dichotomus'
where species_name = 'Streptocephalus_dichotomous';

update combined_species_data
set species_name = 'Streptocephalus_dichotomus'
where species_name = 'S_dichotomus';

update combined_species_data
set species_name = 'Streptocephalus_simplex'
where species_name = 'S_simplex';

update combined_species_data
set species_name = 'Cyzicus_annandalei'
where species_name = 'Cyzicus_annandelei';

update combined_species_data
set species_name = 'Cyzicus_annandalei'
where species_name = 'C_annandalei';

update combined_species_data
set species_name = 'Lynceus_denticulatus'
where species_name = 'L_denticulatus';

update combined_species_data
set species_name = 'Eulimnadia_indocylindrova'
where species_name = 'Eulimnadia_indocyclindrova';

update combined_species_data
set species_name = 'Eulimnadia_indocylindrova'
where species_name = 'E_indocylindrova';

update combined_species_data
set species_name = 'Eulimnadia_michaeli'
where species_name = 'E_michaeli';

update combined_species_data
set species_name = 'Cyclestheria_hislopi'
where species_name = 'C_hislopi';


delete from combined_species_data 
where species_name ilike '%colomb%'
;

update combined_species_data
set species_name = 'Eulimnadia_michaeli'
where species_name = 'Eulimnadia_micheali';

delete from combined_species_data 
where species_name = 'Eulimnadia_michaeli' and locality = 'Belhe'
;

delete from combined_species_data 
where species_name = 'Eulimnadia_sp.';

delete from combined_species_data 
where species_name = 'Eocyzicus_pellucidus';

delete from combined_species_data 
where species_name = 'Eocyzicus_plumosus';

delete from combined_species_data 
where species_name = 'Eocyzicus_sp.';

delete from combined_species_data 
where species_name = 'Eulimnadia_similis';

delete from combined_species_data 
where species_name = 'Leptestheria_longispina';

insert into combined_species_data
values('Eulimnadia_michaeli','Belhe',19.113,74.2177)
;

insert into combined_species_data
values('Eulimnadia_bondi','Fatrade_Goa',15.2094,73.9388)
;

insert into combined_species_data
values('Eulimnadia_bondi','Benaulim',15.2439,73.9447)
;

insert into combined_species_data
values('Eulimnadia_bondi','Univ_Goa',15.4585,73.8345)
;

insert into combined_species_data
values('Eulimnadia_chaperi','Badami',15.92,75.68028)
;

select 
*
from 
combined_species_data csd ;
-- Splitting the species_name into species and genus column

alter table public.combined_species_data 
add column genus varchar(50);

update public.combined_species_data 
set genus = split_part(species_name,'_',1);


alter table public.combined_species_data 
add column species varchar(50);
update public.combined_species_data
set species = split_part(species_name,'_',2);

select 
count(distinct species_name)
from 
public.combined_species_data ;

select 
*
from 
combined_species_data csd ;

-- Adding the family information to the combined dataset
select 
csd.species_name,
csd.locality,
csd.latitude,
csd.longitude,
csd.genus,
csd.species,
fd.family
from 
combined_species_data  as csd
join
family_data  as fd
on
csd.genus=fd.genus
;

-- Generating a locality table for all occurrence data

drop table if exists localities ;

create table localities (
locality varchar(150), 
Latitude numeric ,
Longitude numeric
);

insert into localities
select 
distinct locality,
latitude,
longitude
from 
public.combined_species_data 
;
 
-- adding a primary key

alter table public.localities
add column locality_id serial primary key not null;

select 
*
from 
localities;

-- generating a table for all species data

drop table if exists species;

create table species (
species_id serial primary key not null,
species_name varchar(150)
);

insert into species(species_name)
select distinct species_name
species_name
from public.combined_species_data 
;


-- Junction table

--https://dba.stackexchange.com/questions/146774/populating-a-junction-table

drop table sp_loc;

CREATE TABLE sp_loc (
  spec_id int,
 loc_id int)
;

insert into sp_loc (spec_id,loc_id)
SELECT  species_id ,
        locality_id 
FROM species CROSS JOIN localities ;

ALTER TABLE sp_loc
add constraint sp_id_fkey foreign key (spec_id) references species (species_id);

ALTER TABLE sp_loc
add constraint loc_id_fkey foreign key (loc_id) references localities (locality_id);

select 
*
from 
sp_loc;

select species.species_name 
from 
species
join
sp_loc 
on species.species_id = sp_loc.spec_id
;

select 
*
from 
sp_loc;


select *
from 
combined_species_data 
;

select 
species_name,
locality ,
dense_rank () over (order by species_name)
from 
combined_species_data csd 
;