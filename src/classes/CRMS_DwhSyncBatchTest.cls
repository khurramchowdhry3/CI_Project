/**
	Test class for the batch class for DWH sync
	Author: Saket Joshi
	Created Date: 31/03/2015		Version: 1.0
*/

@isTest
public with sharing class CRMS_DwhSyncBatchTest {

	//Method to create the test data for contacts
	static void createTestData() {
		CRMS_Util objUtil = new CRMS_Util();
		CRMS_Util.generateEndpoints();
		
		List<Account> lstAccount = new List<Account> ();
		List<Sync_Queue__c> lstQueue = new List<Sync_Queue__c> ();
		List<Contact> lstContact = new List<Contact> ();
		List<Contact> lstContactToDelete = new List<Contact> ();
		List<Task> lstTaskToInsert = new List<Task> ();
		
		CRMS_Util.generateCampaignList(10, true);
		CRMS_Util.generateCaseList(10, true);
		
		CRMS_Util.generateUserList(2, true);
		
		for(Integer i = 0 ; i < 10 ; i++) {
			lstTaskToInsert.add( new Task ( Subject = 'Call Testclass', Status = 'Not Started', Priority = 'Normal' ) );
		}
		
		insert lstTaskToInsert;
		objUtil.initializeCreditAssessment(true);
		objUtil.initializeOperation(true);
		Opportunity newOpp = objUtil.initializeOpportunity(true);
		
		objUtil.initializeLead(true);
		for(Integer i = 0 ; i < 10 ; i++) {
			lstAccount.add(objUtil.initializeAccount(false));
		}
		insert lstAccount;
		
		CRMS_Util.generateODGList(10, true, lstAccount[0].Id, newOpp.Id);
		
		lstContact = CRMS_Util.generateContactList(10, true, lstAccount[0].Id);
		for(Account objAccount : lstAccount) {
			lstQueue.add( new Sync_Queue__c ( Account__c = objAccount.Id,
											DWH_Data_Type__c = CRMS_Constants.DWH_DATA_TYPE_ACCOUNT,
											Queued_Record_ID__c = objAccount.Id,
											Sync_Status__c = CRMS_Constants.SYNC_QUEUE_STATUS_PENDING,
											Action__c = CRMS_Constants.SYNC_ACTION_CREATE) );
		}
		
		for(Contact objContact : lstContact) {
			lstQueue.add( new Sync_Queue__c ( Contact__c = objContact.Id,
										DWH_Data_Type__c = CRMS_Constants.DWH_DATA_TYPE_CONTACT,
										Queued_Record_ID__c = objContact.Id,
										Sync_Status__c = CRMS_Constants.SYNC_QUEUE_STATUS_PENDING,
										Action__c = CRMS_Constants.SYNC_ACTION_CREATE) );
		}
		insert lstQueue;
		
		for(Integer i = 0 ; i < 5 ; i++)
			lstContactToDelete.add(lstContact.get(i));
		
		delete [SELECT Id
				FROM Sync_Queue__c
				WHERE Contact__c IN :lstContactToDelete];
				
		delete lstContactToDelete;
	}

	//Method to test the batch for contact records without sync queue records
	@isTest
	static void testBatchWithoutQueue() {
		createTestData();
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		Test.startTest();
		Database.executeBatch(new CRMS_DwhSyncBatch());
		Test.stopTest();
		
		List<Sync_Queue__c> lstQueue = new List<Sync_Queue__c> ();
		lstQueue = [SELECT Id, Notes__c, Sync_Status__c FROM Sync_Queue__c];
		
		system.assertNotEquals(0, lstQueue.size());
	
		for(Sync_Queue__c objQueue : lstQueue) {
			
			system.assert(
				objQueue.Sync_Status__c.equals(CRMS_Constants.SYNC_QUEUE_STATUS_SUCCESS) || 
				objQueue.Sync_Status__c.equals(CRMS_Constants.SYNC_STATUS_STALE) || 
				objQueue.Sync_Status__c.equals(CRMS_Constants.SYNC_QUEUE_STATUS_PENDING)
			);
		} //End of for loop on every queue record
	}

}