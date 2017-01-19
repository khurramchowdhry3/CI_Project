/*
    CRMS_UKApplicationFormExtension is the controller for CRMS_UKApplicationForm.
    It fetches information from current Opportunity, its related Business Account and
    related Person Accounts.
    
    Functionality:
    1. Update Opportunity details
    2. Updated Business Account details
    3. Update Person Account Details
    4. Add Person Accounts as Owner/Director/Guarantor to the current Opportunity
    5. If all required fields are filled the Application Form will be considered completed
*/
public class CRMS_UKApplicationFormExtension 
{
    Id accountId;
    public Integer deleteIndex{get;set;}
    public Integer debtIndex{get;set;}
    public integer rowODGCount {get;set;}
    public static integer premiseRowCount {get;set;}
    public static integer rowCount = 0;
    public static integer debtRowCount = 0;
    public string bussinesslegalAcc{get;set;}
    public string strCountry {get;set;}
    public string lkp{get;set;}
    public Id oppIdToRedirectPage{get;set;}
    public boolean blnSelfOwned {get;set;}
    public boolean blnMorgaged {get;set;}
    public boolean blnRented {get;set;} 
    public boolean blnOthers {get;set;}
    public boolean tradingSet{get;set;}
    public boolean boolFinanceBlock{get;set;}
    public boolean boolRelationShip{get;set;}
    public Boolean message{get;set;}
    public boolean blnException{get;set;}
    public Boolean boolHongkong{get;set;}
    public Boolean boolSingapore{get;set;}
    public Boolean boolPhilippines{get;set;}
    public Boolean boolUk{get;set;}
    public Boolean tradingAddAcc{get;set;}
    public boolean msgTotalOwnerShip {get;set;}
    public Boolean errorLastName{get;set;}
    Boolean blnResidencyStatus = false;
    boolean blnOccupiedStatus = false;
    boolean blnOccupiedStatusCompleted = false;
    boolean blnTrading = false;
    boolean blnTradingCompleted = false;
    boolean blndebtType = false;
    boolean blndebtTypeCompleted = false;
    boolean blnPremise = false;
    boolean blnPremiseCompleted = false;
    boolean blnBusinessDebt = false;
    boolean blnBusinessDebtCompleted = false;
    boolean blnSig = false;
    boolean blnODGAddDebt = false;
    boolean blnODGAddDebtCompleted = false;
    public boolean blnPersonBirthdate {get;set;}
    public Opportunity objOpportunity{get;set;}
    public Account accountInfo {get;set;}
    public list<Account> lstPersonAccountToInsert;
    public list<Account> lstPersonAccountToUpdate;
    public list<ownerDetails> lstWrapperToDisplay{get;set;}
    public list<debtDetails> lstDebt{get;set;}
    public list<premiseInfo> lstPremise {get;set;}
    public map<Id,Account> mapPremiseId_PremiseToDelete = new map<Id,Account>();
    public map<Id,Guarantors__c> mapGuarantorId_GuarantorToDelete = new map<Id,Guarantors__c>();
    public map<Id,Additional_Debt__c> mapDebtId_DebtToDelete = new map<Id,Additional_Debt__c>();
    public map<String, Id> mapPerson_Id;
    public map<String, Id> mapPremise_Id;
    map<Id, Id> mapAccountId_GuarantorId = new map<Id,Id>();
    map<Id, String> mapGuarantor_Consent = new map<Id,String>();
    map<Id, boolean> mapGuarantor_Signatory = new map<Id,boolean>();
    public static final Integer CONST_EIGHTEEN = 18;
    public static final Integer CONST_ZERO = 0;
    public static final String CONST_NONE = '--None--';
    public static final String CONST_UK = 'UK';
    public static final String CONST_HK = 'Hong Kong';
    public static final String CONST_SG = 'Singapore';
    public static final String CONST_PP = 'Philippines';
    public static final String CONST_MR = 'Mr.';
    public static final String CONST_SIR = 'Sir.';
    public static final String CONST_DR = 'Dr.';
    public static final String CONST_MALE = 'Male';
    public static final String CONST_FEMALE = 'Female';
    public static final String CONST_SELFOWNED = 'Self-Owned';
    public static final String CONST_RENTED = 'Rented';
    public static final String CONST_MORTGAGED = 'Mortgaged';
    public static final String CONST_OTHER = 'Other';
    public static final String CONST_NONSGRESIDENT = 'Non-Singapore Resident';
    public static final String CONST_NONPPRESIDENT = 'Non-Philippines Resident';
    public static final String CONST_NONHKRESIDENT = 'Non-HK Resident';
    public static final String CONST_NONPERMANENTRESIDENT = 'Non-Permanent Resident';
    public static final String CONST_PERMANENTRESIDENT = 'Permanent Resident';
    public static final String CONST_YES = 'Yes';
    public static final String CONST_NO = 'No';
    public static final String CONST_HONG = 'Hong';
    public static final String CONST_PENDINGSIGNATURE = 'Pending Signature';
    public static final String CONST_PERSON = 'Person';
    public static final String CONST_PREMISE = 'Premise';
    public static final String CONST_ACCOUNT = 'Account';
    public static final String CONST_PRESONUK = 'Person_UK';
    public static final String CONST_PERSONHONGKONG = 'Person_Hong_Kong';
    public static final String CONST_PERSONPHILIPPINES = 'Person_Philippines';
    public static final String CONST_PERSONSINGAPORE = 'Person_Singapore';
    public static final String CONST_HONGKONG = 'Hong_Kong';
    public static final String CONST_SINGAPOREAN = 'Singaporean';
    public static final String CONST_SINGAPOREPERMANENTRESIDENT = 'Singapore Permanent Resident';
    public static final String CONST_SINGAPOREFOREIGNERWITHPASS = 'Foreigner with Employment Pass';
    public static final String CONST_SINGAPOREFOREIGNERWITHOUTPASS = 'Foreigner without Employment Pass';
    public static final String CONST_CITIZEN = 'Citizen';
    public static final String CONST_PERMANENTRESIDENTALIEN = 'Permanent Resident Alien';
    
    public String selectedBankVal{get;set;}     
    public List<Bank_Detail__c> banks {get;set;}
    
    
    public CRMS_UKApplicationFormExtension (ApexPages.StandardController controller) 
    {   
        initializeData(controller.getId());
    } // end of CRMS_UKApplicationFormExtension constructor
    
