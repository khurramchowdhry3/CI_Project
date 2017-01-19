@isTest
private class CRMS_UKApplicationFormExtentionTest
{
    static Account objBA, objAcc,objBAPP,objAccPP,objBAHK,objAccHK,objBASG,objAccSG,objAccPremise;
    static Opportunity objOpp,objOpp1,objOppHK,objOppSG;
    static list<RecordType> lstUKBA, lstUKPA, lstUKApplication,lstUKPremise,lstPPPremise,lstSGBA, lstSGPA,lstHKPremise,lstSGApplication;
    static list<RecordType> lstPPBA, lstPPPA, lstPPApplication,lstHKBA,lstHKPA, lstHKApplication,lstSGPremise;
    static Guarantors__c objGuarantors,objGuarantorsPP,objGuarantorsHK,objGuarantorsSG;
    static Additional_Debt__c objAD,objADPP,objADHK,objADSG;
    
    private static void initialize()
    {
        CRMS_Util.generateEndpoints();
        lstUKBA = [Select r.SobjectType, r.Id, r.DeveloperName 
                    From RecordType r 
                    where r.SobjectType = 'Account' 
                    and r.DeveloperName = 'Prospect_UK'];
                    
        lstUKPA = [select Id from RecordType r where r.SobjectType = 'Account'
                    and r.DeveloperName = 'Person_UK'];
        
        lstUKApplication = [Select r.SobjectType, r.Name, r.Id, r.DeveloperName 
                            From RecordType r where r.SobjectType = 'Opportunity' 
                            and r.DeveloperName = 'Application_UK'];
        objBA = new Account();
        objBA.Name = 'UK Company';
        objBA.RecordtypeId = lstUKBA[0].Id;
        objBA.Business_Legal_Name__c = 'UK Company Co.';
        objBA.AccountNumber = 'UKACC01';
        objBA.Business_Nature_Category__c = 'Food Services';
        objBA.Business_Nature_Type__c = 'Bakeries [5462]';
        objBA.Sic = 'UKSIC';
        objBA.Entity_Type__c = 'LLP';        
        objBA.LE_Floor_No__c = '4';
        objBA.LE_Street_Number__c = '40';
        objBA.LE_Street_Name__c = 'Street 40';
        //objBA.LE_City__c = 'London';
        objBA.LE_Postcode__c = 'LON101';
        objBA.LE_Country__c = 'England';
        objBA.Years_in_Business__c = '5';
        objBA.Phone = '9865329865';
        objBA.Fax = '7845784578';
        objBA.Business_Email_Address__c = 'user@test.com';
        objBA.Website = 'www.ukcompany.com';
        objBA.Trading_Address_if_different__c = true;
        objBA.TA_Floor_No__c = '4';
        objBA.TA_Street_Number__c = '40';
        objBA.TA_Street_Name__c = 'Street 40';
        //objBA.TA_City__c = 'London';
        objBA.TA_Postcode__c = 'LON101';
        objBA.TA_Country__c = 'England';
        objBA.TA_Address_Line_2__c = 'line 2';
        objBA.TA_Address_Line_3__c = 'Line 3';
        objBA.Type_of_Premises__c = 'Shop';
        objBA.Self_Owned_Rented__c = 'Rented';
        objBA.Property_Owner_First_Name__c = 'James';
        objBA.Property_Owner_Last_Name__c = 'Brown';
        objBA.Property_Owner_Contact_Number__c = '7417417410';
        objBA.Operating_Days_Per_Week__c = '5';
        objBA.Operating_Hours_Per_Day__c = '8';
        objBA.Total_No_Of_Staff__c = '5';
        objBA.Other_Operating_Costs__c = 56565;
        objBA.Total_Staff_Cost__c = 50000;
        //objBA.Time_at_this_Address__c = '8';
        objBA.Time_at_this_Address_Months__c = '0-6 months';
        objBa.Monthly_Rent__c = 9000;
        objBA.Monthly_Mortgage_Payments__c = 3500;
        objBA.Debt_Type__c = 'Overdraft';
        objBA.Rental_Security_Deposit__c = 35000;
        objBA.Original_Debt_Amount__c = 50000;
        objBA.Monthly_Repayment__c = 2500;
        objBA.Outstanding_Debt_Amount__c = 35000;
        objBA.Months_Left_on_the_Lease__c = '3';
        objBA.Paid_for_the_Month_Of__c = 'Jan';
        objBA.Paid_for_the_amount_of__c = 6000;
        objBA.Number_of_Months_in_Arrears_if_any__c = '5';
        objBA.Civil_Litigation__c = 'Yes';
        objBA.Business_Rates__c = 5600;        
        objBA.Civil_Litigation__c = 'No';
        objBA.Debt_Type__c = 'Personal Loan';
        objBA.Original_Debt_Amount__c = 1500;
        objBA.Monthly_Repayment__c = 1500;
        objBA.Legal_Entity__c = 'LE';
        objBA.ParentId = objBA.Id;
        //CRMS_Util.generateEndpoints();
        insert objBA;
        
        objAcc = new Account();
        objAcc.RecordTypeId = lstUKPA[0].Id;
        objAcc.Salutation = 'Mr.';
        objAcc.Salutation__pc = 'Mr.';
        objAcc.FirstName = 'Ethan';
        objAcc.LastName = 'Hunt';
        objAcc.Gender__pc = 'Male';
        objAcc.Marital_Status__pc = 'Married';
        objAcc.Any_Dependents__pc = '2';
        objAcc.Education_Level__pc = 'Secondary';
        objAcc.Business_Position__pc = 'Owner';
        objAcc.Percentage_of_the_Company_Ownership__pc = 60;
        objAcc.Associated_Business__c = objBA.Id;
        objAcc.Home_Floor_No__pc = '12';
        objAcc.Home_Street_Number__pc = '12';
        objAcc.PersonBirthdate = Date.Today().addYears(-18);
        objAcc.Home_Street_Name__pc = '12th Street';
        //objAcc.Home_City__pc = 'London';
        objAcc.Home_Postcode__pc = 'LON101';
        objAcc.Home_Country__pc = 'England';
        objAcc.Property_Ownership__pc = 'Shop';
        objAcc.Time_in_Country__c = '0-6 months';
        objAcc.Time_at_this_Address_Months__c = '0-6 months';
        objAcc.National_Insurance_Number__pc = 'NIC101';
        objAcc.PersonMobilePhone = '4561237890';
        objAcc.PersonEmail = 'ethan@test.com';
        objAcc.Was_AMP_Client_Before__pc = 'No';
        objAcc.Debt_Type__pc = 'Personal Loan';
        objAcc.Lending_Entity__pc = 'LE';
        objAcc.Original_Debt_Amount__c = 1500;
        objAcc.Monthly_Repayment__pc = 15000;
        objAcc.Outstanding_Amount__pc = 1500;
        objAcc.Civil_Litigation__pc = 'Yes';
        objAcc.Consent_to_Search__pc = 'Yes';
        //CRMS_Util.generateEndpoints();
       insert objAcc;
       
       objAcc.PersonBirthdate = Date.Today().addYears(-18).addMonths(1);
       update objAcc;
        
        objOpp = new Opportunity();
        objOpp.Name = 'testOpp';
        objOpp.RecordtypeId = lstUKApplication[0].Id;
        objOpp.Amount = 1000;
        objOpp.CloseDate = date.Today() + 30;
        objOpp.StageName = 'In Progress';
        objOpp.AccountId = objBA.Id;
        objOpp.Country__c = 'UK';
        objOpp.Loan_Purpose__c = 'Expansion';
        objOpp.Requested_Loan_Term__c = '09 (270 days)';
        objOpp.Average_Monthly_Card_Sales__c = 10000;
        objOpp.Ave_Monthly_Sales__c = 20000;
        objOpp.Monthly_Rental__c = 1500;
        objOpp.Monthly_Interest__c = 2.5;
        objOpp.Agreed_that_no_Relationship_Exists__c = true;
        objOpp.Has_any_Relationship_with_AMP_Directors__c = 'Yes';
        objOpp.Name_of_AMP_Personnel__c = 'test';
        objOpp.Relationship_to_the_Applicant__c = 'brother';
        objOpp.Person_Account__c = objAcc.id;
        //CRMS_Util.generateEndpoints();
        insert objOpp;
        objOpp.Has_any_Relationship_with_AMP_Directors__c = 'No';
        //CRMS_Util.generateEndpoints();
        update objOpp;
       
        objGuarantors = new Guarantors__c();
        objGuarantors.Opportunity__c = objOpp.id;
        objGuarantors.Account__c = objAcc.id;
        objGuarantors.Consent_to_Search__c = 'Yes';
        objGuarantors.Account_Role__c = 'Owner';
        objGuarantors.Required_Bank_Signatory__c = true;
        //CRMS_Util.generateEndpoints();
        insert objGuarantors;
        
        objAD =  new Additional_Debt__c();
        objAD.Account__c = objBA.id;
        objAD.Civil_Litigation__c = 'No';
        objAD.Debt_Type__c = 'Personal Loan';
        objAD.Outstanding_Amount__c = 1500;
        objAD.Original_Debt_Amount__c = 1500;
        objAD.Monthly_Repayment__c = 1500;
        objAD.Legal_Entity__c = 'LE';
        //CRMS_Util.generateEndpoints();
        insert objAD;
    }
    
    
    static testMethod void testAccountPremise(){
        lstUKPremise = [Select r.Id, r.SobjectType ,r.DeveloperName
                    From RecordType r 
                    where r.SobjectType = 'Account' 
                    and r.DeveloperName = 'Premise_UK'];
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        initialize();
        Account objBA1 = new Account();
        objBA1.Name = 'UK Company';
        objBA1.TA_Floor_No__c = '4';
        objBA1.TA_Street_Number__c = '40';
        objBA1.TA_Street_Name__c = 'Street 40';
        //objBA1.TA_City__c = 'London';
        objBA1.TA_Postcode__c = 'LON101';
        objBA1.TA_Country__c = 'England';
        objBA1.TA_Address_Line_2__c = 'line 2';
        objBA1.TA_Address_Line_3__c = 'Line 3';
        objBA1.Business_Rates__c = 110;
        objBA1.RecordtypeId = lstUKPremise[0].Id;
        objBA1.Trading_Address_if_different__c = true;
        objBA1.ParentId = objBA.Id;
        insert objBA1;
        System.debug('objBA1^^^^^^^^^^^^^^^^^^^^^^^^'+objBA1.Id);        
        update objBA;
        
        Account objAcc1 = new Account();
        objAcc1.RecordTypeId = lstUKPA[0].Id;
        objAcc1.Salutation = 'Ms.';
        objAcc1.Salutation__pc = 'Sir.';
        objAcc1.FirstName = 'Ethan';
        objAcc1.LastName = 'Hunt';
        objAcc1.Gender__pc = 'Female';
        objAcc1.Marital_Status__pc = 'Married';
        objAcc1.Any_Dependents__pc = '2';
        objAcc1.Education_Level__pc = 'Secondary';
        objAcc1.Business_Position__pc = 'Owner';
        objAcc1.Percentage_of_the_Company_Ownership__pc = 60;
        objAcc1.Associated_Business__c = objBA.Id;
        objAcc1.Home_Floor_No__pc = '12';
        objAcc1.Home_Street_Number__pc = '12';
        objAcc1.PersonBirthdate = Date.Today().addYears(-28);
        objAcc1.Home_Street_Name__pc = '12th Street';
        //objAcc1.Home_City__pc = 'London';
        objAcc1.Home_Postcode__pc = 'LON101';
        objAcc1.Home_Country__pc = 'England';
        objAcc1.Property_Ownership__pc = 'Shop';
        objAcc1.Time_in_Country__c = '0-6 months';
        objAcc1.Time_at_this_Address_Months__c = '0-6 months';
        objAcc1.National_Insurance_Number__pc = 'NIC101';
        objAcc1.PersonMobilePhone = '4561237890';
        objAcc1.PersonEmail = 'ethan@test.com';
        objAcc1.Was_AMP_Client_Before__pc = 'No';
        objAcc1.Debt_Type__pc = 'Personal Loan';
        objAcc1.Lending_Entity__pc = 'LE';
        objAcc1.Original_Debt_Amount__c = 1500;
        objAcc1.Monthly_Repayment__pc = 15000;
        objAcc1.Outstanding_Amount__pc = 1500;
        objAcc1.Civil_Litigation__pc = 'Yes';
        objAcc1.Consent_to_Search__pc = 'Yes';
        insert objAcc1;
        CRMS_UKApplicationFormExtension objUk1 = new CRMS_UKApplicationFormExtension(
        new ApexPages.StandardController(objOpp));
        PageReference pageRef1 = Page.CRMS_ApplicationForm;
        pageRef1.getParameters().put('Id',objOpp.Id);
        Test.setCurrentPageReference(pageRef1);
        Guarantors__c objG = new Guarantors__c();
        Additional_Debt__c addDebtobj = new Additional_Debt__c();
        list<CRMS_UKApplicationFormExtension.debtDetails> lstD = new list<CRMS_UKApplicationFormExtension.debtDetails>();
        CRMS_UKApplicationFormExtension.ownerDetails ownerDetailsobj = 
        new CRMS_UKApplicationFormExtension.ownerDetails(objAcc1,objOpp,objG,true,false, true, lstD);
        CRMS_UKApplicationFormExtension.debtDetails debtDetailsobj = 
        new CRMS_UKApplicationFormExtension.debtDetails(addDebtobj,true,false);
        objUk1.lstWrapperToDisplay.add(new CRMS_UKApplicationFormExtension.ownerDetails (
            objAcc1, objOpp, objG, true, true, false,
            new List<CRMS_UKApplicationFormExtension.debtDetails> ()
        ));
        objUk1.lstDebt.add(new CRMS_UKApplicationFormExtension.debtDetails(addDebtobj,true,true));
        objUk1.lstWrapperToDisplay[0].objAcc = objAcc1;
        objUk1.lstWrapperToDisplay[0].objOpp = objOpp;
        objUk1.lstWrapperToDisplay[0].objGuarantor = objG;
        objUk1.lstWrapperToDisplay[0].counter = 1;
        objUk1.lstWrapperToDisplay[0].blnExisting = false; 
        objUk1.lstWrapperToDisplay[0].blndisplayBlock = false;
        objUk1.lstDebt[0].objDebt = addDebtobj;
        objUk1.lstDebt[0].blnDisplay = true;
        objUk1.lstDebt[0].blnExisting = false;
        objUk1.lstDebt[0].counter = 0;
        //objUk1.lstWrapperToDisplay[0].lstODGDebt[0] = objUk1.lstDebt[0];
        //objUk1.insertUpdatePremise();
        //objUk1.lstPremise.add(new CRMS_UKApplicationFormExtension.premiseInfo(objBA1,true));
        objAcc.Debt_Type__c = null;
        objUk1.saveOpp();
        
        objAcc.Debt_Type__c = 'Personal Loan';
        objUk1.saveOpp();
        system.assert(!objUk1.lstPremise.isEmpty());
    }
    
