/**
@ Created Date : 31-3-2015. 
@ Description  : It is used to insert the cases record using REST. 
*/
@istest
public with sharing class CRMS_RESTCases_Test {
    static testMethod void  testPostRestService(){
        CRMS_Util.generateEndpoints();
        String responseMsg = CRMS_RESTCases.insertCases();   
        system.assertEquals('[{"status_code":400,"salesforce_CaseID":null,"description":"The error has occurred.Attempt to de-reference a null object"}]', responseMsg);
        // Get util data 
        CRMS_Util util = new CRMS_Util();
        Operation__c operationRec = util.initializeOperation(false);
        // Insert CA
        insert operationRec;
        Operation__c insertedOperation = [select id, Account__c from Operation__c where id =: operationRec.Id];
        
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        String JsonMsg = '[{"SalesforceOperationId": "'+insertedOperation.id+'","SalesforceClientId": "'+insertedOperation.Account__c+'","CurrencyIsoCode": "EUR"}]';
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
         
        req.requestURI = '/services/apexrest/FieldCases';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        CRMS_RESTCases.restResponseLog responseValue = new CRMS_RESTCases.restResponseLog();
        responseMsg = CRMS_RESTCases.insertCases();
        system.debug('======== Response IS '+ responseMsg);
   		
        Test.stopTest();
    }
}