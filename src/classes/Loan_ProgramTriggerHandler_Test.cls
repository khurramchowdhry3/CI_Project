@isTest
public class Loan_ProgramTriggerHandler_Test {
    public static testmethod void insertTest(){
        
        CRMS_Util.generateEndpoints();
        
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        
        Program__c prog = new Program__c();
        insert prog;
        
        List<Program__c> result = [SELECT DWH_Status__c   FROM Program__c WHERE id = :prog.id];
         system.assertNotEquals(null, result[0].DWH_Status__c);
        
           
        Sync_Queue__c sq = new Sync_Queue__c ( Program__c = prog.Id,
                                                        DWH_Data_Type__c = CRMS_Constants.DWH_DATA_TYPE_PROGRAM,
                                                        Queued_Record_ID__c = prog.Id,
                                                        Sync_Status__c = CRMS_Constants.SYNC_QUEUE_STATUS_PENDING);
        insert sq; 
        prog.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
        update prog;
		  
        Program__c prog2 = new Program__c(Country__c = 'SG',DWH_Import__c =  true);
        insert prog2;
        prog2.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
        update prog2;
        
        delete prog;
    }

}