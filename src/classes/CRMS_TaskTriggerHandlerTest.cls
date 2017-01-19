/**
    Test class for the Task trigger
    Author: CRMS
    Version: 1.0
*/
@isTest
private class CRMS_TaskTriggerHandlerTest {
   
    static testMethod void test_BeforeInsert() {
        CRMS_Util util = new CRMS_Util();
        CRMS_Util.generateEndpoints();
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		
		Test.startTest(); 
        Task taskTest = util.initializeTask(false);
        taskTest.DWH_Status__c = CRMS_Util.DWH_STATUS_SYNCED;
        taskTest.Event_Date__c = date.today().adddays(10);
        taskTest.Hours__c = '10';
        taskTest.Minutes__c = '15';
        insert taskTest;
        
        Task[] testTaskList = [SELECT DWH_Status__c,DWH_Last_Sync__c FROM Task WHERE Id = :taskTest.Id];
        system.assertNotEquals(null, testTaskList[0].DWH_Status__c);
        
        Task taskTest1 = util.initializeTask(false);
        insert taskTest1;
        
        Test.stopTest();
    }
    
    static testMethod void test_setTaskDWHStatusSynced_BeforeUpdate() {
        CRMS_Util util = new CRMS_Util();
        CRMS_Util.generateEndpoints();
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		
		Test.startTest();
		
        Task task = util.initializeTask(false);
        insert task;
        
        task.DWH_Status__c = CRMS_Util.DWH_STATUS_SYNCED;
        update task;
        Test.stopTest();
        
        List<Task> testTaskList = [SELECT DWH_Status__c,DWH_Last_Sync__c FROM Task WHERE id = :task.Id];
        system.assertNotEquals(null, testTaskList[0].DWH_Status__c);
    }
    
    static testMethod void test_setTaskDWHStatusQueued_BeforeUpdate() {
        CRMS_Util util = new CRMS_Util();
        CRMS_Util.generateEndpoints();
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		
		Test.startTest();
        Task task = util.initializeTask(false);
        task.DWH_Status__c = CRMS_Util.DWH_STATUS_SYNCED;
        insert task;
        
        task.DWH_Status__c = null;
        update task;
        
        List<Task> testTaskList = [SELECT DWH_Status__c,DWH_Last_Sync__c FROM Task WHERE id = :task.Id];
        system.assertNotEquals(null, testTaskList[0].DWH_Status__c);
        Test.stopTest();
    }
    
    
    /*static testMethod void test_createSyncQueue(){
        CRMS_Util util = new CRMS_Util();
        Task task = util.initializeTask(false);
        task.DWH_Import__c = false;
        insert task;
        
        List<Sync_Queue__c> syncQueList = [SELECT Sync_Status__c,Task_Id__c FROM Sync_Queue__c WHERE Task_Id__c = :task.Id];
        system.assertEquals(1,syncQueList.size());
        system.assertEquals(CRMS_Util.SYNC_QUEUE_STATUS_PENDING,syncQueList[0].Sync_Status__c);
    }*/
    
    static testMethod void test_updateSyncQueueRecord_BeforeDelete() {
        CRMS_Util util = new CRMS_Util();
        CRMS_Util.generateEndpoints();
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		
		Test.startTest();
        Task task1 = util.initializeTask(false);
        task1.DWH_Status__c = CRMS_Util.DWH_STATUS_SYNCED;
        insert task1;
        List<Task> testTaskList = [SELECT DWH_Status__c,DWH_Last_Sync__c FROM Task WHERE id = :task1.Id];
        system.assertNotEquals(null, testTaskList[0].DWH_Status__c);
        
        String taskID = task1.Id;
        delete task1;
        Test.stopTest();
    }
    
    /*static testMethod void test_updateTaskStatus(){
        CRMS_Util util = new CRMS_Util();
        Task task = util.initializeTask(false);
        task.DWH_Import__c = true;
        insert task;
        
        List<Task> taskList = [SELECT DWH_Import__c,DWH_Status__c from Task where Id = :task.Id];
        system.assertEquals(false, taskList[0].DWH_Import__c);
        system.assertEquals(CRMS_Util.DWH_STATUS_SYNCED, taskList[0].DWH_Status__c);
        
    }*/
    
    static testMethod void test_updateExistingSyncQueueRecord_BeforeDelete() {
        CRMS_Util util = new CRMS_Util();
        CRMS_Util.generateEndpoints();
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		
		Test.startTest();
        //Query ??Sync Queue? for records matching the criteria of Lead = Lead, Sync Status is ?Pending?.  If a record if found
        
        //If Sync Queue record meeting criteria is not found
        Task task = util.initializeTask(false);
        task.DWH_Status__c = CRMS_Util.DWH_STATUS_QUEUED;
        insert task;
        String taskId = task.Id;
        Sync_Queue__c syncQueue = new Sync_Queue__c();
        syncQueue.Task_Id__c = taskId;
        syncQueue.Sync_Status__c = CRMS_Util.SYNC_QUEUE_STATUS_PENDING;
        insert syncQueue;
        delete task; 
        Test.stopTest();
        List<Sync_Queue__c> syncQueList = [SELECT Sync_Status__c,Task_Id__c FROM Sync_Queue__c WHERE Task_Id__c = :task.Id];
        system.assertEquals(1,syncQueList.size());
    }
    
    static testMethod void test_EmailLoansManager()
    {
    	CRMS_Util util = new CRMS_Util();
        CRMS_Util.generateEndpoints();
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		
		Account objAcc = new Account(Name = 'Account');
		insert objAcc;
		
		Opportunity objOpp = new Opportunity();
		objOpp.Name = 'Opportunity';
		objOpp.AccountId = objAcc.Id;
		objOpp.CloseDate = date.today();
		objOpp.StageName = 'In Progress';
		insert objOpp;
		
		Task objTask = new Task();
		objTask.Subject = 'Credit Assessment Completed (Approved)';
		objTask.WhatId = objOpp.Id;
		objTask.Status = 'Started';
		objTask.Priority = 'High';
		objTask.OwnerId = userInfo.getUserId();
		insert objTask;
    }
}