/**
	Trigger to create the sync queue records for Case object
	Author: Saket Joshi
	Version: 1.0
*/

trigger CRMS_CaseTrigger on Case (after insert, after update, before delete, 
before insert, before update) {

	//Before insert method
	if(trigger.isBefore && trigger.isInsert) {
		List<Case> lstImportedCases = new List<Case> ();
		List<Case> lstNotImportedCases = new List<Case> ();
		
		CRMS_CaseTriggerHandler objHandler = new CRMS_CaseTriggerHandler();
		
		for(Case objCase : trigger.new) {
			if(objCase.DWH_Status__c == CRMS_Constants.DWH_STATUS_SYNCED)
				lstImportedCases.add(objCase);
			else
				lstNotImportedCases.add(objCase);
		}
		
		if(lstImportedCases != null && !lstImportedCases.isEmpty())
			objHandler.setDwhStatusSynced(lstImportedCases);
		if(lstNotImportedCases != null && !lstNotImportedCases.isEmpty())
			objHandler.setDwhStatusQueued(lstNotImportedCases);
	}
	
	//After insert method
	if(trigger.isAfter && trigger.isInsert) {
	
		RecordType objRecord = [SELECT Id FROM RecordType WHERE Name = 'Loan Status Update (Phone)' LIMIT 1];
		
		List<Id> lstCaseId = new List<Id> ();
		for(Case objCase : trigger.new) {
			if(!(objCase.RecordTypeId == objRecord.Id
				&& objCase.Verbal_Loan_Status_Provided__c == true
				&& objCase.isClosed == false))
				
				lstCaseId.add(objCase.Id);
		}
		
        if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER && lstCaseId.size() > 0 && !CRMS_CaseTriggerHandler.isTriggerCalledInsert && !system.isFuture() && !system.isBatch() && !system.isScheduled()) {
    		//AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_CREATE);
    		//CRMS_DwhSyncHandler.doSynchronizationFromFuture(lstCaseId, CRMS_Constants.SYNC_ACTION_CREATE);
    		CRMS_CaseTriggerHandler.isTriggerCalledInsert = true;
        }
	}
	
	//Before update method
	if(trigger.isBefore && trigger.isUpdate) {
		List<Case> lstImportedCases = new List<Case> ();
		List<Case> lstNotImportedCases = new List<Case> ();
		CRMS_CaseTriggerHandler objHandler = new CRMS_CaseTriggerHandler();
		
        for(Case objCase : trigger.new) {
            if (objCase.DWH_Status__c == CRMS_Constants.DWH_STATUS_SYNCED) {
                lstImportedCases.add(objCase);
            } else  {  //if (objCase.DWH_Import__c == false && Trigger.oldMap.get(objCase.Id).DWH_Import__c == false)
                lstNotImportedCases.add(objCase);
            }
        }
        if (!lstImportedCases.isEmpty()) {
            objHandler.setDwhStatusSynced(lstImportedCases);
        }
        if (!lstNotImportedCases.isEmpty()) {
            objHandler.setDwhStatusQueued(lstNotImportedCases);
        }
	}
	
	//After update method
	if(trigger.isAfter && trigger.isUpdate) {
        if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER && !CRMS_CaseTriggerHandler.isTriggerCalled && !system.isFuture() && !system.isBatch() && !system.isScheduled()) {
    		//AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_UPDATE);
    		//CRMS_DwhSyncHandler.doSynchronizationFromFuture(new List<Id> (trigger.newMap.keySet()), CRMS_Constants.SYNC_ACTION_UPDATE);
    		CRMS_CaseTriggerHandler.isTriggerCalled = true;
        }
	}
	
	//Before delete method
	if(trigger.isBefore && trigger.isDelete) {
		List<Case> lstCases = new List<Case> ();
		CRMS_CaseTriggerHandler objHandler = new CRMS_CaseTriggerHandler();
		
		for(Case objCase : trigger.old)
			lstCases.add(objCase);
		
		if(lstCases != null && !lstCases.isEmpty())
			objHandler.updateSyncQueueRecord(lstCases);
	}

}