    // Method used to set value to all variables when Application Form is loaded
    public void initializeData(Id OppId)
    {
        list<Opportunity> lstOpp = new list<Opportunity>();
        list<Account> lstAccount = new list<Account>();
        list<Account> lstPersonAccount = new list<Account>();
        list<Guarantors__c> lstG = new list<Guarantors__c>();
        premiseRowCount = 0;
        rowODGCount = 0;
        debtIndex = 0;
        oppIdToRedirectPage = OppId;
        boolHongkong = false;
        boolSingapore = false;
        boolPhilippines = false;
        boolUk = false;
        boolFinanceBlock = false;
        boolRelationShip = false;
        blnSelfOwned = false;
        blnRented = false;
        blnMorgaged = false;
        blnOthers = false;
        blnException = false;
        blnPersonBirthdate = true;
        mapPerson_Id = new map<String, Id>();
       
        lstWrapperToDisplay = new list<ownerDetails>();
        lstDebt = new list<debtDetails>();
        lstPremise = new list<premiseInfo>();
        String strSetRecordType;
        lstPersonAccountToInsert = new list<Account>();
        
        lstOpp = [select Id, Amount, Loan_purpose__c, Country__c, Agreed_that_no_Relationship_Exists__c,
                  AccountId,Has_any_Relationship_with_AMP_Directors__c , RecordtypeId, Primary_Contact__c,
                  Job_Title__c,RecType_Name__c,Person_Account__c, Requested_Loan_Term__c,StageName,
                  Relationship_to_the_Applicant__c ,Landlord_Contact_Details__c , Name_of_AMP_personnel__c,
                  Average_Monthly_Card_Sales__c, Ave_Monthly_Sales__c, Monthly_Rental__c,Number_of_Employees__c,Number_of_Outlets__c
                  from Opportunity where Id =: oppIdToRedirectPage limit 1];
        
        lstG = [Select g.Opportunity__c, g.Id, g.Account__c, g.Consent_to_Search__c, g.CreatedDate,
                g.Account_Role__c, g.Required_Bank_Signatory__c 
                From Guarantors__c g
                where g.Opportunity__c =: oppIdToRedirectPage 
                order by CreatedDate];
        
        map<String,boolean> mapExistingODG = new map<String,boolean>();
        set<Id> setPersonId = new set<Id>();
        for(Guarantors__c objG : lstG)
        {
            if(objG.Account__c != null)
            {
                setPersonId.add(objG.Account__c);
                mapGuarantor_Consent.put(objG.Account__c, objG.Consent_to_Search__c);
                mapGuarantor_Signatory.put(objG.Account__c, objG.Required_Bank_Signatory__c);
                mapAccountId_GuarantorId.put(objG.Account__c, objG.Id);
            }
        }
        
        objOpportunity = lstOpp[0];
        objOpportunity.RecordtypeId = lstOpp[0].RecordtypeId;
        if(lstOpp.size() > 0 && !lstOpp.isEmpty())
        {
            for(Opportunity objOpp : lstOpp)
            {
                accountId = objOpp.AccountId;
                if(objOpp.Country__c == CONST_HK)
                {
                    boolHongkong = true;
                    strCountry = CONST_HK;
                }
                else if(objOpp.Country__c == CONST_PP)
                {
                    boolPhilippines = true;
                    strCountry = CONST_PP;
                }
                else if(objOpp.Country__c == CONST_SG)
                {
                    boolSingapore = true;
                    strCountry = CONST_SG;
                }
                else
                {
                    boolUk = true;
                    strCountry = CONST_UK;
                }    
                
                if(objOpp.RecType_Name__c.contains(CONST_UK))
                    strSetRecordType = CONST_PRESONUK;
                
                else if(objOpp.RecType_Name__c.contains(CONST_HONGKONG))
                    strSetRecordType = CONST_PERSONHONGKONG;
                
                else if(objOpp.RecType_Name__c.contains(CONST_PP))
                    strSetRecordType = CONST_PERSONPHILIPPINES;
                
                else
                    strSetRecordType = CONST_PERSONSINGAPORE;
                
                disableBlock();
            }// end of Opportunity for loop 
        } // end of lstOpp.size() >0
        
        list<RecordType> lstR = [Select r.SobjectType, r.Name, r.IsActive, r.Id, r.DeveloperName
                                From RecordType r
                                where  r.SobjectType = 'Account'
                                and (r.DeveloperName like 'Person%'
                                or r.DeveloperName like 'Premise%')];
        
        list<Additional_Debt__c> lstBusinessAD = [Select a.Outstanding_Amount__c, a.Opportunity__c, a.Original_Debt_Amount__c, a.Monthly_Repayment__c,
                                                 a.Legal_Entity__c, a.Id, a.Debt_Type__c, a.Civil_Litigation__c, a.Account__c ,
                                                 a.CreatedDate
                                                 From Additional_Debt__c a
                                                 where a.Account__c =: accountId AND Opportunity__c =:oppIdToRedirectPage
                                                 order by CreatedDate];
        
        if(lstBusinessAD != null && !lstBusinessAD.isEmpty())
        {
            for(Additional_Debt__c objAD : lstBusinessAD)
            {
                lstDebt.add(new debtDetails(objAD, false, true));
                debtRowCount ++;
            }   
        }else{
        	        	
	        Additional_Debt__c objDebt = new Additional_Debt__c();
	        objDebt.Account__c = accountId;
	        objDebt.Opportunity__c = oppIdToRedirectPage;
	        lstDebt.add(new debtDetails(objDebt, true, false));
        }
        
        mapPerson_Id = new map<String, Id>();
        mapPremise_Id = new map<String, Id>();
        for(RecordType objR : lstR)
        {
            if(objR.DeveloperName.contains(CONST_PERSON) && objR.DeveloperName.contains(CONST_UK))
            {
                mapPerson_Id.put(CONST_UK , objR.Id);
            }
            if(objR.DeveloperName.contains(CONST_PERSON) && objR.DeveloperName.contains(CONST_HONG))
            {
                mapPerson_Id.put(CONST_HK , objR.Id);
            }
            if(objR.DeveloperName.contains(CONST_PERSON) && objR.DeveloperName.contains(CONST_PP))
            {
                mapPerson_Id.put(CONST_PP , objR.Id);
            }
            if(objR.DeveloperName.contains(CONST_PERSON) && objR.DeveloperName.contains(CONST_SG))
            {
                mapPerson_Id.put(CONST_SG , objR.Id);
            }
            if(objR.DeveloperName.contains(CONST_PREMISE) && objR.DeveloperName.contains(CONST_UK))
            {
                mapPremise_Id.put(CONST_UK , objR.Id);
            }
            if(objR.DeveloperName.contains(CONST_PREMISE) && objR.DeveloperName.contains(CONST_HONG))
            {
                mapPremise_Id.put(CONST_HK , objR.Id);
            }
            if(objR.DeveloperName.contains(CONST_PREMISE) && objR.DeveloperName.contains(CONST_PP))
            {
                mapPremise_Id.put(CONST_PP , objR.Id);
            }
            if(objR.DeveloperName.contains(CONST_PREMISE) && objR.DeveloperName.contains(CONST_SG))
            {
                mapPremise_Id.put(CONST_SG , objR.Id);
            }
        }
        
        list<Account> lstPremiseAccount = [Select a.ParentId, a.Name, a.Id, a.Business_Rates__c, a.isPersonAccount,
                                            a.TA_Address_Line_2__c, a.TA_Address_Line_3__c , a.TA_Building_Name__c,
                                             a.TA_Country__c, a.TA_District__c, a.TA_Floor_No__c,a.TA_City_Lookup__c,
                                            a.TA_Postcode__c, a.TA_Region__c, a.TA_Sub_Region__c, a.TA_Street_Name__c, a.TA_Street_Number__c,
                                            a.Trading_Address_if_different__c, a.CreatedDate
                                            From Account a
                                            where a.ParentId = : accountId
                                            order by CreatedDate];
                                            //a.TA_City__c,
        if(lstPremiseAccount != null && !lstPremiseAccount.isEmpty())
        {
            for(Account objAccount : lstPremiseAccount)
            {
                lstPremise.add(new premiseInfo(objAccount, true));
                premiseRowCount++;
            }
        }
        // Removed from Layout therefore Removed from Query:
        // 
        // Was_AMP_client_before__pc,
        
        lstPersonAccount = [select FirstName,LastName,Salutation__pc,Salutation,Business_Position__pc,
                            Percentage_of_the_Company_Ownership__pc, Additional_Business_Owner_Information__pc,
                            National_Insurance_Number__pc,Driver_Licence_Number__pc,
                            Property_Ownership__pc, Other_Operating_Costs__c, Time_in_Country__c,
                            PersonMobilePhone,PersonHomePhone,PersonEmail,
                            Consent_to_search__pc,PersonBirthdate ,Original_Debt_Amount__c,
                            Education_Level__pc,HKID_card_no__pc,Any_Dependents__pc,Business_Legal_Name__c,
                            Debt_type__pc, Civil_Litigation__pc, Outstanding_amount__pc, isPersonAccount ,
                            Monthly_repayment__pc, Lending_Entity__pc, Home_Address_Line_2__pc,
                            Home_Address_Line_3__pc,Home_Building_Name__pc,Passport_Number__pc,
                            Home_Country__pc,Home_District__pc,Home_Floor_No__pc,Home_City_Lookup__pc,Home_Postcode__pc,
                            Home_Region__pc,Home_Sub_Region__pc,Home_Street_Name__pc,Home_Street_Number__pc,Valid_ID__pc,Other_ID__pc,NRIC_Number__pc,
                            Gender__pc,Type_Of_Residential_Property__pc,Associated_Business__c,ECR__pc,
                            Marital_Status__pc, Time_at_this_Address_Months__c, Business_Rates__c,
                            Required_Bank_Signatory__c, Recordtype.DeveloperName, CreatedDate, LastModifiedDate,
                            Residency_Status__pc,Passport_County_of_issues__pc,Passport_Expiry_Date__pc,
                            (Select Id, Legal_Entity__c, Debt_Type__c, Original_Debt_Amount__c, CreatedDate,
                            Monthly_Repayment__c, Outstanding_Amount__c, Civil_Litigation__c, Account__c,Opportunity__c 
                            From Additional_Debts__r where Opportunity__c =:oppIdToRedirectPage
                            order by CreatedDate)
                            From Account
                            where isPersonAccount = true
                            and Id IN :setPersonId
                            order by CreatedDate];
                            //Home_City__pc,
        if(lstPersonAccount.size() > 0 && !lstPersonAccount.isEmpty())
        {
            setUpExistingPersonAccount(lstPersonAccount);
            directorBlockStatus();
        }
        // Else portion added for resolution of JIRA SPT-253
        else
        {
            // Removed from Layout therefore Removed from Query:
            // 
            // Was_AMP_client_before__pc,
            
            lstPersonAccount = [select FirstName,LastName,Salutation__pc,Salutation,Business_Position__pc,
                                Percentage_of_the_Company_Ownership__pc, Additional_Business_Owner_Information__pc,
                                National_Insurance_Number__pc,Driver_Licence_Number__pc,
                                Property_Ownership__pc, Other_Operating_Costs__c, Time_in_Country__c,
                                PersonMobilePhone,PersonHomePhone,PersonEmail,
                                Consent_to_search__pc,PersonBirthdate ,Original_Debt_Amount__c,
                                Education_Level__pc,HKID_card_no__pc,Any_Dependents__pc,Business_Legal_Name__c,
                                Debt_type__pc, Civil_Litigation__pc, Outstanding_amount__pc, isPersonAccount ,
                                Monthly_repayment__pc, Lending_Entity__pc, Home_Address_Line_2__pc,
                                Home_Address_Line_3__pc,Home_Building_Name__pc,Passport_Number__pc,
                                Home_Country__pc,Home_District__pc,Home_Floor_No__pc,Home_City_Lookup__pc,Home_Postcode__pc,
                                Home_Region__pc,Home_Sub_Region__pc,Home_Street_Name__pc,Home_Street_Number__pc,Valid_ID__pc,Other_ID__pc,NRIC_Number__pc,
                                Gender__pc,Type_Of_Residential_Property__pc,Associated_Business__c,ECR__pc,
                                Marital_Status__pc, Time_at_this_Address_Months__c, Business_Rates__c,
                                Required_Bank_Signatory__c, Recordtype.DeveloperName, CreatedDate, LastModifiedDate,
                                Residency_Status__pc,Passport_County_of_issues__pc,Passport_Expiry_Date__pc,
                                (Select Id, Legal_Entity__c, Debt_Type__c, Original_Debt_Amount__c, CreatedDate,
                                Monthly_Repayment__c, Outstanding_Amount__c, Civil_Litigation__c, Account__c,Opportunity__c 
                                From Additional_Debts__r where Opportunity__c =:oppIdToRedirectPage
                                order by CreatedDate)
                                From Account
                                where isPersonAccount = true and 
                                Associated_Business__c =: accountId];
            //Home_City__pc,
            if(lstPersonAccount.size() > 0 && !lstPersonAccount.isEmpty())
            {
                setUpExistingPersonAccount(lstPersonAccount);
                directorBlockStatus();
            }
        }
        
        objOpportunity.Application_Form_Completed__c = false;
        objOpportunity.StageName = 'In Progress';
        
        /*
        * These fields are removed from application form layout, So no need to Query
        
            a.Rental_Security_Deposit__c,           
            a.Months_Left_on_the_Lease__c,
            a.Paid_for_the_Month_Of__c,
            a.Paid_for_the_amount_of__c,
            a.Number_of_Months_in_Arrears_if_any__c 
            
        */
        
        
        lstAccount = [Select a.Id,a.AccountNumber,a.Website,a.Phone, a.Sic, a.Type_Of_Premises__c,
                      a.Type, a.Business_Legal_Name__c, a.Total_Monthly_Sales__c, a.RecordtypeId,
                      a.Self_Owned_Rented__c, 
                      a.Property_Owner_Contact_Number__c,
                      a.Outstanding_Debt_Amount__c, a.Name, a.LastName, a.FirstName, 
                      a.Monthly_Repayment__c, a.Monthly_Rent__c, a.Legal_Entity__c,
                      a.Entity_Type__c, a.Debt_Type__c, a.Civil_Litigation__c, a.Business_Premise_Owner__c,
                      a.IsPersonAccount,a.Monthly_Mortgage_Payments__c,
                      a.Landlord_Name__c, a.Other_Operating_Costs__c,
                      a.Average_Monthly_Card_Sales_Volume__c, a.Total_No_Of_Staff__c,a.Total_Staff_Cost__c,
                      a.Operating_Days_Per_Week__c,a.Operating_Hours_Per_Day__c,
                      a.PersonBirthdate,a.Bank_Account_Holder_Name__c,
                      a.Property_Owner_First_Name__c,a.Property_Owner_Last_Name__c,a.Business_Email_Address__c,
                      a.Fax,a.Business_Nature__c,a.Original_Debt_Amount__c,a.LE_Address_Line_2__c,
                      a.LE_Address_Line_3__c,a.LE_Building_Name__c,a.LE_Country__c,
                      a.LE_District__c,a.LE_Floor_No__c,a.LE_Postcode__c,a.LE_Region__c,
                      a.Business_Nature_Category__c , a.Recordtype.DeveloperName,
                      a.LE_Street_Name__c,a.LE_Street_Number__c,a.TA_Address_Line_2__c,
                      a.TA_Address_Line_3__c,a.TA_Building_Name__c,a.TA_Country__c,
                      a.TA_District__c,a.TA_Floor_No__c,a.TA_Postcode__c,a.TA_Region__c,
                      a.TA_Street_Number__c,a.TA_Street_Name__c,a.Trading_Address_if_Different__c,
                      a.Bank_Address_Line_1__c,a.Bank_Address_Line_2__c,
                      a.Landlord_Tel_No__c, a.Years_in_Business__c ,a.Business_Nature_Type__c,
                      a.Associated_Business__c, a.Bank_Account_Number__c,
                      a.Time_at_this_Address_Months__c, a.Bank_Address_Postcode__c, a.Business_Rates__c,
                      a.Required_Bank_Signatory__c,
                      a.TA_Sub_Region__c,a.LE_Sub_Region__c,a.Bank_Address_Country__c,a.Bank_Address_Floor_Number__c,
                      a.Bank_Address_Region__c, a.Bank_Address_Sub_Region__c,a.Bank_Address_Building_Name__c,
                      a.Bank_Address_Street_Number__c, a.Bank_Address_Street_Name__c,
                      a.Bank_Address_City_Lookup__c,a.LE_City_Lookup__c,a.TA_City_Lookup__c,
                      a.Bank_Name_Lookup__c,a.Bank_No__c,a.Bank_Account_Sort_Code__c,a.Bank_Address_District__c,a.Bank_Branch_No__c
                      From Account a where a.Id =: accountId ];
                      //a.Bank_Address_City__c,a.LE_City__c,a.TA_City__c,,a.Bank_Name__c,
        if(lstAccount.size() > 0 && !lstAccount.isEmpty())
        {
            accountInfo  = lstAccount[0];            
            //selectedBankVal = accountInfo.Bank_Name__c;
            if(accountInfo.Trading_Address_if_Different__c == true)
            {
                tradingAddAcc = true;
                tradingAddressAutoPopulate();
            }
            else
            {
                tradingAddAcc =false;
            }
            
            if(accountInfo.IsPersonAccount == true)
            {
                if(accountInfo.FirstName != null)
                {
                    bussinesslegalAcc = accountInfo.FirstName + accountInfo.LastName;
                }
                else
                {
                    bussinesslegalAcc = accountInfo.LastName;
                }
                occupiedStatus();
                financeBlockStatus();
            }
            else
            {
                bussinesslegalAcc = accountInfo.Name;
                occupiedStatus();
                financeBlockStatus();
            }
            
        } // end of lstAccount > 0
    } // end of initializeData method
    
    public void setUpExistingPersonAccount(list<Account> lstPersonAccount) {
        for(Account objAccPer : lstPersonAccount)
        {                       
            if(objAccPer.Id == objOpportunity.Primary_Contact__c) {
                Guarantors__c objG = new Guarantors__c ();
                boolean primary = true;
                
                if(objAccPer.Salutation == CONST_MR
                || objAccPer.Salutation == CONST_SIR
                || objAccPer.Salutation == CONST_DR)
                {
                    objAccPer.Gender__pc = CONST_MALE;
                }
                else
                {
                    objAccPer.Gender__pc = CONST_FEMALE;
                }
                if(mapGuarantor_Consent.get(objAccPer.Id) != null)
                {
                    objAccPer.Consent_to_search__pc = mapGuarantor_Consent.get(objAccPer.Id);
                }
                if(mapGuarantor_Signatory.get(objAccPer.Id) != null)
                {
                    objAccPer.Required_Bank_Signatory__c = mapGuarantor_Signatory.get(objAccPer.Id);
                }
                list<debtDetails> lstD = new list<debtDetails>();
                debtRowCount = 0;
                for(Additional_Debt__c objDt : objAccPer.Additional_Debts__r)
                {
                    lstD.add(new debtDetails(objDt, true, true));
                    debtRowCount++;
                }
                
                if(lstD.isEmpty() && lstD.size() <=0){
                	Additional_Debt__c objDebt = new Additional_Debt__c();
			        objDebt.Account__c = objAccPer.Id;			        
			        lstD.add(new debtDetails(objDebt, true, true));
                }
                
                lstWrapperToDisplay.add(new ownerDetails(objAccPer, objOpportunity, objG, primary, true, true, lstD));
                rowCount++;
            }
        }
        for(Account objAccPer : lstPersonAccount)
        {
            if(objAccPer.Id != objOpportunity.Primary_Contact__c) {
                Guarantors__c objG = new Guarantors__c ();
                boolean primary = false;
                if(objAccPer.Salutation == CONST_MR
                || objAccPer.Salutation == CONST_SIR
                || objAccPer.Salutation == CONST_DR)
                {
                    objAccPer.Gender__pc = CONST_MALE;
                }
                else
                {
                    objAccPer.Gender__pc = CONST_FEMALE;
                }
                if(mapGuarantor_Consent.get(objAccPer.Id) != null)
                {
                    objAccPer.Consent_to_search__pc = mapGuarantor_Consent.get(objAccPer.Id);
                }
                if(mapGuarantor_Signatory.get(objAccPer.Id) != null)
                {
                    objAccPer.Required_Bank_Signatory__c = mapGuarantor_Signatory.get(objAccPer.Id);
                }
                list<debtDetails> lstD = new list<debtDetails>();
                debtRowCount = 0;
                for(Additional_Debt__c objDt : objAccPer.Additional_Debts__r)
                {
                    lstD.add(new debtDetails(objDt, true, true));
                    debtRowCount++;
                }
                
                if(lstD.isEmpty() && lstD.size() <=0){
                	Additional_Debt__c objDebt = new Additional_Debt__c();
			        objDebt.Account__c = objAccPer.Id;			        
			        lstD.add(new debtDetails(objDebt, true, true));
                }
                
                lstWrapperToDisplay.add(new ownerDetails(objAccPer, objOpportunity, objG, primary, true, true, lstD));
                rowCount++;
            }
        }
    }
    