   static testMethod void testODGCompleteness(){
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        initialize();
        
        // load the page       
        PageReference pageRef1 = Page.CRMS_ApplicationForm;
        pageRef1.getParameters().put('Id',objOpp.Id);
        Test.setCurrentPageReference(pageRef1);
        
        // load the extension
        CRMS_UKApplicationFormExtension objUk1 = new CRMS_UKApplicationFormExtension(
        new ApexPages.StandardController(objOpp));
        objUk1.ODG_UK_Completeness(new CRMS_UKApplicationFormExtension.ownerDetails (
            objAcc, objOpp, objGuarantors, true, true, false,
            new List<CRMS_UKApplicationFormExtension.debtDetails>()));
        //objUk1.insertODG_ForNewlyInsertedPersonAccounts(objAcc);
    }
    
    static testMethod void testODGDebtCompleteness(){
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        initialize();
         
        // load the page       
        PageReference pageRef1 = Page.CRMS_ApplicationForm;
        pageRef1.getParameters().put('Id',objOpp.Id);
        Test.setCurrentPageReference(pageRef1);
        
        // load the extension
        Additional_Debt__c addDebtobj = new Additional_Debt__c();
        list<CRMS_UKApplicationFormExtension.debtDetails> lstD1 = new list<CRMS_UKApplicationFormExtension.debtDetails>();
        CRMS_UKApplicationFormExtension objUk1 = new CRMS_UKApplicationFormExtension(
        new ApexPages.StandardController(objOpp));
        objUk1.ODG_Debt_Completeness(lstD1);
    }
    
    static testMethod void testDisplayBlock(){
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        initialize();
        String occupiedStatus;
        // load the page       
        CRMS_UKApplicationFormExtension objUk1 = new CRMS_UKApplicationFormExtension(
        new ApexPages.StandardController(objOpp));
        PageReference pageRef1 = Page.CRMS_ApplicationForm;
        pageRef1.getParameters().put('Id',objOpp.Id);
        Test.setCurrentPageReference(pageRef1);
        Test.startTest();
        objUk1.addDebtDisclosure();
        objUk1.tradingAddAcc = true;
        objUk1.salutationChange();
        objUk1.tradingAddressAutoPopulate();
        objUk1.selectPersonAccount();
        //objUk1.displayBlock();
        objUk1.lstWrapperToDisplay.add(new CRMS_UKApplicationFormExtension.ownerDetails (
            objBA, objOpp, objGuarantors, true, true, false,
            new List<CRMS_UKApplicationFormExtension.debtDetails> ()
        ));
        objUk1.lstDebt.add(new CRMS_UKApplicationFormExtension.debtDetails(objAD,true,true));
        objUk1.saveOpp();
        system.debug(System.LoggingLevel.ERROR, 'ERROR*****' + Apexpages.getMessages());
        Test.stopTest();
        
    }
    
