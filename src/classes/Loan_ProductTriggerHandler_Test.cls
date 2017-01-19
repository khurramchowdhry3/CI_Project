@isTest
public class Loan_ProductTriggerHandler_Test {
    public static testmethod void insertTest(){
        
        CRMS_Util.generateEndpoints();
        
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        
        Product2 prod = new Product2();
        insert prod;
        
        List<Product2> result = [SELECT DWH_Status__c   FROM Product2 WHERE id = :prod.id];
         system.assertNotEquals(null, result[0].DWH_Status__c);
        
           
        Sync_Queue__c sq = new Sync_Queue__c ( Product__c = prod.Id,
                                                        DWH_Data_Type__c = CRMS_Constants.DWH_DATA_TYPE_PRODUCT,
                                                        Queued_Record_ID__c = prod.Id,
                                                        Sync_Status__c = CRMS_Constants.SYNC_QUEUE_STATUS_PENDING);
        insert sq; 
        prod.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
        update prod;
		  
        Product2 prod2 = new Product2(Product_Type__c = 'Miro',DWH_Import__c =  true);
        insert prod2;
        prod2.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
        prod2.Description ='222';
        update prod2;
        
        delete prod;
    }
}