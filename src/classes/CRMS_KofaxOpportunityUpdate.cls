/**
@ Created Date : 3-3-2015. 
@ Description  : It is used to provide opportunity update using SOAP.
@ Author       : CRMSuperstars
*/
global class CRMS_KofaxOpportunityUpdate {
    
    // DTO -- Inner class for json 
    global class DocumentReceivedUpdate{
        public string Application_Id;
        public boolean Required_Documents_Received;
        //public boolean creditCheck;
        Public boolean documents_Processed;
        public string document_Names;
     }
     global class responseLog{
        public integer status_code;
        public string description;
     }
     
    // Get SOAP request data for upadate the opportuity.  
    webservice static String updateOpportunity(string requestBody){
        
        system.debug(requestBody);
        // Used to store error message. 
        string responseJSON = '';
        // TO check found error / not.
        Boolean isError = true;
        try{
            // json de-serialize 
            List<DocumentReceivedUpdate> listOppdata = (List<DocumentReceivedUpdate>)JSON.deserialize(requestBody, List<DocumentReceivedUpdate>.class);
            system.debug(listOppdata);
            if ( listOppdata[0].Application_Id != '' && listOppdata[0].Application_Id != null  ){
                // Query to fetch 
                Opportunity[] oppRecord = [SELECT id, Application_ID2__c, Required_Documents_Received__c,
                                                Documents_Processed__c, Documents_Received_Kofax__c
                                           FROM Opportunity
                                           WHERE Application_ID2__c =: listOppdata[0].Application_Id];
                if( oppRecord.size() > 0 ){
                    
                    // Add list opp data with updated value
                    for( DocumentReceivedUpdate oppData : listOppdata ){
                        system.debug(oppData.document_Names);
                        if( oppRecord[0].Required_Documents_Received__c == true && oppRecord[0].Documents_Processed__c== true ){
                            responseJSON = generateResponseJSON('Credit Assessment is in progress', 304);
                            isError = false;
                        }
                            
                        if( oppRecord[0].Required_Documents_Received__c != true && oppData.Required_Documents_Received != null )
                            oppRecord[0].Required_Documents_Received__c = oppData.Required_Documents_Received;
                        
                        if( oppRecord[0].Documents_Processed__c!= true && oppData.documents_Processed != null )
                            oppRecord[0].Documents_Processed__c= oppData.documents_Processed;
                        
                       
                        if(oppRecord[0].Documents_Received_Kofax__c != null && oppData.document_Names != null && oppData.document_Names != '' )
                        {
                            oppRecord[0].Documents_Received_Kofax__c = oppRecord[0].Documents_Received_Kofax__c + ' \r\n' + system.now()+ '(' + oppData.document_Names + ')';
                        }
                        else if( oppData.document_Names != null && oppData.document_Names != ''  )
                            oppRecord[0].Documents_Received_Kofax__c = system.now()+ '(' + oppData.document_Names + ')';
                       
                    }
                }else{
                    responseJSON = generateResponseJSON('Application_Id is invalid. Please provide valid Application_Id', 400);
                    isError = false;
                }
                
                // Check list is empty / not
                if( oppRecord.size()  > 0)
                    update oppRecord;
                // IF No other error 
                if( isError == true )
                    responseJSON = generateResponseJSON('Record is successfully updated', 200);
            }
            else
                responseJSON = generateResponseJSON('Please provide a valid Application_Id', 400);
            
        }catch( exception e){
            responseJSON = generateResponseJSON(e.getMessage(), 400);
            return responseJSON;
        }
        return responseJSON;
     }
    // Use to create status code with error.
    public static string generateResponseJSON( string responseJSON, integer statusCode){
        responseLog response = new responseLog();
        response.status_code = statusCode;
        response.description = responseJSON;
        
        return JSON.serialize(response);
    }
    
}