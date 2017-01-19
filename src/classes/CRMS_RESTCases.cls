/**
@ Created Date : 31-3-2015. 
@ Description  : It is used to insert the cases record using REST.
@ Author       : CRMSuperstars 
*/
@RestResource(urlMapping='/FieldCases/*')
global class CRMS_RESTCases {
    // Used to stor response json
    public static String responseJSON = '';
    public static List<restResponseLog> listResponse = new List<restResponseLog>();
    // DTO -- Inner class for json 
    global class restRequestLog{
        public String SalesforceOperationId;
        public String SalesforceClientId;
        public String CurrencyIsoCode;
    }
    
    global class restResponseLog{
        public Integer status_code;
        public String description;
        public String salesforce_CaseID;
     }
     
      @HttpPost
     global static String insertCases(){
        // Used to store all credit assessments to insert
        List<Case> listCasesToInsert  = new List<Case>();
        RestRequest req = RestContext.request;
        //
        Map<Integer, ID> mapOfcounterAndID = new Map<Integer, ID>();
        Integer counter = 0;
        try{
            // json de-serialize 
            List<restRequestLog> listCases = (List<restRequestLog>)JSON.deserialize(req.requestbody.tostring(), List<restRequestLog>.class);
            system.debug('******* Request Data to Insert ******'+listCases);
            // Need to check null 
            for (restRequestLog caseRec : listCases ){
                Case newCaes = new Case();
                newCaes.recordTypeId = '012260000008UlD';
                newCaes.Operation__c = (Id)caseRec.SalesforceOperationId;
                newCaes.AccountId = (Id)caseRec.SalesforceClientId;
                newCaes.Status = 'Open';
                newCaes.Origin = 'Merlot';
                newCaes.CurrencyIsoCode = caseRec.CurrencyIsoCode;
                mapOfcounterAndID.put(counter, (Id)caseRec.SalesforceOperationId);
                counter++;
                listCasesToInsert.add(newCaes);
            }
            // Use to store the insert result
            Database.SaveResult[] listInsertResult ;
             
            if( listCasesToInsert.size() > 0 ){
                listInsertResult = Database.insert(listCasesToInsert, false);
                counter = 0;
                // Iterate through each returned result
                for (Database.SaveResult saveResult : listInsertResult) {
                    if (saveResult.isSuccess()) {
                        // Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully inserted case. Case ID: ' + saveResult.getId());
                        generateResponseJSON('Successfully inserted Case. Case ID: '+saveResult.getId(), 200, mapOfcounterAndID.get(counter));
                    }
                    else {
                        // Operation failed, so get all errors                
                        for(Database.Error err : saveResult.getErrors()) {
                            generateResponseJSON('The error has occurred.'+err.getStatusCode() + ': ' + err.getMessage()+'Case fields that affected this error: ' + err.getFields(), 400, mapOfcounterAndID.get(counter));
                            System.debug('The following error has occurred.');
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Case fields that affected this error: ' + err.getFields());
                        }
                    }
                    counter++;
                }
            }
        }
        catch(Exception e){
            system.debug('********** Exception Is ******* ::'+e.getMessage());
            generateResponseJSON('The error has occurred.'+e.getMessage(), 400, null);
            
            if( listResponse.size() > 0 )
                responseJSON = JSON.serialize(listResponse);
            return responseJSON; 
        }
        if( listResponse.size() > 0  )
            responseJSON = JSON.serialize(listResponse);
        return responseJSON;  
     }
     
     // Use to create status code with error.
    public static void generateResponseJSON( string responseMessage, integer statusCode, String operationID){
        restResponseLog response = new restResponseLog();
        response.status_code = statusCode;
        response.description = responseMessage;
        response.salesforce_CaseID = operationID;
        listResponse.add(response);
        
        //return JSON.serialize(response);
    }
}