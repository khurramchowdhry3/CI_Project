/**
 * AMP Sync Application
 * 
 * This file is the part of the AMP Sync Application used to Process Response from Callout Activity
 * 
 * Copyright (c) 2016 - xoomworks.com
 * 
 * @author Khurram Shahzad (Sr. Software Engineer .at. XoomWorks) <a href="http://www.xoomworks.com/">XoomWorks</a>
 * @created 2016
 * 
 * Class to Process Response from Callout Activity
 *
 */
 
public with sharing class AMPSyncApp_Response {
	
	
   /*	
	*	Process Callout Response and Update Queue.
	*	This function is used to process response from CAIROS and update queue for related records.
	*	
	*	@Response	:	JSON encoded Response from CAIROS	
	*	@Objects	: 	List of record Id's which synched with CAIROS, 
	*					This required to update status for these records after getting response.
	*  
	*/
	
	public void ProcessCalloutResponse(string Response, list<ID> Objects){
		map<ID, String> ItemsToBeUpdated = new map<ID, String>();
		string ResponseDateTime = Datetime.now().format();
		
		if(Response != null && Response != ''){
			try{
				
				/* Deserialize JSON Response and Create Map of Object record id and its status Message to updated Queue */
				
				ResponseItems Items = (ResponseItems)Json.deserialize(Response, ResponseItems.class);
				system.debug('<<< Response Size >>> '+Items.results.size());								
				
				/*  Iterate over Response Results and create map of synced record ids with status message */ 
											
				for(ResponseDetail Res : Items.results){
					if(Res.salesForceId != null && Res.salesForceId != ''){
						if(Res.success){												
							ItemsToBeUpdated.put(Res.salesForceId,'');													
						}else ItemsToBeUpdated.put(Res.salesForceId,  ResponseDateTime + ' ' + Res.reason);
					
					}else{ 
					
						/*  If response doesn't contains salesforce Id then Iterate over List of Ids 
						 *  which we get from parameter.
						 *	
						 *	Verify corresponding value in map to avoid overwritting message for particualr Id.  
						 */
						
						for(ID Key : Objects){
							if(ItemsToBeUpdated.get(Key) == null){
								ItemsToBeUpdated.put(Key, ResponseDateTime + ' ' + Res.reason);								
							}
						}
					}	
				}								
			}catch(Exception ex){				
				for(ID Key : Objects){
					ItemsToBeUpdated.put(Key, ResponseDateTime + ' ' + Response);
				}
			}
		}else {
			 for(ID Key : Objects){
				ItemsToBeUpdated.put(Key, ResponseDateTime + ' ' + AMPSyncApp_Constants.CALLOUT_EXCEPTION);
			 }
		}		
		
		if(ItemsToBeUpdated != null)
			new AMPSyncApp_SyncQueue().UpdateQueue(ItemsToBeUpdated);
			new AMPSyncApp_SyncQueue().UpdateDWHSyncFlagInObjects(ItemsToBeUpdated);
	}
	
		
	public class ResponseItems{
		public String requestId;
	    public DateTime timestamp;
	    public String objectName;
	    public String responseMessage;
	    public List<ResponseDetail> results;
	}
	
	public class ResponseDetail{
		public String salesForceId;
        public Boolean success;
        public String reason;
      
        public ResponseDetail(String salesForceId, Boolean success, String reason) {
            this.salesForceId = salesForceId;
            this.success = success;
            this.reason = reason;
        }
	}
}