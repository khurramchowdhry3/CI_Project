/**
	Test class for CRMS_SendEmailInlinePageController class
	Author: Saket Joshi
	Created Date: 27/03/2015		Version: 1.0
*/

@isTest
public with sharing class CRMS_SendEmailInlinePageControllerTest {

	@isTest
	static void testPageUK() {
		CRMS_Util.generateEndpoints();
		Opportunity objOpp = new CRMS_Util().initializeOpportunity(true);
		CRMS_Util.generateODGList(1, true, objOpp.AccountId, objOpp.Id);
		
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		Test.setCurrentPage(Page.CRMS_SendEmailInlinePage);
		Test.startTest();
		
		Apexpages.StandardController stdCon = new Apexpages.StandardController(objOpp);
		CRMS_SendEmailInlinePageController objController = new CRMS_SendEmailInlinePageController(stdCon);
		
		objController.sendMail();
		
		Test.stopTest();
		
		List<Opportunity> lstOpp = new List<Opportunity> { [SELECT Application_Email_Sent__c 
																FROM Opportunity 
																WHERE Id = :objOpp.Id 
																LIMIT 1] };
		system.assertEquals(false, lstOpp.get(0).Application_Email_Sent__c);
	}
	@isTest
	static void testPageHK() {
		CRMS_Util.generateEndpoints();
        String strRecordTypeId = [SELECT Id 
                                  FROM RecordType 
                                  WHERE SobjectType = 'Opportunity' and Name = 'Application Hong Kong'].Id;
		Opportunity objOpp = new CRMS_Util().initializeOpportunity(false);
        objOpp.RecordTypeId = strRecordTypeId;
        insert objOpp;
		CRMS_Util.generateODGList(1, true, objOpp.AccountId, objOpp.Id);
		
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		Test.setCurrentPage(Page.CRMS_SendEmailInlinePage);
		Test.startTest();
		
		Apexpages.StandardController stdCon = new Apexpages.StandardController(objOpp);
		CRMS_SendEmailInlinePageController objController = new CRMS_SendEmailInlinePageController(stdCon);
		
		objController.sendMail();
		
		Test.stopTest();
		
		List<Opportunity> lstOpp = new List<Opportunity> { [SELECT Application_Email_Sent__c 
																FROM Opportunity 
																WHERE Id = :objOpp.Id 
																LIMIT 1] };
		system.assertEquals(false, lstOpp.get(0).Application_Email_Sent__c);
	}
    
    @isTest
	static void testPagePH() {
		CRMS_Util.generateEndpoints();
        String strRecordTypeId = [SELECT Id 
                                  FROM RecordType 
                                  WHERE SobjectType = 'Opportunity' and Name = 'Application Philippines'].Id;
		Opportunity objOpp = new CRMS_Util().initializeOpportunity(false);
        objOpp.RecordTypeId = strRecordTypeId;
        insert objOpp;
		CRMS_Util.generateODGList(1, true, objOpp.AccountId, objOpp.Id);
		
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		Test.setCurrentPage(Page.CRMS_SendEmailInlinePage);
		Test.startTest();
		
		Apexpages.StandardController stdCon = new Apexpages.StandardController(objOpp);
		CRMS_SendEmailInlinePageController objController = new CRMS_SendEmailInlinePageController(stdCon);
		
		objController.sendMail();
		
		Test.stopTest();
		
		List<Opportunity> lstOpp = new List<Opportunity> { [SELECT Application_Email_Sent__c 
																FROM Opportunity 
																WHERE Id = :objOpp.Id 
																LIMIT 1] };
		system.assertEquals(false, lstOpp.get(0).Application_Email_Sent__c);
	}
}