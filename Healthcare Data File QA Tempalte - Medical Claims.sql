--Medical Claims Template Code



--****************************************************************************************
----Medical Claims File (Mx)

------Top-level analysis:
--View table
select * from tbl_AsImported_Claims

--Row Count: Match to control totals, if available
select count(*) from tbl_AsImported_Claims
--388436


--Column Count 
----Find table 'id'
select id from sysobjects where name = 'tbl_AsImported_Claims'
----Count Columns
select count(*) from syscolumns where id = '437576597'
--59



----Column Names
select name from syscolumns where id = '437576597'
order by colid
--
select name from syscolumns where id = '437576597'
order by name



--Replace place-holder column names with actual colulmn names using Edit: Replace (CTRL-H)
-----Glossary
-------BilledAmount: Money value billed for services.
-------BillTypeCode: Code that groups claims by entity submitting the bill. 
--               P = physician; A = ancillary; F = facility
-------ClaimNumber: ID sequence for services billed; number can itemize each claim or each 
--------------------line on a claim depending on client's numbering method.
-------ClaimLineNumber: A sub-number to ClaimNumber, itemizing the number of lines per claim.
-------ClaimPaidDate: Date claims was paid/acted-on by payer.
-------ClaimRecDate: Date claim was received by payer.
-------ClaimTypeCode: Distinguishes claims among medical(M),dental(D),pharmacy(Rx),vision(V)
-------ClaimTypeDesc: Distinguishes claims among medical(M),dental(D),pharmacy(Rx),vision(V)
-------CoInsuranceAmount: Money value for patient's scheduled payment per benefits.
-------CoPayAmount: Money value for patient's scheduled payment per benefits.
-------DeductibleAmount: Money value for patient's responsibility per benefits.
-------Diag1Code: Code for diagnosis, primary as opPOSCodeed to secondary or tertiary
-------MedMemberDOB: date of birth for member in Mx data
-------MedSubscriberID: Usually populated with employee's SSN plus a two digit suffix
-------ServiceDate: Date care was initiated aka admit date.
-------MedMemberGender: members' gender in Mx data.
-------NetworkFlag: Indicator of contract status between payer and ProviderIDer
-------MedMemberID: Usually populated with employee's SSN with a two digit suffix attached.
-------ModifierCode: Two digit modifier used on CPT4 ProcCode codes.
-------ProviderGroupID: Code identifying Networks of contracted ProviderIDers.
-------ProviderGroupName: Description for above Networks.
-------NotAllowedAmount: Money value for dollars not paid per contract between payer and 
-------	 		 plan.
-------PaidAmount: Money value paid for services: Payer to ProviderIDer or payer to patient.
-------POSCode: Location/setting healthcare was administered, HCFA standard
-------PlanExclAmount: Money value for exlcluded dollars per limits set-up in contracting.
-------PPOSavingsAmount: Money value for portion of bill DeductibleAmounted for payment due; 
-------                  per contracted rates.
-------ProcCode: Code used to ID what medical work was done in the setting.
-------ProcTypeFlag: Indicator of procedure code filed on claim line. (CPT4,HCPC,REV,DRG,etc)
-------ProviderID: Identifier for renderer of care, DEA, ME#, or federal tax ID or home-grown.
-------ProvTypeCode: Code for rolling-up providers into large classes.
-------ProvTypeDesc: Description for ProvTypeCode
-------SpecialtyCode: Code for specialty of ProviderIDer rendering care. This is the detailed level.
-------SpecialtyDesc: description for SpecialtyCode
-------ServiceDate: Date care was received.
-------ServiceTypeCode: Type of service code for billing; bundles claims of like procedure.
-------ServiceTypeDesc: Description for ServiceTypeCode
-------ServiceUnitQuantity: Numerical measure for healthcare metrics.
-------MedDepSeqCode : Indicates subscriber to plan and his/her dependents.
-------DischargeDate: Date care was terminated, aka discharge date.
-------CaseMGMTFlag: Indicates members' inclusion in a case management program.
-------AdjudicationFlag: If ClaimNumber+ClaimLineNumber not itemizing by line,
--                       then ClaimNumber+ClaimLineNumber+AdjudicationFlag should.


---------------------------------------------------------------------------------------------

--*****************************************************************************************
--For the purposes of QCing columns using PaidAmount percentages, replace 45888529.6300 with 
--the result from the below statement:
select sum(PaidAmount) as AmtPaid
from tbl_AsImported_Claims
--45888529.6300

--*****************************************************************************************

---------------------------------------------------------------------------------------------



