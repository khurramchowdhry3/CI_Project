/**
    Trigger on Lead object to create respective sync records
    Convert Lead to Business Account/Opportunity and create Person Account record for the same
    Delete Contact record being created
    Author: Saket Joshi
    Version: 1.0
*/ 
trigger CRMS_LeadTrigger on Lead (before insert, before update, after insert, after update, before delete) 
{
    static boolean blnAfterInsert = true;
    static boolean blnAfterUpdate = true;
    list<Lead> lstUKLead = new list<Lead>();
   
    CRMS_LeadTriggerHandler objLeadHandler = new CRMS_LeadTriggerHandler();
    
    system.debug('New Lead >>>> '+trigger.new);
    system.debug('Old Lead >>>> '+trigger.old);
    
    if(trigger.isInsert && trigger.isBefore)
    {
        objLeadHandler.AutoPopulate(trigger.new, trigger.oldMap);
        if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER){
        	new AMPSales_PersonalAccount().CreatePersonAccountFromLead(trigger.new);
        }
        Set<Id> setConvertedOppIds  = new Set<Id>();
        List<Lead> lstImportedLeads = new List<Lead>();
        List<Lead> lstLeads = new List<Lead>(); 
        List<Lead> convertLeadList = new List<Lead>();  
        
        for (Lead ld : Trigger.new) 
        {
            
            //if(ld.TA_Country__c!=null &&  ld.TA_Country__c != '' && !ld.Trading_Address_if_different__c) {
              //  ld.LE_Country__c = ld.TA_Country__c;
            //}
            
            if (ld.isConverted && ld.ConvertedOpportunityId != null)
            {
                setConvertedOppIds.add(ld.ConvertedOpportunityId);
            }
            if (ld.DWH_Import__c == true) {
                lstImportedLeads.add(ld);
            }else {
                lstLeads.add(ld);
            }
            if(ld.Convert_Lead__c == true)
            {
               convertLeadList.add(ld);
            }
        }
        
        objLeadHandler.updateQualifiedRecordType(convertLeadList);
           
        if (!Statics.inFutureContext)
        {
             if (!setConvertedOppIds.isEmpty())
             {
                CRMS_OpportunityTeamProcessor.createOpportunityTeamMember(setConvertedOppIds);
             }
        } 
        
        if (!lstImportedLeads.isEmpty()) {
            objLeadHandler.setLeadDWHStatusSynced(lstImportedLeads);
        }
        if (!lstLeads.isEmpty()) {
            
            objLeadHandler.updateCampaignID(lstLeads);
            objLeadHandler.setLeadDWHStatusQueued(lstLeads);
        }
    }
        
    if(trigger.isInsert && trigger.isAfter)
    {
        
        
        //List<Lead> lstQueuedLeads = new List<Lead>();
        List<Lead> lstSyncedLeads = new List<Lead>();
        List<Id> lstLeadId = new List<Id> ();
        for(Lead objLead : trigger.new)
        {
            //system.debug('LeadID after t:'+objLead);
            if(objLead.Convert_Lead__c == true)
            {
                lstUKLead.add(objLead);
            }
            //Qualified leads are synced everytime because the Web Application form is inserting qualified leads that does not exist in sf
            //if(objLead.Convert_Lead__c == false)
            //{
                if (objLead.DWH_Import__c == true && objLead.DWH_Status__c == CRMS_Constants.DWH_STATUS_SYNCED) {
                    lstSyncedLeads.add(objLead);
                }
                
                lstLeadId.add(objLead.Id);
           // }
        }
        objLeadHandler.autoConvertLead(lstUKLead);  
        if (!lstSyncedLeads.isEmpty()) {
            objLeadHandler.updateLeadStatus(lstSyncedLeads);
        } 
              
        if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER 
        	&& lstUKLead.isEmpty()      	 
        	&& !CRMS_LeadTriggerHandler.isTriggerCalledOnInsert 
        	&& !lstLeadId.isEmpty() 
        	&& !system.isFuture() 
        	&& !system.isBatch() 
        	&& !system.isScheduled()){            
            
            AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_INSERT);
            //CRMS_DwhSyncHandler.doSynchronizationFromFuture(lstLeadId, CRMS_Constants.SYNC_ACTION_UPDATE);
            CRMS_LeadTriggerHandler.isTriggerCalledOnInsert = true; 
        }
    }
    
    if(trigger.isUpdate && trigger.isBefore)
    {
        objLeadHandler.AutoPopulate(trigger.new, trigger.oldMap);
                        
        Set<Id> setConvertedOppIds  = new Set<Id>(); 
        List<Lead> lstImportedLeads = new List<Lead>();
        List<Lead> lstLeads = new List<Lead>(); 
        List<Lead> convertLeadList = new List<Lead>();     
        for (Lead ld : Trigger.new) 
        {
            if (ld.isConverted && ld.ConvertedOpportunityId != null 
                && Trigger.oldMap.get(ld.Id).ConvertedOpportunityId != ld.ConvertedOpportunityId)
            {
                setConvertedOppIds.add(ld.ConvertedOpportunityId);
            }
            if (ld.DWH_Import__c == true) {
                lstImportedLeads.add(ld);
            } else if (ld.DWH_Import__c == false && Trigger.oldMap.get(ld.Id).DWH_Import__c == false) {  
                lstLeads.add(ld);
            }
            // to test SPT-28 'Introducer' value should be different for Internal and partner
            if(ld.Convert_Lead__c == true)
            {
                //ld.Status = 'Qualified';
	            if(ld.Lead_Owner_Profile_Name__c != null &&
	            string.isNotBlank(ld.Lead_Owner_Profile_Name__c) &&
	            (ld.Lead_Owner_Profile_Name__c.contains('Referral Channel')
	            || ld.Lead_Owner_Profile_Name__c.contains('Sales Channel')))
	            {
	            	ld.Qualified_By__c = UserInfo.getUserId();
	            }
                convertLeadList.add(ld);
            }
        }
        
        objLeadHandler.updateQualifiedRecordType(convertLeadList);
        
        if (!Statics.inFutureContext)
        {
             if (!setConvertedOppIds.isEmpty())
             {
                  CRMS_OpportunityTeamProcessor.createOpportunityTeamMember(setConvertedOppIds);
             }
        }
        if (!lstImportedLeads.isEmpty()) {
           objLeadHandler.setLeadDWHStatusSynced(lstImportedLeads);
        }
        if (!lstLeads.isEmpty()) {
                       
            objLeadHandler.updateCampaignID(lstLeads);
            objLeadHandler.setLeadDWHStatusQueued(lstLeads); 
        }
    }
     
    if(trigger.isUpdate && trigger.isAfter)
    {
        
        Map<Id,Lead> leadIdToNewLeadMap = new Map<Id,Lead>();
        List<Lead> lstLeads = new List<Lead>();
        List<Id> lstLeadId = new List<Id> ();
        if(blnAfterUpdate)
        {
            blnAfterUpdate = false;
            //objLeadHandler.assignLeadToQueue(trigger.new);
            for(Lead objLead : trigger.new)
            {
                if(objLead.Convert_Lead__c == true)
                {
                    //objLead.Status = 'Qualified';
                    lstUKLead.add(objLead);
                }
                //else {
                    lstLeadId.add(objLead.Id);
                //}
                //leadIdToNewLeadMap.put(objLead.Id,objLead);
            }
            objLeadHandler.autoConvertLead(lstUKLead);
            if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER
            	&& lstUKLead.isEmpty() 
            	&& !system.isFuture() 
            	&& !system.isBatch() 
            	&& !system.isScheduled() 
            	&& !CRMS_LeadTriggerHandler.isTriggerCalled ){
                AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_UPDATE);
                //CRMS_DwhSyncHandler.doSynchronizationFromFuture(lstLeadId, CRMS_Constants.SYNC_ACTION_UPDATE);
                CRMS_LeadTriggerHandler.isTriggerCalled = true; 
            }
        }
    }
    
    if (trigger.isDelete && trigger.isBefore) {
        List<Lead> lstLeads = new List<Lead>();
        for (Lead lead : trigger.old) {
            if(lead.Convert_Lead__c == false)
            {
                lstLeads.add(lead);
            }
        }
        
         if(!lstLeads.isEmpty() && !system.isFuture() 
                && !system.isBatch() 
                && !system.isScheduled() 
                && !CRMS_LeadTriggerHandler.isTriggerCalled ){
                AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.old, AMPSyncApp_Constants.SYNC_ACTION_DELETE);
                CRMS_LeadTriggerHandler.isTriggerCalled = true;
         }
        
        if (!lstLeads.isEmpty()) {
            objLeadHandler.updateSyncQueueRecord(lstLeads);
        }
    } 
}