/**
    Wrapper for all the objects required to serialize for callout to DWH
    Author: Saket Joshi
    Version: 1.0
*/

public without sharing class CRMS_CalloutObjects {

    //Wrapper class for delete Json serialization
    public class DeleteWrapper {
        public String operationType;
        public String recordId;
        
        public DeleteWrapper(String recordId) {
            this.operationType = 'Delete';
            this.recordId = recordId;
        }
    }

    //Wrapper class for leads values for various records
    public class Values {
        public String operationType;
        public List<FieldInformation> fieldArray;
        
        //Default constructor
        public Values() {
            
        }
        
        //Parameterized constructor
        public Values(String operationType, List<FieldInformation> fieldArray) {
            this.operationType = operationType;
            this.fieldArray = fieldArray;
        }
    }

    //Wrapper for field information
    public class FieldInformation {
        public String fieldName;
        public String fieldValue;
        
        //Default constructor
        public FieldInformation() {
            
        }
        
        //Parameterized constructor
        public FieldInformation(String fieldName, String fieldValue) {
            this.fieldName = fieldName;
            this.fieldValue = fieldValue;
        }
    }

}