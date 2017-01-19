/**
 * This class used to change the owner of accounts as per the contract sign date.
 *
 * Initial Draft            Author           Date
 * Version 1.0              Yogesh          25/5/2015 

 *
 
 */
@isTest
public class CRMS_BatchAccountOwnerChangeTest {
    static testMethod  void testBatchForOwnerChange(){
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        CRMS_Util objUtil = new CRMS_Util();
        // Create opp
        Opportunity newopp = objUtil.initializeOpportunity(true);
        
        Test.startTest();
        Database.executeBatch(new CRMS_BatchAccountOwnerChange());
        Test.stopTest();
        Opportunity insertedOpp = [SELECT id,
                                          AccountId,
                                          Account.OwnerId,
                                          Account.Account_Manager__c
                                   FROM Opportunity
                                   WHERE id = : newopp.id];
        
        system.assertEquals(insertedOpp.Account.Account_Manager__c, insertedOpp.Account.OwnerId );
    }
}