    static testMethod void trading_address_test(){
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        initialize();
        // load the page       
        CRMS_UKApplicationFormExtension objUk1 = new CRMS_UKApplicationFormExtension(
        new ApexPages.StandardController(objOpp));
        PageReference pageRef1 = Page.CRMS_ApplicationForm;
        pageRef1.getParameters().put('Id',objOpp.Id);
        Test.setCurrentPageReference(pageRef1);
        test.startTest();
        //objUk1.tradingAddAcc = true;
        objBA.Trading_Address_if_different__c = true;
        objBA.TA_Floor_No__c = '4';
        objBA.TA_Street_Number__c = '40';
        objBA.TA_Street_Name__c = 'Street 40';
        //objBA.TA_City__c = 'London';
        objBA.TA_Postcode__c = 'LON101';
        objBA.TA_Country__c = 'England';
        objBA.TA_Address_Line_2__c = 'line 2';
        objBA.TA_Address_Line_3__c = 'Line 3';
        update objBA;
        objUk1.tradingAddress_Completeness();
        //objUk1.saveOpp();
        //System.assertEquals(true,objBA.Trading_Address_if_different__c);
        objOpp.Has_any_Relationship_with_AMP_Directors__c = 'Yes';
        update objOpp;
        objUk1.disableBlock();
        objUk1.saveOpp();
        system.assert(objUk1.tradingAddAcc = true);
        test.stopTest();
    }
    
    static testMethod void addPremiseTest(){
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        initialize();
        //Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        PageReference pageRef1 = Page.CRMS_ApplicationForm;
        pageRef1.getParameters().put('Id',objOpp.Id);
        Test.setCurrentPageReference(pageRef1);
        CRMS_UKApplicationFormExtension objUk1 = new CRMS_UKApplicationFormExtension(
        new ApexPages.StandardController(objOpp));
        //objUk1.tradingAddAcc = true;
        
        Test.startTest();
       // objAcc = [select id,Name,Trading_Address_if_different__c from Account where Name =:'UK Company'];
        
        // load the extension
        objUk1.tradingAddAcc = true;
        objUk1.addPremise();
        objUk1.addPremise();
        objUk1.premise_Completeness();
        System.assertEquals(2,objUk1.lstPremise.size());
        Test.stopTest();
    }
    
    static testMethod void removePremiseTest(){
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        initialize();
        //Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        PageReference pageRef1 = Page.CRMS_ApplicationForm;
        pageRef1.getParameters().put('Id',objOpp.Id);
        Test.setCurrentPageReference(pageRef1);
        
        Test.startTest();
        objAcc = [select id,Name,Trading_Address_if_different__c from Account where Name =:'UK Company'];
        
        // load the extension
        CRMS_UKApplicationFormExtension objUk1 = new CRMS_UKApplicationFormExtension(
        new ApexPages.StandardController(objOpp));
        objUk1.addPremise();
        objUk1.addPremise();
        objUk1.deleteIndex= 0 ;
        objUk1.removePremise();
        objUk1.tradingAddAcc = true;
        System.assertEquals(1,objUk1.lstPremise.size());
        Test.stopTest();
    } 
    
    static testMethod void testRented() 
    {
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        initialize();
        
        String occupiedStatus;
        // load the page       
        CRMS_UKApplicationFormExtension objUk1 = new CRMS_UKApplicationFormExtension(
        new ApexPages.StandardController(objOpp));
        
        
        PageReference pageRef1 = Page.CRMS_ApplicationForm;
        pageRef1.getParameters().put('Id',objOpp.Id);
        Test.setCurrentPageReference(pageRef1);
        test.startTest();
        
        // load the extension
        objBA.Self_Owned_Rented__c ='Rented';
        objBA.Operating_Days_Per_Week__c = '7';
        objBA.Operating_Hours_Per_Day__c = '09';
        objBA.Total_No_of_Staff__c = '4';
        objBA.Total_Staff_Cost__c = 1400;
        objBA.Other_Operating_Costs__c = 900000;
        objBA.Time_at_this_Address_Months__c = '0-6 months';
        objBA.Time_in_Country__c = '0-6 months';
        objBA.Rental_Security_Deposit__c = 8789;
        objBA.Months_Left_on_the_Lease__c = '8';
        objBA.Paid_for_the_Month_Of__c = '02';
        objBA.Paid_for_the_amount_of__c = 12121;
        objBA.Number_of_Months_in_Arrears_if_any__c = '01';
        update objBA;
        objUk1.accountOwnership_Rented_Completeness();
        objUk1.saveOpp();
        objUk1.occupiedStatus();
        test.stopTest();
    }
    
    static testMethod void testaccountDebt_Completeness(){
        initialize();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        String occupiedStatus;                  
        // load the page       
        CRMS_UKApplicationFormExtension objUk1 = new CRMS_UKApplicationFormExtension(
        new ApexPages.StandardController(objOpp));
        
        PageReference pageRef1 = Page.CRMS_ApplicationForm;
        pageRef1.getParameters().put('Id',objOpp.Id);
        Test.setCurrentPageReference(pageRef1);
        objUk1.accountDebt_Completeness();
        objUk1.accountOpportunityBasicInfo_Completeness();
        
        objUk1.businessDebt_Completeness();
    }
   
    static testMethod void  testEmployeeOfAMP(){
        initialize();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        String occupiedStatus;                  
        // load the page       
        CRMS_UKApplicationFormExtension objUk1 = new CRMS_UKApplicationFormExtension(
        new ApexPages.StandardController(objOpp));
        
        PageReference pageRef1 = Page.CRMS_ApplicationForm;
        pageRef1.getParameters().put('Id',objOpp.Id);
        Test.setCurrentPageReference(pageRef1);
        objOpp.Has_any_Relationship_with_AMP_Directors__c = 'Yes';
        objUk1.disableBlock();
        System.assertEquals(true,objUk1.boolRelationShip);
     }
     
   static testMethod void testAddDebt(){
       Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
       initialize();
        
        // load the page       
        PageReference pageRef1 = Page.CRMS_ApplicationForm;
        pageRef1.getParameters().put('Id',objOpp.Id);
        Test.setCurrentPageReference(pageRef1);
        
        // load the extension
        CRMS_UKApplicationFormExtension objUk1 = new CRMS_UKApplicationFormExtension(
        new ApexPages.StandardController(objOpp));
        objUk1.addDebt();
        
        //system.assertEquals(1,CRMS_UKApplicationFormExtension.debtRowCount);
        objUk1.deleteIndex = 0;
        objUk1.removeDebt();
        //system.assertEquals(1,CRMS_UKApplicationFormExtension.debtRowCount);
        objUk1.tradingAddAcc = true;
        objUk1.saveOpp();
    }
    
    static testMethod void testODGdebt(){
       Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
       initialize();
        
        // load the page       
        PageReference pageRef1 = Page.CRMS_ApplicationForm;
        pageRef1.getParameters().put('Id',objOpp.Id);
        Test.setCurrentPageReference(pageRef1);
        
        // load the extension
        CRMS_UKApplicationFormExtension objUk1 = new CRMS_UKApplicationFormExtension(
        new ApexPages.StandardController(objOpp));
        objUk1.addODGDebt();
        
        system.assertEquals(1,CRMS_UKApplicationFormExtension.debtRowCount);
        objUk1.deleteIndex = 0;
        objUk1.removeODGDebt();
        //system.assertEquals(0,CRMS_UKApplicationFormExtension.debtRowCount);
        objUk1.tradingAddAcc = true;
        system.debug(System.LoggingLevel.ERROR, 'objOpportunity' + objUk1.objOpportunity + '----' + objUk1.accountInfo);
        objUk1.saveOpp();
    }
    
    static testMethod void testRemoveBlock() {
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        initialize();
        
        // load the page       
        PageReference pageRef1 = Page.CRMS_ApplicationForm;
        pageRef1.getParameters().put('Id',objOpp.Id);
        Test.setCurrentPageReference(pageRef1);
        
        // load the extension
        CRMS_UKApplicationFormExtension objUk1 = new CRMS_UKApplicationFormExtension(
        new ApexPages.StandardController(objOpp));
        objUk1.displayBlock();
        objUk1.deleteIndex = 0;
        objUk1.RemoveBlock();
        objUk1.saveOpp();
        system.assert(!objUk1.lstWrapperToDisplay.isEmpty());
    }
    
