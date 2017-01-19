/**
    Trigger on Task object to create respective sync records
    Author: Saket Joshi
    Version: 1.0
*/
trigger CRMS_TaskTrigger on Task (after insert, after update, before insert, before update, before delete) {
    
    CRMS_TaskTriggerHandler taskTriggerHandler =  new CRMS_TaskTriggerHandler();
    List<Task> taskImportedList = new List<Task>();
    List<Task> taskList = new List<Task>(); 
    
    if (trigger.isInsert && trigger.isBefore) {
        for (Task task : Trigger.new) 
        {
            if (task.DWH_Status__c == CRMS_Constants.DWH_STATUS_SYNCED) {
                taskImportedList.add(task);
            } else {
                taskList.add(task);
            }
        }
        if (!taskImportedList.isEmpty()) {
            taskTriggerHandler.setTaskDWHStatusSynced(taskImportedList);
        }
        if (!taskList.isEmpty()) {
            taskTriggerHandler.setTaskDWHStatusQueued(taskList);
        }
    }
    
    if (trigger.isUpdate && trigger.isBefore) {
        for (Task task : trigger.new) 
        {
            if (task.DWH_Status__c == CRMS_Constants.DWH_STATUS_SYNCED) {
                taskImportedList.add(task);
            } else  {         //if (task.DWH_Import__c == false && Trigger.oldMap.get(task.Id).DWH_Import__c == false)
                taskList.add(task);
            }
        }
        if (!taskImportedList.isEmpty()) {
            taskTriggerHandler.setTaskDWHStatusSynced(taskImportedList);
        }
        if (!taskList.isEmpty()) {
            taskTriggerHandler.setTaskDWHStatusQueued(taskList);
        }
    }
    
    if (trigger.isInsert && trigger.isAfter) {
        List<Id> lstTaskId = new List<Id> ();
        for(Task objTask : trigger.new){
            system.debug('objTask.Summary_Comments__c ------- >'+objTask.Description);        
            if(objTask.Description == null || objTask.Description == ''){
                lstTaskId.add(objTask.Id);
                system.debug('objTask.Summary_Comments__c ------- >'+objTask.Summary_Comments__c);
            }
        }
        if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER && lstTaskId.size() > 0 && !CRMS_TaskTriggerHandler.isTriggerCalled && !system.isFuture() && !system.isBatch() && !system.isScheduled()) {
            //AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_CREATE);
            //CRMS_DwhSyncHandler.doSynchronizationFromFuture(lstTaskId, CRMS_Constants.SYNC_ACTION_CREATE);
            CRMS_TaskTriggerHandler.isTriggerCalled = true;
        }
        CRMS_TaskTriggerHandler objClass = new CRMS_TaskTriggerHandler();
        objClass.createEvent(trigger.new);
    }
    
    if (trigger.isUpdate && trigger.isAfter) {
        system.debug('Inside Afetr Update----------- ');
        if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER && !CRMS_TaskTriggerHandler.isAfterUpdate && !system.isFuture() && !system.isBatch() && !system.isScheduled()) {
            //AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_UPDATE);
            //CRMS_DwhSyncHandler.doSynchronizationFromFuture(new List<Id> (trigger.newMap.keySet()), CRMS_Constants.SYNC_ACTION_UPDATE);
            CRMS_TaskTriggerHandler.isAfterUpdate = true;
        }
    }
    
    if (trigger.isDelete && trigger.isBefore) {
        List<Task> lstTask = new List<Task>();
        for (Task task : trigger.old) {
            lstTask.add(task);
        }
        if (!lstTask.isEmpty()) {
            taskTriggerHandler.updateSyncQueueRecord(lstTask);
        }
    } 
}