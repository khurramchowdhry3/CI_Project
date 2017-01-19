/**
    Utility class to perform Http Callouts
    Author: Saket Joshi
    Version: 1.0
*/

public without sharing class CRMS_HttpCalloutUtility {
    //Method to perform the callout and get the response
    public static CRMS_HttpResponseWrapper doCallout(CRMS_HttpRequestParams objRequestParams) {
        HttpRequest objHttpRequest = new HttpRequest();
        objHttpRequest.setMethod(objRequestParams.getCalloutMethod());
        
        //Callout method is GET, set the params in the url
        if(objRequestParams.getCalloutMethod().equals(CRMS_Constants.CALLOUT_METHOD_GET)) {
            String endpointWithParams;
            
            if(objRequestParams.getRequestParams() != null)
                endpointWithParams = getEndpointUrlWithParams(objRequestParams.getEndpointUrl(), objRequestParams.getRequestParams());
            else
                endpointWithParams = objRequestParams.getEndpointUrl();
                
            objHttpRequest.setEndPoint(endpointWithParams);
        } //End of if callout method is GET
        else {
            objHttpRequest.setEndpoint(objRequestParams.getEndpointUrl());
            system.debug(':: End Point URL :: '+objRequestParams.getEndpointUrl());            
            
            if(objRequestParams.getRequestBody() != null)
                objHttpRequest.setBody(objRequestParams.getRequestBody());
                system.debug(':: Request Body :: '+objRequestParams.getRequestBody());

            if(objRequestParams.getRequestHeaders() != null && !objRequestParams.getRequestHeaders().isEmpty())
                for(String headerName : objRequestParams.getRequestHeaders().keySet()) {
                    objHttpRequest.setHeader(headerName, objRequestParams.getRequestHeaderParam(headerName));
                }
        } //End of if callout method is POST
        
        if(objRequestParams.getTimeoutValue() != null)
            objHttpRequest.setTimeout(objRequestParams.getTimeoutValue());
        
        Http objHttp = new Http();
        HttpResponse objHttpResponse = new HttpResponse();
        try {
            system.debug('objHttpRequest Body---->'+objHttpRequest.getBody());
            system.debug('objHttpRequest ---->'+objHttpRequest);
            objHttpRequest.setHeader(CRMS_Constants.CONTENT_TYPE, CRMS_Constants.CONTENT_TYPE_JSON);
            objHttpResponse = objHttp.send(objHttpRequest);
            /*//
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            // Step 1: Create a new Email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
            // Step 2: Set list of people who should get the email
            List<String> sendTo = new List<String>();
            sendTo.add('mr.yogeshmahajan@gmail.com');
            mail.setToAddresses(sendTo);
            mail.setSubject('URGENT BUSINESS PROPOSAL');
            mail.setHtmlBody(objHttpResponse.getBody());
            
            mails.add(mail); */
            // Step 6: Send all emails in the master list
            //Messaging.sendEmail(mails);
            
            system.debug('objHttpResponse ---->'+objHttpResponse.getBody());
        } //End of try send request
        catch (System.CalloutException ex) {
            objHttpResponse.setBody('{"responseMessage" : "' + ex.getMessage().replaceAll('\"', '\\\\\"') + '"}');
        } //End of catch callout exception
        
        CRMS_HttpResponseWrapper objResponse;
        
        try {
            objResponse = (CRMS_HttpResponseWrapper)Json.deserialize(objHttpResponse.getBody(), CRMS_HttpResponseWrapper.class);
        }
        catch(System.JsonException ex) {
            objResponse = new CRMS_HttpResponseWrapper();
            objResponse.setResponseMessage(ex.getMessage());
        }
        return objResponse;
    }
    
    //Method to generate the endpoint url by appending the params for GET method
    private static String getEndpointUrlWithParams(String endpointUrl, Map<String, String> params) {
        String tempUrl = endpointUrl + '?';
        for(String paramName : params.keySet()) {
            tempUrl += paramName + '=' + params.get(paramName) + '&';
        }
        
        return tempUrl.removeEnd('&');
    }

    /*Method to generate the request body from the map for POST method
    private static String getBodyString(Map<String, String> params) {
        String tempBodyString = '';
        for(String paramName : params.keySet()) {
            tempBodyString += paramName + '=' + params.get(paramName) + '&';
        }
        
        return tempBodyString.removeEnd('&');
    }*/
} // end of CRMS_HttpCalloutUtility