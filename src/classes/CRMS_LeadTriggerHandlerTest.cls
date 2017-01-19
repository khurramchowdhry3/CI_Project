/**
    Test class for the Case trigger
    Author: CRMS
    Version: 1.0
*/
@isTest
private class CRMS_LeadTriggerHandlerTest 
{
    static list<RecordType> lstRec;
    static map<String, Id> mapRecTypeName_Id;
    static void initializeData() {
    	lstRec = [Select Id, Name, DeveloperName, SobjectType from RecordType
                  where SobjectType = 'Lead'];
        mapRecTypeName_Id = new map<String,Id>();
        for(RecordType objR : lstRec){
            mapRecTypeName_Id.put(objR.DeveloperName, objR.Id);
        }
    }
    
    static testMethod void testLeadTriggerHandler()
    {
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        CRMS_OpportunityTeamProcessor oppTeam = new CRMS_OpportunityTeamProcessor();
        Test.startTest();
        initializeData();
        Lead objLead1 = new Lead();
        objLead1.Convert_Lead__c = false;
        objLead1.RecordTypeId = mapRecTypeName_Id.get('UK');
        objLead1.LastName='Holmes';
        objLead1.FirstName='Sherlock';
        objLead1.Business_Position__c = 'Owner';
        objLead1.Company='Bakers';
        objLead1.Status='Open';
        objLead1.Email = 'test5@gmail.com';
        objLead1.Accepts_Credit_Cards__c = true;
        objLead1.TA_Country__c= 'UK';
        insert objLead1;
        
        objLead1.Status='Qualified';
        objLead1.RecordTypeId = mapRecTypeName_Id.get('Qualified_UK');
        objLead1.Convert_Lead__c = true;
        objLead1.Accepts_Credit_Cards__c = true;
        objLead1.Business_Registered_in_UK__c = true;
        objLead1.Business_in_Operation_Minimum_6_months__c = true;
        objLead1.Business_Nature__c = true;
        update objLead1;
        Test.stopTest();
         
        list<Account> lstA = [select Id from Account where Name = 'Bakers' limit 1];
        
        system.assertEquals(1, lstA.size());
    }
    
    static testMethod void testLeadHK() {
    	CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        Test.startTest();
        initializeData();
        
        Lead objLead2 = new Lead();
        objLead2.Convert_Lead__c = false;
        objLead2.RecordTypeId = mapRecTypeName_Id.get('Hong_Kong');
        objLead2.LastName='Holme';
        objLead2.FirstName='Sherloc';
        objLead2.Business_Position__c = 'Owner';
        objLead2.Company='Baker';
        objLead2.Status='Open';
        objLead2.Email = 'test@gmail.com';
        objLead2.Accepts_Credit_Cards__c = true;
        objLead2.TA_Country__c= 'Hong Kong';
        insert objLead2;
        
        objLead2.Status='Qualified';
        objLead2.RecordTypeId = mapRecTypeName_Id.get('Qualified_Hong_Kong');
        objLead2.Convert_Lead__c = true;
        objLead2.Accepts_Credit_Cards__c = true;
        objLead2.Business_Registered_in_Hong_Kong__c = true;
        objLead2.Business_in_Operation_Minimum_3_months__c = true;
        objLead2.Business_Nature__c = true;
        update objLead2;
        Test.stopTest();
    }
    
    static testMethod void testLeadSG() {
    	CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        Test.startTest();
        initializeData();
        
        Lead objLead3 = new Lead();
        objLead3.Convert_Lead__c = false;
        objLead3.RecordTypeId = mapRecTypeName_Id.get('Singapore');
        objLead3.LastName='Holm';
        objLead3.FirstName='Sheloc';
        objLead3.Business_Position__c = 'Owner';
        objLead3.Company='Bakr';
        objLead3.Status='Open';
        objLead3.Email = 'test1@gmail.com';
        objLead3.Accepts_Credit_Cards__c = true;
        objLead3.TA_Country__c= 'Singapore';
        insert objLead3;
        
        objLead3.Status='Qualified';
        objLead3.RecordTypeId = mapRecTypeName_Id.get('Qualified_Singapore');
        objLead3.Convert_Lead__c = true;
        objLead3.Accepts_Credit_Cards__c = true;
        objLead3.Business_Registered_in_Singapore__c = true;
        objLead3.Business_in_Operation_Minimum_3_months__c = true;
        objLead3.Business_Nature__c = true;
        update objLead3;
        Test.stopTest();
    }
    
    static testMethod void testLeadPP() {
    	CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        Test.startTest();
        initializeData();
        
        Lead objLead4 = new Lead();
        objLead4.Convert_Lead__c = false;
        objLead4.RecordTypeId = mapRecTypeName_Id.get('Philippines');
        objLead4.LastName='Hom';
        objLead4.FirstName='Shloc';
        objLead4.Business_Position__c = 'Owner';
        objLead4.Company='Bar';
        objLead4.Status='Open';
        objLead4.Email = 'test2@gmail.com';
        objLead4.Accepts_Credit_Cards__c = true;
        objLead4.TA_Country__c= 'Philippines';
        insert objLead4;
        
        objLead4.Status='Qualified';
        objLead4.RecordTypeId = mapRecTypeName_Id.get('Qualified_Philippines');
        objLead4.Convert_Lead__c = true;
        objLead4.Accepts_Credit_Cards__c = true;
        objLead4.Business_Registered_in_Philippines__c = true;
        objLead4.Business_in_Operation_Minimum_3_months__c = true;
        objLead4.Business_Nature__c = true;
        update objLead4;
        Test.stopTest();
    }
    