    static testMethod void testPA_Addition() 
    {
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        initialize();
        
        // load the page       
        PageReference pageRef1 = Page.CRMS_ApplicationForm;
        pageRef1.getParameters().put('Id',objOpp.Id);
        Test.setCurrentPageReference(pageRef1);
        
        // load the extension
        CRMS_UKApplicationFormExtension objUk1 = new CRMS_UKApplicationFormExtension(
        new ApexPages.StandardController(objOpp));
        objUk1.displayBlock();
        System.debug(System.LoggingLevel.ERROR ,'objUk1.lstWrapperToDisplay*****'+objUk1.lstWrapperToDisplay);
        objUk1.tradingAddAcc = true;
        objUk1.saveOpp();
     }
     
     private static void initialize_PP()
        {
        CRMS_Util.generateEndpoints();
        lstPPBA = [Select r.SobjectType, r.Id, r.DeveloperName 
                    From RecordType r 
                    where r.SobjectType = 'Account' 
                    and r.DeveloperName = 'Prospect_Philippines'];
                    
        lstPPPA = [select Id from RecordType r where r.SobjectType = 'Account'
                    and r.DeveloperName = 'Person_Philippines'];
        
        lstPPApplication = [Select r.SobjectType, r.Name, r.Id, r.DeveloperName 
                            From RecordType r where r.SobjectType = 'Opportunity' 
                            and r.DeveloperName = 'Application_Philippines'];
        
        objBAPP = new Account();
        objBAPP.Name = 'PP Company';
        objBAPP.RecordtypeId = lstPPBA[0].Id;
        objBAPP.Business_Legal_Name__c = 'PP Company Co.';
        objBAPP.AccountNumber = 'PPACC01';
        objBAPP.Business_Nature_Category__c = 'Food Services';
        objBAPP.Business_Nature_Type__c = 'Bakeries [5462]';
        objBAPP.Sic = 'PPSIC';
        objBAPP.Entity_Type__c = 'LLP';        
        objBAPP.LE_Floor_No__c = '4';
        objBAPP.LE_Street_Number__c = '40';
        objBAPP.LE_Street_Name__c = 'Street 40';
        //objBAPP.LE_City__c = 'Phil';
        objBAPP.LE_Postcode__c = 'LON101';
        objBAPP.LE_Country__c = 'Philippines';
        objBAPP.LE_District__c = 'pp';
        objBAPP.LE_Region__c = 'pp';
        objBAPP.Years_in_Business__c = '5';
        objBAPP.Phone = '9865329865';
        objBAPP.Fax = '7845784578';
        objBAPP.Business_Email_Address__c = 'user@test.com';
        objBAPP.Website = 'www.ppcompany.com';
        objBAPP.Trading_Address_if_different__c = true;
        objBAPP.TA_Floor_No__c = '4';
        objBAPP.TA_Street_Number__c = '40';
        objBAPP.TA_Street_Name__c = 'Street 40';
        objBAPP.TA_District__c = 'pp';
        objBAPP.TA_Region__c = 'pp';
        objBAPP.TA_Postcode__c = 'LON101';
        objBAPP.TA_Country__c = 'Philippines';
        objBAPP.Type_of_Premises__c = 'Shop';
        objBAPP.Self_Owned_Rented__c = 'Other';
        objBAPP.Property_Owner_First_Name__c = 'James';
        objBAPP.Property_Owner_Last_Name__c = 'Brown';
        objBAPP.Property_Owner_Contact_Number__c = '7417417410';
        objBAPP.Operating_Days_Per_Week__c = '5';
        objBAPP.Operating_Hours_Per_Day__c = '8';
        objBAPP.Total_No_Of_Staff__c = '5';
        objBAPP.Other_Operating_Costs__c = 56565;
        objBAPP.Total_Staff_Cost__c = 50000;
        objBAPP.Time_in_Country__c = '0-6 months';
        objBAPP.Time_at_this_Address_Months__c = '0-6 months';
        objBAPP.Monthly_Rent__c = 9000;
        objBAPP.Monthly_Mortgage_Payments__c = 3500;
        objBAPP.Debt_Type__c = 'Overdraft';
        objBAPP.Rental_Security_Deposit__c = 35000;
        objBAPP.Original_Debt_Amount__c = 50000;
        objBAPP.Monthly_Repayment__c = 2500;
        objBAPP.Outstanding_Debt_Amount__c = 35000;
        objBAPP.Months_Left_on_the_Lease__c = '3';
        objBAPP.Paid_for_the_Month_Of__c = 'Jan';
        objBAPP.Paid_for_the_amount_of__c = 6000;
        objBAPP.Number_of_Months_in_Arrears_if_any__c = '5';
        objBAPP.Civil_Litigation__c = 'Yes';
        objBAPP.Business_Rates__c = 5600;        
        objBAPP.ParentId = objBAPP.Id;
        //CRMS_Util.generateEndpoints();
        insert objBAPP;
        
        objAccpp = new Account();
        objAccpp.RecordTypeId = lstPPPA[0].Id;
        objAccpp.Salutation = 'Ms.';
        objAccpp.Salutation__pc = 'Ms.';
        objAccpp.FirstName = 'Ethan';
        objAccpp.LastName = 'Hunt';
        objAccpp.Gender__pc = 'Female';
        objAccpp.Marital_Status__pc = 'Married';
        objAccpp.Any_Dependents__pc = '2';
        objAccpp.Education_Level__pc = 'Secondary';
        objAccpp.Business_Position__pc = 'Owner';
        objAccpp.Percentage_of_the_Company_Ownership__pc = 60;
        objAccpp.Associated_Business__c = objBAPP.Id;
        objAccpp.Home_Floor_No__pc = '12';
        objAccpp.Home_Street_Number__pc = '12';
        objAccpp.PersonBirthdate = Date.Today().addYears(-18).addDays(1);
        objAccpp.Home_Street_Name__pc = '12th Street';
        objAccpp.Home_Postcode__pc = 'LON101';
        objAccpp.Home_Country__pc = 'Philippines';
        objAccpp.Property_Ownership__pc = 'Shop';
        objAccpp.Time_in_Country__c = '0-6 months';
        objAccpp.Time_at_this_Address_Months__c = '0-6 months';
        //objAccpp.National_Insurance_Number__pc = 'NIC101';
        objAccpp.PersonMobilePhone = '4561237890';
        objAccpp.PersonEmail = 'ethan@test.com';
        objAccpp.Was_AMP_Client_Before__pc = 'No';
        objAccpp.Civil_Litigation__pc = 'Yes';
        objAccpp.Consent_to_Search__pc = 'Yes';
        insert objAccpp;
        
        objOpp1 = new Opportunity();
        objOpp1.Name = 'testOpp';
        objOpp1.RecordtypeId = lstPPApplication[0].Id;
        objOpp1.Amount = 1000;
        objOpp1.CloseDate = date.Today() + 30;
        objOpp1.StageName = 'In Progress';
        objOpp1.AccountId = objBAPP.Id;
        objOpp1.Country__c = 'Philippines';
        objOpp1.Loan_Purpose__c = 'Expansion';
        objOpp1.Requested_Loan_Term__c = '09 (270 days)';
        objOpp1.Average_Monthly_Card_Sales__c = 10000;
        objOpp1.Ave_Monthly_Sales__c = 20000;
        objOpp1.Monthly_Rental__c = 1500;
        objOpp1.Monthly_Interest__c = 2.5;
        objOpp1.Agreed_that_no_Relationship_Exists__c = true;
        objOpp1.Has_any_Relationship_with_AMP_Directors__c = 'Yes';
        objOpp1.Name_of_AMP_Personnel__c = 'test';
        objOpp1.Relationship_to_the_Applicant__c = 'brother';
        objOpp1.Person_Account__c = objAccpp.id;
        //CRMS_Util.generateEndpoints();
        insert objOpp1;
        objOpp1.Has_any_Relationship_with_AMP_Directors__c = '--None--';
        //CRMS_Util.generateEndpoints();
        update objOpp1;
       
        objGuarantorsPP = new Guarantors__c();
        objGuarantorsPP.Opportunity__c = objOpp1.id;
        objGuarantorsPP.Account__c = objAccpp.id;
        objGuarantorsPP.Consent_to_Search__c = 'Yes';
        objGuarantorsPP.Account_Role__c = 'Owner';
        objGuarantorsPP.Required_Bank_Signatory__c = true;
        //CRMS_Util.generateEndpoints();
        insert objGuarantorsPP;
        
        objADPP =  new Additional_Debt__c();
        objADPP.Account__c = objBAPP.id;
        objADPP.Civil_Litigation__c = 'No';
        objADPP.Debt_Type__c = 'Personal Loan';
        objADPP.Outstanding_Amount__c = 1500;
        objADPP.Original_Debt_Amount__c = 1500;
        objADPP.Monthly_Repayment__c = 1500;
        objADPP.Legal_Entity__c = 'LE';
        //CRMS_Util.generateEndpoints();
        insert objADPP;
      }
      
