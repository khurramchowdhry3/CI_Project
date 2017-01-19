@isTest
private class CRMS_OpportunityTriggerHandlerTest 
{
    static testMethod void test_setOpportunityCloneOpportunity() {
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        
        
        Account objAcc = new Account();
        objAcc.Name = 'testAcc';
        insert objAcc;
        
        Opportunity objOpp = new Opportunity();
        objOpp.Name = 'testOpp';
        objOpp.AccountId = objAcc.Id;
        objOpp.StageName = 'In Progress';//'Qualification';
        objOpp.CloseDate = date.today();
        objOpp.Country__c = 'UK';
        objOpp.Contract_End_Date__c = date.today();
        objOpp.Contract_Signed__c = false;
        insert objOpp;

        objOpp.StageName = 'Accepted';
        objOpp.Contract_End_Date__c = date.today();
        update objOpp;
        list<Opportunity> lstOpp = [select id, Name, Contract_End_Date__c, StageName, AccountId 
                                    From Opportunity 
                                    where AccountId =: objAcc.Id];
        
        system.assertEquals(1,lstOpp.size());
    }
  
    static testMethod void testOpportunityTriggerHandler() 
    {
        list<User> lstUser1 = [SELECT Id, Name FROM User where Name Like '%Partner%'];
        
        list<Profile> lstProfile = [Select p.UserLicenseId, p.Name, p.Id From Profile p 
                                    where p.Name Like '%Partner%' limit 1];
        list<User> lstUser  = [Select u.ProfileId, u.IsActive, u.Id From User u 
                              where u.isActive = true limit 1];
        
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        
        Test.startTest();
        
        Account objAcc = new Account();
        objAcc.Name = 'testAcc';
        insert objAcc;
                              
        Contact objContact = new Contact();
        objContact.lastName = 'first Contact';
        objContact.phone = '8983794213';
        objcontact.Email = 'test@crmsuperstars.com';
        objContact.AccountId = objAcc.Id;
        objContact.Allocated_Internal_Sales_Representative__c = lstuser[0].Id;
        insert objContact ;
                              
        User objUser = new User(
                             Email='standarduser123@test.com', 
                             EmailEncodingKey='UTF-8', 
                             LastName='Testing', 
                             LanguageLocaleKey='en_US', 
                             LocaleSidKey='en_US', 
                             ProfileId = lstProfile[0].Id,
                             TimeZoneSidKey='America/Los_Angeles', 
                             UserName='standarduser123@test.com',
                             CommunityNickname = 'testUser123',
                             ContactId = objContact.Id,
                             Alias = 't1');
        insert objUser;
        
        Opportunity objOpp = new Opportunity();
        //System.runAs(objUser){
        objOpp.Name = 'testOpp';
        objOpp.AccountId = objAcc.Id;
        objOpp.StageName = 'Qualification';
        objOpp.CloseDate = date.today();
        objOpp.Introducer__c = objUser.Id;
        objOpp.Country__c = 'UK';
        insert objOpp;
        //}
        OpportunityTeamMember objOppTeamMember = new OpportunityTeamMember();
        objOppTeamMember.OpportunityId = objOpp.Id;
        objOppTeamMember.UserId = objUser.Id;
        objOppTeamMember.TeamMemberRole = 'Sales Rep';
        insert objOppTeamMember;
        
        Statics.inFutureContext = true;
        
        Account objAcc1 = new Account();
        objAcc1.Name = 'testAcc1';
        insert objAcc1;
                              
        Contact objContact1 = new Contact();
        objContact1.lastName = 'first Contact1';
        objContact1.phone = '898379423';
        objContact1.Email = 'test@crmsuperstar.com';
        objContact1.AccountId = objAcc1.Id;
        objContact1.Allocated_Internal_Sales_Representative__c = lstuser1[0].Id;
        insert objContact1 ;
        
        User objUser1 = new User(
                             Email='standarduse123@test.com', 
                             EmailEncodingKey='UTF-8', 
                             LastName='Testing', 
                             LanguageLocaleKey='en_US', 
                             LocaleSidKey='en_US', 
                             ProfileId = lstProfile[0].Id,
                             TimeZoneSidKey='America/Los_Angeles', 
                             UserName='standarduser113@test.com',
                             CommunityNickname = 'testUser111',
                             ContactId = objContact1.Id,
                             Alias = 't1');
        insert objUser1;
        objOpp.Introducer__c = objUser1.Id;
        objOpp.StageName = 'Contract Stage';
        update objOpp;
        Test.stopTest();
    }
    
