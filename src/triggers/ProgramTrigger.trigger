trigger ProgramTrigger on Program__c ( before delete, before insert, before update,after delete, after insert, after undelete, 
after update) {
 Loan_ProgramTriggerHandler objHandler = new Loan_ProgramTriggerHandler(); 
    
    //
    if(trigger.isInsert && trigger.isBefore){
        List<Program__c> addImportedList = new List<Program__c>();
        List<Program__c> addList = new List<Program__c>();
        for( Program__c tempItem : Trigger.new ){
            
            
        tempItem.Name = tempItem.Program_Name__c;
        //tempItem.CurrencyIsoCode = AMP_Utils.getCurrencyISOByCountryCode(tempItem.Country__c);
     //DWH PART -----------------------------------------------------       
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
        for( Program__c tempItem : Trigger.new ){
            if( tempItem.DWH_Import__c != true )
                addID.add( tempItem.id);
        }
        if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER && !system.isFuture() && !system.isBatch() && !system.isScheduled() ){
            AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_INSERT);
            //CRMS_DwhSyncHandler.doSynchronizationFromFuture(addID, CRMS_Constants.SYNC_ACTION_INSERT);
        }
    }
    
    //
    if (trigger.isUpdate && trigger.isBefore){
        /*if (!(Trigger.new).isEmpty()) {
            objHandler.setAddDWHStatusQueued(Trigger.new); 
        }*/
        List<Program__c> addImportedList = new List<Program__c>();
        List<Program__c> addList = new List<Program__c>();
        
        for( Program__c tempItem : Trigger.new ){
            
        tempItem.Name = tempItem.Program_Name__c;
        //tempItem.CurrencyIsoCode = AMP_Utils.getCurrencyISOByCountryCode(tempItem.Country__c);
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
        if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER && !system.isFuture() && !system.isBatch() && !system.isScheduled() && !Loan_ProgramTriggerHandler.isTriggerCalled ){
            AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_UPDATE);
            //CRMS_DwhSyncHandler.doSynchronizationFromFuture(new List<Id> (trigger.newMap.keySet()), CRMS_Constants.SYNC_ACTION_UPDATE);
            Loan_ProgramTriggerHandler.isTriggerCalled =true;
        }
    }
    
    //
    if (trigger.isDelete && trigger.isBefore) {
        List<Program__c> addList = new List<Program__c>();
        for (Program__c tempItem : trigger.old) {
            addList.add(tempItem);
        }
        
         if(!system.isFuture() && !system.isBatch() && !system.isScheduled() && !Loan_ProgramTriggerHandler.isTriggerCalled ){
            AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.old, AMPSyncApp_Constants.SYNC_ACTION_DELETE);            
            Loan_ProgramTriggerHandler.isTriggerCalled =true;
        }
        
        if (!addList.isEmpty()) {
            objHandler.updateSyncQueueRecord(addList);
        }
    }
}