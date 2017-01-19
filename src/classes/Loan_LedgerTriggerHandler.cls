public with sharing class Loan_LedgerTriggerHandler {
    public static Boolean isTriggerCalled = false;
    // method to set Operation status as Queued when updated on SF end
    public void setAddDWHStatusQueued(List<Loan_Ledger__c> lstAdd) { 
        
        for (Loan_Ledger__c tempItem : lstAdd){
            tempItem.DWH_Status__c = CRMS_Constants.DWH_STATUS_QUEUED;
        }
        
    }
    
    // method to set Operation status as Synced when successfully synced with DWH
    public void setAddDWHStatusSynced(List<Loan_Ledger__c> lstAdd) {
        
        for (Loan_Ledger__c tempItem : lstAdd){
            tempItem.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
            tempItem.DWH_Last_Sync__c = Datetime.now();
        }
        
    }
    // method to create/update Sync Queue records
    public void updateSyncQueueRecord(List<Loan_Ledger__c> lstAdd){
        Map<Id,List<Sync_Queue__c>> addIdToSynchQueListMap = new  Map<Id,List<Sync_Queue__c>>();
        Set<Id> addIdSet = new Set<Id>();
        Sync_Queue__c[] synchQueueUpdateList = new Sync_Queue__c[]{};
        Sync_Queue__c[] synchQueueCreateList = new Sync_Queue__c[]{};
        
        for (Loan_Ledger__c tempItem : lstAdd) {
            addIdSet.add(tempItem.Id);
        }
        List<Sync_Queue__c> syncQueueList = [
            SELECT Loan_Ledger__c
                 , Notes__c
                 , Action__c
                 , Queued_Record_ID__c
                 , Sync_Status__c
                 , DWH_Data_Type__c
               FROM Sync_Queue__c 
              WHERE Sync_Status__c = :CRMS_Constants.SYNC_QUEUE_STATUS_PENDING
                AND Loan_Ledger__c IN :addIdSet
         ];
         
        for (Sync_Queue__c syncQueue : syncQueueList) {
            if (addIdToSynchQueListMap.containsKey(syncQueue.Loan_Ledger__c) == true) {
                addIdToSynchQueListMap.get(syncQueue.Loan_Ledger__c).add(syncQueue);
            } else {
                addIdToSynchQueListMap.put(syncQueue.Loan_Ledger__c, new Sync_Queue__c[] {syncQueue});
            }
        }
        
        for (Loan_Ledger__c tempItem : lstAdd) {
            Sync_Queue__c[] synchQueueList = addIdToSynchQueListMap.get(tempItem.Id);
            if (synchQueueList != null && !synchQueueList.isEmpty()) {
                for (Sync_Queue__c synchQue : synchQueueList) {
                    if (synchQue.Action__c != CRMS_Constants.SYNC_ACTION_DELETE) {
                        synchQue.Sync_Status__c = CRMS_Constants.SYNC_STATUS_STALE;
                    }
                    String currentDateTime = Datetime.now().format() + CRMS_Constants.DWH_DELETE_TRIGGER;
                    synchQue.Action__c = CRMS_Constants.SYNC_ACTION_DELETE;
                    synchQue.Notes__c = currentDateTime;
                    synchQue.Queued_Record_ID__c = tempItem.Id;
                    synchQueueUpdateList.add(synchQue);
                }
            } 
            Sync_Queue__c syncQueue = new Sync_Queue__c();
            syncQueue.Queued_Record_ID__c = tempItem.Id;
            syncQueue.DWH_Data_Type__c = CRMS_Constants.DWH_DATA_TYPE_LOAN_LEDGER;
            syncQueue.Action__c = CRMS_Constants.SYNC_ACTION_DELETE;
            syncQueue.Sync_Status__c = CRMS_Constants.SYNC_QUEUE_STATUS_PENDING;
            String currentDateTime = Datetime.now().format() + CRMS_Constants.SYNC_STATUS_LOAN_LEDGER_DELETED;
            syncQueue.Notes__c = currentDateTime;
            synchQueueCreateList.add(syncQueue);
            
        }
        if (!synchQueueUpdateList.isEmpty()) {
            update synchQueueUpdateList;
        }
        if (!synchQueueCreateList.isEmpty()) {
            insert synchQueueCreateList;
        }
    }
    
    public void changeOperationStatus (Map<ID,String> loanIDStatusMap){
        List<Operation__c> opList = new List<Operation__c>();
        opList = [Select ID, Status__c From Operation__c Where ID IN :loanIDStatusMap.keySet()];        
        for (Operation__c tempOp : opList) {
            if(loanIDStatusMap.get(tempOp.Id)=='In Progress') {
				tempOp.Status__c = 'In Progress';                
            }else if (loanIDStatusMap.get(tempOp.Id)=='Completed'){
                tempOp.Status__c = 'Completed';             
            }            
        }
        
        update opList;
    }
    
    public void bounceBackReceived (List<Loan_Ledger__c> boucedLedgers){
        List<Task> newTasks = new List<Task>();
		String subject = 'Bounce Back for client: ';
        String bs = ' ';
		String description1 = 'There has been a Bounce Back for the amount of: ';        
		String description2 = ' .This is Bounce Back number ';
        String description3 = ' for this loan. To handle the issue please follow this link ';
        String description4 = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/Loan_Management?screenSelected=bounceBackSection&accountID=';
	    String status = 'Not Started';
		String priority = 'High';
		Date dueDate = Date.today();        
        for(Loan_Ledger__c ll : boucedLedgers){
            ll.isTaskCreated__c = true;
           newTasks.add(
            	AMP_Utils.createTask(subject + ll.Account_Name__c, 
                                 	description1+ll.BB_Amount__c+bs+ll.Currency__c+description2+Integer.valueOf(ll.BB_Num__c)+description3+description4+ll.Account__c, 
                                 	status, priority, ll.OwnerId, ll.LoanID__c, dueDate)
               );
        }
        if(!newTasks.isEmpty()) insert newTasks;
    }
}