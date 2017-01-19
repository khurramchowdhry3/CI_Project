/**
    Test class for account trigger handler
    Author: Saket Joshi
    Version: 1.0
*/
@isTest
private class CRMS_AccountTriggerHandlerTest {

    static testMethod void test_BeforeInsert() {
        CRMS_Util util = new CRMS_Util();
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        
        Test.startTest();
        Account account = util.initializeAccount(false);
        insert account;
        
        Account[] accountList = [SELECT DWH_Status__c,DWH_Last_Sync__c FROM Account WHERE Id = :account.Id];
        
        system.assertNotEquals(null, accountList[0].DWH_Status__c);
    }
    
    static testMethod void test_BeforeInsertSync(){
        CRMS_Util util = new CRMS_Util();
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
       
        Test.startTest();
        Account account = util.initializeAccount(false);
        account.DWH_Status__c = CRMS_Util.DWH_STATUS_SYNCED;
        insert account;       
        Account[] testaccount = [SELECT DWH_Status__c,DWH_Last_Sync__c FROM Account WHERE Id = :account.Id];
        Test.stopTest();    
            
        
    }
    
    static  testMethod void testHKID_AfterInsert()
    {
        CRMS_Util util = new CRMS_Util();
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        try{
            Test.startTest();
            RecordType contactType = [SELECT Id FROM RecordType WHERE Name = 'Person Hong Kong' LIMIT 1];
            Account account = new Account(RecordTypeId=contactType.Id);
            account.HKID_Card_No__pc = 'K546234(E)';
            account.lastname='Account_PTMA';
            insert account;
            Account[] accountList = [SELECT HKID_Card_No__pc FROM Account WHERE Id = :account.Id];
            system.assertNotEquals(null, accountList[0].HKID_Card_No__pc);
            
            account = new Account(RecordTypeId=contactType.Id);
            account.HKID_Card_No__pc = 'C668668(9)';
            insert account;
            Account[] accountListTest = [SELECT HKID_Card_No__pc FROM Account WHERE Id = :account.Id];
            system.assertEquals('C668668(9)', accountList[0].HKID_Card_No__pc);
            
            account = new Account(RecordTypeId=contactType.Id);
            account.HKID_Card_No__pc = 'A347346(8)';
            insert account;
            accountListTest = [SELECT HKID_Card_No__pc FROM Account WHERE Id = :account.Id];
            system.assertEquals('A347346(8)', accountList[0].HKID_Card_No__pc);
            
            account = new Account(RecordTypeId=contactType.Id);
            account.HKID_Card_No__pc = 'K546234(E)';
            insert account;
            accountListTest = [SELECT HKID_Card_No__pc FROM Account WHERE Id = :account.Id];
            
            
            Test.stopTest();
        }Catch( Exception e){
            
        }
        
    }
    
    static  testMethod void testSGID_AfterInsert()
    {
        CRMS_Util util = new CRMS_Util();
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        try{
            Test.startTest();
            RecordType contactType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Person_Singapore' LIMIT 1];
            
            Account account = new Account(RecordTypeId=contactType.Id);
            account = new Account(RecordTypeId=contactType.Id);
            account.NRIC_Number__pc = 'S1234567D';
            account.lastname='Account_PTM';
            insert account;
            Account[] accountList = [SELECT NRIC_Number__pc FROM Account WHERE Id = :account.Id];
            system.assertNotEquals(null, accountList[0].NRIC_Number__pc);
            
            account = new Account(RecordTypeId=contactType.Id);
            account.NRIC_Number__pc = 'G1234567X';
            account.lastname='Account_PTM';
            insert account;
            accountList = [SELECT id, NRIC_Number__pc FROM Account WHERE Id = :account.Id];
            
            system.assertNotEquals(null, accountList[0].NRIC_Number__pc);
           
            account = new Account(RecordTypeId=contactType.Id);
            account.NRIC_Number__pc = 'S1234567Z';
            account.lastname='Account_PTM';
            insert account;
            
            accountList[0].NRIC_Number__pc = 'S1234567J';
            update account;
            
             
            
            Test.stopTest();   
            
        }Catch( Exception e){
           
        }
    }
    static testMethod void test_setAccountDWHStatusSynced_BeforeUpdate() {
        CRMS_Util util = new CRMS_Util();
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        
        Test.startTest();
        
        Account account = util.initializeAccount(false);
        account.DWH_Status__c = CRMS_Util.DWH_STATUS_QUEUED;
        insert account;
        
        account.DWH_Status__c = CRMS_Util.DWH_STATUS_SYNCED;
        update account;
        
        Account[] accountList = [SELECT DWH_Status__c,DWH_Last_Sync__c FROM Account WHERE Id = :account.Id];
        Test.stopTest();
        system.assertNotEquals(null, accountList[0].DWH_Status__c);
    }
    
