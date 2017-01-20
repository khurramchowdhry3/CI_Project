public class LoanManagementEventTrigger_Handler 
{
	public static Boolean isTriggerCalled = false;
    // method to set LoanManagementEvent status as Queued when updated on SF end
    public void setLoanManagementEventDWHStatusQueued(List<Loan_Management_Event__c> lstLoanManagementEvent) 
    {
        for (Loan_Management_Event__c lme : lstLoanManagementEvent) 
        {
            lme.DWH_Status__c = CRMS_Constants.DWH_STATUS_QUEUED;
        }
    }
    // method to set LoanManagementEvent status as Synced when successfully synced with DWH
    public void setLoanManagementEventDWHStatusSynced(List<Loan_Management_Event__c> lstLoanManagementEvent){
        for (Loan_Management_Event__c lme : lstLoanManagementEvent) 
        {
            lme.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
            lme.DWH_Last_Sync__c = Datetime.now();
        }
    }

    // method to create/update Sync Queue records
    public void updateSyncQueueRecord(List<Loan_Management_Event__c> lstLoanManagementEvent){
        Map<Id,List<Sync_Queue__c>> lmeIdToSynchQueListMap = new  Map<Id,List<Sync_Queue__c>>();
        Set<Id> lmeIdSet = new Set<Id>();
        Sync_Queue__c[] synchQueueUpdateList = new Sync_Queue__c[]{};
        Sync_Queue__c[] synchQueueCreateList = new Sync_Queue__c[]{};
        
        for (Loan_Management_Event__c lme : lstLoanManagementEvent) {
            lmeIdSet.add(lme.Id);
        }
        List<Sync_Queue__c> syncQueueList = [
            SELECT Loan_Management_Event__c
                 , Notes__c
                 , Action__c
                 , Queued_Record_ID__c
                 , Sync_Status__c
                 , DWH_Data_Type__c
               FROM Sync_Queue__c 
              WHERE Sync_Status__c = :CRMS_Constants.SYNC_QUEUE_STATUS_PENDING
                AND Loan_Management_Event__c IN :lmeIdSet
         ];
         
        for (Sync_Queue__c syncQueue : syncQueueList) {
            if (lmeIdToSynchQueListMap.containsKey(syncQueue.Loan_Management_Event__c) == true) {
                lmeIdToSynchQueListMap.get(syncQueue.Loan_Management_Event__c).add(syncQueue);
            } else {
                lmeIdToSynchQueListMap.put(syncQueue.Loan_Management_Event__c, new Sync_Queue__c[] {syncQueue});
            }
        }
        
        for (Loan_Management_Event__c lme : lstLoanManagementEvent) {
            Sync_Queue__c[] synchQueueList = lmeIdToSynchQueListMap.get(lme.Id);
            system.debug('***** synchQueueList '+synchQueueList);
            if (synchQueueList != null && !synchQueueList.isEmpty()) {
                for (Sync_Queue__c synchQue : synchQueueList) {
                    if (synchQue.Action__c != CRMS_Constants.SYNC_ACTION_DELETE) {
                        synchQue.Sync_Status__c = CRMS_Constants.SYNC_STATUS_STALE;
                    }
                    String currentDateTime = Datetime.now().format() + CRMS_Constants.DWH_DELETE_TRIGGER;
                    synchQue.Action__c = CRMS_Constants.SYNC_ACTION_DELETE;
                    synchQue.Notes__c = currentDateTime;
                    synchQue.Queued_Record_ID__c = lme.Id;
                    synchQueueUpdateList.add(synchQue);
                }
            } 
            Sync_Queue__c syncQueue = new Sync_Queue__c();
            syncQueue.Queued_Record_ID__c = lme.Id;
            syncQueue.DWH_Data_Type__c = CRMS_Constants.DWH_DATA_TYPE_LOAN_MANAGEMENT_EVENT;
            syncQueue.Action__c = CRMS_Constants.SYNC_ACTION_DELETE;
            syncQueue.Sync_Status__c = CRMS_Constants.SYNC_QUEUE_STATUS_PENDING;
            String currentDateTime = Datetime.now().format() + CRMS_Constants.SYNC_STATUS_LOAN_MANAGEMENT_EVENT_DELETED;
            syncQueue.Notes__c = currentDateTime;
            synchQueueCreateList.add(syncQueue);
            
        }
        if (!synchQueueUpdateList.isEmpty()) {
            update synchQueueUpdateList;
             system.debug('***** synchQueueUpdateList '+synchQueueUpdateList);
        }
        if (!synchQueueCreateList.isEmpty()) {
            insert synchQueueCreateList;
            system.debug('***** synchQueueCreateList '+synchQueueCreateList);
        }
    }// end of updateSyncQueueRecord
    
    public void CreateCaseOnBounceBack(List<Loan_Management_Event__c> lstLoanManagementEvent){    	
    	
    	map<ID, Loan_Management_Event__c> LoanManagementMap = new map<ID, Loan_Management_Event__c>();
    	for(Loan_Management_Event__c LME : lstLoanManagementEvent){
    		if(LME.Event_Type__c == 'Bounce Back'){
    			LoanManagementMap.put(LME.Operation__c, LME);    			
    		}
    	}
    	
    	if(LoanManagementMap.size() > 0 && !LoanManagementMap.isEmpty()){
    		AMPLoan_Case BounceBackCase = new AMPLoan_Case();
    		BounceBackCase.CreateNewCase(LoanManagementMap);
    	}
    }    
}