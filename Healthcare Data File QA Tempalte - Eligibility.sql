--Project Name

--****************************************************************************************
----Eligibility File (Ex)

------Top-level analysis:
--View table
select * from tbl_AsImported_Eligibilities

--Row Count: Match to control totals, if available
select count(*) from tbl_AsImported_Eligibilities
--


--Column Count 
----Find table 'id'
select id from sysobjects where name = 'tbl_AsImported_Eligibilities'
----Count Columns
select count(*) from syscolumns where id = '135671531'
-

----Column Names
select name from syscolumns where id = '135671531'
order by colid
--

select * from tbl_AsImported_Eligibilities

--************************************************************************
-----Glossary
-------MedMemberID: Unique string used to ID patients within and across data sources. 
-------MedSubscriberID: Usually populated with member's SSN plus a two digit suffix
-------Social_Security_Number: SSN for member/subscriber.
-------Dependent_Code: Itemizes members under a subscrirbers plan
-------Relationship: Describes relationship between member and subscriber
-------Case_Mgmt_Flag: Indicates that member is under case management.
-------Birth_Date : Date of Birth_Date  for member in Ex data
-------Original_Effective_Date : Date members' coverage begins.
-------Sex: members' gender in Ex data
-------Termination_Date: date members' coverage end
-------Coverage: indicates member as a family, single, single+1 or other benefit plan


---------------------------------------------------------------------------------------------
--*******************************************************************************************


--Eligibility SQL Analysis



--Subscriber Number: 
----Find Length(s) of MedSubscriberID
----Check for consistent field value length
select len(MedSubscriberID),count(*) as recs
from tbl_AsImported_Eligibilities
group by len(MedMemberID)
order by recs desc

----Check for dummy values, i.e. values inserted as defaults - these values will usually
----have high record counts. (Examples: 123456789 or 999999999).
select MedSubscriberID,count(*) as recs
from tbl_AsImported_Claims
group by MedSubscriberID
order by recs desc

--Often this field is imported incorrectly and the leading values of '0' are trimmed-off.
--Check for records with leading zero, if there are no results than the business rule must 
--be written to re-affix the chopped-off 0s.
select distinct Social_Security_Number from tbl_AsImported_Eligibilities
where left(MedSubscriberID,1) = '0'

--Business Rule: set = right('00000000'+MedMemberID,9).

--Adjustment to code: Since leading 0s have been trimmed, they must be manually re-affixed
--for accurate analysis of the data. 
--Replace MedMemberID with right('00000000'+MedMemberID,9)


----View MedMemberID; look for digit suffixes and/or '-' between digits. 
----Also look for dummy Social_Security_Number values (e.g. 123456789, 999999999).
select MedSubscriberID,count(*) as recs
from tbl_AsImported_Eligibilities
group by MedSubscriberID
order by recs desc


----View rows for ID with highest record count, look for inconsistencies:
select * from tbl_AsImported_Eligibilities
where MedSubscriberID = '80042158802'

----Count distinct members - compare with control totals provide by client.
select count(distinct(left(MedSubscriberID,9))) as members 
from tbl_AsImported_Eligibilities
--








--Member ID
----Unique string used to ID patients within and across data sources. Traditionally, MemberID is constructed 
----using the plan subscriber's SSN concatenated with a two digit suffix denoting subscriber (00 or 01), dependent (02,03,...)

----Check for consistent field value length
select len(MedMemberID),count(*) as recs
from tbl_AsImported_Eligibilities
group by len(MedMemberID)
order by recs desc


----Check for dummy values, i.e. values inserted as defaults - these values will usually
----have high record counts. (Examples: 123456789 or 999999999).
select MedMemberID,count(*) as recs
from tbl_AsImported_Claims
group by MedMemberID
order by recs desc

--Often this field is imported incorrectly and the leading values of '0' are trimmed-off.
--Check for records with leading zero, if there are no results than the business rule must 
--be written to re-affix the chopped-off 0s.
select distinct Social_Security_Number from tbl_AsImported_Eligibilities
where left(MedMemberID,1) = '0'

--Business Rule: set = right('00000000'+MedMemberID,9).

--Adjustment to code: Since leading 0s have been trimmed, they must be manually re-affixed
--for accurate analysis of the data. 
--Replace MedMemberID with right('00000000'+MedMemberID,9)


----View MedMemberID; look for digit suffixes and/or '-' between digits. 
----Also look for dummy Social_Security_Number values (e.g. 123456789, 999999999).
select MedMemberID,count(*) as recs
from tbl_AsImported_Eligibilities
group by MedMemberID
order by recs desc