    static testMethod void test_setOpportunityCreditAssessmentCreation() {
        CRMS_Util util = new CRMS_Util();
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        
        Test.startTest();
        
        Account Acc = new Account();
        Acc.Name  = 'Test Credit Assesment Creation';
        insert Acc;
        
        Contact objContact = new Contact();
        objContact.lastName = 'first Contact1';
        objContact.phone = '898379423';
        objContact.Email = 'test@crmsuperstar.com';
        objContact.AccountId = Acc.Id;
        insert objContact ;
        
        list<Profile> lstProfile1 = [Select p.UserLicenseId, p.Name, p.Id From Profile p where p.Name = 'System Administrator'limit 1];
        User objUser1 = new User(
                             Email='standarduse123@test.com', 
                             EmailEncodingKey='UTF-8', 
                             LastName='Testing', 
                             LanguageLocaleKey='en_US', 
                             LocaleSidKey='en_US', 
                             ProfileId = lstProfile1[0].Id,
                             TimeZoneSidKey='America/Los_Angeles', 
                             UserName='standarduser123@test.com',
                             CommunityNickname = 'testUser143',
                             Alias = 't1');
        insert objUser1;
        
        Opportunity objP = new Opportunity();
        
        //System.runAS(objUser1){
        objP.AccountId = Acc.Id;
        objP.Name = 'Test Operation Creation';
        objP.CloseDate  = date.today().addDays(30);
        objP.StageName = 'Accepted';
        objP.Loan_Purpose__c = 'Inventory';
        objP.Requested_Loan_Term__c = '03 (090 days)';
        objP.Amount = 1500;
        objP.Monthly_Rental__c = 100;
        objP.Ave_Monthly_Sales__c = 15000;
        objP.Average_Monthly_Card_Sales__c = 15000;
        objP.Contract_Signed__c = false;
        objP.Introducer__c = objUser1.Id;
        insert objP;
        //}
        
        User objUser = new User(
                             Email='standarduser123@test.com', 
                             EmailEncodingKey='UTF-8', 
                             LastName='Test', 
                             LanguageLocaleKey='en_US', 
                             LocaleSidKey='en_US', 
                             ProfileId = lstProfile1[0].Id,
                             TimeZoneSidKey='America/Los_Angeles', 
                             UserName='standarduser113@test.com',
                             CommunityNickname = 'testUser113',
                             
                             Alias = 't1');
        insert objUser;
        
        CRMS_OpportunityTriggerHandler.blnUpdate = false;  
        objP.Signed_Application_Form_Received__c = true;
        objP.Documents_Received_Kofax__c = 'Test';
        objP.Application_Form_Completed__c = true;
        objP.Required_Documents_Received__c = true;
        objP.Documents_Processed__c = true;
        objP.Contract_End_Date__c = date.today();
        objP.StageName = '(Won) Disbursed';
        objP.Contract_Signed__c = true;
        objP.Introducer__c = objUser.Id;
        update objP;
        
        Test.stopTest();
        list<Credit_Assessment__c> lstCredit = [select Id,CurrencyIsoCode from Credit_Assessment__c where Opportunity__c = :objP.Id];
        system.assertEquals(1,lstCredit.size());
    }
    
