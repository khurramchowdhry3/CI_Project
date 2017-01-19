/**
	Test class for the Contact trigger handler class
	Author: Saket Joshi
	Version: 1.0
*/

@isTest
public with sharing class CRMS_ContactTriggerHandlerTest {

	//Method to test for DWH_Import__c = false on insert
	@isTest
	static void testFalseImport() {
		CRMS_Util objUtil = new CRMS_Util();
		CRMS_Util.generateEndpoints();
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		
		Account objAccount = objUtil.initializeAccount(true); 
		List<Contact> lstContact = CRMS_Util.generateContactList(30, false, objAccount.Id);
		
		Test.startTest();
		insert lstContact;
		Test.stopTest();
		
		List<Contact> lstContactNew = new List<Contact> ();
		lstContactNew = [SELECT DWH_Status__c, DWH_Last_Sync__c FROM Contact];

		for(Contact contact : lstContactNew)
			system.assertNotEquals(null, contact.DWH_Status__c);
	}
	
	//Method to test for DWH_Import__c = true on insert
	@isTest
	static void testTrueImport() {
		CRMS_Util objUtil = new CRMS_Util();
		CRMS_Util.generateEndpoints();
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		
		Account objAccount = objUtil.initializeAccount(true);
		List<Contact> lstContact = CRMS_Util.generateContactList(30, false, objAccount.Id);
		
		Test.startTest();
		
		for(Contact objContact : lstContact)
			objContact.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
		insert lstContact;
		Test.stopTest();
		
		List<Contact> lstContactNew = new List<Contact> ();
		lstContactNew = [SELECT DWH_Status__c, DWH_Last_Sync__c FROM Contact];
		
		system.assertNotEquals(0, lstContactNew.size());
		for(Contact objContact : lstContactNew)
			system.assertNotEquals(null, objContact.DWH_Last_Sync__c);
	}

	//Method to test for DWH_Import = true on update
	@isTest
	static void testImportChangeFalseToTrue() {
		CRMS_Util objUtil = new CRMS_Util();
		CRMS_Util.generateEndpoints();
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		
		Account objAccount = objUtil.initializeAccount(true);
		List<Contact> lstContact = CRMS_Util.generateContactList(30, false, objAccount.Id);
		insert lstContact;
		
		Test.startTest();
		for(Contact objContact : lstContact)
			objContact.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
		
		update lstContact;
		Test.stopTest();
		
		List<Contact> lstContactNew = new List<Contact> ();
		lstContactNew = [SELECT DWH_Status__c, DWH_Last_Sync__c FROM Contact];
		
		system.assertNotEquals(0, lstContactNew.size());
		for(Contact objContact : lstContactNew)
			system.assertNotEquals(null, objContact.DWH_Last_Sync__c);
	}
	
	//Method to test for DWH_Import = false on update
	@isTest
	static void testImportChangeTrueToFalse() {
		CRMS_Util objUtil = new CRMS_Util();
		CRMS_Util.generateEndpoints();
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		
		Account objAccount = objUtil.initializeAccount(true);
		List<Contact> lstContact = CRMS_Util.generateContactList(30, false, objAccount.Id);
		for(Contact objContact : lstContact)
			objContact.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
		
		insert lstContact;
		
		Test.startTest();
		for(Contact objContact : lstContact)
			objContact.DWH_Status__c = null;
		
		update lstContact;
		Test.stopTest();
		
		List<Contact> lstContactNew = new List<Contact> ();
		lstContactNew = [SELECT DWH_Status__c, DWH_Last_Sync__c FROM Contact];
		
		system.assertNotEquals(0, lstContactNew.size());
		for(Contact objContact : lstContactNew)
			system.assertNotEquals(null, objContact.DWH_Status__c);
	}
	
	//Method to test deletion of contact record
	/*@isTest
	static void testDeleteContact() {
		CRMS_Util objUtil = new CRMS_Util();
		
		Account objAccount = objUtil.initializeAccount(true);
		List<Contact> lstContact = CRMS_Util.generateContactList(30, false, objAccount.Id);
		insert lstContact;
		
		Set<Id> setContactId = new Set<Id> ();
		for(Contact objContact : lstContact)
			setContactId.add(objContact.Id);
		
		Test.startTest();
		delete lstContact;
		Test.stopTest();
		
		List<Sync_Queue__c> lstSyncQueue = new List<Sync_Queue__c>();
		lstSyncQueue = [SELECT DWH_Data_Type__c, Sync_Status__c, Action__c FROM Sync_Queue__c WHERE Contact__c = null];

		//system.assertNotEquals(0, lstSyncQueue.size());
		for(Sync_Queue__c objQueue : lstSyncQueue)
			//system.assertEquals(CRMS_Constants.SYNC_STATUS_STALE, objQueue.Sync_Status__c);
	}*/
	
	static testMethod void test_createSyncQueueRecord_BeforeDelete() {
        CRMS_Util util = new CRMS_Util();
        CRMS_Util.generateEndpoints();
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        
        Account objAccount = util.initializeAccount(true);
        Contact[] contactList = CRMS_Util.generateContactList(1, false, objAccount.Id);
        Contact contact = contactList.get(0);
        contact.DWH_Status__c = CRMS_Util.DWH_STATUS_QUEUED;
        contact.Salutation = 'Mr.';
        insert contact;
        
        String contactId = contact.Id;
        delete contact;
        
        List<Sync_Queue__c> syncQueListTest1 =[
            SELECT Account__c
                 , Id
                 , Notes__c
                 , Action__c
                 , Queued_Record_ID__c
                 , Sync_Status__c
                 , DWH_Data_Type__c
               FROM Sync_Queue__c 
              WHERE Queued_Record_ID__c = :contactId
        ];
        
        system.assertEquals(CRMS_Util.DWH_DATA_TYPE_CONTACT,syncQueListTest1[0].DWH_Data_Type__c);
        
    }
	
	@isTest
	static void test_updateExistingSyncQueueRecord_BeforeDelete() {
        CRMS_Util util = new CRMS_Util();
        CRMS_Util.generateEndpoints();
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        
        Account objAccount = util.initializeAccount(true);
        Contact[] contactList = CRMS_Util.generateContactList(1, false, objAccount.Id);
        Contact contact = contactList.get(0);
        contact.DWH_Status__c = CRMS_Util.DWH_STATUS_QUEUED;
        contact.Salutation = 'Ms.';
        insert contact;
        
        Sync_Queue__c syncQueue = new Sync_Queue__c();
        syncQueue.Contact__c = contact.Id;
        syncQueue.Sync_Status__c = CRMS_Util.SYNC_QUEUE_STATUS_PENDING;
        insert syncQueue;
        String contactId = contact.Id;
       
        delete contact;
        
        List<Sync_Queue__c> syncQueListTest1 =[
            SELECT Credit_Assessment__c
                 , Id
                 , Notes__c
                 , Action__c
                 , Queued_Record_ID__c
                 , Sync_Status__c
                 , DWH_Data_Type__c
               FROM Sync_Queue__c 
              WHERE Queued_Record_ID__c = :contactId
        ];
        
        system.assertEquals(CRMS_Util.SYNC_STATUS_DELETE, syncQueListTest1[0].Action__c);
        system.assertEquals(CRMS_Util.SYNC_STATUS_STALE, syncQueListTest1[0].Sync_Status__c);
        
    }
}