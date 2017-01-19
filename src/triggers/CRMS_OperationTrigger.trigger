/**
    Trigger on Operations object to create respective sync records
    Author: Saket Joshi
    Version: 1.0
*/
trigger CRMS_OperationTrigger on Operation__c (before insert, after update, before update, after insert, before delete) {
    CRMS_OperationTriggerHandler objHandler = new CRMS_OperationTriggerHandler();
    static boolean blnUpdate = true;
    static boolean runOnce = true; // Prevent trigger to run recursively. (khurram shahzad 26/02/16 SPT-304
    
    if(trigger.isInsert && trigger.isBefore)
    {
        //objHandler.beforeInsert(trigger.new);
        
        List<Operation__c> operationImportedList = new List<Operation__c>();
        List<Operation__c> operationList = new List<Operation__c>();
        for (Operation__c operation : Trigger.new) 
        {
            if (operation.DWH_Status__c == CRMS_Constants.DWH_STATUS_SYNCED) {
                operationImportedList.add(operation);
            } else {
                operationList.add(operation);
            }
        }
        if (!operationImportedList.isEmpty()) {
            objHandler.setOperationDWHStatusSynced(operationImportedList);
        }
        if (!operationList.isEmpty()) {
            objHandler.setOperationDWHStatusQueued(operationList);
        }
        
    }
    
    /**** Khurram Shahzad 26/02/16 SPT-304****/
    
    if (trigger.isInsert && trigger.isAfter) {
        if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER && runOnce && !system.isFuture() && !system.isBatch() && !system.isScheduled()){
            runOnce = false;
            AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_INSERT);
            //CRMS_DwhSyncHandler.doSynchronizationFromFuture(new List<Id> (trigger.newMap.keySet()), CRMS_Constants.SYNC_ACTION_INSERT);         
        }
    }
    
    /**** Khurram Shahzad 26/02/16 SPT-304****/
    
    
    if(trigger.isUpdate && trigger.isAfter)
    {
        if(blnUpdate && !CRMS_OperationTriggerHandler.isTriggerCalled)
        {
            //objHandler.afterUpdate(trigger.newMap,trigger.oldMap);
            blnUpdate = false;
            if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER && !system.isFuture() && !system.isBatch() && !system.isScheduled() && !CRMS_OperationTriggerHandler.isTriggerCalled){
                AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_UPDATE);
                //CRMS_DwhSyncHandler.doSynchronizationFromFuture(new List<Id> (trigger.newMap.keySet()), CRMS_Constants.SYNC_ACTION_UPDATE);
                CRMS_OperationTriggerHandler.isTriggerCalled =true;
            }            
           
            CRMS_OperationTriggerHandler objClass = new CRMS_OperationTriggerHandler();
            objClass.updateOpportunity(trigger.new, trigger.oldMap);
            objClass.CheckForAdditionalInformation(trigger.newMap,trigger.oldMap);            
        }
    }
    
    if (trigger.isUpdate && trigger.isBefore) {
        List<Operation__c> operationImportedList = new List<Operation__c>();
        List<Operation__c> operationList = new List<Operation__c>();
                        
        for (Operation__c operation : trigger.new) 
        {
            if (operation.DWH_Status__c == CRMS_Constants.DWH_STATUS_SYNCED) {
                operationImportedList.add(operation);
            } else  { //if (operation.DWH_Import__c == false && Trigger.oldMap.get(operation.Id).DWH_Import__c == false)
                operationList.add(operation);
            }
        }
        if (!operationImportedList.isEmpty()) {
            objHandler.setOperationDWHStatusSynced(operationImportedList);
        }
        if (!operationList.isEmpty()) {
            objHandler.setOperationDWHStatusQueued(operationList);

        }
                    
            objHandler.sendEmailToOpportunityTeam(trigger.new);
        
        
    }   
    
    if (trigger.isDelete && trigger.isBefore) {
        List<Operation__c> lstOperation = new List<Operation__c>();
        for (Operation__c operation : trigger.old) {
            lstOperation.add(operation);
        }
        if (!lstOperation.isEmpty()) {
            objHandler.updateSyncQueueRecord(lstOperation);
        }
        
        if(!system.isFuture() 
        	&& !system.isBatch() 
        	&& !system.isScheduled() 
        	&& !CRMS_OperationTriggerHandler.isTriggerCalled){
            
            AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.old, AMPSyncApp_Constants.SYNC_ACTION_DELETE);            
            CRMS_OperationTriggerHandler.isTriggerCalled =true;
        }
    } 
}