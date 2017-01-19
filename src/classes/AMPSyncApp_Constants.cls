/**
 * AMP Sync Application
 * 
 * This file is the part of the AMP Sync Application used for AMP Sync App Constants
 * 
 * Copyright (c) 2016 - xoomworks.com
 * 
 * @author Khurram Shahzad (Sr. Software Engineer .at. XoomWorks) <a href="http://www.xoomworks.com/">XoomWorks</a>
 * @created 2016
 * 
 * Class of App Constants.
 *  
 */  
 
public with sharing class AMPSyncApp_Constants {
	
	public static String CALLOUT_EXCEPTION;
	public static final map<string,string> CALLOUT_METHOD_MAP = new map<string, string>{
		'Delete'	=>	'DELETE',
		'Insert'	=>	'POST',
		'Create'	=>	'POST',
		'Update'	=>	'POST'		
	};	
	public static final String AMP_INTEGRATION_USER = 'dwhsvc02@amp-creditech.com.devgold';
	public static final String SYNC_FAILURE_REASON = 'Not Synced Yet';
	public static final String SYNC_STATUS = 'Pending';
	public static final String CALLOUT_METHOD_GET = 'GET';
    public static final String SYNC_ACTION_DELETE = 'Delete';
    public static final String SYNC_ACTION_UPDATE = 'Update';
    public static final String SYNC_ACTION_INSERT = 'Insert';
    public static final String SYNC_ACTION_CREATE = 'Create';
    public static final String CALLOUT_PARAM_JSON_DATA = 'jsonData';
    public static final String CONTENT_TYPE = 'content-type';
    public static final String CONTENT_TYPE_JSON = 'application/json';
    public static final Integer CALLOUT_DEFAULT_TIMEOUT = 60000;
    public static final Integer CALLOUT_RESPONSE_CODE = 200;
    public static final string CALLOUT_RESPONSE_STATUS = 'OK';
    public static final string SYNC_STATUS_FAIL = 'Pending';
    public static final string SYNC_STATUS_SUCCESS = 'Success';    
    public static final String REQUEST_HEADER_DATE = 'x-amp-date';
    public static final String REQUEST_HEADER_AUTH = 'x-amp-auth';
    public static final string CURRENT_DATETIME_IN_GMT = datetime.now().formatGmt('EEE, dd MMM yyyy HH:mm:ss') + ' GMT';
    public static final String REMOTE_SITE_URL = Label.DWH_Endpoint;    
    public static final map<string, Endpoints__c> SOBJECT_ENDPOINTS_MAP = Endpoints__c.getAll();
    public static final map<string, string> mapObjectNameFieldSet = new map<String, String>{
                                                    'Lead' 		=> 'DWH_Lead',
                                                    'Account' 	=> 'DWH_Account',
                                                    'Case' 		=> 'DWH_Case',
                                                    'Contact' 	=> 'DWH_Contacts',
                                                    'Credit_Assessment__c' 	=> 'DWH_Credit_Assessment',
                                                    'Operation__c' 			=> 'DWH_Operations',
                                                    'Opportunity' 			=> 'DWH_Opportunity',
                                                    'Guarantors__c' 		=> 'DWH_ODG',
                                                    'User' 					=> 'DWH_User',
                                                    'Campaign' 				=> 'DWH_Campaign',
                                                    'Task' 					=> 'DWH_Task',
                                                    'PersonAccount' 		=> 'DWH_PersonAccount', 
                                                    'Additional_Debt__c' 	=> 'Additional_Debt',
                                                    'Product2' 				=> 'DWH_Product',
                                                    'Program__c' 			=> 'DWH_Program',
                                                    'Program_Product_ASO__c' 	=> 'DWH_Product_Program_Combination',
                                                    'Reward__c' 				=> 'DWH_Reward',
                                                    'Loan_Management__c' 		=> 'DWH_Loan_Management',
                                                    'Loan_Ledger__c' 			=> 'DWH_Loan_Ledger',
                                                    'Loan_Management_Event__c' 	=> 'DWH_Loan_Management_Event'   
	};
}