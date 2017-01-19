@isTest
public class Loan_LedgerTriggerHandler_Test {
   public static testmethod void insertTest(){
        
        CRMS_Util.generateEndpoints();
        
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        
        Loan_Ledger__c lr = new Loan_Ledger__c(Sign_Off_Date__c = Date.today(),Agreed_by_client__c = true,InputFromScreen__c = 'bounceBackSection');
        insert lr;
        lr.Status__c = 'In Progress';
        update lr;
        List<Loan_Ledger__c> result = [SELECT DWH_Status__c   FROM Loan_Ledger__c WHERE id = :lr.id];
         system.assertNotEquals(null, result[0].DWH_Status__c);
        
           
        Sync_Queue__c sq = new Sync_Queue__c ( Loan_Ledger__c = lr.Id,
                                                        DWH_Data_Type__c = CRMS_Constants.DWH_DATA_TYPE_LOAN_LEDGER,
                                                        Queued_Record_ID__c = lr.Id,
                                                        Sync_Status__c = CRMS_Constants.SYNC_QUEUE_STATUS_PENDING);
        insert sq; 
        lr.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
        update lr;
		  
        Loan_Ledger__c lr2 = new Loan_Ledger__c(Sign_Off_Date__c = Date.today(),Agreed_by_client__c = true, DWH_Import__c =  true);
        insert lr2;
        lr2.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
        update lr2;
        
        delete lr;
    }

}