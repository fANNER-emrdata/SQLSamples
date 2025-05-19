

--****************************************************************************************

--****************************************************************************************
----Pharmacy Claims File (Rx)

------Top-level analysis:
--View table
select * from [014 RX CLAIMS]


--Row Count: Match to control totals, if available
select count(*) from [014 RX CLAIMS]
--


--Column Count 
----Find table 'id'
select id from sysobjects where name = '[014 RX CLAIMS]'
----Count Columns
select count(*) from syscolumns where id = '389576426'
--

----Column Names
select name from syscolumns where id = '389576426'
order by colid
--
select name from syscolumns where id = '389576426'
order by name


--Replace Placeholder/dummy column names with actual colulmn names using Edit: Replace
-----Glossary
-------[DOCUMENT NUMBER]: ID sequence for Rxs billed.
-------MedMemberID: ID for members (employees and their dependents). Often as concat field.
-------PatientDateofBirth: date of birth for member in Rx data
-------PatientGender: members' gender in Rx data
-------NDC: NDC standard, 11 digits
-------DrugName: Product name.
-------FormularyIndicator: Indicates presence of drug filled on plan's formulary.
-------[GENERIC BRAND IND]: Denotes single source brand vs. multi source brand vs. generic
-------PrescriberDEANumber: Identifier for prescribers admin by DEA
-------DaysSupply: Number of days covered by prescription - as written.
-------[DT OF FILL]: Date Rx was filled by pharmacy.
-------Quantity: Number of pills as written in script.
-------[AMOUNT PAID]: Total amount reimbursed to the pharmacy by payer.
-------BilledAmount_Rx: Total amount preseneted to the payer for remittance.
-------Copayment: Amount paid by patient per benefit plan
-------Deductible: Amount paid by patient per benefit plan.
-------Ingrd_Cost: Base cost of an Rx
-------DispFee: Cost charged by pharmacy per perscription.
-------Pro_Fee: Professional charge for admin of Rx.
-------Tax: Taxes on transaction.
-------NotAllwAmt: Amount removed from the payment to the pharmacy, based on contracts.
-------PaidDate: Date claim was paid to pharmacy from payer.
-------HomeDeliveryRetailCode: Reveals pharmacy type that filled Rx: Mail Order or Retail.
-------RxNumber: 6 digit ID that remains the same for each refill
-------Fill_Number: counts refills on each MDS0043BLNGIMGLOCNBR
-------Dependent_ID: Code that numbers subsriber and his/her dependents. Subscriber is 00 or 01.
-------Adjustment_Ind: Code that describes a record as a paid claim, an adjusted claim, a
-------                voided claim or a re-processed claim.


---------------------------------------------------------------------------------------------
--*******************************************************************************************
---------------------------------------------------------------------------------------------

--Find the sum of [AMOUNT PAID] for the table; use this actual sum to replace 999.99 through
--out the code. This provides percentages for analysis.
select sum([AMOUNT PAID]) from [014 RX CLAIMS]
--





--SN.228 AmountBilled
----Gross amount presented by pharmacy to payer.
----If an AmountBilled field is not present use this formula:
------Ingrd_Cost + DispFee - Copayment
select sum(BilledAmount_Rx) as AmountBilled
from [014 RX CLAIMS]
--
--Replace 888.88 through-out code with total billed amount figure.

--Compare BilledAmount_Rx to manual calculation of billed amount.
select sum(Ingrd_Cost + DispFee) as AmountBilled
from [014 RX CLAIMS]
--




--SN.230 ClaimNumber
----Client-internal ID for medical charges billed. Varies largely from file to file.
----Count distinct [DOCUMENT NUMBER] and compare to record count: 
select count(*) from [014 RX CLAIMS]
--
select count(distinct [DOCUMENT NUMBER]) from [014 RX CLAIMS]
--
select count(distinct [DOCUMENT NUMBER]+Fill_Number+Adjustment_Ind) from [014 RX CLAIMS]
--
--If distinct [DOCUMENT NUMBER] count is less than record count, look for additional fields that 
--distinguish records like ClaimType or Adjustment_Indicator.

