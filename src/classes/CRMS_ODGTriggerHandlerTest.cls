/**
	Test class for the ODG trigger handler class
	Author: Saket Joshi
	Version: 1.0
*/

@isTest
public with sharing class CRMS_ODGTriggerHandlerTest {

	//Method to test for DWH_Import__c = false on insert
	@isTest
	static void testFalseImport() {
		CRMS_Util objUtil = new CRMS_Util();
		CRMS_Util.generateEndpoints();
		RecordType contactType = [SELECT Id FROM RecordType WHERE Name = 'Person Hong Kong' LIMIT 1];
        Account account = new Account(RecordTypeId=contactType.Id);
        account.lastname='Account_PTMA';
        insert account;
        
		Opportunity objOpportunity = objUtil.initializeOpportunity(true);
		
		List<Guarantors__c> lstGuarantors = CRMS_Util.generateODGList(30, false, account.Id, objOpportunity.Id);
		
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		Test.startTest();
		insert lstGuarantors;
		Test.stopTest();
		
		List<Guarantors__c> lstGurantorNew = new List<Guarantors__c> ();
		lstGurantorNew = [SELECT DWH_Status__c, DWH_Last_Sync__c FROM Guarantors__c];
		
		system.assertNotEquals(0, lstGurantorNew.size());
	}
	
	//Method to test for DWH_Import__c = true on insert
	@isTest
	static void testTrueImport() {
		CRMS_Util objUtil = new CRMS_Util();
		CRMS_Util.generateEndpoints();
		RecordType contactType = [SELECT Id FROM RecordType WHERE Name = 'Person Hong Kong' LIMIT 1];
        Account account = new Account(RecordTypeId=contactType.Id);
        account.lastname='Account_PTMA';
        insert account;
        
		Opportunity objOpportunity = objUtil.initializeOpportunity(true);
		
		List<Guarantors__c> lstGuarantors = CRMS_Util.generateODGList(30, false, account.Id, objOpportunity.Id);
		
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		Test.startTest();
		
		for(Guarantors__c objGuarantor : lstGuarantors)
			objGuarantor.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
		
		insert lstGuarantors;
		Test.stopTest();
		
		List<Guarantors__c> lstGurantorNew = new List<Guarantors__c> ();
		lstGurantorNew = [SELECT DWH_Status__c, DWH_Last_Sync__c FROM Guarantors__c];
		
		system.assertNotEquals(0, lstGurantorNew.size());
	}

	//Method to test for DWH_Import = true on update
	@isTest
	static void testImportChangeFalseToTrue() {
		CRMS_Util objUtil = new CRMS_Util();
		CRMS_Util.generateEndpoints();
		RecordType contactType = [SELECT Id FROM RecordType WHERE Name = 'Person Hong Kong' LIMIT 1];
        Account account = new Account(RecordTypeId=contactType.Id);
        account.lastname='Account_PTMA';
        insert account;
        
		Opportunity objOpportunity = objUtil.initializeOpportunity(true);
		
		List<Guarantors__c> lstGuarantors = CRMS_Util.generateODGList(30, false, account.Id, objOpportunity.Id);
		for(Guarantors__c objGuarantor : lstGuarantors)
			objGuarantor.DWH_Status__c = CRMS_Constants.DWH_STATUS_QUEUED;
		insert lstGuarantors;
		
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		Test.startTest();
		for(Guarantors__c objGuarantor : lstGuarantors)
			objGuarantor.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
		
		update lstGuarantors;
		Test.stopTest();
		
		List<Guarantors__c> lstGurantorNew = new List<Guarantors__c> ();
		lstGurantorNew = [SELECT DWH_Status__c, DWH_Last_Sync__c FROM Guarantors__c];
		
		system.assertNotEquals(0, lstGurantorNew.size());
	}
	
	//Method to test for DWH_Import = false on update
	@isTest
	static void testImportChangeTrueToFalse() {
		CRMS_Util objUtil = new CRMS_Util();
		CRMS_Util.generateEndpoints();
		RecordType contactType = [SELECT Id FROM RecordType WHERE Name = 'Person Hong Kong' LIMIT 1];
        Account account = new Account(RecordTypeId=contactType.Id);
        account.lastname='Account_PTMA';
        insert account;
        
		Opportunity objOpportunity = objUtil.initializeOpportunity(true);
		
		List<Guarantors__c> lstGuarantors = CRMS_Util.generateODGList(30, false, account.Id, objOpportunity.Id);
		for(Guarantors__c objGuarantor : lstGuarantors)
			objGuarantor.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
		
		insert lstGuarantors;
		
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		Test.startTest();
		for(Guarantors__c objGuarantor : lstGuarantors)
			objGuarantor.DWH_Status__c = null;
		
		update lstGuarantors;
		Test.stopTest();
		
		List<Guarantors__c> lstGurantorNew = new List<Guarantors__c> ();
		lstGurantorNew = [SELECT DWH_Status__c, DWH_Last_Sync__c FROM Guarantors__c];
		
		system.assertNotEquals(0, lstGurantorNew.size());
	}
	
	//Method to test deletion of contact record
	@isTest
	static void testDeleteContact() {
		CRMS_Util objUtil = new CRMS_Util();
		CRMS_Util.generateEndpoints();
		RecordType contactType = [SELECT Id FROM RecordType WHERE Name = 'Person Hong Kong' LIMIT 1];
        Account account = new Account(RecordTypeId=contactType.Id);
        account.lastname='Account_PTMA';
        insert account;
		
        Opportunity objOpportunity = objUtil.initializeOpportunity(true);
		Set<Id> guarantorsIdSet = new Set<Id>();
		
		List<Guarantors__c> lstGuarantors = CRMS_Util.generateODGList(30, false, account.Id, objOpportunity.Id);
		for (Guarantors__c guarantor : lstGuarantors) {
		   guarantor.DWH_Status__c = CRMS_Constants.DWH_STATUS_QUEUED;
		}
		insert lstGuarantors;
		
		for (Guarantors__c guarantor : lstGuarantors) {
		    guarantorsIdSet.add(guarantor.Id);
		}
		
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		Test.startTest();
		delete lstGuarantors;
		Test.stopTest();
		
		List<Sync_Queue__c> lstSyncQueue = new List<Sync_Queue__c>();
		lstSyncQueue = [
		    SELECT Sync_Status__c
		         , Action__c
		         , Queued_Record_ID__c
		         , Notes__c 
		       FROM Sync_Queue__c 
		      WHERE Queued_Record_ID__c 
		        IN :guarantorsIdSet ];

		system.assertNotEquals(0, lstSyncQueue.size());
	}
	
	static testMethod void test_updateExistingSyncQueueRecord_BeforeDelete() {
        CRMS_Util objUtil = new CRMS_Util();
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        Test.startTest();
        //Query ‘”Sync Queue” for records matching the criteria of Lead = Lead, Sync Status is ‘Pending’.  If a record is found
        
        //If Sync Queue record meeting criteria is not found
        RecordType contactType = [SELECT Id FROM RecordType WHERE Name = 'Person Hong Kong' LIMIT 1];
        Account account = new Account(RecordTypeId=contactType.Id);
        account.lastname='Account_PTMA';
        insert account;
		Opportunity objOpportunity = objUtil.initializeOpportunity(true);
		Sync_Queue__c[] syncQueueList = new Sync_Queue__c[] {};
		Set<String> guarantorsIdSet = new Set<String>();
		
		List<Guarantors__c> lstGuarantors = CRMS_Util.generateODGList(30, false, account.Id, objOpportunity.Id);
		for (Guarantors__c guarantor : lstGuarantors) {
		    guarantor.DWH_Status__c = CRMS_Constants.DWH_STATUS_QUEUED;
		}
		insert lstGuarantors;
		for (Guarantors__c guarantor : lstGuarantors) {
		    String tempId = guarantor.Id;
		    guarantorsIdSet.add(tempId);
		    Sync_Queue__c syncQueue = new Sync_Queue__c();
            syncQueue.ODG__c = guarantor.Id;
            syncQueue.Sync_Status__c = CRMS_Util.SYNC_QUEUE_STATUS_PENDING;
            syncQueueList.add(syncQueue);
		}
        insert syncQueueList;
        delete lstGuarantors;
        Test.stopTest();
        system.assertEquals(syncQueueList[0].Sync_Status__c, CRMS_Util.SYNC_QUEUE_STATUS_PENDING);
    }
}