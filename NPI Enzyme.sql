--Healthcare Database Prime
----National Provider Identifier Reference Table Enzyme Code
select *
--into REF_TBL_NPI_AI_Master
from [NPI As Imported]

select *
from REF_TBL_NPI_AI_Master
where npi = '1831352590'

--Create table of practiece address info:
----1. Find table ID
select id 
from sysobjects 
where name = 'REF_TBL_NPI_AI_Master'
--812750894 



--Search and replace Table ID below, with value of above statement
----Count columns
select count(*) 
from syscolumns 
where id = '812750894'
--316

--Column Names
----1. List column names in left-to-right order 
select name 
from syscolumns 
where id = '812750894'
order by colid

--Create subset table from AI of relevant/critical to ID fields; renaming columns to HDCP standards.
select NPI,
		[Provider First Line Business Practice Location Address] as PROV_PRACT_ADDRS_1,
		[Provider Second Line Business Practice Location Address] as PROV_PRACT_ADDRS_2,
		[Provider Business Practice Location Address City Name] as PROV_PRACT_City,
		[Provider Business Practice Location Address State Name] as PROV_PRACT_State,
		[Provider Business Practice Location Address Postal Code] as PROV_PRACT_Zip,
		[Provider Business Practice Location Address Telephone Number] as PROV_PRACT_Phone,
		[Provider Business Practice Location Address Fax Number] as PROV_PRACT_Fax
into REF_NPI_Practice_Address
from REF_TBL_NPI_AI_Master

alter table REF_NPI_Practice_Address add NPI_TXT varchar(10)
go 
update REF_NPI_Practice_Address
set NPI_TXT = NPI

--Entity Type: Individual Providers
drop table REF_NPI_Base_INDV
select NPI,'1' as Entity_Type_Code,[Entity Type] as Entity_Type,
		replace([Provider Last Name (Legal Name)],'.','') as Provider_Last_Name,
		replace([Provider First Name],'.','') as Provider_First_Name,replace([Provider Middle Name],'.','') as Provider_Middle_Name,
		[Provider Gender Code] as Provider_Gender_Code,
		replace([Provider Name Suffix Text],'.','') as Provider_Name_Suffix,[Provider Credential Text] as Provider_Credentials
into REF_NPI_Base_INDV				
from REF_TBL_NPI_AI_Master
where [Entity Type] = 'Individual'

select *
from REF_NPI_Base_INDV 

--Clean fields
update REF_NPI_Base_INDV
set Provider_Last_Name = LTRIM(RTRIM(Provider_Last_Name)) 
update REF_NPI_Base_INDV
set Provider_First_Name = LTRIM(RTRIM(Provider_First_Name)) 
update REF_NPI_Base_INDV
set Provider_Middle_Name = LTRIM(RTRIM(Provider_Middle_Name)) 
update REF_NPI_Base_INDV
set Provider_Name_Suffix = LTRIM(RTRIM(Provider_Name_Suffix)) 

--Replace '/' with '-' 
update REF_NPI_Base_INDV
set provider_last_name = replace(provider_last_name,'/','-')

update REF_NPI_Base_INDV
set provider_first_name = replace(provider_first_name,'/','-')

update REF_NPI_Base_INDV
set provider_middle_name = replace(provider_middle_name,'/','-')

--Remove spaces around hyphens
update REF_NPI_Base_INDV
set provider_last_name = replace(provider_last_name,' - ','-')

update REF_NPI_Base_INDV
set provider_last_name = replace(provider_last_name,' -','-')

update REF_NPI_Base_INDV
set provider_last_name = replace(provider_last_name,'- ','-')

update REF_NPI_Base_INDV
set provider_last_name = replace(provider_last_name,'-','')
where right(provider_last_name,1) = '-'

update REF_NPI_Base_INDV
set provider_last_name = replace(provider_last_name,'-','')
where left(provider_last_name,1) = '-'

update REF_NPI_Base_INDV
set provider_first_name = replace(provider_first_name,' - ','-')

update REF_NPI_Base_INDV
set provider_first_name = replace(provider_first_name,' -','-')

update REF_NPI_Base_INDV
set provider_first_name = replace(provider_first_name,'- ','-')

update REF_NPI_Base_INDV
set provider_first_name = replace(provider_first_name,'-','')
where right(provider_first_name,1) = '-'


update REF_NPI_Base_INDV
set provider_middle_name = replace(provider_middle_name,' - ','-')

update REF_NPI_Base_INDV
set provider_middle_name = replace(provider_middle_name,' -','-')

update REF_NPI_Base_INDV
set provider_middle_name = replace(provider_middle_name,'- ','-')

update REF_NPI_Base_INDV
set provider_middle_name = replace(provider_middle_name,'-','')
where right(provider_middle_name,1) = '-'

update REF_NPI_Base_INDV
set provider_middle_name = replace(provider_middle_name,'-','')
where left(provider_middle_name,1) = '-'


--Remove spaces around apostrophes
select *
from REF_NPI_Base_INDV
where provider_last_name like '%''%'

