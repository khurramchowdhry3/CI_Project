/**
    Handler class for the Lead trigger
    Author: CRM Superstars
    Version: 1.0
*/
public class CRMS_LeadTriggerHandler 
{
    public static Boolean isTriggerCalled = false;
    public static Boolean isTriggerCalledOnInsert = false;
    
    //method to auto update CurrencyIsoCode field 
    public void AutoPopulate(List<Lead> lstLead, map<Id,Lead> mapOldLead)
    { 	        
        
        for(Lead objLead :lstLead)
        {
            if(objLead.TA_Country__c != Null)
            { 
                
                if(objLead.TA_Country__c.contains('Hong'))
                {
                    objLead.CurrencyIsoCode = 'HKD';                    
                }
                else if(objLead.TA_Country__c.contains('Philippines'))
                {
                    objLead.CurrencyIsoCode = 'PHP';
                }
                else if(objLead.TA_Country__c.contains('Singapore'))
                {
                    objLead.CurrencyIsoCode = 'SGD';
                }
                else
                {
                   
                    objLead.CurrencyIsoCode = 'GBP';
                }
                
                
            }           
            //methods split due to null pointer
            if(objLead.LE_Country__c != Null && objLead.CurrencyIsoCode == 'GBP')
            { 
                if(objLead.LE_Country__c.contains('Hong'))
                {
                    objLead.CurrencyIsoCode = 'HKD';
                }
                else if(objLead.LE_Country__c.contains('Philippines'))
                {
                    objLead.CurrencyIsoCode = 'PHP';
                }
                else if(objLead.LE_Country__c.contains('Singapore'))
                {
                    objLead.CurrencyIsoCode = 'SGD';
                }
                else
                {
                    objLead.CurrencyIsoCode = 'GBP';
                }
            }
        	
        	/****** Khurram Shahzad 17/02/2016 SPT-298 *****
        	*
        	* Set Country Field according to CurrencyIsoCode Selected
        	*/
        	
        	if(objLead.CurrencyIsoCode == 'GBP'){
            	ObjLead.Country__c = 'UK';            	
            }else if(objLead.CurrencyIsoCode == 'HKD'){
            	ObjLead.Country__c = 'Hong Kong';
            }else if(objLead.CurrencyIsoCode == 'SGD'){
            	ObjLead.Country__c = 'Singapore';
            }else if(objLead.CurrencyIsoCode == 'PHP'){
            	ObjLead.Country__c = 'Philippines';
            }
            ObjLead.Country = ObjLead.Country__c;           
            
            /****** Khurram Shahzad 17/02/2016 SPT-298 *****/
            
            
            if(objLead.OwnerId != null)
            {
                objLead.Lead_Owner_Id__c = objLead.OwnerId;
            }
            
            if(objLead.Trading_Address_if_different__c == false)
            {
                if(objLead.LE_Country__c !=null && objLead.LE_Country__c != '') 
                	objLead.TA_Country__c = objLead.LE_Country__c;
                if(objLead.LE_Region__c != null && objLead.LE_Region__c != '') 
                	objLead.TA_Region__c = objLead.LE_Region__c;
                if(objLead.LE_District__c != null && objLead.LE_District__c != '') 
                	objLead.TA_District__c = objLead.LE_District__c;                
                if(objLead.LE_Sub_region__c != null && objLead.LE_Sub_region__c != '')
                	objLead.TA_Sub_region__c = objLead.LE_Sub_region__c;
                if(objLead.LE_City_Lookup__c != null)
                	objLead.TA_City_Lookup__c = objLead.LE_City_Lookup__c;
            }
            if(objLead.Status == 'Qualified' && mapOldLead != null && mapOldLead.get(objLead.Id).Status != 'Qualified')
            { 
                objLead.Qualified_By__c = UserInfo.getUserId();
            }
               
        }
        //system.debug('lstLead:'+JSON.serializePretty(lstLead));
    }   
 
