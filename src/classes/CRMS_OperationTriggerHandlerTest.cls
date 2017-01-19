@isTest
public class CRMS_OperationTriggerHandlerTest {

	/*@isTest(seeAllData=true)
    static void testCRMS_CreditAssessmentTriggerHandler()
    {
    	Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
    	
    	Test.startTest();
        list<RecordType> lstRecType = [Select r.SobjectType, r.Id, r.DeveloperName, r.Name 
                           From RecordType r 
                            where r.SobjectType = 'Opportunity' and r.DeveloperName like 'Application%'];
        
        Opportunity objOpp = new Opportunity();
        	objOpp.Name = 'test';
            objOpp.CloseDate = date.today();
        	objOpp.StageName = 'Closed Won';
        	objOpp.RecordTypeId = lstRecType[0].Id;
        	
        	insert objOpp;
        	objOpp.Contract_Signed__c = true;
        	update objOpp;
        	
        	
        
        Operation__c lstOperation = [select Id,Opportunity__c,Payment_Received__c,Status__c from Operation__c where Opportunity__c =:objOpp.Id];
        System.debug('lstOperation>>>'+lstOperation);
        lstOperation.Status__c = 'Payment Received';  
        lstOperation.Payment_Received__c = true;
        update lstOperation;
        
        lstOperation.Status__c = 'Payment Outstanding';  
        lstOperation.Payment_Received__c = false;
        update lstOperation;
        
        Test.stopTest();
        
        //list<Task> lstTask = [select Id,Subject,WhatId from Task where WhatId =:objOpp.Id];
        //System.debug('lstTask[0].Subject'+lstTask[0].Subject);
		//System.assertEquals(lstTask[0].Subject, 'Follow Up With Client');
    }*/
    
    static testMethod void test_setOperationDWHStatusSynced() {
        CRMS_Util util = new CRMS_Util();
        CRMS_Util.generateEndpoints();
    	Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
    	
    	Test.startTest();
        Operation__c operationObj = util.initializeOperation(false);
        operationObj.DWH_Status__c = CRMS_Util.DWH_STATUS_SYNCED;
        insert operationObj;
        Test.stopTest();
        List<Operation__c> testOperationList = [select DWH_Status__c,DWH_Last_Sync__c from Operation__c where id = :operationObj.Id];
    	System.assertNotEquals(null, testOperationList[0].DWH_Status__c);
    }
    
    static testMethod void test_setOperationDWHStatusQueued() {
        CRMS_Util util = new CRMS_Util();
       	CRMS_Util.generateEndpoints();
    	Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
    	
    	Test.startTest();
        Operation__c operationObj = util.initializeOperation(false);
        insert operationObj;
        Test.stopTest();
        List<Operation__c> testOperationList = [select DWH_Status__c from Operation__c where id = :operationObj.Id];
   		System.assertNotEquals(null, testOperationList[0].DWH_Status__c);
    }
    
    static testMethod void test_updateOperationDWHStatusSynced() {
        CRMS_Util util = new CRMS_Util();
        CRMS_Util.generateEndpoints();
    	Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
    	
    	Test.startTest();
        Operation__c operationObj = util.initializeOperation(false);
        insert operationObj;
        
        operationObj.DWH_Status__c = CRMS_Util.DWH_STATUS_SYNCED;
        update operationObj;
        Test.stopTest();
        List<Operation__c> testOperationList = [select DWH_Status__c,DWH_Last_Sync__c from Operation__c where id = :operationObj.Id];
    	System.assertNotEquals(null, testOperationList[0].DWH_Status__c);
    }
    
