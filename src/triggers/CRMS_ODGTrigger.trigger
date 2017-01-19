/**
	Trigger on Owner/Director/Guarantor object to create respective sync records
	Author: Saket Joshi
	Version: 1.0
*/

trigger CRMS_ODGTrigger on Guarantors__c (after insert, after update, before delete, 
before insert, before update) {
	
	system.debug('New ODG >>>> '+trigger.new);
    system.debug('Old ODG >>>> '+trigger.old);
    
	//Before insert method
	if(trigger.isBefore && trigger.isInsert) {
		List<Guarantors__c> lstImportedGuarantors = new List<Guarantors__c> ();
		List<Guarantors__c> lstNotImportedGuarantors = new List<Guarantors__c> ();
		
		CRMS_ODGTriggerHandler objHandler = new CRMS_ODGTriggerHandler();
		
		for(Guarantors__c objGuarantor : trigger.new) {
			if(objGuarantor.DWH_Status__c == CRMS_Constants.DWH_STATUS_SYNCED)
				lstImportedGuarantors.add(objGuarantor);
			else
				lstNotImportedGuarantors.add(objGuarantor);
		}
		 
		if(lstImportedGuarantors != null && !lstImportedGuarantors.isEmpty())
			objHandler.setDwhStatusSynced(lstImportedGuarantors);
		if(lstNotImportedGuarantors != null && !lstNotImportedGuarantors.isEmpty())
			objHandler.setDwhStatusQueued(lstNotImportedGuarantors);
	}
	
	//After insert method
	if(trigger.isAfter && trigger.isInsert) {
		List<Id> lstOdgId = new List<Id> ();
		for(Guarantors__c objOdg : trigger.new)
			if(objOdg.Person_Account_Email_ID__c == null || objOdg.Person_Account_Email_ID__c == '' || objOdg.Person_Account_Email_ID__c.contains(''))
				lstOdgId.add(objOdg.Id);
				
        if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER && !CRMS_ODGTriggerHandler.isTriggerCalled && !system.isFuture() && !system.isBatch() && !system.isScheduled()) {
    		AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_CREATE);
    		//CRMS_DwhSyncHandler.doSynchronizationFromFuture(lstOdgId, CRMS_Constants.SYNC_ACTION_CREATE);
    		CRMS_ODGTriggerHandler.isTriggerCalled = true;
        }
	}
	
	//Before update method
	if(trigger.isBefore && trigger.isUpdate) {
		List<Guarantors__c> lstImportedGuarantors = new List<Guarantors__c> ();
		List<Guarantors__c> lstNotImportedGuarantors = new List<Guarantors__c> ();
		CRMS_ODGTriggerHandler objHandler = new CRMS_ODGTriggerHandler();
		
        for(Guarantors__c objGuarantor : trigger.new) {
            if (objGuarantor.DWH_Status__c == CRMS_Constants.DWH_STATUS_SYNCED) {
                lstImportedGuarantors.add(objGuarantor);
            } else  { //if (objGuarantor.DWH_Import__c == false && Trigger.oldMap.get(objGuarantor.Id).DWH_Import__c == false)
                lstNotImportedGuarantors.add(objGuarantor);
            }
        }
        if (!lstImportedGuarantors.isEmpty()) {
            objHandler.setDwhStatusSynced(lstImportedGuarantors);
        }
        if (!lstNotImportedGuarantors.isEmpty()) {
            objHandler.setDwhStatusQueued(lstNotImportedGuarantors);
        }
	}
	
	//After update method
	if(trigger.isAfter && trigger.isUpdate) {
        if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER && !system.isFuture() && !system.isBatch() && !system.isScheduled())
    		AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_UPDATE);
    		//CRMS_DwhSyncHandler.doSynchronizationFromFuture(new List<Id> (trigger.newMap.keySet()), CRMS_Constants.SYNC_ACTION_UPDATE);
	}
	
	//Before delete method
	if(trigger.isBefore && trigger.isDelete) {
        List<Guarantors__c> lstGuarantor = new List<Guarantors__c> ();
        CRMS_ODGTriggerHandler objHandler = new CRMS_ODGTriggerHandler();
        
        for(Guarantors__c objGuarantor : trigger.old)
            lstGuarantor.add(objGuarantor);
        
        if(!system.isFuture() && !system.isBatch() && !system.isScheduled()){            
            AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.old, AMPSyncApp_Constants.SYNC_ACTION_DELETE);
            //CRMS_DwhSyncHandler.doSynchronizationFromFuture(new List<Id> (trigger.newMap.keySet()), CRMS_Constants.SYNC_ACTION_UPDATE);            
        }
        
        if(lstGuarantor != null && !lstGuarantor.isEmpty())
            objHandler.updateSyncQueueRecord(lstGuarantor);
    } 

}