    // method to convert Lead into Person Account,Account and Opportunity 
    public void autoConvertLead (List<Lead> lstLead)
    {
        map<String,Id> mapLeadId_OwnerId = new map<String,Id>();
        map<ID,ID> LeadUsersProfiles = new map<ID,ID>();
        map<ID, String> UsersProfilesMap = new map<ID, String>();
        

        for(Lead objLead :lstLead)
        {
            LeadUsersProfiles.put(objLead.CreatedBy.ProfileId,objLead.Id);
            if(objLead.OwnerId != null)
            {
                mapLeadId_OwnerId.put(objLead.Id,objLead.OwnerId);
            }
        }
        
        for(Profile P : [select Id,Name from Profile Where Id IN : LeadUsersProfiles.keySet()]){
        	UsersProfilesMap.put(LeadUsersProfiles.get(P.Id),P.Name);
        }
        
        
        list<User> lstUser = [Select u.Profile_Name__c, u.LastName, u.Id, u.Name, u.Contact.Allocated_Internal_Sales_Representative__c From User u where u.Id IN :mapLeadId_OwnerId.values()];
        list<RecordType> lstPersonAccRecordType = [Select r.SobjectType, r.Name, r.IsPersonType, r.Id, r.DeveloperName From RecordType r where r.SobjectType='Account' and  r.DeveloperName='Person_UK'];
        map<Id,Id> mapUserId_ContactAllocatedId = new map<Id,Id>();
        map<Id,Account> mapLeadId_Account = new map<Id,Account>();
        map<Id,Id> mapBAccountId_OppId = new map<Id,Id>();
        map<Id,Id> mapBAccountId_PersonAccountId = new map<Id,Id>();
        map<Id,Id> mapOppId_PAId = new map<Id,Id>();
        
        list<Account> lstPersonAccToInsert = new list<Account>();
        list<Contact> lstPersonContactToDelete = new list<Contact>();
        list<Guarantors__c> lstGuarantorsToInsert = new list<Guarantors__c>();
        list<Opportunity> lstOppToUpdate = new list<Opportunity>(); 
        set<Id> setPersonContactToDelete = new set<Id>();
        Map<ID,String> leadCountryMap = new Map <ID,String>();
        map<ID,ID> LeadPersonAccountIdMap = new map<ID,ID>();
        map<ID,Account> LeadPersonAccountMap = new map<ID,Account>();
        
        for(User objUser : lstUser)
        {
            if(objUser.Contact.Allocated_Internal_Sales_Representative__c!=null&&objUser.Contact.Allocated_Internal_Sales_Representative__c!='')
            mapUserId_ContactAllocatedId.put(objUser.Id,objUser.Contact.Allocated_Internal_Sales_Representative__c);
        }
        
        List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
        
        for (Lead objLead : lstLead)
        {
            if (objLead.isConverted == false && UsersProfilesMap.get(objLead.Id) != 'AMP Integration')
            {
                Database.LeadConvert lc = new Database.LeadConvert();                        
                lc.setLeadId(objLead.Id);
                lc.setConvertedStatus(objLead.Status);
                if(mapUserId_ContactAllocatedId.get(objLead.OwnerId) != null&&mapUserId_ContactAllocatedId.get(objLead.OwnerId)!='')
                {
                    lc.setOwnerId(mapUserId_ContactAllocatedId.get(objLead.OwnerId));
                    lc.setSendNotificationEmail(true);
                }
                leadConverts.add(lc);
                
                leadCountryMap.put(objLead.Id, objLead.TA_Country__c);                
                LeadPersonAccountIdMap.put(objLead.PersonAccountId__c,objLead.Id);
            }
        }
        try
        {
            if(LeadPersonAccountIdMap != null && LeadPersonAccountIdMap.size() >0)
	            for(Account AC: [Select a.Id, 
	            					a.Associated_Business__c, 
	            					a.PersonContactId From Account a 
	            					Where Id IN:LeadPersonAccountIdMap.keyset()]){
	            						
	            	LeadPersonAccountMap.put(LeadPersonAccountIdMap.get(AC.Id),AC);
	            }
                                   
            if (!leadConverts.isEmpty()) 
            {
                List<Database.LeadConvertResult> lcr = Database.convertLead(leadConverts, false );
                List<Account> createdAccount = new List<Account>();
                Map<ID,ID> createdAccountIDLeadID = new Map<ID,ID>();
                Set<Id> createdAccountIDs = new Set<id>();
                
                for(Database.LeadConvertResult objResult : lcr)
                {	
                  	//system.debug('objResult.getErrors()'+objResult.getErrors());
                  	//system.debug('objResult.getAccountID()'+objResult.getAccountID());
                    createdAccountIDs.add(objResult.getAccountID());
                    createdAccountIDLeadID.put(objResult.getAccountId(),objResult.getLeadId());
                  	//system.debug('createdAccountIDLeadID'+createdAccountIDLeadID);
                    if(objResult.isSuccess())
                    {
                        if(LeadPersonAccountMap.get(objResult.getLeadId()) != null)
                        {
                            Account objAccount = LeadPersonAccountMap.get(objResult.getLeadId());
                            objAccount.Associated_Business__c = objResult.getAccountId();
                            //system.debug('MIRO ->>......  objAccount.Associated_Business__c'+ objAccount.Associated_Business__c);
                            lstPersonAccToInsert.add(objAccount);   
                            mapBAccountId_OppId.put(objResult.getAccountId(),objResult.getOpportunityId());
                        }
                    }
                    setPersonContactToDelete.add(objResult.getContactId());
                }
                
               createdAccount = [Select id,TA_Country__c,LE_Country__c from Account where id in :createdAccountIDs];                             
               for(Account tempA : createdAccount){                    
                    //System.debug('Miro Debug --->> Before --->> tempA.TA_Country__c:' + tempA.TA_Country__c + 'tempA.LE_Country__c:'+tempA.LE_Country__c);                    
                    //System.debug('Miro Debug --->>  --->>leadCountryMap.get(createdAccountIDLeadID.get(tempA.id))' + leadCountryMap.get(createdAccountIDLeadID.get(tempA.id)));
                  //  tempA.TA_Country__c = leadCountryMap.get(createdAccountIDLeadID.get(tempA.id));
                   // tempA.LE_Country__c = tempA.TA_Country__c;
                    tempA.Converted__c = true;
                    tempA.Lead_Id__c = createdAccountIDLeadID.get(tempA.Id);
                    //System.debug('Miro Debug --->> After --->> tempA.TA_Country__c:' + tempA.TA_Country__c + 'tempA.LE_Country__c:'+tempA.LE_Country__c);                    
                }
                //system.debug('createdAccount:'+createdAccount);
                upsert createdAccount;
                
            }
            if(!lstPersonAccToInsert.isEmpty())
            {
                update lstPersonAccToInsert;
                
                map<Id,Id> mapPersonAcount_PartnerAccountId = new map<Id,Id>(); 
                list<Account> lstPA = [Select a.IsPersonAccount, a.Id, a.Associated_Business__c, 
                                      a.Partner_Website_Tracker__c, a.PersonContactId, a.Name, 
                                      a.PersonEmail, a.Business_Position__pc, a.Consent_to_Search__pc
                                      From Account a 
                                      where a.IsPersonAccount = true and a.Associated_Business__c IN : mapBAccountId_OppId.Keyset() limit 1];
               
                //system.debug('MIRO ->>......  mapBAccountId_OppId.Keyset()'+ mapBAccountId_OppId.Keyset());
                system.debug('MIRO ->>...... lstPA'+lstPA);
                
                list<Opportunity> lstOpp = [Select o.Primary_Contact__c, o.Id , o.Partner_Website_Tracker__c
                                           From Opportunity o
                                           where o.Id IN : mapBAccountId_OppId.Values()];
                                           
                if(!lstPA.isEmpty())
                {                    
                    for(Account objPA : lstPA)
                    {//system.debug('MIRO ->>...... objPA.Associated_Business__c'+objPA.Associated_Business__c);                        
                        mapBAccountId_PersonAccountId.put(objPA.Associated_Business__c, objPA.PersonContactId);
                        if(mapBAccountId_OppId.get(objPA.Associated_Business__c) != Null)
                        {//system.debug('MIRO ->>...... mapBAccountId_OppId.get(objPA.Associated_Business__c)'+mapBAccountId_OppId.get(objPA.Associated_Business__c));
                            Guarantors__c objGuarantors = new Guarantors__c();
                            objGuarantors.Account__c = objPA.Id;
                            objGuarantors.Opportunity__c = mapBAccountId_OppId.get(objPA.Associated_Business__c);
                            objGuarantors.Email__c = objPA.PersonEmail;
                            objGuarantors.Consent_to_Search__c = objPA.Consent_to_Search__pc;
                            objGuarantors.Account_Role__c = objPA.Business_Position__pc;
                            lstGuarantorsToInsert.add(objGuarantors);          
                            
                            mapOppId_PAId.put(mapBAccountId_OppId.get(objPA.Associated_Business__c),objPA.Id);                     
                        }
                        if(objPA.Partner_Website_Tracker__c != null)
                        {
                            mapPersonAcount_PartnerAccountId.put(objPA.Id, objPA.Partner_Website_Tracker__c);
                        }
                    }
                    
                    
                }
                //system.debug('MIRO ->>...... mapBAccountId_OppId:'+mapBAccountId_OppId);
                
                //system.debug('MIRO ->>...... mapOppId_PAId:'+mapOppId_PAId);
                
                if(!lstOpp.isEmpty())
                {
                    for(Opportunity objOpp : lstOpp)
                    { //system.debug('MIRO ->>...... objOpp id:'+objOpp);
                        if(mapOppId_PAId.get(objOpp.Id) != null)
                        {//system.debug('MIRO ->>...... mapOppId_PAId.get(objOpp.Id)'+mapOppId_PAId.get(objOpp.Id));
                            objOpp.Primary_Contact__c = mapOppId_PAId.get(objOpp.Id);
                            if(mapPersonAcount_PartnerAccountId.get(mapOppId_PAId.get(objOpp.Id)) != null)
                            {
                                objOpp.Partner_Website_Tracker__c = mapPersonAcount_PartnerAccountId.get(mapOppId_PAId.get(objOpp.Id));
                            }
                            lstOppToUpdate.add(objOpp);
                         //system.debug('MIRO ->>...... objOpp.Primary_Contact__c'+objOpp.Primary_Contact__c);
                        }
                    }
                }
                if(!setPersonContactToDelete.isEmpty())
                {
                    lstPersonContactToDelete = [Select c.IsPersonAccount, c.Id, c.AccountId, 
                                                (Select Id, WhoId From Tasks), 
                                                (Select Id, WhoId From Events), 
                                                (Select Id, WhoId From ActivityHistories) 
                                                From Contact c 
                                               where c.Id IN : setPersonContactToDelete
                                               and IsPersonAccount = false];
                }
                if(!lstOppToUpdate.isEmpty())
                {//system.debug('lstOppToUpdate:'+lstOppToUpdate);
                    update lstOppToUpdate;
                }
                if(!lstGuarantorsToInsert.isEmpty())
                {//system.debug('lstGuarantorsToInsert:'+lstGuarantorsToInsert);
                    insert lstGuarantorsToInsert;
                }
            }
            if(!lstPersonContactToDelete.isEmpty())
            {
                list<Task> lstTask = new list<Task>();
                list<Event> lstEvent = new list<Event>();
                list<ActivityHistory> lstActivityHistory = new list<ActivityHistory>();
                for(Contact objC : lstPersonContactToDelete){
                	if(objC.AccountId != null && mapBAccountId_PersonAccountId.get(objC.AccountId) != null) {
	                	for(Task objTask : objC.Tasks){
	                		objTask.WhoId = mapBAccountId_PersonAccountId.get(objC.AccountId);
	                		lstTask.add(objTask);
	                	}
	                	for(Event objEvent : objC.Events){
	                		objEvent.WhoId = mapBAccountId_PersonAccountId.get(objC.AccountId);
	                		lstEvent.add(objEvent);
	                	}
                	}
                }
                //system.debug('lstTask:'+lstTask);
                //system.debug('lstEvent:'+lstEvent);
                //system.debug('lstPersonContactToDelete:'+lstPersonContactToDelete);
                update lstTask;
                update lstEvent;
                delete lstPersonContactToDelete;
            }
        }
        catch(DmlException e)
        {
            
                system.debug('exception:'+e.getMessage());
            for (Integer i = 0; i < e.getNumDml(); i++) 
            {
            } 
        }
    }
    // method to set Lead status as Queued when updated on SF end
    public void setLeadDWHStatusQueued(List<Lead> lstLead) {
        set<Id> setPartnerAccountId = new set<Id>();
        for (Lead lead : lstLead) 
        {
            if(!lead.IsConverted)
            {
                lead.DWH_Status__c = CRMS_Constants.DWH_STATUS_QUEUED;
                if(lead.Partner_Website_Id__c != null && lead.Partner_Website_Id__c != '')
                {
                    //setPartnerAccountId.add(lead.Partner_Website_Id__c);
                    lead.Partner_Website_Tracker__c = lead.Partner_Website_Id__c;
                }
            }
        }
        /*
        if(!setPartnerAccountId.isEmpty())
        {
            map<Id,Account> mapAccount = new map<Id, Account>([Select Id from Account where Id IN: setPartnerAccountId]);
            if(mapAccount != null && !mapAccount.isEmpty())
            {
                for(Lead lead : lstLead)
                {
                    if(mapAccount.get(lead.Partner_Website_Id__c) != null)
                    lead.Partner_Website_Tracker__c = mapAccount.get(lead.Partner_Website_Id__c).Id;
                }
            }
        }*/
    }
    // method to set Lead status as Synced when successfully synced with DWH
    public void setLeadDWHStatusSynced(List<Lead> lstLead) {
        for (Lead lead : lstLead) 
        {
            lead.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
            lead.DWH_Last_Sync__c = Datetime.now();
        }
        
    }
    
    
   // method to create/update Sync Queue records 
   public void updateSyncQueueRecord(List<Lead> lstLead){
        Map<Id,List<Sync_Queue__c>> leadIdToSynchQueListMap = new  Map<Id,List<Sync_Queue__c>>();
        Set<Id> leadIdSet = new Set<Id>();
        Sync_Queue__c[] synchQueueUpdateList = new Sync_Queue__c[]{};
        Sync_Queue__c[] synchQueueCreateList = new Sync_Queue__c[]{};
        
        for (Lead lead : lstLead) {
            leadIdSet.add(lead.Id);
        }
        List<Sync_Queue__c> syncQueueList = [
            SELECT Lead__c
                 , Notes__c
                 , Action__c
                 , Queued_Record_ID__c
                 , Sync_Status__c
                 , DWH_Data_Type__c
               FROM Sync_Queue__c 
              WHERE Sync_Status__c = :CRMS_Constants.SYNC_QUEUE_STATUS_PENDING
                AND Lead__c IN :leadIdSet
         ];
         
        for (Sync_Queue__c syncQueue : syncQueueList) {
            if (leadIdToSynchQueListMap.containsKey(syncQueue.Lead__c) == true) {
                leadIdToSynchQueListMap.get(syncQueue.Lead__c).add(syncQueue);
            } else {
                leadIdToSynchQueListMap.put(syncQueue.Lead__c, new Sync_Queue__c[] {syncQueue});
            }
        }
        
        for (Lead lead : lstLead) {
            Sync_Queue__c[] synchQueueList = leadIdToSynchQueListMap.get(lead.Id);
            if (synchQueueList != null && !synchQueueList.isEmpty()) {
                for (Sync_Queue__c synchQue : synchQueueList) {
                    if (synchQue.Action__c != CRMS_Constants.SYNC_ACTION_DELETE) {
                        synchQue.Sync_Status__c = CRMS_Constants.SYNC_STATUS_STALE;
                    }
                    String currentDateTime = Datetime.now().format() + CRMS_Constants.DWH_DELETE_TRIGGER;
                    synchQue.Action__c = CRMS_Constants.SYNC_ACTION_DELETE;
                    //synchQue.Notes__c = currentDateTime;
                    synchQue.Queued_Record_ID__c = lead.Id;
                    synchQueueUpdateList.add(synchQue);
                    
                }
            } 
            Sync_Queue__c syncQueue = new Sync_Queue__c();
            syncQueue.Queued_Record_ID__c = lead.Id;
            syncQueue.DWH_Data_Type__c = CRMS_Constants.DWH_DATA_TYPE_LEAD;
            syncQueue.Action__c = CRMS_Constants.SYNC_ACTION_DELETE;
            syncQueue.Sync_Status__c = CRMS_Constants.SYNC_QUEUE_STATUS_PENDING;
            String currentDateTime = Datetime.now().format() + CRMS_Constants.SYNC_STATUS_LEAD_DELETED;
            //syncQueue.Notes__c = currentDateTime;
            synchQueueCreateList.add(syncQueue);
            
        }
        if (!synchQueueUpdateList.isEmpty()) {
            update synchQueueUpdateList;
        }
        if (!synchQueueCreateList.isEmpty()) {
            insert synchQueueCreateList;
        }
    }
    //method to update field of Lead
     public void updateLeadStatus(List<Lead> lstLead) {
       Lead[] leadList = new Lead[]{};
       Lead[] updateLeadList = new Lead[]{};
       Set<Id> leadIdSet = new Set<Id>();
       for (Lead lead : lstLead) {
           leadIdSet.add(lead.Id);
       }
       leadList = [SELECT DWH_Import__c, DWH_Status__c, DWH_Last_Sync__c from Lead where Id IN : leadIdSet];
       
       for (Lead lead : leadList) {
            lead.DWH_Import__c = false;
            updateLeadList.add(lead);
       }
       
       update updateLeadList;
    }
    
