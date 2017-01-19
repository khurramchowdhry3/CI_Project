/**
	Test class for handler for Case trigger
	Author: Saket Joshi
	Version: 1.0
*/

@isTest
public with sharing class CRMS_CaseTriggerTest {

	//Method to test for DWH_Import__c = false on insert
	@isTest
	static void testFalseImport() {
		CRMS_Util objUtil = new CRMS_Util();
		CRMS_Util.generateEndpoints();
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		
		List<Case> lstCase = CRMS_Util.generateCaseList(30, false);
		
		Test.startTest();
		//lstCase[0].DWH_Status__c = CRMS_Constants.DWH_STATUS_QUEUED;
		insert lstCase;
		Test.stopTest();
		List<Case> lstCaseNew = new List<Case> ();
		lstCaseNew = [SELECT DWH_Status__c, DWH_Last_Sync__c FROM Case where Id IN : lstCase];
		for(Case objCase : lstCaseNew)
		    system.assertNotEquals(null, objCase.DWH_Status__c);
	}
	
	//Method to test for DWH_Import__c = true on insert
	@isTest
	static void testTrueImport() {
		CRMS_Util objUtil = new CRMS_Util();
		
		CRMS_Util.generateEndpoints();
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		
		List<Case> lstCase = CRMS_Util.generateCaseList(30, false);
		
		Test.startTest();
		for(Case objCase : lstCase)
			objCase.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
		
		insert lstCase;
		Test.stopTest();
		List<Case> lstCaseNew = new List<Case> ();
		lstCaseNew = [SELECT DWH_Status__c, DWH_Last_Sync__c FROM Case];
		for(Case objCase : lstCaseNew)
		    system.assertNotEquals(null, objCase.DWH_Status__c);
	}

	//Method to test for DWH_Import = true on update
	@isTest
	static void testImportChangeFalseToTrue() {
		CRMS_Util objUtil = new CRMS_Util();
		CRMS_Util.generateEndpoints();
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		
		List<Case> lstCase = CRMS_Util.generateCaseList(30, false);
		//lstCase[0].DWH_Status__c = CRMS_Constants.DWH_STATUS_QUEUED;
		insert lstCase;
		
		Test.startTest();
		for(Case objCase : lstCase)
			objCase.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
		
		update lstCase;
		Test.stopTest();
		
        List<Sync_Queue__c> lstSyncQueue = new List<Sync_Queue__c>();
		lstSyncQueue = [SELECT DWH_Data_Type__c, Sync_Status__c, Action__c FROM Sync_Queue__c WHERE Case__c IN: lstCase];

		system.assertNotEquals(0, lstSyncQueue.size());
        
		List<Case> lstCaseNew = new List<Case> ();
		lstCaseNew = [SELECT DWH_Status__c, DWH_Last_Sync__c FROM Case];
		
		system.assertNotEquals(0, lstCaseNew.size());
		for(Case objCase : lstCaseNew)
			system.assertNotEquals(null, objCase.DWH_Status__c);
	}
	
	//Method to test for DWH_Import = false on update
	@isTest
	static void testImportChangeTrueToFalse() {
		CRMS_Util objUtil = new CRMS_Util();
		CRMS_Util.generateEndpoints();
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		
		List<Case> lstCase = CRMS_Util.generateCaseList(30, false);
		for(Case objCase : lstCase)
			objCase.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
		
		insert lstCase;
		
		Test.startTest();
		for(Case objCase : lstCase)
			objCase.DWH_Status__c = null;
		
		update lstCase;
		Test.stopTest();
		
		List<Case> lstCaseNew = new List<Case> ();
		lstCaseNew = [SELECT DWH_Status__c, DWH_Last_Sync__c FROM Case];
		
		system.assertNotEquals(0, lstCaseNew.size());
		for(Case objCase : lstCaseNew)
			system.assertNotEquals(null, objCase.DWH_Status__c);
	}
	
	//Method to test deletion of Case record
	@isTest
	static void testDeleteCase() {
		CRMS_Util objUtil = new CRMS_Util();
		CRMS_Util.generateEndpoints();
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		
		List<Case> lstCase = CRMS_Util.generateCaseList(30, false);
		insert lstCase;
		
		Set<Id> setCaseID = new Set<Id> ();
		for(Case objCase : lstCase)
			setCaseID.add(objCase.Id);
        Sync_Queue__c syncQueue = new Sync_Queue__c();
        syncQueue.Case__c = lstCase[0].Id;
        syncQueue.Sync_Status__c = CRMS_Util.SYNC_QUEUE_STATUS_PENDING;
        insert syncQueue;
		Test.startTest();
		delete lstCase;
		Test.stopTest();
		
		List<Sync_Queue__c> lstSyncQueue = new List<Sync_Queue__c>();
		lstSyncQueue = [SELECT DWH_Data_Type__c, Sync_Status__c, Action__c FROM Sync_Queue__c];

		system.assertNotEquals(0, lstSyncQueue.size());
        
        List<Sync_Queue__c> syncQueListTest1 =[
            SELECT Credit_Assessment__c
                 , Id
                 , Notes__c
                 , Action__c
                 , Queued_Record_ID__c
                 , Sync_Status__c
                 , DWH_Data_Type__c
               FROM Sync_Queue__c 
              WHERE Queued_Record_ID__c = :lstCase[0].Id
        ];
		system.assertEquals(CRMS_Util.SYNC_STATUS_DELETE, syncQueListTest1[0].Action__c);
	}

}