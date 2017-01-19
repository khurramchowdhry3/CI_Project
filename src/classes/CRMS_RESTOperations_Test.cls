/**
@ Created Date : 31-3-2015. 
@ Description  : It is used to update the operation record using REST Test. 
*/
@istest
public with sharing class CRMS_RESTOperations_Test {
    static testMethod void  testPostRestService(){
        CRMS_Util.generateEndpoints();
        String responseMsg = CRMS_RESTOperations.updateOperations();
        system.assertEquals('[{"status_code":400,"salesforce_operationID":null,"description":"The error has occurred.Attempt to de-reference a null object"}]', responseMsg);        
        // Get util data 
        CRMS_Util util = new CRMS_Util();
        Operation__c operationRec = util.initializeOperation(false);
        // Insert CA
        insert operationRec;
        //Operation__c insertedOperation = [select id from Operation__c where id =: operationRec.Id];
        //system.debug('**** CA values******'+insertedOperation);
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        String JsonMsg = '[{"LoanId": 100736001,"SalesforceOperationId": "'+operationRec.id+'","LoanDisbursed": 12.4,"LoanDisbursedDate": "2014-11-19","LoanOutstandingPrincipal": 12.3,"LoanOutstandingInterest":13.3,"OutstandingFees":24.4,"FrequencyCollection":"Test","DayOfWeekToBeDebited0":"Test","FinalCollectionDate": "2014-11-19","FinalAmountToBeDebited":"Test"}]';
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
         
        req.requestURI = '/services/apexrest/FieldOperations';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        CRMS_RESTOperations.restResponseLog responseValue = new CRMS_RESTOperations.restResponseLog();
        responseMsg = CRMS_RESTOperations.updateOperations();
   
        Test.stopTest();
    }
}