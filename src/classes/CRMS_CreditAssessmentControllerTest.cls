/*
	Test Class for CRMS_CreditAssessmentControllerTest
 */
@isTest
private class CRMS_CreditAssessmentControllerTest{
    static testMethod void myUnitTest(){
       Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());

       Account accountobj = new Account();
       accountobj.Name = 'Test';
       insert accountobj;

       Opportunity opprotunityobj = new Opportunity();
       opprotunityobj.AccountId = accountobj.Id;
       opprotunityobj.Name = 'Test1';
       opprotunityobj.CloseDate = Date.Today();
       opprotunityobj.Loan_Purpose__c = 'Other';
       opprotunityobj.StageName = 'In Progress';
       opprotunityobj.FOC__c = 'Daily';
       insert opprotunityobj;

       Credit_Assessment__c creditobj = new Credit_Assessment__c();
       creditobj.Opportunity__c = opprotunityobj.Id;
       creditobj.Approved_Loan_Amount__c = 1000;
       creditobj.Approved_Loan_Term__c = '06 (180 days)';
       creditobj.Monthly_Interest_Approved__c = 2.5 ;
       creditobj.Test__c = 1000;
       creditobj.Paid_In_M1__c = 5555;
       creditobj.Paid_In_M2__c = 3333;
       creditobj.Paid_In_M3__c = 1111;
       insert creditobj;

       ApexPages.StandardController controller = new ApexPages.StandardController(creditobj);
       CRMS_CreditAssessmentController objCreditAssessment = new CRMS_CreditAssessmentController(controller);
        
        List<CreditAssessmentIncomeDetails> resList = objCreditAssessment.getIncomeDetails();
        
        system.assertEquals(true, resList != null);
        
       //CreditAssessmentobj.creditAssessmentDetails(creditobj.Id);
    } // end of myUnitTest
} // end of class