    static testMethod void testAccountPremise_PP(){
        lstPPPremise = [Select r.SobjectType, r.Id, r.DeveloperName 
                    From RecordType r 
                    where r.SobjectType = 'Account' 
                    and r.DeveloperName = 'Premise_Philippines'];
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        initialize_PP();
        Account objBA2 = new Account();
        objBA2.Name = 'PP Company';
        objBA2.TA_Floor_No__c = '4';
        objBA2.TA_Street_Number__c = '40';
        objBA2.TA_Street_Name__c = 'Street 40';
        objBA2.TA_Postcode__c = 'PP101';
        objBA2.TA_District__c = 'PP'; 
        objBA2.TA_Country__c = 'Philippines';
        objBA2.TA_Region__c = 'PP';
        objBA2.RecordtypeId = lstPPPremise[0].Id;
        objBA2.Trading_Address_if_different__c = true;
        objBA2.ParentId = objBAPP.Id;
        insert objBA2;
        
        
        update objBAPP;
        CRMS_UKApplicationFormExtension objUk1 = new CRMS_UKApplicationFormExtension(
        new ApexPages.StandardController(objOpp1));
        PageReference pageRef1 = Page.CRMS_ApplicationForm;
        pageRef1.getParameters().put('Id',objOpp1.Id);
        Test.setCurrentPageReference(pageRef1);
        objOpp1.Has_any_Relationship_with_AMP_Directors__c = null;
        update objOpp1;
        //objUk1.lstPremise.add(new CRMS_UKApplicationFormExtension.premiseInfo(objBA2,true));
        objUk1.accountOpportunityBasicInfo_Completeness(); 
        objUk1.saveOpp();
        system.assert(!objUk1.lstPremise.isEmpty());
        objUk1.saveOpp();   
    }
    
    static testMethod void testNonPPResident(){
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        initialize_PP();
        
        String occupiedStatus;                  
        // load the page       
        CRMS_UKApplicationFormExtension objUk1 = new CRMS_UKApplicationFormExtension(
        new ApexPages.StandardController(objOpp1));
        PageReference pageRef1 = Page.CRMS_ApplicationForm;
        pageRef1.getParameters().put('Id',objOpp1.Id);
        Test.setCurrentPageReference(pageRef1);
        
        objAccpp.Residency_Status__pc = 'Citizen';
        objAccpp.Valid_ID__pc = 'PP3555';
        objuk1.strCountry = 'Philippines';
        objUK1.rowODGCount = 0;
        objUk1.residencyStatusChange();
        objUk1.residencyStatusCompleteness(new CRMS_UKApplicationFormExtension.ownerDetails (
            objAccpp, objOpp1, objGuarantorspp, true, true, false,
            new List<CRMS_UKApplicationFormExtension.debtDetails> ()));
        objAccpp.Residency_Status__pc='Permanent Resident Alien';
        objAccpp.Other_ID__pc = 'Test';
        objAccpp.ECR__pc = 3555;
        objuk1.strCountry = 'Philippines';
        objUK1.rowODGCount = 0;
        objAccpp.Valid_ID__pc = 'PP3555';
        objUK1.residencyStatusChange();
        objUk1.ODG_UK_Completeness(new CRMS_UKApplicationFormExtension.ownerDetails (
            objAccSG, objOppSG, objGuarantorsSG, true, true, false,
            new List<CRMS_UKApplicationFormExtension.debtDetails> ()));
        objUk1.residencyStatusCompleteness(new CRMS_UKApplicationFormExtension.ownerDetails (
            objAccSG, objOppSG, objGuarantorsSG, true, true, false,
            new List<CRMS_UKApplicationFormExtension.debtDetails> ()));
    }
    
    static testMethod void testOwnedRented_Other() 
    {
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        initialize_PP();
        
        String occupiedStatus;                  
        // load the page       
        CRMS_UKApplicationFormExtension objUk1 = new CRMS_UKApplicationFormExtension(
        new ApexPages.StandardController(objOpp1));
        PageReference pageRef1 = Page.CRMS_ApplicationForm;
        pageRef1.getParameters().put('Id',objOpp1.Id);
        Test.setCurrentPageReference(pageRef1);
        test.startTest();
        // load the extension
        objBAPP.Self_Owned_Rented__c ='Other';
        objBAPP.Operating_Days_Per_Week__c = '7';
        objBAPP.Operating_Hours_Per_Day__c = '09';
        objBAPP.Total_No_of_Staff__c = '4';
        objBAPP.Total_Staff_Cost__c = 1400;
        objBAPP.Other_Operating_Costs__c = 900000;
        objBAPP.Time_at_this_Address_Months__c = '0-6 months';
        update objBAPP;
        //objUk1.tradingAddAcc = false; 
        objUk1.occupiedStatus();
        objUk1.accountOwnership_Others_Completeness();
        objUk1.saveOpp();
        
        objUk1.tradingAddress_Completeness();
        test.stopTest();
    }
    
    static testMethod void removePremiseTest1(){
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        initialize_PP();
        //Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        PageReference pageRef1 = Page.CRMS_ApplicationForm;
        pageRef1.getParameters().put('Id',objOpp1.Id);
        Test.setCurrentPageReference(pageRef1);
        
        Test.startTest();
        objAccpp = [select id,Name,Trading_Address_if_different__c from Account where Name =:'PP Company'];
        
        // load the extension
        CRMS_UKApplicationFormExtension objUk1 = new CRMS_UKApplicationFormExtension(
        new ApexPages.StandardController(objOpp1));
        objUk1.addPremise();
        objUk1.addPremise();
        objUk1.deleteIndex= 0 ;
        objUk1.removePremise();
        objUk1.tradingAddAcc = true;
        System.assertEquals(1,objUk1.lstPremise.size());
        Test.stopTest();
    } 
    
