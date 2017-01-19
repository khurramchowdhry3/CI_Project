public with sharing class AMPSyncApp_Collection {
	
	public class Values {
    	public String operationType;
        public list<FieldInformation> fieldArray;        
        
        public Values(String operationType, list<FieldInformation> fieldArray) {
            this.operationType = operationType;
            this.fieldArray = fieldArray;
        }
    }
    
    public class FieldInformation {
        public String fieldName;
        public String fieldValue;             
       
        public FieldInformation(String fieldName, String fieldValue) {
            this.fieldName = fieldName;
            this.fieldValue = fieldValue;
        }
    }
    
    public class DeleteWrapper {
        public String operationType;
        public String recordId;
        
        public DeleteWrapper(String recordId) {
            this.operationType = 'Delete';
            this.recordId = recordId;
        }
    }
}