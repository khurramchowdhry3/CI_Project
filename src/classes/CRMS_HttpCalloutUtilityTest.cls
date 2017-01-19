/**
	Test class for the Http callout utility class
	Author: Saket Joshi
	Version: 1.0
*/

@isTest
public with sharing class CRMS_HttpCalloutUtilityTest {

	//Method to test the Http callout for GET method without Url Params
	@isTest
	static void testGetCalloutWithoutParams() {
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		
		CRMS_HttpRequestParams objRequestParams = new CRMS_HttpRequestParams(CRMS_Constants.AMP_ENDPOINT_URL, CRMS_Constants.CALLOUT_METHOD_GET);
		
		CRMS_HttpResponseWrapper objResponse = CRMS_HttpCalloutUtility.doCallout(objRequestParams);
		//system.assertEquals(401, objResponse.getResponseCode());
		system.assertEquals(null, objResponse.getObjectName());
	}
	
	//Method to test the Http callout for GET method with Url params
	@isTest
	static void testGetCalloutWithParams() {
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		
		CRMS_HttpRequestParams objRequestParams = new CRMS_HttpRequestParams(CRMS_Constants.AMP_ENDPOINT_URL, CRMS_Constants.CALLOUT_METHOD_GET);
		objRequestParams.addParamToParams(CRMS_Constants.CALLOUT_PARAM_JSON_DATA, '{"dummy":"value"}');
		
		CRMS_HttpResponseWrapper objResponse = CRMS_HttpCalloutUtility.doCallout(objRequestParams);
		
		system.assertEquals(null, objResponse.getObjectName());
	}
	
	//Method to test Http callout for POST method with body and headers
	@isTest
	static void testPostCalloutWithBodyHeaders() {
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		
		CRMS_HttpRequestParams objRequestParams = new CRMS_HttpRequestParams(CRMS_Constants.AMP_ENDPOINT_URL, CRMS_Constants.CALLOUT_METHOD_POST);
		objRequestParams.setRequestBody('{"dummy":"value"}');
		objRequestParams.addParamToHeaders(CRMS_Constants.CONTENT_TYPE, CRMS_Constants.CONTENT_TYPE_JSON);
		objRequestParams.setTimeoutValue(30000);
		
		CRMS_HttpResponseWrapper objResponse = CRMS_HttpCalloutUtility.doCallout(objRequestParams);
		
		system.assertEquals(null, objResponse.getObjectName());
	}

}