    //Initialise class for Hong Kong
    private static void initialize_HK()
    {
        CRMS_Util.generateEndpoints();
        lstHKBA = [Select r.SobjectType, r.Id, r.DeveloperName 
                    From RecordType r 
                    where r.SobjectType = 'Account' 
                    and r.DeveloperName = 'Prospect_Hong_Kong'];
                    
        lstHKPA = [select Id from RecordType r where r.SobjectType = 'Account'
                    and r.DeveloperName = 'Person_Hong_Kong'];
        
        lstHKApplication = [Select r.SobjectType, r.Name, r.Id, r.DeveloperName 
                            From RecordType r where r.SobjectType = 'Opportunity' 
                            and r.DeveloperName = 'Application_Hong_Kong'];
        
        objBAHK = new Account();
        objBAHK.Name = 'HK Company';
        objBAHK.RecordtypeId = lstHKBA[0].Id;
        objBAHK.Business_Legal_Name__c = 'HK Company Co.';
        objBAHK.AccountNumber = 'HKACC01';
        objBAHK.Business_Nature_Category__c = 'Food Services';
        objBAHK.Business_Nature_Type__c = 'Bakeries [5462]';
        objBAHK.Sic = 'UKSIC';
        objBAHK.Entity_Type__c = 'LLP';
        
        objBAHK.LE_Floor_No__c = '4';
        objBAHK.LE_Street_Number__c = '40';
        objBAHK.LE_Street_Name__c = 'Street 40';
        //objBAHK.LE_City__c = 'Shanghai';
        objBAHK.LE_Postcode__c = 'LON101';
        objBAHK.LE_Country__c = 'Hong Kong';
        objBAHK.LE_District__c = 'HK';
        objBAHK.LE_Region__c = 'HK';
        objBAHK.Years_in_Business__c = '5';
        objBAHK.Phone = '9865329865';
        objBAHK.Fax = '7845784578';
        objBAHK.Business_Email_Address__c = 'user@test.com';
        objBAHK.Website = 'www.ukcompany.com';
        objBAHK.Trading_Address_if_different__c = false;
        objBAHK.Type_of_Premises__c = 'Shop';
        objBAHK.Self_Owned_Rented__c = 'Self-Owned';
        objBAHK.Operating_Days_Per_Week__c = '5';
        objBAHK.Operating_Hours_Per_Day__c = '8';
        objBAHK.Total_No_Of_Staff__c = '5';
        objBAHK.Other_Operating_Costs__c = 56565;
        objBAHK.Total_Staff_Cost__c = 50000;
        objBAHK.Time_in_Country__c = '0-6 months';
        objBAHK.Time_at_this_Address_Months__c = '0-6 months';
        objBAHK.Monthly_Rent__c = 9000;
        objBAHK.Monthly_Mortgage_Payments__c = 3500;
        objBAHK.Debt_Type__c = 'Overdraft';
        objBAHK.Rental_Security_Deposit__c = 35000;
        objBAHK.Original_Debt_Amount__c = 50000;
        objBAHK.Monthly_Repayment__c = 2500;
        objBAHK.Outstanding_Debt_Amount__c = 35000;
        objBAHK.Months_Left_on_the_Lease__c = '3';
        objBAHK.Paid_for_the_Month_Of__c = 'Jan';
        objBAHK.Paid_for_the_amount_of__c = 6000;
        objBAHK.Number_of_Months_in_Arrears_if_any__c = '5';
        objBAHK.Civil_Litigation__c = 'Yes';
        objBAHK.Business_Rates__c = 5600;
        
        objBAHK.TA_Street_Number__c = '40';
        objBAHK.TA_Street_Name__c = 'Street 40';
        objBAHK.TA_Postcode__c = 'PP101';
        objBAHK.TA_District__c = 'hk'; 
        objBAHK.TA_Country__c = 'Hong Kong';
        objBAHK.TA_Region__c = 'hk';
        objBAHK.ParentId = objBAHK.Id;
        //CRMS_Util.generateEndpoints();
        insert objBAHK;
        
        objAccHK = new Account();
        objAccHK.RecordTypeId = lstHKPA[0].Id;
        objAccHK.Salutation = 'Ms.';
        objAccHK.Salutation__pc = 'Ms.';
        objAccHK.FirstName = 'Ethan';
        objAccHK.LastName = 'Hunt';
        objAccHK.Gender__pc = 'Female';
        objAccHK.Marital_Status__pc = 'Married';
        objAccHK.Any_Dependents__pc = '2';
        objAccHK.Education_Level__pc = 'Secondary';
        objAccHK.Business_Position__pc = 'Owner';
        objAccHK.Percentage_of_the_Company_Ownership__pc = 60;
        objAccHK.Associated_Business__c = objBAHK.Id;
        objAccHK.Home_Floor_No__pc = '12';
        objAccHK.Home_Street_Number__pc = '12';
        objAccHK.PersonBirthdate = Date.Today().addYears(-18).addDays(-1);
        objAccHK.Home_Street_Name__pc = '12th Street';
        objAccHK.Home_Postcode__pc = 'LON101';
        objAccHK.Home_Country__pc = 'Hong Kong';
        objAccHK.Property_Ownership__pc = 'Shop';
        objAccHK.Time_in_Country__c = '0-6 months';
        objAccHK.Time_at_this_Address_Months__c = '0-6 months';
        objAccHK.Residency_Status__pc = 'Permanent Resident';
        objAccHK.HKID_Card_No__pc = 'C546234(5)';
        objAccHK.Passport_Number__pc = '565656';
        objAccHK.Passport_County_of_issues__pc = 'Hong kong';
        objAccHK.Passport_Expiry_Date__pc = date.newInstance(2019, 06, 15);
        objAccHK.PersonMobilePhone = '4561237890';
        objAccHK.PersonEmail = 'ethan@test.com';
        objAccHK.Was_AMP_Client_Before__pc = 'No';
        objAccHK.Civil_Litigation__pc = 'Yes';
        objAccHK.Consent_to_Search__pc = 'Yes';
        //CRMS_Util.generateEndpoints();
       insert objAccHK;
        
        objOppHK = new Opportunity();
        objOppHK.Name = 'testOHK';
        objOppHK.RecordtypeId = lstHKApplication[0].Id;
        objOppHK.Amount = 1000;
        objOppHK.CloseDate = date.Today() + 30;
        objOppHK.StageName = 'In Progress';
        objOppHK.AccountId = objBAHK.Id;
        objOppHK.Country__c = 'Hong Kong';
        objOppHK.Loan_Purpose__c = 'Expansion';
        objOppHK.Requested_Loan_Term__c = '09 (270 days)';
        objOppHK.Average_Monthly_Card_Sales__c = 10000;
        objOppHK.Ave_Monthly_Sales__c = 20000;
        objOppHK.Monthly_Rental__c = 1500;
        objOppHK.Monthly_Interest__c = 2.5;
        objOppHK.Has_any_Relationship_with_AMP_Directors__c = 'Yes';
        objOppHK.Name_of_AMP_Personnel__c = 'test';
        objOppHK.Relationship_to_the_Applicant__c = 'brother';
        objOppHK.Person_Account__c = objAccHK.id;
        //CRMS_Util.generateEndpoints();
        insert objOppHK;
        objOppHK.Has_any_Relationship_with_AMP_Directors__c = 'Yes';
        //CRMS_Util.generateEndpoints();
        update objOppHK;
       
        objGuarantorsHK = new Guarantors__c();
        objGuarantorsHK.Opportunity__c = objOppHK.id;
        objGuarantorsHK.Account__c = objAccHK.id;
        objGuarantorsHK.Consent_to_Search__c = 'Yes';
        objGuarantorsHK.Account_Role__c = 'Owner';
        objGuarantorsHK.Required_Bank_Signatory__c = false;
        //CRMS_Util.generateEndpoints();
        insert objGuarantorsHK;
        
        objADHK =  new Additional_Debt__c();
        objADHK.Account__c = objBAHK.id;
        objADHK.Civil_Litigation__c = 'No';
        objADHK.Debt_Type__c = null;

        //CRMS_Util.generateEndpoints();
        insert objADHK;
      }
    static testMethod void testAccountPremise_HK(){
        lstHKPremise = [Select r.SobjectType, r.Id, r.DeveloperName 
                    From RecordType r 
                    where r.SobjectType = 'Account' 
                    and r.DeveloperName = 'Premise_Hong_Kong'];
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        initialize_HK();
        Account objBA2 = new Account();
        objBA2.Name = 'HK Company';
        objBA2.RecordtypeId = lstHKPremise[0].Id;
        objBA2.TA_Street_Number__c = '40';
        objBA2.TA_Street_Name__c = 'Street 40';
        objBA2.TA_Postcode__c = 'PP101';
        objBA2.TA_District__c = 'hk'; 
        objBA2.TA_Country__c = 'Hong Kong';
        objBA2.TA_Region__c = 'hk';
        objBA2.TA_Building_Name__c= 'Prince';
        objBA2.TA_Floor_No__c = '56';
        objBA2.ParentId = objBAHK.Id;
        objBA2.Trading_Address_if_different__c = true ;
        insert objBA2;
        
        update objBAHK;
        CRMS_UKApplicationFormExtension objUk1 = new CRMS_UKApplicationFormExtension(
        new ApexPages.StandardController(objOppHK));
        PageReference pageRef1 = Page.CRMS_ApplicationForm;
        pageRef1.getParameters().put('Id',objOppHK.Id);
        Test.setCurrentPageReference(pageRef1);
        //objUk1.lstPremise.add(new CRMS_UKApplicationFormExtension.premiseInfo(objBA2,true));
        objUk1.accountOpportunityBasicInfo_Completeness(); 
        objUk1.saveOpp();
        system.assert(!objUk1.lstPremise.isEmpty());
        objUk1.saveOpp();   
    }
    static testMethod void testSelf_OwnedRented() 
    {
        initialize_HK();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        String occupiedStatus;                  
        // load the page       
        CRMS_UKApplicationFormExtension objUk1 = new CRMS_UKApplicationFormExtension(
        new ApexPages.StandardController(objOppHK));
        
        
        PageReference pageRef1 = Page.CRMS_ApplicationForm;
        pageRef1.getParameters().put('Id',objOppHK.Id);
        Test.setCurrentPageReference(pageRef1);
        // load the extension
        test.startTest();
        objBAHK.Self_Owned_Rented__c ='Self-Owned';
        objBAHK.Operating_Days_Per_Week__c = '7';
        objBAHK.Operating_Hours_Per_Day__c = '09';
        objBAHK.Total_No_of_Staff__c = '4';
        objBAHK.Total_Staff_Cost__c = 1400;
        objBAHK.Other_Operating_Costs__c = 900000;
        objBAHK.Time_at_this_Address_Months__c = '0-6 months';
        update objBAHK;
        //objUk1.tradingAddAcc = true;
        objUk1.occupiedStatus();
        objUk1.accountOwnership_Others_Completeness();
        objUk1.saveOpp();
        test.stopTest();
    }
    static testMethod void testNotPermanentResident(){
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        initialize_HK();
        
        String occupiedStatus;                  
        // load the page       
        CRMS_UKApplicationFormExtension objUk1 = new CRMS_UKApplicationFormExtension(
        new ApexPages.StandardController(objOppHK));
        PageReference pageRef1 = Page.CRMS_ApplicationForm;
        pageRef1.getParameters().put('Id',objOppHK.Id);
        Test.setCurrentPageReference(pageRef1);
        test.startTest();
        objAccHK.Residency_Status__pc='Permanent Resident';
        objAccHK.HKID_Card_No__pc = 'A182361(5)';
        objUK1.rowODGCount = 0;
        objUK1.residencyStatusChange();
        objUk1.residencyStatusCompleteness(new CRMS_UKApplicationFormExtension.ownerDetails (
            objAccHK, objOppHK, objGuarantorsHK, true, true, false,
            new List<CRMS_UKApplicationFormExtension.debtDetails> ()));
        objAccHK.Residency_Status__pc='Non-HK Resident';
        objAccHK.Passport_Expiry_Date__pc = date.newInstance(2019, 06, 15);
        objAccHK.Passport_Number__pc = '4H4456';
        objAccHK.Passport_County_of_issues__pc = 'HK';
        objAccHK.Time_at_this_Address_Months__c = '0-6 months';
        objUK1.rowODGCount = 0;
        objUK1.residencyStatusChange();
        objUk1.residencyStatusCompleteness(new CRMS_UKApplicationFormExtension.ownerDetails (
            objAccHK, objOppHK, objGuarantorsHK, true, true, false,
            new List<CRMS_UKApplicationFormExtension.debtDetails> ()));
        objAccHK.Residency_Status__pc='Non-Permanent Resident';
        objAccHK.HKID_Card_No__pc = 'C546234(5)';
        objAccHK.Passport_Expiry_Date__pc = date.newInstance(2019, 06, 15);
        objAccHK.Passport_Number__pc = '4H4456';
        objAccHK.Passport_County_of_issues__pc = 'HK';
        objAccHK.Time_at_this_Address_Months__c = '0-6 months';
        objUK1.rowODGCount = 0;
        objUK1.residencyStatusChange();
        update objAccHK;
        objUk1.residencyStatusCompleteness(new CRMS_UKApplicationFormExtension.ownerDetails (
            objAccHK, objOppHK, objGuarantorsHK, true, true, false,
            new List<CRMS_UKApplicationFormExtension.debtDetails> ()));
    }
    
