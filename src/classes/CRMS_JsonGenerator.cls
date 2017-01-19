/**
    Class for generating JSON data to send to DWH
    Author: Saket Joshi
    Version: 1.0
*/

public without sharing class CRMS_JsonGenerator {

    //Method to generate JSON data for object
    public static String generateJson(List<SObject> lstObjects, String dmlOperation) {
        List<CRMS_CalloutObjects.Values> lstValues = new List<CRMS_CalloutObjects.Values> ();
        Boolean isPerson = false;
        system.debug('actualUsers ------>'+lstObjects);
        try{
        if(lstObjects != null && !lstObjects.isEmpty()) {
            String objectAPIName = lstObjects[0].getSObjectType().getDescribe().getName();
            system.debug(' objectAPIName :: '+objectAPIName);
            List<Schema.FieldSetMember> lstFields = lstObjects.get(0).getSObjectType().getDescribe().fieldsets.getMap().get(CRMS_Constants.mapObjectNameFieldSet.get(objectAPIName)).getFields();
            
            if(lstObjects[0].getSObjectType() == Account.getSObjectType() && ((Boolean)lstObjects[0].get('isPersonAccount')) == true) {
                //lstFields = Account.getSObjectType().getDescribe().fieldsets.getMap().get(CRMS_Constants.mapObjectNameFieldSet.get('PersonAccount')).getFields();
                isPerson = true;
            }
            
            //For every record in the list
            for(SObject objRecord : lstObjects) {
                if(objRecord.getSObjectType() == Credit_Assessment__c.getSObjectType()) {
                    String recordStatus = (String) objRecord.get('Status__c');
                    if(!recordStatus.equals('Approved') && !recordStatus.equals('Rejected')) {
                        objRecord.put('Approved_Loan_Amount__c', null);
                        objRecord.put('Approved_Loan_Term__c', null);
                    } //End of if status is Approved or Rejected
                } //End of if record is of Credit_Assessment__c type
                
                List<CRMS_CalloutObjects.FieldInformation> lstFieldArray = new List<CRMS_CalloutObjects.FieldInformation> ();
                Map<String, Schema.SObjectField> mapFieldNames = Id.valueOf(lstObjects[0].Id).getSObjectType().getDescribe().fields.getMap();
                system.debug(':: Fields Map :: '+mapFieldNames);
                //If account is a person account then add every field from account to the JSON
                if(isPerson) {
                    //For every field of every record
                    for(String fieldApiName : mapFieldNames.keySet()) {
                        String fieldLabel = mapFieldNames.get(fieldApiName).getDescribe().getName();
                                               
                        try {
                            String fieldValue = String.valueOf(objRecord.get(fieldApiName));
                            if(fieldValue == null)
                                fieldValue = '';
                        
                            lstFieldArray.add( new CRMS_CalloutObjects.FieldInformation( fieldLabel, fieldValue ) );
                        } //End of try block
                        catch(System.SObjectException ex) {
                            /* Catch the "SObject row was retrieved via SOQL without querying the requested field" error */
                        } //End of catch System.SObjectException
                    } //End of for loop for fields
                    
                    system.debug('<<< lstFieldArray >>> '+lstFieldArray);
                    
                } //End of if account is a person account
                else {
                    //For every field of every record
                    for(Schema.FieldSetMember strField : lstFields) {
                        String fieldApiName = strField.getFieldPath();
                                                
                        if(mapFieldNames.containsKey(fieldApiName) && mapFieldNames.get(fieldApiName) != null) {
                            String fieldLabel = mapFieldNames.get(fieldApiName).getDescribe().getName();
                             
                            try {
                                String fieldValue = String.valueOf(objRecord.get(fieldApiName));
                                if(fieldValue == null)
                                    fieldValue = '';
                            
                                lstFieldArray.add( new CRMS_CalloutObjects.FieldInformation( fieldLabel, fieldValue ) );
                            } //End of try block
                            catch(System.SObjectException ex) {
                                /* Catch the "SObject row was retrieved via SOQL without querying the requested field" error */
                            } //End of catch System.SObjectException
                        } //End of if describe map does not contain field from fieldset
                    } //End of for loop for fields
                } //End of else for account is a person account
                
                lstValues.add( new CRMS_CalloutObjects.Values( dmlOperation, lstFieldArray ) );
                
            } //End of for loop for records
        } //End of lstObjects is not null & empty
        }catch( Exception e){
            system.debug('------ Exception Is -------------'+e.getMessage());
        }
             
        return Json.serialize(lstValues);
    } //End of generateJson method

    //Method to generate Json data for delete records
    public static String generateJsonForDelete(List<String> lstRecordId) {
        List<CRMS_CalloutObjects.DeleteWrapper> lstDelete = new List<CRMS_CalloutObjects.DeleteWrapper>();
        for(String recordId : lstRecordId)
            lstDelete.add( new CRMS_CalloutObjects.DeleteWrapper(recordId));
        system.debug('Json.serialize(lstDelete) ----->'+Json.serialize(lstDelete));
        return Json.serialize(lstDelete);
    }
    
    /*
    //Method to generate JSON data for Leads records
    public static String generateJsonForLeads(List<Lead> lstLeads, String dmlOperation) {
        List<CRMS_CalloutObjects.Values> lstValues = new List<CRMS_CalloutObjects.Values> ();
        Map<String, Schema.SObjectField> mapFields = Schema.SObjectType.Lead.fields.getMap();
        
        //For every record in the list
        for(Lead objLead : lstLeads) {
            SObject sObjectLead = (SObject) objLead;
            List<CRMS_CalloutObjects.FieldInformation> lstFieldArray = new List<CRMS_CalloutObjects.FieldInformation> ();
            
            //For every field of every record
            for(String fieldApiName : mapFields.keySet()) {
                String fieldLabel = mapFields.get(fieldApiName).getDescribe().getLabel();
                
                try {
                    String fieldValue = String.valueOf(sObjectLead.get(fieldApiName));
                    if(fieldValue == null)
                        fieldValue = '';
                
                    lstFieldArray.add( new CRMS_CalloutObjects.FieldInformation( fieldLabel, fieldValue ) );
                }
                catch(System.SObjectException ex) {
                    
                }
            }
            
            lstValues.add( new CRMS_CalloutObjects.Values( dmlOperation, lstFieldArray ) );
        }
        
        return Json.serialize(lstValues);
    }*/

}