----View rows for ID with highest record count, look for inconsistencies:
select * from tbl_AsImported_Eligibilities
where MedMemberID = '80042158802'

----Count distinct members - compare with control totals provide by client.
select count(distinct(MedMemberID)) as members 
from tbl_AsImported_Eligibilities
--





--SSN
----Look at length of Social_Security_Number
select len(Social_Security_Number),count(*) as recs
from tbl_AsImported_Eligibilities
group by len(Social_Security_Number)
order by recs desc

--Often this field is imported incorrectly and the leading values of '0' are trimmed-off.
--Check for records with leading zero, if there are no results than the business rule must 
--be written to re-affix the chopped-off 0s.
select distinct Social_Security_Number from tbl_AsImported_Eligibilities
where left(Social_Security_Number,1) = '0'

--Business Rule: set = right('00000000'+Social_Security_Number,9).

--Adjustment to code: Since leading 0s have been trimmed, they must be manually re-affixed
--for accurate analysis of the data. 
--Replace Social_Security_Number with right('00000000'+Social_Security_Number,9)





--CareManagementStatus
----Count members by status.
select Case_Mgmt_Flag,
count(distinct MedMemberID) 
      as Members
from tbl_AsImported_Eligibilities
group by Case_Mgmt_Flag
order by Members desc



--DOB
----Ensure that all uzbrth are valid by looking for DOBs in the future:
select Birth_Date ,
count(distinct MedMemberID) 
      as Members
from tbl_AsImported_Eligibilities
group by Birth_Date 
order by Birth_Date  desc
--

------Look for dummy values
select Birth_Date,
count(distinct MedMemberID) 
      as Members
from tbl_AsImported_Eligibilities
group by Birth_Date 
order by Members desc





--EffectiveDate
--Take a quick count of members by 'yyyymm'and compare with reporting dates
select convert(varchar,year(Original_Effective_Date ))+
       RIGHT('0'+convert(varchar,month(Original_Effective_Date )),2) as Effective_ccyymm,
       count( distinct MedMemberID) as members
from tbl_AsImported_Eligibilities
group by convert(varchar,year(Original_Effective_Date ))+
         RIGHT('0'+convert(varchar,month(Original_Effective_Date )),2)
order by 1










--Gender
-----View Values
select Sex,count(distinct MedMemberID)  as Members
from tbl_AsImported_Eligibilities
group by Sex
order by members desc


--If NULL or more than two distinct values for MemberSex then rectify with data contact.
--If sum of distinct member count my MemberSex > distinct total members then investigate
--Business Rule Standard:
----M = Male; F = Female











--MedCovType
----Describes coverage by elected number of enrollees, e.g. single, single + 1, family plan.
------View Coverage by count of members
select Coverage,
count(MedMemberID) as members
from tbl_AsImported_Eligibilities
group by Coverage
order by members desc
------Business Rule Standard:
---------'S' = single; 'F' = family.





--MemberID
----Uses Social_Security_Number as root string concatenated with Birth_Date and Sex to 
----create unique ID.
----Find Length of base member identifier(Social_Security_Number)
select len(Social_Security_Number),count(*) as recs
from tbl_AsImported_Eligibilities
group by len(Social_Security_Number)
order by recs desc
--SSNs are 9 in length, SSNs are your best chance for matches with Mx and Rx. 


----Count distinct MemberIDs - match to control totals.
select count(distinct MedMemberID)
       as Members
from tbl_AsImported_Eligibilities
--





--RelationshipFlag
----Indicates member's relationship with member/subscriber
------Count members by PatientRelationtomemberation 
select Relationship,
count(distinct MedMemberID) 
      as Members
from tbl_AsImported_Eligibilities
group by Relationship
order by members desc

--Use Dependent_Code to clarify rules.
select Dependent_Code,Relationship,
count(distinct MedMemberID) 
      as Members
from tbl_AsImported_Eligibilities
group by Dependent_Code,Relationship
order by members desc


--Business Rule Standard:
----set = 'E' for member or subscriber; set = 'S' for spouse; set = 'D' for dependent




--SubscriberFlag
----Review file lay-out to ID field which will differentiate between subscriber and 
----dependent/spouse.
--Check to make sure field is populated consistently
select Relationship,
       count(distinct MedMemberID)
       as Members
from tbl_AsImported_Eligibilities
group by Relationship
order by Members desc
--

------Business Rule Standard: 'S' for Subscriber, 'D' for anyone getting coverage thru Sub.





--TerminationDate
--Take a quick count of members by 'yyyymm' termination date and compare with reporting dates
select convert(varchar,year(Termination_Date))+
       RIGHT('0'+convert(varchar,month(Termination_Date)),2) as Term_ccyymm,