----View all fields, order by select fields, analyze:
select *
from [014 RX CLAIMS]
order by MedMemberID,RxNumber,Fill_Number,[DT OF FILL]

----View select fields
select MedMemberID as MedMemberID,[DOCUMENT NUMBER],Adjustment_Ind,RxNumber,Fill_Number,NDC,DrugName,
       [DT OF FILL],[AMOUNT PAID]
from [014 RX CLAIMS]
order by MedMemberID,RxNumber,Fill_Number,[DT OF FILL]




--SN.231 ClaimPaidDate
----Date claim was paid by payer. Count recs by ccyymm, compare with cycle dates.
select convert(varchar,year(PaidDate))+
RIGHT('0'+convert(varchar,month(PaidDate)),2),count(*) as recs
from [014 RX CLAIMS]
group by convert(varchar,year(PaidDate))+
RIGHT('0'+convert(varchar,month(PaidDate)),2)
order by 1
--




--SN.232 CopayAmount
----Amount paid by patient for an Rx filled per their benefit plan. Usually a fixed amouont,
----could be a percentage arrangement as well.
select sum(Copayment) as Total_Copay
from [014 RX CLAIMS]
--

select sum(Copayment)/888.88 as Percentage
from [014 RX CLAIMS]
--



--SN.233 DaysSupply (INT)
----Days the quantity, strength and directions/prescription allow - distinct on every Rx.
----Value as written on script.
----Find Mode; look for nulls, blanks and 0s.
select DaysSupply,count(*) as rxs
from [014 RX CLAIMS]
group by DaysSupply
order by Rxs desc
--

--Sum [AMOUNT PAID] for different ranges
select 'a.0' as range,sum([AMOUNT PAID])/999.99 as AmtPaid_Percent
from [014 RX CLAIMS]
where DaysSupply = '0'
union 
select 'b.1-60',sum([AMOUNT PAID])/999.99 as AmtPaid_Percent
from [014 RX CLAIMS]
where DaysSupply between '1' and '60'
union
select 'c.61-120',sum([AMOUNT PAID])/999.99 as AmtPaid_Percent
from [014 RX CLAIMS]
where DaysSupply between '61' and '120'
union
select 'd.120+',sum([AMOUNT PAID])/999.99 as AmtPaid_Percent
from [014 RX CLAIMS]
where DaysSupply > '120'
union
select 'e.Total',sum([AMOUNT PAID])/999.99 as AmtPaid_Percent
from [014 RX CLAIMS]
union
select 'f.Null',sum([AMOUNT PAID])/999.99 as AmtPaid_Percent
from [014 RX CLAIMS]
where DaysSupply is null
union
select 'g.Blank',sum([AMOUNT PAID])/999.99 as AmtPaid_Percent
from [014 RX CLAIMS]
where DaysSupply = ' '




--SN.236 DEANumber
----Alpha-Numeric identifier for prescribers assigned by the DEA for tracking of Rxs.
----Match against tbl_Master_DEANames
select sum([AMOUNT PAID])/999.99 as AmtPaid_Percent
from [014 RX CLAIMS]
where PrescriberDEANumber in (select DEAID from 
                    washington.hawkeyemaster.dbo.tbl_Master_DEANames)





--SN.237 DeductibleAmount
----Amount paid by patient for an Rx filled per their benefit plan. For patients with 
----indemnity plans where a certain amount must be met by the patient for a benefit year 
----before the payer is involved.
select sum(Deductible) as Total_Copay
from [014 RX CLAIMS]
--

select sum(Deductible)/888.88 as Percentage
from [014 RX CLAIMS]
--


--SN.238 DOB
----Check for "dummy" DOB values, e.g. "9999-01-01"
select PatientDateofBirth,count(*) as recs
from [014 RX CLAIMS]
group by PatientDateofBirth
order by recs desc

