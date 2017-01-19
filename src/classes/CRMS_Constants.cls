/**
    Class for storing constant values
    Author: Saket Joshi
*/

public without sharing class CRMS_Constants {

    public static final String DWH_STATUS_QUEUED = 'Queued';
    public static final String DWH_STATUS_SYNCED = 'Synced';
    public static final String SYNC_QUEUE_STATUS_PENDING = 'Pending';
    public static final String SYNC_QUEUE_STATUS_SUCCESS = 'Success';
    public static final String DWH_DATA_TYPE_CASE = 'Case';
    public static final String DWH_DATA_TYPE_ODG = 'ODG';
    public static final String DWH_DATA_TYPE_USER = 'User';
    public static final String DWH_DATA_TYPE_CONTACT = 'Contact';
    public static final String DWH_DATA_TYPE_LEAD = 'Lead';
    public static final String DWH_DATA_TYPE_TASK = 'Task';
    public static final String DWH_DATA_TYPE_ACCOUNT = 'Account';
    public static final String DWH_DATA_TYPE_OPPORTUNITY = 'Opportunity';
    public static final String DWH_DATA_TYPE_OPERATION = 'Operation';
    public static final String DWH_DATA_TYPE_CREDIT_ASSESSMENT = 'Credit Assessment';
    public static final String DWH_DATA_TYPE_CAMPAIGN = 'Campaign';
    public static final String DWH_DATA_TYPE_PROGRAM = 'Program';
    public static final String DWH_DATA_TYPE_PRODUCT = 'Product';
    public static final String DWH_DATA_TYPE_PPAS = 'Program Product Association';
    public static final String DWH_DATA_TYPE_REWARD = 'Reward';
    public static final String DWH_DATA_TYPE_LOAN_MANAGEMENT = 'Loan Management';
    public static final String DWH_DATA_TYPE_LOAN_LEDGER = 'Loan Ledger';
    public static final String DWH_DATA_TYPE_LOAN_MANAGEMENT_EVENT = 'Loan Management Event';
    public static final String SYNC_STATUS_DELETE = 'Delete';
    public static final String SYNC_STATUS_STALE = 'Stale';
    public static final String DWH_CREATED_BY_TRIGGER = ' DWH Created by Trigger';
    public static final String DWH_DELETE_TRIGGER = ' DWH Delete by Trigger';
    public static final String SYNC_ACTION_DELETE = 'Delete';
    public static final String SYNC_ACTION_UPDATE = 'Update';
    public static final String SYNC_ACTION_INSERT = 'Insert';
    public static final String SYNC_ACTION_CREATE = 'Create';
    public static final String SYNC_STATUS_CONTACT_DELETED = ': Contact deleted';
    public static final String SYNC_STATUS_LEAD_DELETED = ': Lead deleted';
    public static final String SYNC_STATUS_TASK_DELETED = ': Task deleted';
    public static final String SYNC_STATUS_ODG_DELETED = ': O/D/G deleted';
    public static final String SYNC_STATUS_ACCOUNT_DELETED = ': Account deleted';
    public static final String SYNC_STATUS_OPPORTUNITY_DELETED = ': Opportunity deleted';
    public static final String SYNC_STATUS_OPERATION_DELETED = ': Operation deleted';
    public static final String SYNC_STATUS_CREDIT_ASSESSMENT_DELETED = ': Credit Assessment deleted';
    public static final String SYNC_STATUS_PROGRAM_DELETED = ': Program deleted';
    public static final String SYNC_STATUS_PRODUCT_DELETED = ': Product deleted';
    public static final String SYNC_STATUS_PPAS_DELETED = ': Program Product Combination deleted';
    public static final String SYNC_STATUS_REWARD_DELETED = ': Reward deleted';
    public static final String SYNC_STATUS_LOAN_MANAGEMENT_DELETED = ': Rules Engine deleted';
    public static final String SYNC_STATUS_LOAN_LEDGER_DELETED = ': Loan Ledger deleted';
    public static final String SYNC_STATUS_LOAN_MANAGEMENT_EVENT_DELETED = ': Loan Management Event deleted';
    public static final String CALLOUT_METHOD_GET = 'GET';
    public static final String CALLOUT_METHOD_POST = 'POST';
    public static final String CALLOUT_METHOD_PUT = 'PUT';
    public static final String CALLOUT_METHOD_PATCH = 'PATCH';
    public static final String CALLOUT_METHOD_DELETE = 'DELETE';
    public static final String CALLOUT_PARAM_JSON_DATA = 'jsonData';
    public static final String CONTENT_TYPE = 'content-type';
    public static final String CONTENT_TYPE_JSON = 'application/json';
    public static final String AMP_ENDPOINT_URL = 'https://test.salesforce.com';
    public static final String CALLOUT_RESPONSE_SUCCESS = 'SUCCESS';
    public static final String CALLOUT_RESPONSE_JSON_PARAM_MISSING = 'JSON DATA MISSING';
    public static final String CALLOUT_RESPONSE_ERROR = 'ERROR';
    public static final Integer CALLOUT_DEFAULT_TIMEOUT = 30000;
    public static final Integer CALLOUT_RESPONSE_OK = 200;
    public static final String LEAD_CREATED_RESPONSE = ' Callout response: ';
    public static final String BATCH_RESPONSE_ERROR = ' XYXY XXX by batch, callout response: ';
    public static final String BATCH_RESPONSE_SUCCESS = ' XYXY XXX by batch ';
    public static final String BATCH_NO_ACTION_NEEDED = ' DWH no action needed by batch';
    public static final String API_ENDPOINT_LEADS = 'Lead';
    public static final String SHAREPOINT_DEV_ENDPOINT = 'https://advancedpay.sharepoint.com/sites/ampdev/';
    public static final String SHAREPOINT_QA_ENDPOINT = 'https://advancedpay.sharepoint.com/sites/QA/';
    public static final String SHAREPOINT_PROD_ENDPOINT = 'https://sharepoint.amp-creditech.com/sites/clientdocs/'; 
   
    // Inline send Email 
    public static final string docName = 'Application Document Alert';
    public static final string hongKong = 'Hong Kong';
    public static final string hk = 'HK';
    public static final string hkTemplate = 'Application Document Alert HK';
    
    public static final string uk = 'UK';
    public static final string ukTemplate = 'Application Document Alert UK';
    
    public static final string singapore = 'Singapore';
    public static final string sg = 'SG';
    public static final string sgTemplate = 'Application Document Alert SG';
    
    public static final string philippines = 'Philippines';
    public static final string ph = 'PH';
    public static final string phTemplate = 'Application Document Alert PH';
    
    public static final Map<String, String> mapDataTypeObjectName;
    public static final Map<String, String> mapDataTypeObjectApiName;
    public static final Map<String, String> mapApiNameDataType;
    public static final Map<String, String> mapObjectNameFieldSet;
    static {
        mapDataTypeObjectName = new Map<String, String> { 'Account' => 'Account__c',
                                                    'Case' => 'Case__c',
                                                    'Contact' => 'Contact__c',
                                                    'Credit Assessment' => 'Credit_Assessment__c',
                                                    'Lead' => 'Lead__c',
                                                    'ODG' => 'ODG__c',
                                                    'Operation' => 'Operation__c',
                                                    'Opportunity' => 'Opportunity__c',
                                                    'User' => 'User__c',
                                                    'Campaign' => 'Campaign__c',
                                                    'Task' => 'Task_Id__c',
                                                    'Additional Debt' => 'Additional_Debt__c',
                                                    'Product' => 'Product2' ,
                                                    'Program' => 'Program__c' ,
                                                    'Program Product Association' => 'Program_Product_ASO__c',
                                                    'Reward' => 'Reward__c',            
            										'Loan Management'  => 'Loan_Management__c',
            										'Loan Ledger' => 'Loan_Ledger__c',
            										'Loan Management Event' => 'Loan_Management_Event__c'
            };
        
        mapDataTypeObjectApiName =  new Map<String, String> { 'Account' => 'Account',
                                                    'Case' => 'Case',
                                                    'Contact' => 'Contact',
                                                    'Credit Assessment' => 'Credit_Assessment__c',
                                                    'Lead' => 'Lead',
                                                    'ODG' => 'Guarantors__c',
                                                    'Operation' => 'Operation__c',
                                                    'Opportunity' => 'Opportunity',
                                                    'User' => 'User',
                                                    'Campaign' => 'Campaign',
                                                    'Task' => 'Task',
                                                    'Additional Debt' => 'Additional_Debt__c',
                                                    'Product' => 'Product2' ,
                                                    'Program' => 'Program__c' ,
                                                    'Program Product Association' => 'Program_Product_ASO__c',
                                                    'Reward' => 'Reward__c',            
            										'Loan Management'  => 'Loan_Management__c',
            										'Loan Ledger' => 'Loan_Ledger__c',
            										'Loan Management Event' => 'Loan_Management_Event__c'
            };
        
        mapApiNameDataType = new Map<String, String> { 'Account' => 'Account',
                                                    'Case' => 'Case',
                                                    'Contact' => 'Contact',
                                                    'Credit_Assessment__c' => 'Credit Assessment',
                                                    'Lead' => 'Lead',
                                                    'Guarantors__c' => 'ODG',
                                                    'Operation__c' => 'Operation',
                                                    'Opportunity' => 'Opportunity',
                                                    'User' => 'User',
                                                    'Campaign' => 'Campaign',
                                                    'Task' => 'Task',
                                                    'Additional_Debt__c' => 'Additional Debt',
                                                    'Product2' => 'Product' ,
                                                    'Program__c' => 'Program' ,
                                                    'Program_Product_ASO__c' => 'Program Product Association',
                                                    'Reward__c' => 'Reward',
            										'Loan_Management__c'  => 'Loan Management',
            										'Loan_Ledger__c' => 'Loan Ledger',
            										'Loan_Management_Event__c' => 'Loan Management Event'
            };
                                                    
        mapObjectNameFieldSet = new Map<String, String>{
                                                    'Lead' => 'DWH_Lead',
                                                    'Account' => 'DWH_Account',
                                                    'Case' => 'DWH_Case',
                                                    'Contact' => 'DWH_Contacts',
                                                    'Credit_Assessment__c' => 'DWH_Credit_Assessment',
                                                    'Operation__c' => 'DWH_Operations',
                                                    'Opportunity' => 'DWH_Opportunity',
                                                    'Guarantors__c' => 'DWH_ODG',
                                                    'User' => 'DWH_User',
                                                    'Campaign' => 'DWH_Campaign',
                                                    'Task' => 'DWH_Task',
                                                    'PersonAccount' => 'DWH_PersonAccount', 
                                                    'Additional_Debt__c' => 'Additional_Debt',
                                                    'Product2' => 'DWH_Product',
                                                    'Program__c' => 'DWH_Program',
                                                    'Program_Product_ASO__c' => 'DWH_Product_Program_Combination',
                                                    'Reward__c' => 'DWH_Reward',
                                                    'Loan_Management__c' => 'DWH_Loan_Management',
                                                    'Loan_Ledger__c' => 'DWH_Loan_Ledger',
                                                    'Loan_Management_Event__c' => 'DWH_Loan_Management_Event'   
                                                    };
    }
    
    public static final String REQUEST_HEADER_DATE = 'x-amp-date';
    public static final String REQUEST_HEADER_AUTH = 'x-amp-auth';
    
}