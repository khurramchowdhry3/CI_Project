/*
*This Batch is supposed to run at midnight local time and approves any unprocessed Bounce Backs, so that they will be processed by DWH with default parameters
*
*/

global class Loan_BounceBackBatch implements Database.Batchable<SObject>{
    
    public static final Date UK_DATE = Date.valueOf(System.now().format('yyyy-MM-dd', 'GMT+00:00'));
    public static final Date PH_SG_HK_DATE = Date.valueOf(System.now().format('yyyy-MM-dd', 'GMT+08:00'));
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([Select Id, Event_Process_Method__c, IsApproved__c, Approval_Date__c, ApprovedBy__c, Operation__r.Program_Product_ASO__c
                                         From Loan_Management_Event__c 
                                         Where Event_Type__c = 'Bounce Back' 
                                         	And IsApproved__c = false
                                         	And DAY_ONLY(CreatedDate) <: Date.today()
                                        ]);
    }

    global void execute(Database.BatchableContext BC, List<Loan_Management_Event__c> lstLMEvents) {
              
        if(!lstLMEvents.isEmpty())
        {
            for (Loan_Management_Event__c lme : lstLMEvents)
            {
                
                List<Loan_Management__c> rulesList = [Select Id, Repayment_method__c From Loan_Management__c Where Program_Product_ASO__c =: lme.Operation__r.Program_Product_ASO__c];
                lme.Event_Process_Method__c = rulesList.size() == 1 ? rulesList[0].Repayment_method__c : null;
                lme.IsApproved__c = true;
                lme.Approval_Date__c = Datetime.now();
                lme.ApprovedBy__c = UserInfo.getUserId();
            }
            
            update lstLMEvents;
        }
        
    }
    
    public void finish(Database.BatchableContext info) 
    {
       
    }
}