----Check for invalid DOB values, e.g. "1776-07-04"
select PatientDateofBirth,count(*) as recs
from [014 RX CLAIMS]
group by PatientDateofBirth
order by PatientDateofBirth 





--SN.240 EmployeeID
--Usually the employee's SSN
----Find Length of base member identifier(MedMemberID),SSNs are 9 in length.
select len(MedMemberID),count(*) as recs
from [014 RX CLAIMS]
group by len(MedMemberID)
order by recs desc
--




--SN.241 Formulary
----Indicator for presence of drug on a plan's established preferred drug-list.
-----Check [AMOUNT PAID] by indicator.
select FormularyIndicator,sum([AMOUNT PAID])/999.99 as AmtPaid_Percent
from [014 RX CLAIMS]
group by FormularyIndicator
order by AmtPaid_Percent desc
--
----Business Rule:
----Set = 'Y' where drug is on formulary; Set = 'N' where drug is not on formulary.





--SN.243 GenBrandInd
----Indicator for branded drugs and generics.
----Check [AMOUNT PAID] by indicator.
select [GENERIC BRAND IND],sum([AMOUNT PAID])/999.99 as AmtPaid_Percentage
from [014 RX CLAIMS]
group by [GENERIC BRAND IND]
order by AmtPaid_Percentage desc
--
----Business Rule:
----Set = '1' where drug is a single source brand; Set = '2' where drug is multi-source 
----brand. Set = '3' where drug is a generic.


--SN.244 Gender
-----View Values
select PatientGender,
count(distinct(left(MedMemberID,9)+convert(varchar(50),PatientDateofBirth,12))) as members 
from [014 RX CLAIMS]
group by PatientGender
order by members desc
--
	
--If NULL or more than two distinct values for MemberSex then rectify with data contact.
--If sum of distinct member count my MemberSex > distinct total members then investigate
--Business Rule Standard:
----M = Male; F = Female





--SN.245 HMOID
--SN.246 HMOName
-----2nd level of 4-level aggregation. Usually hard-coded or updated via eligibility.



--SN.248 MailOrderIndicator
----Code revealing type of pharmacy that filled the Rx and how it was delivered.
select HomeDeliveryRetailCode,sum([AMOUNT PAID])/999.99 as Amt_Paid_PerCent
from [014 RX CLAIMS]
group by HomeDeliveryRetailCode
order by Amt_Paid_PerCent desc
--
----Business Rule:
----Set = 'M' where Rx filled by Mail-Order Pharmacy; Set = 'R' where filled by retail




--SN.250 MemberID
----Unique identifier for each patient filling an Rx.
----Find Length 
select len(MedMemberID),count(*) as recs
from [014 RX CLAIMS]
group by len(MedMemberID)
order by recs desc
--

--
--View Concat of Employees' SSN and Patients' DOB
select left(MedMemberID,9)+convert(varchar(50),PatientDateofBirth,12) as MedMemberID,
       count(*) as recs
from [014 RX CLAIMS]
group by left(MedMemberID,9)+convert(varchar(50),PatientDateofBirth,12)
order by recs desc

--Look at records for MemberID with most records.
select * from [014 RX CLAIMS]
where left(MedMemberID,9)+convert(varchar(50),PatientDateofBirth,12) = '123456789'

----Count Distinct Members
select count(distinct(left(MedMemberID,9)+convert(varchar(50),PatientDateofBirth,12))) 
       as members 
from [014 RX CLAIMS]
--




--SN.252 NDCCode
----11 digit code standard for the industry references drug name, strength, package size,etc. 
----Check to ensure length = 11
select len(NDC),sum([AMOUNT PAID])/999.99 as AmtPaid_Percent
from [014 RX CLAIMS]
group by len(NDC)
order by AmtPaid_Percent desc
--

