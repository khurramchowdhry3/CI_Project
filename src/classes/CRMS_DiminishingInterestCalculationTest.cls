/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
public class CRMS_DiminishingInterestCalculationTest {

    static testMethod void myUnitTest() {
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());

        RecordType oppRecordType = [Select r.Id, r.SobjectType ,r.DeveloperName
                                    From RecordType r 
                                    where r.SobjectType = 'Operation__c' 
                                    and DeveloperName = 'Operation_Philippines'];
        list<Operation__c> lstOper = new list<Operation__c>(); 
        
        Operation__c objOperation = new Operation__c();
        objOperation.Loan_Disbursed_Date__c = date.today().addDays(-5);
        objOperation.Loan_Amount__c = 10000;
        objOperation.Outstanding_Principal__c = 10000;
        objOperation.RecordTypeId = oppRecordType.Id;
        objOperation.Loan_Term__c = '03 (090 days)';
        objOperation.Principal_Daily_Repayments__c = 200;
        objOperation.Repayments_Made__c = 0;
        lstOper.add(objOperation);

        Operation__c objOperation1 = new Operation__c();
        objOperation1.Loan_Disbursed_Date__c = date.today().addDays(-6);
        objOperation1.Loan_Amount__c = 15000;
        objOperation1.Outstanding_Principal__c = 15000;
        objOperation1.RecordTypeId = oppRecordType.Id;
        objOperation1.Loan_Term__c = '06 (180 days)';
        objOperation1.Principal_Daily_Repayments__c = 200;
        objOperation1.Repayments_Made__c = 0;
        lstOper.add(objOperation1);
        Test.startTest();
        insert lstOper;
        Database.executeBatch(new CRMS_DiminishingInterestCalculation());
        Test.stopTest();
    }
}