    static testMethod void test_setAccountDWHStatusQueued_BeforeUpdate() {
        CRMS_Util util = new CRMS_Util();
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        
        Test.startTest();
        
        Account account = util.initializeAccount(false);
        //account.DWH_Status__c = CRMS_Util.DWH_STATUS_SYNCED;
        insert account;
        
        account.DWH_Status__c = CRMS_Util.DWH_STATUS_SYNCED;
        update account;
        
        Account[] accountList = [SELECT DWH_Status__c,DWH_Last_Sync__c FROM Account WHERE Id = :account.Id];
        Test.stopTest();
        system.assertNotEquals(null, accountList[0].DWH_Status__c);
    }
    
    /*static testMethod void test_createSyncQueue(){
        CRMS_Util util = new CRMS_Util();
        Account account = util.initializeAccount(false);
        account.DWH_Import__c = false;
        insert account;
        
        List<Sync_Queue__c> syncQueList = [SELECT Sync_Status__c,Account__c FROM Sync_Queue__c WHERE Account__c = :account.Id];
        //system.assertEquals(1,syncQueList.size());
        //system.assertEquals(CRMS_Util.SYNC_QUEUE_STATUS_PENDING,syncQueList[0].Sync_Status__c);
    }
    
    static testMethod void test_updateAccountStatus(){
        CRMS_Util util = new CRMS_Util();
        Account accountTest = util.initializeAccount(false);
        accountTest.DWH_Import__c = true;
        insert accountTest;
        
        Account[] testaccountList = [SELECT DWH_Status__c,DWH_Import__c FROM Account WHERE Id = :accountTest.Id];
        //system.assertEquals(1,testaccountList.size());
        //system.assertEquals(false, testaccountList[0].DWH_Import__c);
        //system.assertEquals(CRMS_Util.DWH_STATUS_SYNCED, testaccountList[0].DWH_Status__c);
    }*/
    
    static testMethod void test_updateSyncQueueRecord_BeforeDelete() {
        CRMS_Util util = new CRMS_Util();
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        
        Test.startTest();
        
        Account account1 = util.initializeAccount(false);
        account1.DWH_Status__c = CRMS_Util.DWH_STATUS_QUEUED;
        insert account1;
        
        String accountId = account1.Id;
        delete account1;
        
        List<Sync_Queue__c> syncQueListTest1 =[
            SELECT Account__c
                 , Id
                 , Notes__c
                 , Action__c
                 , Queued_Record_ID__c
                 , Sync_Status__c
                 , DWH_Data_Type__c
               FROM Sync_Queue__c 
              WHERE Queued_Record_ID__c = :accountId
        ];
        Test.stopTest();
        system.assertEquals(CRMS_Util.SYNC_ACTION_DELETE, syncQueListTest1[0].Action__c);
        
    }
    
    static testMethod void test_updateExistingSyncQueueRecord_BeforeDelete() {
        CRMS_Util util = new CRMS_Util();
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        
        Test.startTest();
        //Query ‘”Sync Queue” for records matching the criteria of Lead = Lead, Sync Status is ‘Pending’.  If a record if found
        
        //If Sync Queue record meeting criteria is not found
        Account account = util.initializeAccount(false);
        account.DWH_Status__c = CRMS_Util.DWH_STATUS_QUEUED;
        insert account;
        
        Sync_Queue__c syncQueue = new Sync_Queue__c();
        syncQueue.Account__c = account.Id;
        syncQueue.Sync_Status__c = CRMS_Util.SYNC_QUEUE_STATUS_PENDING;
        insert syncQueue;
        String accountId = account.Id;
       
        delete account;
        
        List<Sync_Queue__c> syncQueListTest1 =[
            SELECT Credit_Assessment__c
                 , Id
                 , Notes__c
                 , Action__c
                 , Queued_Record_ID__c
                 , Sync_Status__c
                 , DWH_Data_Type__c
               FROM Sync_Queue__c 
              WHERE Queued_Record_ID__c = :accountId
        ];
        Test.stopTest();
        system.assertEquals(CRMS_Util.SYNC_STATUS_DELETE, syncQueListTest1[0].Action__c);
        
    }
}