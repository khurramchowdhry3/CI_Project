/**
    Trigger on dsfs__DocuSign_Status__c to fetch Docusign Envelope and update Opportunity records appropriately
    Author: Saket Joshi
    Created Date: 31/03/2015    Version: 1.0
*/
trigger CRMS_DocuSignSignedTrigger on dsfs__DocuSign_Status__c (before insert, before update) 
{
    CRMS_DocuSignTriggerHandler objClass = new CRMS_DocuSignTriggerHandler();
    objClass.updateOpportunty(trigger.new);
}