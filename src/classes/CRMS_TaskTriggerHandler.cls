/**
    Handler class for the Task trigger
    Author: CRM Superstars
    Version: 1.0
*/
public class CRMS_TaskTriggerHandler {
    
    public static Boolean isTriggerCalled = false;
    public static Boolean isAfterUpdate = false;
    public static final String CONST_Approved = 'Approved';
    public static final String CONST_Rejected = 'Rejected';
    
    public void createEvent(list<Task> lstTask)
    {
    	list<Event> lstEvent = new list<Event>();
    	map<Id,String> mapOppId_Subject = new map<Id,String>(); 
    	set<Id> setOpportunityIds = new set<Id>(); 
    	for(Task objTask : lstTask)
    	{
    		if(objTask.Hours__c != null && objTask.Hours__c != ''
    		&& objTask.Minutes__c != null && objTask.Minutes__c != ''
    		&& objTask.Event_Date__c != null)
    		{
    			datetime startDateTime = datetime.newInstance(objTask.Event_Date__c.year(), objTask.Event_Date__c.month(),
    			objTask.Event_Date__c.day(), integer.valueOf(objTask.Hours__c), integer.valueOf(objTask.Minutes__c),0);
    			Event objEvent = new Event();
                objEvent.WhoId = objTask.WhoId;
                objEvent.Subject = objTask.Subject;
                objEvent.StartDateTime = startDateTime;
                objEvent.EndDateTime = startDateTime.addMinutes(15);
                objEvent.DurationInMinutes = 15; 
                objEvent.OwnerId = objTask.OwnerId;
                objEvent.Description = objTask.Description__c;
                lstEvent.add(objEvent);
    		}
    		/*if(objTask.WhatId != null && string.valueOf(objTask.WhatId).startsWith('006')
    		&& objTask.Subject.contains('Credit Assessment Completed'))
    		{
    			setOpportunityIds.add(objTask.WhatId);
    			mapOppId_Subject.put(objTask.WhatId, objTask.Subject);
    		}*/
    	}
    	if(!lstEvent.isEmpty())
    	{
    		insert lstEvent;
    	}
    	/*if(!setOpportunityIds.isEmpty())
    	{
    		emailLoansManager(setOpportunityIds, mapOppId_Subject);
    	}*/
    }
    
    /*
    public void emailLoansManager(set<Id> setOpportunityIds, map<Id,String> mapOppId_Subject)
    {
    	List<Messaging.SingleEmailMessage> listEmail = new List<Messaging.SingleEmailMessage>();
    	list<string> lstEmailIds = new list<String>();
    	list<Opportunity> lstOpp = [select Id, Name, OwnerId, Owner.email, Owner.Name from Opportunity where Id IN: setOpportunityIds];
    	for(Opportunity objOpp : lstOpp)
    	{
	    	String strDetail = mapOppId_Subject.get(objOpp.Id).contains(CONST_Approved)?CONST_Approved:CONST_Rejected;
	    	lstEmailIds.add(objOpp.Owner.email);
	    	Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
	    	message.setSubject(mapOppId_Subject.get(objOpp.Id));
	    	message.setToAddresses(lstEmailIds);
	    	message.plainTextBody = 'Hi '+ +objOpp.Owner.Name+ ',\n\n'+
	    	'  Credit Assessment for '+objOpp.Name+' has been '+strDetail+'. '+
	    	'Please notify the same to the client.\n\n'+
	    	'Thank you';
	    	listEmail.add(message);
	    	lstEmailIds.clear();
    	}
    	if(!listEmail.isEmpty())
    	{
    		List<Messaging.SendEmailResult> result = Messaging.sendEmail(listEmail);
    	}
    }
    */
    
    public void setTaskDWHStatusQueued(List<Task> lstTask) {
        for (Task task : lstTask) 
        {
            task.DWH_Status__c = CRMS_Constants.DWH_STATUS_QUEUED;
        }
    }
    
    // method to set DWH status as Synced
    public void setTaskDWHStatusSynced(List<Task> lstTask) {
        for (Task task : lstTask) 
        {
            task.DWH_Last_Sync__c = Datetime.now();
        }
    }
    
    // method to insert/update Sync Queue record
    public void updateSyncQueueRecord(List<Task> lstTask){
        Map<String,List<Sync_Queue__c>> taskIdToSynchQueListMap = new  Map<String,List<Sync_Queue__c>>();
        Set<String> taskIdSet = new Set<String>();
        Sync_Queue__c[] synchQueueUpdateList = new Sync_Queue__c[]{};
        Sync_Queue__c[] synchQueueCreateList = new Sync_Queue__c[]{};
        
        for (Task task : lstTask) {
            String taskId = task.Id;
            taskIdSet.add(taskId);
        }
        List<Sync_Queue__c> syncQueueList = [
            SELECT Task_Id__c
                 , Notes__c
                 , Action__c
                 , Queued_Record_ID__c
                 , Sync_Status__c
                 , DWH_Data_Type__c
               FROM Sync_Queue__c 
              WHERE Sync_Status__c = :CRMS_Constants.SYNC_QUEUE_STATUS_PENDING
                AND Task_Id__c IN :taskIdSet
         ];
       
        for (Sync_Queue__c syncQueue : syncQueueList) {
            if (taskIdToSynchQueListMap.containsKey(syncQueue.Task_Id__c) == true) {
                taskIdToSynchQueListMap.get(syncQueue.Task_Id__c).add(syncQueue);
            } else {
                taskIdToSynchQueListMap.put(syncQueue.Task_Id__c, new Sync_Queue__c[] {syncQueue});
            }
        }
        
        for (Task task : lstTask) {
            Sync_Queue__c[] synchQueueList = taskIdToSynchQueListMap.get(task.Id);
            if (synchQueueList != null && !synchQueueList.isEmpty()) {
                for (Sync_Queue__c synchQue : synchQueueList) {
                    if (synchQue.Action__c != CRMS_Constants.SYNC_ACTION_DELETE) {
                        synchQue.Sync_Status__c = CRMS_Constants.SYNC_STATUS_STALE;
                    }
                    String currentDateTime = Datetime.now().format() + CRMS_Constants.DWH_DELETE_TRIGGER;
                    //synchQue.Notes__c = currentDateTime;
                    synchQue.Action__c = CRMS_Constants.SYNC_ACTION_DELETE;
                    synchQue.Queued_Record_ID__c = task.Id;
                    
                    synchQueueUpdateList.add(synchQue);
                }
            } 
            Sync_Queue__c syncQueue = new Sync_Queue__c();
            syncQueue.Queued_Record_ID__c = task.Id;
            syncQueue.DWH_Data_Type__c = CRMS_Constants.DWH_DATA_TYPE_TASK;
            syncQueue.Action__c = CRMS_Constants.SYNC_ACTION_DELETE;
            syncQueue.Sync_Status__c = CRMS_Constants.SYNC_QUEUE_STATUS_PENDING;
            String currentDateTime = Datetime.now().format() + CRMS_Constants.SYNC_STATUS_TASK_DELETED;
            //syncQueue.Notes__c = currentDateTime;
            synchQueueCreateList.add(syncQueue);
            
        }
        if (!synchQueueUpdateList.isEmpty()) {
            update synchQueueUpdateList;
        }
        if (!synchQueueCreateList.isEmpty()) {
            insert synchQueueCreateList;            
        }
    } // end of updateSyncQueueRecord
} // end of class