    public List<SelectOption> getBankOptions(){
        String c;
        boolean isBankCode = false;
        
        if(strCountry == CONST_UK) c = 'UK';
        else if(strCountry == CONST_PP) c = 'PH';        
        else if(strCountry == CONST_SG) {c = 'SG'; isBankCode=true;}
        else if(strCountry == CONST_HK) {c = 'HK'; isBankCode=true;}
        
        List<SelectOption> optns = new List<SelectOption>();
        List<Bank_Detail__c> bankList = new List<Bank_Detail__c>();
        bankList = [Select id,Name,Bank_Code__c From Bank_Detail__c Where Country__c = :c and Country__c != null order by name ];       
        optns.add(new SelectOption(' ','--None--'));
        for(Bank_Detail__c b : bankList){
           if( !isBankCode)
                optns.add(new selectOption(b.Name, b.Name));
           else
                optns.add(new selectOption(b.Name+'-'+b.Bank_Code__c, b.Name+'-'+b.Bank_Code__c));
        }            
        return optns;
    }
    // Method to toggle Gender based on Salutation
    public void salutationChange()
    {
        if(lstWrapperToDisplay[rowODGCount].objAcc.Salutation__pc == CONST_MR
        || lstWrapperToDisplay[rowODGCount].objAcc.Salutation__pc == CONST_DR
        || lstWrapperToDisplay[rowODGCount].objAcc.Salutation__pc == CONST_SIR)
        {
            lstWrapperToDisplay[rowODGCount].objAcc.Gender__pc = CONST_MALE;
        }
        else
        {
            lstWrapperToDisplay[rowODGCount].objAcc.Gender__pc = CONST_FEMALE;
        }
    } // end of salutationChange
    
    // Method to toggle "Relationship With Director / Employee Of AMP" section
    public void disableBlock()
    {
        if(objOpportunity.Has_any_Relationship_with_AMP_Directors__c == CONST_YES)
        {
            boolRelationShip = false;
            objOpportunity.Agreed_that_no_Relationship_Exists__c = false;
        }
        else if(objOpportunity.Has_any_Relationship_with_AMP_Directors__c == CONST_NO)
        {
            boolRelationShip = true;
            objOpportunity.Name_of_AMP_Personnel__c = null;
            objOpportunity.Job_Title__c = null;
            objOpportunity.Relationship_to_the_Applicant__c = null;
            objOpportunity.Agreed_that_no_Relationship_Exists__c = true;
        }
        else
        {
            boolRelationShip = true;
            objOpportunity.Name_of_AMP_Personnel__c = null;
            objOpportunity.Job_Title__c = null;
            objOpportunity.Relationship_to_the_Applicant__c = null;
            objOpportunity.Agreed_that_no_Relationship_Exists__c = true;
        }
    } //end of disableBlock method
    
    // Method to toggle Trading Address details
    public void tradingAddressAutoPopulate()
    {
        if(tradingAddAcc == true)
        {
            tradingSet = true;
        }
        else
        {
            tradingSet = false;
        }
    } // end of tradingAddressAutoPopulate method
     
    //Method to toggle "Business Premises Information" section
    public void occupiedStatus()
    {
        if(accountInfo.Self_Owned_Rented__c == CONST_SELFOWNED)
        {
            blnSelfOwned = true;
            blnRented = false;
            blnMorgaged = false;
            blnOthers = false;
            
            /*
            * These fields are removed from application form layout.
            
            accountInfo.Rental_Security_Deposit__c = null;
            accountInfo.Months_Left_on_the_Lease__c = null;
            accountInfo.Paid_for_the_Month_of__c = null;
            accountInfo.Paid_for_the_Amount_of__c = null;
            accountInfo.Number_of_Months_in_Arrears_if_any__c = null;
            
            */
            accountInfo.Monthly_Mortgage_Payments__c = null;
        }
        if(accountInfo.Self_Owned_Rented__c == CONST_RENTED)
        {
            blnSelfOwned = false;
            blnRented = true;
            blnMorgaged = false;
            blnOthers = false;
            accountInfo.Monthly_Mortgage_Payments__c = null;
        }
        if(accountInfo.Self_Owned_Rented__c == CONST_MORTGAGED)
        {
            blnSelfOwned = false;
            blnRented = false;
            blnMorgaged = true;
            blnOthers = false;
            
            /*
            * These fields are removed from application form layout.
            
            accountInfo.Rental_Security_Deposit__c = null;
            accountInfo.Months_Left_on_the_Lease__c = null;
            accountInfo.Paid_for_the_Month_of__c = null;
            accountInfo.Paid_for_the_Amount_of__c = null;
            accountInfo.Number_of_Months_in_Arrears_if_any__c = null;
           */
        }
        if(accountInfo.Self_Owned_Rented__c == CONST_OTHER)
        {
            blnSelfOwned = false;
            blnRented = false;
            blnMorgaged = false;
            blnOthers = true;
            
            /*
            * These fields are removed from application form layout.
            
            accountInfo.Rental_Security_Deposit__c = null;
            accountInfo.Months_Left_on_the_Lease__c = null;
            accountInfo.Paid_for_the_Month_of__c = null;
            accountInfo.Paid_for_the_Amount_of__c = null;
            accountInfo.Number_of_Months_in_Arrears_if_any__c = null;
            */
            accountInfo.Monthly_Mortgage_Payments__c = null;
        }
        if(accountInfo.Self_Owned_Rented__c == null)
        {
            blnSelfOwned = false;
            blnRented = false;
            blnMorgaged = false;
            blnOthers = false;
            accountInfo.Operating_Days_Per_Week__c = null;
            accountInfo.Operating_Hours_Per_Day__c = null;
            objOpportunity.Number_of_Employees__c = null;
            accountInfo.Total_Staff_Cost__c = null;
            accountInfo.Other_Operating_Costs__c = null;
            accountInfo.Time_at_this_Address_Months__c = null;
            
            /*
            * These fields are removed from application form layout.
            
            accountInfo.Rental_Security_Deposit__c = null;
            accountInfo.Months_Left_on_the_Lease__c = null;
            accountInfo.Paid_for_the_Month_of__c = null;
            accountInfo.Paid_for_the_Amount_of__c = null;
            accountInfo.Number_of_Months_in_Arrears_if_any__c = null;
            */
            accountInfo.Monthly_Mortgage_Payments__c = null;
        }
    } // end of occupiedStatus method
    
    public void residencyStatusChange()
    {
        if(lstWrapperToDisplay[rowODGCount].objAcc.Residency_Status__pc == CONST_PERMANENTRESIDENT
        && strCountry == CONST_HK)
        {
            lstWrapperToDisplay[rowODGCount].objAcc.Passport_Number__pc = null;
            lstWrapperToDisplay[rowODGCount].objAcc.Passport_County_of_issues__pc = null;
            lstWrapperToDisplay[rowODGCount].objAcc.Passport_Expiry_Date__pc = null;
            lstWrapperToDisplay[rowODGCount].objAcc.Time_in_Country__c = null;
        }
        else if(lstWrapperToDisplay[rowODGCount].objAcc.Residency_Status__pc == CONST_NONHKRESIDENT
        && strCountry == CONST_HK)
        {
            lstWrapperToDisplay[rowODGCount].objAcc.HKID_Card_No__pc = null;
        }
        else if((lstWrapperToDisplay[rowODGCount].objAcc.Residency_Status__pc == null
        || lstWrapperToDisplay[rowODGCount].objAcc.Residency_Status__pc == CONST_NONE)
        && strCountry == CONST_HK)
        {
            lstWrapperToDisplay[rowODGCount].objAcc.HKID_Card_No__pc = null;
            lstWrapperToDisplay[rowODGCount].objAcc.Passport_Number__pc = null;
            lstWrapperToDisplay[rowODGCount].objAcc.Passport_County_of_issues__pc = null;
            lstWrapperToDisplay[rowODGCount].objAcc.Passport_Expiry_Date__pc = null;
            lstWrapperToDisplay[rowODGCount].objAcc.Time_in_Country__c = null;
        }
        if(lstWrapperToDisplay[rowODGCount].objAcc.Residency_Status__pc == CONST_SINGAPOREAN
        && strCountry == CONST_SG)
        {
            lstWrapperToDisplay[rowODGCount].objAcc.Passport_Number__pc = null;
            lstWrapperToDisplay[rowODGCount].objAcc.Passport_County_of_issues__pc = null;
            lstWrapperToDisplay[rowODGCount].objAcc.Passport_Expiry_Date__pc = null;
            lstWrapperToDisplay[rowODGCount].objAcc.Time_in_Country__c = null;
        }
        else if(lstWrapperToDisplay[rowODGCount].objAcc.Residency_Status__pc == CONST_SINGAPOREPERMANENTRESIDENT
        || lstWrapperToDisplay[rowODGCount].objAcc.Residency_Status__pc == null
        || lstWrapperToDisplay[rowODGCount].objAcc.Residency_Status__pc == CONST_NONE
        && strCountry == CONST_SG)
        {
            lstWrapperToDisplay[rowODGCount].objAcc.NRIC_Number__pc = null;
            lstWrapperToDisplay[rowODGCount].objAcc.Passport_Number__pc = null;
            lstWrapperToDisplay[rowODGCount].objAcc.Passport_County_of_issues__pc = null;
            lstWrapperToDisplay[rowODGCount].objAcc.Passport_Expiry_Date__pc = null;
            lstWrapperToDisplay[rowODGCount].objAcc.Time_in_Country__c = null;
        }
        else if((lstWrapperToDisplay[rowODGCount].objAcc.Residency_Status__pc == CONST_SINGAPOREFOREIGNERWITHPASS
        || lstWrapperToDisplay[rowODGCount].objAcc.Residency_Status__pc == CONST_SINGAPOREFOREIGNERWITHOUTPASS)
        && strCountry == CONST_SG)
        {
            lstWrapperToDisplay[rowODGCount].objAcc.NRIC_Number__pc = null;
        }
        else if((lstWrapperToDisplay[rowODGCount].objAcc.Residency_Status__pc == CONST_CITIZEN)
        && strCountry == CONST_PP)
        {
            lstWrapperToDisplay[rowODGCount].objAcc.Other_ID__pc = null;
            lstWrapperToDisplay[rowODGCount].objAcc.ECR__pc = null;
        }
        else if((lstWrapperToDisplay[rowODGCount].objAcc.Residency_Status__pc == CONST_PERMANENTRESIDENTALIEN)
        && strCountry == CONST_PP)
        {
            lstWrapperToDisplay[rowODGCount].objAcc.Valid_ID__pc = null;
        }
    }
    
    // Method to toggle "Business Financial Disclosure" section
    public void financeBlockStatus()
    {
        if(accountInfo.Debt_Type__c != null)
        {
            boolFinanceBlock = true;
        }
        else
        {
            accountInfo.Original_Debt_Amount__c = 0;
            accountInfo.Monthly_Repayment__c = 0;
            accountInfo.Outstanding_Debt_Amount__c = 0;
            accountInfo.Civil_Litigation__c = null;
            boolFinanceBlock = false;
        }
    } // end of financeBlockStatus method
    
    // Method to toggle "Additional Business Financial Disclosure" section
    public void addDebtDisclosure()
    {
        for(debtDetails objD : lstDebt) 
        {
            if(objD.objDebt.Debt_Type__c != null
            && objD.objDebt.Debt_Type__c != CONST_NONE
            && objD.objDebt.Debt_Type__c != '')
            {
                objD.blnDisplay = true;
            }
            else
            {
                objD.objDebt.Original_Debt_Amount__c = 0;
                objD.objDebt.Monthly_Repayment__c = 0;
                objD.objDebt.Outstanding_Amount__c = 0;
                objD.objDebt.Civil_Litigation__c = null;
                objD.blnDisplay = false;
            } 
        }
    } // end of addDebtDisclosure method
    
    // Method to toggle "Additional Business Financial Disclosure" section
    public void addODGDebtDisclosure()
    {
        debtDetails objD = lstWrapperToDisplay[rowODGCount].lstODGDebt.get(debtIndex);
        if(objD.objDebt.Debt_Type__c != null
        && objD.objDebt.Debt_Type__c != CONST_NONE
        && objD.objDebt.Debt_Type__c != '')
        {
            objD.blnDisplay = true;
        }
        else
        {
            objD.objDebt.Original_Debt_Amount__c = 0;
            objD.objDebt.Monthly_Repayment__c = 0;
            objD.objDebt.Outstanding_Amount__c = 0;
            objD.objDebt.Civil_Litigation__c = null;
            objD.objDebt.Legal_Entity__c = null;
            objD.blnDisplay = false;
        }
    } // end of addDebtDisclosure method
    
