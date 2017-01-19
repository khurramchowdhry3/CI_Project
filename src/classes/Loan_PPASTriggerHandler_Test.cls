@isTest
public class Loan_PPASTriggerHandler_Test {
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
        
        List<Program_Product_ASO__c> result = [SELECT DWH_Status__c   FROM Program_Product_ASO__c WHERE id = :ppas1.id];
         system.assertNotEquals(null, result[0].DWH_Status__c);
        
           
        Sync_Queue__c sq = new Sync_Queue__c ( Program_Product_ASO__c = ppas1.Id,
                                                        DWH_Data_Type__c = CRMS_Constants.DWH_DATA_TYPE_PPAS,
                                                        Queued_Record_ID__c = ppas1.Id,
                                                        Sync_Status__c = CRMS_Constants.SYNC_QUEUE_STATUS_PENDING);
        insert sq; 
        ppas1.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
        update ppas1;
        
        Program_Product_ASO__c ppas2 = new Program_Product_ASO__c(Program__c = prog.id, Product__c = prod2.Id, DWH_Import__c =  true);
        insert ppas2;
        ppas2.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
        update ppas2;
        
        delete ppas1;
    }

}