/**
 * This class used to show set the flag for show sharepoint document.
 *
 * Initial Draft            Author           Date
 * Version 1.0              Yogesh          25/5/2015 

 *
 
 */
@isTest
public with sharing class CRMS_ShowOperationDocumentControllerTest {
    static testMethod  void testOperationDoc(){
        CRMS_Util.generateEndpoints();
        Operation__c objOperation = new CRMS_Util().initializeOperation(true);
        system.debug('objOperation------>'+objOperation);
        //CRMS_Util.generateODGList(1, true, objOperation.AccountId, objOpp.Id);
        
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        //Test.setCurrentPage(Page.CRMS_SendEmailInlinePage);
        Test.startTest();
        
        Apexpages.StandardController stdCon = new Apexpages.StandardController(objOperation);
        CRMS_ShowOperationDocumentController objController = new CRMS_ShowOperationDocumentController(stdCon);
        
        Test.stopTest();
        
        system.assertEquals(objController.isUK, true);
        
    }
}