--Match NDC to master reference table.
select sum([AMOUNT PAID])/999.99 as AmtPaid_Percent
from [014 RX CLAIMS]
where NDC in (select NDCCode from 
                    washington.hawkeyemaster.dbo.tbl_Master_NDCInfo)




--SN.253 NDCDesc 
----Description of code; usually drug name or pname or pdesc.
----Check DrugName on claim, if provided.
select DrugName,sum([AMOUNT PAID])/999.99 as AmtPaid_Percent
from [014 RX CLAIMS]
group by DrugName
order by AmtPaid_Percent desc
--Top 5




--SN.254 NotAllowedAmount
-----Amount refused by payer, usually per contracts with pharmacies. 
select sum(NotAllwAmt) 
from [014 RX CLAIMS]
--

select sum(NotAllwAmt)/888.88 as Percentage
from [014 RX CLAIMS]
--




--SN.255 PaidAmount
----Dollar amount remitted to the pharmacy for drugs filled.
select sum([AMOUNT PAID])/888.88 as percentage
from [014 RX CLAIMS]
--
select sum([AMOUNT PAID]) as Total
from [014 RX CLAIMS]
--

----Ingredient Cost + Dispensing Fee + Tax - Copay - Deductible Applied 
----Check [AMOUNT PAID] against above formula
select sum(Ingrd_Cost+DispFee+Tax-Copayment-Deductiblet-NotAllwAmt) as Total
from [014 RX CLAIMS]
--
--Check for negative [AMOUNT PAID] values
select count(*) from [014 RX CLAIMS]
where [AMOUNT PAID] < 0




--SN.257 PCPID
--SN.259 PCPName
-----4th level of 4 level aggregation.




--SN.260 PlanTypeCode
--SN.261 PlanTypeDesc
-----3rd level of 4 level aggregation




--SN.267 ServiceDate
----Date Rx was filled by pharmacy.
----Check a count of Rxs by year_month of sevice and compare to reporting dates.
select convert(varchar,year([DT OF FILL]))+
RIGHT('0'+convert(varchar,month([DT OF FILL])),2),count(*) as recs
from [014 RX CLAIMS]
group by convert(varchar,year([DT OF FILL]))+
RIGHT('0'+convert(varchar,month([DT OF FILL])),2)
order by 1
--





--SN.268 ServiceUnits (INT)
----Quantity Dispensed in a fill. For Rxs in the pill form it's an actual count of units. 
----For liquid and other forms it can be non-standard.
----Qty as written on the script.
----Find Mode; look at format of field
select Quantity,count(*) as rxs
from [014 RX CLAIMS]
group by Quantity
order by Rxs desc
--

--Sum [AMOUNT PAID] for different ranges
select 'a.0' as range,sum([AMOUNT PAID])/999.99 as AmtPaid_Percent
from [014 RX CLAIMS]
where Quantity = '0'
union 
select 'b.1-60',sum([AMOUNT PAID])/999.99 as AmtPaid_Percent
from [014 RX CLAIMS]
where Quantity between '1' and '60'
union
select 'c.61-120',sum([AMOUNT PAID])/999.99 as AmtPaid_Percent
from [014 RX CLAIMS]
where Quantity between '61' and '120'
union
select 'd.120+',sum([AMOUNT PAID])/999.99 as AmtPaid_Percent
from [014 RX CLAIMS]
where Quantity > '120'
union
select 'e.Total',sum([AMOUNT PAID])/999.99 as AmtPaid_Percent
from [014 RX CLAIMS]
union
select 'f.Null',sum([AMOUNT PAID])/999.99 as AmtPaid_Percent
from [014 RX CLAIMS]
where Quantity is null
union
select 'g.Blank',sum([AMOUNT PAID])/999.99 as AmtPaid_Percent
from [014 RX CLAIMS]
where Quantity = ' '
--





--SN.271 SubscriberFlag
select Dependent_ID,count(*) as recs
from [014 RX CLAIMS]
group by Dependent_ID
order by recs desc
--