    static testMethod void test_setLeadDWHStatusSynced() {
        CRMS_Util util = new CRMS_Util();
        
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        Test.startTest();
        
        Lead leadObj = util.initializeLead(false);
        leadObj.DWH_Import__c = true;
        insert leadObj;
        
        List<Lead> testLeadList = [select DWH_Status__c from Lead where id = :leadObj.Id];
        System.assertEquals(testLeadList[0].DWH_Status__c,CRMS_Constants.DWH_STATUS_SYNCED);
    }
    
    static testMethod void test_setLeadDWHStatusQueued() {
        CRMS_Util util = new CRMS_Util();
        
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        Test.startTest();
        
        Lead leadObj = util.initializeLead(false);
        leadObj.DWH_Import__c = false;
        insert leadObj;
        Test.stopTest();
        
        List<Lead> testLeadList = [select DWH_Status__c from Lead where id = :leadObj.Id];
    }
    
    static testMethod void test_updateLeadStatus() {
        CRMS_Util util = new CRMS_Util();
        
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        Test.startTest();
        
        Lead leadObj = util.initializeLead(false);
        leadObj.DWH_Import__c = true;
        insert leadObj;
        Test.stopTest();
        
        List<Lead> testLeadList = [select DWH_Status__c,DWH_Import__c from Lead where id = :leadObj.Id];
    }
    
   /* static testMethod void test_createSyncQueueAfterLeadInsert() {
        CRMS_Util util = new CRMS_Util();
        
                                
        Lead leadObj = util.initializeLead(false);
        leadObj.DWH_Import__c = false;
        insert leadObj;
        
        List<Sync_Queue__c> syncQueList = [SELECT Sync_Status__c FROM Sync_Queue__c WHERE Lead__c = :leadObj.Id];
        system.assertEquals(1,syncQueList.size());
        system.assertEquals(CRMS_Util.SYNC_QUEUE_STATUS_PENDING,syncQueList[0].Sync_Status__c);
    }
    
    static testMethod void test_createSyncQueueAfterLeadUpdate() {
        CRMS_Util util = new CRMS_Util();
        
                                
        Lead leadObj = util.initializeLead(false);
        leadObj.DWH_Import__c = true;
        insert leadObj;
        
        List<Lead> leadList = [SELECT DWH_Import__c,DWH_Status__c,LE_Country__c FROM Lead WHERE Id = :leadObj.Id];
        leadList[0].LE_Country__c = 'Scotland';
        leadList[0].DWH_Import__c = false;
        update leadList;
        
        List<Sync_Queue__c> syncQueList = [SELECT Sync_Status__c FROM Sync_Queue__c WHERE Lead__c = :leadObj.Id];
        system.assertEquals(1,syncQueList.size());
        system.assertEquals(CRMS_Util.SYNC_QUEUE_STATUS_PENDING,syncQueList[0].Sync_Status__c);
    }*/
    
    static testMethod void test_createSyncQueueRecord_BeforeDelete() {
        CRMS_Util util = new CRMS_Util();
        
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        Test.startTest();
        
        //If Sync Queue record meeting criteria is not found
        Lead leadObj1 = util.initializeLead(false);
        leadObj1.DWH_Import__c = false;
        insert leadObj1;
        
        String leadId = leadObj1.Id;
        List<Sync_Queue__c> syncQueList1 =[SELECT Id FROM Sync_Queue__c WHERE Lead__c = :leadId];
        delete syncQueList1;
        delete leadObj1;
        Test.stopTest();
        
        List<Sync_Queue__c> syncQueListTest =[
            SELECT Lead__c
                 , Id
                 , Notes__c
                 , Action__c
                 , Queued_Record_ID__c
                 , Sync_Status__c
                 , DWH_Data_Type__c
               FROM Sync_Queue__c 
              WHERE Queued_Record_ID__c = :leadId
        ];
        system.assertEquals(1,syncQueListTest.size());
    }
    
    static testMethod void test_updateSyncQueueRecord_BeforeDelete() {
        CRMS_Util util = new CRMS_Util();
        //Query ��Sync Queue� for records matching the criteria of Lead = Lead, Sync Status is �Pending�.  If a record if found
        
        //If Sync Queue record meeting criteria is not found
        
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        Test.startTest();
        
        Lead leadObj = util.initializeLead(false);
        leadObj.DWH_Status__c = CRMS_Util.DWH_STATUS_QUEUED;
        insert leadObj;
        
        Sync_Queue__c syncQueue = new Sync_Queue__c();
        syncQueue.Lead__c = leadObj.Id;
        syncQueue.Sync_Status__c = CRMS_Util.SYNC_QUEUE_STATUS_PENDING;
        insert syncQueue;
        String leadId = leadObj.Id;
       
        delete leadObj;
        Test.stopTest();
        
        List<Sync_Queue__c> syncQueListTest =[
            SELECT Credit_Assessment__c
                 , Id
                 , Notes__c
                 , Action__c
                 , Queued_Record_ID__c
                 , Sync_Status__c
                 , DWH_Data_Type__c
               FROM Sync_Queue__c 
              WHERE Queued_Record_ID__c = :leadId
        ];
        system.assertNotEquals(0,syncQueListTest.size());
    }
}