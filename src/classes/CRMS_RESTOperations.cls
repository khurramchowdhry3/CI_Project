/**
@ Created Date : 31-3-2015. 
@ Description  : It is used to update the operation record using REST. 
@ Author       : CRMSuperstars
*/
@RestResource(urlMapping='/FieldOperations/*')
global class CRMS_RESTOperations {
    // Used to stor response json
    public static String responseJSON = '';
    public static List<restResponseLog> listResponse = new List<restResponseLog>();
    // DTO -- Inner class for json 
    global class restRequestLog{
        public Integer LoanId;
        public String SalesforceOperationId;
        public Decimal LoanDisbursed; 
        public DateTime LoanDisbursedDate;
        
        public Decimal LoanOutstandingPrincipal;
        public Decimal LoanOutstandingInterest;
        public Decimal OutstandingFees;
        public String FrequencyCollection;
        public String DayOfWeekToBeDebited;
        public DateTime FinalCollectionDate;
        public String FinalAmountToBeDebited;
       // public Long DisbursedAmount;
    }
    
    global class restResponseLog{
        public Integer status_code;
        public String description;
        public String salesforce_operationID;
     }
      @HttpPost
     global static String updateOperations(){
        // Used to store all credit assessments to insert
        List<Operation__c> listOperationToUpdate  = new List<Operation__c>();
        RestRequest req = RestContext.request;
        // List Of operation Id
        List<Id> listID = new List<Id>();
        try{
            // json de-serialize 
            List<restRequestLog> listOperations = (List<restRequestLog>)JSON.deserialize(req.requestbody.tostring(), List<restRequestLog>.class);
            system.debug('******* Request Data to Insert ******'+listOperations);
            // Get operation Ids
            for( restRequestLog operation : listOperations){
                listID.add(operation.SalesforceOperationId);
            }
            // Query all operation record contains list Id
            Map<ID, Operation__c> mapOperation = new Map<ID, Operation__c>([SELECT Id, Loan_Disbursed__c, Loan_Disbursed_Date__c, 
                                                                                        Loan_Amount__c, Loan_Outstanding_Principal__c,
                                                                                        Loan_Outstanding_Interest__c, Outstanding_Fees__c,
                                                                                        Frequency_of_Collection__c, Day_of_the_Week_to_be_Debited__c,
                                                                                        Final_Amount_to_be_Debited__c
                                                                            FROM Operation__c 
                                                                            Where Id IN : listID]);
            // Need to check null 
            for(restRequestLog operation : listOperations ){
                Operation__c operationToUpdate = new Operation__c();
                operationToUpdate = mapOperation.get(operation.SalesforceOperationId);
                if(operationToUpdate != null ){
                    if( operation.LoanId != null ){
                        if( operation.LoanDisbursed == 1 )
                            operationToUpdate.Loan_Disbursed__c  = true ;
                        else if( operation.LoanDisbursed == 0 )
                            operationToUpdate.Loan_Disbursed__c  = false ;
                        operationToUpdate.Loan_Disbursed_Date__c = Date.valueOf(operation.LoanDisbursedDate);
                        operationToUpdate.Loan_Id__c = operation.LoanId; 
                        operationToUpdate.Loan_Outstanding_Principal__c = operation.LoanOutstandingPrincipal;
                        operationToUpdate.Loan_Outstanding_Interest__c = operation.LoanOutstandingInterest;
                        operationToUpdate.Outstanding_Fees__c = operation.OutstandingFees;
                        operationToUpdate.Frequency_of_Collection__c = operation.FrequencyCollection;
                        operationToUpdate.Day_of_the_Week_to_be_Debited__c = operation.DayOfWeekToBeDebited;
                        //operationToUpdate.Date_of_Final_Collection__c = Date.valueOf(operation.FinalCollectionDate);
                        operationToUpdate.Final_Amount_to_be_Debited__c = operation.FinalAmountToBeDebited;
                        //operationToUpdate.Loan_Amount__c  = operation.DisbursedAmount;
                        // Add to the updation list
                        listOperationToUpdate.add(operationToUpdate);

                    }else
                        generateResponseJSON('Please provide Loan Id. ', 304, operation.SalesforceOperationId);
                }else 
                    generateResponseJSON('Salesforce operation ID does not match. Please provide correct salesforce Id. ', 400, operation.SalesforceOperationId);
                
            }
            
            
            // Use to store the insert result
            Database.SaveResult[] listInsertResult;
             
            if( listOperationToUpdate.size() > 0 ){
                listInsertResult = Database.update(listOperationToUpdate, false);
            
                // Iterate through each returned result
                for (Database.SaveResult saveResult : listInsertResult) {
                    if (saveResult.isSuccess()) {
                        // Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully updated operation. Operation ID: ' + saveResult.getId());
                        generateResponseJSON('Successfully updated operation.', 200, saveResult.getId());
                    }
                    else {
                        // Operation failed, so get all errors                
                        for(Database.Error err : saveResult.getErrors()) {
                            generateResponseJSON('The error has occurred.'+err.getStatusCode() + ': ' + err.getMessage()+'operation fields that affected this error: ' + err.getFields(), 400, saveResult.getId());
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('operation fields that affected this error: ' + err.getFields());
                        }
                    }
                }
            }
        }catch(Exception e){
            system.debug('********** Exception Is ******* ::'+e.getMessage());
            
            generateResponseJSON('The error has occurred.'+e.getMessage(), 400, null);
            
            if( listResponse.size() > 0 )
                responseJSON = JSON.serialize(listResponse);
            return responseJSON; 
        }
        if( listResponse.size() > 0 )
            responseJSON = JSON.serialize(listResponse);
            
      return responseJSON;  
     }
     // Use to create status code with error.
    public static void generateResponseJSON( string responseMessage, integer statusCode, String operationID){
        restResponseLog response = new restResponseLog();
        response.status_code = statusCode;
        response.description = responseMessage;
        response.salesforce_operationID = operationID;
        listResponse.add(response);
        
        //return JSON.serialize(response);
    }
}