--SN.90 BilledAmount
----Dollar amount billed by Provider for services rendered. 
----Sum for entire table. Look for proper decimal point placement:
select sum(BilledAmount) as AmtBilled
from tbl_AsImported_Claims
--91322937.3500

----Find ratio between PaidAmount/BilledAmount. Percentage should be between 40% & 60%.
select 45888529.6300/sum(BilledAmount) as Ratio
from tbl_AsImported_Claims
--.502486351858457824779986





--SN.91 Bill Type ALSO SEE SN.153 BELOW!!!
select BillTypeCode,count(*) as recs
from tbl_AsImported_Claims
group by BillTypeCode
order by recs desc
--P	239836
--F	148600





--SN.93 ClaimNumber
----Client-internal ID for medical charges billed. Varies largely from account to account.
----Count distinct ClaimNumber and compare to record count. If distinct count is less than
----record count then there are multiple lines per ClaimNumber
select count(*) from tbl_AsImported_Claims
--388436

select count(distinct ClaimNumber) from tbl_AsImported_Claims
--177735


----Count distinct ClaimNumber+ClaimLineNumber and compare to record count.
select count(distinct ClaimNumber+ClaimLineNumber) from tbl_AsImported_Claims
--372336


----Count distinct ClaimNumber+ClaimLineNumber+AdjudicationFlag and compare to record count.
select count(distinct ClaimNumber+ClaimLineNumber+AdjudicationFlag) 
from tbl_AsImported_Claims
---372336


----View selected fields and analyze results to understand how the data
----set was constructed with regard to level of detail billed, inclusion/exclusion of
----denied, adjusted or backed-out claims and if PaidAmount is a negative value where it 
----should be.
select ClaimNumber,ClaimLineNumber,AdjudicationFlag,ServiceDate,ClaimPaidDate,
MedMemberID+convert(varchar(50),MedMemberDOB,12) as memberid,
Diag1Code,[ProcCode],PaidAmount
from tbl_AsImported_Claims
order by ClaimNumber,ClaimLineNumber,ServiceDate





--SN.94 ClaimPaidDate
----Date claim was processed by the payer. Records should appear most robustly for the cycle's
----yyyymms, however there may be be run-in and run-out claims that were processed before or
----after the reporting dates.
--Count recs by year_month and compare with cycle dates.
select convert(varchar,year(ClaimPaidDate))+
RIGHT('0'+convert(varchar,month(ClaimPaidDate)),2),count(*) as recs
from tbl_AsImported_Claims
group by convert(varchar,year(ClaimPaidDate))+
RIGHT('0'+convert(varchar,month(ClaimPaidDate)),2)
order by 1





--SN.95 ClaimRecDate
----Date claim was received by the payer. Records should appear most robustly for the cycle's
----yyyymms, however there may be be run-in and run-out claims that were processed before or
----after the reporting dates.
--Count recs by year_month and compare with cycle dates.
select convert(varchar,year(ClaimRecDate))+
RIGHT('0'+convert(varchar,month(ClaimRecDate)),2),count(*) as recs
from tbl_AsImported_Claims
group by convert(varchar,year(ClaimRecDate))+
RIGHT('0'+convert(varchar,month(ClaimRecDate)),2)
order by 1





--SN.96 ClaimTypeCode
----Uses Type of Service codes to assign one of the four values: M,D,Rx,V
select ClaimTypeCode,ClaimTypeDesc,count(*) as recs
from tbl_AsImported_Claims
group by ClaimTypeCode,ClaimTypeDesc
order by recs desc
--M	Medical		206843
--H	Hospital	152812
--E	Vision		10575
--D	Dental		9426
--V	Substance Abuse	7593
--R			1187






--SN.97 ClaimTypeDesc
select ClaimTypeCode,ClaimTypeDesc,count(*) as recs
from tbl_AsImported_Claims
group by ClaimTypeCode,ClaimTypeDesc
order by recs desc
--
----If ClaimTypeCode & Desc are not available, check file TOS reference table and look for 
----non-medical types of service, e.g. Rx or Dental. 

--Check descriptions for ServiceTypeCode by matching with imported AsPrpared table:
select ServiceTypeCode,[DESC],sum(PaidAmount)/45888529.6300 as amt_pd_percent
from tbl_AsImported_Claims A,masterdb.rules.dbo.tbl_AsPrepared_XXX_Serv_Type B
where a.ServiceTypeCode=b.code
group by ServiceTypeCode,[DESC]
order by amt_pd_percent desc
--
----Business Rule:
----Breaks the care renedered into four possible codes: MED,RX,VIS,DEN





