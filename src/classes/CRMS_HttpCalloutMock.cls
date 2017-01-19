/**
	Class for generating mock Http response
	Author: Saket Joshi
	Version: 1.0
*/

@isTest
global class CRMS_HttpCalloutMock implements HttpCalloutMock {

	static Integer isResponseAlreadyGiven = Math.mod(Integer.valueOf(Math.random() * 10), 2);

	global HttpResponse respond(HttpRequest req) {
		HttpResponse res = new HttpResponse();
		res.setHeader(CRMS_Constants.CONTENT_TYPE, CRMS_Constants.CONTENT_TYPE_JSON);
		if(req.getMethod().equals(CRMS_Constants.CALLOUT_METHOD_GET)) {		//Callout method is GET
			if(req.getEndpoint().contains(CRMS_Constants.CALLOUT_PARAM_JSON_DATA))
				res.setBody(generateResponseJson(req.getBody()));
			else
				res.setBody(generateResponseMissingJson());
		} //End of if callout method is GET
		else {
			if(isResponseAlreadyGiven == 0) {
				res.setBody(generateResponseJson(req.getBody()));
				isResponseAlreadyGiven = Math.mod(Integer.valueOf(Math.random() * 10), 2);
			} //End of if response is not given
			else {
				isResponseAlreadyGiven = Math.mod(Integer.valueOf(Math.random() * 10), 2);
				res.setBody(generateResponseError('Error'));
				return res;
			} //End of else response is not given
		} //End of if callout method is POST
		return res;
	}

	//Method to return Json serialized string for success
	private String generateResponseJson(String requestBody) {
		CRMS_HttpResponseWrapper objResponse = new CRMS_HttpResponseWrapper();
		objResponse.setResponseMessage(CRMS_Constants.CALLOUT_RESPONSE_SUCCESS);
		
		List<CRMS_HttpResponseWrapper.RecordResultWrapper> lstResultWrapper = new List<CRMS_HttpResponseWrapper.RecordResultWrapper> ();
		
		List<CRMS_CalloutObjects.Values> requestArray = new List<CRMS_CalloutObjects.Values> ();
		try {
			requestArray = (List<CRMS_CalloutObjects.Values>) Json.deserialize(requestBody, List<CRMS_CalloutObjects.Values>.class);
			List<String> lstId = new List<String> ();

			//For every object for every field of that object, if field is ID, populate the list
			for(CRMS_CalloutObjects.Values objValue : requestArray) {
				if(objValue.fieldArray != null && !objValue.fieldArray.isEmpty())
					for(CRMS_CalloutObjects.FieldInformation fieldInfo : objValue.fieldArray)
						if(fieldInfo.fieldName.equals('Id'))
							lstId.add(fieldInfo.fieldValue);
			} //Traverse every record in the request and set the response values
			
			if(lstId != null && !lstId.isEmpty())
				for(String strId : lstId) {
					Integer randomNumber = Math.mod(Integer.valueOf(Math.random() * 10), 2);
					lstResultWrapper.add ( new CRMS_HttpResponseWrapper.RecordResultWrapper (
										strId,
										randomNumber == 0 ? true : false,
										randomNumber == 0 ? 'Success' : 'Error'
									) );
				} //End of for every Id
			
			objResponse.setResults(lstResultWrapper);
			return Json.serialize(objResponse);
		} //End of try deserialize
		catch (System.JsonException ex) {
			return generateResponseError(ex.getMessage());
		} //End of catch JsonException
	}
	
	//Method to return Json serialized string for error
	private String generateResponseMissingJson() {
		CRMS_HttpResponseWrapper objResponse = new CRMS_HttpResponseWrapper();
		objResponse.setResponseMessage(CRMS_Constants.CALLOUT_RESPONSE_JSON_PARAM_MISSING);
		
		return Json.serialize(objResponse);
	}
	
	//Method to return Json serialized string for error
	private String generateResponseError(String errorMessage) {
		CRMS_HttpResponseWrapper objResponse = new CRMS_HttpResponseWrapper();
		objResponse.setResponseMessage(errorMessage);
		
		return Json.serialize(objResponse);
	}
} // end of class