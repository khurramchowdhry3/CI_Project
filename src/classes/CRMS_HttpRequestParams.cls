/**
    Container class for the Http Callout parameters
    Author: Saket Joshi
    Version: 1.0
*/

public without sharing class CRMS_HttpRequestParams {

    private String endpointUrl;
    private String calloutMethod;
    private String requestBody;
    private Map<String, String> requestHeaders;
    private Map<String, String> requestParams;
    private Integer timeoutValue;
    
    //Constructor accepting required values
    public CRMS_HttpRequestParams(String endpointUrl, String calloutMethod) {
        this.endpointUrl = endpointUrl;
        this.calloutMethod = calloutMethod;
    }
    
    //Method to get the endpoint url
    public String getEndpointUrl() {
        return endpointUrl;
    }
    
    //Method to get callout method type
    public String getCalloutMethod() {
        return calloutMethod;
    }
    
    /*Method to add a new param to existing request body
    public void addParamToBody(String paramName, String paramValue) {
        if(this.requestBody == null)
            this.requestBody = new Map<String, String> ();
        this.requestBody.put(paramName, paramValue);
    }*/
    
    //Method to set the request body
    public void setRequestBody(String requestBody) {
        this.requestBody = requestBody;
    }
    
    //Method to get the request body
    public String getRequestBody() {
        return requestBody;
    }
    
    /*Method to get the value of individual request body header
    public String getRequestBodyParam(String paramName) {
        return getParamFromMap(this.requestBody, paramName);
    }*/
    
    //Method to add new value to existing request headers
    public void addParamToHeaders(String paramName, String paramValue) {
        if(this.requestHeaders == null)
            this.requestHeaders = new Map<String, String> ();
        this.requestHeaders.put(paramName, paramValue);
    }
    
    //Method to get the map of the request headers
    public Map<String, String> getRequestHeaders() {
        return requestHeaders;
    }
    
    //Method to get the value of specified request header
    public String getRequestHeaderParam(String paramName) {
        return getParamFromMap(this.requestHeaders, paramName);
    }
    
    //Method to add a new value to request params for GET method
    public void addParamToParams(String paramName, String paramValue) {
        if(this.requestParams == null)
            this.requestParams = new Map<String, String> ();
        this.requestParams.put(paramName, paramValue);
    }
    
    //Method to get the request param map for GET method
    public Map<String, String> getRequestParams() {
        return requestParams;
    }
    
    //Method to get specific param value for GET method 
    public String getRequestParamsParam(String paramName) {
        return getParamFromMap(this.requestParams, paramName);
    }
    
    //Setter method for timeout value
    public void setTimeoutValue(Integer timeoutValue) {
        this.timeoutValue = timeoutValue;
    }
    
    //Method to get the timeout value
    public Integer getTimeoutValue() {
        return timeoutValue;
    }
    
    //Method to get the param value from a map
    private String getParamFromMap(Map<String, String> mapToGetFrom, String paramName) {
        return mapToGetFrom.get(paramName);
    }
}