    public void updateCampaignID(List<Lead> lstLeads){
        List<CampaignMember> cmList = new list<CampaignMember>();
            Set<id> setLeadId = new Set<id>();
            Map<id,Lead> leadMap = new Map<id,Lead>();
            
            for (Lead ld : lstLeads)
            {
                setLeadId.add(ld.id);
                leadMap.put(ld.id, ld);
            }        
            cmList = [Select CampaignID,LeadID, Campaign.Program__c from CampaignMember where LeadID in :setLeadId and LeadID != null];
            for(CampaignMember cm : cmList){
                leadMap.get(cm.LeadId).CampaignID__c = cm.CampaignID;
                leadMap.get(cm.LeadId).Program__c = cm.Campaign.Program__c;
            }
    }
    public void updateQualifiedRecordType(List<Lead> lstLeads){
        List<RecordType> recTypeList = new List<RecordType>();
        recTypeList = [SELECT Id, Name FROM RecordType where SobjectType = 'lead' and name like '%Qualified'];
        
        Map<String,ID> recTypeMap = new Map<String,ID>();
        
        for(RecordType rt:recTypeList){
            recTypeMap.put(rt.Name, rt.Id);
        }
        //system.debug('Leads before Rec Type'+JSON.serializePretty(lstLeads));
        for(Lead l:lstLeads){
            if (l.CurrencyIsoCode=='HKD'){
                l.RecordTypeId = recTypeMap.get('Hong Kong Qualified');
                l.Country = 'Hong Kong';              
                l.Country__c = 'Hong Kong';
            }else if (l.CurrencyIsoCode=='PHP'){                
                l.RecordTypeId = recTypeMap.get('Philippines Qualified');
                l.Country = 'Philippines';              
                l.Country__c = 'Philippines';
            }else if (l.CurrencyIsoCode=='SGD'){                
                l.RecordTypeId = recTypeMap.get('Singapore Qualified');
                l.Country = 'Singapore';              
                l.Country__c = 'Singapore';
            }else {                
                l.RecordTypeId = recTypeMap.get('UK Qualified'); 
                l.Country = 'UK';              
                l.Country__c = 'UK';
            }

        }
        
        //system.debug('Leads after Rec Type'+JSON.serializePretty(lstLeads));
        
    }
}