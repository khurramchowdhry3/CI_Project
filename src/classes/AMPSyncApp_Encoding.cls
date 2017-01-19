/**
 * AMP Sync Application
 * 
 * This file is the part of the AMP Sync Application used to make easy to gain access of current Encoding Classes
 * 
 * Copyright (c) 2016 - xoomworks.com
 * 
 * @author Khurram Shahzad (Sr. Software Engineer .at. XoomWorks) <a href="http://www.xoomworks.com/">XoomWorks</a>
 * @created 2016
 * 
 * Class to make it easy to gain access to the current Encoding Classes in use. 
 * For Example you can use JSONEncode() function to access JSONConverter Class methods.
 *
 */
public with sharing class AMPSyncApp_Encoding {
		
	private static AMPSyncApp_JSONConverter Encoder = null;
    
    /**
     * prevent instantiation of this class
     */
     
    private AMPSyncApp_Encoding(){}
    
    /**
     * Return the current AMPSyncApp_JSONConverter Object returns JSON representation of value. 
     */
     
    public static AMPSyncApp_JSONConverter JSON_Encode() {
        if (Encoder == null) {
            Encoder =  new AMPSyncApp_JSONConverter();
        } 
        return Encoder;
    }
}