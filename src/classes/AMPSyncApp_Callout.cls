/**
 * AMP Sync Application
 * 
 * This file is the part of the AMP Sync Application used to Sync Data between Salesforce and Other Platforms
 * 
 * Copyright (c) 2016 - xoomworks.com
 * 
 * @author Khurram Shahzad (Sr. Software Engineer .at. XoomWorks) <a href="http://www.xoomworks.com/">XoomWorks</a>
 * @created 2016
 * 
 * Class to make callout requests to other AMP Platforms
 *
 */
 
public with sharing class AMPSyncApp_Callout {
	 
    private static string CallOutMethod; // Callout Method (GET/POST/DELETE)
    
    public static void setCallOutMethod(string Method){
    	CallOutMethod = Method;
    }
      
	/*
     *  Returns Http Request Object.
     *  Set Header for Content Type, Authentication Key and Auth Date
     *	Default Time out of this request set to 30000
     *	This requires following parameters.     
     *  
     *  @APIEndpoint : Endpoint URL.
     *    
     *     
     */
	
	private static HttpRequest CreateHTTPRequest(string APIEndpoint){		
		HttpRequest CalloutRequest = new HttpRequest();
		CalloutRequest.setHeader(AMPSyncApp_Constants.CONTENT_TYPE, AMPSyncApp_Constants.CONTENT_TYPE_JSON);
      	CalloutRequest.setHeader(AMPSyncApp_Constants.REQUEST_HEADER_DATE, AMPSyncApp_Constants.CURRENT_DATETIME_IN_GMT);
      	CalloutRequest.setHeader(AMPSyncApp_Constants.REQUEST_HEADER_AUTH, AMPSyncApp_Util.generateAuthKey(CallOutMethod, APIEndpoint));
      	CalloutRequest.setTimeout(AMPSyncApp_Constants.CALLOUT_DEFAULT_TIMEOUT);
		CalloutRequest.setMethod(CallOutMethod);
      	return CalloutRequest;
	}
	
	/**
	 * Take HttpRequest Object as parameter and Returns HttpResponse	 	  	 
	 * This is Synchronous CallOut Request
	 * Return NULL on Exceptions	 
	 */
	 
	private static string Execute(HttpRequest Request){		
		try{                    	
           	HttpResponse Response = new http().send(Request);
           	return Response.getBody();			
        }catch(System.CalloutException e) {            
            AMPSyncApp_Constants.CALLOUT_EXCEPTION = e.getmessage();
            return null;
        }        
	}
	
	/*
     *  CalloutGet to make GET request to AMP DWH remote site.
     *	This requires following parameters.
     *  
     *  @APIEndPoint : Endpoint URL like /api/LoanLedger
     *  
     *  @QueryStringParam : URL Parameters like ?LoanId=.
     *     
     */ 
		
	
	public static string CallOutGET(string APIEndPoint, string QueryStringParam){
		HttpRequest Request = CreateHTTPRequest(APIEndPoint);
		Request.setEndpoint(AMPSyncApp_Constants.REMOTE_SITE_URL + APIEndPoint + QueryStringParam);
		return Execute(Request);		
	}
	
	/*
     *  CalloutGet to make POST/DELETE requests to AMP DWH remote site.
     *	This requires following parameters.
     *  
     *  @APIEndPoint : Endpoint URL like /api/LoanLedger
     *  
     *  @SerializeJSONString : JSON Encoded String.
     *     
     */
	
	public static string CallOutPOST(string APIEndPoint, string SerializeJSONString){
		HttpRequest Request = CreateHTTPRequest(APIEndPoint);
		Request.setBody(SerializeJSONString);
		system.debug(' body size :: '+SerializeJSONString.length());
		system.debug(' <<<< SerializeJSONString >>>> '+SerializeJSONString);		
		Request.setEndpoint(AMPSyncApp_Constants.REMOTE_SITE_URL + APIEndPoint);		
		string Response = Execute(Request);		
		system.debug(':: Response :: '+Response);
		return Response;
	}
}