--SN.98 CoInsurance
----Dollar amount paid by patient, per benefit schedule, usually applied after a deductible
----has been met.
----Sum for entire table
select sum(CoInsuranceAmount) as Coins
from tbl_AsImported_Claims
--911108.9900

----Find ratio with BilledAmount; 1-5% range.
select sum(CoInsuranceAmount)/sum(BilledAmount) as AmtBilled_Ratio
from tbl_AsImported_Claims
--.0099






--SN.99 CoPayAmount
----Dollar amount paid by patient, per benefit schedule, this is usually a fixed, whole dollar
----amount not related to a deductible.
----Sum for entire table
select sum(CoPayAmount) as CoPayAmount
from tbl_AsImported_Claims
--3889538.9400

----Find ratio with BilledAmount; 5%-15% range.
select sum(CoPayAmount)/sum(BilledAmount) as AmtBilled_Ratio
from tbl_AsImported_Claims
--.0425






--SN.101 DeductibleAmount
----Dollar amount paid by patient, per benefit schedule; yearly amount paid out-of-pocket
----by member before copay or coinsurance benefits kick-in. Indemnity plans use deductibles.
----Many managed care plans are using hybrids of indemnity/copay benefits.
----Sum for entire table
select sum(DeductibleAmount) as Deduc
from tbl_AsImported_Claims
--109547.4300

----Find ratio with BilledAmount; 1%-5% range.
select sum(DeductibleAmount)/sum(BilledAmount) as AmtBilled_Ratio
from tbl_AsImported_Claims
--.0011






--SN.102 DiagCode
----ICD9 code 2-5 digits in length. This field should be populated with the 
----primary diagnosis. ICD9 codes have decimal points, however they are usually not included 
----in claims billing. 's reference table must have ICD9 codes with out decimal point.
--View codes, look for decimals
select Diag1Code from tbl_AsImported_Claims

--Sum PaidAmount by length of Diag1Code(ICD9 coddes are 2-5 in length without decimals)
select len(Diag1Code),sum(PaidAmount)/45888529.6300 as amt_pd_percent
from tbl_AsImported_Claims
group by len(Diag1Code)
order by amt_pd_percent desc
--4	.51939741155746419
--5	.38111932482941053
--3	.09948326361312527


--Calculate % of PaidAmount dollars where Diag1Code has a match in Master reference 
--table: masterdb.master.dbo.tbl_Master_DiagCodes
----ICD9
select sum(PaidAmount)/45888529.6300 as amt_pd_percent
from tbl_AsImported_Claims a, masterdb.master.dbo.tbl_Master_Diagnoses b
where a.Diag1Code=b.DiagCode
--





--SN.103 DiagDesc
----Descriptions for the above codes. Use master tables and AsPrepared tables to populate.
select a.Diag1Code,b.DiagDesc,sum(PaidAmount)/45888529.6300 as amt_pd_percent
from tbl_AsImported_Claims a, masterdb.master.dbo.tbl_Master_Diagnoses b
where a.Diag1Code=b.DiagCode
group by a.Diag1Code,b.DiagDesc
order by amt_pd_percent desc
--




--SN.104 DOB
----Patient date of birth. Critical component for creating member IDs. Converted to yymmdd 
----format.
----Check length for uniformity. All records should have length of 6:
select len(convert(varchar(50),MedMemberDOB,12)),count(*) as recs
from tbl_AsImported_Claims
group by len(convert(varchar(50),MedMemberDOB,12))
order by recs desc
--6	388436

----Check for dummy values:
select convert(varchar(50),MedMemberDOB,12),count(*) as recs
from tbl_AsImported_Claims
group by convert(varchar(50),MedMemberDOB,12)
order by recs desc
--

----Check for invalid DOBs, i.e. future dates.
select convert(varchar(50),MedMemberDOB,12),count(*) as recs
from tbl_AsImported_Claims
group by convert(varchar(50),MedMemberDOB,12)
order by convert(varchar(50),MedMemberDOB,12)
--





--SN.105 EmployeeID
----Subscriber's SSN is preferred.
select distinct MedSubscriberID from tbl_AsImported_Claims
--

----Find Length(s) of MedSubscriberID
select len(MedSubscriberID),count(*) as recs
from tbl_AsImported_Claims
group by len(MedSubscriberID)
order by recs desc
--SSNs are 9 in length, SSNs are the best chance for matches with Ex and Rx
--9	388436


----Check for dummy values, i.e. values inserted as defaults - these values will usually
----have high record counts. (Examples: 123456789 or 999999999).
select MedSubscriberID,count(*) as recs
from tbl_AsImported_Claims
group by MedSubscriberID
order by recs desc
--