    // Method to toggle "Owner/Director Financial Standing Disclosure" section
    public void directorBlockStatus()
    {
        for(ownerDetails objWrapper1 : lstWrapperToDisplay)
        {
            if(objWrapper1.objAcc.Debt_Type__pc != null 
            && objWrapper1.objAcc.Debt_Type__pc != CONST_NONE
            && objWrapper1.objAcc.Debt_Type__pc != '')
            {
                objWrapper1.blndisplayBlock = true;
            }
            else
            {
                objWrapper1.objAcc.Original_Debt_Amount__c = 0;
                objWrapper1.objAcc.Monthly_Repayment__pc = 0;
                objWrapper1.objAcc.Outstanding_Amount__pc = 0;
                objWrapper1.objAcc.Civil_Litigation__pc = null;
                objWrapper1.objAcc.Lending_Entity__pc = null;
                objWrapper1.blndisplayBlock = false;
            } 
        }
    } // end of directorBlockStatus method
    
    // Method to add new Debt information
    public void addDebt()
    {
        debtRowCount = lstDebt.size();
        Additional_Debt__c objDebt = new Additional_Debt__c();
        objDebt.Account__c = accountId;
        objDebt.Opportunity__c = oppIdToRedirectPage;
        lstDebt.add(new debtDetails(objDebt, true, false));
        debtRowCount ++;
    } // end of addDebt
    
    // Method to add remove Debt information
    public void removeDebt()
    {
        debtDetails objDt = lstDebt.get(deleteIndex);
        if(objDt.blnExisting)
        {
            mapDebtId_DebtToDelete.put(objDt.objDebt.Id,objDt.objDebt);
            //list<Additional_Debt__c> lstAD = [Select Id from Additional_Debt__c where Id =: objDt.objDebt.Id];
            //delete lstAD;
        }
        lstDebt.remove(deleteIndex);
        Integer intCounter = 0;
        for(debtDetails objDebt : lstDebt)
        {
            objDebt.counter = intCounter;
            intCounter ++;
        }
    }
    
    // method to add ODG additional Debt
    public void addODGDebt()
    {
        debtRowCount = lstWrapperToDisplay[rowODGCount].lstODGDebt.size();
        Additional_Debt__c objDebt = new Additional_Debt__c();
        lstWrapperToDisplay[rowODGCount].lstODGDebt.add(new debtDetails(objDebt, false, false));
        debtRowCount ++;
    } // end of addODGDebt
    
    // method to remove ODG additional debt
    public void removeODGDebt()
    {
        debtDetails objDt = lstWrapperToDisplay[rowODGCount].lstODGDebt.get(deleteIndex);
        if(objDt.blnExisting)
        {
            mapDebtId_DebtToDelete.put(objDt.objDebt.Id,objDt.objDebt);
            //list<Additional_Debt__c> lstAD = [Select Id from Additional_Debt__c where Id =: objDt.objDebt.Id];
            //delete lstAD;
        }
        lstWrapperToDisplay[rowODGCount].lstODGDebt.remove(deleteIndex);
        Integer intCounter = 0;
        for(debtDetails objDebt : lstWrapperToDisplay[rowODGCount].lstODGDebt)
        {
            objDebt.counter = intCounter;
            intCounter ++;
        }
    } // end of removeODGDebt method
    
    // Method to add new Owner/Director/Guarantor information
    public void displayBlock()
    {
        rowCount = lstWrapperToDisplay.size();
        Account objAcc = new Account ();
        objAcc.RecordtypeId = mapPerson_Id.get(strCountry);
        objAcc.Associated_Business__c = accountId;
        Opportunity tempOpp = new Opportunity();
        tempOpp.Person_Account__c = null;
        Guarantors__c objG = new Guarantors__c();
        list<debtDetails> lstD = new list<debtDetails>();
        lstWrapperToDisplay.add(new ownerDetails(objAcc, tempOpp, objG, false, false, false, lstD));
        rowCount++;
    } // end of displayBlock method
    
    // Method to remove new Owner/Director/Guarantor information
    public void RemoveBlock()
    {
        ownerDetails ODGtoDelete = lstWrapperToDisplay.get(deleteIndex);
        lstWrapperToDisplay.remove(deleteIndex);
        if(ODGtoDelete.objGuarantor.Id != null)
        {
            mapGuarantorId_GuarantorToDelete.put(ODGtoDelete.objGuarantor.Id,ODGtoDelete.objGuarantor);
            //list<Guarantors__c> lstODGToDelete = [select Id from Guarantors__c where Id =: ODGtoDelete.objGuarantor.Id];
            //delete lstODGToDelete;
        }
        Integer intCounter = 0;
        for(ownerDetails objWrap : lstWrapperToDisplay)
        {
            objWrap.counter = intCounter;
            intCounter ++;
        }   
    } // end of RemoveBlock
    
    // Method to add new Premise information
    public void addPremise()
    {
        premiseRowCount = lstPremise.size();
        Account objAcc = new Account();
        objAcc.RecordtypeId = mapPremise_Id.get(strCountry);
        lstPremise.add(new premiseInfo(objAcc, false));
        premiseRowCount++;
    } // end of addPremise
    
    // Method to remove Premise information
    public void removePremise()
    {
        premiseInfo objPremise = lstPremise.get(deleteIndex);
        if(objPremise.blnExisting)
        {
            mapPremiseId_PremiseToDelete.put(objPremise.objAcc.Id,objPremise.objAcc);
            //list<Account> lstPremise = [Select Id from Account where Id =: objPremise.objAcc.Id];
            //delete lstPremise;
        }
        lstPremise.remove(deleteIndex);
        Integer intCounter = 0;
        for(premiseInfo objWrap : lstPremise)
        {
            objWrap.counter = intCounter;
            intCounter ++;
        }   
    } // end of removePremise
    
    // method to fetch existing Person Account details for ODG
    public void selectPersonAccount()
    {
        list<Id> lstPerson_Lookup = new list<Id>();
        for(ownerDetails objWrap : lstWrapperToDisplay)
        {
            lstPerson_Lookup.add(objWrap.objOpp.Person_Account__c);
            lkp = objWrap.objOpp.Person_Account__c;
        }
        
        // Removed from Layout therefore Removed from Query:
        // 
        // Was_AMP_client_before__pc,
        
        list<Account> lstSelectPersonAccount = [select FirstName,LastName,Salutation__pc,Salutation,Business_Position__pc,
                                                Percentage_of_the_Company_Ownership__pc, Additional_Business_Owner_Information__pc,
                                                National_Insurance_Number__pc,Driver_Licence_Number__pc,
                                                Property_Ownership__pc, Other_Operating_Costs__c, Time_in_Country__c,
                                                PersonMobilePhone,PersonHomePhone,PersonEmail,
                                                Consent_to_search__pc,PersonBirthdate ,Original_Debt_Amount__c,
                                                Education_Level__pc,HKID_card_no__pc,Any_Dependents__pc,Business_Legal_Name__c,
                                                Debt_type__pc, Civil_Litigation__pc, Outstanding_amount__pc, isPersonAccount ,
                                                Monthly_repayment__pc, Lending_Entity__pc, Home_Address_Line_2__pc,
                                                Home_Address_Line_3__pc,Home_Building_Name__pc,Passport_Number__pc,
                                                Home_Country__pc,Home_District__pc,Home_Floor_No__pc,Home_City_Lookup__pc,Home_Postcode__pc,
                                                Home_Region__pc,Home_Street_Name__pc,Home_Street_Number__pc,Valid_ID__pc,Other_ID__pc,NRIC_Number__pc,
                                                Gender__pc,Type_Of_Residential_Property__pc,Associated_Business__c,ECR__pc,
                                                Marital_Status__pc, Time_at_this_Address_Months__c, Business_Rates__c,
                                                Required_Bank_Signatory__c, Recordtype.DeveloperName, CreatedDate, LastModifiedDate,
                                                Residency_Status__pc,Passport_County_of_issues__pc,Passport_Expiry_Date__pc,
                                                (Select Id, Legal_Entity__c, Debt_Type__c, Original_Debt_Amount__c, CreatedDate,
                                                Monthly_Repayment__c, Outstanding_Amount__c, Civil_Litigation__c, Account__c, Opportunity__c 
                                                From Additional_Debts__r where Opportunity__r.StageName IN('In Progress','Pending Signature','Assessment In Progress','Application Revised')
                                                order by CreatedDate)
                                                From Account
                                                where isPersonAccount = true and  Id IN: lstPerson_Lookup];
                                                //Home_City__pc,
        for(Account objAccPerExist : lstSelectPersonAccount)
        {                        
            if(objAccPerExist.Salutation == CONST_MR
            || objAccPerExist.Salutation == CONST_SIR
            || objAccPerExist.Salutation == CONST_DR)
            {
                objAccPerExist.Gender__pc = CONST_MALE;
            }
            else
            {
                objAccPerExist.Gender__pc = CONST_FEMALE;
            }
            rowCount = lstWrapperToDisplay.size() - 1;
            list<debtDetails> lstD = new list<debtDetails>();
            boolean blnDebt = false;
            if(objAccPerExist.Debt_type__pc != null && objAccPerExist.Debt_type__pc != CONST_NONE)
            {
                blnDebt = true;
            }
            integer intC = 0;
            for(Additional_Debt__c objD : objAccPerExist.Additional_Debts__r)
            {
                Additional_Debt__c CloneDebt = new Additional_Debt__c(
                	Legal_Entity__c = objD.Legal_Entity__c, 
                	Debt_Type__c = objD.Debt_Type__c, 
                	Original_Debt_Amount__c = objD.Original_Debt_Amount__c,
                    Monthly_Repayment__c = objD.Monthly_Repayment__c, 
                    Outstanding_Amount__c = objD.Outstanding_Amount__c, 
                    Civil_Litigation__c = objD.Civil_Litigation__c, 
                    Account__c = objD.Account__c
                );
                lstD.add(new debtDetails(CloneDebt, true, true));
                intC++;
                debtRowCount++;
            }
            Guarantors__c objG = new Guarantors__c();
            lstWrapperToDisplay[lstWrapperToDisplay.size()-1]= new ownerDetails(objAccPerExist, objOpportunity, objG, false, blnDebt, true, lstD);
        }
        lkp = null;
    } // end of selectPersonAccount method
    
    // method to insert ODG information
    public void insertODG()
    {
        list<Guarantors__c> lstGuarantors_LookUp = new list<Guarantors__c>();
            
        for(ownerDetails objWrapLookUp : lstWrapperToDisplay)
        {
            Guarantors__c objGuarantor_LookUp;
            if(objWrapLookUp.objAcc.Id != null)
            {
                if(mapAccountId_GuarantorId.get(objWrapLookUp.objAcc.Id) != null)
                {
                    objGuarantor_LookUp = new Guarantors__c(Id = mapAccountId_GuarantorId.get(objWrapLookUp.objAcc.Id));
                }
                else
                {
                    objGuarantor_LookUp = new Guarantors__c();
                    objGuarantor_LookUp.Account__c = objWrapLookUp.objAcc.Id;
                    objGuarantor_LookUp.Opportunity__c = objOpportunity.Id;
                }
                objGuarantor_LookUp.Email__c = objWrapLookUp.objAcc.PersonEmail;
                objGuarantor_LookUp.Account_Role__c = objWrapLookUp.objAcc.Business_Position__pc;
                objGuarantor_LookUp.Required_Bank_Signatory__c = objWrapLookUp.objAcc.Required_Bank_Signatory__c;
                objGuarantor_LookUp.Consent_to_Search__c = objWrapLookUp.objAcc.Consent_to_Search__pc;
                lstGuarantors_LookUp.add(objGuarantor_LookUp);
            }
        }
        if(lstGuarantors_LookUp != null  && !lstGuarantors_LookUp.isEmpty())
        {
            database.upsertResult[] lstSave = database.upsert(lstGuarantors_LookUp, Guarantors__c.Fields.Id, false);
        }
    } // end of insertODG
    //method to check completeness of accountOpportunity Basic Info
    public boolean accountOpportunityBasicInfo_Completeness()
    {
        boolean blnTemp = false;
        if(objOpportunity.Amount != null  && objOpportunity.Amount > 0
        && objOpportunity.Loan_purpose__c != null && objOpportunity.Loan_purpose__c != CONST_NONE
        && objOpportunity.Requested_Loan_Term__c != null && objOpportunity.Requested_Loan_Term__c != CONST_NONE
        && accountInfo.AccountNumber != null && accountInfo.AccountNumber != ''
        && accountInfo.Entity_Type__c != null && accountInfo.Entity_Type__c != CONST_NONE
        && accountInfo.Phone != null && accountInfo.Phone != ''
        && accountInfo.Type_Of_Premises__c != null && accountInfo.Type_Of_Premises__c != CONST_NONE
        && accountInfo.LE_Street_Number__c != null && accountInfo.LE_Street_Number__c != ''
        && accountInfo.LE_Street_Name__c != null && accountInfo.LE_Street_Name__c != '' 
        && accountInfo.Business_Nature_Category__c != null && accountInfo.Business_Nature_Category__c != ''
        && accountInfo.Business_Nature_Type__c != null && accountInfo.Business_Nature_Type__c != ''
        //&& accountInfo.LE_Postcode__c != null && accountInfo.LE_Postcode__c != '' 
        && accountInfo.LE_Country__c != null && accountInfo.LE_Country__c != CONST_NONE
        && accountInfo.Years_in_Business__c != null && accountInfo.Years_in_Business__c != CONST_NONE
        && objopportunity.Average_Monthly_Card_Sales__c != null  && objopportunity.Average_Monthly_Card_Sales__c != 0.0
        && objopportunity.Ave_Monthly_Sales__c != null && objopportunity.Ave_Monthly_Sales__c != 0.0
        && accountInfo.Self_Owned_Rented__c != null && accountInfo.Self_Owned_Rented__c != CONST_NONE)
        {
            if(objopportunity.Country__c == CONST_UK)
            {
                if(accountInfo.Business_Rates__c != null && accountInfo.Business_Rates__c != 0
                && accountInfo.Business_Legal_Name__c != null && accountInfo.Business_Legal_Name__c != ''
                //&& accountInfo.LE_City_Lookup__c != null 
                && accountInfo.LE_Postcode__c != null && accountInfo.LE_Postcode__c != ''
                && objopportunity.Number_Of_Outlets__c != null && objopportunity.Number_Of_Outlets__c != CONST_NONE)
                {
                    blnTemp = true;
                }
            }//end of UK accountOpportunity Basic Info
            else if (objopportunity.Country__c == CONST_HK
            || objopportunity.Country__c == CONST_SG
            || objopportunity.Country__c == CONST_PP)
            {
                if(accountInfo.LE_District__c != null && accountInfo.LE_District__c != CONST_NONE
                && accountInfo.LE_Region__c != null && accountInfo.LE_Region__c != CONST_NONE)
                {
                    if((objopportunity.Country__c == CONST_SG || objopportunity.Country__c == CONST_PP)
                    && accountInfo.LE_Postcode__c != null && accountInfo.LE_Postcode__c != '')
                    {
                        blnTemp = true;
                    }
                    else
                    {
                        blnTemp = false;
                    }
                    if(objopportunity.Country__c == CONST_HK)
                    {
                        blnTemp = true;
                    }
                }
            }//end of Asian accountOpportunity Basic Info
            else
            {
                blnTemp = false;
            }
        }
        return blnTemp;
    } // end of accountOpportunityBasicInfo_Completeness

