/**
    Trigger on Additional Debt object for sync with DWH
    Author: CRMS
    Version: 1.0
*/
trigger CRMS_AdditionalDebtTrigger on Additional_Debt__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
    CRMS_AdditionalDebtHandler objHandler = new CRMS_AdditionalDebtHandler();
    
    //
    if(trigger.isInsert && trigger.isBefore){
        List<Additional_Debt__c> addDebtImportedList = new List<Additional_Debt__c>();
        List<Additional_Debt__c> addDebtList = new List<Additional_Debt__c>();
        
        for( Additional_Debt__c additionalDebt : Trigger.new ){
            
            if (additionalDebt.DWH_Import__c ==  true) {
                addDebtImportedList.add(additionalDebt);
            } else {
                addDebtList.add(additionalDebt);
            }
            
        }
        if (!addDebtImportedList.isEmpty()) {
            objHandler.setAddDebtDWHStatusSynced(addDebtImportedList);
        }
        if (!addDebtList.isEmpty()) {
            objHandler.setAddDebtDWHStatusQueued(addDebtList);
        }
    }
    
    //
    if(trigger.isInsert && trigger.isAfter){
        List<ID> addDebtID = new List<ID>();
        for( Additional_Debt__c additionalDebt : Trigger.new ){
            if( additionalDebt.DWH_Import__c != true )
                addDebtID.add( additionalDebt.id);
        }
        if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER && !system.isFuture() && !system.isBatch() && !system.isScheduled() ){
            AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_INSERT);
            //CRMS_DwhSyncHandler.doSynchronizationFromFuture(addDebtID, CRMS_Constants.SYNC_ACTION_INSERT);
        }
    }
    
    //
    if (trigger.isUpdate && trigger.isBefore){
        if (!(Trigger.new).isEmpty()) {
            objHandler.setAddDebtDWHStatusQueued(Trigger.new); 
        }
        List<Additional_Debt__c> addDebtImportedList = new List<Additional_Debt__c>();
        List<Additional_Debt__c> addDebtList = new List<Additional_Debt__c>();
        
        for( Additional_Debt__c additionalDebt : Trigger.new ){
            
            if (additionalDebt.DWH_Status__c == CRMS_Constants.DWH_STATUS_SYNCED) {
                addDebtImportedList.add(additionalDebt);
            } else {
                addDebtList.add(additionalDebt);
            }
            
        }
    }
    
    //
    if(trigger.isUpdate && trigger.isAfter){
        List<ID> addDebtID = new List<ID>();
        
        if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER && !system.isFuture() && !system.isBatch() && !system.isScheduled() && !CRMS_OperationTriggerHandler.isTriggerCalled ){
            AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_UPDATE);
            //CRMS_DwhSyncHandler.doSynchronizationFromFuture(new List<Id> (trigger.newMap.keySet()), CRMS_Constants.SYNC_ACTION_UPDATE);
            CRMS_OperationTriggerHandler.isTriggerCalled =true;
        }
    }
    
    //
    if (trigger.isDelete && trigger.isBefore) {
        List<Additional_Debt__c> addDebtList = new List<Additional_Debt__c>();
        for (Additional_Debt__c additionalDebt : trigger.old) {
            addDebtList.add(additionalDebt);
        }
        if (!addDebtList.isEmpty()) {
            objHandler.updateSyncQueueRecord(addDebtList);
        }
    }
}