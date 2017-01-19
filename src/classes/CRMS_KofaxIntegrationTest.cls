@isTest
public with sharing class CRMS_KofaxIntegrationTest {
    static testMethod void testCustomKofaxSOAP() {
        
        //CRMS_Util objUtil = new CRMS_Util();
		CRMS_Util.generateEndpoints();
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        // False test.
        string responseMsg = CRMS_KofaxOpportunityUpdate.updateOpportunity('');
        // Wrong Input data
        responseMsg = CRMS_KofaxOpportunityUpdate.updateOpportunity('[{"Application_Id":"200542001","Required_Documents_Received":true,"creditCheck":false,"document_Names":"Merchant Statement,Business Bank statement,Proof of identity"}]');
        // Get util data 
        CRMS_Util util = new CRMS_Util();
        Opportunity opp = util.initializeOpportunity(false);
        // Insert opportunity
        insert opp;
        Opportunity updatedOpp = [SELECT Application_ID2__c, Required_Documents_Received__c, Documents_Processed__c
                                  FROM Opportunity
                                  Where id = : opp.id];
        
        // Correct data
        responseMsg = CRMS_KofaxOpportunityUpdate.updateOpportunity('[{"Application_Id":'+updatedOpp.Application_ID2__c+',"Required_Documents_Received":true,"creditCheck":false,"document_Names":"Merchant Statement,Business Bank statement,Proof of identity,Proof of address"}]');
        updatedOpp = [SELECT Application_ID2__c, Required_Documents_Received__c, Documents_Processed__c
                      FROM Opportunity
                      Where id = : opp.id];
        system.debug('==== '+updatedOpp);
        system.assertEquals(true, updatedOpp.Required_Documents_Received__c);
        system.assertEquals(false, updatedOpp.Documents_Processed__c);
        // Wrong application Id
        responseMsg = CRMS_KofaxOpportunityUpdate.updateOpportunity('[{"Application_Id":"200542","Required_Documents_Received":true,"creditCheck":false,"document_Names":"Merchant Statement,Business Bank statement"}]');
    }
}