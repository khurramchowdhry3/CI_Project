/**
    Trigger on Owner/Director/Guarantor object to create respective sync records
    Author: Saket Joshi
    Version: 1.0
*/
trigger CRMS_OpportunityTrigger on Opportunity (before insert,before update,after update,after insert,before delete) 
{

	system.debug('New Opportunity >>> '+trigger.new);
    system.debug('Old Opportunity >>> '+trigger.old);
    
    if(trigger.isBefore && trigger.isInsert)
    {
        Opportunity[] opportunityImportedList = new Opportunity[]{};
        Opportunity[] opportunityList = new Opportunity[]{};
        
        CRMS_OpportunityTriggerHandler objClass = new CRMS_OpportunityTriggerHandler();
        objClass.beforeInsert(trigger.new);
        
        for (Opportunity opp : Trigger.new) 
        {
            if (opp.DWH_Status__c == CRMS_Constants.DWH_STATUS_SYNCED) {
                opportunityImportedList.add(opp);
            }else {
                opportunityList.add(opp);
            }
        }
        if (!opportunityImportedList.isEmpty()) {
            objClass.setOpportunityDWHStatusSynced(opportunityImportedList);
        }
        if (!opportunityList.isEmpty() ) {
            objClass.setOpportunityDWHStatusQueued(opportunityList); 
        }
    }
 
    if(trigger.isAfter && trigger.isInsert)
    {
        CRMS_OpportunityTriggerHandler objClass = new CRMS_OpportunityTriggerHandler();
        List<Opportunity> lstSyncedOpportunity = new List<Opportunity>();
        objClass.afterInsert(trigger.newMap);
        List<Id> lstOppId = new List<Id> ();
        
        Opportunity[] opportunityList = new Opportunity[]{};
        for (Opportunity opp : trigger.new) 
         {
             if (opp.DWH_Import__c == true && opp.DWH_Status__c == CRMS_Constants.DWH_STATUS_SYNCED) {
                 lstSyncedOpportunity.add(opp);
             }
             else {
                lstOppId.add(opp.Id);
             }
         }
         
         if(!CRMS_OpportunityTriggerHandler.isTriggerCalledOnInsert && !system.isFuture() && !system.isBatch() && !system.isScheduled()) {
            //CRMS_DwhSyncHandler.doSynchronizationFromFuture(lstOppId, CRMS_Constants.SYNC_ACTION_UPDATE);
            CRMS_OpportunityTriggerHandler.isTriggerCalledOnInsert = true;
         }
    }   
    if(trigger.isBefore && trigger.isUpdate)
    {
        
        CRMS_OpportunityTriggerHandler objClass = new CRMS_OpportunityTriggerHandler();
        objClass.beforeUpdate(trigger.newmap,trigger.oldmap);
        Opportunity[] opportunityImportedList = new Opportunity[]{};
        Opportunity[] opportunityList = new Opportunity[]{};
        
        objClass.beforeInsert(trigger.new);
        objClass.validateLoanAmount(trigger.new);
        
        for (Opportunity opp : trigger.new) 
        {            
            opp.Requested_Loan_Term__c = opp.Loan_Term__c;
         	opp.FOC__c = opp.Loan_Frequency__c;
         	opp.Monthly_Interest__c = opp.Loan_Interest__c;             
            
            	
            if (opp.DWH_Status__c == CRMS_Constants.DWH_STATUS_SYNCED) {
                opportunityImportedList.add(opp);
            } else  { //if (opp.DWH_Import__c == false && Trigger.oldMap.get(opp.Id).DWH_Import__c == false)
                opportunityList.add(opp);
            }
        }
        if (!opportunityImportedList.isEmpty()) {
            objClass.setOpportunityDWHStatusSynced(opportunityImportedList);
        }
    }

         if(trigger.isAfter && trigger.isUpdate)
    {
        CRMS_OpportunityTriggerHandler objClass = new CRMS_OpportunityTriggerHandler();
        
        Set<ID> opportunityWithdrawnIDs = new Set<ID>();
        List<Id> listOppID = new List<Id>();
        for (Opportunity opp : trigger.new){
            system.debug('trigger.new************'+trigger.new);
            listOppID.add(opp.id);
                                
            if(opp.StageName == 'Loan Withdrawn'){
                opportunityWithdrawnIDs.add(opp.ID);
            }
        }
			/*

            if(!opportunityWithdrawnIDs.isEmpty()){
            	objClass.setOperationStatusCanceled(opportunityWithdrawnIDs);
             }*/
        
        if(!CRMS_OpportunityTriggerHandler.blnUpdate){
        	objClass.afterUpdate(trigger.newMap, trigger.OldMap);
        	CRMS_OpportunityTriggerHandler.blnUpdate = true; 
        }
        
        if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER 
        	&& !system.isFuture() 
        	&& !system.isBatch() 
        	&& !system.isScheduled())
        	AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_UPDATE);
            //CRMS_DwhSyncHandler.doSynchronizationFromFuture(new List<Id> (trigger.newMap.keySet()), CRMS_Constants.SYNC_ACTION_UPDATE);                      
        
    }
       
    if (trigger.isDelete && trigger.isBefore) {
        CRMS_OpportunityTriggerHandler objClass = new CRMS_OpportunityTriggerHandler();
        List<Opportunity> lstOpportunity = new List<Opportunity>();
        Opportunity[] opportunityList = new Opportunity[]{};
        for (Opportunity opp : trigger.old) {
            lstOpportunity.add(opp);
        }
        if(!CRMS_OpportunityTriggerHandler.blnUpdate && !system.isFuture() 
            && !system.isBatch() 
            && !system.isScheduled()){
            AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.old, AMPSyncApp_Constants.SYNC_ACTION_DELETE);
            CRMS_OpportunityTriggerHandler.blnUpdate = true;
        }
        
        if (!lstOpportunity.isEmpty()) {
            objClass.updateSyncQueueRecord(lstOpportunity);
        }
    } 
}