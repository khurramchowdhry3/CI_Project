/**
    Handler class for the Docusign trigger
    Author: CRM Superstars
    Version: 1.0
*/
public class CRMS_DocuSignTriggerHandler 
{
    /**This method is used to update opportunity fields when docusign's status record is inseted and it's status 
    * is updated to "Completed".
    **/
    public void updateOpportunty(list<dsfs__DocuSign_Status__c> listDocusign)
    {
        List<Id> oppIds = new List<Id>();
        List<Id> lstOperationIds = new List<Id>();
        for(dsfs__DocuSign_Status__c dc: listDocusign)
        {
            if(dc.dsfs__Envelope_Status__c == 'Completed')
            { //Assuming the field on Docusign object is Status__c
                if(dc.dsfs__Opportunity__c != null)
                {
                    oppIds.add(dc.dsfs__Opportunity__c); //Assuming the relationship field on Docusign object is Opportunity__c
                }
            }
            if(dc.dsfs__Envelope_Status__c == 'Sent')
            {
                lstOperationIds .add(dc.Operation__c);
            }
        }
        List<Opportunity> oppList = [select StageName, Signed_Application_Form_Received__c, Contract_Signed__c,
                                    Contract_Signed_Date__c, Data_Protection_Act_Declaration__c,
                                    Credit_File_Disclosure__c, Recordtype.Name, Id, Name
                                    from Opportunity where id IN : oppIds];
        List<Opportunity> oppListnew = new List<Opportunity>();
        
        List<Operation__c> operationList = [select Id, Advanced_Notification_Sent_to_Customer__c 
                                            from Operation__c where id In : lstOperationIds ];
        List<Operation__c> lstOperationToUpdate = new List<Operation__c>();
        
        //integer flag = 0;
        if(oppList != null && !oppList.isEmpty())
        {
            /*
            for(Opportunity op : oppList)
            {
                // when 1st signed docusign document is received 
                flag = 0;
                if(op.Signed_Application_Form_Received__c == false)
                {
                    op.Signed_Application_Form_Received__c = true;
                    op.Signed_Application_Form_Received_Date__c = date.today();
                    op.Credit_File_Disclosure__c = true;
                    op.Data_Protection_Act_Declaration__c = true;
                    flag = 1;
                }
                // when 2nd signed docusign document is received 
                if(op.Contract_Signed__c == false & flag==0)
                {
                    op.Contract_Signed__c = true;
                    op.Contract_Signed_Date__c = date.today();
                }
                oppListnew.add(op);
            }
            */
            for(Opportunity op : oppList)
            {
                if(op.Recordtype.Name.contains('Application'))
                {
                    system.debug('***********Inside sign done********');
                    op.Signed_Application_Form_Received__c = true;
                    op.Signed_Application_Form_Received_Date__c = date.today();
                    op.Data_Protection_Act_Declaration__c = true;
                    op.Credit_File_Disclosure__c = true;
                }
                else if(op.Recordtype.Name.contains('Outcome'))
                {
                    op.Contract_Signed__c = true;
                    op.Contract_Signed_Date__c = date.today();
                }
                oppListnew.add(op);
            }
        }
        if(!operationList.isEmpty() && operationList != null)
        {
            for(Operation__c objOperation : operationList)
            {
                if(objOperation.Advanced_Notification_Sent_to_Customer__c == false)
                {
                    objOperation.Advanced_Notification_Sent_to_Customer__c  = true;
                    lstOperationToUpdate.add(objOperation);
                }
            }
        }
        if(!oppListnew.isEmpty() && oppListnew != null)
        {
            update oppListnew;
        }
        if(!lstOperationToUpdate.isEmpty() && lstOperationToUpdate != null)
        {
            update lstOperationToUpdate;
        }
    } // end of updateOpportunty method
} // end of class