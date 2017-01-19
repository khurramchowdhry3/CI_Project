@isTest
private class CRMS_DocuSignTriggerHandlerTest 
{
    static testMethod void testCRMS_DocuSignTriggerHandler() 
    {
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        //insert account
        account acc = new account(
        Name='test account');
        
        insert acc;
        
        list<RecordType> lstRec = [Select r.SobjectType, r.Id, r.DeveloperName 
        							From RecordType r 
        							where r.DeveloperName 
        							like 'Application%'
        							limit 1];
        							
        opportunity opp = new opportunity(
        Name = 'Test Opportunity',
        StageName = 'In Progress',
        CloseDate = system.today(),
        Average_Monthly_Card_Sales__c = 5000,
        Monthly_Rental__c = 50,
        Amount = 5000,
        RecordtypeId = lstRec[0].Id);
        //fill all the required field and make sure your data passes the validation rules.
        insert opp;
        
        dsfs__DocuSign_Status__c  dsfs = new dsfs__DocuSign_Status__c (
        dsfs__Completed_Date_Time__c = system.today(),
        dsfs__Opportunity__c = opp.id,
        dsfs__Envelope_Status__c = 'Send');
        insert dsfs;
        
        dsfs.dsfs__Envelope_Status__c = 'Completed';
        update dsfs;
        
        list<Opportunity> lstOpp = [Select o.Id, o.Signed_Application_Form_Received__c From Opportunity o where o.Id = : opp.Id];
        
        System.assertEquals(lstOpp[0].Signed_Application_Form_Received__c, true);
        
        list<RecordType> lstRec1 = [Select r.SobjectType, r.Id, r.DeveloperName 
        							From RecordType r 
        							where r.DeveloperName 
        							like 'Outcome%'
        							limit 1];
        
        opp.RecordtypeId = lstRec1[0].Id;
        update opp;
        
        dsfs__DocuSign_Status__c  dsfs1 = new dsfs__DocuSign_Status__c (
        dsfs__Completed_Date_Time__c = system.today(),
        dsfs__Opportunity__c = opp.id,
        dsfs__Envelope_Status__c = 'Send');
        insert dsfs1;
        
        dsfs1.dsfs__Envelope_Status__c = 'Completed';
        update dsfs1;
    }
}