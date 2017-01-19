/*
* Class for utilities for all SObjects
*
* Revision History: 

* Functionality :
*1. Add extra check in dymanic query for task (generateQuery function)
*
* Version       Author             Date           Description 
*  1.0           CRMS                             Initial Draft 
*
* Version       Author             Date           Description 
*  1.1           CRMS             13-07-2013     Functionality(1) 
*/

public without sharing class CRMS_SObjectUtility {

    //Method to generate query for all fields for Sync_Queue object
    public static String generateQueryForQueue() {
        String query = 'SELECT ';
        Map<String, Schema.SObjectField> mapQueueFields = Sync_Queue__c.getSObjectType().getDescribe().fields.getMap();
        for(String strField : mapQueueFields.keySet()) {
            Schema.DescribeFieldResult objField = mapQueueFields.get(strField).getDescribe();
            if(objField.isAccessible())
                query += objField.getName() + ', ';
        } //End of for loop for fields
        
        query = query.removeEnd(', ') + ' FROM Sync_Queue__c';
        return query;
    }
    
    //Method to get all the info for Sync_Queue records incl. parent fields
    public static String generateQueryForQueueParents() {
        String query = 'SELECT ';
        Map<String, Schema.SObjectField> mapQueueFields = Sync_Queue__c.getSObjectType().getDescribe().fields.getMap();
        for(String strField : mapQueueFields.keySet()) {
            Schema.DescribeFieldResult objField = mapQueueFields.get(strField).getDescribe();
            if(objField.isAccessible()) {
                if(objField.getRelationshipName() != null && objField.getReferenceTo()[0].getDescribe().fields.getMap().containsKey('DWH_Status__c')) {
                    query += objField.getRelationshipName() + '.DWH_Status__c, ';
                }
                query += objField.getName() + ', ';
            }
        } //End of for loop for fields
        query = query.removeEnd(', ') + ' FROM Sync_Queue__c';
        return query;
    }
/*
    //Method to generate dynamic query for Lead with all fields
    public static String generateQueryForLead() {
        String query = 'SELECT ';
        Map<String, Schema.SObjectField> mapLeadFields = Lead.getSObjectType().getDescribe().fields.getMap();
        for(String strField : mapLeadFields.keySet()) {
            Schema.DescribeFieldResult objField = mapLeadFields.get(strField).getDescribe();
            if(objField.isAccessible())
                query += objField.getName() + ', ';
        } //End of for loop for lead fields
        
        query += '(SELECT Lead__c, Action__c, Notes__c, Sync_Status__c FROM Sync_Queues__r) ';
        //query = query.removeEnd(', ');
        query += ' FROM Lead';
        
        return query;
    }
    */
    //Method used to create the dynamic query for object based on the id passed
    public static String generateQuery(ID objectID) {
        String query = '';
        Map<String, String> mapOfObjectNames = new Map<String, String>{
                                                                    'Lead' => 'Lead__c',
                                                                    'Account' => 'Account__c',
                                                                    'Case' => 'Case__c',
                                                                    'Contact' => 'Contact__c',
                                                                    'Credit_Assessment__c' => 'Credit_Assessment__c',
                                                                    'Operation__c' => 'Operation__c',
                                                                    'Opportunity' => 'Opportunity__c',
                                                                    'Guarantors__c' => 'ODG__c',
                                                                    'User' => 'User__c',
                                                                    'Campaign' => 'Campaign__c',
                                                                    'Task' => 'Task_Id__c',
                                                                    'Additional_Debt__c' => 'Additional_Debt__c',
                                                                    'Reward__c' => 'Reward__c',
                                                                    'Product2' => 'Product__c',
                                                                    'Program__c' => 'Program__c',
                                                                    'Program_Product_ASO__c' => 'Program_Product_ASO__c',
                                                                    'Loan_Management__c'   => 'Loan_Management__c',
                                                                    'Loan_Ledger__c'   => 'Loan_Ledger__c',
                                                                    'Loan_Management_Event__c' => 'Loan_Management_Event__c'
                                                                    };
        
        List<Account> lstAccount = new List<Account> ();
        if(Account.getSObjectType() == objectId.getSObjectType())
            lstAccount = [SELECT isPersonAccount 
                                FROM Account
                                WHERE Id =: objectId
                                LIMIT 1];
        
        String objectAPIName = objectID.getSObjectType().getDescribe().getName();
        if( objectAPIName != null ){
            query = 'SELECT ';
            Map<String, Schema.SObjectField> mapFieldNames = Id.valueOf(objectId).getSObjectType().getDescribe().fields.getMap();
            List<Schema.FieldSetMember> lstFields = Id.valueOf(objectID).getSObjectType().getDescribe().fieldsets.getMap().get(CRMS_Constants.mapObjectNameFieldSet.get(objectAPIName)).getFields();
            
            //If account is a person account then add every field from account to the query
            if(lstAccount != null && !lstAccount.isEmpty() && lstAccount.get(0).isPersonAccount) {
                for(String fieldName : mapFieldNames.keySet()) {
                    Schema.DescribeFieldResult objField = mapFieldNames.get(fieldName).getDescribe();
                    if(objField.isAccessible())
                        query += objField.getName() + ',';
                } //End of for loop for every field
            } //End of if account is a person account
            else {
                for(Schema.FieldSetMember strField : lstFields) {
                    if(mapFieldNames.get(strField.getFieldPath()) != null && mapFieldNames.get(strField.getFieldPath()).getDescribe().isAccessible())
                        query += strField.getFieldPath() + ',';
                    //if(objField.isAccessible() && objField.isUpdateable())
                      //  query += objField.getName() + ',';
                } //End of for loop for fields
            } //End of if record is not a person account
            query = query .substring(0,query.length()-1);
             if(objectID.getSObjectType() != Task.getSObjectType()) {
                query += ',(SELECT ' + mapOfObjectNames.get(objectAPIName); 
                query += ', Action__c, Notes__c, Sync_Status__c FROM Sync_Queues__r WHERE Sync_Status__c = \'Pending\') ';       
             }
            query += ' FROM ' + objectAPIName;
            
        }
        system.debug('query  ------>'+query );
        //System.debug(Logginglevel.ERROR, 'Miro Debug >_> ::' + Json.serializePretty(query));
        return query;
    }
    
    //Method to generate query from object name
    public static String generateQueryFromObjectName(String objectName) {
        String query = 'SELECT ';
        String objectApiName = CRMS_Constants.mapDataTypeObjectApiName.get(objectName);
        
        Map<String, Schema.SObjectType> mapDescribeAll = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> mapFieldNames = mapDescribeAll.get(objectApiName).getDescribe().fields.getMap();
        List<Schema.FieldSetMember> lstFields = mapDescribeAll.get(objectApiName).getDescribe().fieldsets.getMap().get(CRMS_Constants.mapObjectNameFieldSet.get(objectAPIName)).getFields();
        
        //If object is Account, add all the fields in the query
        if(objectName.equals('Account')) {
            for(String fieldName : mapFieldNames.keySet()) {
                Schema.DescribeFieldResult objField = mapFieldNames.get(fieldName).getDescribe();
                    if(objField.isAccessible())
                        query += objField.getName() + ', ';
            } //End of for all fields
        } //End of if object name is account
        else {
            for(Schema.FieldSetMember strField : lstFields) {
                if(mapFieldNames.get(strField.getFieldPath()) != null && mapFieldNames.get(strField.getFieldPath()).getDescribe().isAccessible())
                    query += strField.getFieldPath() + ', ';
            } //End of for loop for fields
            
            if(system.isBatch())
                query += 'DWH_Status__c, ';
        } //End of if object name is not account
        
        if(objectName.equals(CRMS_Constants.DWH_DATA_TYPE_TASK)) {
            return query.removeEnd(', ') + ' FROM Task';
        }
        
        query += '(SELECT ' + CRMS_Constants.mapDataTypeObjectName.get(objectName); 
        query += ', Action__c, Notes__c, Sync_Status__c FROM Sync_Queues__r WHERE Sync_Status__c = \'Pending\') ';
        query += ' FROM ' + CRMS_Constants.mapDataTypeObjectApiName.get(objectName);
        return query;
    }
    
    /*--- Danail 10/03/2016 ---- */
    /*--- Source: http://sfdc.arrowpointe.com/2011/03/28/cloning-records-in-apex/ ---*/
    
    public static String generateQueryForClone(ID objectId)
    {
        String fieldsToSelect = '';
                   
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = objectId.getSobjectType().getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
         
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCreateable()){ // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }
         
        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                fieldsToSelect += s + ',';
            }
            if (fieldsToSelect.endsWith(','))
            {
                fieldsToSelect = fieldsToSelect.substring(0, fieldsToSelect.lastIndexOf(','));
            }
             
        }
         
        return 'SELECT ' + fieldsToSelect + ' FROM ' + objectId.getSobjectType() + ' WHERE Id=\'' + objectId + '\'';
    }
    
    /*--------------------------*/
}