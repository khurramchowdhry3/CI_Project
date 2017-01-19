@isTest
public class Loan_RewardTriggerHandler_Test {
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
        
        Reward__c rew = new Reward__c(Program_Product_ASO__c = ppas1.id);
        insert rew;
        List<Reward__c> result = [SELECT id,DWH_Status__c   FROM Reward__c WHERE id = :rew.id];
        
         system.assertNotEquals(null, result[0].DWH_Status__c);

        rew.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
        update rew;
		  
        Reward__c rew2 = new Reward__c(Program_Product_ASO__c = ppas2.id,DWH_Import__c =  true);
        insert rew2;
                
           
        Sync_Queue__c sq = new Sync_Queue__c ( Reward__c = rew2.Id,
                                                        DWH_Data_Type__c = CRMS_Constants.DWH_DATA_TYPE_REWARD,
                                                        Queued_Record_ID__c = rew2.Id,
                                                        Sync_Status__c = CRMS_Constants.SYNC_QUEUE_STATUS_PENDING);
        insert sq; 
        rew2.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
        update rew2;
        
        delete rew2;
    }

}