    static testMethod void test_setOpportunityOperationCreation() {
        CRMS_Util util = new CRMS_Util();
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        RecordType oppRecordType = [Select r.Id, r.SobjectType ,r.DeveloperName
                                        From RecordType r 
                                        where r.SobjectType = 'Opportunity' 
                                        and r.DeveloperName = 'Outcome_UK'];
                                        
                                        list<Profile> lstProfile1 = [Select p.UserLicenseId, p.Name, p.Id From Profile p where p.Name = 'System Administrator'limit 1];
        User objUser1 = new User(
                             Email='standarduse123@test.com', 
                             EmailEncodingKey='UTF-8', 
                             LastName='Testing', 
                             LanguageLocaleKey='en_US', 
                             LocaleSidKey='en_US', 
                             ProfileId = lstProfile1[0].Id,
                             TimeZoneSidKey='America/Los_Angeles', 
                             UserName='credituser123@test.com',
                             CommunityNickname = 'testUser143',
                             Alias = 't1');
        insert objUser1;
        Test.startTest();
        
        Opportunity objOpportunity = new Opportunity(RecordTypeId = oppRecordType.Id);
        objOpportunity.Name = 'Test Operations Creation';
        objOpportunity.CloseDate  = date.today().adddays(30);
        objOpportunity.StageName = 'Assessment In Progress';
        objOpportunity.Loan_Purpose__c = 'Inventory';
        objOpportunity.Average_Monthly_Card_Sales__c = 10000;
        objOpportunity.Monthly_Rental__c = 200;
        objOpportunity.Amount = 10000;
        objOpportunity.Monthly_Interest__c = 0.2;
        objOpportunity.Requested_Loan_Term__c = '06 (180 days)';
        objOpportunity.Contract_Signed__c = false;
        insert objOpportunity;
        
        List<RecordType> caRecordType = [Select r.Id, r.SobjectType ,r.DeveloperName
                                        From RecordType r 
                                        where r.SobjectType = 'Credit_Assessment__c' 
                                        and DeveloperName = 'Credit_Assessment_Completed'];
        
        Credit_Assessment__c objCredit = new Credit_Assessment__c(RecordTypeId = caRecordType[0].Id);
        objCredit.OwnerId = objUser1.Id;
        objCredit.Opportunity__c = objOpportunity.Id;
        //objCredit.CurrencyIsoCode = objOpportunity.CurrencyIsoCode;
        objCredit.Annual_Calculation__c = objOpportunity.Annual_Calculation__c;
        objCredit.Approved_Loan_Amount__c = 10000;
        objCredit.Monthly_Interest_Approved__c = 0.2;
        objCredit.Annual_Calculation__c = true;
        objCredit.Offer_Amount__c = 12000;
        objCredit.Approved_Loan_Term__c = '06 (180 days)';
        objCredit.Monthly_Interest__c = 0.2;
        objCredit.Monthly_Interest_Requested__c = objOpportunity.Monthly_Interest__c;
        insert objCredit;
        
        CRMS_OpportunityTriggerHandler.blnUpdate = false;
        objOpportunity.StageName = 'Application Revised';
        objOpportunity.Amount = 10500;
        update objOpportunity;
        
        CRMS_OpportunityTriggerHandler.blnUpdate = false;
        objOpportunity.Contract_Signed__c = true;
        objOpportunity.StageName = '(Won) Signed';
        objOpportunity.Contract_Signed_Date__c = date.today().addDays(30);
        objOpportunity.Contract_End_Date__c = date.newInstance(2016, 06, 01);
        objOpportunity.Signed_Application_Form_Received__c = true;
        update objOpportunity;
        Test.stopTest();
        list<Operation__c> lstOperation = [Select o.Opportunity__c, o.Id From Operation__c o where o.Opportunity__c =: objOpportunity.Id];
        system.assertEquals(1,lstOperation.size());
    }
    