--SN.106 FromDate
----Date care commenced. Records should appear most robustly for the cycle's yyyymms, 
----however there may be be run-in and run-out claims that were processed before or
----after the reporting dates.
--Count recs by year_month and compare with cycle dates.
select convert(varchar,year(ServiceDate))+
RIGHT('0'+convert(varchar,month(ServiceDate)),2),count(*) as recs
from tbl_AsImported_Claims
group by convert(varchar,year(ServiceDate))+
RIGHT('0'+convert(varchar,month(ServiceDate)),2)
order by 1
--





--SN.109 Gender
----Check values in MedMemberGender field.
select MedMemberGender,count(*) as records
from tbl_AsImported_Claims
group by MedMemberGender
--F	244639
--M	143797


--Business Rule: Males must be coded as 'M'; Females as 'F'.





--SN.110 HMOID
-----2nd tier of 4 level aggregation logic. Very often this field IDs the payer by code.
select caseid,casedesc,count(*) as recs
from tbl_AsImported_Claims
group by caseid,casedesc
order by caseid,casedesc

select caseid,casedesc,count(*) as recs
from tbl_AsImported_Eligibilities
group by caseid,casedesc
order by caseid,casedesc


--SN.111 HMOName
-----2nd tier of 4 level aggregation logic. Very often this field IDs the payer by name.





--SN.113 InNetwork
-----Code describing the contract status of the Provider and payer of a claim. 

--Count recs by Network code
select NetworkFlag,count(*) as recs
from tbl_AsImported_Claims
group by NetworkFlag
order by recs desc
--I	323100
--O	65336

--Business Rule:
----set = 'Y' for claims paid as out-of-network; set = 'N' for claims paid as in-network.





--SN.114 Inpatient Days
----Metric counting number of days of room & board charged on an inpatient claim.
----Often appears under SERVICEServiceUnitQuantity field. Revenue codes are used to distinguish claim-lines
----as room & board charges. See Master.Tbl_Master_RevenueCodes.RoomBoardInd = 'Y'.
--View Claims that match room & board revenue code:
select ClaimNumber,ClaimLineNumber,AdjudicationFlag,ServiceDate,DischargeDate,
MedMemberID+convert(varchar(50),MedMemberDOB,12) as memberid,
a.[ProcCode],ServiceUnitQuantity
from tbl_AsImported_Claims A, masterdb.master.dbo.tbl_master_procedures B
where len(a.ProcCode) = 3
      AND
      'R' + a.[ProcCode]=b.ProcCode
      AND 
      b.ProcAreaDesc like '%Days%'
order by ClaimNumber,ClaimLineNumber,ServiceDate 


select * from masterdb.master.dbo.tbl_master_procedures


--SN.117  MemberID
----Unique string used to ID patients within and across data sources. The base is almost
----always employee SSN concatenated with patient date of birth to distinguish members
----receiving coverage through a subscriber/employee.

--View Concat
select distinct left(MedMemberID,9)+convert(varchar(50),MedMemberDOB,12) as memberid
from tbl_AsImported_Claims

----Count Distinct Members
select count(distinct left(MedMemberID,9)+convert(varchar(50),MedMemberDOB,12)) as members 
from tbl_AsImported_Claims
--11,648






--SN.119 ModifierCode & SN.120 ModifierCodeDesc
----Two digit code used to modify CPT4 ProcCode codes. These modifier codes often include
----homegrown values, check codes against tbl_Master_ModifierCodes in Master.
select a.ModifierCode,COUNT(*) AS RECS
from tbl_AsImported_Claims a
group by a.ModifierCode
order by RECS DESC
--





--SN.122 ProviderGroupID
----Code used to ID the PPO network the claim was paid under. A blank or null value usually 
----indicates that the Provider was out-of-network.
----View ProviderGroupID by highest aggregate dollar codes:
select ProviderGroupID,sum(PaidAmount) as Amt_Pd
from tbl_AsImported_Claims
group by ProviderGroupID
order by Amt_Pd desc



select * from tbl_AsImported_Claims
where providername <> providergroupname


--SN.123 NetworkName
----Name associate with ProviderGroupID
----Select and sum by PaidAmount
select ProviderGroupID,ProviderGroupName,sum(PaidAmount)/45888529.6300 as Ratio
from tbl_AsImported_Claims
group by ProviderGroupID,ProviderGroupName
order by Ratio desc