    // method to validate completeness of Trading Address
    public void tradingAddress_Completeness()
    {
        if(tradingAddAcc)
        {
            blnTrading = true;
            if(objopportunity.Country__c == CONST_UK)
            {
                if(accountInfo.TA_Street_Number__c != null && accountInfo.TA_Street_Number__c != ''
                && accountInfo.TA_Street_Name__c != null && accountInfo.TA_Street_Name__c != ''
                //&& accountInfo.TA_City_Lookup__c != null 
                && accountInfo.TA_Postcode__c != null && accountInfo.TA_Postcode__c != ''
                && accountInfo.TA_Country__c != null && accountInfo.TA_Country__c != CONST_NONE)
                {
                    blnTradingCompleted = true; 
                }
            }
            else if(objopportunity.Country__c == CONST_HK 
            || objopportunity.Country__c == CONST_PP 
            || objopportunity.Country__c == CONST_SG)
            {
                if(accountInfo.TA_Street_Number__c != null && accountInfo.TA_Street_Number__c != ''
                && accountInfo.TA_Street_Name__c != null && accountInfo.TA_Street_Name__c != ''
                && accountInfo.TA_Region__c != null && accountInfo.TA_Region__c != CONST_NONE
                && accountInfo.TA_District__c != null && accountInfo.TA_District__c != CONST_NONE
                //&& accountInfo.TA_Postcode__c != null && accountInfo.TA_Postcode__c != ''
                && accountInfo.TA_Country__c != null && accountInfo.TA_Country__c != CONST_NONE)
                {
                    if((objopportunity.Country__c == CONST_PP 
                    || objopportunity.Country__c == CONST_SG) 
                    && accountInfo.TA_Postcode__c != null && accountInfo.TA_Postcode__c != '')
                    {
                        blnTradingCompleted = true;
                    }
                    else
                    {
                        blnTradingCompleted = false;
                    }
                    if(objopportunity.Country__c == CONST_HK)
                    {
                        blnTradingCompleted = true;
                    } 
                }
            }
            else
                blnTradingCompleted = false;
        }
    } // end of tradingAddress_Completeness
    
    // method to validate completeness of Occupied Status if Self-Owned/Others
    public void accountOwnership_Others_Completeness()
    {
        blnOccupiedStatus = true;
        if(accountInfo.Operating_Days_Per_Week__c != null && accountInfo.Operating_Days_Per_Week__c !=  CONST_NONE
        && accountInfo.Operating_Hours_Per_Day__c != null && accountInfo.Operating_Hours_Per_Day__c != CONST_NONE
        && objOpportunity.Number_of_Employees__c != null && objOpportunity.Number_of_Employees__c != CONST_NONE
        && accountInfo.Total_Staff_Cost__c != null && accountInfo.Total_Staff_Cost__c != 0.0
        && accountInfo.Other_Operating_Costs__c != null 
        && accountInfo.Time_at_this_Address_Months__c != null && accountInfo.Time_at_this_Address_Months__c != CONST_NONE)
        {
            blnOccupiedStatusCompleted = true;
        }
    } // end of accountOwnership_Others_Completeness
    
    // method to validate completeness of Occupied Status if Mortgaged
    public void accountOwnership_Mortgage_Completeness()
    {
        blnOccupiedStatus = true;
        if(accountInfo.Monthly_Mortgage_Payments__c != null && accountInfo.Monthly_Mortgage_Payments__c != 0.0
        && accountInfo.Operating_Days_Per_Week__c != null && accountInfo.Operating_Days_Per_Week__c != CONST_NONE
        && accountInfo.Operating_Hours_Per_Day__c != CONST_NONE && accountInfo.Operating_Hours_Per_Day__c != null
        && objOpportunity.Number_of_Employees__c != null && objOpportunity.Number_of_Employees__c != CONST_NONE
        && accountInfo.Total_Staff_Cost__c != null && accountInfo.Total_Staff_Cost__c != 0.0
        && accountInfo.Other_Operating_Costs__c != null
        && accountInfo.Time_at_this_Address_Months__c != null && accountInfo.Time_at_this_Address_Months__c != CONST_NONE)
        {
            blnOccupiedStatusCompleted = true;
        }
    } // end of accountOwnership_Mortgage_Completeness
    
    // method to validate completeness of Occupied Status if Rented
    public void accountOwnership_Rented_Completeness()
    {
        /*
        * These fields are removed from application form layout.
        
            && accountInfo.Rental_Security_Deposit__c != null           
            && accountInfo.Months_Left_on_the_Lease__c != null
            && accountInfo.Paid_for_the_Month_Of__c != null
            && accountInfo.Paid_for_the_amount_of__c != null
            && accountInfo.Number_of_Months_in_Arrears_if_any__c != null 
            && accountInfo.Rental_Security_Deposit__c  != 0.0
            && accountInfo.Months_Left_on_the_Lease__c != CONST_NONE 
            && accountInfo.Paid_for_the_Month_Of__c != CONST_NONE
            && accountInfo.Paid_for_the_amount_of__c != 0.0
            && accountInfo.Number_of_Months_in_Arrears_if_any__c != CONST_NONE      
        */
        
        blnOccupiedStatus = true;
        if(objOpportunity.Monthly_Rental__c != null && objOpportunity.Monthly_Rental__c != 0.0
        && accountInfo.Operating_Days_Per_Week__c != null && accountInfo.Operating_Days_Per_Week__c != CONST_NONE
        && accountInfo.Operating_Hours_Per_Day__c != CONST_NONE && accountInfo.Operating_Hours_Per_Day__c != null
        && objOpportunity.Number_of_Employees__c != null && objOpportunity.Number_of_Employees__c != CONST_NONE
        && accountInfo.Total_Staff_Cost__c != null && accountInfo.Total_Staff_Cost__c != 0.0
        && accountInfo.Other_Operating_Costs__c != null
        && accountInfo.Time_at_this_Address_Months__c != null && accountInfo.Time_at_this_Address_Months__c != CONST_NONE         
        )
        {
            blnOccupiedStatusCompleted = true;
        }
    } // end of accountOwnership_Rented_Completeness
    
    // method to validate completeness of Account Debt type
    public void accountDebt_Completeness()
    {
        blndebtType = true;
        if(accountInfo.Original_Debt_Amount__c != null && accountInfo.Original_Debt_Amount__c != 0.0
        && accountInfo.Monthly_Repayment__c != null && accountInfo.Monthly_Repayment__c != 0.0
        && accountInfo.Outstanding_Debt_Amount__c != null && accountInfo.Outstanding_Debt_Amount__c != 0.0
        && accountInfo.Civil_Litigation__c != null
        && accountInfo.Civil_Litigation__c != CONST_NONE)
        {
            blndebtTypeCompleted = true;
        }
    } // end of accountDebt_Completeness
    
    // method to validate completeness of Account Premise
    public void premise_Completeness()
    {
        for(premiseInfo objPremise : lstPremise)
        {
            blnPremise = true;
            if(objopportunity.Country__c == CONST_UK)
            {
                if(objPremise.objAcc.Name != null
                //&& objPremise.objAcc.Business_Rates__c != null
                //&& objPremise.objAcc.Business_Rates__c > 0
                && objPremise.objAcc.TA_Street_Number__c != null
                && objPremise.objAcc.TA_Street_Name__c != null
                //&& objPremise.objAcc.TA_City_Lookup__c != null
                && objPremise.objAcc.TA_Postcode__c != null
                && objPremise.objAcc.TA_Country__c != null
                && objPremise.objAcc.TA_Country__c != CONST_NONE)
                {
                    blnPremiseCompleted = true;
                }
            }
            else if(objopportunity.Country__c == CONST_HK
            || objopportunity.Country__c == CONST_PP 
            || objopportunity.Country__c == CONST_SG)
            {
                if(objPremise.objAcc.Name != null
                && objPremise.objAcc.TA_Street_Number__c != null
                && objPremise.objAcc.TA_Street_Name__c != null
                && objPremise.objAcc.TA_District__c != null 
                && objPremise.objAcc.TA_District__c != CONST_NONE
                && objPremise.objAcc.TA_Region__c != null
                && objPremise.objAcc.TA_Region__c != CONST_NONE
                //&& objPremise.objAcc.TA_Postcode__c != null
                && objPremise.objAcc.TA_Country__c != null
                && objPremise.objAcc.TA_Country__c != CONST_NONE)
                {
                    if((objopportunity.Country__c == CONST_PP
                    || objopportunity.Country__c == CONST_SG)
                    && objPremise.objAcc.TA_Postcode__c != null)
                    {
                        blnPremiseCompleted = true;
                    }
                    else
                    {
                        blnPremiseCompleted = false;
                    }
                    if(objopportunity.Country__c == CONST_HK)
                    {
                        blnPremiseCompleted = true;
                    }
                }
            }
            else
            {
                blnPremiseCompleted = false;
                break;
            }
        }
    } // end of premise_Completeness
    
    // method to validate completeness of business Debt
    public void businessDebt_Completeness()
    {
        for(debtDetails objDt : lstDebt)
        {
            if(objDT.objDebt.Debt_Type__c != null
            && objDt.objDebt.Debt_Type__c != CONST_NONE)
            {
                blnBusinessDebt = true;
                if(objDT.objDebt.Original_Debt_Amount__c != null
                && objDT.objDebt.Original_Debt_Amount__c > 0
                && objDT.objDebt.Monthly_Repayment__c != null
                && objDT.objDebt.Monthly_Repayment__c > 0
                && objDT.objDebt.Outstanding_Amount__c != null
                && objDT.objDebt.Outstanding_Amount__c > 0
                && objDT.objDebt.Civil_Litigation__c != null
                && objDT.objDebt.Civil_Litigation__c != CONST_NONE)
                {
                    blnBusinessDebtCompleted = true;
                }
                else
                {
                    blnBusinessDebtCompleted = false;
                    break;
                }
            }
        }
    } // end of businessDebt_Completeness
    
    // method to validate completeness of Owner/Director/Guarantor debt
    public void ODG_Debt_Completeness(list<debtDetails> lstdebtDetails)
    {
        for(debtDetails objDT : lstdebtDetails)
        {
            if(objDT.objDebt.Debt_Type__c != null
            && objDt.objDebt.Debt_Type__c != CONST_NONE)
            {
                blnODGAddDebt = true;
                if(objDT.objDebt.Original_Debt_Amount__c != null
                && objDT.objDebt.Original_Debt_Amount__c > 0
                && objDT.objDebt.Monthly_Repayment__c != null
                && objDT.objDebt.Monthly_Repayment__c > 0
                && objDT.objDebt.Outstanding_Amount__c != null
                && objDT.objDebt.Outstanding_Amount__c > 0
                && objDT.objDebt.Legal_Entity__c != null
                && objDT.objDebt.Legal_Entity__c != ''
                && objDT.objDebt.Civil_Litigation__c != null
                && objDT.objDebt.Civil_Litigation__c != CONST_NONE)
                {
                    blnODGAddDebtCompleted = true;
                }
                else
                {
                    blnODGAddDebtCompleted = false;
                    break;
                }
            }
        }
    } // end of ODG_Debt_Completeness
    
