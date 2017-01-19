trigger ProgramProductAssociationTrigger on Program_Product_ASO__c (before delete, before insert, before update,after delete, after insert, after undelete, 
after update) {

     Loan_PPASOTriggerHandler objHandler = new Loan_PPASOTriggerHandler(); 
    
    //
    if(trigger.isInsert && trigger.isBefore){
        List<Program_Product_ASO__c> addImportedList = new List<Program_Product_ASO__c>();
        List<Program_Product_ASO__c> addList = new List<Program_Product_ASO__c>();
        
        for( Program_Product_ASO__c tempItem : Trigger.new ){
       
            //tempItem.Name = tempItem.Association_Name__c;
            tempItem.Name = tempItem.Product_Name__c;
            tempItem.Check_Name__c = tempItem.Association_Name__c;
		//DWH PART ---------------------------------            
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
        for( Program_Product_ASO__c tempItem : Trigger.new ){
            if( tempItem.DWH_Import__c != true )
                addID.add( tempItem.id);
        }
        if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER && addID.size() > 0 && !system.isFuture() && !system.isBatch() && !system.isScheduled() ){
            AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_CREATE);
            //CRMS_DwhSyncHandler.doSynchronizationFromFuture(addID, CRMS_Constants.SYNC_ACTION_CREATE);
        }
    }
    
    //
    if (trigger.isUpdate && trigger.isBefore){
        List<Program_Product_ASO__c> addImportedList = new List<Program_Product_ASO__c>();
        List<Program_Product_ASO__c> addList = new List<Program_Product_ASO__c>();
        
        for( Program_Product_ASO__c tempItem : Trigger.new ){
            
            //tempItem.Name = tempItem.Association_Name__c;
            tempItem.Name = tempItem.Product_Name__c;
            tempItem.Check_Name__c = tempItem.Association_Name__c;
            
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
        
        if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER && !system.isFuture() && !system.isBatch() && !system.isScheduled() && !Loan_PPASOTriggerHandler.isTriggerCalled ){
            AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_UPDATE);
            //CRMS_DwhSyncHandler.doSynchronizationFromFuture(new List<Id> (trigger.newMap.keySet()), CRMS_Constants.SYNC_ACTION_UPDATE);
            Loan_PPASOTriggerHandler.isTriggerCalled =true;
        }
    }
    
    //
    if (trigger.isDelete && trigger.isBefore) {
        List<Program_Product_ASO__c> addList = new List<Program_Product_ASO__c>();
        for (Program_Product_ASO__c tempItem : trigger.old) {
            addList.add(tempItem);
        }
        if(!system.isFuture() && !system.isBatch() && !system.isScheduled() && !Loan_PPASOTriggerHandler.isTriggerCalled ){
            AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.old, AMPSyncApp_Constants.SYNC_ACTION_DELETE);            
            Loan_PPASOTriggerHandler.isTriggerCalled =true;
        }
        
        if (!addList.isEmpty()) {
            objHandler.updateSyncQueueRecord(addList);
        }    
        
        //Create Queues for deleted Details on the Master-Detail relationship
        //deleting child does not run the corresponding trigger
        List<Loan_Management__c> addListLM = new List<Loan_Management__c>();
        addListLM = [Select ID From Loan_Management__c Where Program_Product_ASO__c IN :addList];
        delete addListLM;
        /*Loan_LoanManagementTriggerHandler lmHandler = new Loan_LoanManagementTriggerHandler ();
        if (!addListLM.isEmpty()) {
            lmHandler.updateSyncQueueRecord(addListLM);
        }   */     
        List<Reward__c> addListComm = new List<Reward__c>();        
        addListComm = [Select ID From Reward__c Where Program_Product_ASO__c IN :addList];
        delete addListComm;
        /*
        Loan_CommissionTriggerHandler commHandler = new Loan_CommissionTriggerHandler ();
        if (!addListComm.isEmpty()) {
            commHandler.updateSyncQueueRecord(addListComm);
        }*/
    }
}