--SN.125 NotAllowed
----Dollar amount not paid due per the contracting between plan and Provider.
----Sum for entire table
select sum(NotAllowedAmount) as NotAllw_Amt
from tbl_AsImported_Claims
--

--Find percentage of amount billed, 5-10% range:
select sum(NotAllowedAmount)/sum(BilledAmount) as NotAllw_Amt_Percent
from tbl_AsImported_Claims
--






--SN.127 PaidAmount
----Dollar amount paid to Provider by payer for services rendered. 
----Sum for entire table
select sum(PaidAmount) as AmtPd
from tbl_AsImported_Claims
--

--Find percentage of amount billed, 60-80% range:
select sum(PaidAmount)/sum(BilledAmount) as Amt_Paid_Percent
from tbl_AsImported_Claims
--

----Check for negative values in data, indicates presence of back-outs.
select count(*) as recs from tbl_AsImported_Claims
where PaidAmount < 0
--





--SN.132 PCPTypeCode

select caseid,casedesc,UnitID,UnitDesc,plantypecode,PlanTypeDesc,
count(*) as recs
from tbl_AsImported_Claims
--where plantypecode = ' '
group by caseid,casedesc,UnitID,UnitDesc,plantypecode,PlanTypeDesc
order by 2,3

select caseid,casedesc,UnitID,UnitDesc,plantypecode,PlanTypeDesc,
count(*) as recs
from tbl_AsImported_Eligibilities
--where plantypecode = ' '
group by caseid,casedesc,UnitID,UnitDesc,plantypecode,PlanTypeDesc
order by 2,3
           
select casedesc,plantypecode,PlanTypeDesc,
count(*) as recs
from tbl_AsImported_Eligibilities
--where plantypecode = ' '
group by casedesc,plantypecode,PlanTypeDesc
order by 1,recs desc

select casedesc,plantypecode,PlanTypeDesc,
count(*) as recs
from tbl_AsImported_Claims
--where plantypecode = ' '
group by casedesc,plantypecode,PlanTypeDesc
order by 1,recs desc

select caseid,casedesc,UnitID,UnitDesc,plantypecode,PlanTypeDesc,
count(*) as recs
from tbl_AsImported_Claims
---where MedSubscriberID = '521962118'
group by caseid,casedesc,UnitID,UnitDesc,plantypecode,PlanTypeDesc
order by 2,3

--SN.133 PCPTypeDesc
-----3rd level in 4 level aggregation logic. Often a group roll-up name, or vendor name.




--SN.134 PlaceOfServiceCode
----This field must be the HCFA standard; if not, then the non-HCFA codes must be 
----cross-walked to HCFA using a reference table.
----View POS codes within the data:
select POSCode,count(*) as recs
from tbl_AsImported_Claims
group by POSCode
order by POSCode

select billtypecode,POSCode,providername,specialtydesc,proccode,procdesc,count(*) as recs
from tbl_AsImported_Claims
where poscode = 'TX'
group by billtypecode,POSCode,providername,specialtydesc,proccode,procdesc
order by recs desc


select proccode,procdesc,count(*) as recs
from tbl_AsImported_Claims
where poscode = '21'
group by proccode,procdesc
--order by billtypecode,POSCode,providername,proccode,procdesc
order by len(proccode),recs desc

select * from tbl_AsImported_Claims

--Count records by length; look for nulls or blanks.
select len(POSCode),count(*) as recs 
from tbl_AsImported_Claims
group by len(POSCode)
order by recs desc





--SN.135 PlaceOfServiceDesc
----Description for location of care.
------This field must be populated with HCFAPOSDesc from 
------masterdb.master.dbo.tbl_Master_HCFAPOS

--Match against master table: Check Sum of PaidAmount
select sum(PaidAmount)/45888529.6300 from tbl_AsImported_Claims
where POSCode in (select HCFAPOSCode
	           from masterdb.master.dbo.tbl_Master_HCFAPOSCodes)




--SN.136 Plan Limit Exclusion
----Dollar amount not paid due to a limit referenced in the contract
----Sum for entire table
select sum(PlanExclAmount) as PlanEx_Amt
from tbl_AsImported_Claims
--

--Find percentage of amount billed, 1-5% range:
select sum(PlanExclAmount)/sum(BilledAmount) as PlanExcl_Percent
from tbl_AsImported_Claims






--SN.139 PPOSavings
----Dollar amount discounted for payer in accordance with Provider contracts.
----Sum for entire table
select sum(PPOSavingsAmount) as PPO_Save
from tbl_AsImported_Claims
--.0000