    // method to validate completeness of Owner/Director/Guarantor information
    public boolean ODG_UK_Completeness(ownerDetails objWrapper)
    {
        //Removed from Layout, So no need to remove from Condition as well
        // && objWrapper.objAcc.Was_AMP_Client_Before__pc != null && objWrapper.objAcc.Was_AMP_Client_Before__pc != CONST_NONE
        
        boolean blnTemp = false;
        if(objWrapper.objAcc.Salutation__pc != null && objWrapper.objAcc.Salutation__pc != CONST_NONE
        && objWrapper.objAcc.FirstName != null && objWrapper.objAcc.FirstName != ''
        && objWrapper.objAcc.LastName!= null && objWrapper.objAcc.LastName != ''
        && objWrapper.objAcc.Business_Position__pc != null && objWrapper.objAcc.Business_Position__pc != ''
        && objWrapper.objAcc.Percentage_of_the_Company_Ownership__pc != null 
        && objWrapper.objAcc.Percentage_of_the_Company_Ownership__pc != 0.0
        && objWrapper.objAcc.Gender__pc != null && objWrapper.objAcc.Gender__pc != CONST_NONE
        && objWrapper.objAcc.PersonBirthdate != null
        && objWrapper.objAcc.Marital_Status__pc != null && objWrapper.objAcc.Marital_Status__pc != CONST_NONE
        && objWrapper.objAcc.Any_Dependents__pc != null &&objWrapper.objAcc.Any_Dependents__pc != CONST_NONE
        && objWrapper.objAcc.Education_Level__pc != null && objWrapper.objAcc.Education_Level__pc != CONST_NONE
        && objWrapper.objAcc.Associated_Business__c != null
        && objWrapper.objAcc.Home_Street_Number__pc != null && objWrapper.objAcc.Home_Street_Number__pc != ''
        && objWrapper.objAcc.Home_Street_Name__pc != null && objWrapper.objAcc.Home_Street_Name__pc != ''
        //&& objWrapper.objAcc.Home_Postcode__pc != null && objWrapper.objAcc.Home_Postcode__pc != ''
        && objWrapper.objAcc.Home_Country__pc != null && objWrapper.objAcc.Home_Country__pc != CONST_NONE
        && objWrapper.objAcc.Time_at_this_Address_Months__c != null && objWrapper.objAcc.Time_at_this_Address_Months__c != CONST_NONE
        && objWrapper.objAcc.PersonMobilePhone != null && objWrapper.objAcc.PersonMobilePhone != ''
        && objWrapper.objAcc.PersonEmail != null && objWrapper.objAcc.PersonEmail != ''
        && objWrapper.objAcc.Property_Ownership__pc != null  && objWrapper.objAcc.Property_Ownership__pc != CONST_NONE        
        && objWrapper.objAcc.Consent_to_Search__pc == CONST_YES)
        {
            if(objOpportunity.Country__c == CONST_UK)
            {
                if(//objWrapper.objAcc.Home_City_Lookup__pc != null  
                   objWrapper.objAcc.Home_Postcode__pc != null && objWrapper.objAcc.Home_Postcode__pc != ''
                )
                {
                    blnTemp = true;
                }
            }// end of ODG for UK
            else if(objOpportunity.Country__c == CONST_HK
            || objOpportunity.Country__c == CONST_SG
            || objOpportunity.Country__c == CONST_PP)
            {
                if(objWrapper.objAcc.Home_Region__pc != null && objWrapper.objAcc.Home_Region__pc != CONST_NONE
                && objWrapper.objAcc.Home_District__pc != null && objWrapper.objAcc.Home_District__pc != CONST_NONE
                && objWrapper.objAcc.Residency_Status__pc != null && objWrapper.objAcc.Residency_Status__pc != CONST_NONE)
                {
                    if((objOpportunity.Country__c == CONST_SG
                    || objOpportunity.Country__c == CONST_PP)
                    && objWrapper.objAcc.Home_Postcode__pc != null && objWrapper.objAcc.Home_Postcode__pc != '')
                    {
                        blnTemp = residencyStatusCompleteness(objWrapper);
                    }
                    if(objOpportunity.Country__c == CONST_HK)
                    {
                        blnTemp = residencyStatusCompleteness(objWrapper);
                    }
                }
            }// end of ODG for HK ,SG,PP
            else
            {
                blnTemp = false;
            }
        }
        return blnTemp;
    } // end of ODG_UK_Completeness
    
    //method to validate completeness of ResidencyStatus
    public boolean residencyStatusCompleteness(ownerDetails objWrapper)
    {
        if(objWrapper.objAcc.Residency_Status__pc == CONST_PERMANENTRESIDENT 
        || objWrapper.objAcc.Residency_Status__pc == CONST_SINGAPOREAN
        || objWrapper.objAcc.Residency_Status__pc == CONST_CITIZEN )
        {
            if(objWrapper.objAcc.HKID_Card_No__pc <> null && objWrapper.objAcc.HKID_Card_No__pc <> ''
            || objWrapper.objAcc.Valid_ID__pc <> null && objWrapper.objAcc.Valid_ID__pc <> '' 
            || objWrapper.objAcc.NRIC_Number__pc <> null && objWrapper.objAcc.NRIC_Number__pc <> '')
            {
                blnResidencyStatus = true;
            }
        }
        else if(objWrapper.objAcc.Residency_Status__pc == CONST_NONPERMANENTRESIDENT)
        {
            if((objWrapper.objAcc.HKID_Card_No__pc <> null && objWrapper.objAcc.HKID_Card_No__pc <> '')
            && (objWrapper.objAcc.Passport_Number__pc <> null 
            && objWrapper.objAcc.Passport_Number__pc <> '')
            && (objWrapper.objAcc.Passport_County_of_issues__pc <> null 
            && objWrapper.objAcc.Passport_County_of_issues__pc <> '')
            && (objWrapper.objAcc.Passport_Expiry_Date__pc <> null )
            && (objWrapper.objAcc.Time_in_Country__c <> null 
            && objWrapper.objAcc.Time_in_Country__c <> CONST_NONE))
            {
                blnResidencyStatus = true;
            }
        }
        else if(objWrapper.objAcc.Residency_Status__pc == CONST_NONHKRESIDENT
        || objWrapper.objAcc.Residency_Status__pc == CONST_NONPPRESIDENT
        || objWrapper.objAcc.Residency_Status__pc == CONST_SINGAPOREFOREIGNERWITHPASS
        || objWrapper.objAcc.Residency_Status__pc == CONST_SINGAPOREFOREIGNERWITHOUTPASS )
        {
            if((objWrapper.objAcc.Passport_Number__pc <> null 
            && objWrapper.objAcc.Passport_Number__pc <> '')
            && (objWrapper.objAcc.Passport_County_of_issues__pc <> null 
            && objWrapper.objAcc.Passport_County_of_issues__pc <> '')
            && (objWrapper.objAcc.Passport_Expiry_Date__pc <> null)
            && (objWrapper.objAcc.Time_in_Country__c <> null 
            && objWrapper.objAcc.Time_in_Country__c <> CONST_NONE))
            {
                blnResidencyStatus = true;
            }
        }
        else if(objWrapper.objAcc.Residency_Status__pc == CONST_SINGAPOREPERMANENTRESIDENT)
        {
            blnResidencyStatus = true;
        }
        else if(objWrapper.objAcc.Residency_Status__pc == CONST_PERMANENTRESIDENTALIEN)
        {
            if(objWrapper.objAcc.ECR__pc <> null
            && String.valueof(objWrapper.objAcc.ECR__pc) != '')
            {
                blnResidencyStatus = true;
            }
        }
        else
            blnResidencyStatus = false;
        return blnResidencyStatus;
    }
    // method to validate completeness of Owner/Director/Guarantor information
    public void ODG_Completeness()
    {
        boolean blnOwnerInfoCompleted = false;
        Decimal totalOwnership = 0;
        for(ownerDetails objWrapper : lstWrapperToDisplay)
        {
            if(objWrapper.objAcc.LastName == null && objWrapper.objAcc.LastName == '')
            {
                apexPages.addmessage(new apexpages.message(apexpages.severity.Error,
                Label.CRMS_LastNameError));
                errorLastName = true;
                break;
            }
            else
            {
                blnOwnerInfoCompleted = ODG_UK_Completeness(objWrapper);
                ODG_Debt_Completeness(objWrapper.lstODGDebt);
                errorLastName = false;
                if(objWrapper.objAcc.Percentage_of_the_Company_Ownership__pc != null)
                    totalOwnership  = totalOwnership + objWrapper.objAcc.Percentage_of_the_Company_Ownership__pc;
                if(blnOwnerInfoCompleted)
                {
                    if(objWrapper.objAcc.Required_Bank_Signatory__c == true)
                    {
                        blnSig = true;
                    }
                    
                    if(blnPersonBirthdate)
                    {
                        blnPersonBirthdate = checkBirthdate(objWrapper.objAcc.PersonBirthdate);
                    }
                    /*
                    Change made on 05/01/2017
                    if(objWrapper.objAcc.Debt_Type__pc != null && objWrapper.objAcc.Debt_Type__pc != CONST_NONE)
                    {
                        if(objWrapper.objAcc.Lending_Entity__pc != null
                        && objWrapper.objAcc.Original_Debt_Amount__c != null && objWrapper.objAcc.Original_Debt_Amount__c > 0
                        && objWrapper.objAcc.Monthly_Repayment__pc != null && objWrapper.objAcc.Monthly_Repayment__pc > 0
                        && objWrapper.objAcc.Outstanding_Amount__pc != null && objWrapper.objAcc.Outstanding_Amount__pc > 0
                        && objWrapper.objAcc.Civil_Litigation__pc != null && objWrapper.objAcc.Civil_Litigation__pc != CONST_NONE)
                        {
                            validateAllData(totalOwnership, blnPersonBirthdate);
                        }
                        else
                        {
                            objOpportunity.Application_form_Completed__c = false;
                            message = false;
                            break;
                        }
                    }
                    else
                    {*/
                        validateAllData(totalOwnership, blnPersonBirthdate);
                    //} // Person Debt type null
                }
                else
                {
                    objOpportunity.Application_form_Completed__c = false;
                    message = false;
                    //blnPersonBirthdate = false;
                    break;
                }
            } // end of Last Name not null
        } // end of Wrapper for ODG
    } // end of ODG_Completeness
    
    //method to check if age is greater than 18 years
    public boolean checkBirthdate(Date dtBirthdate)
    {
        if(date.today().year() - dtBirthdate.year() > CONST_EIGHTEEN)
        {
            blnPersonBirthdate = true;
        }
        else if(date.today().year() - dtBirthdate.year() == CONST_EIGHTEEN)
        {
            if(date.today().month() - dtBirthdate.month() < CONST_ZERO)
            {
                blnPersonBirthdate = false;
            }
            else if(date.today().month() - dtBirthdate.month() == CONST_ZERO)
            {
                if(date.today().day() - dtBirthdate.day() < CONST_ZERO)
                {
                    blnPersonBirthdate = false;
                }
                else
                {
                    blnPersonBirthdate = true;
                }
            }
            else if(date.today().month() - dtBirthdate.month() > CONST_ZERO)
            {
                blnPersonBirthdate = true;
            }
            else
            {
                blnPersonBirthdate = false;
            }
        }
        else
        {
            blnPersonBirthdate = false;
        }
        return blnPersonBirthdate;
    }//end of 
    
    // validate if all the data has been completed successfully
    public void validateAllData(decimal totalOwnership, boolean blnPersonBirthdate)
    {
        if((blndebtType && blndebtTypeCompleted)
        || (!blndebtType && !blndebtTypeCompleted))
        {
            if((blnOccupiedStatusCompleted && blnOccupiedStatus)
            || (!blnOccupiedStatusCompleted && !blnOccupiedStatus))
            {
                if((blnTradingCompleted && blnTrading)
                || (!blnTradingCompleted && !blnTrading))
                {
                    if((blnPremise && blnPremiseCompleted)
                    || (!blnPremise && !blnPremiseCompleted))
                    {
                        if((blnBusinessDebt && blnBusinessDebtCompleted)
                        || (!blnBusinessDebt && !blnBusinessDebtCompleted))
                        {
                            if((blnODGAddDebt && blnODGAddDebtCompleted)
                            || (!blnODGAddDebt && !blnODGAddDebtCompleted))
                            {
                                if(blnSig)
                                {
                                    if(integer.valueOf(totalOwnership) >= 51 && integer.valueOf(totalOwnership) <= 100)
                                    {
                                        msgTotalOwnerShip = true;
                                        if(blnPersonBirthdate)
                                        {
                                            objOpportunity.Application_form_Completed__c = true;
                                            objOpportunity.StageName = CONST_PENDINGSIGNATURE;
                                            message = true;
                                        }
                                        else
                                        {
                                            objOpportunity.Application_form_Completed__c = false;
                                            message = true;
                                        }
                                    }
                                    else
                                    {
                                        objOpportunity.Application_form_Completed__c = false;
                                        msgTotalOwnerShip = false;
                                        message = true;
                                    }
                                }
                                else
                                {
                                    objOpportunity.Application_form_Completed__c = false;
                                    message = false;
                                }
                            }
                            else
                            {
                                objOpportunity.Application_form_Completed__c = false;
                                message = false;
                            }
                        }
                        else
                        {
                             objOpportunity.Application_form_Completed__c = false;
                             message = false;
                        }
                    }
                    else
                    {
                         objOpportunity.Application_form_Completed__c = false;
                         message = false;
                    }
                }
                else
                {
                     objOpportunity.Application_form_Completed__c = false;
                     message = false;
                }
            }
            else
            {
                 objOpportunity.Application_form_Completed__c = false;
                 message = false;
            }
        }
        else
        {
             objOpportunity.Application_form_Completed__c = false;
             message = false;
        }
    } // end of validateAllData
    
