/**
@ Created Date : 31-3-2015. 
@ Description  : It is used to update the credit assessment record using REST Test. 
*/
@istest
public with sharing class CRMS_RESTCreditAssessment_Test {
    static testMethod void  testPostRestService(){
        CRMS_Util.generateEndpoints();
        String responseMsg = CRMS_RESTCreditAssessment.updateCreditAssessment();    
        system.assertEquals('[{"status_code":400,"salesforce_Credit_AssessmentID":null,"description":"The error has occurred.Attempt to de-reference a null object"}]', responseMsg);    
        // Get util data 
        CRMS_Util util = new CRMS_Util();
        Credit_Assessment__c creditAssessment = util.initializeCreditAssessment(false);
        // Insert CA
        insert creditAssessment;
        Credit_Assessment__c insertedCA = [select id, Application_ID__c from Credit_Assessment__c where id =: creditAssessment.Id];
        system.debug('**** CA values******'+insertedCA.Application_ID__c);
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        String JsonMsg = '[{"ApplicationNumber": "'+insertedCA.Application_ID__c+'","SalesforceCreaditAssessmentId": "'+creditAssessment.id+'","CreditScore": 12.4,"OfferAmount": 12.5,"OfferedPrincipalDailyRepaiment": 12.6,"OfferedPrincipalWeeklyRepayment": 12.7,"OffederInterestDailyRepayment": 12.8,"OfferedInterestWeeklyRepayment": 12.9,"OfferedTotalDailyRepayment": 13.2,"OfferedTotalWeeklyRepayment": 13.3,"OfferedTotalRepayment": 13.4,"LoanTermInMonths" : 12,"MonthlyInterest" : 12.2,"DailyRepaimentNum" :2}]';
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        Test.startTest();
   
         
   
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
         
        req.requestURI = '/services/apexrest/FieldCreditAssessment';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        CRMS_RESTCreditAssessment.restResponseLog responseValue = new CRMS_RESTCreditAssessment.restResponseLog();
        responseMsg = CRMS_RESTCreditAssessment.updateCreditAssessment();
   
        Test.stopTest();
   
   }
}