----Find % vs. BilledAmount
select sum(PPOSavingsAmount)/sum(BilledAmount) as PPO_Save_PerCent
from tbl_AsImported_Claims
--

----Often PPOSavings is not ProviderIDed in the data because of contract scenarios. If this is 
----case, PPOSavings can be "backed-into" by subtracting the different paid values from the 
----originally charged amount.
select (sum(BilledAmount)-SUM(PaidAmount+CoInsuranceAmount+CoPayAmount+DeductibleAmount+AMOUNTCOB))
       /(sum(BilledAmount)) as PPO_Save_PerCent
from tbl_AsImported_Claims




--SN.140 ProcCode
--SN.141 ProcDesc
----Codes filed on claims to describe the acutal "work-done" by a Provider, for which they are 
----billing. HCPC,CPT4,ICD9,Revenue,DRG and homegrown codes are all possible values.
----Procedure coding is the most non-standard and divergent element in healthcare data 
----received by . In some data sets there are multiple columns (one for each procedure 
----code type), however, this standardized code is written for tables in which the different 
----procedure code types are "stacked" into one column: look for a procedure code type column
----denoting the PRRCDRCD value as CPT4, Revenue Code, etc. Without this column, follow 
----standards below to reveal procedure code type and definition.

--Find % of amount paid by length: length CPT4 = 5, Revenue = 3
select ProcTypeFlag,len(ProcCode),sum(PaidAmount)/45888529.6300 as amt_pd_percent
from tbl_AsImported_Claims
group by ProcTypeFlag,len(ProcCode)
order by amt_pd_percent desc
-- 

--Check PaidAmount percentage for matches against masterdb.master.dbo.
--tbl_master_procedures and masterdb.palmercaycarefirst.dbo.tbl_AsPrepared_ICD9ProcCode
----CPT4
select sum(PaidAmount)/45888529.6300 as amt_pd_percent
from tbl_AsImported_Claims a, masterdb.master.dbo.tbl_master_procedures b
where len(a.ProcCode) = 5 AND a.ProcCode=b.ProcCode and ProcTypeFlag = 'CPT4'
--Ratio
--.57817263581822898
select * from tbl_AsImported_Claims
where len(ProcCode) = 2 and ProcTypeFlag = 'CPT4'

select * from masterdb.master.dbo.tbl_master_procedures
where ProcCode = '00095' and ProcTypeDesc = 'CPT4'

--UB92RevenueCode
select * from tbl_AsImported_Claims
where ProcTypeFlag = 'REV'

select ProcTypeFlag,len(ProcCode),sum(PaidAmount)/45888529.6300 as amt_pd_percent
from tbl_AsImported_Claims
where ProcTypeFlag = 'REV'
group by ProcTypeFlag,len(ProcCode)
order by amt_pd_percent desc

select sum(PaidAmount)/45888529.6300 as amt_pd_percent
from tbl_AsImported_Claims a, masterdb.master.dbo.tbl_master_procedures b
where len(a.ProcCode) = 3 AND 'R'+a.ProcCode=b.ProcCode
--Ratio
--

--DRG Codes
select sum(PaidAmount)/45888529.6300 as amt_pd_percent
from tbl_AsImported_Claims a, masterdb.master.dbo.tbl_master_procedures b
where 'D'+a.ProcCode=b.ProcCode
--Ratio
--

--ICD9
select sum(PaidAmount)/45888529.6300 as amt_pd_percent
from tbl_AsImported_Claims a, masterdb.palmercaycarefirst.dbo.tbl_AsPrepared_ICD9ProcCode b
where a.ProcCode=b.ICD9ProcCode
--Ratio
--

--Homegrown
select sum(PaidAmount)/45888529.6300 as amt_pd_percent
from tbl_AsImported_Claims a
where ProcTypeFlag = 'DNTLC'
--Ratio
--.22944936795526607
select ProcCode,sum(PaidAmount)/45888529.6300 as amt_pd_percent
from tbl_AsImported_Claims 
where ProcTypeFlag = 'DNTLC'
group by ProcCode
order by amt_pd_percent desc

select ProcTypeFlag,ProcCode,ProcDesc,sum(PaidAmount)/45888529.6300 as amt_pd_percent
from tbl_AsImported_Claims 
where ProcDesc = ' '
group by ProcTypeFlag,ProcCode,ProcDesc
order by amt_pd_percent desc

select * 
from tbl_AsImported_Claims
where proccode = '01'



--SN.144 ProviderID
----ID for renderer of care. Often the Provider's TaxID. Attempt to make as unique as
----possible by concatenating with sub-ID or name.

