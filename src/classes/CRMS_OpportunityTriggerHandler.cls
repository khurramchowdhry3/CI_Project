/**
    Handler class for the Opportunity trigger
    Author          Version             Description
    Vivian Charlie  1.0                 Initial Draft
    Vivian Charlie  1.1                 Added functionality to update Credit Assessment 
                                        and Operations after Loan is withdrawn
*/
public class CRMS_OpportunityTriggerHandler 
{
    public static Boolean isEmailSent = false;
    public static boolean blnUpdate = false;
    public static Boolean isTriggerCalledOnInsert = false;
    public static final string WITHDRAWN_BY_CUSTOMER = 'Application withdrawn by customer';
    public static final string WITHDRAWN_BY_AMP = 'Application withdrawn by AMPLIFI Capital';
    //public static final string REFUSE_TO_BORROW = 'Refuse to borrow from unfamiliar compan';
    public static final string NO_RESPONSE = 'No Response from Client';
    public static final string LOAN_WITHDRAWN = 'Loan Withdrawn';
    
    private static boolean run = true;
    public static boolean runOnce(){
        if(run){
            run = false;
            return true;
        }else{
                return run;
        }
    }
    
    //method to validate Loan Amount of Opportunity  
    public void validateLoanAmount(list<Opportunity> lstOpportunity)
    {
        for(Opportunity objOpp : lstOpportunity)
        {
            if(objOpp.Average_Monthly_Card_Sales__c > 0)
            {
                if(objOpp.Amount > (objOpp.Average_Monthly_Card_Sales__c * objOpp.Conditional_Approval_Multiplier__c))
                {
                    objOpp.addError(Label.CRMS_RequestedAmountError);
                }
            }
        }
    }
    // method to set Opportunity status as Queued when updated on SF end
    public void setOpportunityDWHStatusQueued(List<Opportunity> lstOpportunity) {
        for (Opportunity opp : lstOpportunity) 
        {
            opp.DWH_Status__c = CRMS_Constants.DWH_STATUS_QUEUED;
        }
        
    }
    // method to set Opportunity status as Synced when successfully synced with DWH
    public void setOpportunityDWHStatusSynced(List<Opportunity> lstOpportunity) {
        for (Opportunity opp : lstOpportunity) 
        {
            opp.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
            opp.DWH_Last_Sync__c = Datetime.now();
        }
        
    }
    // method to create/update Sync Queue records
    public void updateSyncQueueRecord(List<Opportunity> lstOpportunity){
        Map<Id,List<Sync_Queue__c>> opportunityIdToSynchQueListMap = new  Map<Id,List<Sync_Queue__c>>();
        Set<Id> opportunityIdSet = new Set<Id>();
        Sync_Queue__c[] synchQueueUpdateList = new Sync_Queue__c[]{};
        Sync_Queue__c[] synchQueueCreateList = new Sync_Queue__c[]{};
        
        for (Opportunity opportunity : lstOpportunity) {
            opportunityIdSet.add(opportunity.Id);
        }
        List<Sync_Queue__c> syncQueueList = [
            SELECT Opportunity__c
                 , Notes__c
                 , Action__c
                 , Queued_Record_ID__c
                 , Sync_Status__c
                 , DWH_Data_Type__c
               FROM Sync_Queue__c 
              WHERE Sync_Status__c = :CRMS_Constants.SYNC_QUEUE_STATUS_PENDING
                AND Opportunity__c IN :opportunityIdSet
         ];
         
        for (Sync_Queue__c syncQueue : syncQueueList) {
            if (opportunityIdToSynchQueListMap.containsKey(syncQueue.Opportunity__c) == true) {
                opportunityIdToSynchQueListMap.get(syncQueue.Opportunity__c).add(syncQueue);
            } else {
                opportunityIdToSynchQueListMap.put(syncQueue.Opportunity__c, new Sync_Queue__c[] {syncQueue});
            }
        }
        
        for (Opportunity opportunity : lstOpportunity) {
            Sync_Queue__c[] synchQueueList = opportunityIdToSynchQueListMap.get(opportunity.Id);
            if (synchQueueList != null && !synchQueueList.isEmpty()) {
                for (Sync_Queue__c synchQue : synchQueueList) {
                    if (synchQue.Action__c != CRMS_Constants.SYNC_ACTION_DELETE) {
                        synchQue.Sync_Status__c = CRMS_Constants.SYNC_STATUS_STALE;
                    }
                    String currentDateTime = Datetime.now().format() + CRMS_Constants.DWH_DELETE_TRIGGER;
                    //synchQue.Notes__c = currentDateTime;
                    synchQue.Queued_Record_ID__c = opportunity.Id;
                    synchQue.DWH_Data_Type__c = CRMS_Constants.DWH_DATA_TYPE_OPPORTUNITY;
                    synchQue.Action__c = CRMS_Constants.SYNC_ACTION_DELETE;
                    synchQueueUpdateList.add(synchQue);
                }
            } 
            Sync_Queue__c syncQueue = new Sync_Queue__c();
            syncQueue.Queued_Record_ID__c = opportunity.Id;
            syncQueue.DWH_Data_Type__c = CRMS_Constants.DWH_DATA_TYPE_OPPORTUNITY;
            syncQueue.Action__c = 'Delete';
            syncQueue.Sync_Status__c = CRMS_Constants.SYNC_QUEUE_STATUS_PENDING;
            String currentDateTime = Datetime.now().format() + CRMS_Constants.SYNC_STATUS_OPPORTUNITY_DELETED;
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
    
    //method to set Introducer of Opportunity
    public void beforeInsert(list<Opportunity> lstOpportunity)
    {
        
        //SPT-101 add LeadID to Opportunity
        populateLeadID(lstOpportunity);
        set<Id> setRecordtypeId = new set<Id>();
        for(Opportunity objOpp : lstOpportunity)
        {
            if(objOpp.Lead_Owner_Id__c != null)
            {
                Id idLeadOwnerId = Id.valueOf(objOpp.Lead_Owner_Id__c);
                // commented temporarily to test SPT-28 'Introducer' value should be different for Internal and partner 
                //objOpp.Introducer__c = idLeadOwnerId;
            }
            if(objOpp.RecordTypeId != null) {
              setRecordtypeId.add(objOpp.RecordTypeId);
            }           
        }
        
        map<Id, RecordType> mapId_RT;
        if(!setRecordtypeId.isEmpty()) {
            mapId_RT = new map<Id, RecordType> ([Select Id, Name, DeveloperName 
                                                from RecordType 
                                                where Id IN: setRecordtypeId]);
        }
        for(Opportunity objOpp : lstOpportunity){
            if(objOpp.RecordTypeId != null) {
                if(mapId_RT.get(objOpp.RecordTypeId).DeveloperName.contains('Hong')
                || mapId_RT.get(objOpp.RecordTypeId).DeveloperName.contains('HK')){
                    objOpp.CurrencyIsoCode = 'HKD';
                }
                else if(mapId_RT.get(objOpp.RecordTypeId).DeveloperName.contains('Philippine')
                || mapId_RT.get(objOpp.RecordTypeId).DeveloperName.contains('PP')){
                    objOpp.CurrencyIsoCode = 'PHP';
                }
                else if(mapId_RT.get(objOpp.RecordTypeId).DeveloperName.contains('Singapore')
                || mapId_RT.get(objOpp.RecordTypeId).DeveloperName.contains('SG')){
                    objOpp.CurrencyIsoCode = 'SGD';
                }
                else if(mapId_RT.get(objOpp.RecordTypeId).DeveloperName.contains('UK')){
                    objOpp.CurrencyIsoCode = 'GBP';
                }
            }
            if(objOpp.Signed_Application_Form_Received__c){
                objOpp.Data_Protection_Act_Declaration__c = true;
                objOpp.Credit_File_Disclosure__c = true;
            }
        }
        
    }
    
    public void afterInsert(map<Id,Opportunity> mapNewOpportunity)
    {                       
        list<Opportunity> OpportunityUpdates = new list<Opportunity>();
        
        for(Opportunity objOpp : mapNewOpportunity.values()){
            if (objOpp.Program_Product_ASO__c != null && objOpp.Amount != null){   
                
                double interestPremium = objOpp.Loan_Interest__c*objOpp.Loan_Term_In_Days__c / (365*100);                             
                integer repaymentsNum = integer.valueof(objOpp.Loan_Frequency__c == 'Daily' ? objOpp.No_of_Repayments_Daily__c : objOpp.No_of_Repayments_Weekly__c);
                integer daysIncrement = objOpp.Loan_Frequency__c == 'Daily' ? 1 : 7;
                                                             
                if([select id, Grace_period__c from Loan_Management__c where Program_Product_ASO__c =:objOpp.Program_Product_ASO__c].size() == 0)
                    objOpp.addError('There is no defined Rules Engine for the selected Program - Product association');
                else 
                {
                    Opportunity newOpp = new Opportunity(Id = objOpp.Id);                    
                    integer gracePeriod = integer.valueof([select id,Grace_period__c from Loan_Management__c where Program_Product_ASO__c =:objOpp.Program_Product_ASO__c][0].Grace_period__c);
                    newOpp.APR__c = interestPremium*repaymentsNum*365*100/CRMS_Util.SumCollectionDays(gracePeriod, repaymentsNum, daysIncrement);                    
                    OpportunityUpdates.add(newOpp);
                }
            }
        }
        
        if(OpportunityUpdates.size() > 0 && !OpportunityUpdates.isEmpty()){
            update OpportunityUpdates;
        }
    }
    
    //Method to validate that Loan cannot be withdrawn after 15 days of disbursal
    public void beforeUpdate(map<Id,Opportunity> mapNewOpportunity, map<Id,Opportunity> mapOldOpportunity){
        set<Id> setOpportunityId = new set<Id>();
        for(Opportunity objOpp : mapNewOpportunity.values()){
            if(objOpp.StageName.equalsIgnorecase(LOAN_WITHDRAWN)
            && mapOldOpportunity.get(objOpp.Id).StageName != LOAN_WITHDRAWN){
                setOpportunityId.add(objOpp.Id);
            }
        }
        if(!setOpportunityId.isEmpty()){
            Map<String, Date_Setting__c> mcs = Date_Setting__c.getAll();
            if(mcs != null && mcs.values()[0].Disbursal_Range__c != null){
                Date compareDate = date.parse(date.today().format()).addDays(-integer.valueOf(mcs.values()[0].Disbursal_Range__c));
                list<Operation__c> lstOperation = [Select Id, Loan_Disbursed__c, Loan_Disbursed_Date__c,
                                                   Opportunity__c
                                                   from Operation__c
                                                   where Opportunity__c IN :setOpportunityId
                                                   and Loan_Disbursed_Date__c <=:compareDate];
                
                if(lstOperation != null && !lstOperation.isEmpty()){
                    map<Id,boolean> mapOpportunityId_Boolean = new map<Id,boolean>(); 
                    for(Operation__c objOper : lstOperation){
                        if(objOper.Opportunity__c != null){
                            mapOpportunityId_Boolean.put(objOper.Opportunity__c,true);
                        }
                    } // end of for loop
                    
                    for(Opportunity objOpp : mapNewOpportunity.values()){
                        if(objOpp.StageName.equalsIgnorecase(LOAN_WITHDRAWN)
                        && mapOldOpportunity.get(objOpp.Id).StageName != LOAN_WITHDRAWN){
                            if(mapOpportunityId_Boolean.get(objOpp.Id) != null
                            && mapOpportunityId_Boolean.get(objOpp.Id) != false){
                                objOpp.addError(Label.Disbursal_Range_Error);
                            }
                        }                      
                        
                    } // end od for loop
                } // end of lstOperation not null
            } // custom setting is not null
        } // setOpportunityId is not empty
        
        
    } // end of beforeUpdate
    
    // Method to create Credit Assessment and Operation records 
    public void afterUpdate(map<Id,Opportunity> mapNewOpportunity, map<Id,Opportunity> mapOldOpportunity)
    {
        list<Credit_Assessment__c> lstCredit_Assessment = new list<Credit_Assessment__c>();
        map<Id,Credit_Assessment__c> mapOppId_CreditAssessment = new map<Id,Credit_Assessment__c>();
        set<Id> setOppId = new set<Id>();
        Opportunity OppObjRef;
        set<Id> setOpportunityIds_With_Updated_Amount = new set<Id>(); 
        list<Operation__c> lstOperationToInsert = new list<Operation__c>();
        
        map<String,Id> mapOfRecordTypeToIdCreditAssessment = new map<String,Id>();
        
        map<String,Id> mapOfRecordTypeToIdOperation =  new map<String,Id>();
        
        list<RecordType> lstCreditAssessmentRecordType = [Select r.SobjectType, r.Name, r.IsActive, r.Id, r.DeveloperName 
                                                        From RecordType r where r.IsActive = true and r.SobjectType= 'Credit_Assessment__c'
                                                        and (NOT r.DeveloperName like '%Completed%')];
        for(RecordType objrecordType : lstCreditAssessmentRecordType)
        {
            if(objRecordType.Name.contains('UK'))
                mapOfRecordTypeToIdCreditAssessment.put('UK',objrecordType.Id);
            
            else if(objRecordType.Name.contains('Hong'))
                mapOfRecordTypeToIdCreditAssessment.put('Hong',objrecordType.Id);
            
            else if(objRecordType.Name.contains('Singapore'))
                mapOfRecordTypeToIdCreditAssessment.put('Singapore',objrecordType.Id); 
            
            else
                mapOfRecordTypeToIdCreditAssessment.put('Philippines',objrecordType.Id);  
        }
        
        list<RecordType> lstOperationRecordType = [Select r.SobjectType, r.Name, r.IsActive, r.Id, r.DeveloperName 
                                                    From RecordType r where r.IsActive = true and r.SobjectType= 'Operation__c'];
                                                    
        for(RecordType objrecordType : lstOperationRecordType)
        {
            if(objRecordType.Name.contains('UK'))
                mapOfRecordTypeToIdOperation.put('UK',objrecordType.Id);
            
            else if(objRecordType.Name.contains('Hong'))
                mapOfRecordTypeToIdOperation.put('Hong',objrecordType.Id);
            
            else if(objRecordType.Name.contains('Singapore'))
                mapOfRecordTypeToIdOperation.put('Singapore',objrecordType.Id); 
            
            else
                mapOfRecordTypeToIdOperation.put('Philippines',objrecordType.Id);  
        }
        
        set<Id> setOppTeamMemberId = new set<Id>();
        set<Id> setCloneOpportunityId = new set<Id>();
        set<Id> setUpdatedOpportunityIds = new set<Id>();
        list<OpportunityTeamMember> lstDeleteOpportunityTeamMember = new list<OpportunityTeamMember>();
        map<Id,Opportunity> mapOppId_IntroId = new map<Id,Opportunity>(); 
        
        list<Opportunity> lstOpportunity = [select Id, OwnerId, Is_Cloned__c, CreatedDate, 
                                            Amount, StageName, RecordTypeId, CloseDate, Name, Country__c,
                                            Contract_End_Date__c, Introducer__c,Contract_Signed__c,Program_Product_ASO__c from Opportunity where Id IN : mapNewOpportunity.keySet()];
        
        
        list<OpportunityTeamMember> lstOpportunityTeamMember = [Select o.UserId, o.TeamMemberRole, o.OpportunityId, o.Id 
                                                                From OpportunityTeamMember o
                                                                where o.OpportunityId IN : mapNewOpportunity.keySet()];
        list<Credit_Assessment__c> lstCreatedCredit = [select Id,Opportunity__c from Credit_Assessment__c 
                                                            where Opportunity__c IN :mapNewOpportunity.keySet()];
        map<Id,Id> mapOppId_CreditId = new map<Id,Id>();
        
        if(lstCreatedCredit != null && !lstCreatedCredit.isEmpty())
        {
            for(Credit_Assessment__c objCreditCreated : lstCreatedCredit )
            {
                mapOppId_CreditId.put(objCreditCreated.Opportunity__c, objCreditCreated.Id);
            }
        }
        
        list<Credit_Assessment__c> lstCreditAssessment = new list<Credit_Assessment__c>();
        
        set<Id> setLostOpportunityId = new set<Id>();
        set<Id> setLostOpportunityId_Operations = new set<Id>();
        for(Opportunity objOpp : mapNewOpportunity.values())
        {
            if((objOpp.StageName.equalsIgnoreCase(WITHDRAWN_BY_CUSTOMER)
            || objOpp.StageName.equalsIgnoreCase(WITHDRAWN_BY_AMP)
            || objOpp.StageName.equalsIgnoreCase(NO_RESPONSE))
            && (mapOldOpportunity.get(objOpp.Id).StageName.equalsIgnoreCase('Assessment in Progress')
            || mapOldOpportunity.get(objOpp.Id).StageName.equalsIgnoreCase('Application Revised')))
            {
                setLostOpportunityId.add(objOpp.Id);
            }
            if(objOpp.StageName.equalsIgnoreCase(LOAN_WITHDRAWN)
            && mapOldOpportunity.get(objOpp.Id).StageName.equalsIgnoreCase('(Won) Signed')){
                setLostOpportunityId_Operations.add(objOpp.Id);
            }
            if(objOpp.Contract_End_Date__c != null && objOpp.StageName == '(Won) Disbursed'
               && mapOldOpportunity.get(objOpp.Id).StageName != '(Won) Disbursed')
            {
                setCloneOpportunityId.add(objOpp.Id);
            }
            if(objOpp.Introducer__c != mapOldOpportunity.get(objOpp.Id).Introducer__c)
            {
                for(OpportunityTeamMember objOppTeammember : lstOpportunityTeamMember)
                {
                    if(objOpp.Introducer__c != null && objOpp.Id == objOppTeammember.OpportunityId)
                    {
                        lstDeleteOpportunityTeamMember.add(objOppTeammember);
                        setOppTeamMemberId.add(objOpp.Id);
                        mapOppId_IntroId.put(objOpp.Id,objOpp);
                    }
                    else if(objOpp.Introducer__c == null && objOpp.Id == objOppTeammember.OpportunityId)
                    {
                        lstDeleteOpportunityTeamMember.add(objOppTeammember);   
                    }
                }
            }
            if(objOpp.Signed_Application_Form_Received__c == true &&  objOpp.Documents_Received_Kofax__c != null
            && objOpp.Application_Form_Completed__c == true && objOpp.Required_Documents_Received__c == true
            && objOpp.Documents_Processed__c == true &&  mapOppId_CreditId.get(objOpp.Id) == null
            && (mapOldOpportunity.get(objOpp.Id).Signed_Application_Form_Received__c != true ||
               mapOldOpportunity.get(objOpp.Id).Documents_Received_Kofax__c == null ||
               mapOldOpportunity.get(objOpp.Id).Application_Form_Completed__c != true ||
               mapOldOpportunity.get(objOpp.Id).Required_Documents_Received__c != true ||
               mapOldOpportunity.get(objOpp.Id).Documents_Processed__c != true )
            )
            {                                 
                Credit_Assessment__c objCredit = new Credit_Assessment__c();
                objCredit.Opportunity__c = objOpp.Id;
                objCredit.CurrencyIsoCode = objOpp.CurrencyIsoCode;
                objCredit.Annual_Calculation__c = objOpp.Annual_Calculation__c;
                objCredit.Offer_Amount__c = null;
                objCredit.Monthly_Interest__c = objOpp.Monthly_Interest__c;
                objCredit.Monthly_Interest_Requested__c = objOpp.Monthly_Interest__c;
                objCredit.Monthly_Interest_Approved__c = objCredit.Annual_Calculation__c?objOpp.Monthly_Interest__c:(objOpp.Monthly_Interest__c*12);
                objCredit.Program_Product_ASO__c = objOpp.Program_Product_ASO__c;
                objCredit.Program__c = objOpp.Program__c;
                //objCredit.FOC__c = objOpp.FOC__c;
                objCredit.Monthly_Interest_Approved__c = objOpp.Monthly_Interest__c;
                objCredit.Approved_Loan_Amount__c = objOpp.Amount;
                objCredit.Approved_Loan_Term__c = objOpp.Requested_Loan_Term__c;
                objCredit.Approved_Interest_Rate__c = string.valueof(objOpp.Loan_Interest__c) + '%';                
                objCredit.APR_Approved__c = objOpp.APR__c; 
                
                if(objOpp.RecType_Name__c.Contains('Hong'))
                    objCredit.RecordTypeId =  mapOfRecordTypeToIdCreditAssessment.get('Hong');
                
                else if(objOpp.RecType_Name__c.Contains('UK'))
                    objCredit.RecordTypeId =  mapOfRecordTypeToIdCreditAssessment.get('UK');
                
                else if(objOpp.RecType_Name__c.Contains('Singapore'))
                    objCredit.RecordTypeId =  mapOfRecordTypeToIdCreditAssessment.get('Singapore');
                
                else 
                    objCredit.RecordTypeId =  mapOfRecordTypeToIdCreditAssessment.get('Philippines');
                lstCreditAssessment.add(objCredit);
            }
            //To Insert Records in Operation Object
            if(objOpp.Contract_Signed__c != mapOldOpportunity.get(objOpp.Id).Contract_Signed__c
            && objOpp.Contract_Signed__c == true)
            {
              setOppId.add(objOpp.Id);
            }
            if(objOpp.RecType_Name__c.contains('Outcome') && 
            (objOpp.Amount != mapOldOpportunity.get(objOpp.Id).Amount ||
            objOpp.Requested_Loan_Term__c != mapOldOpportunity.get(objOpp.Id).Requested_Loan_Term__c))
            {
                setOpportunityIds_With_Updated_Amount.add(objOpp.Id);
            }
        }
        
        if(!setOpportunityIds_With_Updated_Amount.isEmpty())
        {
            notifyCreditTeam(setOpportunityIds_With_Updated_Amount, mapOfRecordTypeToIdCreditAssessment);
        }
        lstCredit_Assessment = [select Id,Opportunity__c,Approved_Loan_Amount__c, Approved_Loan_Term__c, FOC__c,
                                  Monthly_Interest_Approved__c, Number_of_Repayments_Approved__c,
                                  Principal_Daily_Repayments_Approved__c, Interest_Daily_Repayment_Approved__c,
                                  Total_Daily_Repayment_Approved__c,Total_Daily_Repayment_Offer__c,
                                  Total_Amount_Repayable_Approved__c, Total_Weekly_Repayment_Approved__c,
                                  Total_Weekly_Amount_Repayable_Approved__c, Principal_Weekly_Repayments_Approved__c,
                                  Number_of_Weekly_Repayments_Approved__c, Interest_Weekly_Repayment_Approved__c,Interest_Amount_Approved__c,
                                  Program_Product_ASO__c,Approved_APR__c,VAT_Daily_Repayment_Approved__c from Credit_Assessment__c
                                  where Opportunity__c IN:setOppId];
        if(lstCredit_Assessment != null && !lstCredit_Assessment.isEmpty())
        {
            for(Credit_Assessment__c objCredit :  lstCredit_Assessment)
            {
                mapOppId_CreditAssessment.put(objCredit.Opportunity__c,objCredit);
            }
        }
        
        map<String,Id> mapCountry_QueueId = new map<String,Id>(); 
        list<QueueSobject> lstQ = [Select q.SobjectType, q.QueueId, q.Queue.Name, q.Id 
                                    From QueueSobject q where q.SobjectType = 'Operation__c'];
        
        if(lstQ != null && !lstQ.isEmpty())
        {
            for(QueueSobject objQ : lstQ)
            {
                if(objQ.Queue.Name.contains('UK'))
                {
                    mapCountry_QueueId.put('UK', objQ.QueueId);
                }
                if(objQ.Queue.Name.contains('Hong'))
                {
                    mapCountry_QueueId.put('Hong', objQ.QueueId);
                }
                if(objQ.Queue.Name.contains('Singapore'))
                {
                    mapCountry_QueueId.put('Singapore', objQ.QueueId);
                }
                if(objQ.Queue.Name.contains('Philippines'))
                {
                    mapCountry_QueueId.put('Philippines', objQ.QueueId);
                }
            }
        }
        
        try{
            for(Opportunity objOpp : mapNewOpportunity.values())
            {
                OppObjRef = objOpp;
                if(mapOldOpportunity.get(objOpp.Id).Contract_Signed__c == false
                && objOpp.Contract_Signed__c == true && (objOpp.StageName == '(Won) Signed' 
                || objOpp.StageName == 'Contract Stage' || objOpp.StageName == 'Accepted'))
                {
                    Operation__c objOperation = new Operation__c();
                    if(objOpp.RecType_Name__c.contains('UK'))
                    {
                        objOperation.OwnerId = mapCountry_QueueId.get('UK');
                    }
                    if(objOpp.RecType_Name__c.contains('Hong'))
                    {
                        objOperation.OwnerId = mapCountry_QueueId.get('Hong');
                    }
                    if(objOpp.RecType_Name__c.contains('Singapore'))
                    {
                        objOperation.OwnerId = mapCountry_QueueId.get('Singapore');
                    }
                    if(objOpp.RecType_Name__c.contains('Philippines'))
                    {
                        objOperation.OwnerId = mapCountry_QueueId.get('Philippines');
                    }
                    objOperation.Opportunity__c = objOpp.Id;
                    objOperation.CurrencyIsoCode = objOpp.CurrencyIsoCode;
                    //objOperation.Disbursal_Type__c = objOpp.Type;
                    objOperation.Status__c = 'Pre-Disbursement';
                    objOperation.Account__c = mapNewOpportunity.get(objOpp.Id).AccountId;
                    objOperation.Contract_Signed_And_Received__c = true;
                    objOperation.Contract_Signed_Received_Date__c = objOpp.Contract_Signed_Date__c;
                    objOperation.Frequency_of_Collection__c = mapOppId_CreditAssessment.get(objOpp.Id).FOC__c;
                    objOperation.Program_Product_ASO__c =  mapOppId_CreditAssessment.get(objOpp.Id).Program_Product_ASO__c;
                    if (mapOppId_CreditAssessment.get(objOpp.Id) != null) {
                        objOperation.VAT_Repayment__c = mapOppId_CreditAssessment.get(objOpp.Id).VAT_Daily_Repayment_Approved__c;
                        objOperation.APR__c = mapOppId_CreditAssessment.get(objOpp.Id).Approved_APR__c;
                        objOperation.Loan_Amount__c = mapOppId_CreditAssessment.get(objOpp.Id).Approved_Loan_Amount__c;
                        objOperation.Outstanding_Principal__c = mapOppId_CreditAssessment.get(objOpp.Id).Approved_Loan_Amount__c;
                        /*--- Change: Danail - 9 Mar 2016 - Required for LMS ---*/
                        objOperation.Loan_Outstanding_Principal__c = mapOppId_CreditAssessment.get(objOpp.Id).Approved_Loan_Amount__c;
                        objOperation.Loan_Outstanding_Interest__c = mapOppId_CreditAssessment.get(objOpp.Id).Interest_Amount_Approved__c; 
                        										//(mapOppId_CreditAssessment.get(objOpp.Id).FOC__c == 'Weekly'? 
                                                                //mapOppId_CreditAssessment.get(objOpp.Id).Total_Weekly_Amount_Repayable_Approved__c:
                                                                //mapOppId_CreditAssessment.get(objOpp.Id).Total_Amount_Repayable_Approved__c) - mapOppId_CreditAssessment.get(objOpp.Id).Approved_Loan_Amount__c;
                            // Added: Elisaveta - 4 Apr 2016
                        objOperation.Interest_Amount__c = mapOppId_CreditAssessment.get(objOpp.Id).Interest_Amount_Approved__c;
																//mapOppId_CreditAssessment.get(objOpp.Id).FOC__c == 'Weekly'? 
                                                                ///mapOppId_CreditAssessment.get(objOpp.Id).Total_Weekly_Amount_Repayable_Approved__c:
                                                                //mapOppId_CreditAssessment.get(objOpp.Id).Total_Amount_Repayable_Approved__c) - mapOppId_CreditAssessment.get(objOpp.Id).Approved_Loan_Amount__c;
                        objOperation.Actual_Interest_Amount__c = mapOppId_CreditAssessment.get(objOpp.Id).Interest_Amount_Approved__c;
                        										//(mapOppId_CreditAssessment.get(objOpp.Id).FOC__c == 'Weekly'? 
                                                                //mapOppId_CreditAssessment.get(objOpp.Id).Total_Weekly_Amount_Repayable_Approved__c:
                                                                //mapOppId_CreditAssessment.get(objOpp.Id).Total_Amount_Repayable_Approved__c) - mapOppId_CreditAssessment.get(objOpp.Id).Approved_Loan_Amount__c;
                        objOperation.Actual_Number_of_Repayments__c = mapOppId_CreditAssessment.get(objOpp.Id).FOC__c == 'Weekly'?
                                                                mapOppId_CreditAssessment.get(objOpp.Id).Number_of_Weekly_Repayments_Approved__c : 
                                                                mapOppId_CreditAssessment.get(objOpp.Id).Number_of_Repayments_Approved__c;
                        objOperation.Remaining_Number_of_Repayments__c = mapOppId_CreditAssessment.get(objOpp.Id).FOC__c == 'Weekly'?
                                                                mapOppId_CreditAssessment.get(objOpp.Id).Number_of_Weekly_Repayments_Approved__c : 
                                                                mapOppId_CreditAssessment.get(objOpp.Id).Number_of_Repayments_Approved__c;
                        /*--- End of change ---*/
                        objOperation.Loan_Term__c =  mapOppId_CreditAssessment.get(objOpp.Id).Approved_Loan_Term__c;
                        objOperation.Monthly_Interest__c  =  mapOppId_CreditAssessment.get(objOpp.Id).Monthly_Interest_Approved__c;
                        objOperation.Number_of_Repayments__c = mapOppId_CreditAssessment.get(objOpp.Id).FOC__c == 'Weekly'?
                                                                mapOppId_CreditAssessment.get(objOpp.Id).Number_of_Weekly_Repayments_Approved__c : 
                                                                mapOppId_CreditAssessment.get(objOpp.Id).Number_of_Repayments_Approved__c;
                        objOperation.Principal_Daily_Repayments__c = mapOppId_CreditAssessment.get(objOpp.Id).FOC__c == 'Weekly'?
                                                                    mapOppId_CreditAssessment.get(objOpp.Id).Principal_Weekly_Repayments_Approved__c:
                                                                    mapOppId_CreditAssessment.get(objOpp.Id).Principal_Daily_Repayments_Approved__c;
                        objOperation.Interest_Daily_Repayment__c = mapOppId_CreditAssessment.get(objOpp.Id).FOC__c == 'Weekly'? 
                                                                    mapOppId_CreditAssessment.get(objOpp.Id).Interest_Weekly_Repayment_Approved__c:
                                                                    mapOppId_CreditAssessment.get(objOpp.Id).Interest_Daily_Repayment_Approved__c;
                        objOperation.Total_Daily_Repayment__c = mapOppId_CreditAssessment.get(objOpp.Id).FOC__c == 'Weekly'? 
                                                                mapOppId_CreditAssessment.get(objOpp.Id).Total_Weekly_Repayment_Approved__c:
                                                                mapOppId_CreditAssessment.get(objOpp.Id).Total_Daily_Repayment_Approved__c;
                        objOperation.Total_Amount_Repayable__c = mapOppId_CreditAssessment.get(objOpp.Id).FOC__c == 'Weekly'? 
                                                                mapOppId_CreditAssessment.get(objOpp.Id).Total_Weekly_Amount_Repayable_Approved__c:
                                                                mapOppId_CreditAssessment.get(objOpp.Id).Total_Amount_Repayable_Approved__c;
                   }
                    
                    if(objOpp.RecType_Name__c.Contains('Hong'))
                        objOperation.RecordTypeId =  mapOfRecordTypeToIdOperation.get('Hong');
                    
                    else if(objOpp.RecType_Name__c.Contains('UK'))
                        objOperation.RecordTypeId =  mapOfRecordTypeToIdOperation.get('UK');
                    
                    else if(objOpp.RecType_Name__c.Contains('Singapore'))
                        objOperation.RecordTypeId =  mapOfRecordTypeToIdOperation.get('Singapore');
                    
                    else 
                        objOperation.RecordTypeId =  mapOfRecordTypeToIdOperation.get('Philippines');    
                    
                    lstOperationToInsert.add(objOperation);
                    
                    system.debug('lstOperationToInsert >>> '+lstOperationToInsert);
                }
                              
                /*---- calculate APR ---- */
                //done in After Update, because the formula fields based on Requested_Loan_Term are not accessible in Before Update
                Opportunity oldOpp = mapOldOpportunity.get(objOpp.Id);
                if (oldOpp.Program_Product_ASO__c != objOpp.Program_Product_ASO__c || oldOpp.Amount != objOpp.Amount)
                {   
                    double interestPremium = objOpp.Loan_Interest__c*objOpp.Loan_Term_In_Days__c / (365*100);                             
                    integer repaymentsNum = integer.valueof(objOpp.Loan_Frequency__c == 'Daily' ? objOpp.No_of_Repayments_Daily__c : objOpp.No_of_Repayments_Weekly__c);
                    integer daysIncrement = objOpp.Loan_Frequency__c == 'Daily' ? 1 : 7;
                    
                                        
                    if([select id, Grace_period__c from Loan_Management__c where Program_Product_ASO__c =:objOpp.Program_Product_ASO__c].size() == 0)
                        objOpp.addError('There is no defined Rules Engine for the selected Program - Product association');
                    else 
                    {
                        Opportunity newOpp = new Opportunity(Id = objOpp.Id);
                        integer gracePeriod = integer.valueof([select id,Grace_period__c from Loan_Management__c where Program_Product_ASO__c =:objOpp.Program_Product_ASO__c][0].Grace_period__c);
                        newOpp.APR__c = interestPremium*repaymentsNum*365*100/CRMS_Util.SumCollectionDays(gracePeriod, repaymentsNum, daysIncrement);
                        upsert newOpp;
                    }
                }
                /*---- end of calculate APR -----*/
            }
                
            if(!setCloneOpportunityId.isEmpty())
            {
                //cloneOpportunity(setCloneOpportunityId);
            }
            if(!lstDeleteOpportunityTeamMember.isEmpty())
            {
                delete lstDeleteOpportunityTeamMember;
                Statics.inFutureContext = false;
            }
            if(!mapOppId_IntroId.isEmpty())
            {
                CRMS_OpportunityTeamProcessor.createOpportunityTeamMember(setOppTeamMemberId);
            }
            if(!lstCreditAssessment.isEmpty())
            {
                system.debug ('lstCreditAssessment >>> '+lstCreditAssessment);  
                insert lstCreditAssessment;         
            }
            if(!lstOperationToInsert.isEmpty())
            {
                system.debug('Miro New Operation:'+ lstOperationToInsert);
                insert lstOperationToInsert;
            }
            if(!setLostOpportunityId.isEmpty())
            {
                withdrawCredit(setLostOpportunityId);
            }
            if(!setLostOpportunityId_Operations.isEmpty()){
                withdrawOperations(setLostOpportunityId_Operations);
            }           
        }catch(Exception ex){
            OppObjRef.addError(ex.getmessage() + string.valueOf(ex.getLineNumber()));
        }              
    } // end of afterUpdate
    
    /*
    public void cloneOpportunity(set<Id> setOpportunityId)
    {
        list<Opportunity> lstOpportunity = [select Id, OwnerId, Is_Cloned__c, CreatedDate, Application_ID2__c, 
                                            Amount, StageName, RecordTypeId, CloseDate, Name,
                                            Contract_End_Date__c from Opportunity where Id IN : setOpportunityId];
        
        list<RecordType> lstRecordType = [Select r.SobjectType, r.Id, r.DeveloperName 
                                          From RecordType r 
                                          where r.SobjectType = 'Opportunity' and r.DeveloperName = 'Renewal'];
        
        list<Opportunity> lstOpportunityToInsert = new list<Opportunity>();
        for(Opportunity objOpportunity : lstOpportunity)
        {
            Opportunity newOpp = objOpportunity.clone(false, true);
            newOpp.OwnerId = objOpportunity.OwnerId;
            newOpp.Application_ID2__c = null;
            newOpp.Name = objOpportunity.Name+' - Renewal';
            newOpp.Amount = objOpportunity.Amount;
            newOpp.StageName = 'Qualification';
            if(lstRecordType != null && !lstRecordType.isEmpty())
                newOpp.RecordTypeId = lstRecordType[0].Id; 
            newOpp.CloseDate = objOpportunity.Contract_End_Date__c.addYears(1);
            newOpp.Contract_End_Date__c = objOpportunity.Contract_End_Date__c.addYears(1);
            lstOpportunityToInsert.add(newOpp);
        }
        if(!lstOpportunityToInsert.isEmpty())
        {
            insert lstOpportunityToInsert;
        }
    }
    */
    
    //Method to withdraw Credit Assessment record if Opportunity is withdrawn
    //Set Credit Assessment status as Closed
    public void withdrawCredit(set<Id> setLostOpportunityId)
    {
        list<Credit_Assessment__c> lstCA = [Select Id, Status__c, Opportunity__c
                                           from Credit_Assessment__c
                                           where Opportunity__c IN: setLostOpportunityId
                                           and Status__c !=: 'Closed'];
                                           
        if(lstCA != null && !lstCA.isEmpty())
        {
            for(Credit_Assessment__c objCA : lstCA)
            {
                objCA.Status__c = 'Closed';
            }
            update lstCA;
        }
    } // end of withdrawCredit_And_Operations
    
    // Method to set Operations records as withdrawal
    public void withdrawOperations(set<Id> setLostOpportunityId){
        system.debug('Loan Withdraw >>> '+setLostOpportunityId);
        list<Operation__c> lstOperations = [Select Id, Status__c, Opportunity__c,
                                                Final_Decision__c,
                                                Final_Decision_Date__c,
                                                Disbursal_Reject_Reason__c
                                           from Operation__c
                                           where Opportunity__c IN: setLostOpportunityId
                                           and Status__c !=: LOAN_WITHDRAWN];
            
        if(lstOperations != null && !lstOperations.isEmpty()){
            for(Operation__c objOperation : lstOperations){
                //objOperation.Status__c = 'Rejected';
                //objOperation.Final_Decision__c = 'Rejected';
                //objOperation.Final_Decision_Date__c = Date.Today();
                //objOperation.Disbursal_Reject_Reason__c = LOAN_WITHDRAWN;
            }
            //update lstOperations;
        }
    } // end of method
    
    //Method to notify Credit Team when Requested Amount or term is updated by Loans Manager//
    public void notifyCreditTeam(set<Id> setOppIds, map<String,Id> mapOfRecordTypeToIdCreditAssessment)
    {
        List<Messaging.SingleEmailMessage> listEmail = new List<Messaging.SingleEmailMessage>();
        list<Task> lstTaskToInsert = new list<Task>(); 
        list<Credit_Assessment__c> lstCA = [Select c.Status__c, c.RecordTypeId, c.Final_Decision__c, 
                                            c.Final_Decision_Date__c, c.Approved_By__c, 
                                            c.Approval_Date__c, c.Opportunity__c, c.RecordType.Name, 
                                            c.OwnerId, c.Opportunity__r.Name, c.Opportunity__r.Amount, 
                                            c.Opportunity__r.Requested_Loan_Term__c, c.Revision__c 
                                            From Credit_Assessment__c c
                                            where c.Opportunity__c IN : setOppIds];
                                            
        if(lstCA != null && !lstCA.isEmpty())
        {
            for(Credit_Assessment__c objCA : lstCA)
            {
                if(objCA.RecordType.Name.contains('UK'))
                {
                    objCA.RecordTypeId = mapOfRecordTypeToIdCreditAssessment.get('UK');
                }
                else if(objCA.RecordType.Name.contains('Hong'))
                {
                    objCA.RecordTypeId = mapOfRecordTypeToIdCreditAssessment.get('Hong');
                }
                else if(objCA.RecordType.Name.contains('Philippines'))
                {
                    objCA.RecordTypeId = mapOfRecordTypeToIdCreditAssessment.get('Philippines');
                }
                else if(objCA.RecordType.Name.contains('Singapore'))
                {
                    objCA.RecordTypeId = mapOfRecordTypeToIdCreditAssessment.get('Singapore');
                }
                objCA.Status__c = 'Revised';
                objCA.Approval_Date__c = null;
                objCA.Approved_By__c = null;
                objCA.Final_Decision__c = null;
                objCA.Final_Decision_Date__c = null;
                objCA.Revision__c = objCA.Revision__c == null ? 1 : objCA.Revision__c + 1;
                if(string.valueOf(objCA.OwnerId).startswith('005'))
                {
                    Task objTask = new Task();
                    objTask.WhatId = objCA.Id;
                    objTask.Status = 'Not Started';
                    objTask.OwnerId = objCA.OwnerId;
                    objTask.Subject = 'Requested loan details have been updated';
                    objTask.Description = 'Please find the updated loan details: \n'+
                    '1. Loan Amount : '+objCA.Opportunity__r.Amount+'\n'+
                    '2. Loan Term : '+objCA.Opportunity__r.Requested_Loan_Term__c;
                    objTask.Priority = 'High';
                    objTask.ActivityDate = date.today();
                    lstTaskToInsert.add(objTask);
                }
            }
            update lstCA;
            if(!lstTaskToInsert.isEmpty())
            {
                insert lstTaskToInsert;
            }
        }
    }
    
    private void populateLeadID (list<Opportunity> lstOpportunity){
        List<Lead> lstLeads = new List<Lead>();
        Set<ID> oppIds = new Set<ID>();
        Map<ID, Opportunity> oppMap = new Map<ID, Opportunity>();
        
        for(Opportunity op: lstOpportunity){
            oppMap.put(op.id, op);
            oppIds.add(op.id);
        }
        lstLeads = [Select id,ConvertedOpportunityId from Lead where ConvertedOpportunityId in :oppIds and ConvertedOpportunityId != null];
        
        for(Lead l : lstLeads){
            oppMap.get(l.ConvertedOpportunityId).LeadID__c = l.Id;
        } 
    }
    public void setOperationStatusCanceled(Set<ID> setOppIDs){
        List<Operation__c> operationList = new List<Operation__c>();        
        operationList = [Select ID,Status__c From Operation__c Where Opportunity__c IN :setOppIDs];
        
        for (Operation__c tempOp : operationList){
            tempOp.Status__c = 'Cancelled';            
        }
        
        update operationList;
    }
} // end of class