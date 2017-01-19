trigger LoanManagementTrigger on Loan_Management__c (before delete, before insert, before update,after delete, after insert, after undelete, 
after update) {

         Loan_LoanManagementTriggerHandler objHandler = new Loan_LoanManagementTriggerHandler(); 
    
    //
    if(trigger.isInsert && trigger.isBefore){
        List<Loan_Management__c> addImportedList = new List<Loan_Management__c>();
        List<Loan_Management__c> addList = new List<Loan_Management__c>();
        
        for( Loan_Management__c tempItem : Trigger.new ){
            
            if (tempItem.DWH_Import__c ==  true) {
                addImportedList.add(tempItem);
            } else {
                addList.add(tempItem);
            }
            
        }
        if (!addImportedList.isEmpty()) {
            objHandler.setAddDWHStatusSynced(addImportedList);
        }
        if (!addList.isEmpty()) {
            objHandler.setAddDWHStatusQueued(addList);
        }
    }
    
    //
    if(trigger.isInsert && trigger.isAfter){
        List<ID> addID = new List<ID>();
        for( Loan_Management__c tempItem : Trigger.new ){
            if( tempItem.DWH_Import__c != true )
                addID.add( tempItem.id);
        }
        if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER && addID.size() > 0 && !system.isFuture() && !system.isBatch() && !system.isScheduled() ){
            AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_INSERT);
            //CRMS_DwhSyncHandler.doSynchronizationFromFuture(addID, CRMS_Constants.SYNC_ACTION_INSERT);
        }
    }
    
    //
    if (trigger.isUpdate && trigger.isBefore){
        List<Loan_Management__c> addImportedList = new List<Loan_Management__c>();
        List<Loan_Management__c> addList = new List<Loan_Management__c>();
        
        for( Loan_Management__c tempItem : Trigger.new ){
            
            if (tempItem.DWH_Status__c == CRMS_Constants.DWH_STATUS_SYNCED) {
                addImportedList.add(tempItem);
            } else {
                addList.add(tempItem);
            }
            
        }
    }
    
    //
    if(trigger.isUpdate && trigger.isAfter){
        List<ID> addID = new List<ID>();
        
        if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER && !system.isFuture() && !system.isBatch() && !system.isScheduled() && !Loan_LoanManagementTriggerHandler.isTriggerCalled ){
            AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_UPDATE);
            //CRMS_DwhSyncHandler.doSynchronizationFromFuture(new List<Id> (trigger.newMap.keySet()), CRMS_Constants.SYNC_ACTION_UPDATE);
            Loan_LoanManagementTriggerHandler.isTriggerCalled =true;
        }
    }
    
    //
    if (trigger.isDelete && trigger.isBefore) {
        system.debug('DANI-delete RULES');
        List<Loan_Management__c> addList = new List<Loan_Management__c>();
        
        if(!system.isFuture() && !system.isBatch() && !system.isScheduled()){
            AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.old, AMPSyncApp_Constants.SYNC_ACTION_DELETE);
        }        
        for (Loan_Management__c tempItem : trigger.old) {
            addList.add(tempItem);
        }      
        
        if (!addList.isEmpty()) {
            objHandler.updateSyncQueueRecord(addList);
        }
    }
}