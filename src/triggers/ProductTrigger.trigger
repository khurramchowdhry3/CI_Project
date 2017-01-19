// 2015-01-07 Elisaveta Godumova: Added deletion of Program_Product_ASO records related to the currently deleted Product

trigger ProductTrigger on Product2 ( before delete, before insert, before update,after delete, after insert, after undelete, 
after update) {
 Loan_ProductTriggerHandler objHandler = new Loan_ProductTriggerHandler();
    
    //
    if(trigger.isInsert && trigger.isBefore){
        List<Product2> addImportedList = new List<Product2>();
        List<Product2> addList = new List<Product2>();
        
        for( Product2 tempItem : Trigger.new ){
            
        tempItem.Name = tempItem.Product_Name__c;
        tempItem.CurrencyIsoCode = AMP_Utils.getCurrencyISOByCountryCode(tempItem.Country__c);
            
       //DWH PART ------------------------------------------------    
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
        for( Product2 tempItem : Trigger.new ){
            if( tempItem.DWH_Import__c != true )
                addID.add( tempItem.id);
        }
        if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER && addID.size() > 0 && !system.isFuture() && !system.isBatch() && !system.isScheduled() ){
            AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_UPDATE);
            //CRMS_DwhSyncHandler.doSynchronizationFromFuture(addID, CRMS_Constants.SYNC_ACTION_INSERT);
        }
    }
    
    //
    if (trigger.isUpdate && trigger.isBefore){
        List<Product2> addImportedList = new List<Product2>();
        List<Product2> addList = new List<Product2>();
        
        for( Product2 tempItem : Trigger.new ){
            
        tempItem.Name = tempItem.Product_Name__c;
        tempItem.CurrencyIsoCode = AMP_Utils.getCurrencyISOByCountryCode(tempItem.Country__c);
            
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
        
        if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER && !system.isFuture() && !system.isBatch() && !system.isScheduled() && !Loan_ProductTriggerHandler.isTriggerCalled ){
            AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_UPDATE);
            //CRMS_DwhSyncHandler.doSynchronizationFromFuture(new List<Id> (trigger.newMap.keySet()), CRMS_Constants.SYNC_ACTION_UPDATE);
            Loan_ProductTriggerHandler.isTriggerCalled =true;
        }
    }
    
    //
   if (trigger.isDelete && trigger.isBefore) {
        List<Product2> addList = new List<Product2>();
        List<Id> Product_Ids = new List<Id>();
        
        if(!system.isFuture() && !system.isBatch() && !system.isScheduled()){
            AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.old, AMPSyncApp_Constants.SYNC_ACTION_DELETE);            
        }
        
        for (Product2 tempItem : trigger.old) {
            addList.add(tempItem);            
            Product_Ids.add(tempItem.Id);
        }
                
        Program_Product_ASO__c[] objsToDelete = [select id from Program_Product_ASO__c where Product__c IN :Product_Ids];
       
        delete objsToDelete; //perform delete statement    
        
        
        
        if (!addList.isEmpty()) {
           // objHandler.updateSyncQueueRecord(addList);
        }
        
    }
}