    static testMethod void test_updateOperationDWHStatusQueued() {
        CRMS_Util util = new CRMS_Util();
       	CRMS_Util.generateEndpoints();
    	Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
    	
    	Test.startTest();
        Operation__c operationObj = util.initializeOperation(false);
        operationObj.DWH_Status__c = CRMS_Util.DWH_STATUS_SYNCED;
        insert operationObj;
        
        operationObj.DWH_Status__c = null;
        update operationObj;
        Test.stopTest();
        List<Operation__c> testOperationList = [select DWH_Status__c from Operation__c where id = :operationObj.Id];
    	System.assertNotEquals(null, testOperationList[0].DWH_Status__c);
    }
   /*
    static testMethod void test_updateOperationStatus() {
        CRMS_Util util = new CRMS_Util();
        
        Operation__c operationObj = util.initializeOperation(false);
        operationObj.DWH_Import__c = true;
        insert operationObj;
        
        List<Operation__c> testOperationList = [select DWH_Status__c,DWH_Import__c from Operation__c where id = :operationObj.Id];
        system.assertEquals(false, testOperationList[0].DWH_Import__c);
        system.assertEquals(CRMS_Util.DWH_STATUS_SYNCED, testOperationList[0].DWH_Status__c);
    }
    
    static testMethod void test_createSyncQueueAfterOperationInsert() {
        CRMS_Util util = new CRMS_Util();
        
                                
        Operation__c operationObj = util.initializeOperation(false);
        operationObj.DWH_Import__c = false;
        insert operationObj;
        
        List<Sync_Queue__c> syncQueList = [SELECT Sync_Status__c FROM Sync_Queue__c WHERE Operation__c = :operationObj.Id];
        system.assertEquals(1,syncQueList.size());
        system.assertEquals(CRMS_Util.SYNC_QUEUE_STATUS_PENDING,syncQueList[0].Sync_Status__c);
    }
    
    static testMethod void test_createSyncQueueAfterOperationUpdate() {
        CRMS_Util util = new CRMS_Util();
        
                                
        Operation__c operationObj = util.initializeOperation(false);
        operationObj.DWH_Import__c = true;
        insert operationObj;
        
        List<Operation__c> operationList = [SELECT DWH_Import__c,DWH_Status__c FROM Operation__c WHERE Id = :operationObj.Id];
        operationList[0].DWH_Import__c = false;
        operationList[0].DWH_Status__c = CRMS_Util.DWH_STATUS_QUEUED;
        update operationList;
        
        List<Sync_Queue__c> syncQueList = [SELECT Sync_Status__c FROM Sync_Queue__c WHERE Operation__c = :operationObj.Id];
        system.assertEquals(1,syncQueList.size());
        system.assertEquals(CRMS_Util.SYNC_QUEUE_STATUS_PENDING,syncQueList[0].Sync_Status__c);
    }*/
    
    static testMethod void test_createSyncQueueRecord_BeforeDelete() {
        CRMS_Util util = new CRMS_Util();
        CRMS_Util.generateEndpoints();
    	Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
    	
    	Test.startTest();
        //If Sync Queue record meeting criteria is not found
        Operation__c operationObj1 = util.initializeOperation(false);
        operationObj1.DWH_Status__c = CRMS_Util.DWH_STATUS_QUEUED;
        insert operationObj1;
        
        String operationId = operationObj1.Id;
        delete operationObj1;
        Test.stopTest();
        List<Sync_Queue__c> syncQueListTest1 =[
            SELECT Operation__c
                 , Id
                 , Notes__c
                 , Action__c
                 , Queued_Record_ID__c
                 , Sync_Status__c
                 , DWH_Data_Type__c
               FROM Sync_Queue__c 
              WHERE Queued_Record_ID__c = :operationId
        ];
        
    }
    
    static testMethod void test_updateSyncQueueRecord_BeforeDelete() {
        CRMS_Util util = new CRMS_Util();
        CRMS_Util.generateEndpoints();
    	Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
    	
    	Test.startTest();
        //If Sync Queue record meeting criteria is not found
        Operation__c operation = util.initializeOperation(false);
        operation.DWH_Status__c = CRMS_Util.DWH_STATUS_QUEUED;
        insert operation;
        
        Sync_Queue__c syncQueue = new Sync_Queue__c();
        syncQueue.Operation__c = operation.Id;
        syncQueue.Sync_Status__c = CRMS_Util.SYNC_QUEUE_STATUS_PENDING;
        insert syncQueue;
        system.debug('***syncQueue '+syncQueue); 
        String operationId = operation.Id;
       
        delete operation;
        Test.stopTest();
        List<Sync_Queue__c> syncQueListTest1 =[
            SELECT Credit_Assessment__c
                 , Id
                 , Notes__c
                 , Action__c
                 , Queued_Record_ID__c
                 , Sync_Status__c
                 , DWH_Data_Type__c
               FROM Sync_Queue__c 
              WHERE Queued_Record_ID__c = :operationId
        ];
        
        
    }
}