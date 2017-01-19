/**
    Trigger on Credit_Assessment__c to perform sync with DWH
    Author: Saket Joshi
    Created Date: 31/03/2015    Version: 1.0
*/
trigger CRMS_CreditAssessmentTrigger on Credit_Assessment__c (before insert, after update, after insert, before update, before delete) 
{
    CRMS_CreditAssessmentTriggerHandler objHandler = new CRMS_CreditAssessmentTriggerHandler();
    static boolean blnUpdate = true;
    
    List<Credit_Assessment__c> creAssesmentImportedList = new List<Credit_Assessment__c>();
    List<Credit_Assessment__c> creAssesmentList = new List<Credit_Assessment__c>(); 
    
    if(trigger.isInsert && trigger.isBefore)
    {
        objHandler.beforeInsert(trigger.new);
        for (Credit_Assessment__c creAssesment : Trigger.new) 
        {
            if (creAssesment.DWH_Status__c == CRMS_Constants.DWH_STATUS_SYNCED) {
                creAssesmentImportedList.add(creAssesment);
            } else {
                creAssesmentList.add(creAssesment);
            }
        }
        if (!creAssesmentImportedList.isEmpty()) {
            objHandler.setCreAsessmentDWHStatusSynced(creAssesmentImportedList);
        }
        if (!creAssesmentList.isEmpty()) {
            objHandler.setCreAsessmentDWHStatusQueued(creAssesmentList);
        }
    }
    
    
    if(trigger.isUpdate && trigger.isAfter)
    {
        if(blnUpdate)
        { 
            List<Id> lstToSync = new List<Id> ();
            Map<ID,String> lstOppAccountIDsCAStatusMap = new Map<ID,String>();
            
            objHandler.afterUpdate(trigger.newMap,trigger.oldMap);
            for(Credit_Assessment__c objCA : trigger.new){
                 lstToSync.add(objCA.Id);                
            }
            
            if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER 
            	&& !system.isFuture() 
            	&& !system.isBatch() 
            	&& !system.isScheduled() 
            	&& !CRMS_CreditAssessmentTriggerHandler.isTriggerCalled) {
                AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_UPDATE);
                //CRMS_DwhSyncHandler.doSynchronizationFromFuture(lstToSync, CRMS_Constants.SYNC_ACTION_UPDATE);
                CRMS_CreditAssessmentTriggerHandler.isTriggerCalled = true;
            }
            blnUpdate = false;
        }
    }
    
    if(trigger.isInsert && trigger.isAfter)
    {
        //List<Credit_Assessment__c> lstSyncedCreditAssesment = new List<Credit_Assessment__c>();
        objHandler.afterInsert(trigger.new);
        List<Id> lstToSync = new List<Id> ();
        if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER && !system.isFuture() && !system.isBatch() && !system.isScheduled() && !CRMS_CreditAssessmentTriggerHandler.isTriggerCalledInsert) {
            for(Credit_Assessment__c objCA : trigger.new)
                //if(objCA.Status__c.equals('Approved') || objCA.Status__c.equals('Rejected'))
                    lstToSync.add(objCA.Id);
            AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_INSERT);
            //CRMS_DwhSyncHandler.doSynchronizationFromFuture(lstToSync, CRMS_Constants.SYNC_ACTION_UPDATE);
            CRMS_CreditAssessmentTriggerHandler.isTriggerCalledInsert = true;
        }
    }
    
    if(trigger.isBefore && trigger.isUpdate)
    {
        objHandler.beforeUpdate(trigger.new, trigger.oldMap);
        
        for (Credit_Assessment__c creAssesment : trigger.new) 
        {
            if (creAssesment.DWH_Status__c == CRMS_Constants.DWH_STATUS_SYNCED) {
                creAssesmentImportedList.add(creAssesment);
            } else { //if (creAssesment.DWH_Import__c == false && Trigger.oldMap.get(creAssesment.Id).DWH_Import__c == false) 
                creAssesmentList.add(creAssesment);
            }
        }
        if (!creAssesmentImportedList.isEmpty()) {
            objHandler.setCreAsessmentDWHStatusSynced(creAssesmentImportedList);
        }
        if (!creAssesmentList.isEmpty()) {
            objHandler.setCreAsessmentDWHStatusQueued(creAssesmentList);
        }
    }
    
    if (trigger.isDelete && trigger.isBefore) {
        List<Credit_Assessment__c> lstCreAssessment = new List<Credit_Assessment__c>();
        for (Credit_Assessment__c creAssessment : trigger.old) {
            lstCreAssessment.add(creAssessment);
        }
        if (!lstCreAssessment.isEmpty()) {
            objHandler.updateSyncQueueRecord(lstCreAssessment);
        }
    } 
}