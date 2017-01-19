/**
@ Created Date : 3-3-2015. 
@ Description  : It is used to provide opportunity update using SOAP.
*/
global class KofaxOpportunityUpdate{
 
    // DTO -- Inner class for json 
    global class DocumentReceivedUpdate{
        public string Appication_Id;
        public boolean Required_Documents_Received;
        public boolean creditCheck;
        public string document_Names;
     }
     global class responseLog{
        public integer status_code;
        public string description;
     }
     
    // Get SOAP request data for upadate the opportuity.  
    webservice static string updateOpportunity(string requestBody){
        // Used to store temp. values
        string documentNames = '';
        List<string> listDocNames = new List<string>();
        List<string> setDocNames = new List<string>();
        // Used to store error message. 
        string responseJSON = '';
        Boolean isAllDocument = false;
        Boolean isUpdate = false;
        try{
            // json de-serialize 
            List<DocumentReceivedUpdate> listOppdata = (List<DocumentReceivedUpdate>)JSON.deserialize(requestBody, List<DocumentReceivedUpdate>.class);
            system.debug('============'+listOppdata);
            List<Opportunity> listOppToUpdate = new List<Opportunity>();
        
            // Query to fetch opportunity record
            Opportunity[] oppRecord = [SELECT id, Application_ID2__c, Required_Documents_Received__c,
                                            Documents_Processed__c, Documents_Received_Kofax__c
                                       FROM Opportunity
                                       WHERE Application_ID2__c =: listOppdata[0].Appication_Id];
            if( oppRecord.size() > 0 ){
                system.debug('==== Inside if=====');
                // Add list opp data with updated value
                for( DocumentReceivedUpdate oppData : listOppdata ){
                    documentNames = oppRecord[0].Documents_Received_Kofax__c;
                    documentNames = documentNames + oppData.document_Names;
                    if( documentNames.contains('Merchant Statement') == true && documentNames.contains('Business Bank statement') == true 
                         && documentNames.contains('Proof of identity') == true && documentNames.contains('Proof of address') == true)
                            isAllDocument = true;
                    // Checking all required Document names are present / not
                    if( ( oppData.Required_Documents_Received != null || oppData.creditCheck != null )
                        && isAllDocument == true){
                            oppRecord[0].Required_Documents_Received__c = oppData.Required_Documents_Received;
                            oppRecord[0].Documents_Processed__c= oppData.creditCheck;
                            isUpdate = true;
                    }else if((oppData.Required_Documents_Received == true || oppData.creditCheck == true)
                        && isAllDocument == false ){
                            responseJSON = generateResponseJSON('All required documents are not received yet! Please provide all required documents names.', 400);
                            
                    }
                    system.debug('=========='+isAllDocument);
                    oppRecord[0].Documents_Received_Kofax__c = '';
                    listDocNames = documentNames.split(',');
                    setDocNames.addAll(listDocNames);
                    oppRecord[0].Documents_Received_Kofax__c = string.valueOf(setDocNames);
                    
                    
                    //listOppToUpdate.add(oppRecord[0]);
                }
            }else{
                responseJSON = generateResponseJSON('Application_Id is invalid. Please provide valid Application_Id', 400);
            }
            system.debug('====== Error msg'+responseJSON );
            system.debug('===== listOppToUpdate '+listOppToUpdate);
            // Check list is empty / not
            if( oppRecord.size()  > 0)
                update oppRecord;
            if( isUpdate == true )
                responseJSON = generateResponseJSON('Record is successfully updated', 200);
        }catch( exception e){
            System.debug('Inside Exception===='+e.getMessage());
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