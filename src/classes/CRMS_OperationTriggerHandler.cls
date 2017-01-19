/**
    Handler class for the Opearation trigger
    Author: CRM Superstars
    Version: 1.0
*/
public class CRMS_OperationTriggerHandler
{
    public static Boolean isTriggerCalled = false;    
    
    // method to set Operation status as Queued when updated on SF end
    public void setOperationDWHStatusQueued(List<Operation__c> lstOperation) {
        for (Operation__c operation : lstOperation) 
        {
            operation.DWH_Status__c = CRMS_Constants.DWH_STATUS_QUEUED;
        }
    }
    // method to set Operation status as Synced when successfully synced with DWH
    public void setOperationDWHStatusSynced(List<Operation__c> lstOperation){
        for (Operation__c operation : lstOperation) 
        {
            //operation.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
            operation.DWH_Last_Sync__c = Datetime.now();
        }
    }

    public void updateOpportunity(List<Operation__c> lstOperation, map<Id,Operation__c> mapOldOperations){
        map<ID,Opportunity> mapOpportunityToUpdate = new map<ID,Opportunity>(); 
        map<Id, Loan_Management_Event__c> LoanEventmap = new map<Id,Loan_Management_Event__c>();
              
        for(Operation__c objOper : lstOperation){           
            
            if((objOper.Loan_Disbursed__c && mapOldOperations.get(objOper.Id).Loan_Disbursed__c == false)){              
                	
            	mapOpportunityToUpdate.put(objOper.Id, new Opportunity(
                    Id = objOper.Opportunity__c,
                    Disbursed_Date__c = date.today()                    
                ));
                LoanEventmap.put(objOper.Id, new Loan_Management_Event__c(
                    Operation__c = objOper.Id,
                    Event_Date__c = objOper.Loan_Disbursed_Date__c,
                    Event_Type__c = 'Disbursal',
                    Effective_Date__c =  objOper.First_Repayment_Date__c,
                    Event_Amount__c =  objOper.Loan_Amount__c,
                    IsApproved__c = true,
                    ApprovedBy__c = userinfo.getuserId(),
                    Approval_Date__c =  DateTime.now()          
                ));                              
            }
            
            if(objOper.Final_Decision__c == 'Rejected' && mapOldOperations.get(objOper.Id).Final_Decision__c == null){
                mapOpportunityToUpdate.put(objOper.Id, new Opportunity(
                    Id = objOper.Opportunity__c,
                    StageName = 'Loan Withdrawn'
                ));
            }
        }
        if(LoanEventmap.size() > 0 && !LoanEventmap.isEmpty()){         
            Database.insert(LoanEventmap.values());
        }
        if(!mapOpportunityToUpdate.isEmpty() && mapOpportunityToUpdate.size() > 0){           
            update mapOpportunityToUpdate.values();
        }
    }
    
    public void CheckForAdditionalInformation(map<Id,Operation__c> mapNewOperations,map<Id,Operation__c> mapOldOperations){
        list<Task> AdditionalInfoTasks = new list<Task>();
        for(Operation__c Operation : mapNewOperations.values()){
            if(Operation.Disbursal_More_Info__c == true 
                && Operation.Additional_Information_Narrative__c != null
                && mapOldOperations.get(Operation.Id).Disbursal_More_Info__c != true){
                
                AdditionalInfoTasks.add( this.CreatTask(Operation,
                                'Additional information is required for disbursal of funds',
                                'Normal'));             
            }
            
            if(Operation.Additional_Information_Narrative__c != null
                && mapOldOperations.get(Operation.Id).Additional_Information_Narrative__c != null
                && Operation.Additional_Information_Narrative__c != mapOldOperations.get(Operation.Id).Additional_Information_Narrative__c){
                AdditionalInfoTasks.add( this.CreatTask(Operation,
                                'Additional information is not satisfactory for disbursal of funds',
                                'Normal'));
            }
        }
        if(AdditionalInfoTasks.size()>0 && !AdditionalInfoTasks.isEmpty()){
            Database.insert(AdditionalInfoTasks);
        }         
    
    }
    
    private Task CreatTask(Operation__c OperationObj,string Subject, string Priority){
        Task AdditionalInfoTask= new Task();        
        if(OperationObj != null){
            ID AssignedToUser;
             
            if(OperationObj.RecordtypeId == '012260000008Txc'){ //Operation UK
                AssignedToUser = '00526000000Q6R6'; //Opera UK-Agent 
            }else if(OperationObj.RecordtypeId == '012260000008Txh'){ //Operation HK
                AssignedToUser = '00526000000QTN2'; //Opera HK-Agent 
            }else if(OperationObj.RecordtypeId == '012260000008Txm'){ //Operation SG
                AssignedToUser = '00526000000Qide'; //Opera SG-Agent 
            }else AssignedToUser = OperationObj.OwnerId;
                        
            AdditionalInfoTask.WhatId = OperationObj.Id;
            AdditionalInfoTask.Status = 'Not Started';
            AdditionalInfoTask.OwnerId = AssignedToUser;
            AdditionalInfoTask.Subject = Subject;
            AdditionalInfoTask.Description = 'The following additional information is required: \n' + 
            OperationObj.Additional_Information_Narrative__c;
            AdditionalInfoTask.Priority = Priority;
            AdditionalInfoTask.ActivityDate = date.today();
        }
        return AdditionalInfoTask;        
    }