--Count distinct values
select count(distinct ProviderID) from tbl_AsImported_Claims
--2654

--Count recs by length, look for standard length.
select len(ProviderID),count(*) as recs
from tbl_AsImported_Claims
group by len(ProviderID)
order by recs desc
--

--Count Recs by ProviderID, look for "dummy" IDs and frequency.
select ProviderID,count(*) as recs
from tbl_AsImported_Claims
group by ProviderID
order by recs desc
--

--Count Recs by ProviderID & ProviderName
select ProviderID,ProviderName,count(*) as recs
from tbl_AsImported_Claims
group by ProviderID,ProviderName
order by recs desc
--

--View records for ProviderID with highest number of claims; look for other fields in data 
--breaking-down to a individual Provider level (name or sub-id).
select * from tbl_AsImported_Claims 
where ProviderID = '123456789098'




--SN.146 ProviderTypeCode
--SN.147 ProviderTypeDesc
----Provider-of-care type grouping - aka individual specialty or facility description.
----Existing master reference table: masterdb.master.dbo.tbl_Master_ProviderTypes
----This table has two columns for code matching: SourceProviderTypeCode(alpha,1-3 chars) 
----and ProviderTypeCode(numeric, 3 digits). It is likely that ProvTypeCode is unique to the 
----vendor, in which case an AsImported table must be created and checked.
------ProvTypeCode: Code for rolling-up providers into large classes.
-------ProvTypeDesc
--Find most common values:
select SpecialtyCode,SpecialtyDesc,count(*) as recs
from tbl_AsImported_Claims
group by SpecialtyCode,SpecialtyDesc
order by recs desc

--Count by length; look for standard.
select len(SpecialtyCode),count(*) as recs
from tbl_AsImported_Claims
group by len(SpecialtyCode)
order by recs desc
--

--Match against Master ProviderTypes table:
----First on SourceProviderTypeCode
select sum(PaidAmount)/45888529.6300 as amt_paid_percent from tbl_AsImported_Claims
where SpecialtyCode in (select SourceProviderTypeCode 
	           from masterdb.master.dbo.tbl_Master_ProviderTypes)
--Matching Ratio
--

----Next on ProviderTypeCode
select sum(PaidAmount)/45888529.6300 as amt_paid_percent from tbl_AsImported_Claims
where SpecialtyCode in (select ProviderTypeCode 
	           from masterdb.master.dbo.tbl_Master_ProviderTypes)
--Matching Ratio
--

----Match to AsPrepared table:
select sum(PaidAmount)/45888529.6300 as amt_paid_percent from tbl_AsImported_Claims
where SpecialtyCode in (select ProviderTypeCode 
	           from masterdb.rules.dbo.tbl_AsPrepared_xxx_ProvSpec)
--Matching Ratio
--




--SN.148 ServiceDate
----Date care received. Records should appear most robustly for the cycle's yyyymms, 
----however there may be be run-in and run-out claims that were processed before or
----after the reporting dates.
--Count recs by year_month and compare with cycle dates.
select convert(varchar,year(ServiceDate))+
RIGHT('0'+convert(varchar,month(ServiceDate)),2),count(*) as recs
from tbl_AsImported_Claims
group by convert(varchar,year(ServiceDate))+
RIGHT('0'+convert(varchar,month(ServiceDate)),2)
order by 1
--




--SN.149 ServiceTypeCode
--SN.150 ServiceTypeDesc
----Highly non-standard code describing services rendered at a higher level than ProvTypeCode. 
----There is no standard reference table on file. Each data-set has it's own coding system;
----an AsPreared table is required for code descriptions. 

--Check record count by length; look for most common:
select len(ServiceTypeCode),count(*) as recs
from tbl_AsImported_Claims
group by len(ServiceTypeCode)
order by recs desc
--


--Check most common values
select ServiceTypeCode,count(*) as recs
from tbl_AsImported_Claims
group by ServiceTypeCode
order by recs desc
--

--Check descriptions for ServiceTypeCode by matching with imported AsPrpared table:
select ServiceTypeCode,[DESC],sum(PaidAmount)/45888529.6300 as amt_pd_percent
from tbl_AsImported_Claims A,masterdb.rules.dbo.tbl_AsPrepared_XXX_Serv_Type B
where a.ServiceTypeCode=b.code
group by ServiceTypeCode,[DESC]
order by recs desc





--SN.151 ServiceServiceUnitQuantity
----An integer counting ServiceUnitQuantity of care. Could be days, or MGs of IV fluid, etc...
----Look for most common values; also make sure adjustments and back-outs are negative.
select ServiceUnitQuantity,count(*) as recs
from tbl_AsImported_Claims
group by ServiceUnitQuantity
order by recs desc