    //Initialise class for Singapore
    private static void initialize_SG()
    {
        CRMS_Util.generateEndpoints();
        lstSGBA = [Select r.SobjectType, r.Id, r.DeveloperName 
                    From RecordType r 
                    where r.SobjectType = 'Account' 
                    and r.DeveloperName = 'Prospect_Singapore'];
                    
        lstSGPA = [select Id from RecordType r where r.SobjectType = 'Account'
                    and r.DeveloperName = 'Person_Singapore'];
        
        lstSGApplication = [Select r.SobjectType, r.Name, r.Id, r.DeveloperName 
                            From RecordType r where r.SobjectType = 'Opportunity' 
                            and r.DeveloperName = 'Application_Singapore'];
        
        objBASG = new Account();
        objBASG.Name = 'SG Company';
        objBASG.RecordtypeId = lstSGBA[0].Id;
        objBASG.Business_Legal_Name__c = 'SG Company Co.';
        objBASG.AccountNumber = 'SGACC01';
        objBASG.Business_Nature_Category__c = 'Food Services';
        objBASG.Business_Nature_Type__c = 'Bakeries [5462]';
        objBASG.Sic = 'SGSIC';
        objBASG.Entity_Type__c = 'LLP';
        
        objBASG.LE_Floor_No__c = '4';
        objBASG.LE_Street_Number__c = '40';
        objBASG.LE_Street_Name__c = 'Street 40';
        objBASG.LE_Postcode__c = 'LON101';
        objBASG.LE_Country__c = 'Singapore';
        objBASG.LE_District__c = 'SG';
        objBASG.LE_Region__c = 'SG';
        objBASG.Years_in_Business__c = '5';
        objBASG.Phone = '9865329865';
        objBASG.Fax = '7845784578';
        objBASG.Business_Email_Address__c = 'user@test.com';
        objBASG.Website = 'www.ukcompany.com';
        objBASG.Trading_Address_if_different__c = true;
        objBASG.TA_Floor_No__c = '4';
        objBASG.TA_Street_Number__c = '40';
        objBASG.TA_Street_Name__c = 'Street 40';
        objBASG.TA_District__c = 'SG';
        objBASG.TA_Region__c = 'SG';
        objBASG.TA_Postcode__c = 'LON101';
        objBASG.TA_Country__c = 'Singapore';
        objBASG.Type_of_Premises__c = 'Shop';
        objBASG.Self_Owned_Rented__c = 'Mortgaged';
        objBASG.Operating_Days_Per_Week__c = '5';
        objBASG.Operating_Hours_Per_Day__c = '8';
        objBASG.Total_No_Of_Staff__c = '5';
        objBASG.Other_Operating_Costs__c = 56565;
        objBASG.Total_Staff_Cost__c = 50000;
        objBASG.Time_in_Country__c = '0-6 months';
        objBASG.Time_at_this_Address_Months__c = '0-6 months';
        objBASG.Monthly_Rent__c = 9000;
        objBASG.Monthly_Mortgage_Payments__c = 3500;
        objBASG.Debt_Type__c = 'Overdraft';
        objBASG.Rental_Security_Deposit__c = 35000;
        objBASG.Original_Debt_Amount__c = 50000;
        objBASG.Monthly_Repayment__c = 2500;
        objBASG.Outstanding_Debt_Amount__c = 35000;
        objBASG.Months_Left_on_the_Lease__c = '3';
        objBASG.Paid_for_the_Month_Of__c = 'Jan';
        objBASG.Paid_for_the_amount_of__c = 6000;
        objBASG.Number_of_Months_in_Arrears_if_any__c = '5';
        objBASG.Civil_Litigation__c = 'Yes';
        objBASG.Business_Rates__c = 5600;
        
        objBASG.ParentId = objBASG.Id;
        //CRMS_Util.generateEndpoints();
        insert objBASG;
        
        objAccSG = new Account();
        objAccSG.RecordTypeId = lstSGPA[0].Id;
        objAccSG.Salutation = 'Ms.';
        objAccSG.Salutation__pc = 'Ms.';
        objAccSG.FirstName = 'Ethan';
        objAccSG.LastName = 'Hunt';
        objAccSG.Gender__pc = 'Female';
        objAccSG.Marital_Status__pc = 'Married';
        objAccSG.Any_Dependents__pc = '2';
        objAccSG.Education_Level__pc = 'Secondary';
        objAccSG.Business_Position__pc = 'Owner';
        objAccSG.Percentage_of_the_Company_Ownership__pc = 60;
        objAccSG.Associated_Business__c = objBASG.Id;
        objAccSG.Home_Floor_No__pc = '12';
        objAccSG.Home_Street_Number__pc = '12';
        objAccSG.PersonBirthdate = Date.Today().addYears(-19);
        objAccSG.Home_Street_Name__pc = '12th Street';
        objAccSG.Home_Postcode__pc = 'LON101';
        objAccSG.Home_Country__pc = 'Singapore';
        objAccSG.Home_District__pc = 'SG';
        objAccSG.Home_Region__pc = 'Sg';
        objAccSG.Property_Ownership__pc = 'Shop';
        objAccSG.Time_in_Country__c = '0-6 months';
        objAccSG.Time_at_this_Address_Months__c = '0-6 months';
        objAccSG.Residency_Status__pc = 'Singaporean';
        objAccSG.NRIC_Number__pc = 'S1234567D';
        objAccSG.Passport_County_of_issues__pc = 'Singapore';
        objAccSG.Passport_Expiry_Date__pc = date.newInstance(1997, 05, 15);
        objAccSG.Passport_Number__pc = '34545';
        objAccSG.PersonMobilePhone = '4561237890';
        objAccSG.PersonEmail = 'ethan@test.com';
        objAccSG.Was_AMP_Client_Before__pc = 'No';
        objAccSG.Civil_Litigation__pc = 'Yes';
        objAccSG.Consent_to_Search__pc = 'No';
        //CRMS_Util.generateEndpoints();
       insert objAccSG;
        
        objOppSG = new Opportunity();
        objOppSG.Name = 'testOSG';
        objOppSG.RecordtypeId = lstSGApplication[0].Id;
        objOppSG.Amount = 1000;
        objOppSG.CloseDate = date.Today() + 30;
        objOppSG.StageName = 'In Progress';
        objOppSG.AccountId = objBASG.Id;
        objOppSG.Country__c = 'Singapore';
        objOppSG.Loan_Purpose__c = 'Expansion';
        objOppSG.Requested_Loan_Term__c = '09 (270 days)';
        objOppSG.Average_Monthly_Card_Sales__c = 10000;
        objOppSG.Ave_Monthly_Sales__c = 20000;
        objOppSG.Monthly_Rental__c = 1500;
        objOppSG.Monthly_Interest__c = 2.5;
        objOppSG.Agreed_that_no_Relationship_Exists__c = true;
        objOppSG.Has_any_Relationship_with_AMP_Directors__c = 'Yes';
        objOppSG.Name_of_AMP_Personnel__c = 'test';
        objOppSG.Relationship_to_the_Applicant__c = 'brother';
        objOppSG.Person_Account__c = objAccSG.id;
        //CRMS_Util.generateEndpoints();
        insert objOppSG;
        objOppSG.Has_any_Relationship_with_AMP_Directors__c = 'Yes';
        //CRMS_Util.generateEndpoints();
        update objOppSG;
       
        objGuarantorsSG = new Guarantors__c();
        objGuarantorsSG.Opportunity__c = objOppSG.id;
        objGuarantorsSG.Account__c = objAccSG.id;
        objGuarantorsSG.Consent_to_Search__c = 'Yes';
        objGuarantorsSG.Account_Role__c = 'Owner';
        objGuarantorsSG.Required_Bank_Signatory__c = true;
        //CRMS_Util.generateEndpoints();
        insert objGuarantorsSG;
        
        objADSG =  new Additional_Debt__c();
        objADSG.Account__c = objBASG.id;
        objADSG.Civil_Litigation__c = 'No';
        objADSG.Debt_Type__c = null;
      
        //CRMS_Util.generateEndpoints();
        insert objADSG;
      }
    static testMethod void testAccountPremise_SG(){
        lstSGPremise = [Select r.SobjectType, r.Id, r.DeveloperName 
                    From RecordType r 
                    where r.SobjectType = 'Account' 
                    and r.DeveloperName = 'Premise_Singapore'];
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        initialize_SG();
        Account objBA2 = new Account();
        objBA2.Name = 'sg Company';
        objBA2.RecordtypeId = lstSGPremise[0].Id;
        objBA2.TA_Floor_No__c = '4';
        objBA2.TA_Street_Number__c = '40';
        objBA2.TA_Street_Name__c = 'Street 40';
        objBA2.TA_Postcode__c = 'PP101';
        objBA2.TA_District__c = 'SG'; 
        objBA2.TA_Country__c = 'Singapore';
        objBA2.TA_Region__c = 'SG';
        objBA2.TA_Building_Name__c = 'Ban';
        objBA2.ParentId = objBASG.Id;
        objBA2.Trading_Address_if_different__c = true;
        insert objBA2;
        
        
        update objBASG;
        CRMS_UKApplicationFormExtension objUk1 = new CRMS_UKApplicationFormExtension(
        new ApexPages.StandardController(objOppSG));
        PageReference pageRef1 = Page.CRMS_ApplicationForm;
        pageRef1.getParameters().put('Id',objOppSG.Id);
        Test.setCurrentPageReference(pageRef1);
        //objUk1.lstPremise.add(new CRMS_UKApplicationFormExtension.premiseInfo(objBA2,true));
        objUk1.salutationChange();
        objUk1.accountOpportunityBasicInfo_Completeness(); 
        objUk1.saveOpp();
        system.assert(!objUk1.lstPremise.isEmpty());
        objUk1.saveOpp();   
    }
    static testMethod void testBankDetails(){
        
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
       initialize_SG();
        Bank_Detail__c bd = new Bank_Detail__c();
        bd.name = 'Bank1';
        bd.Bank_Code__c = '01';
        bd.Country__c = 'SG';
        insert bd;
        
        CRMS_UKApplicationFormExtension objUk1 = new CRMS_UKApplicationFormExtension(
        new ApexPages.StandardController(objOppSG));
      
        PageReference pageRef1 = Page.CRMS_ApplicationForm;
        pageRef1.getParameters().put('Id',objOppSG.Id);
        Test.setCurrentPageReference(pageRef1);
        
        List<SelectOption> optns = new List<SelectOption>();
        optns = objUk1.getBankOptions();
        Test.startTest();
            System.assertEquals(false, optns.isEmpty());
        Test.stopTest();
    }
    