    static testMethod void test_setOpportunity() {
        CRMS_Util util = new CRMS_Util();
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        RecordType oppRecordType = [Select r.Id, r.SobjectType ,r.DeveloperName
                                        From RecordType r 
                                        where r.SobjectType = 'Opportunity' 
                                        and r.DeveloperName = 'Outcome_UK'];
                                        
        list<Profile> lstProfile1 = [Select p.UserLicenseId, p.Name, p.Id From Profile p where p.Name = 'System Administrator'limit 1];
        User objUser2 = new User(
                             Email='standarduse123@test.com', 
                             EmailEncodingKey='UTF-8', 
                             LastName='Testing', 
                             LanguageLocaleKey='en_US', 
                             LocaleSidKey='en_US', 
                             ProfileId = lstProfile1[0].Id,
                             TimeZoneSidKey='America/Los_Angeles', 
                             UserName='credituser123@test.com',
                             CommunityNickname = 'testUser143',
                             Alias = 't1');
        insert objUser2;
        Test.startTest();
        
        Opportunity objOpportunity = new Opportunity(RecordTypeId = oppRecordType.Id);
        objOpportunity.Name = 'Test Opportunity';
        objOpportunity.CloseDate  = date.today().adddays(30);
        objOpportunity.StageName = 'Loan Withdrawn';
        objOpportunity.Loan_Purpose__c = 'Inventory';
        objOpportunity.Average_Monthly_Card_Sales__c = 10000;
        objOpportunity.Monthly_Rental__c = 200;
        objOpportunity.Amount = 20000;
        objOpportunity.Monthly_Interest__c = 0.2;
        objOpportunity.Requested_Loan_Term__c = '06 (180 days)';
        objOpportunity.Contract_Signed__c = false;
        insert objOpportunity;
        
        Date_Setting__c dtCustom = new Date_Setting__c();
        dtCustom.Name = 'Test';
        dtCustom.Disbursal_Range__c = 3;
        dtCustom.Batch_Ownership_Change__c = 4;
        insert dtCustom;
        
        Operation__c operationobj = new Operation__c();
        operationobj.Loan_Disbursed__c = true;
        operationobj.Loan_Disbursed_Date__c = date.today().adddays(10);
        operationobj.Opportunity__c = objOpportunity.Id;
        insert operationobj;
        
    }
    
    
    static testMethod void test_setOpportunityDWHStatusSynced() {
        CRMS_Util util = new CRMS_Util();
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        
        Test.startTest();
        
        Opportunity opportunity = util.initializeOpportunity(false);
        opportunity.DWH_Status__c = CRMS_Util.DWH_STATUS_SYNCED;
        insert opportunity;
        Test.stopTest();
        
        List<Opportunity> testOpportunityList = [select DWH_Status__c,DWH_Last_Sync__c from Opportunity where id = :opportunity.Id];
        //system.assertNotEquals(null, testOpportunityList[0].DWH_Last_Sync__c);
    }
    