select * from tbl_AsImported_Claims
where ServiceUnitQuantity = 2




--SN.153 SpecialtyRollupCode & SN.91 BillTypeCode
----Code classifying medical source of claim at a high-level. In another Analyzer window 
----opened on your local machine, make a copy of tbl_AsPrepared_xxx_ProvSpec. Add a 
----SpecRollupCode column and use the descriptions to place specialties into one of four 
----values: '01' Primary Care (IM,GP,FP,non-specified Pediatrics, and Preventative Medicine),
----'02' Specialty (any MD other than Primary Care), '03' Facility and '04' Other (All 
----ancillary or Allied Health related claims).

----SN.91 BillTypeCode - Add column to tbl_AsPrepared_xxx_ProvSpec called "BillTypeCode"
----Code classifying medical source of claim at a high-level - directly related to 
----SpecialtyRollupCode.
----Set BillTypeCode = 'P' (Physician) where SpecialtyRollupCode in ('01','02'); 
----set BillTypeCode = 'F' (Facility) where SpecialtyRollupCode = '03'; set = 'A' 
----(Allied Health Provider) where SpecialtyRollupCode = '04'.

--View record count by ProvTypeCode
select BillTypeCode,count(*) as Records
from tbl_AsImported_Claims
group by BillTypeCode
order by Records desc

--View record count by ProviderID and SpecialtyCode
select BillTypeCode,SpecialtyCode,count(*) as Records
from tbl_AsImported_Claims
group by BillTypeCode,SpecialtyCode
order by Records desc

--If available view record count by ProvTypeCode,ProvTypeDesc and SpecialtyCode,
--SpecialtyCodeDesc.
select ProvTypeCode,ProvTypeDesc,SpecialtyCode,SpecialtyCodeDesc,count(*) as Records
from tbl_AsImported_Claims
group by ProvTypeCode,ProvTypeDesc,SpecialtyCode,SpecialtyCodeDesc
order by Records desc





--SN.154 SpecialtyRollupDesc
----Set = 'Primary Care' where SpecialtyRollupCode = '01'; set = 'Specialty' where
----SpecialtyRollupCode = '01'; set = 'Facility' where SpecialtyRollupCode = '03'; 
----set = 'Other' where SpecialtyRollupCode = '04'.




--SN.156 SubscriberFlag
----Indicator of subscriber to health insurance plan.
----Count members by MedDepSeqCode
select MedDepSeqCode,count(distinct MedMemberID+convert(varchar(50),MedMemberDOB,12)) as members
from tbl_AsImported_Claims
group by MedDepSeqCode
order by members desc

----If no MedDepSeqCode available, use last two digits of MedSubscriberID where len(MedSubscriberID) = 11
select right(MedSubscriberID,2),count(distinct MedMemberID+convert(varchar(50),MedMemberDOB,12)) as members
from tbl_AsImported_Claims
where len(MedSubscriberID) > 10
group by right(MedSubscriberID,2)
order by members desc





--SN.159 ToDate
----Date care was ended; discharge date for inpatient
----View a count of records by month compare with cycle/reporting dates.
select convert(varchar,year(DischargeDate))+
RIGHT('0'+convert(varchar,month(DischargeDate)),2),count(*) as recs
from tbl_AsImported_Claims
group by convert(varchar,year(DischargeDate))+
RIGHT('0'+convert(varchar,month(DischargeDate)),2)
order by 1




--SN.171 CareManagementStatus
----Indicates member's inclusion in case management program.
----Count members by CaseMGMTFlag
select CaseMGMTFlag,count(distinct MedMemberID+convert(varchar(50),MedMemberDOB,12)) as members
from tbl_AsImported_Claims
group by CaseMGMTFlag
order by members desc 

select count(distinct MedMemberID+
                      convert(varchar(50),MedMemberDOB,12)+
                      MedMemberGender) 
                      as members
from tbl_AsImported_Claims

--9466

select distinct MedMemberID+
                      convert(varchar(50),MedMemberDOB,12)+
                      MedMemberGender 
                      as members
from tbl_AsImported_Claims
order by members


--SN.172 AdjudicationFlag
----Indicates claim's status as paid,denied,reversal,re-process,etc...
----Count members by CaseMGMTFlag
select AdjudicationFlag,count(distinct MedMemberID+convert(varchar(50),MedMemberDOB,12)) as members
from tbl_AsImported_Claims
group by AdjudicationFlag
order by members desc 

































