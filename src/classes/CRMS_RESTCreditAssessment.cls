/**
@ Created Date : 31-3-2015. 
@ Description  : It is used to update the credit assessment record using REST. 
@ Author       : CRMSuperstars
*/
@RestResource(urlMapping='/FieldCreditAssessment/*')
global class CRMS_RESTCreditAssessment {
    // Used to stor response json
    public static String responseJSON = '';
    public static List<restResponseLog> listResponse = new List<restResponseLog>();
    // DTO -- Inner class for json 
    global class restRequestLog{
        public String ApplicationNumber;
        //public Integer AplicationId;
        public String SalesforceCreaditAssessmentId;
        public Decimal CreditScore; 
        public Decimal OfferAmount;
        public Decimal OfferedPrincipalDailyRepaiment;
        public Decimal OfferedPrincipalWeeklyRepayment;
        public Decimal OffederInterestDailyRepayment;
        public Decimal OfferedInterestWeeklyRepayment;
       
        public Decimal OfferedTotalDailyRepayment;
        public Decimal OfferedTotalWeeklyRepayment;
        public Decimal OfferedTotalRepayment;
        public Integer LoanTermInMonths;
        public Decimal MonthlyInterest;
        public Integer DailyRepaimentNum;
    }
    
    global class restResponseLog{
        public Integer status_code;
        public String description;
        public String salesforce_Credit_AssessmentID;
     }
     @HttpPost
     global static String updateCreditAssessment(){
        
        // Used to store all credit assessments to insert
        List<Credit_Assessment__c> listCreditAToUpdate  = new List<Credit_Assessment__c>();
        RestRequest req = RestContext.request;
        //String requestJSON = RestRequest.requestBody.toString();
        // List Of operation Id
        List<Id> listID = new List<Id>();
        try{
            // json de-serialize 
            List<restRequestLog> listCreditAssessment = (List<restRequestLog>)JSON.deserialize(req.requestbody.tostring(), List<restRequestLog>.class);
            system.debug('******* Request Data to Insert ******'+listCreditAssessment);
            // Get operation Ids
            for( restRequestLog creditAss : listCreditAssessment){
                listID.add(creditAss.SalesforceCreaditAssessmentId);
            }
            // Query all operation record contains list Id
            Map<ID, Credit_Assessment__c> mapCreditAssess = new Map<ID, Credit_Assessment__c>([SELECT Id, Application_ID__c, AMP_Credit_Score__c, Offer_Amount__c,
                                                                                                        Principal_Daily_Repayment_Offer__c, Interest_Daily_Repayment_Offer__c,
                                                                                                        Total_Amount_Repayable_Offer__c, Total_Daily_Repayment_Offer__c,
                                                                                                        Offer_Total_Repayment__c, Offer_Term__c, Monthly_Interest__c,
                                                                                                        Number_of_Repayments_Offer__c
                                                                                                FROM Credit_Assessment__c 
                                                                                                Where Id = : listID]);
            
            if( listCreditAssessment != null ){
                // Need to check null 
                for (restRequestLog creditAssessment : listCreditAssessment ){
                    system.debug('======Application Id Is:::::'+creditAssessment.ApplicationNumber);
                    Credit_Assessment__c newCreditAssessment = new Credit_Assessment__c();
                    newCreditAssessment = mapCreditAssess.get(creditAssessment.SalesforceCreaditAssessmentId);
                    if( newCreditAssessment != null ){
                        if( newCreditAssessment.Application_ID__c == creditAssessment.ApplicationNumber ){
                            //newCreditAssessment.Id = (Id)creditAssessment.SalesforceCreaditAssessmentId;
                            newCreditAssessment.AMP_Credit_Score__c = creditAssessment.CreditScore;
                            newCreditAssessment.Offer_Amount__c = creditAssessment.OfferAmount;
                            newCreditAssessment.Principal_Daily_Repayment_Offer__c = creditAssessment.OfferedPrincipalDailyRepaiment;
                            newCreditAssessment.Principal_Weekly_Repayment_Offer__c = creditAssessment.OfferedPrincipalWeeklyRepayment;
                            newCreditAssessment.Interest_Daily_Repayment_Offer__c = creditAssessment.OffederInterestDailyRepayment;
                            newCreditAssessment.Interest_Weekly_Repayment_Offer__c = creditAssessment.OfferedInterestWeeklyRepayment;
                            newCreditAssessment.Total_Daily_Repayment_Offer__c = creditAssessment.OfferedTotalDailyRepayment; 
                            newCreditAssessment.Total_Weekly_Repayment_Offer__c = creditAssessment.OfferedTotalWeeklyRepayment;
                            newCreditAssessment.Offer_Total_Repayment__c = creditAssessment.OfferedTotalRepayment;
                            newCreditAssessment.Offer_Term__c = string.valueOf(creditAssessment.LoanTermInMonths);
                            newCreditAssessment.Monthly_Interest__c = creditAssessment.MonthlyInterest;
                            newCreditAssessment.Number_of_Repayments_Offer__c = creditAssessment.DailyRepaimentNum;
                            
                            listCreditAToUpdate.add(newCreditAssessment);
                        }else 
                            generateResponseJSON('Application Id does not Match ', 304, newCreditAssessment.Id);
                        
                    }else 
                        generateResponseJSON('Salesforce Credit Assessment ID does not match. Please provied correct salesforce Id. ', 400, creditAssessment.SalesforceCreaditAssessmentId);
                    
                }
                // Use to store the insert result
                Database.SaveResult[] listInsertResult;
                 system.debug('***** TO DO *****');
                if( listCreditAToUpdate.size() > 0 ){
                    listInsertResult = Database.update(listCreditAToUpdate, false);
                
                    // Iterate through each returned result
                    for (Database.SaveResult saveResult : listInsertResult) {
                        if (saveResult.isSuccess()) {
                            // Operation was successful, so get the ID of the record that was processed
                            System.debug('Successfully inserted Credit Assessment. Credit Assessment ID: ' + saveResult.getId());
                            generateResponseJSON('Successfully updated Credit Assessment. ', 200, saveResult.getId());
                        }
                        else {
                            // Operation failed, so get all errors                
                            for(Database.Error err : saveResult.getErrors()) {
                                generateResponseJSON('The error has occurred.'+err.getStatusCode() + ': ' + err.getMessage()+'Credit Assessment fields that affected this error: ' + err.getFields(), 400, saveResult.getId());
                                System.debug('The following error has occurred.');
                                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                System.debug('Credit Assessment fields that affected this error: ' + err.getFields());
                            }
                        }
                    }
                }
            }
        }catch(Exception e){
            system.debug('********** Exception Is ******* ::'+e.getMessage());
            generateResponseJSON('The error has occurred.'+e.getMessage(), 400, null);
            
            if( listResponse.size() > 0)
                responseJSON = JSON.serialize(listResponse);
            return responseJSON; 
        }
        
        if(listResponse.size() > 0 )
            responseJSON = JSON.serialize(listResponse);
      return responseJSON;  
     }
      // Use to create status code with error.
    public static void generateResponseJSON( string responseMessage, integer statusCode, String operationID){
        restResponseLog response = new restResponseLog();
        response.status_code = statusCode;
        response.description = responseMessage;
        response.salesforce_Credit_AssessmentID = operationID;
        listResponse.add(response);
        
        //return JSON.serialize(response);
    }
}