update REF_NPI_Base_INDV
set provider_last_name = replace(provider_last_name,' '' ','''')

update REF_NPI_Base_INDV
set provider_last_name = replace(provider_last_name,' ''','''')

update REF_NPI_Base_INDV
set provider_last_name = replace(provider_last_name,''' ','''')

update REF_NPI_Base_INDV
set provider_last_name = replace(provider_last_name,'''','')
where right(provider_last_name,1) = ''''

update REF_NPI_Base_INDV
set provider_last_name = replace(provider_last_name,'''','')
where left(provider_last_name,1) = ''''

update REF_NPI_Base_INDV
set provider_first_name = replace(provider_first_name,' '' ','''')

update REF_NPI_Base_INDV
set provider_first_name = replace(provider_first_name,' ''','''')

update REF_NPI_Base_INDV
set provider_first_name = replace(provider_first_name,''' ','''')

update REF_NPI_Base_INDV
set provider_first_name = replace(provider_first_name,'''','')
where right(provider_first_name,1) = ''''


update REF_NPI_Base_INDV
set provider_middle_name = replace(provider_middle_name,' '' ','''')

update REF_NPI_Base_INDV
set provider_middle_name = replace(provider_middle_name,' ''','''')

update REF_NPI_Base_INDV
set provider_middle_name = replace(provider_middle_name,''' ','''')

update REF_NPI_Base_INDV
set provider_middle_name = replace(provider_middle_name,'''','')
where right(provider_middle_name,1) = ''''

update REF_NPI_Base_INDV
set provider_middle_name = replace(provider_middle_name,'''','')
where left(provider_middle_name,1) = ''''





--Re-style Names from SMITH to Smith
----Add on length of name fields
select a.NPI,
		a.Entity_Type_Code,a.Entity_Type,
		a.Provider_Last_Name,a.Provider_First_Name,a.Provider_Middle_Name,a.Provider_Gender_Code,
		a.Provider_Name_Suffix,a.Provider_Credentials_2 as Provider_Credentials,
		LEN(a.provider_last_name) as len_prov_lname,
		charindex('-',a.Provider_Last_Name) as lname_hyphen_loc,
		charindex('''',a.Provider_Last_Name) as lname_apstr_loc,
		charindex(' ',a.Provider_Last_Name) as lname_space_loc,
		LEN(a.provider_first_name) as len_prov_fname,
		charindex('-',a.Provider_First_Name) as fname_hyphen_loc,
		charindex('''',a.Provider_First_Name) as fname_apstr_loc,
		charindex(' ',a.Provider_First_Name) as fname_space_loc,
		LEN(a.provider_middle_name) as len_prov_mname,
		charindex('''',a.Provider_Middle_Name) as mname_apstr_loc,
		charindex('-',a.Provider_Middle_Name) as mname_hyphen_loc,
		charindex(' ',a.Provider_Middle_Name) as mname_space_loc
into REF_NPI_Base_INDV_2		
from REF_NPI_Base_INDV a

drop table REF_NPI_Base_INDV
exec sp_rename 'REF_NPI_Base_INDV_2','REF_NPI_Base_INDV'

select *
select npi,charindex(' ',right(a.Provider_Last_Name,(len_prov_lname-lname_space_loc))) as lname_space_loc
from REF_NPI_Base_INDV a
where lname_space_loc <> 0

select *
from REF_NPI_Base_INDV
where npi = '1629223557'

--Update provider names 
alter table REF_NPI_Base_INDV add PROV_LNAME_WRK nvarchar(255)
go

update REF_NPI_Base_INDV
set PROV_LNAME_WRK = null


--Set first letter as cap, all following as lower case, e.g. to Fanning from FANNING
--Last Name WITHOUT hyphen or spaces
update REF_NPI_Base_INDV
set PROV_LNAME_WRK = left(Provider_Last_Name,1)+lower(RIGHT(Provider_Last_Name,len_prov_lname-1))


--Hyphens: set letter right of hyphen as cap, e.g. Smith-jones to Smith-Jones:
update REF_NPI_Base_INDV
set PROV_LNAME_WRK = left(PROV_LNAME_WRK,lname_hyphen_loc)
						+upper(substring(PROV_LNAME_WRK,lname_hyphen_loc+1,1))
						+right(PROV_LNAME_WRK,len_prov_lname-lname_hyphen_loc-1)
where lname_hyphen_loc <> 0




--Apostrophe's:set letters right apostrophe as cap, e.g. o'brien to O'Brien
update REF_NPI_Base_INDV
set PROV_LNAME_WRK = left(PROV_LNAME_WRK,lname_apstr_loc)+
						upper(substring(PROV_LNAME_WRK,lname_apstr_loc+1,1))
						+right(PROV_LNAME_WRK,len_prov_lname-lname_apstr_loc-1)
where lname_apstr_loc = 2
		or
		(lname_apstr_loc-2 = lname_hyphen_loc
			and
			lname_hyphen_loc > 0)


update REF_NPI_Base_INDV
set PROV_LNAME_WRK = left(PROV_LNAME_WRK,lname_apstr_loc)+
						upper(substring(PROV_LNAME_WRK,lname_apstr_loc+1,1))
						+right(PROV_LNAME_WRK,len_prov_lname-lname_apstr_loc-1)
where lname_apstr_loc = 3
		or
		(lname_apstr_loc-3 = lname_hyphen_loc
			and
			lname_hyphen_loc > 0)




--Spaces: set letter right of space as cap, e.g. Smith jones to Smith Jones:
update REF_NPI_Base_INDV
set PROV_LNAME_WRK = left(PROV_LNAME_WRK,lname_space_loc)
						+upper(substring(PROV_LNAME_WRK,lname_space_loc+1,1))
						+right(PROV_LNAME_WRK,len_prov_lname-lname_space_loc-1)
where lname_space_loc <> 0


-----Last names with more than 1 space:
select *
from REF_NPI_Base_INDV
where lname_space_loc <> 0

select *
select npi,right(PROV_LNAME_WRK,len_prov_lname-lname_space_loc),PROV_LNAME_WRK
--select npi,charindex(' ',right(ltrim(rtrim(PROV_LNAME_WRK)),lname_space_loc+1)),PROV_LNAME_WRK
from REF_NPI_Base_INDV
where lname_space_loc <> 0
		and
		charindex(' ',right(ltrim(rtrim(PROV_LNAME_WRK)),lname_space_loc+1)) > 0


--Add-on len PROV_LNAME_WRK
alter table REF_NPI_Base_INDV add len_prov_lname_wrk integer
go
update REF_NPI_Base_INDV
set len_prov_lname_wrk = len(PROV_LNAME_WRK)


--Add-on location of second space
alter table REF_NPI_Base_INDV add lname_space_loc2 integer
go
update REF_NPI_Base_INDV
set lname_space_loc2 = null

update REF_NPI_Base_INDV
set lname_space_loc2 = lname_space_loc+charindex(' ',right(PROV_LNAME_WRK,len_prov_lname_wrk-lname_space_loc))
where lname_space_loc <> 0

update REF_NPI_Base_INDV
set lname_space_loc2 = 0
where lname_space_loc = lname_space_loc2

select *
from REF_NPI_Base_INDV
where lname_space_loc2 <> 0

update REF_NPI_Base_INDV
set PROV_LNAME_WRK = left(PROV_LNAME_WRK,lname_space_loc2)
						+upper(substring(PROV_LNAME_WRK,lname_space_loc2+1,1))
						+right(PROV_LNAME_WRK,len_prov_lname_wrk-lname_space_loc2-1)
where lname_space_loc2 <> 0




--Add-on location of third space
alter table REF_NPI_Base_INDV add lname_space_loc3 integer
go
--update REF_NPI_Base_INDV
--set lname_space_loc3 = null

update REF_NPI_Base_INDV
set lname_space_loc3 = lname_space_loc2+charindex(' ',right(PROV_LNAME_WRK,len_prov_lname_wrk-lname_space_loc2))
where lname_space_loc2 <> 0

update REF_NPI_Base_INDV
set lname_space_loc3 = 0
where lname_space_loc2 = lname_space_loc3

select *
from REF_NPI_Base_INDV
where lname_space_loc3 <> 0

update REF_NPI_Base_INDV
set PROV_LNAME_WRK = left(PROV_LNAME_WRK,lname_space_loc3)
						+upper(substring(PROV_LNAME_WRK,lname_space_loc3+1,1))
						+right(PROV_LNAME_WRK,len_prov_lname_wrk-lname_space_loc3-1)
where lname_space_loc3 <> 0




--Add-on location of fourth space
alter table REF_NPI_Base_INDV add lname_space_loc4 integer
go
--update REF_NPI_Base_INDV
--set lname_space_loc3 = null

update REF_NPI_Base_INDV
set lname_space_loc4 = lname_space_loc3+charindex(' ',right(PROV_LNAME_WRK,len_prov_lname_wrk-lname_space_loc3))
where lname_space_loc3 <> 0

update REF_NPI_Base_INDV
set lname_space_loc4 = 0
where lname_space_loc3 = lname_space_loc4

select *
from REF_NPI_Base_INDV
where lname_space_loc4 <> 0

update REF_NPI_Base_INDV
set PROV_LNAME_WRK = left(PROV_LNAME_WRK,lname_space_loc4)
						+upper(substring(PROV_LNAME_WRK,lname_space_loc4+1,1))
						+right(PROV_LNAME_WRK,len_prov_lname_wrk-lname_space_loc4-1)
where lname_space_loc4 <> 0


--Last Name Tweaks:
select distinct npi,PROV_LNAME_WRK,left(prov_lname_wrk,2)+UPPER(substring(prov_lname_wrk,3,1))+right(prov_lname_wrk,len(prov_lname_wrk)-3)
from REF_NPI_Base_INDV
where LEFT(prov_lname_wrk,2) = 'Mc'

select distinct npi,PROV_LNAME_WRK,'O ','O'''
from REF_NPI_Base_INDV
where prov_lname_wrk like '% O %'

select distinct npi,PROV_LNAME_WRK,lower(left(prov_lname_wrk,1))+right(prov_lname_wrk,len(prov_lname_wrk)-1)
from REF_NPI_Base_INDV
where prov_lname_wrk like 'von %'


update REF_NPI_Base_INDV
set prov_lname_wrk = left(prov_lname_wrk,2)+UPPER(substring(prov_lname_wrk,3,1))+right(prov_lname_wrk,len(prov_lname_wrk)-3)
where LEFT(prov_lname_wrk,2) = 'Mc'

update REF_NPI_Base_INDV
set prov_lname_wrk = left(prov_lname_wrk,3)+UPPER(substring(prov_lname_wrk,4,1))+right(prov_lname_wrk,len(prov_lname_wrk)-4)
where LEFT(prov_lname_wrk,3) = 'Mac'
		and
		len(prov_lname_wrk)>4

update REF_NPI_Base_INDV
set prov_lname_wrk = replace(prov_lname_wrk,'O ','O''')
where prov_lname_wrk like 'O %'

update REF_NPI_Base_INDV
set prov_lname_wrk = replace(prov_lname_wrk,'O ','O''')
where prov_lname_wrk like '% O %'

update REF_NPI_Base_INDV
set prov_lname_wrk = lower(left(prov_lname_wrk,1))+right(prov_lname_wrk,len(prov_lname_wrk)-1)
where prov_lname_wrk like 'von %'

update REF_NPI_Base_INDV
set prov_lname_wrk = replace(prov_lname_wrk,'Von','von')
where prov_lname_wrk like '% Von %'

update REF_NPI_Base_INDV
set prov_lname_wrk = replace(prov_lname_wrk,'Von','von')
where prov_lname_wrk like '%-Von %'


select *
from REF_NPI_Base_INDV
where prov_lname_wrk like 'St %'
		or
		prov_lname_wrk like '%-St %'
		or
		prov_lname_wrk like '% St %'


update REF_NPI_Base_INDV
set prov_lname_wrk = replace(prov_lname_wrk,'St ','St. ')
where prov_lname_wrk like 'St %'
		or
		prov_lname_wrk like '%-St %'
		or
		prov_lname_wrk like '% St %'





		
--Update provider first name
alter table REF_NPI_Base_INDV add PROV_FNAME_WRK nvarchar(255)
go

--update REF_NPI_Base_INDV
--set PROV_FNAME_WRK = null

select *
from REF_NPI_Base_INDV

--Set first letter as cap, all following as lower case, e.g. to Fanning from FANNING
update REF_NPI_Base_INDV
set PROV_FNAME_WRK = left(Provider_First_Name,1)+lower(RIGHT(Provider_First_Name,len_prov_fname-1))


--Hyphens: set letter right of hyphen as cap, e.g. Smith-jones to Smith-Jones:
update REF_NPI_Base_INDV
set PROV_FNAME_WRK = left(PROV_FNAME_WRK,fname_hyphen_loc)
						+upper(substring(PROV_FNAME_WRK,fname_hyphen_loc+1,1))
						+right(PROV_FNAME_WRK,len_prov_fname-fname_hyphen_loc-1)
where fname_hyphen_loc <> 0




--Apostrophe's:set letters right apostrophe as cap, e.g. o'brien to O'Brien
update REF_NPI_Base_INDV
set PROV_FNAME_WRK = left(PROV_FNAME_WRK,fname_apstr_loc)+
						upper(substring(PROV_FNAME_WRK,fname_apstr_loc+1,1))
						+right(PROV_FNAME_WRK,len_prov_fname-fname_apstr_loc-1)
where fname_apstr_loc = 2
		or
		(fname_apstr_loc-2 = fname_hyphen_loc
			and
			fname_hyphen_loc > 0)


update REF_NPI_Base_INDV
set PROV_FNAME_WRK = left(PROV_FNAME_WRK,fname_apstr_loc)+
						upper(substring(PROV_FNAME_WRK,fname_apstr_loc+1,1))
						+right(PROV_FNAME_WRK,len_prov_fname-fname_apstr_loc-1)
where fname_apstr_loc = 3
		or
		(fname_apstr_loc-3 = fname_hyphen_loc
			and
			fname_hyphen_loc > 0)




--Spaces: set letter right of space as cap, e.g. Smith jones to Smith Jones:
update REF_NPI_Base_INDV
set PROV_FNAME_WRK = left(PROV_FNAME_WRK,fname_space_loc)
						+upper(substring(PROV_FNAME_WRK,fname_space_loc+1,1))
						+right(PROV_FNAME_WRK,len_prov_fname-fname_space_loc-1)
where fname_space_loc <> 0


-----Last names with more than 1 space:
select *
from REF_NPI_Base_INDV
where fname_space_loc <> 0



--Add-on len PROV_FNAME_WRK
alter table REF_NPI_Base_INDV add len_PROV_FNAME_WRK integer
go
update REF_NPI_Base_INDV
set len_PROV_FNAME_WRK = len(PROV_FNAME_WRK)


--Add-on location of second space
alter table REF_NPI_Base_INDV add fname_space_loc2 integer
go
update REF_NPI_Base_INDV
set fname_space_loc2 = null

update REF_NPI_Base_INDV
set fname_space_loc2 = fname_space_loc+charindex(' ',right(PROV_FNAME_WRK,len_PROV_FNAME_WRK-fname_space_loc))
where fname_space_loc <> 0

update REF_NPI_Base_INDV
set fname_space_loc2 = 0
where fname_space_loc = fname_space_loc2

select *
from REF_NPI_Base_INDV
where fname_space_loc2 <> 0

update REF_NPI_Base_INDV
set PROV_FNAME_WRK = left(PROV_FNAME_WRK,fname_space_loc2)
						+upper(substring(PROV_FNAME_WRK,fname_space_loc2+1,1))
						+right(PROV_FNAME_WRK,len_PROV_FNAME_WRK-fname_space_loc2-1)
where fname_space_loc2 <> 0



--Remove (nick names)
select *
from REF_NPI_Base_INDV
where prov_fname_wrk like '%(%'

--Add-on location of left parenthesis
alter table REF_NPI_Base_INDV add fname_lft_paren_loc integer
go

update REF_NPI_Base_INDV
set fname_lft_paren_loc = charindex('(',PROV_FNAME_WRK)

--Add-on location of right parenthesis
alter table REF_NPI_Base_INDV add fname_rht_paren_loc integer
go

update REF_NPI_Base_INDV
set fname_rht_paren_loc = charindex(')',PROV_FNAME_WRK)

select *
from REF_NPI_Base_INDV
where fname_lft_paren_loc > 1
		and
		fname_rht_paren_loc = len_prov_fname_wrk

update REF_NPI_Base_INDV
set prov_fname_wrk = ltrim(rtrim(left(prov_fname_wrk,fname_lft_paren_loc-1)))
where fname_lft_paren_loc > 1



update REF_NPI_Base_INDV
set prov_fname_wrk = replace(prov_fname_wrk,'(','')
where fname_lft_paren_loc = 1
		and
		fname_rht_paren_loc = len_prov_fname_wrk

update REF_NPI_Base_INDV
set prov_fname_wrk = replace(prov_fname_wrk,')','')
where fname_lft_paren_loc = 1
		and
		fname_rht_paren_loc = len_prov_fname_wrk

update REF_NPI_Base_INDV
set prov_fname_wrk = replace(prov_fname_wrk,')','')
where fname_lft_paren_loc = 1
		and
		fname_rht_paren_loc = len_prov_fname_wrk

update REF_NPI_Base_INDV
set PROV_FNAME_WRK = upper(left(prov_fname_wrk,1))+RIGHT(prov_fname_wrk,len(prov_fname_wrk)-1)
where fname_lft_paren_loc = 1
		and
		fname_rht_paren_loc = len_prov_fname_wrk


update REF_NPI_Base_INDV
set prov_fname_wrk = ltrim(rtrim(right(prov_fname_wrk,len_prov_fname_wrk-fname_rht_paren_loc)))
where fname_lft_paren_loc = 1
		and
		fname_rht_paren_loc <> len_prov_fname_wrk


select *
from REF_NPI_Base_INDV
where fname_lft_paren_loc > 1
		and
		fname_rht_paren_loc <> len_prov_fname_wrk



--First Name Tweaks:
update REF_NPI_Base_INDV
set PROV_FNAME_WRK = left(PROV_FNAME_WRK,2)+UPPER(substring(PROV_FNAME_WRK,3,1))+right(PROV_FNAME_WRK,len(PROV_FNAME_WRK)-3)
where LEFT(PROV_FNAME_WRK,2) = 'Mc'
		and
		len(PROV_FNAME_WRK)>3

update REF_NPI_Base_INDV
set PROV_FNAME_WRK = left(PROV_FNAME_WRK,3)+UPPER(substring(PROV_FNAME_WRK,4,1))+right(PROV_FNAME_WRK,len(PROV_FNAME_WRK)-4)
where LEFT(PROV_FNAME_WRK,3) = 'Mac'
		and
		len(PROV_FNAME_WRK)>4

update REF_NPI_Base_INDV
set PROV_FNAME_WRK = replace(PROV_FNAME_WRK,'O ','O''')
where PROV_FNAME_WRK like 'O %'

update REF_NPI_Base_INDV
set PROV_FNAME_WRK = replace(PROV_FNAME_WRK,'O ','O''')
where PROV_FNAME_WRK like '% O %'

update REF_NPI_Base_INDV
set prov_lname_wrk = replace(prov_lname_wrk,'St ','St. ')
where prov_lname_wrk like 'St %'
		or
		prov_lname_wrk like '%-St %'
		or
		prov_lname_wrk like '% St %'


update REF_NPI_Base_INDV
set prov_fname_wrk = prov_fname_wrk+'.'
where LEN(prov_fname_wrk) = 1

update REF_NPI_Base_INDV
set prov_fname_wrk = prov_fname_wrk+'.'
where substring(prov_fname_wrk,len(prov_fname_wrk)-1,1) = ' '

update REF_NPI_Base_INDV
set prov_fname_wrk = left(prov_fname_wrk,1)+'.'+RIGHT(prov_fname_wrk,len(prov_fname_wrk)-1)
where substring(prov_fname_wrk,2,1) = ' '



--Add-on prov fname first initial
alter table REF_NPI_Base_INDV add PROV_FNAME_INTL varchar(1)
go
update REF_NPI_Base_INDV
set PROV_FNAME_INTL = left(prov_fname_wrk,1)
where prov_fname_wrk is not null

--Add-on prov_lname_match
--alter table REF_NPI_Base_INDV add prov_name_match varchar(255)
--go
update REF_NPI_Base_INDV 
set prov_name_match = upper(prov_lname_wrk)+PROV_FNAME_INTL
where provider_first_name is not null

update REF_NPI_Base_INDV 
set prov_name_match = upper(prov_lname_wrk)
where provider_first_name is null

update REF_NPI_Base_INDV 
set prov_name_match = ltrim(rtrim(replace(prov_name_match,'-','')))

update REF_NPI_Base_INDV 
set prov_name_match = replace(prov_name_match,' ','')

select *
from REF_NPI_Base_INDV


--Add-on prov full name match
alter table REF_NPI_Base_INDV add prov_full_name_match varchar(255)
go
update REF_NPI_Base_INDV
set prov_full_name_match = provider_last_name+provider_first_name+provider_middle_name
where provider_middle_name is not null

update REF_NPI_Base_INDV
set prov_full_name_match = provider_last_name+provider_first_name
where provider_middle_name is null


update REF_NPI_Base_INDV
set prov_full_name_match = replace(prov_full_name_match,' ','')

update REF_NPI_Base_INDV
set prov_full_name_match = replace(prov_full_name_match,'-','')

update REF_NPI_Base_INDV
set prov_full_name_match = replace(prov_full_name_match,'''','')

update REF_NPI_Base_INDV
set prov_full_name_match = replace(prov_full_name_match,'.','')

update REF_NPI_Base_INDV
set prov_full_name_match = replace(prov_full_name_match,'/','')

update REF_NPI_Base_INDV
set prov_full_name_match = replace(prov_full_name_match,'\','')

update REF_NPI_Base_INDV
set prov_full_name_match = replace(prov_full_name_match,'(','')

update REF_NPI_Base_INDV
set prov_full_name_match = replace(prov_full_name_match,')','')

update REF_NPI_Base_INDV
set prov_full_name_match = replace(prov_full_name_match,',','')

select *
from REF_NPI_Base_INDV

----Middle Name Tweaks:
--update REF_NPI_Base_INDV
--set prov_mname_wrk = prov_mname_wrk+'.'
--where LEN(prov_mname_wrk) = 1
--
--update REF_NPI_Base_INDV
--set prov_mname_wrk = prov_mname_wrk+'.'
--where substring(prov_mname_wrk,len(prov_mname_wrk)-1,1) = ' '
--		and
--		LEN(prov_mname_wrk) > 1
--
--update REF_NPI_Base_INDV
--set prov_mname_wrk = left(prov_mname_wrk,1)+'.'+RIGHT(prov_mname_wrk,len(prov_mname_wrk)-1)
--where substring(prov_mname_wrk,2,1) = ' '
--		and
--		LEN(prov_mname_wrk) > 1
--		
--		
--update REF_NPI_Base_INDV
--set PROV_MNAME_WRK = ' '
--where PROV_MNAME_WRK is null
--		
--update REF_NPI_Base_INDV
--set Provider_Middle_Name = PROV_MNAME_WRK
--






--Add-on Provider_Name
alter table REF_NPI_Base_INDV add Provider_Name nvarchar(150)
go 
update REF_NPI_Base_INDV
set Provider_Name = PROV_FNAME_WRK+' '+PROV_LNAME_WRK

alter table REF_NPI_Base_INDV add Provider_Name_Credentials nvarchar(150)
go 
update REF_NPI_Base_INDV
set Provider_Name_Credentials = Provider_Name+' '+Provider_Credentials

select *
from REF_NPI_Base_INDV
where prov_name_match like '%('

drop table REF_NPI_Base_INDV_Master
select distinct Entity_Type_Code,Entity_Type,NPI,Provider_Name_Credentials,Provider_Gender_Code,
				Provider_Name,Provider_Last_Name,Provider_First_Name,Provider_Middle_Name,Provider_Name_Suffix,
				Provider_Credentials
into REF_NPI_Base_INDV_Master
from REF_NPI_Base_INDV
order by 1,2,3

select *
from REF_NPI_Base_INDV_Master
where npi = '1235132382'

select *
from REF_NPI_Base_INDV_Master
where LEFT(provider_last_name,2) = 'De'


select *
from REF_TBL_NPI_AI_Master
where npi = '1235132382'

--David -*Dempsey FNP,BC




--Entity Type: Organizations
drop table REF_NPI_Base_ORG
select NPI,'2' as Entity_Type_Code,[Entity Type] as Entity_Type,
		ltrim(rtrim([Provider Organization Name (Legal Business Name)])) as Provider_Name_Legal,
		ltrim(rtrim([Provider Other Organization Name])) as Provider_Name
into REF_NPI_Base_ORG	
from REF_TBL_NPI_AI_Master
where [Entity Type] <> 'Individual'

select *
from REF_NPI_Base_ORG 


--Replace '/' with '-' 
update REF_NPI_Base_ORG
set Provider_Name_Legal = replace(Provider_Name_Legal,'/','-')

update REF_NPI_Base_ORG
set Provider_Name = replace(Provider_Name,'/','-')


--Remove spaces around hyphens
update REF_NPI_Base_ORG
set Provider_Name_Legal = replace(Provider_Name_Legal,' - ','-')

update REF_NPI_Base_ORG
set Provider_Name_Legal = replace(Provider_Name_Legal,' -','-')

update REF_NPI_Base_ORG
set Provider_Name_Legal = replace(Provider_Name_Legal,'- ','-')

update REF_NPI_Base_ORG
set Provider_Name_Legal = replace(Provider_Name_Legal,'-','')
where right(Provider_Name_Legal,1) = '-'

update REF_NPI_Base_ORG
set Provider_Name_Legal = replace(Provider_Name_Legal,'-','')
where left(Provider_Name_Legal,1) = '-'


update REF_NPI_Base_ORG
set Provider_Name = replace(Provider_Name,' - ','-')

update REF_NPI_Base_ORG
set Provider_Name = replace(Provider_Name,' -','-')

update REF_NPI_Base_ORG
set Provider_Name = replace(Provider_Name,'- ','-')

update REF_NPI_Base_ORG
set Provider_Name = replace(Provider_Name,'-','')
where right(Provider_Name,1) = '-'

update REF_NPI_Base_ORG
set Provider_Name = replace(Provider_Name,'-','')
where left(Provider_Name,1) = '-'



--Remove spaces around apostrophes
select *
from REF_NPI_Base_ORG
where Provider_Name like '%''%'

update REF_NPI_Base_ORG
set Provider_Name = replace(Provider_Name,' '' ','''')

update REF_NPI_Base_ORG
set Provider_Name = replace(Provider_Name,' ''','''')

update REF_NPI_Base_ORG
set Provider_Name = replace(Provider_Name,''' ','''')

update REF_NPI_Base_ORG
set Provider_Name = replace(Provider_Name,'''','')
where right(Provider_Name,1) = ''''

update REF_NPI_Base_ORG
set Provider_Name = replace(Provider_Name,'''','')
where left(Provider_Name,1) = ''''

update REF_NPI_Base_ORG
set Provider_Name_Legal = replace(Provider_Name_Legal,' '' ','''')

update REF_NPI_Base_ORG
set Provider_Name_Legal = replace(Provider_Name_Legal,' ''','''')

update REF_NPI_Base_ORG
set Provider_Name_Legal = replace(Provider_Name_Legal,''' ','''')

update REF_NPI_Base_ORG
set Provider_Name_Legal = replace(Provider_Name_Legal,'''','')
where right(Provider_Name_Legal,1) = ''''

select *
from REF_NPI_Base_ORG

update REF_NPI_Base_ORG
set provider_name = provider_name_legal
where provider_name is null



--Add-on prov_lname_match
alter table REF_NPI_Base_ORG add prov_name_match varchar(255)
go
update REF_NPI_Base_ORG 
set prov_name_match = replace(provider_name,'-','')

update REF_NPI_Base_ORG 
set prov_name_match = replace(prov_name_match,' ','')

update REF_NPI_Base_ORG 
set prov_name_match = replace(prov_name_match,'','')

update REF_NPI_Base_ORG 
set prov_name_match = replace(prov_name_match,',','')

update REF_NPI_Base_ORG 
set prov_name_match = replace(prov_name_match,'.','')

--Recreate NPI
alter table REF_NPI_Base_ORG add NPI_TXT varchar(10)
go
update REF_NPI_Base_ORG 
set npi_txt = npi


--Recreate provider name:
alter table REF_NPI_Base_ORG add Provider_Name2 nvarchar(150)
go 
update REF_NPI_Base_ORG
set Provider_Name2 = Provider_Name

select NPI_TXT as NPI,Entity_Type_Code,Entity_Type,
		Provider_Name2 as Provider_Name,Provider_Name_Legal,
		prov_name_match as PROV_Name_Match
into REF_NPI_Base_ORG_2
from REF_NPI_Base_ORG
		
drop table REF_NPI_Base_ORG
exec sp_rename 'REF_NPI_Base_ORG_2','REF_NPI_Base_ORG'

select *
from REF_NPI_Base_ORG

--Combine ORG AND INDV into NPI name reference master:

--Recreate NPI in REF_NPI_Base_INDV
alter table REF_NPI_Base_INDV add NPI_TXT varchar(10)
go
update REF_NPI_Base_INDV 
set npi_txt = npi

select npi_txt as NPI,Entity_Type_Code,Entity_Type,
		Provider_Name,Provider_Credentials,
		prov_lname_wrk as Provider_Last_Name,prov_fname_wrk as Provider_First_Name
into REF_NPI_Provider_Name
from REF_NPI_Base_INDV
union all
select NPI,Entity_Type_Code,Entity_Type,
		Provider_Name,null as Provider_Credentials,
		null as Provider_Last_Name,null as Provider_First_Name
from REF_NPI_Base_ORG
order by 2,1

select *
from REF_NPI_Provider_Name



--Add-on Taxonomy_Specialty
select *
from REF_TBL_NPI_AI_Master


drop table REF_NPI_ID_Taxonomy_SPCLTY_XWALK
select NPI,'1' as Entity_Type_Code,[Entity Type] as Entity_Type,ltrim(rtrim([Healthcare Provider Taxonomy Code_1])) as Provider_Taxonomy_Code
into REF_NPI_ID_Taxonomy_SPCLTY_XWALK				
from REF_TBL_NPI_AI_Master

update REF_NPI_ID_Taxonomy_SPCLTY_XWALK
set Entity_Type_Code = '2'
where Entity_Type = 'Organization'

alter table REF_NPI_ID_Taxonomy_SPCLTY_XWALK add Taxonomy_Code varchar(10)
go
update REF_NPI_ID_Taxonomy_SPCLTY_XWALK
set Taxonomy_Code = Provider_Taxonomy_Code

alter table REF_NPI_ID_Taxonomy_SPCLTY_XWALK drop column Provider_Taxonomy_Code 

update REF_NPI_ID_Taxonomy_SPCLTY_XWALK
set taxonomy_code = '999999999X'
where taxonomy_code is null


--select *
--into REF_NPI_ID_TXNMY_174400000X
--from REF_NPI_ID_Taxonomy_SPCLTY_XWALK
--where taxonomy_code = '174400000X'
--
--drop table REF_NPI_ID_TXNMY_174400000X_CD2
--select NPI,[Entity Type] as Entity_Type,ltrim(rtrim([Healthcare Provider Taxonomy Code_2])) as Provider_Taxonomy_Code2
--into REF_NPI_ID_TXNMY_174400000X_CD2				
--from REF_TBL_NPI_AI_Master
--where [Healthcare Provider Taxonomy Code_1] = '174400000X'
--
--delete from REF_NPI_ID_TXNMY_174400000X_CD2
--where Provider_Taxonomy_Code2 is null
--
--delete from REF_NPI_ID_TXNMY_174400000X_CD2
--where Provider_Taxonomy_Code2 = '174400000X'
--
--select *
--from REF_NPI_ID_TXNMY_174400000X_CD2
--
--alter table REF_NPI_ID_TXNMY_174400000X_CD2 add Taxonomy_Code varchar(10)
--go
--update REF_NPI_ID_TXNMY_174400000X_CD2
--set Taxonomy_Code = Provider_Taxonomy_Code2
--
--select a.*,b.Taxonomy_Code as Taxonomy_Code2
--into REF_NPI_ID_TXNMY_174400000X_2
--from REF_NPI_ID_TXNMY_174400000X a inner join REF_NPI_ID_TXNMY_174400000X_CD2 b
--on a.npi = b.npi
--
--drop table REF_NPI_ID_TXNMY_174400000X
--exec sp_rename 'REF_NPI_ID_TXNMY_174400000X_2','REF_NPI_ID_TXNMY_174400000X'

select a.*,b.Taxonomy_Code2
into REF_NPI_ID_Taxonomy_SPCLTY_XWALK_2
from REF_NPI_ID_Taxonomy_SPCLTY_XWALK a left outer join REF_NPI_ID_TXNMY_174400000X b
on a.npi = b.npi

update REF_NPI_ID_Taxonomy_SPCLTY_XWALK_2
set Taxonomy_Code = Taxonomy_Code2
where Taxonomy_Code2 is not null

alter table REF_NPI_ID_Taxonomy_SPCLTY_XWALK_2 drop column Taxonomy_Code2

drop table REF_NPI_ID_Taxonomy_SPCLTY_XWALK
exec sp_rename 'REF_NPI_ID_Taxonomy_SPCLTY_XWALK_2','REF_NPI_ID_Taxonomy_SPCLTY_XWALK'

select *
from REF_NPI_ID_Taxonomy_SPCLTY_XWALK
where npi in
		(select npi
			from REF_NPI_ID_TXNMY_174400000X)


--Add-on Taxonomy descriptor fields:
select a.NPI,Entity_Type_Code,a.Entity_Type,a.Taxonomy_Code as Taxonomy_CD_Listed,b.*
into REF_NPI_ID_Taxonomy_SPCLTY_XWALK_2
from REF_NPI_ID_Taxonomy_SPCLTY_XWALK a left outer join REF_Provider_Taxonomy_to_CMS_XWALK b
on a.Taxonomy_Code = b.Taxonomy_Code

drop table REF_NPI_ID_Taxonomy_SPCLTY_XWALK
exec sp_rename 'REF_NPI_ID_Taxonomy_SPCLTY_XWALK_2','REF_NPI_ID_Taxonomy_SPCLTY_XWALK'

select *
from REF_NPI_ID_Taxonomy_SPCLTY_XWALK

alter table REF_NPI_ID_Taxonomy_SPCLTY_XWALK add NPI_TXT varchar(10)
go
update REF_NPI_ID_Taxonomy_SPCLTY_XWALK 
set npi_txt = npi

select *
from REF_NPI_ID_Taxonomy_SPCLTY_XWALK

--Rename/Reorder fields: 
select NPI_TXT as NPI,Entity_Type_Code,Entity_Type,
		Taxonomy_Code,Taxonomy_Group,Taxonomy_Type,Taxonomy_Class,Taxonomy_Specialty,Taxonomy_Sub_Specialty,
		CMS_Specialty_Code,CMS_Specialty
into REF_NPI_ID_Taxonomy_SPCLTY_XWALK_2
from REF_NPI_ID_Taxonomy_SPCLTY_XWALK
order by 1

drop table REF_NPI_ID_Taxonomy_SPCLTY_XWALK
exec sp_rename 'REF_NPI_ID_Taxonomy_SPCLTY_XWALK_2','REF_NPI_ID_Taxonomy_SPCLTY_XWALK'


--Create table with name and taxonomy
select *
from REF_NPI_Provider_Name

select *
from REF_NPI_ID_Taxonomy_SPCLTY_XWALK


drop table REF_NPI_Provider_Name_Taxnonomy
select a.*,
		b.Taxonomy_Group,b.Taxonomy_Type,b.Taxonomy_Class,
		b.Taxonomy_Code,b.Taxonomy_Specialty,b.Taxonomy_Sub_Specialty,b.CMS_Specialty_Code,b.CMS_Specialty
into REF_NPI_Provider_Name_Taxnonomy
from REF_NPI_Provider_Name a left outer join REF_NPI_ID_Taxonomy_SPCLTY_XWALK b
on a.npi = b.npi


select taxonomy_type,count(distinct npi) as npis
from REF_NPI_Provider_Name_Taxnonomy
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_type <> 'Agencies'
group by taxonomy_type
order by npis desc


select taxonomy_type,taxonomy_class,taxonomy_specialty,count(distinct npi) as npis
from REF_NPI_Provider_Name_Taxnonomy
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_type = 'Podiatric Medicine & Surgery Service Providers'
group by taxonomy_type,taxonomy_class,taxonomy_specialty
order by npis desc

select *
from REF_NPI_Provider_Name_Taxnonomy
where taxonomy_class = 'Podiatrist'
		and
		taxonomy_specialty = 'Optician'



--Scrub Provider_Credentials:
alter table REF_NPI_Provider_Name_Taxnonomy add Provider_Credentials_2 varchar(50)
go

update REF_NPI_Provider_Name_Taxnonomy
set Provider_Credentials_2 = replace(Provider_Credentials,'. ','')
update REF_NPI_Provider_Name_Taxnonomy
set Provider_Credentials_2 = replace(Provider_Credentials_2,'.','')
update REF_NPI_Provider_Name_Taxnonomy
set Provider_Credentials_2 = replace(Provider_Credentials_2,',,',',')
update REF_NPI_Provider_Name_Taxnonomy
set Provider_Credentials_2 = replace(Provider_Credentials_2,',',', ')
update REF_NPI_Provider_Name_Taxnonomy
set Provider_Credentials_2 = replace(Provider_Credentials_2,'/',', ')
update REF_NPI_Provider_Name_Taxnonomy
set Provider_Credentials_2 = replace(Provider_Credentials_2,' ,',', ')
update REF_NPI_Provider_Name_Taxnonomy
set Provider_Credentials_2 = replace(Provider_Credentials_2,',  ',', ')
update REF_NPI_Provider_Name_Taxnonomy
set Provider_Credentials_2 = LTRIM(RTRIM(Provider_Credentials_2)) 

update REF_NPI_Provider_Name_Taxnonomy 
set provider_credentials = 'MD'
where provider_credentials = 'M, D'

update REF_NPI_Provider_Name_Taxnonomy 
set provider_credentials = 'MD'
where provider_credentials = 'M D'

update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'MD'
where provider_credentials = 'MD,'

update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'MD'
where provider_credentials = 'M,D,'

update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'MD'
where provider_credentials = 'M, D, '

update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'PHARMD'
where provider_credentials = 'PHARM D'

update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = replace(provider_credentials,';',',')

update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = ltrim(rtrim(replace(provider_credentials,' - ',', ')))



--Add-on length of credentials field
alter table REF_NPI_Provider_Name_Taxnonomy add len_prov_cred integer
go
--update REF_NPI_Provider_Name_Taxnonomy
--set len_prov_cred = null

update REF_NPI_Provider_Name_Taxnonomy
set len_prov_cred = len(provider_credentials)

--Add-on locations of first and second spaces
alter table REF_NPI_Provider_Name_Taxnonomy add prov_cred_space_loc integer
go
--update REF_NPI_Provider_Name_Taxnonomy
--set prov_cred_space_loc = null

update REF_NPI_Provider_Name_Taxnonomy
set prov_cred_space_loc = charindex(' ',provider_credentials)




alter table REF_NPI_Provider_Name_Taxnonomy add prov_cred_space_loc2 integer
go
--update REF_NPI_Provider_Name_Taxnonomy
--set prov_cred_space_loc2 = null

update REF_NPI_Provider_Name_Taxnonomy
set prov_cred_space_loc2 = prov_cred_space_loc+charindex(' ',right(provider_credentials,len_prov_cred-prov_cred_space_loc))
where prov_cred_space_loc <> 0

update REF_NPI_Provider_Name_Taxnonomy
set prov_cred_space_loc2 = 0
where prov_cred_space_loc = prov_cred_space_loc2



--select *
--from REF_NPI_Provider_Name_Taxnonomy
--where prov_cred_space_loc = 0
--		and
--		provider_credentials not like '%,%'
--		and
--		len(provider_credentials) > 6
--		and
--		provider_credentials not like '%-%'

update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = null
where prov_cred_space_loc = 0
		and
		provider_credentials not like '%,%'
		and
		len(provider_credentials) > 6
		and
		provider_credentials not like '%-%'


--select *
--from REF_NPI_Provider_Name_Taxnonomy
--where prov_cred_space_loc > 0
--		and
--		prov_cred_space_loc2 = 0
--		and
--		provider_credentials not like '%,%'
--		and
--		provider_credentials not like '%-%'
--		and
--		len(provider_credentials) > 10

update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = null
where prov_cred_space_loc > 0
		and
		prov_cred_space_loc2 = 0
		and
		provider_credentials not like '%,%'
		and
		provider_credentials not like '%-%'
		and
		len(provider_credentials) > 10

update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'DPM'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Podiatrist'


update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'OD'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_specialty = 'Optometrist'


update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'LDO'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_specialty = 'Optician'


update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'CNS'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Clinical Nurse Specialist'



update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'CNM'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Advanced Practice Midwife'


update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'PA'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Physician Assistant'


update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'CRNA'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Nurse Anesthetist, Certified Registered'


update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'CPHT'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Pharmacy Technician'


update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'PHARMD'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Pharmacist'


update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'AUD'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Audiologist'


update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'SLP'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Speech-Language Pathologist'


update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'CNM'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Midwife'


update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'LAC'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Acupuncturist'


update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'CMP'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Case Manager/Care Coordinator'


update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'CRT'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Respiratory Therapist, Certified'


update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'LMT'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Massage Therapist'


update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'DT'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Developmental Therapist'

update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'COTA'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Occupational Therapy Assistant'

update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'PTA'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Physical Therapy Assistant'


update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'OT'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Occupational Therapist'

update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'PT'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Physical Therapist'

update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'CN'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Nutritionist'


update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'RD'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Dietitian, Registered'

update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'RDH'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Dental Hygienist'


update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'RDA'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Dental Assistant'

update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'DDS'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Dentist'


update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'DC'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Chiropractor'


update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'LPC'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Counselor'
		and
		taxonomy_specialty in ('Counselor','Professional','School')

update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'LMHC'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Counselor'
		and
		taxonomy_specialty = 'Mental Health'


update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'LAC'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Counselor'
		and
		taxonomy_specialty = 'Addiction (Substance Use Disorder)'

update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'DMIN'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Counselor'
		and
		taxonomy_specialty = 'Pastoral'

update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'NP'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Nurse Practitioner'

update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'RN'
where 
		(
			provider_credentials is null
			or
			provider_credentials = 'NP'
		)
		and
		entity_type_code = '1'
		and
		taxonomy_class = 'Registered Nurse'

update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'MD'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_type = 'Allopathic & Osteopathic Physicians'

		
update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'PHD'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_type = 'Behavioral Health & Social Service Providers'
		and
		taxonomy_class in ('Clinical Neuropsychologist','Psychologist')


update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = 'LCSW'
where provider_credentials is null
		and
		entity_type_code = '1'
		and
		taxonomy_type = 'Behavioral Health & Social Service Providers'
		and
		taxonomy_class in ('Social Worker')



select *
from REF_NPI_Provider_Name_Taxnonomy
where prov_cred_space_loc > 0
		
update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = replace(provider_credentials,'>','')

update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = replace(provider_credentials,'<','')

update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = replace(provider_credentials,' ',', ')

update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = replace(provider_credentials,',, ',', ')

update REF_NPI_Provider_Name_Taxnonomy
set provider_credentials = replace(provider_credentials,', ,',',')

update REF_NPI_Provider_Name_Taxnonomy
set Provider_Credentials = ltrim(rtrim(replace(Provider_Credentials,',','')))
where right(Provider_Credentials,1) = ','

update REF_NPI_Provider_Name_Taxnonomy
set Provider_Credentials = ltrim(rtrim(replace(Provider_Credentials,'BOARD, CERTIFIED','')))
where Provider_Credentials like '%BOARD, CERTIFIED%'

update REF_NPI_Provider_Name_Taxnonomy
set Provider_Credentials = ltrim(rtrim(replace(Provider_Credentials,'CERTIFIED','')))
where Provider_Credentials like '%CERTIFIED%'


update REF_NPI_Provider_Name_Taxnonomy
set Provider_Credentials = 'MD'
where provider_credentials = 'ND'
		and
		taxonomy_type = 'Allopathic & Osteopathic Physicians'

update REF_NPI_Provider_Name_Taxnonomy
set Provider_Credentials = replace(provider_credentials,'MD','')
where taxonomy_code = '390200000X'

update REF_NPI_Provider_Name_Taxnonomy
set Provider_Credentials = replace(provider_credentials,'PHD','')
where taxonomy_code = '390200000X'

update REF_NPI_Provider_Name_Taxnonomy
set Provider_Credentials = replace(provider_credentials,'DO','')
where taxonomy_code = '390200000X'

update REF_NPI_Provider_Name_Taxnonomy
set Provider_Credentials = replace(provider_credentials,'DPM','')
where taxonomy_code = '390200000X'

update REF_NPI_Provider_Name_Taxnonomy
set Provider_Credentials = replace(provider_credentials,'DDS','')
where taxonomy_code = '390200000X'

update REF_NPI_Provider_Name_Taxnonomy
set Provider_Credentials = replace(provider_credentials,'DMD','')
where taxonomy_code = '390200000X'

update REF_NPI_Provider_Name_Taxnonomy
set Provider_Credentials = replace(provider_credentials,', ','')
where Provider_Credentials like ', %'

update REF_NPI_Provider_Name_Taxnonomy
set Provider_Credentials = replace(provider_credentials,', ','')
where Provider_Credentials like '%, '

update REF_NPI_Provider_Name_Taxnonomy
set Provider_Credentials = null
where Provider_Credentials = ' '


update REF_NPI_Provider_Name_Taxnonomy
set Provider_Credentials = null
where taxonomy_code = '390200000X'
		and
		len(Provider_Credentials) = 1


update REF_NPI_Provider_Name_Taxnonomy
set Provider_Credentials = 'DMD'
where provider_credentials = 'MD'
		and
		taxonomy_type = 'Dental Providers'


 

--Find specific NPIs with incorrect taxonomy and fix:

----DPM

--Update to Credentials to DPM
update REF_NPI_Provider_Name_Taxnonomy
set Provider_Credentials = 'DPM'
where provider_credentials = 'MD'
		and
		taxonomy_type = 'Podiatric Medicine & Surgery Service Providers'


drop table REF_NPI_PROV_TXNMY_CRRCT_DPM
select *
into REF_NPI_PROV_TXNMY_CRRCT_DPM
from REF_NPI_Provider_Name_Taxnonomy
where Provider_Credentials = 'DPM' 
		and
		taxonomy_code not like '213E%'
		and
		taxonomy_code not like '3902%'

update REF_NPI_PROV_TXNMY_CRRCT_DPM
set taxonomy_code = '213ES0103X'
where taxonomy_code in ('207XX0004X','208600000X','207X00000X')

update REF_NPI_PROV_TXNMY_CRRCT_DPM
set taxonomy_code = '213E00000X'
where taxonomy_code <> '213ES0103X'

select *
from REF_NPI_PROV_TXNMY_CRRCT_DPM
where taxonomy_code not in ('213ES0103X')

select distinct npi,taxonomy_code
into REF_NPI_PROV_TXNMY_CRRCT_MASTER
from REF_NPI_PROV_TXNMY_CRRCT_DPM


----MD
drop table REF_NPI_PROV_TXNMY_CRRCT_MD
select *
into REF_NPI_PROV_TXNMY_CRRCT_MD
from REF_NPI_Provider_Name_Taxnonomy
where Provider_Credentials = 'MD' 
		and
		taxonomy_type not in ('Allopathic & Osteopathic Physicians','Other Service Providers','Podiatric Medicine & Surgery Service Providers')

select *
from REF_NPI_PROV_TXNMY_CRRCT_MD
where taxonomy_group <> 'PERSON'
		and
		taxonomy_code not in ('2084P0800X','146D00000X','207P00000X','208100000X','207W00000X','207ZP0102X','204D00000X',
								'246XC2901X','246XC2903X','207RC0001X','207RI0011X',
								'2085R0202X','2085R0204X','2085R0203X','2085N0904X','208600000X','208U00000X','207RN0300X',
								'2088P0231X','208000000X','207RG0100X','208D00000X','207RB0002X','207RX0202X','2081P2900X',
								'207VX0000X','207VE0102X','2081N0008X','207YX0602X')
--		and
--		taxonomy_sub_specialty IS NOT NULL


select *
from REF_Provider_Taxonomy_to_CMS_XWALK
where taxonomy_group = 'PERSON'
		and
		taxonomy_type = 'Allopathic & Osteopathic Physicians'
		and
		taxonomy_sub_specialty like '%pathology%'

select *
from REF_Provider_Taxonomy_to_CMS_XWALK
where taxonomy_code = '1003021718'


select *
from REF_TBL_NPI_AI_Master
where npi = '1013079367'


select *
from REF_TBL_NPI_AI_Master
where [provider last name (legal name)] = 'HO'
		and
		[provider first name] LIKE 'K%'



--UPDATE STATEMENTS TO FIX INCORRECT TAXONOMY_CODES

----Update to Otolaryngology/Otology & Neurotology
update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '207YX0602X'
where taxonomy_specialty like '%Audio%'

update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '207YX0602X'
where taxonomy_specialty like '%Hearing Instrument Specialist%'

----Update to Otolaryngology
update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '207YX0602X'
where taxonomy_sub_specialty like '%laryngology%'


----Update to Physical Medicine & Rehabilitation/Neuromuscular Medicine
update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '2081N0008X'
where taxonomy_sub_specialty like '%neuro%'

----Update to Endocrinlogy
update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '207VE0102X'
where taxonomy_sub_specialty like '%endo%'


----Update to Obstetrics
update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '207VX0000X'
where taxonomy_sub_specialty like '%Obst%'

----Update to Physical Medicine & Rehabilitation/Pain Medicine
update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '2081P2900X'
where taxonomy_sub_specialty like '%Pain%'


----Update to Oncology
update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '207RX0202X'
where taxonomy_sub_specialty like '%Oncology%'


----Update to Bariatric
update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '207RB0002X'
where taxonomy_sub_specialty like '%nutrition%'

update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '207RB0002X'
where taxonomy_specialty like '%nutrition%'

update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '207RB0002X'
where taxonomy_specialty like '%diet%'

----Update to General Practice
update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '208D00000X'
where taxonomy_sub_specialty like '%GENERAL%'


----Update to Gastroenterology
update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '207RG0100X'
where taxonomy_sub_specialty like '%Gastroenterology%'


----Update to Pediatrics
update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '208000000X'
where taxonomy_sub_specialty like '%Pediatrics%'

----Update to Urology
update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '2088P0231X'
where taxonomy_sub_specialty like '%Urology%'

----Update to Nephrology
update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '207RN0300X'
where taxonomy_sub_specialty like '%Nephrology%'


----Update to Clinical Pharmacology
update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '208U00000X'
where taxonomy_class = 'Pharmacist'


----Update to Surgery
update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '208600000X'
where taxonomy_code in ('246ZS0400X')



--Update to RADIOLOGY
update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '2085R0202X'
where taxonomy_group = 'PERSON'
		and
		taxonomy_code not in ('2084P0800X','146D00000X','207P00000X','208100000X','207W00000X','207ZP0102X',
								'204D00000X','246XC2901X','246XC2903X','207RC0001X',
								'2085R0202X','2085R0204X','2085R0203X','2085N0904X')
		and
		taxonomy_class like '%radio%'


update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '2085N0904X'
where taxonomy_code in ('2471N0900X')

update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '2085R0203X'
where taxonomy_code in ('2471R0002X')

update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '2085R0204X'
where taxonomy_code in ('2471V0106X')

update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '2085R0202X'
where taxonomy_code in ('247100000X','2471C3402X','246XS1301X')


--Update to Cardiology
update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '207RI0011X'
where taxonomy_code in ('246XC2901X','246XC2903X')

update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '207RC0001X'
where taxonomy_code in ('246W00000X','246X00000X')

update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '204D00000X'
where taxonomy_type = 'Chiropractic Providers'



--Update to Pathology
update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '2084P0800X'
where taxonomy_class like '%Patholo%'

--Update to Pathology-Clinical Pathology/Laboratory Medicine
update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '207ZP0105X'
where taxonomy_group <> 'PERSON'
		and
		(taxonomy_type like '%LABORA%'
			or
			taxonomy_class like '%LABORA%'
			or
			taxonomy_specialty like '%LABORA%'
			or
			taxonomy_sub_specialty like '%LABORA%')


--Update to Psych
update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '2084P0800X'
where taxonomy_sub_specialty like '%Psych%'

update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '2084P0800X'
where taxonomy_type = 'Behavioral Health & Social Service Providers'

update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '2084P0800X'
where taxonomy_class = 'Psychologist'


--Update to Ophthalmology
update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '207W00000X'
where taxonomy_type = 'Eye and Vision Services Providers'


--Update to Pulmonology
update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '208100000X'
where taxonomy_type = 'Respiratory, Developmental, Rehabilitative and Restorative Service Providers'

--Update to Emergency Medicine
update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '207P00000X'
where taxonomy_type = 'Emergency Medical Service Providers'


--Update to PA
update REF_NPI_Provider_Name_Taxnonomy
set Provider_Credentials = 'PA'
where provider_credentials = 'MD'
		and
		taxonomy_type = 'Physician Assistants & Advanced Practice Nursing Providers'


update REF_NPI_Provider_Name_Taxnonomy
set Provider_Credentials = 'PA'
where provider_credentials = 'MD'
		and
		taxonomy_type = 'Physician Assistants & Advanced Practice Nursing Providers'

----Update to Internal Medicine for all remaining
update REF_NPI_PROV_TXNMY_CRRCT_MD
set taxonomy_code = '207R00000X'
where taxonomy_group = 'PERSON'
		and
		taxonomy_code not in ('2084P0800X','146D00000X','207P00000X','208100000X','207W00000X','207ZP0102X','204D00000X',
								'246XC2901X','246XC2903X','207RC0001X','207RI0011X',
								'2085R0202X','2085R0204X','2085R0203X','2085N0904X','208600000X','208U00000X','207RN0300X',
								'2088P0231X','208000000X','207RG0100X','208D00000X','207RB0002X','207RX0202X','2081P2900X',
								'207VX0000X','207VE0102X','2081N0008X','207YX0602X')



--Create table of MD NPIs where listed taxnmy code is either a company or facility
drop table REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN
select *
into REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN
from REF_NPI_PROV_TXNMY_CRRCT_MD
where taxonomy_group <> 'PERSON'
		and
		taxonomy_code not in ('2084P0800X','146D00000X','207P00000X','208100000X','207W00000X','207ZP0102X','204D00000X',
								'246XC2901X','246XC2903X','207RC0001X','207RI0011X',
								'2085R0202X','2085R0204X','2085R0203X','2085N0904X','208600000X','208U00000X','207RN0300X',
								'2088P0231X','208000000X','207RG0100X','208D00000X','207RB0002X','207RX0202X','2081P2900X',
								'207VX0000X','207VE0102X','2081N0008X','207YX0602X')
select *
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN


select b.npi,b.[Healthcare Provider Taxonomy Code_2] as taxnmy_cd2,b.[Healthcare Provider Taxonomy_2] as taxnmy_2
into REF_TBL_NPI_TAXNMY_TWO
from REF_TBL_NPI_AI_Master b

delete
from REF_TBL_NPI_TAXNMY_TWO
where taxnmy_cd2 is null

select *
from REF_TBL_NPI_TAXNMY_TWO

alter table REF_TBL_NPI_TAXNMY_TWO add npi_txt varchar(10)
go
update REF_TBL_NPI_TAXNMY_TWO
set npi_txt = convert(varchar,convert(int,npi))

alter table REF_TBL_NPI_TAXNMY_TWO add taxonomy_code2 varchar(10)
go
update REF_TBL_NPI_TAXNMY_TWO
set taxonomy_code2 = convert(varchar,taxnmy_cd2)

select *
into REF_TBL_NPI_TAXNMY_TWO_A
from REF_TBL_NPI_TAXNMY_TWO
where taxonomy_code2 in
		(select taxonomy_code
			from REF_Provider_Taxonomy_to_CMS_XWALK
			where taxonomy_type in ('Allopathic & Osteopathic Physicians','Other Service Providers','Podiatric Medicine & Surgery Service Providers'))

drop table REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_2
select a.*,b.taxonomy_code2,b.taxnmy_2
into REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_2
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN a left outer join REF_TBL_NPI_TAXNMY_TWO_A b
on a.npi = b.npi_txt

drop table REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN
exec sp_rename 'REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_2','REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN'

select *
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN

select taxonomy_group,taxonomy_type,
		taxonomy_class,taxonomy_code,taxonomy_specialty,taxonomy_sub_specialty,
		taxonomy_code2,taxnmy_2,count(distinct npi) as npis
into REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN
where taxonomy_code2 is not null
		and
		taxonomy_code2 <> '174400000X'
group by taxonomy_group,taxonomy_type,
			taxonomy_class,taxonomy_code,taxonomy_specialty,taxonomy_sub_specialty,
			taxonomy_code2,taxnmy_2
order by taxonomy_code,npis desc

drop table REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_MAX
select taxonomy_code,max(npis) as max_npis
into REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_MAX
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT
group by taxonomy_code

select *
into REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT
where taxonomy_code+convert(varchar,npis) in
		(select taxonomy_code+convert(varchar,max_npis)
			from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_MAX)
		and
		npis > 1

delete
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT
where taxonomy_code in
		(select taxonomy_code
			from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP)

select taxonomy_code,count(*) as recs
into REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_RECS
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT
group by taxonomy_code

insert into REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP
select *
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT
where taxonomy_code in
		(select taxonomy_code
			from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_RECS
			where recs = 1)
		and
		taxonomy_code not in
		(select taxonomy_code
			from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP)

insert into REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP
select *
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT
where taxonomy_code = '207ZP0105X'
		and
		taxonomy_code2 = '207ZP0102X'

insert into REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP
select *
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT
where taxonomy_code = '251B00000X'
		and
		taxonomy_code2 = '2084P0800X'

insert into REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP
select *
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT
where taxonomy_code = '251K00000X'
		and
		taxonomy_code2 = '2083P0901X'

insert into REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP
select *
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT
where taxonomy_code = '261QS1200X'
		and
		taxonomy_code2 = '207YX0905X'

insert into REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP
select *
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT
where taxonomy_code = '261QM0855X'
		and
		taxonomy_code2 = '2080A0000X'


insert into REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP
select *
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT
where taxonomy_code = '261QU0200X'
		and
		taxonomy_code2 = '207P00000X'


insert into REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP
select *
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT
where taxonomy_code = '323P00000X'
		and
		taxonomy_code2 = '2084P0800X'

select *
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT
where taxonomy_code not in
		(select taxonomy_code
			from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP)

select distinct taxonomy_code
select *
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP

update REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP
set taxonomy_code2 = '2083P0901X'
where taxonomy_code = '261QP0905X'

update REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP
set taxnmy_2 = 'Public Health & General Preventive Medicine'
where taxonomy_code = '261QP0905X'

update REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP
set taxonomy_code2 = '208U00000X'
where taxonomy_code = '333600000X'

update REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP
set taxnmy_2 = 'Clinical Pharmacology'
where taxonomy_code = '333600000X'

update REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP
set taxonomy_code2 = '2085R0202X'
where taxonomy_code = '261QR0200X'

update REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP
set taxnmy_2 = 'Diagnostic Radiology'
where taxonomy_code = '261QR0200X'


update REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP
set taxonomy_code2 = '2081P2900X'
where taxonomy_code = '261QX0100X'

update REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP
set taxnmy_2 = 'Physical Medicine & Rehabilitation'
where taxonomy_code = '261QX0100X'

update REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP
set taxonomy_code2 = '2084P0800X'
where taxonomy_code = '261QM0801X'

update REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP
set taxnmy_2 = 'Psychiatry'
where taxonomy_code = '261QM0801X'

update REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP
set taxonomy_code2 = '207P00000X'
where taxonomy_code = '341600000X'

update REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP
set taxnmy_2 = 'Emergency Medicine'
where taxonomy_code = '341600000X'

update REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP
set taxonomy_code2 = '208000000X'
where taxonomy_code = '282NC2000X'

update REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP
set taxnmy_2 = 'Pediatrics'
where taxonomy_code = '282NC2000X'


update REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP
set taxonomy_code2 = '207R00000X'
where taxonomy_code in ('261QV0200X','282NR1301X')

update REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP
set taxnmy_2 = 'Internal Medicine'
where taxonomy_code in ('261QV0200X','282NR1301X')




alter table REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP drop column npis

select *
--into REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_XWLK
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN
where taxonomy_code2 is not null

select *
into REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_NULL
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN
where taxonomy_code2 is null

alter table REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_NULL drop column taxonomy_code2
alter table REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_NULL drop column taxnmy_2


insert into REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_XWLK
select distinct a.*,b.taxonomy_code2,b.taxnmy_2
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_NULL a inner join REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_CNT_KP b
on a.taxonomy_code = b.taxonomy_code
where a.npi not in
		(select npi
			from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_XWLK)

delete
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_NULL
where npi in
		(select npi
			from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_XWLK)



insert into REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_XWLK
select distinct a.*,'207R00000X' as taxonomy_code2,'Internal Medicine' as taxnmy_2
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_NULL a 
where a.taxonomy_type = 'Managed Care Organizations'

insert into REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_XWLK
select distinct a.*,'207R00000X' as taxonomy_code2,'Internal Medicine' as taxnmy_2
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_NULL a 
where a.taxonomy_type = 'Ambulatory Health Care Facilities'
		and
		taxonomy_sub_specialty in ('Medical Specialty','Ambulatory Surgical','Multi-Specialty','Public Health, Federal')

insert into REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_XWLK
select distinct a.*,'207R00000X' as taxonomy_code2,'Internal Medicine' as taxnmy_2
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_NULL a 
where a.taxonomy_type = 'Ambulatory Health Care Facilities'
		and
		taxonomy_sub_specialty is null



insert into REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_XWLK
select distinct a.*,'208M00000X' as taxonomy_code2,'Hospitalist' as taxnmy_2
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_NULL a 
where a.taxonomy_type = 'Hospitals'
		and
		taxonomy_class in ('Special Hospital','Chronic Disease Hospital')

insert into REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_XWLK
select distinct a.*,'208M00000X' as taxonomy_code2,'Hospitalist' as taxnmy_2
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_NULL a 
where a.taxonomy_type = 'Nursing & Custodial Care Facilities'


insert into REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_XWLK
select distinct a.*,'261QX0100X' as taxonomy_code2,'Physical Medicine & Rehabilitation' as taxnmy_2
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_NULL a 
where taxonomy_class like 'REHAB%'

insert into REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_XWLK
select distinct a.*,'207RA0401X' as taxonomy_code2,'Addiction Medicine' as taxnmy_2
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_NULL a 
where taxonomy_specialty like '%substance%'

insert into REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_XWLK
select distinct a.*,'207P00000X' as taxonomy_code2,'Emergency Medicine' as taxnmy_2
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_NULL a 
where taxonomy_specialty like '%emergency%'
insert into REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_XWLK


insert into REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_XWLK
select distinct a.*,'2084P0800X' as taxonomy_code2,'Psychiatry' as taxnmy_2
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_NULL a 
where taxonomy_specialty like '%behavioral%'

insert into REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_XWLK
select distinct a.*,'2084P0800X' as taxonomy_code2,'Psychiatry' as taxnmy_2
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_NULL a 
where taxonomy_specialty like '% mental%'

insert into REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_XWLK
select distinct a.*,'2085R0202X' as taxonomy_code2,'Diagnostic Radiology' as taxnmy_2
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_NULL a 
where taxonomy_specialty like '%radiology%'

insert into REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_XWLK
select distinct a.*,'207R00000X' as taxonomy_code2,'Internal Medicine' as taxnmy_2
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_NULL a 

delete
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_NULL
where npi in
		(select npi
			from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_XWLK)

select taxonomy_group,taxonomy_type,taxonomy_class,taxonomy_specialty,taxonomy_sub_specialty,count(*) as npis
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_NULL
group by taxonomy_group,taxonomy_type,taxonomy_class,taxonomy_specialty,taxonomy_sub_specialty
order by npis desc

select *
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_XWLK

select *
from REF_NPI_PROV_TXNMY_CRRCT_MD


--Insert MD results
insert into REF_NPI_PROV_TXNMY_CRRCT_MASTER
select distinct npi,taxonomy_code
from REF_NPI_PROV_TXNMY_CRRCT_MD
where taxonomy_group = 'PERSON'

--Insert MD results
insert into REF_NPI_PROV_TXNMY_CRRCT_MASTER
select distinct npi,taxonomy_code2
from REF_NPI_PROV_TXNMY_CRRCT_MD_NONPRSN_XWLK

select *
from REF_NPI_PROV_TXNMY_CRRCT_MASTER

--Create master npi,taxonomy crosswalk
select distinct npi,taxonomy_code
into REF_NPI_PROV_TXNMY_CODE_MASTER
from REF_NPI_Provider_Name_Taxnonomy


--Remove/Replace Providence edits:
delete
from REF_NPI_PROV_TXNMY_CODE_MASTER
where npi in
		(select npi
			from PRVDNC_HAF_REF_TBL_TAX_CRRCTNS_NPI)

insert into REF_NPI_PROV_TXNMY_CODE_MASTER
select distinct *
from PRVDNC_HAF_REF_TBL_TAX_CRRCTNS_NPI


--Remove/Replace Montefiore edits:
delete
from REF_NPI_PROV_TXNMY_CODE_MASTER
where npi in
		(select npi
			from MNTF_HF_REF_TBL_NPI_ALT_TAXNMY_XWLK)

insert into REF_NPI_PROV_TXNMY_CODE_MASTER
select distinct *
from MNTF_HF_REF_TBL_NPI_ALT_TAXNMY_XWLK

--Remove/Replace XL Health edits:
delete
from REF_NPI_PROV_TXNMY_CODE_MASTER
where npi in
		(select npi
			from XL_HLTH_REF_TBL_NPI_ALT_TAXNMY_XWLK)

insert into REF_NPI_PROV_TXNMY_CODE_MASTER
select distinct *
from XL_HLTH_REF_TBL_NPI_ALT_TAXNMY_XWLK

select *
from REF_NPI_PROV_TXNMY_CODE_MASTER
where 

select npi
into REF_NPI_PROV_TXNMY_CODE_MASTER_FIX
from REF_NPI_PROV_TXNMY_CODE_MASTER
where taxonomy_code = '193200000X'
		and
		npi in
		(select npi
			from REF_NPI_Provider_Name_Taxnonomy
			where entity_type_code = '1')
		and
		npi in
		(select npi
			from XL_HLTH_REF_TBL_NPI_ALT_TAXNMY_XWLK)

update REF_NPI_PROV_TXNMY_CODE_MASTER
set taxonomy_code = '207R00000X'
where taxonomy_code = '193200000X'
		and
		npi in
		(select npi
			from REF_NPI_Provider_Name_Taxnonomy
			where entity_type_code = '1')
		and
		npi in
		(select npi
			from XL_HLTH_REF_TBL_NPI_ALT_TAXNMY_XWLK)

delete
from XL_HLTH_REF_TBL_NPI_ALT_TAXNMY_XWLK
where alt_txnmy_cd = '193200000X'
		and
		npi in
		(select npi
			from REF_NPI_Provider_Name_Taxnonomy
			where entity_type_code = '1')
		
--Remove/Replace VNS Choice:
delete
from REF_NPI_PROV_TXNMY_CODE_MASTER
where npi in
		(select npi
			from VNS_REF_TBL_NPI_ALT_TAXNMY_XWLK)
	

insert into REF_NPI_PROV_TXNMY_CODE_MASTER
select distinct *
from VNS_REF_TBL_NPI_ALT_TAXNMY_XWLK





--REPLACE TAXONOMY_CODES
drop table REF_NPI_Provider_Name_Taxnonomy_V2
select a.NPI,Entity_Type_Code,Entity_Type,Provider_Name,Provider_Credentials,Provider_Last_Name,Provider_First_Name,b.Taxonomy_Code
into REF_NPI_Provider_Name_Taxnonomy_V2
from REF_NPI_Provider_Name_Taxnonomy a inner join REF_NPI_PROV_TXNMY_CODE_MASTER b
on a.npi = b.npi
where a.npi in
		(select npi
			from VNS_REF_TBL_NPI_ALT_TAXNMY_XWLK)
			

delete
from REF_NPI_Provider_Name_Taxnonomy
where npi in
		(select npi
			from VNS_REF_TBL_NPI_ALT_TAXNMY_XWLK)

select *
from REF_NPI_Provider_Name_Taxnonomy_V2

select *
from REF_Provider_Taxonomy_to_CMS_XWALK

select a.*,
		b.Taxonomy_Group,b.Taxonomy_Type_ALT as Taxonomy_Type,
		b.Taxonomy_Class,b.Taxonomy_Specialty,b.Taxonomy_Sub_Specialty,
		b.CMS_Specialty_Code,b.CMS_Specialty
into REF_NPI_Provider_Name_Taxnonomy_V2_A
from REF_NPI_Provider_Name_Taxnonomy_V2 a left outer join REF_Provider_Taxonomy_to_CMS_XWALK b
on a.taxonomy_code = b.taxonomy_code
order by 1


select count(distinct npi)
from REF_NPI_Provider_Name_Taxnonomy_V2_A
--3564

select *
from REF_NPI_Provider_Name_Taxnonomy_V2_A

drop table REF_NPI_Provider_Name_Taxnonomy_V2
exec sp_rename 'REF_NPI_Provider_Name_Taxnonomy_V2_A','REF_NPI_Provider_Name_Taxnonomy_V2'

insert into REF_NPI_Provider_Name_Taxnonomy
select *
from REF_NPI_Provider_Name_Taxnonomy_V2


select *
from REF_NPI_Provider_Name_Taxnonomy
where npi = '1609872803'
where provider_name like 'Doshi%'

where npi = '1962441600'
select *
from REF_NPI_Base_INDV
where npi in (1962441600)

select *
from REF_TBL_NPI_AI_Master
where npi in (1962441600)







--Crosswalk provider state license ID to NPI
select *
from REF_TBL_NPI_ST_LIC_ID_XWALK

--Add-on prov_name_match
select *
from REF_TBL_NPI_ST_LIC_ID_XWALK

alter table REF_TBL_NPI_ST_LIC_ID_XWALK drop column prov_name_match

select distinct a.*,b.prov_name_match
into REF_TBL_NPI_ST_LIC_ID_XWALK_2
from REF_TBL_NPI_ST_LIC_ID_XWALK a inner join REF_NPI_Base_ORG b
on a.npi = b.NPI
union all
select distinct a.*,b.prov_name_match
from REF_TBL_NPI_ST_LIC_ID_XWALK a inner join REF_NPI_Base_INDV b
on a.npi = b.NPI

drop table REF_TBL_NPI_ST_LIC_ID_XWALK
exec sp_rename 'REF_TBL_NPI_ST_LIC_ID_XWALK_2','REF_TBL_NPI_ST_LIC_ID_XWALK'




select *
from REF_NPI_Base_INDV
where lname_apstr_loc > 0


select count(*)
select count(distinct npi)
select *
from REF_TBL_NPI_ST_LIC_ID_XWALK
--2572124 
--2400006

drop table REF_TBL_NPI_ST_LIC_ID_CNT_X_NPI
select npi,count(distinct provider_lic_state+provider_state_lic_id) as prov_lic_ids
into REF_TBL_NPI_ST_LIC_ID_CNT_X_NPI
from REF_TBL_NPI_ST_LIC_ID_XWALK
group by npi
order by prov_lic_ids desc

drop table REF_TBL_NPI_NPI_CNT_X_PROV_NAME
select prov_name_match,count(distinct npi) as npis
into REF_TBL_NPI_NPI_CNT_X_PROV_NAME
from REF_TBL_NPI_ST_LIC_ID_XWALK
group by prov_name_match
order by npis desc


drop table REF_TBL_NPI_NPI_CNT_X_ST_LIC_ID
select provider_state_lic_id as provider_state_lic_id_ai,count(distinct npi ) as npis
into REF_TBL_NPI_NPI_CNT_X_ST_LIC_ID
from REF_TBL_NPI_ST_LIC_ID_XWALK
group by provider_state_lic_id
order by npis desc

select provider_state_lic_id as provider_state_lic_id_ai,npis
into REF_TBL_NPI_NPI_CNT_X_ST_LIC_ID_2
from REF_TBL_NPI_NPI_CNT_X_ST_LIC_ID

drop table REF_TBL_NPI_NPI_CNT_X_ST_LIC_ID
exec sp_rename 'REF_TBL_NPI_NPI_CNT_X_ST_LIC_ID_2','REF_TBL_NPI_NPI_CNT_X_ST_LIC_ID'

select *
from REF_TBL_NPI_NPI_CNT_X_ST_LIC_ID
where npis = 1

--Add-on provider_state_lic_id_ai 
alter table REF_TBL_NPI_NPI_CNT_X_ST_LIC_ID add prov_lic_id varchar(100)
go
update REF_TBL_NPI_NPI_CNT_X_ST_LIC_ID
set prov_lic_id = ltrim(rtrim(replace(provider_state_lic_id_ai,' ','')))


select *
from REF_TBL_NPI_NPI_CNT_X_ST_LIC_ID

LEN(a.provider_last_name) as len_prov_lname,
		charindex('-',a.Provider_Last_Name) as lname_hyphen_loc,

drop table REF_TBL_NPI_ST_LIC_ID_HYPHEN
select distinct provider_state_lic_id_ai,prov_lic_id,prov_lic_id as prov_lic_id_alt,
				LEN(prov_lic_id) as len_prov_lic_id,
				charindex('-',prov_lic_id) as prov_lic_id_hyphen_loc
into REF_TBL_NPI_ST_LIC_ID_HYPHEN
from REF_TBL_NPI_NPI_CNT_X_ST_LIC_ID
where prov_lic_id like '%-%'
order by 1,2,3


select *
from REF_TBL_NPI_ST_LIC_ID_HYPHEN

update REF_TBL_NPI_ST_LIC_ID_HYPHEN
set prov_lic_id_alt = left(prov_lic_id_alt,prov_lic_id_hyphen_loc-1)
where len_prov_lic_id - prov_lic_id_hyphen_loc in (1,2)

update REF_TBL_NPI_ST_LIC_ID_HYPHEN
set prov_lic_id_alt = replace(prov_lic_id_alt,'-','')
where len_prov_lic_id - prov_lic_id_hyphen_loc > 2




select *
from REF_TBL_NPI_NPI_CNT_X_ST_LIC_ID

select a.*,b.prov_lic_id_alt
into REF_TBL_NPI_NPI_CNT_X_ST_LIC_ID_2
from REF_TBL_NPI_NPI_CNT_X_ST_LIC_ID a left outer join REF_TBL_NPI_ST_LIC_ID_HYPHEN b
on a.provider_state_lic_id_ai = b.provider_state_lic_id_ai

drop table REF_TBL_NPI_NPI_CNT_X_ST_LIC_ID 
exec sp_rename 'REF_TBL_NPI_NPI_CNT_X_ST_LIC_ID_2','REF_TBL_NPI_NPI_CNT_X_ST_LIC_ID'

--Add on prov_name_match
select *
from REF_TBL_NPI_ST_LIC_ID_XWALK

select *
from REF_TBL_NPI_NPI_CNT_X_ST_LIC_ID

drop table REF_TBL_NPI_ST_LIC_ID_XWLK_PROV_MATCH
select a.*,b.npi,b.prov_name_match
into REF_TBL_NPI_ST_LIC_ID_XWLK_PROV_MATCH
from REF_TBL_NPI_NPI_CNT_X_ST_LIC_ID a inner join REF_TBL_NPI_ST_LIC_ID_XWALK b
on a.provider_state_lic_id_ai = b.provider_state_lic_id

select *
from REF_TBL_NPI_ST_LIC_ID_XWLK_PROV_MATCH






select *
from REF_TBL_NPI_NPI_CNT_X_ST_LIC_ID
where provider_state_lic_id = '1092'

select provider_state_lic_id,count(distinct provider_lic_state ) as states
into REF_TBL_NPI_STATE_CNT_X_ST_LIC_ID
from REF_TBL_NPI_ST_LIC_ID_XWALK
group by provider_state_lic_id
order by states desc


select *
from REF_TBL_NPI_STATE_CNT_X_ST_LIC_ID
where npi = '1528132974'