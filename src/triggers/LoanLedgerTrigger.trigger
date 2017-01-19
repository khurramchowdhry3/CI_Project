trigger LoanLedgerTrigger on Loan_Ledger__c ( before delete, before update,after delete, after undelete, 
after update) {
 Loan_LedgerTriggerHandler objHandler = new Loan_LedgerTriggerHandler(); 

    if (trigger.isUpdate && trigger.isBefore){
        List<Loan_Ledger__c> addImportedList = new List<Loan_Ledger__c>();
        List<Loan_Ledger__c> addList = new List<Loan_Ledger__c>();
        
        
        List<Loan_Ledger__c> bounceBackLedgers = new List<Loan_Ledger__c>();
        
        for( Loan_Ledger__c tempItem : Trigger.new ){
            
             if(tempItem.BB_Amount__c > 0 && Datetime.now().isSameDay(tempItem.BB_Date__c) && tempItem.isTaskCreated__c != true){
                 bounceBackLedgers.add(tempItem);
             }
            
            if (tempItem.DWH_Status__c == CRMS_Constants.DWH_STATUS_SYNCED&&tempItem.Sign_Off_Date__c >= Date.today()&&tempItem.Agreed_by_client__c == true) {                
                addImportedList.add(tempItem);
            } else if (tempItem.Sign_Off_Date__c >= Date.today()&&tempItem.Agreed_by_client__c == true){
                
                if(tempItem.InputFromScreen__c == 'bounceBackSection'){
                   // tempItem.EventAmount__c = tempItem.BB_Amount__c;
                   // tempItem.EventStartDate__c = tempItem.BB_Date__c;
                }

                addList.add(tempItem);
            }
        }
        if(!bounceBackLedgers.isEmpty()){
            objHandler.bounceBackReceived(bounceBackLedgers);
        }
        if (!addImportedList.isEmpty()) {
            objHandler.setAddDWHStatusSynced(addImportedList);
        }
        if (!addList.isEmpty()) {
            objHandler.setAddDWHStatusQueued(addList);
        }
    }
    
    //
    if(trigger.isUpdate && trigger.isAfter){
        List<ID> addID = new List<ID>();
        
        Map<ID,String> loanIDStatusMap = new Map<ID,String>();
        
         for( Loan_Ledger__c tempItem : trigger.newMap.values() ){
			if (tempItem.Sign_Off_Date__c >= Date.today()&&tempItem.Agreed_by_client__c == true){
                addID.add(tempItem.id);
            }
             if(tempItem.Status__c == 'In Progress' || tempItem.Status__c == 'Completed') {
                 loanIDStatusMap.put(tempItem.LoanID__c,tempItem.Status__c);
             }  
             
        }
        
        if(!loanIDStatusMap.isEmpty()){
            objHandler.changeOperationStatus(loanIDStatusMap);
        }
        
        if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER && addID.size() > 0 && !system.isFuture() && !system.isBatch() && !system.isScheduled() && !Loan_LedgerTriggerHandler.isTriggerCalled ){
                    
             AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_UPDATE);
             //   system.debug('Miro Loan Ledger Trigger : DWH Call : ');
            //CRMS_DwhSyncHandler.doSynchronizationFromFuture(addID, CRMS_Constants.SYNC_ACTION_UPDATE);
            Loan_LedgerTriggerHandler.isTriggerCalled =true;
        }
    }
    
    //
    if (trigger.isDelete && trigger.isBefore) {
        List<Loan_Ledger__c> addList = new List<Loan_Ledger__c>();
        for (Loan_Ledger__c tempItem : trigger.old) {
            addList.add(tempItem);
        }
        
        if(!system.isFuture() && !system.isBatch() && !system.isScheduled() && !Loan_LedgerTriggerHandler.isTriggerCalled ){
            AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.old, AMPSyncApp_Constants.SYNC_ACTION_DELETE);            
            Loan_LedgerTriggerHandler.isTriggerCalled =true;
        }
        
        if (!addList.isEmpty()) {
            objHandler.updateSyncQueueRecord(addList);
        }
    }
}