    static testMethod void test_setOpportunityDWHStatusQueued() {
        CRMS_Util util = new CRMS_Util();
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        
        Test.startTest();
        Opportunity opportunity = util.initializeOpportunity(false);
        insert opportunity;
        
        Test.stopTest();
        List<Opportunity> testOpportunityList = [select DWH_Status__c from Opportunity where id = :opportunity.Id];
    }
    
    
    /*
    // Do not uncomment
    static testMethod void test_createSyncQueueAfterOpportunityInsert() {
        CRMS_Util util = new CRMS_Util();
        
                                
        Opportunity opportunity = util.initializeOpportunity(false);
        opportunity.DWH_Import__c = false;
        insert opportunity;
        
        List<Sync_Queue__c> syncQueList = [SELECT Sync_Status__c FROM Sync_Queue__c WHERE Opportunity__c = :opportunity.Id];
        //system.assertEquals(1,syncQueList.size());
        //system.assertEquals(CRMS_Util.SYNC_QUEUE_STATUS_PENDING,syncQueList[0].Sync_Status__c);
    }
    
    static testMethod void test_createSyncQueueAfterOpportunityUpdate() {
        CRMS_Util util = new CRMS_Util();
        
                                
        Opportunity opportunity = util.initializeOpportunity(false);
        opportunity.DWH_Import__c = true;
        insert opportunity;
        
        List<Opportunity> opportunityList = [SELECT DWH_Import__c,DWH_Status__c FROM Opportunity WHERE Id = :opportunity.Id];
        opportunityList[0].DWH_Import__c = false;
        opportunityList[0].DWH_Status__c = CRMS_Util.DWH_STATUS_QUEUED;
        update opportunityList;
        
        List<Sync_Queue__c> syncQueList = [SELECT Sync_Status__c FROM Sync_Queue__c WHERE Opportunity__c = :opportunity.Id];
        //system.assertEquals(1,syncQueList.size());
        //system.assertEquals(CRMS_Util.SYNC_QUEUE_STATUS_PENDING,syncQueList[0].Sync_Status__c);
    }*/
    
    
    static testMethod void test_createSyncQueueRecord_BeforeDelete() {
        CRMS_Util util = new CRMS_Util();
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        
        Test.startTest();
        
        //If Sync Queue record meeting criteria is not found
        Opportunity oppObj = util.initializeOpportunity(false);
        oppObj.DWH_Import__c = false;
        insert oppObj;
        
        String opportunityId = oppObj.Id;
        List<Sync_Queue__c> syncQueList1 =[SELECT Id FROM Sync_Queue__c WHERE Opportunity__c = :opportunityId];
        delete syncQueList1;
        delete oppObj;
        
        List<Sync_Queue__c> syncQueListTest1 =[
            SELECT Opportunity__c
                 , Id
                 , Notes__c
                 , Action__c
                 , Queued_Record_ID__c
                 , Sync_Status__c
                 , DWH_Data_Type__c
               FROM Sync_Queue__c 
              WHERE Queued_Record_ID__c = :opportunityId
        ];
        
        Test.stopTest();
        //system.assertEquals(CRMS_Util.DWH_DATA_TYPE_OPPORTUNITY,syncQueListTest1[0].DWH_Data_Type__c);
        //system.assertEquals(opportunityId, syncQueListTest1[0].Queued_Record_ID__c);
        //system.assertEquals(CRMS_Util.SYNC_STATUS_DELETE, syncQueListTest1[0].Action__c);
        //system.assertEquals(CRMS_Util.SYNC_QUEUE_STATUS_PENDING, syncQueListTest1[0].Sync_Status__c);
        String syncQueueNotes1 = syncQueListTest1[0].Notes__c;
        //system.assert(syncQueueNotes1.contains(CRMS_Util.SYNC_STATUS_OPPORTUNITY_DELETED));
    }
    
    static testMethod void test_updateSyncQueueRecord_BeforeDelete() {
        CRMS_Util util = new CRMS_Util();
        //Query ??Sync Queue? for records matching the criteria of Lead = Lead, Sync Status is ?Pending?.  If a record if found
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        
        Test.startTest();
        //If Sync Queue record meeting criteria is not found
        Opportunity opprtunity = util.initializeOpportunity(false);
        opprtunity.DWH_Status__c = CRMS_Util.DWH_STATUS_QUEUED;
        insert opprtunity;
        
        Sync_Queue__c syncQueue = new Sync_Queue__c();
        syncQueue.Opportunity__c = opprtunity.Id;
        syncQueue.Sync_Status__c = CRMS_Util.SYNC_QUEUE_STATUS_PENDING;
        insert syncQueue;
        String opprtunityId = opprtunity.Id;
       
        delete opprtunity;
        
        List<Sync_Queue__c> syncQueListTest1 =[
            SELECT Credit_Assessment__c
                 , Id
                 , Notes__c
                 , Action__c
                 , Queued_Record_ID__c
                 , Sync_Status__c
                 , DWH_Data_Type__c
               FROM Sync_Queue__c 
              WHERE Queued_Record_ID__c = :opprtunityId
        ];
        
        Test.stopTest();
       //system.assertEquals(CRMS_Util.SYNC_STATUS_STALE, syncQueListTest1[0].Sync_Status__c);
        String syncQueueNotes1 = syncQueListTest1[0].Notes__c;
        //system.assert(syncQueueNotes1.contains(CRMS_Util.DWH_DELETE_TRIGGER));
    }
}