    // method to create/update Sync Queue records
    public void updateSyncQueueRecord(List<Operation__c> lstOperation){
        Map<Id,List<Sync_Queue__c>> operationIdToSynchQueListMap = new  Map<Id,List<Sync_Queue__c>>();
        Set<Id> operationIdSet = new Set<Id>();
        Sync_Queue__c[] synchQueueUpdateList = new Sync_Queue__c[]{};
        Sync_Queue__c[] synchQueueCreateList = new Sync_Queue__c[]{};
        
        for (Operation__c operation : lstOperation) {
            operationIdSet.add(operation.Id);
        }
        List<Sync_Queue__c> syncQueueList = [
            SELECT Operation__c
                 , Notes__c
                 , Action__c
                 , Queued_Record_ID__c
                 , Sync_Status__c
                 , DWH_Data_Type__c
               FROM Sync_Queue__c 
              WHERE Sync_Status__c = :CRMS_Constants.SYNC_QUEUE_STATUS_PENDING
                AND Operation__c IN :operationIdSet
         ];
         
        for (Sync_Queue__c syncQueue : syncQueueList) {
            if (operationIdToSynchQueListMap.containsKey(syncQueue.Operation__c) == true) {
                operationIdToSynchQueListMap.get(syncQueue.Operation__c).add(syncQueue);
            } else {
                operationIdToSynchQueListMap.put(syncQueue.Operation__c, new Sync_Queue__c[] {syncQueue});
            }
        }
        
        for (Operation__c operation : lstOperation) {
            Sync_Queue__c[] synchQueueList = operationIdToSynchQueListMap.get(operation.Id);
            system.debug('***** synchQueueList '+synchQueueList);
            if (synchQueueList != null && !synchQueueList.isEmpty()) {
                for (Sync_Queue__c synchQue : synchQueueList) {
                    if (synchQue.Action__c != CRMS_Constants.SYNC_ACTION_DELETE) {
                        synchQue.Sync_Status__c = CRMS_Constants.SYNC_STATUS_STALE;
                    }
                    String currentDateTime = Datetime.now().format() + CRMS_Constants.DWH_DELETE_TRIGGER;
                    synchQue.Action__c = CRMS_Constants.SYNC_ACTION_DELETE;
                    synchQue.Notes__c = currentDateTime;
                    synchQue.Queued_Record_ID__c = operation.Id;
                    synchQueueUpdateList.add(synchQue);
                }
            } 
            Sync_Queue__c syncQueue = new Sync_Queue__c();
            syncQueue.Queued_Record_ID__c = operation.Id;
            syncQueue.DWH_Data_Type__c = CRMS_Constants.DWH_DATA_TYPE_OPERATION;
            syncQueue.Action__c = CRMS_Constants.SYNC_ACTION_DELETE;
            syncQueue.Sync_Status__c = CRMS_Constants.SYNC_QUEUE_STATUS_PENDING;
            String currentDateTime = Datetime.now().format() + CRMS_Constants.SYNC_STATUS_OPERATION_DELETED;
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
    
    public void sendEmailToOpportunityTeam(List<Operation__c> lstOperation){
        Map<Id,Id> opportunityOperationMapForEmail = new Map<Id,Id>();
        for(Operation__c tempOp : lstOperation) {
            if(tempOp.Ready_for_Finance_Approval__c == true && tempOp.ReadyForFinanceEmailSent__c == false){
                opportunityOperationMapForEmail.put(tempOp.Opportunity__c,tempOp.Id);
                tempOp.ReadyForFinanceEmailSent__c = true;
            }
        }
        system.debug('Miro opportunityOperationMapForEmail:' + opportunityOperationMapForEmail);
        if(!opportunityOperationMapForEmail.isEmpty()){
            List<OpportunityTeamMember> oppsTeamMembersList = new List<OpportunityTeamMember>();
            oppsTeamMembersList = [Select OpportunityId,User.Email,User.FirstName,User.LastName, Name 
                                   FROM OpportunityTeamMember 
                                   Where OpportunityId IN :opportunityOperationMapForEmail.keySet() And TeamMemberRole = 'Finance'];
            
        system.debug('Miro oppsTeamMembersList:' + oppsTeamMembersList);
                List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
                EmailTemplate templateId = [Select id from EmailTemplate where name = 'Operation Ready For Finance'];
                Messaging.SingleEmailMessage mail;
                List<Contact> tempContactsList = new List<Contact>();
        system.debug('Miro templateId:' + templateId);
            for(OpportunityTeamMember teamMember : oppsTeamMembersList)       {     
                mail = new Messaging.SingleEmailMessage();
                Contact tempContact = new Contact(email = teamMember.User.email, firstName = teamMember.User.FirstName, lastName = teamMember.User.LastName);
                insert tempContact;
                tempContactsList.add(tempContact);
                
                mail.setTemplateID(templateId.Id); 
                mail.setTargetObjectId(tempContact.id);
                mail.setWhatId (opportunityOperationMapForEmail.get(teamMember.OpportunityId));
                mail.setSaveAsActivity(false);
                mail.setUseSignature(false);

                mail.setToAddresses(new String[]{teamMember.User.Email});
    
                allmsg.add(mail);
            }
                system.debug('Miro Emails - >>'+JSON.serialize(allmsg));
                Messaging.SendEmailResult[] res = Messaging.sendEmail(allmsg,false);
            delete tempContactsList;
            for(Messaging.SendEmailResult tempRes : res){
                system.debug('Miro res Emails:' + tempRes.getErrors());}
        }
    }
   
}// end of class