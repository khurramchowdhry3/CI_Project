trigger LoanManagementEvent_Trigger on Loan_Management_Event__c (after insert, after update, before insert, before update) 
{
	LoanManagementEventTrigger_Handler objHandler = new LoanManagementEventTrigger_Handler();
    static boolean blnUpdate = true;
    static boolean runOnce = true; // Prevent trigger to run recursively.
    
    if(trigger.isInsert && trigger.isBefore)
    {         
        List<Loan_Management_Event__c> lmeImportedList = new List<Loan_Management_Event__c>();
        List<Loan_Management_Event__c> lmeList = new List<Loan_Management_Event__c>();
        for (Loan_Management_Event__c lme : Trigger.new) 
        {
            if (lme.DWH_Status__c == CRMS_Constants.DWH_STATUS_SYNCED) {
                lmeImportedList.add(lme);
            } else {
                lmeList.add(lme);
            }
        }
        if (!lmeImportedList.isEmpty()) {
            objHandler.setLoanManagementEventDWHStatusSynced(lmeImportedList);
        }
        if (!lmeList.isEmpty()) {
            objHandler.setLoanManagementEventDWHStatusQueued(lmeList);
        }
        
    }
    
    
    if (trigger.isInsert && trigger.isAfter) {
    	if(!system.isFuture() && userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER && runOnce && !system.isBatch() && !system.isScheduled()){
    		runOnce = false;
    		AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_INSERT);
    		//CRMS_DwhSyncHandler.doSynchronizationFromFuture(new List<Id> (trigger.newMap.keySet()), CRMS_Constants.SYNC_ACTION_INSERT);    		
    	}
        
    }
    
    
    if(trigger.isUpdate && trigger.isAfter)
    {
        if(blnUpdate)
        {            
            blnUpdate = false;
            if(!system.isFuture() && userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER && !system.isBatch() && !system.isScheduled() && !LoanManagementEventTrigger_Handler.isTriggerCalled){
    			AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_UPDATE);
    			//CRMS_DwhSyncHandler.doSynchronizationFromFuture(new List<Id> (trigger.newMap.keySet()), CRMS_Constants.SYNC_ACTION_UPDATE);
    			LoanManagementEventTrigger_Handler.isTriggerCalled =true;
            }            
        }
    }
    
    if (trigger.isUpdate && trigger.isBefore) {
        List<Loan_Management_Event__c> lmeImportedList = new List<Loan_Management_Event__c>();
        List<Loan_Management_Event__c> lmeList = new List<Loan_Management_Event__c>();
        
        for (Loan_Management_Event__c lme : trigger.new) 
        {
            if (lme.DWH_Status__c == CRMS_Constants.DWH_STATUS_SYNCED) {
                lmeImportedList.add(lme);
            } else  {
                lmeList.add(lme);
            }
        }
        if (!lmeImportedList.isEmpty()) {
            objHandler.setLoanManagementEventDWHStatusSynced(lmeImportedList);
        }
        if (!lmeList.isEmpty()) {
            objHandler.setLoanManagementEventDWHStatusQueued(lmeList);

        }
                    
    }   
    
}