/**
	Trigger for maintaining the sync between Contact records in SFDC and DWH
	Author: Saket Joshi
	Version: 1.0
*/

trigger CRMS_ContactTrigger on Contact (after insert, after update, before delete, 
before insert, before update) {

	List<Contact> lstImportedContacts = new List<Contact> ();
	List<Contact> lstNotImportedContacts = new List<Contact> ();
	CRMS_ContactTriggerHandler objHandler = new CRMS_ContactTriggerHandler();

	//Get all the contacts before delete and set DWH status accordingly
	if(trigger.isBefore && trigger.isInsert) {
		for(Contact objContact : trigger.new) {
			if(objContact.Salutation != objContact.Salutation__c)
			{
				objContact.Salutation__c = objContact.Salutation;
			}
			if(objContact.DWH_Status__c == CRMS_Constants.DWH_STATUS_SYNCED)
				lstImportedContacts.add(objContact);
			else
				lstNotImportedContacts.add(objContact);
		}
		
		if(lstImportedContacts != null && !lstImportedContacts.isEmpty())
			objHandler.setDwhStatusSynced(lstImportedContacts);
		if(lstNotImportedContacts != null && !lstNotImportedContacts.isEmpty())
			objHandler.setDwhStatusQueued(lstNotImportedContacts);
	}
	
	//Process the inserted Contact records and create Sync Queue records for the same
	if(trigger.isAfter && trigger.isInsert) {
		if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER && !CRMS_ContactTriggerHandler.isTriggerCalledOnInsert && !system.isFuture() && !system.isBatch() && !system.isScheduled()) {
    		//AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_INSERT);
    		//CRMS_DwhSyncHandler.doSynchronizationFromFuture(new List<Id> (trigger.newMap.keySet()), CRMS_Constants.SYNC_ACTION_UPDATE);
    		CRMS_ContactTriggerHandler.isTriggerCalledOnInsert = true;
		}
	}
	
	//Before update method
	if(trigger.isBefore && trigger.isUpdate) {
        for(Contact objContact : trigger.new) {
        	if(objContact.Salutation != objContact.Salutation__c)
			{
				objContact.Salutation__c = objContact.Salutation;
			}
            if (objContact.DWH_Status__c == CRMS_Constants.DWH_STATUS_SYNCED) {
                lstImportedContacts.add(objContact);
            } else  { //if (objContact.DWH_Import__c == false && Trigger.oldMap.get(objContact.Id).DWH_Import__c == false)
                lstNotImportedContacts.add(objContact);
            }
        }
        if (!lstImportedContacts.isEmpty()) {
            objHandler.setDwhStatusSynced(lstImportedContacts);
        }
        if (!lstNotImportedContacts.isEmpty()) {
            objHandler.setDwhStatusQueued(lstNotImportedContacts);
        }
	}
	
	//After update method
	if(trigger.isAfter && trigger.isUpdate) {
		if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER && !CRMS_ContactTriggerHandler.isTriggerCalled && !system.isFuture() && !system.isBatch() && !system.isScheduled()) {
    		//AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_UPDATE);
    		//CRMS_DwhSyncHandler.doSynchronizationFromFuture(new List<Id> (trigger.newMap.keySet()), CRMS_Constants.SYNC_ACTION_UPDATE);
    		CRMS_ContactTriggerHandler.isTriggerCalled = true;
		}
	}
	
	//Before delete method
	if(trigger.isBefore && trigger.isDelete) {
		List<Contact> lstContact = new List<Contact> ();
		for(Contact objContact : trigger.old)
		{
			if(objContact.IsConverted__c == false)
			{
				lstContact.add(objContact);
			}
		}
		system.debug('**** lstContact '+lstContact);
		if(lstContact != null && !lstContact.isEmpty())
			objHandler.updateSyncQueueRecord(lstContact);
	}
}