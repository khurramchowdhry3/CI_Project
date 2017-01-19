/**
 * AMP Sync Application
 * 
 * This file is the part of the AMP Sync Application used for some utility functions
 * 
 * Copyright (c) 2016 - xoomworks.com
 * 
 * @author Khurram Shahzad (Sr. Software Engineer .at. XoomWorks) <a href="http://www.xoomworks.com/">XoomWorks</a>
 * @created 2016
 * 
 * Class for utility functions, which are used in whole application.
 *
 */
 
public with sharing class AMPSyncApp_Util {
	
        
    
    //Method to return the authorization key for callout
    public static String generateAuthKey(String calloutMethod, String endpoint){
        String signature = calloutMethod + '\n\n\n' + AMPSyncApp_Constants.CURRENT_DATETIME_IN_GMT + '\n' + endpoint;       
        Blob Base64_AuthKey = EncodingUtil.base64Decode(Label.Auth_Shared_Key);
        Blob dataToHmac = Blob.valueOf(signature);
        Blob hmacComputeHash = Crypto.generateMac('hmacSHA256', dataToHmac, Base64_AuthKey);
        return EncodingUtil.base64Encode(hmacComputeHash);
    }
    
    public static String getSObjectAPIName(ID ObjectId){
    	if(ObjectId != null)
    		return ObjectId.getSObjectType().getDescribe().getName();
    	return null;
    }
    
    public static String getSObjectAPIName(Sobject ObjectRec){
    	if(ObjectRec != null)
    		return ObjectRec.getSObjectType().getDescribe().getName();
    	return null;
    }
    
    public static map<string, Schema.Sobjectfield> getSobjectFields(SObject ObjectRec){
    	if(ObjectRec != null)    		
    		return Id.valueOf(ObjectRec.Id).getSObjectType().getDescribe().fields.getMap();
    	return null;
    }
    
    public static list<Schema.FieldSetMember> getSobjectFieldsSet(ID ObjectId, string ObjectAPIName){
    	if(ObjectId != null)
    		return Id.valueOf(ObjectId).getSObjectType().getDescribe().fieldsets.getMap().get(AMPSyncApp_Constants.mapObjectNameFieldSet.get(ObjectAPIName)).getFields();
    	return null;
    }
    
    public static boolean IsPersonAccount(SObject ObjectRec){
    	if(ObjectRec.getSObjectType() == Account.getSObjectType() 
    		&&	((boolean)ObjectRec.get('isPersonAccount') == true)){
    		return true;
    	}
    	return false;
    }
}