    // method to insert/update Business related Premise
    public void insertUpdatePremise()
    {
        system.debug('Insert Update Premise called*********');
        list<Account> lstUpsertPremise = new list<Account>();
        for(premiseInfo objPremise : lstPremise)
        {
            Account objAccount;
            if(objPremise.blnExisting)
            {
                objAccount = new Account(Id = objPremise.objAcc.Id);
            }
            else
            {
                objAccount = new Account();
            }
            objAccount.Name = objPremise.objAcc.Name;
            objAccount.ParentId = accountId;
            objAccount.RecordtypeId = objPremise.objAcc.RecordtypeId;
            //objAccount.Business_Rates__c = objPremise.objAcc.Business_Rates__c;
            objAccount.TA_Floor_No__c = objPremise.objAcc.TA_Floor_No__c;
            objAccount.TA_Building_Name__c = objPremise.objAcc.TA_Building_Name__c;
            objAccount.TA_Street_Number__c = objPremise.objAcc.TA_Street_Number__c;
            objAccount.TA_Street_Name__c = objPremise.objAcc.TA_Street_Name__c;
            objAccount.TA_Address_Line_2__c = objPremise.objAcc.TA_Address_Line_2__c;
            objAccount.TA_Address_Line_3__c = objPremise.objAcc.TA_Address_Line_3__c;
            objAccount.TA_City_Lookup__c = objPremise.objAcc.TA_City_Lookup__c;
            objAccount.TA_Postcode__c = objPremise.objAcc.TA_Postcode__c;
            objAccount.TA_Country__c = objPremise.objAcc.TA_Country__c;
            objAccount.TA_Region__c = objPremise.objAcc.TA_Region__c;
            objAccount.TA_Sub_Region__c = objPremise.objAcc.TA_Sub_Region__c;
            objAccount.TA_District__c = objPremise.objAcc.TA_District__c;
            objAccount.Trading_Address_if_different__c = true;
            lstUpsertPremise.add(objAccount); 
        }
        database.upsertResult[] lstSave = database.upsert(lstUpsertPremise, Account.Fields.Id, false);
        for(database.upsertResult objResult : lstSave){
            if (!objResult.isSuccess()){
                for(Database.Error err : objResult.getErrors()) {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,err.getFields()+': '+err.getMessage()+': '+err.getStatusCode());
                    ApexPages.addMessage(myMsg);
                }
            }
        }
    } // end of insertUpdatePremise
    
    // methof to insert/update Business related debt details
    public void insertUpdateBusinessDebt()
    {
        list<Additional_Debt__c> lstBusinessDebtToUpsert = new list<Additional_Debt__c>();
        for(debtDetails objDt : lstDebt)
        {
            Additional_Debt__c objAD;
            if(!objDt.blnExisting)
            {
                objAD = new Additional_Debt__c();
            }
            else
            {
                objAD = new Additional_Debt__c(Id = objDt.objDebt.Id);
            }
            objAD.Account__c = accountId;
            objAD.Opportunity__c = oppIdToRedirectPage;
            objAD.Civil_Litigation__c = objDt.objDebt.Civil_Litigation__c;
            objAD.Debt_Type__c = objDt.objDebt.Debt_Type__c;
            objAD.Legal_Entity__c = objDt.objDebt.Legal_Entity__c;
            objAD.Monthly_Repayment__c = objDt.objDebt.Monthly_Repayment__c;
            objAD.Original_Debt_Amount__c = objDt.objDebt.Original_Debt_Amount__c;
            objAD.Outstanding_Amount__c = objDt.objDebt.Outstanding_Amount__c;
            
            if(objAD.Debt_Type__c != null 
                	&& objAD.Monthly_Repayment__c != null 
                	&& objAD.Original_Debt_Amount__c != null
                	&& objAD.Outstanding_Amount__c != null){
                		lstBusinessDebtToUpsert.add(objAD);		
            }            
            
        }
        database.upsertResult[] lstSave = database.upsert(lstBusinessDebtToUpsert, Additional_Debt__c.Fields.Id, false);
        for(database.upsertResult objResult : lstSave){
            if (!objResult.isSuccess()){
                for(Database.Error err : objResult.getErrors()) {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,err.getFields()+': '+err.getMessage()+': '+err.getStatusCode());
                    ApexPages.addMessage(myMsg);
                }
            }
        }
    } // end of insertUpdateBusinessDebt
    
    // method to insert/update Person Account and ODG details
    public void insertUpdatePersonAccount()
    {
        map<String,Id> mapCounter_AccountId = new map<String,Id>();
        for(ownerDetails objWrapper : lstWrapperToDisplay)
        {
            if(objWrapper.objAcc.Id != null)
            {
                Account objAccount = new Account(Id = objWrapper.objAcc.Id);
                objAccount.LastName = objWrapper.objAcc.LastName;
                objAccount.FirstName = objWrapper.objAcc.FirstName;
                objAccount.Business_Position__pc = objWrapper.objAcc.Business_Position__pc;
                objAccount.Marital_Status__pc= objWrapper.objAcc.Marital_Status__pc;
                objAccount.Any_Dependents__pc = objWrapper.objAcc.Any_Dependents__pc;
                objAccount.Percentage_of_the_Company_Ownership__pc = objWrapper.objAcc.Percentage_of_the_Company_Ownership__pc ;
                objAccount.PersonBirthdate = objWrapper.objAcc.PersonBirthdate;
                objAccount.Gender__pc = objWrapper.objAcc.Gender__pc;
                objAccount.Salutation = objWrapper.objAcc.Salutation__pc;
                objAccount.Salutation__pc = objWrapper.objAcc.Salutation__pc;
                objAccount.National_Insurance_Number__pc = objWrapper.objAcc.National_Insurance_Number__pc;
                objAccount.Driver_Licence_Number__pc = objWrapper.objAcc.Driver_Licence_Number__pc;
                objAccount.Home_Address_Line_3__pc = objWrapper.objAcc.Home_Address_Line_3__pc;
                objAccount.Home_Building_Name__pc = objWrapper.objAcc.Home_Building_Name__pc;
                objAccount.Home_City_Lookup__pc = objWrapper.objAcc.Home_City_Lookup__pc;
                objAccount.Home_Country__pc = objWrapper.objAcc.Home_Country__pc;
                objAccount.Home_Address_Line_2__pc = objWrapper.objAcc.Home_Address_Line_2__pc;
                objAccount.Home_District__pc = objWrapper.objAcc.Home_District__pc;
                objAccount.Home_Floor_No__pc = objWrapper.objAcc.Home_Floor_No__pc;
                objAccount.Home_Postcode__pc = objWrapper.objAcc.Home_Postcode__pc;
                objAccount.Home_Region__pc = objWrapper.objAcc.Home_Region__pc;
                objAccount.Home_Sub_Region__pc = objWrapper.objAcc.Home_Sub_Region__pc;
                objAccount.Home_Street_Name__pc = objWrapper.objAcc.Home_Street_Name__pc;
                objAccount.Home_Street_Number__pc = objWrapper.objAcc.Home_Street_Number__pc;
                objAccount.Property_Ownership__pc = objWrapper.objAcc.Property_Ownership__pc;
                objAccount.Time_at_this_Address_Months__c = objWrapper.objAcc.Time_at_this_Address_Months__c;
                objAccount.Time_in_Country__c = objWrapper.objAcc.Time_in_Country__c;
                objAccount.PersonHomePhone = objWrapper.objAcc.PersonHomePhone;
                objAccount.PersonMobilePhone  = objWrapper.objAcc.PersonMobilePhone;
                objAccount.PersonEmail = objWrapper.objAcc.PersonEmail;
                objAccount.Consent_to_search__pc = objWrapper.objAcc.Consent_to_search__pc;
                objAccount.Education_Level__pc = objWrapper.objAcc.Education_Level__pc;
                objAccount.Business_Legal_Name__c = objWrapper.objAcc.Business_Legal_Name__c;
                //objAccount.Was_AMP_client_before__pc = objWrapper.objAcc.Was_AMP_client_before__pc;  Removed from Layout
                objAccount.HKID_card_no__pc = objWrapper.objAcc.HKID_card_no__pc;  //Removed from Layout
                objAccount.Debt_type__pc = objWrapper.objAcc.Debt_type__pc;
                objAccount.Civil_Litigation__pc = objWrapper.objAcc.Civil_Litigation__pc;
                objAccount.Outstanding_amount__pc = objWrapper.objAcc.Outstanding_amount__pc;
                objAccount.Monthly_repayment__pc = objWrapper.objAcc.Monthly_repayment__pc;
                objAccount.Original_Debt_Amount__c = objWrapper.objAcc.Original_Debt_Amount__c;
                objAccount.Lending_Entity__pc = objWrapper.objAcc.Lending_Entity__pc;
                objAccount.Residency_Status__pc = objWrapper.objAcc.Residency_Status__pc;
                objAccount.Passport_County_of_issues__pc = objWrapper.objAcc.Passport_County_of_issues__pc;
                objAccount.Passport_Expiry_Date__pc = objWrapper.objAcc.Passport_Expiry_Date__pc;
                objAccount.Passport_Number__pc = objWrapper.objAcc.Passport_Number__pc;
                objAccount.NRIC_Number__pc = objWrapper.objAcc.NRIC_Number__pc;
                objAccount.Valid_ID__pc = objWrapper.objAcc.Valid_ID__pc;
                objAccount.Other_ID__pc = objWrapper.objAcc.Other_ID__pc;
                objAccount.ECR__pc = objWrapper.objAcc.ECR__pc;
                lstPersonAccountToUpdate.add(objAccount);
            }
            else
            {
                Account objAccount = new Account();
                objAccount.RecordtypeId = mapPerson_Id.get(strCountry);
                objAccount.Counter__c = string.valueOf(objWrapper.counter);
                objAccount.Salutation = objWrapper.objAcc.Salutation__pc;
                objAccount.Salutation__pc = objWrapper.objAcc.Salutation__pc;
                if(objWrapper.objAcc.LastName == null || objWrapper.objAcc.LastName == '')
                {
                    apexPages.addmessage(new apexpages.message(apexpages.severity.Error,
                    Label.CRMS_LastNameError));
                    break;
                }
                else
                {
                    objAccount.LastName = objWrapper.objAcc.LastName;
                }
                objAccount.Associated_Business__c = accountId;
                objAccount.FirstName = objWrapper.objAcc.FirstName;
                objAccount.Business_Position__pc = objWrapper.objAcc.Business_Position__pc;
                objAccount.Percentage_of_the_Company_Ownership__pc = objWrapper.objAcc.Percentage_of_the_Company_Ownership__pc ;
                objAccount.PersonBirthdate = objWrapper.objAcc.PersonBirthdate;
                objAccount.Gender__pc = objWrapper.objAcc.Gender__pc;
                objAccount.Marital_Status__pc= objWrapper.objAcc.Marital_Status__pc;
                objAccount.Any_Dependents__pc = objWrapper.objAcc.Any_Dependents__pc;
                objAccount.National_Insurance_Number__pc = objWrapper.objAcc.National_Insurance_Number__pc;
                objAccount.Driver_Licence_Number__pc = objWrapper.objAcc.Driver_Licence_Number__pc;
                objAccount.Home_Address_Line_3__pc = objWrapper.objAcc.Home_Address_Line_3__pc;
                objAccount.Home_Building_Name__pc = objWrapper.objAcc.Home_Building_Name__pc;
                objAccount.Home_City_Lookup__pc = objWrapper.objAcc.Home_City_Lookup__pc;
                objAccount.Home_Country__pc = objWrapper.objAcc.Home_Country__pc;
                objAccount.Home_Address_Line_2__pc = objWrapper.objAcc.Home_Address_Line_2__pc;
                objAccount.Home_District__pc = objWrapper.objAcc.Home_District__pc;
                objAccount.Home_Floor_No__pc = objWrapper.objAcc.Home_Floor_No__pc;
                objAccount.Home_Postcode__pc = objWrapper.objAcc.Home_Postcode__pc;
                objAccount.Home_Region__pc = objWrapper.objAcc.Home_Region__pc;
                objAccount.Home_Sub_Region__pc = objWrapper.objAcc.Home_Sub_Region__pc;
                objAccount.Home_Street_Name__pc = objWrapper.objAcc.Home_Street_Name__pc;
                objAccount.Home_Street_Number__pc = objWrapper.objAcc.Home_Street_Number__pc;
                objAccount.Property_Ownership__pc = objWrapper.objAcc.Property_Ownership__pc;
                objAccount.Time_at_this_Address_Months__c = objWrapper.objAcc.Time_at_this_Address_Months__c;
                objAccount.Time_in_Country__c = objWrapper.objAcc.Time_in_Country__c;
                objAccount.PersonHomePhone = objWrapper.objAcc.PersonHomePhone;
                objAccount.PersonMobilePhone  = objWrapper.objAcc.PersonMobilePhone;
                objAccount.PersonEmail = objWrapper.objAcc.PersonEmail;
                objAccount.Consent_to_search__pc = objWrapper.objAcc.Consent_to_search__pc;
                objAccount.Education_Level__pc = objWrapper.objAcc.Education_Level__pc;
                objAccount.Business_Legal_Name__c = objWrapper.objAcc.Business_Legal_Name__c ;
                //objAccount.Was_AMP_client_before__pc = objWrapper.objAcc.Was_AMP_client_before__pc; Removed from Layout
                objAccount.HKID_card_no__pc = objWrapper.objAcc.HKID_card_no__pc;
                objAccount.Debt_type__pc = objWrapper.objAcc.Debt_type__pc;
                objAccount.Civil_Litigation__pc = objWrapper.objAcc.Civil_Litigation__pc;
                objAccount.Outstanding_amount__pc = objWrapper.objAcc.Outstanding_amount__pc;
                objAccount.Monthly_repayment__pc = objWrapper.objAcc.Monthly_repayment__pc;
                objAccount.Original_Debt_Amount__c = objWrapper.objAcc.Original_Debt_Amount__c;
                objAccount.Lending_Entity__pc = objWrapper.objAcc.Lending_Entity__pc;
                objAccount.Residency_Status__pc = objWrapper.objAcc.Residency_Status__pc ;
                objAccount.Passport_County_of_issues__pc = objWrapper.objAcc.Passport_County_of_issues__pc;
                objAccount.Passport_Expiry_Date__pc = objWrapper.objAcc.Passport_Expiry_Date__pc;
                objAccount.Passport_Number__pc = objWrapper.objAcc.Passport_Number__pc;
                objAccount.NRIC_Number__pc = objWrapper.objAcc.NRIC_Number__pc;
                objAccount.Valid_ID__pc = objWrapper.objAcc.Valid_ID__pc;
                objAccount.Other_ID__pc = objWrapper.objAcc.Other_ID__pc;
                objAccount.ECR__pc = objWrapper.objAcc.ECR__pc;
                lstPersonAccountToInsert.add(objAccount);
            }
        } // end of for loop
        
        if(lstPersonAccountToInsert.size() != 0 && !lstPersonAccountToInsert.isEmpty())
        {
            insert lstPersonAccountToInsert;
            mapCounter_AccountId = insertODG_ForNewlyInsertedPersonAccounts(lstPersonAccountToInsert);
        } // end of lstPersonAccountToInsert > 0
        
        if(lstPersonAccountToUpdate.size() != 0 && !lstPersonAccountToUpdate.isEmpty())
        {
            update lstPersonAccountToUpdate;
        }
        
        if((lstPersonAccountToUpdate.size() != 0 && !lstPersonAccountToUpdate.isEmpty())
        || lstPersonAccountToInsert.size() != 0 && !lstPersonAccountToInsert.isEmpty())
        {
            insertUpdateODGAdditionalDebt(mapCounter_AccountId);
        }
    } // end of insertUpdatePersonAccount
    
    // method to insert/ ODG for new Person Accounts that are inserted
    public map<String,Id> insertODG_ForNewlyInsertedPersonAccounts(list<Account> lstPersonAccountToInsert)
    {
        list<Guarantors__c> lstGuarantors = new list<Guarantors__c>();
        set<Id> setPersonAccountId = new set<Id>();
        list<Account> lstPersonAccountToGetContactId = new list<Account>();
        map<String,Id> mapCounter_AccountId = new map<String,Id>();
        for(Account objPersonAccount : lstPersonAccountToInsert)
        {
            setPersonAccountId.add(objPersonAccount.Id);
            mapCounter_AccountId.put(objPersonAccount.Counter__c, objPersonAccount.Id);
        }
        
        lstPersonAccountToGetContactId  = [select Id,PersonContactId, Business_Position__pc,
                                            PersonEmail, Associated_Business__c, Consent_to_Search__pc,
                                            Required_Bank_Signatory__c
                                           from Account where Id IN:setPersonAccountId];
        
        for(Account objPersonAccount : lstPersonAccountToGetContactId)
        {
            Guarantors__c  objGuarantors = new Guarantors__c();
            objGuarantors.Account__c = objPersonAccount.Id;
            objGuarantors.Opportunity__c = objOpportunity.Id;
            objGuarantors.ExternalId__c = string.valueOf(objOpportunity.Id)+string.valueOf(objPersonAccount.Id);
            objGuarantors.Consent_to_Search__c = objPersonAccount.Consent_to_Search__pc;
            objGuarantors.Email__c = objPersonAccount.PersonEmail;
            objGuarantors.Account_Role__c = objPersonAccount.Business_Position__pc;
            objGuarantors.Required_Bank_Signatory__c = objPersonAccount.Required_Bank_Signatory__c;
            lstGuarantors.add(objGuarantors);
        }
        if(lstGuarantors.size() > 0 && !lstGuarantors.isEmpty())
        {
            database.upsertResult[] lstG = database.upsert(lstGuarantors, Guarantors__c.Fields.Id, false);
            for(database.upsertResult objResult : lstG){
                if (!objResult.isSuccess()){
                    for(Database.Error err : objResult.getErrors()) {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,err.getFields()+': '+err.getMessage()+': '+err.getStatusCode());
                        ApexPages.addMessage(myMsg);
                    }
                }
            }
        }
        return mapCounter_AccountId;
    }
    
    // method to insert/update Additional Debt infor for individual ODG
    public void insertUpdateODGAdditionalDebt(map<String,Id> mapCounter_AccountId)
    {
        list<Additional_Debt__c> lstODGAddDebtToUpsert = new list<Additional_Debt__c>();
        for(ownerDetails objDetails : lstWrapperToDisplay)
        {
            for(debtDetails objD : objDetails.lstODGDebt)
            {
                Additional_Debt__c objAddDebt;
                if(!objD.blnExisting)
                {
                    objAddDebt = new Additional_Debt__c();
                }
                else
                {
                    objAddDebt = new Additional_Debt__c(Id = objD.objDebt.Id);
                }
                if(objDetails.blnExisting)
                    objAddDebt.Account__c = objDetails.objAcc.Id;
                else
                    objAddDebt.Account__c = mapCounter_AccountId.get(string.valueOf(objDetails.counter));
                                
                objAddDebt.Opportunity__c = oppIdToRedirectPage;
                objAddDebt.Civil_Litigation__c = objD.objDebt.Civil_Litigation__c;
                objAddDebt.Debt_Type__c = objD.objDebt.Debt_Type__c;
                objAddDebt.Legal_Entity__c = objD.objDebt.Legal_Entity__c;
                objAddDebt.Monthly_Repayment__c = objD.objDebt.Monthly_Repayment__c;
                objAddDebt.Original_Debt_Amount__c = objD.objDebt.Original_Debt_Amount__c;
                objAddDebt.Outstanding_Amount__c = objD.objDebt.Outstanding_Amount__c;
                
                if(objAddDebt.Debt_Type__c != null 
                	&& objAddDebt.Monthly_Repayment__c != null 
                	&& objAddDebt.Original_Debt_Amount__c != null
                	&& objAddDebt.Outstanding_Amount__c != null){
                		lstODGAddDebtToUpsert.add(objAddDebt);		
                }                
            }
        }
        database.upsertResult[] lstSave = database.upsert(lstODGAddDebtToUpsert, Additional_Debt__c.Fields.Id, false);
        for(database.upsertResult objResult : lstSave){
            if (!objResult.isSuccess()){
                for(Database.Error err : objResult.getErrors()) {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,err.getFields()+': '+err.getMessage()+': '+err.getStatusCode());
                    ApexPages.addMessage(myMsg);
                }
            }
        }
        
    } // end of insertUpdateODGAdditionalDebt
    
    //method to validate application form is complete
    public void validateApplicationForm()
    {
        tradingAddress_Completeness();
                        
        if(accountInfo.Self_Owned_Rented__c == CONST_OTHER || accountInfo.Self_Owned_Rented__c == CONST_SELFOWNED)
        {
            accountOwnership_Others_Completeness();
        } // Premise mortgaged or others
        else if(accountInfo.Self_Owned_Rented__c == CONST_MORTGAGED )
        {
            accountOwnership_Mortgage_Completeness();
        } // end of Premise is Self Owned
        else if(accountInfo.Self_Owned_Rented__c == CONST_RENTED)
        {
            accountOwnership_Rented_Completeness();
        } // end of Premise is rented
        /*  
        Change made on 05/01/2017
        if(accountInfo.Debt_Type__c != null  && accountInfo.Debt_Type__c != CONST_NONE)
        {
            accountDebt_Completeness();
        } // end of Account Debt Type is not null
        */
        blnPremise = false;
        blnPremiseCompleted = false;
        premise_Completeness();
        
        blnBusinessDebt = false;
        blnBusinessDebtCompleted = false;
        businessDebt_Completeness();
        
        blnSig = false;
        blnODGAddDebt = false;
        blnODGAddDebtCompleted = false;
        
        ODG_Completeness();
    }
    
    // method to save Account, Opportunity, Person Account, ODG, Additional Debt info
    public void saveOpp()
    {
        Savepoint sp = Database.setSavepoint();
        errorLastName = false;
        blnOccupiedStatus = false;
        blnOccupiedStatusCompleted = false;
        blnTrading = false;
        blnTradingCompleted = false;
        blndebtType = false;
        blndebtTypeCompleted = false;
        message = false;
        msgTotalOwnerShip = false;
        blnException = false;
        lstPersonAccountToUpdate = new list<Account>();
        lstPersonAccountToInsert = new list<Account>();
        String str = (objOpportunity.Number_of_Outlets__c == null? '1': objOpportunity.Number_of_Outlets__c);        
        //accountInfo.Bank_Name__c = selectedBankVal;
        system.debug(logginglevel.ERROR, 'selectedBankVal:'+selectedBankVal);
        //system.debug(logginglevel.ERROR, ' accountInfo.Bank_Name__c:'+ accountInfo.Bank_Name__c);
        try
        {
            insertODG();
            if((lstPremise.isEmpty() && (objOpportunity.Number_of_Outlets__c == '1' || objOpportunity.Number_of_Outlets__c == CONST_NONE)) 
            || ((objOpportunity.Number_of_Outlets__c != null && objOpportunity.Number_of_Outlets__c != CONST_NONE && lstPremise.size()!= null)
            && ((lstPremise.size() + 1) == Integer.ValueOf(str))))
            {
                if(accountOpportunityBasicInfo_Completeness())
                {
                    validateApplicationForm();
                } // end of necessary mandatory fields
                else
                {
                    objOpportunity.Application_form_Completed__c = false;
                    message = false;
                }
                if(!errorLastName)
                {
                    insertUpdatePremise();
                    insertUpdateBusinessDebt();
                    insertUpdatePersonAccount();
                } // end of Errorlast name false
                
                accountInfo.Monthly_Rent__c = objOpportunity.Monthly_Rental__c;
                accountInfo.Trading_Address_if_different__c = tradingAddAcc;
                accountInfo.Total_Monthly_Sales__c = objopportunity.Ave_Monthly_Sales__c;
                accountInfo.Average_Monthly_Card_Sales_Volume__c = objopportunity.Average_Monthly_Card_Sales__c;
                update accountInfo;
                update objOpportunity;
                if(!mapPremiseId_PremiseToDelete.isEmpty()){
                    delete mapPremiseId_PremiseToDelete.values();
                }
                if(!mapGuarantorId_GuarantorToDelete.isEmpty()){
                    delete mapGuarantorId_GuarantorToDelete.values();
                }
                if(!mapDebtId_DebtToDelete.isEmpty()){
                    delete mapDebtId_DebtToDelete.values();
                }
            } // end of Number of outlet check
            else
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,
                Label.CRMS_Premise_No_Of_Outlets_Error);
                Database.rollback(sp);
                ApexPages.addMessage(myMsg);
            }
       } // end of try
       catch(Exception e) 
       {
            Database.rollback(sp);
            blnException = true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
       } // end of catch
    } // end of saveOpp method
    
    public class ownerDetails
    {
        public Account objAcc {get;set;}
        public Opportunity objOpp{get;set;}
        public Guarantors__c objGuarantor;
        public boolean primaryContact {get;set;}
        public Integer counter {get;set;}
        public boolean blnExisting {get;set;}
        public boolean blndisplayBlock {get;set;}
        public list<debtDetails> lstODGDebt {get;set;}
        
        public ownerDetails(Account objA, Opportunity objOpp, Guarantors__c objGuarantor, boolean primaryContact, boolean blndisplayBlock, boolean blnExisting, list<debtDetails> lstODGDebt)
        {
            objAcc = objA;
            this.objGuarantor = objGuarantor;
            this.objOpp = objOpp;
            this.primaryContact = primaryContact;
            this.blndisplayBlock  = blndisplayBlock;
            this.counter = rowCount;
            this.blnExisting = blnExisting;
            this.lstODGDebt = lstODGDebt;
        }
    } // end of ownerDetails inner class
    
    public class debtDetails
    {
        public Additional_Debt__c objDebt {get;set;}
        public boolean blnDisplay {get;set;}
        public Integer counter {get;set;}
        public boolean blnExisting {get;set;}
        public debtDetails(Additional_Debt__c objDebt, boolean blnDisplay, boolean blnExisting)
        {
            this.objDebt = objDebt;
            this.blnDisplay = blnDisplay;
            this.counter = debtRowCount;
            this.blnExisting = blnExisting;
        }
    } // end of debtDetails inner class
    
    public class premiseInfo
    {
        public Account objAcc {get;set;}
        public boolean blnExisting {get;set;}
        public Integer counter {get;set;}
        
        public premiseInfo(Account objAcc, boolean blnExisting)
        {
            this.objAcc = objAcc;
            this.blnExisting = blnExisting;
            this.counter = premiseRowCount;
        }
    } // end of premiseInfo inner class
} // end of class