    static testMethod void testMortgaged()
    {
       Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        initialize_SG();
        CRMS_UKApplicationFormExtension objUk1 = new CRMS_UKApplicationFormExtension(
        new ApexPages.StandardController(objOppSG));
      
        PageReference pageRef1 = Page.CRMS_ApplicationForm;
        pageRef1.getParameters().put('Id',objOppSG.Id);
        Test.setCurrentPageReference(pageRef1);
        
        test.startTest();
        objBASG.Self_Owned_Rented__c = null;
        objUk1.occupiedStatus();
        
        objBASG.Self_Owned_Rented__c ='Mortgaged';
        objBASG.Operating_Days_Per_Week__c = '7';
        objBASG.Operating_Hours_Per_Day__c = '09';
        objBASG.Total_No_of_Staff__c = '4';
        objBASG.Total_Staff_Cost__c = 1400;
        objBASG.Other_Operating_Costs__c = 900000;
        objBASG.Time_at_this_Address_Months__c = '0-6 months';
        //objBASG.Time_at_this_Address__c = '06';
        objBASG.Monthly_Mortgage_Payments__c = 9000;
        update objBASG;
        objUk1.tradingAddAcc = FALSE;
        objUk1.accountOwnership_Mortgage_Completeness();
        objUk1.saveOpp();
        objUk1.occupiedStatus();
        test.stopTest();
    }
    static testMethod void testNonPermanentResident(){
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        initialize_SG();
        
        String occupiedStatus;                  
        // load the page       
        CRMS_UKApplicationFormExtension objUk1 = new CRMS_UKApplicationFormExtension(new ApexPages.StandardController(objOppSG));
        PageReference pageRef1 = Page.CRMS_ApplicationForm;
        pageRef1.getParameters().put('Id',objOppSG.Id);
        Test.setCurrentPageReference(pageRef1);
        test.startTest();
        
        objAccSG.Residency_Status__pc='Singaporean';
        objAccSG.NRIC_Number__pc = 'S6442646J';
        objUK1.rowODGCount = 0;
        objUK1.residencyStatusChange();
        objUk1.residencyStatusCompleteness(new CRMS_UKApplicationFormExtension.ownerDetails (
                                            objAccSG, objOppSG, objGuarantorsSG, true, true, false,
                                            new List<CRMS_UKApplicationFormExtension.debtDetails> ()));
        objAccSG.Residency_Status__pc='Singapore Permanent Resident';
        objuk1.strCountry = 'Singapore';
        objUK1.rowODGCount = 0;
        objUK1.residencyStatusChange();
        objUk1.residencyStatusCompleteness(new CRMS_UKApplicationFormExtension.ownerDetails (
                                            objAccSG, objOppSG, objGuarantorsSG, true, true, false,
                                            new List<CRMS_UKApplicationFormExtension.debtDetails> ()));
        objAccSG.Residency_Status__pc='Foreigner with Employment Pass';
        objAccSG.Passport_County_of_issues__pc = 'test';
        objAccSG.Passport_Number__pc = 'S1234567D';
        objAccSG.Passport_Expiry_Date__pc = date.today();
        objAccSG.Time_at_this_Address_Months__c = '0-6 months';
        objuk1.strCountry = 'Singapore';
        objUK1.rowODGCount = 0;
        objUK1.residencyStatusChange();
        objUk1.residencyStatusCompleteness(new CRMS_UKApplicationFormExtension.ownerDetails (
                                            objAccSG, objOppSG, objGuarantorsSG, true, true, false,
                                            new List<CRMS_UKApplicationFormExtension.debtDetails> ()));
        objAccSG.Residency_Status__pc='Foreigner without Employment Pass';
        objAccSG.Passport_County_of_issues__pc = 'test1';
        objAccSG.Passport_Number__pc = 'S1234567D';
        objAccSG.Passport_Expiry_Date__pc = date.today();
        objAccSG.Time_at_this_Address_Months__c = '0-6 months';
        objuk1.strCountry = 'Singapore';
        objUK1.rowODGCount = 0;
        objUK1.residencyStatusChange();
        objUk1.ODG_UK_Completeness(new CRMS_UKApplicationFormExtension.ownerDetails (
            objAccSG, objOppSG, objGuarantorsSG, true, true, false,
            new List<CRMS_UKApplicationFormExtension.debtDetails> ()));
        objUk1.residencyStatusCompleteness(new CRMS_UKApplicationFormExtension.ownerDetails (
            objAccSG, objOppSG, objGuarantorsSG, true, true, false,
            new List<CRMS_UKApplicationFormExtension.debtDetails> ()));
    }
}