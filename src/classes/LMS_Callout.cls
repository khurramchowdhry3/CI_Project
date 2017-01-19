/**
 * AMP Loan Management System
 * 
 * This file is part of the AMP Loan Management Project
 * Loan Management System for Sales & Admin Peoples.
 *
 * Copyright (c) 2016 - xoomworks.com
 * 
 * @author Khurram Shahzad (Sr. Software Engineer .at. XoomWorks) <a href="http://www.xoomworks.com/">XoomWorks</a>
 * @created 2016
 * 
 * Class to make callout requests to AMP DWH remote site.
 *
 */ 
public class LMS_Callout {
	
	/*
     *  Returns Http Request Object.
     *  Set Header for Content Type, Authentication Key and Auth Date
     *	Default Time out of this request set to 30000
     *	This requires following parameters.
     *  
     *  @Method : Callout Method (GET/POST)
     *  
     *  @APIEndpoint : Endpoint URL.
     *
     *	@Param : Request parameters in URL	
     *     
     */   
	
	private static HttpRequest CreateRequest(string Method, string APIEndpoint, string Param){		
		HttpRequest CalloutRequest = new HttpRequest();
      	CalloutRequest.setHeader(CRMS_Constants.CONTENT_TYPE, CRMS_Constants.CONTENT_TYPE_JSON);
      	CalloutRequest.setHeader(CRMS_Constants.REQUEST_HEADER_DATE, CRMS_Util.generateDateForAuth());
        CalloutRequest.setHeader(CRMS_Constants.REQUEST_HEADER_AUTH, CRMS_Util.generateAuthKey(Method, APIEndpoint)); 
        CalloutRequest.setMethod(Method);    	
      	CalloutRequest.setEndpoint(Label.DWH_Endpoint + APIEndpoint + Param);
      	CalloutRequest.setTimeout(CRMS_Constants.CALLOUT_DEFAULT_TIMEOUT);      	                    	
      	return CalloutRequest;
	}
	
	/**
	 * Take HttpRequest Object as parameter and Returns HttpResponse	 	  	 
	 * This is Synchronous CallOut Request
	 * Return NULL on Exceptions	 
	 */
	 
	private static HttpResponse Execute(HttpRequest Request){		
		try{            
            return new http().send(Request);
        }catch(System.CalloutException e) {            
            return null;
        }		
	}
	
	/*
     *  CalloutGet to make GET request to AMP DWH remote site.
     *  Returns Response on successfull callout.
     *	Return Null on Exception or on other than 200 status code 
     *	This requires following parameters.
     *  
     *  @EndpointURL : Endpoint URL like /api/LoanLedger
     *  
     *  @QueryStringParam : URL Parameters like ?LoanId=.
     *     
     */ 
		
	public static string CallOutGET(string EndpointURL, string QueryStringParam){
		
		HttpRequest Request = CreateRequest(CRMS_Constants.CALLOUT_METHOD_GET, EndpointURL, QueryStringParam);				
		if(!Test.isRunningTest()){
			HttpResponse CalloutResponse = Execute(Request);							
			if(CalloutResponse != null && (CalloutResponse.getStatusCode() == 200 || CalloutResponse.getStatus() == 'OK')){
				return CalloutResponse.getBody();
			}
		}
		return null;
	}
    
    public static Map<String, Object> GetResultsMapFromResponse(string response)
    {
        if(response == null)
       	{
           throw new AMPException('Http Response body is empty');
       	}
                
        Map<String, Object> responseMap =  (Map<String, Object>)JSON.deserializeUntyped(response); 
        List<Object> responseResultsList = (List<Object>)responseMap.get('results');
        
        if (responseResultsList == null)
        {
            throw new AMPException('Http Response contains no results');
        }
        
        return (Map<String, Object>)responseResultsList[0];  
    }
}