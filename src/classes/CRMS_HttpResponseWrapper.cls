/**
    Wrapper class for storing the response from the Http Callouts
    Author: Saket Joshi
    Version: 1.0
*/

public without sharing class CRMS_HttpResponseWrapper {

    private String requestId;
    private DateTime timestamp;
    private String objectName;
    private String responseMessage;
    private List<RecordResultWrapper> results;
    
    //Default constructor
    public CRMS_HttpResponseWrapper() { }
    
    public void setResponseMessage(String responseMessage) {
        this.responseMessage = responseMessage;
    } 
    
    public String getResponseMessage() {
        return responseMessage;
    }
    
    public void setRequestId(String requestId) {
        this.requestId = requestId;
    }
    
    public String getRequestId() {
        return requestId;
    }
    
    public void setTimestamp(DateTime timestamp) {
        this.timestamp = timestamp;
    }
    
    public DateTime getTimestamp() {
        return timestamp;
    }
    
    public void setObjectName(String objectName) {
        this.objectName = objectName;
    }
    
    public String getObjectName() {
        return objectName;
    }
    
    //Method to set the record id
    public void setResults(List<RecordResultWrapper> results) {
        this.results = results;
    }
    
    //Method to get the record id
    public List<RecordResultWrapper> getResults() {
        return results;
    }
    
    //Wrapper for record id and respective success code
    public class RecordResultWrapper {
        private String salesForceId;
        private Boolean success;
        private String reason;
        
        public RecordResultWrapper() { }
        
        public RecordResultWrapper(String salesForceId, Boolean success, String reason) {
            this.salesForceId = salesForceId;
            this.success = success;
            this.reason = reason;
        }
        
        public void setSalesForceId(String salesForceId) {
            this.salesForceId = salesForceId;
        }
        
        public String getSalesForceId() {
            return salesForceId;
        }
        
        public void setSuccess(Boolean success) {
            this.success = success;
        }
        
        public Boolean getSuccess() {
            return success;
        }
        
        public void setReason(String reason) {
            this.reason = reason;
        }
        
        public String getReason() {
            return reason;
        }
    }
}