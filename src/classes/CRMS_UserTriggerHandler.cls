/**
    Handler for trigger on user object
    Author: Saket Joshi
    Version: 1.0
*/

public class CRMS_UserTriggerHandler {
    
    public static Boolean isTriggerCalled = false; 
    public static Boolean isTriggerCalledInsert = false; 
    
    //Method to set the DWH_Status to Synced for ODG
    public void setDwhStatusSynced(List<User> lstUsers) {
        for(User objUser : lstUsers) {
            objUser.DWH_Last_Sync__c = Datetime.now();
        }
    }
    
    //Method to set the DWH_Status to Queued for ODG
    public void setDwhStatusQueued(List<User> lstUsers) { 
        for(User objUser : lstUsers)
            objUser.DWH_Status__c = CRMS_Constants.DWH_STATUS_QUEUED;
    }
}