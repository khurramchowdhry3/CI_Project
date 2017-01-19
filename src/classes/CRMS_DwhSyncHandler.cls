/*
* Class for methods related to DWH synchronization
*
* Revision History: 

* Functionality :
*1. Remove extra check for task (doSynchronizationFromFuturey function)
*2. Add logic to check Sync queue field (Notes__c) size

* Version       Author             Date           Description 
*  1.0           CRMS                             Initial Draft 
*
* Version       Author             Date           Description 
*  1.1           CRMS             13-07-2013     Functionality(1) 

* Version       Author             Date           Description 
*  1.2           CRMS             17-07-2013     Functionality(2) 
*/

public without sharing class CRMS_DwhSyncHandler {
    // It is used to store the length of the field
    public static Integer fieldLength = (Schema.SObjectType.Sync_Queue__c.fields.Notes__c.getLength()) - 15;
    //Method to perform callout to DWH for leads
    public static CRMS_HttpResponseWrapper doCallout(List<SObject> lstObjects, String dmlOperation) {
        
        String calloutType = CRMS_Util.getCalloutMethodFromOperation(dmlOperation);
        String endpointValue = CRMS_Util.getEndpointValueForObject(lstObjects.get(0).Id);
        system.debug('endpointValue:'+endpointValue);
        CRMS_HttpRequestParams objRequestParams = new CRMS_HttpRequestParams(Label.DWH_Endpoint + endpointValue, calloutType);
        
        try{
        objRequestParams.setTimeoutValue(CRMS_Constants.CALLOUT_DEFAULT_TIMEOUT);
        //objRequestParams.addParamToHeaders(CRMS_Constants.CONTENT_TYPE, CRMS_Constants.CONTENT_TYPE_JSON);
        objRequestParams.addParamToHeaders(CRMS_Constants.REQUEST_HEADER_DATE, CRMS_Util.generateDateForAuth());
        objRequestParams.addParamToHeaders(CRMS_Constants.REQUEST_HEADER_AUTH, CRMS_Util.generateAuthKey(calloutType, endpointValue));
        objRequestParams.setRequestBody(CRMS_JsonGenerator.generateJson(lstObjects, dmlOperation));
        }catch( Exception e){
            system.debug('------ Exception Is -------------'+e.getMessage());
        }
        
        system.debug(' objRequestParams :: '+ objRequestParams);
        return CRMS_HttpCalloutUtility.doCallout(objRequestParams);
    }
    
    //Method to perform callout to DWH for delete operation
    public static CRMS_HttpResponseWrapper doCalloutForDelete(List<String> lstRecordsToDelete) {
        /** REMEMBER TO REMOVE THIS COMMENTS TO ENABLE WEBSERVICE CALLOUTS ON OPERATIONS    **/
       
        String endpointValue = CRMS_Util.getDeleteEndpoint(Id.valueOf(lstRecordsToDelete[0]));
        CRMS_HttpRequestParams objRequestParams = new CRMS_HttpRequestParams(Label.DWH_Endpoint + endpointValue, CRMS_Constants.CALLOUT_METHOD_DELETE);
        try{
        objRequestParams.setTimeoutValue(CRMS_Constants.CALLOUT_DEFAULT_TIMEOUT);
        objRequestParams.addParamToHeaders(CRMS_Constants.CONTENT_TYPE, CRMS_Constants.CONTENT_TYPE_JSON);
        objRequestParams.addParamToHeaders(CRMS_Constants.REQUEST_HEADER_DATE, CRMS_Util.generateDateForAuth());
        objRequestParams.addParamToHeaders(CRMS_Constants.REQUEST_HEADER_AUTH, CRMS_Util.generateAuthKey(CRMS_Constants.CALLOUT_METHOD_DELETE, endpointValue));
       
        objRequestParams.setRequestBody(CRMS_JsonGenerator.generateJsonForDelete(lstRecordsToDelete));
        }catch( Exception e){
            system.debug('------ Exception Is -------------'+e.getMessage());
        }
        return CRMS_HttpCalloutUtility.doCallout(objRequestParams);
        //return new CRMS_HttpResponseWrapper();
    }
    
    //Future method to perform the callout to DWH
    @future (callout=true)
    public static void doSynchronizationFromFuture(List<Id> lstObjectId, String dmlOperation) {
        system.debug('***********lstObject' + lstObjectId);
        try{
        if(lstObjectId != null && !lstObjectId.isEmpty()) {
            List<SObject> lstObjects = new List<SObject> ();
            //if(lstObjectId[0].getSObjectType() == Task.getSObjectType()) {
                //lstObjects = [SELECT DWH_Status__c, DWH_Last_Sync__c FROM Task WHERE Id IN :lstObjectId];
            //} //End of if object is task
            //else{
                String query = CRMS_SObjectUtility.generateQuery(lstObjectId[0]) + ' WHERE Id IN :lstObjectId';
                system.debug('Query to SObject for Data :: '+query);
                
                lstObjects = Database.query(query);
                system.debug('lstObjects------->'+lstObjects);
            //} //End of if object is not task
            if(lstObjects != null && !lstObjects.isEmpty()) {
                
                /** REMEMBER TO REMOVE THIS COMMENTS TO ENABLE WEBSERVICE CALLOUTS ON OPERATIONS    **/
                
                CRMS_HttpResponseWrapper objResponseWrapper = doCallout(lstObjects, dmlOperation);
                               
                system.debug('Miro - >> objResponseWrapper' + objResponseWrapper);
                updateRecordsFromCalloutResponse(objResponseWrapper, lstObjects, dmlOperation);
            } //End of if lstObjects is not empty
        } //End of if lstObjectId is not null or empty
        }catch( Exception e){
            system.debug('------ Exception Is -------------'+e.getMessage()+
                         '/n LN:' + e.getLineNumber()+'/n Stack:'+e.getStackTraceString()+'/n Cause:' + e.getCause());
        }
    }
    
    //Method to generate Sync Queue object from record given
    private static Sync_Queue__c generateSyncQueueFromObject(Id objectToAttach, String strNote, String action) {
        
        Sync_Queue__c objQueue = new Sync_Queue__c(Notes__c = strNote,
                                                Sync_Status__c = CRMS_Constants.SYNC_QUEUE_STATUS_PENDING,
                                                Action__c = action);
        try{
           // system.debug('Miro - Object type: ' + objectToAttach.getSObjectType());
        if(objectToAttach.getSObjectType() == Account.getSObjectType())
            objQueue.Account__c = objectToAttach;
        else if(objectToAttach.getSObjectType() == Case.getSObjectType())
            objQueue.Case__c = objectToAttach;
        else if(objectToAttach.getSObjectType() == Contact.getSObjectType())
            objQueue.Contact__c = objectToAttach;
        else if(objectToAttach.getSObjectType() == Credit_Assessment__c.getSObjectType())
            objQueue.Credit_Assessment__c = objectToAttach;
        else if(objectToAttach.getSObjectType() == Lead.getSObjectType())
            objQueue.Lead__c = objectToAttach;
        else if(objectToAttach.getSObjectType() == Guarantors__c.getSObjectType())
            objQueue.ODG__c = objectToAttach;
        else if(objectToAttach.getSObjectType() == Operation__c.getSObjectType())
            objQueue.Operation__c = objectToAttach;
        else if(objectToAttach.getSObjectType() == Opportunity.getSObjectType())
            objQueue.Opportunity__c = objectToAttach;
        else if(objectToAttach.getSObjectType() == Task.getSObjectType())
            objQueue.Task_Id__c = objectToAttach;
        else if(objectToAttach.getSObjectType() == Campaign.getSObjectType())
            objQueue.Campaign__c = objectToAttach;
        else if(objectToAttach.getSObjectType() == Additional_Debt__c.getSObjectType())
            objQueue.Additional_Debt__c = objectToAttach;
        else if(objectToAttach.getSObjectType() == Product2.getSObjectType())
            objQueue.Product__c = objectToAttach;
        else if(objectToAttach.getSObjectType() == Program__c.getSObjectType())
            objQueue.Program__c = objectToAttach;
        else if(objectToAttach.getSObjectType() == Program_Product_ASO__c.getSObjectType())
            objQueue.Program_Product_ASO__c = objectToAttach;
        else if(objectToAttach.getSObjectType() == Reward__c.getSObjectType())
            objQueue.Reward__c = objectToAttach;
        else if(objectToAttach.getSObjectType() == Loan_Management__c.getSObjectType())
            objQueue.Loan_Management__c = objectToAttach;
        else if(objectToAttach.getSObjectType() == Loan_Ledger__c.getSObjectType())
            objQueue.Loan_Ledger__c = objectToAttach;
        else
            objQueue.User__c = objectToAttach;
        
        objQueue.DWH_Data_Type__c = CRMS_Constants.mapApiNameDataType.get(objectToAttach.getSObjectType().getDescribe().getName());
        objQueue.Queued_Record_ID__c = String.valueOf(objectToAttach);
        }catch( Exception e){
            system.debug('------ Exception Is -------------'+e.getMessage());
        }
        return objQueue;
    }
    
    //Method to fetch only DWH fields from object
    private static String getQueryForDWHFields(Id recordId) {
        String objectName = recordId.getSObjectType().getDescribe().getName();
        
        return 'SELECT DWH_Status__c, DWH_Last_Sync__c, (SELECT DWH_Data_Type__c, Notes__c, Action__c, Sync_Status__c FROM Sync_Queues__r WHERE Sync_Status__c = \'Pending\') FROM ' + objectName;
    }
    
    //Method to perform operations based on values from callout results
    private static void updateRecordsFromCalloutResponse(CRMS_HttpResponseWrapper objResponse, List<SObject> lstCalloutObjects, String dmlOperation) {
        Map<Id, Sync_Queue__c> mapQueueRecordsForObjects = new Map<Id, Sync_Queue__c> ();
        Map<Id, CRMS_HttpResponseWrapper.RecordResultWrapper> mapRecordIdWithResult = new Map<Id, CRMS_HttpResponseWrapper.RecordResultWrapper> ();
        Set<Id> setRecordId = new Set<Id> ();
        List<Sync_Queue__c> lstQueueRecordsToUpdate = new List<Sync_Queue__c> ();
        List<SObject> lstObjectsToUpdate = new List<SObject> ();
        
        String notesData = '';
        try{
        if(lstCalloutObjects[0].Id.getSObjectType() == Task.getSObjectType()) {
            List<Sync_Queue__c> lstQueueForTasks = new List<Sync_Queue__c> ();
            Set<Id> setTasksId = new Set<Id> ();
            for(SObject obj : lstCalloutObjects)
                setTasksId.add(obj.Id);
            lstQueueForTasks = [SELECT Task_Id__c,
                                       Sync_Status__c,
                                       Notes__c,
                                       Id 
                                    FROM Sync_Queue__c
                                    WHERE Sync_Status__c = 'Pending'
                                    AND Task_Id__c IN :setTasksId];
            
            if(lstQueueForTasks != null && !lstQueueForTasks.isEmpty()) {
                for(Sync_Queue__c objQueue : lstQueueForTasks) {
                    system.debug('Sync_Queues__r-------->'+objQueue);
                    mapQueueRecordsForObjects.put(Id.valueOf(objQueue.Task_Id__c), objQueue);
                } //End of for loop for every queue in lstQueueForTasks
            } //End of if queue list not empty
            lstObjectsToUpdate = [SELECT DWH_Status__c, DWH_Last_Sync__c FROM Task WHERE Id IN :setTasksId];
        } //End of of object is task
        else {
            //Generate list of sync queue records for callout records
            for(SObject sObj : lstCalloutObjects) {
                setRecordId.add(sObj.Id);
                system.debug('Sync_Queues__r-------->'+sObj.getSObjects('Sync_Queues__r'));
            
            } //End of for loop for every callout object record
            String query = getQueryForDWHFields(lstCalloutObjects[0].Id) + ' WHERE Id IN :setRecordId';
            
            List<SObject> lstObjectWithQueue = new List<SObject> ();
            String queryForQueue = CRMS_SObjectUtility.generateQuery(lstCalloutObjects[0].Id) + ' WHERE Id IN :setRecordId';
            lstObjectWithQueue = Database.query(queryForQueue);
            
            for(SObject sObj : lstObjectWithQueue) {
                //system.debug('((List<Sync_Queue__c>)sObj.getSObjects('Sync_Queues__r'))[0]-------->'+sObj.getSObjects('Sync_Queues__r'));
                if(sObj.getSObjects('Sync_Queues__r') != null && !((List<Sync_Queue__c>)sObj.getSObjects('Sync_Queues__r')).isEmpty())
                    mapQueueRecordsForObjects.put(sObj.Id, ((List<Sync_Queue__c>)sObj.getSObjects('Sync_Queues__r'))[0]);
            } //End of for loop for every callout object record
            
            System.debug('Query------>'+query);
            lstObjectsToUpdate = Database.query(query);
            System.debug('lstObjectsToUpdate------>'+lstObjectsToUpdate);
        } //End of if object is not task
        
        String objectName = lstCalloutObjects[0].Id.getSObjectType().getDescribe().getName();
        
        //Check main response from callout
        if(objResponse != null && objResponse.getResults() != null && !objResponse.getResults().isEmpty()) {
            for(CRMS_HttpResponseWrapper.RecordResultWrapper objResultWrapper : objResponse.getResults()) {
                if(objResultWrapper.getSalesForceId() != null && objResultWrapper.getSalesForceId() != '')
                    mapRecordIdWithResult.put(Id.valueOf(objResultWrapper.getSalesForceId()), objResultWrapper);
            } //End of for loop for create map of record id with result wrapper
            
            /* Set DWH Status "SYNCED" and Last Sync to "CURRENT DATETIME" */
            for(SObject sObj : lstObjectsToUpdate) {
                //If the response for THIS record is not OK
                if(mapRecordIdWithResult.get(sObj.Id).getSuccess() != true)
                    sObj.put('DWH_Status__c', CRMS_Constants.DWH_STATUS_QUEUED);
                else {
                    sObj.put('DWH_Status__c', CRMS_Constants.DWH_STATUS_SYNCED);
                    sObj.put('DWH_Last_Sync__c', Datetime.now());
                } //End of if response for THIS record is OK
                
                system.debug('Miro sObj:'+sObj);
                /*  Sync Queue records for this record having status = "PENDING"    */
                if(mapQueueRecordsForObjects.containsKey(sObj.Id) && mapQueueRecordsForObjects.get(sObj.Id).Sync_Status__c.equals(CRMS_Constants.SYNC_QUEUE_STATUS_PENDING)) {
                    //Records found
                    if(((String)sObj.get('DWH_Status__c')).equals(CRMS_Constants.DWH_STATUS_SYNCED)) {
                        mapQueueRecordsForObjects.get(sObj.Id).Sync_Status__c = CRMS_Constants.SYNC_STATUS_STALE;
                        if(mapQueueRecordsForObjects.get(sObj.Id).Notes__c == null)
                            mapQueueRecordsForObjects.get(sObj.Id).Notes__c = '';
                            
                        notesData = mapQueueRecordsForObjects.get(sObj.Id).Notes__c;
                        notesData += '\n' + Datetime.now().format() + CRMS_Constants.DWH_CREATED_BY_TRIGGER;
                    
                        mapQueueRecordsForObjects.get(sObj.Id).Notes__c = addValue(notesData);
                        //mapQueueRecordsForObjects.get(sObj.Id).Notes__c += '\n' + Datetime.now().format() + CRMS_Constants.DWH_CREATED_BY_TRIGGER;
                        mapQueueRecordsForObjects.get(sObj.Id).Action__c = dmlOperation;
                        mapQueueRecordsForObjects.get(sObj.Id).DWH_Data_Type__c = CRMS_Constants.mapApiNameDataType.get(objectName);
                    } //End of if record dwh status equals "synced"
                    else if(((String)sObj.get('DWH_Status__c')).equals(CRMS_Constants.DWH_STATUS_QUEUED)) {
                        if(mapRecordIdWithResult.containsKey(sObj.Id)) {
                            if(mapQueueRecordsForObjects.get(sObj.Id).Notes__c == null)
                                mapQueueRecordsForObjects.get(sObj.Id).Notes__c = '';
                            notesData = mapQueueRecordsForObjects.get(sObj.Id).Notes__c;
                            notesData += '\n' + Datetime.now().format() + CRMS_Constants.LEAD_CREATED_RESPONSE + mapRecordIdWithResult.get(sObj.Id).getReason();
                    
                            mapQueueRecordsForObjects.get(sObj.Id).Notes__c = addValue(notesData);
                            //mapQueueRecordsForObjects.get(sObj.Id).Notes__c += '\n' + Datetime.now().format() + CRMS_Constants.LEAD_CREATED_RESPONSE + mapRecordIdWithResult.get(sObj.Id).getReason();
                            mapQueueRecordsForObjects.get(sObj.Id).Action__c = dmlOperation;
                            mapQueueRecordsForObjects.get(sObj.Id).DWH_Data_Type__c = CRMS_Constants.mapApiNameDataType.get(objectName);
                        } //End of if map contains key
                    } //End of if record dwh status equals "queued"
                } //End of queue records with status = pending found
                else {
                    if(((String)sObj.get('DWH_Status__c')).equals(CRMS_Constants.DWH_STATUS_QUEUED)) {
                        lstQueueRecordsToUpdate.add(
                            generateSyncQueueFromObject(
                                sObj.Id,
                                Datetime.now().format() + ' : ' + CRMS_Constants.LEAD_CREATED_RESPONSE + mapRecordIdWithResult.get(sObj.Id).getReason(),
                                dmlOperation
                            )
                        );
                    } //End of record dwh status equals "QUEUED"
                } //End of no records found
            } //End of for loop for callout leads
        } //End of main response is OK
        else {
            //For every record in callout, set status = "QUEUED", and sync queue record notes
            for(SObject sObj : lstCalloutObjects) {

                notesData = '';
                if(mapQueueRecordsForObjects.containsKey(sObj.Id)) {
                    if(mapQueueRecordsForObjects.get(sObj.Id).Notes__c == null)
                            mapQueueRecordsForObjects.get(sObj.Id).Notes__c = '';
                            
                    notesData = mapQueueRecordsForObjects.get(sObj.Id).Notes__c;
                    notesData += '\n' + Datetime.now().format() + ' : ' + objResponse.getResponseMessage();
                    
                    mapQueueRecordsForObjects.get(sObj.Id).Notes__c = addValue(notesData);
                    
                    
                    //mapQueueRecordsForObjects.get(sObj.Id).Notes__c += '\n' + Datetime.now().format() + ' : ' + objResponse.getResponseMessage();
                    mapQueueRecordsForObjects.get(sObj.Id).Action__c = dmlOperation;
                    mapQueueRecordsForObjects.get(sObj.Id).DWH_Data_Type__c = CRMS_Constants.mapApiNameDataType.get(objectName);
                } //End of sync queue already exists
                else {
                    lstQueueRecordsToUpdate.add(
                        generateSyncQueueFromObject(
                            sObj.Id,
                            Datetime.now().format() + ' : ' + objResponse.getResponseMessage(),
                            dmlOperation
                        )
                    );
                } //End of sync queue does not exist
                sObj.put('DWH_Status__c', CRMS_Constants.DWH_STATUS_QUEUED);
            } //End of for loop for callout leads
        } //End of main response is ERROR
        
        //Get all the new and updated queue records to upsert
        if(mapQueueRecordsForObjects != null && !mapQueueRecordsForObjects.values().isEmpty())
            lstQueueRecordsToUpdate.addAll(mapQueueRecordsForObjects.values());
            upsert lstQueueRecordsToUpdate;
            update lstObjectsToUpdate;
        }
        catch (Exception ex) {
            system.debug('******Exception: ' + ex.getMessage());
        }
    }
    
    // check and add the comment on notes
    public static String addValue( String notesValue ){
        //System.debug('String value Is------>'+notesValue);
        if( notesValue.length() > fieldLength ){
            notesValue = notesValue.Substring(0, fieldLength);
            notesValue += '\n **FULL**';
        }
        return notesValue;
         
    }
    
    //Method to perform operations according to result received from callout for batch class
    public static List<Sync_Queue__c> processBatchResults(List<SObject> lstObjects, CRMS_HttpResponseWrapper objResponse, String action) {
        Map<Id, Sync_Queue__c> mapRecordSyncQueue = new Map<Id, Sync_Queue__c> ();
        Map<Id, CRMS_HttpResponseWrapper.RecordResultWrapper> mapRecordResponse = new Map<Id, CRMS_HttpResponseWrapper.RecordResultWrapper> ();

        String objectName = lstObjects[0].getSObjectType().getDescribe().getLabel();
        String notesData = '';
        // It is used to store the length of the field
        //Integer fieldLength = (Schema.SObjectType.Sync_Queue__c.fields.Notes__c.getLength()) - 15;
        system.debug(SYstem.LoggingLevel.ERROR, 'response*****' + objResponse);
        try{
        if(objectName.equals(CRMS_Constants.DWH_DATA_TYPE_TASK)) {
            List<Sync_Queue__c> lstQueueForTasks = new List<Sync_Queue__c> ();
            Set<Id> setTasksId = new Set<Id> ();
            for(SObject obj : lstObjects)
                setTasksId.add(obj.Id);
            lstQueueForTasks = [SELECT Task_Id__c, Sync_Status__c, Notes__c, Id FROM Sync_Queue__c WHERE Task_Id__c IN :setTasksId];
            
            if(lstQueueForTasks != null && !lstQueueForTasks.isEmpty()) {
                for(Sync_Queue__c objQueue : lstQueueForTasks) {
                    mapRecordSyncQueue.put(Id.valueOf(objQueue.Task_Id__c), objQueue);
                } //End of for loop for every queue in lstQueueForTasks
            } //End of if queue list not empty
            
        } //If object is task, then query
        else {
            //Populate the map of record Id and its respective Sync_Queue record
            for(SObject sObj : lstObjects) {
                if(sObj.getSObjects('Sync_Queues__r') != null && !((List<Sync_Queue__c>)sObj.getSObjects('Sync_Queues__r')).isEmpty())
                    mapRecordSyncQueue.put(sObj.Id, ((List<Sync_Queue__c>)sObj.getSObjects('Sync_Queues__r'))[0]);
            } //End of for loop for populating the map
            
        } //End of if object is not task
        
        if(objResponse != null && objResponse.getResults() != null && !objResponse.getResults().isEmpty()) {
            for(CRMS_HttpResponseWrapper.RecordResultWrapper objWrapper : objResponse.getResults()) {
                mapRecordResponse.put(Id.valueOf(objWrapper.getSalesForceId()), objWrapper);
            } //End of for loop for every result in response
            // It is used to store the length of the field
            
            
            for(SObject sObj : lstObjects) {
                notesData = '';
                if(mapRecordResponse.containsKey(sObj.Id) && mapRecordResponse.get(sObj.Id) != null) {
                    if(mapRecordResponse.get(sObj.Id).getSuccess() == true) {
                        mapRecordSyncQueue.get(sObj.Id).Sync_Status__c = CRMS_Constants.SYNC_QUEUE_STATUS_SUCCESS;
                        if(mapRecordSyncQueue.get(sObj.Id).Notes__c == null  )
                            mapRecordSyncQueue.get(sObj.Id).Notes__c = '';
                        notesData = mapRecordSyncQueue.get(sObj.Id).Notes__c;
                        notesData += '\n' + Datetime.now().format() + CRMS_Constants.BATCH_RESPONSE_SUCCESS.replace('XYXY', objectName).replace('XXX', action);
                        
                        mapRecordSyncQueue.get(sObj.Id).Notes__c = addValue(notesData);
                    } //End of if response for this lead is OK
                    else {
                        if(mapRecordSyncQueue.get(sObj.Id).Notes__c == null)
                            mapRecordSyncQueue.get(sObj.Id).Notes__c = '';
                        notesData = mapRecordSyncQueue.get(sObj.Id).Notes__c;
                        notesData += '\n' + Datetime.now().format() + CRMS_Constants.BATCH_RESPONSE_ERROR.replace('XYXY', objectName).replace('XXX', action) + objResponse.getResponseMessage();
                        
                        mapRecordSyncQueue.get(sObj.Id).Notes__c = addValue(notesData);
                    } //End of else response for this lead is NOT OK
                } //End of if block for mapRecordResponse
            } //End of for loop for every lead in lstLeads
        } //End of if response is OK
        else {
            for(SObject sObj : lstObjects) {
                notesData = '';
                if(mapRecordSyncQueue.containsKey(sObj.Id)) {
                    if(mapRecordSyncQueue.get(sObj.Id).Notes__c == null)
                        mapRecordSyncQueue.get(sObj.Id).Notes__c = '';
                    notesData = mapRecordSyncQueue.get(sObj.Id).Notes__c;
                    notesData += '\n' + Datetime.now().format() + CRMS_Constants.BATCH_RESPONSE_ERROR.replace('XYXY', objectName).replace('XXX', action) + objResponse.getResponseMessage();
                    
                    mapRecordSyncQueue.get(sObj.Id).Notes__c = addValue(notesData);
                } //End of if map contains key
            } //End of for loop for lstLeads
        } //End of if response is NOT OK
        }catch( Exception e){
            system.debug('------ Exception Is -------------'+e.getMessage());
        }
        return mapRecordSyncQueue.values();
    } //End of processBatchResults() method
    
    
    //Method to perform operations on Sync Queue records for delete
    public static List<Sync_Queue__c> processBatchResultsForDelete(List<Id> lstQueueRecordId, CRMS_HttpResponseWrapper objResponse) {
        Map<Id, CRMS_HttpResponseWrapper.RecordResultWrapper> mapRecordResponse = new Map<Id, CRMS_HttpResponseWrapper.RecordResultWrapper> ();
        List<Sync_Queue__c> lstQueue = new List<Sync_Queue__c> ();
        String query = CRMS_SObjectUtility.generateQueryForQueue() + ' WHERE Queued_Record_Id__c IN :lstQueueRecordId';
        lstQueue = (List<Sync_Queue__c>) Database.query(query);
        String notesData = '';
        String objectName = lstQueueRecordId[0].getSObjectType().getDescribe().getLabel();
        try{
        if(lstQueue != null && !lstQueue.isEmpty()) {
            
            if(objResponse != null && objResponse.getResults() != null && !objResponse.getResults().isEmpty()) {
                for(CRMS_HttpResponseWrapper.RecordResultWrapper objWrapper : objResponse.getResults()) {
                    mapRecordResponse.put(Id.valueOf(objWrapper.getSalesForceId()), objWrapper);
                } //End of for loop for every result in response
            } //End of if response is not null
            else {
                for(Sync_Queue__c objQueue : lstQueue) {
                    notesData = '';
                    if(objQueue.Notes__c == null)
                        objQueue.Notes__c = '';
                    notesData = objQueue.Notes__c;
                    notesData += '\n' + Datetime.now().format() + CRMS_Constants.BATCH_RESPONSE_ERROR.replace('XYXY', objectName).replace('XXX', CRMS_Constants.SYNC_ACTION_DELETE) + objResponse.getResponseMessage();
                    
                    objQueue.Notes__c = addValue(notesData);
                } //End of for loop on lstQueue
                
                return lstQueue;
            } //End of if response is NOT OK
            
            for(Sync_Queue__c objQueue : lstQueue) {
                notesData = '';
                if(mapRecordResponse.containsKey(objQueue.Queued_Record_Id__c)) {
                    if(mapRecordResponse.get(objQueue.Queued_Record_Id__c).getSuccess() == true) {
                        objQueue.Sync_Status__c = CRMS_Constants.CALLOUT_RESPONSE_SUCCESS;
                        if(objQueue.Notes__c == null)
                            objQueue.Notes__c = '';
                        notesData = objQueue.Notes__c;
                        notesData += '\n' + Datetime.now().format() + CRMS_Constants.BATCH_RESPONSE_SUCCESS.replace('XYXY', objectName).replace('XXX', CRMS_Constants.SYNC_ACTION_DELETE) + mapRecordResponse.get(objQueue.Queued_Record_Id__c).getReason();
                        
                        objQueue.Notes__c = addValue(notesData);
                        
                    } //End of if response is OK
                    else {
                        if(objQueue.Notes__c == null)
                            objQueue.Notes__c = '';
                        notesData = objQueue.Notes__c;
                        notesData += '\n' + Datetime.now().format() + CRMS_Constants.BATCH_RESPONSE_ERROR.replace('XYXY', objectName).replace('XXX', CRMS_Constants.SYNC_ACTION_DELETE) + mapRecordResponse.get(objQueue.Queued_Record_Id__c).getReason();
                        
                        objQueue.Notes__c = addValue(notesData);
                    } //End of if response is NOT OK
                } //End of if map contains record
            } //End of for loop on lstQueue
        } //End of lstQueue is not null
        }catch( Exception e){
            system.debug('------ Exception Is -------------'+e.getMessage());
        }
        return lstQueue;
    }

}