count(distinct MedMemberID) 
      as Members
from tbl_AsImported_Eligibilities
group by convert(varchar,year(Termination_Date))+
         RIGHT('0'+convert(varchar,month(Termination_Date)),2)
order by 1
--







--PlanTypeCode
-----Usually payer type, e.g. Medicare, Comercial, Medicaid
select PlanTypeCode,
count(distinct MedMemberID) 
      as Members
from tbl_AsImported_Eligibilities
group by PlanTypeCode
order by members desc





--PCPTypeDesc 
-----Usually employer/company full name.
select PlanTypeCode,PlanTypeDesc
count(distinct MedMemberID) 
      as Members
from tbl_AsImported_Eligibilities
group by PlanTypeCode,PlanTypeDesc
order by members desc




--HMOID
-----Usually identifies the client.
select HMOID,
count(distinct MedMemberID) 
      as Members
from tbl_AsImported_Eligibilities
group by HMOID
order by members desc




-- HMOName
-----Usually identifies the client.
select HMOID,HMOName,
count(distinct MedMemberID) 
      as Members
from tbl_AsImported_Eligibilities
group by HMOID,HMOName
order by members desc




--PCPTypeCode
-----Usually employer/company ID.
select PCPTypeCode,
count(distinct MedMemberID) 
      as Members
from tbl_AsImported_Eligibilities
group by PCPTypeCode
order by members desc





-- PCPTypeDesc
-----Usually employer/company full name.
select PCPTypeCode,PCPTypeDesc
count(distinct MedMemberID) 
      as Members
from tbl_AsImported_Eligibilities
group by PCPTypeCode,PCPTypeDesc
order by members desc




-- PCPID
-----Usually group IDs or sub-group IDs within a employer's administrative hierarchy. 
select PCPID,
count(distinct MedMemberID) 
      as Members
from tbl_AsImported_Eligibilities
group by PCPID
order by members desc

select PCPTypeCode,PCPID,
count(distinct MedMemberID) 
      as Members
from tbl_AsImported_Eligibilities
group by PCPTypeCode,PCPID
order by PCPTypeCode,PCPID





--PCPName
-----Usually group names or sub-group names within a client's administrative hierarchy. 
select PCPID,PCPName
count(distinct MedMemberID) 
      as Members
from tbl_AsImported_Eligibilities
group by PCPID,PCPName
order by PCPID,PCPName

select PCPTypeCode,PCPTypeDesc,PCPID,PCPName
count(distinct MedMemberID) 
      as Members
from tbl_AsImported_Eligibilities
group by PCPTypeCode,PCPTypeDesc,PCPID,PCPName
order by PCPTypeCode,PCPTypeDesc,PCPID,PCPName




--ADDITIONAL CODE FOR "GROKING" DATA SET.


--Current member analysis.
----Find # of members with Termination_Date on or after reporting end date, or members
----whose Termination_Date is not populated.
select count(distinct MedMemberID) as Members
from tbl_AsImported_Eligibilities
where convert(varchar(50),Termination_Date,23)>='2005-02-28'--reporting_start_date('yyyy-mm-dd')
      or 
      (Termination_Date is null)
      or
      (Termination_Date = ' ')
--




--SQL Code for counting and matching member populations across medical, eligibility and Rx
--data sources:

----ExMx
------Member across data file types.
--------Find % eligibility members appearing in medical data
select count(distinct MedMemberID) as Subscribers 
from tbl_AsImported_Eligibilities
where MedMemberID in
      (select distinct MedMemberID from tbl_AsImported_Claims)
--
select count(distinct MedMemberID) from tbl_AsImported_Claims
--

--ExRx
select count(distinct MedMemberID) as Subscribers 
from tbl_AsImported_Eligibilities
where MedMemberID in
      (select distinct MedMemberID from tbl_AsImported_RxClaims)
--
select count(distinct MedMemberID) from tbl_AsImported_RxClaims
--


--Member Matching
----ExMx
--------Find % eligibility members appearing in medical data
select count(distinct MedMemberID) 
             as Members
from tbl_AsImported_Eligibilities
where MedMemberID in
      (select distinct MedMemberID
       from tbl_AsImported_Claims)
--
select count(distinct MedMemberID)
       as Members
from tbl_AsImported_Claims
--

--ExRx
select count(distinct MedMemberID) 
             as Members
from tbl_AsImported_Eligibilities
where MedMemberID in
      (select distinct MedMemberID
       from tbl_AsImported_RxClaims)
--
select count(distinct MedMemberID)
       as Members
from tbl_AsImported_RxClaims
--






