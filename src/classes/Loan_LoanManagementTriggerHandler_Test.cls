@isTest
public class Loan_LoanManagementTriggerHandler_Test {
    public static testmethod void insertTest(){
        
        CRMS_Util.generateEndpoints();
        
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        
        Program__c prog = new Program__c(Country__c = 'UK1');
        insert prog;

        Product2 prod = new Product2(Country__c = 'UK1');
        insert prod;    
        Product2 prod2 = new Product2(Country__c = 'UK2');
        insert prod2;        
        
        Program_Product_ASO__c ppas1 = new Program_Product_ASO__c(Program__c = prog.id, Product__c = prod.Id);
        insert ppas1;
        
        Program_Product_ASO__c ppas2 = new Program_Product_ASO__c(Program__c = prog.id, Product__c = prod2.Id);
        insert ppas2;
        
        Loan_Management__c lm = new Loan_Management__c(Program_Product_ASO__c = ppas1.id);
        insert lm;
        List<Loan_Management__c> result = [SELECT id,DWH_Status__c   FROM Loan_Management__c WHERE id = :lm.id];
        
         system.assertNotEquals(null, result[0].DWH_Status__c);

        lm.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
        update lm;
		  
        Loan_Management__c lm2 = new Loan_Management__c(Program_Product_ASO__c = ppas2.id,DWH_Import__c =  true);
        insert lm2;
                
           
        Sync_Queue__c sq = new Sync_Queue__c ( Loan_Management__c = lm2.Id,
                                                        DWH_Data_Type__c = CRMS_Constants.DWH_DATA_TYPE_LOAN_MANAGEMENT,
                                                        Queued_Record_ID__c = lm2.Id,
                                                        Sync_Status__c = CRMS_Constants.SYNC_QUEUE_STATUS_PENDING);
        insert sq; 
        lm2.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
        update lm2;
        
        delete lm2;
    }

}