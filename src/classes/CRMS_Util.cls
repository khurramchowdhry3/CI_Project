/**
    CRMS_Util class
    Author : CRM Superstars
    Version: 1.0
*/
public without sharing class CRMS_Util {
    public static final String DWH_STATUS_QUEUED = 'Queued';
    public static final String DWH_STATUS_SYNCED = 'Synced';
    public static final String SYNC_QUEUE_STATUS_PENDING = 'Pending';
    public static final String DWH_DATA_TYPE_CONTACT = 'Contact';
    public static final String DWH_DATA_TYPE_LEAD = 'Lead';
    public static final String DWH_DATA_TYPE_TASK = 'Task';
    public static final String DWH_DATA_TYPE_ACCOUNT = 'Account';
    public static final String DWH_DATA_TYPE_OPPORTUNITY = 'Opportunity';
    public static final String DWH_DATA_TYPE_OPERATION = 'Operation';
    public static final String DWH_DATA_TYPE_CREDIT_ASSESSMENT = 'Credit Assessment';
    public static final String SYNC_STATUS_DELETE = 'Delete';
    public static final String SYNC_STATUS_STALE = 'Stale';
    public static final String DWH_DELETE_TRIGGER = 'DWH Delete by Trigger';
    public static final String SYNC_ACTION_DELETE = 'Delete';
    public static final String SYNC_STATUS_CONTACT_DELETED = ': Contact deleted';
    public static final String SYNC_STATUS_LEAD_DELETED = ': Lead deleted';
    public static final String SYNC_STATUS_TASK_DELETED = ': Task deleted';
    public static final String SYNC_STATUS_ODG_DELETED = ': O/D/G deleted';
    public static final String SYNC_STATUS_ACCOUNT_DELETED = ': Account deleted';
    public static final String SYNC_STATUS_OPPORTUNITY_DELETED = ': Opportunity deleted';
    public static final String SYNC_STATUS_OPERATION_DELETED = ': Operation deleted';
    public static final String SYNC_STATUS_CREDIT_ASSESSMENT_DELETED = ': Credit Assessment deleted';
    public Integer count = 0;
    public Task initializeTask(Boolean isInsert){
        Task task = new Task();
        task.OwnerId = UserInfo.getUserId();
        task.Subject = 'Send Test Letter';
        task.Status = 'Not Started';
        task.Priority = 'Normal';
        
        if(isInsert){
            insert task;
        }
        return task;
    }
    
    public Lead initializeLead(Boolean isInsert){
        Lead leadObj = new Lead();
        leadObj.LastName ='Holmes';
        leadObj.FirstName ='Sherlock';
        leadObj.Business_Position__c = 'Owner';
        leadObj.Status ='Open';
        
        if(isInsert){
            insert leadObj;
        }
        return leadObj;
    }
    
    public Account initializeAccount(Boolean isInsert){
        count++;
        Account account = new Account();
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name LIKE '%System Administrator%' LIMIT 1];
        User newUser = generateAdminUser(sysAdminProfile.id);
        newUser.UserName = 'testclasses'+count+'@testclassuser.com';
        insert newUser;
        account.Name = 'Test Account1';
        account.Account_Manager__c = newUser.id;
        if(isInsert){
            insert account;
        }
        return account; 
        
    }
    
    public Opportunity initializeOpportunity(Boolean isInsert) {
        
        Account account = initializeAccount(true);
        
        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Test Opportunity';
        opportunity.AccountId = account.Id;
        opportunity.Loan_Purpose__c = 'Inventory';
        opportunity.CloseDate = Date.today();
        opportunity.StageName = 'In Progress';
        opportunity.Application_ID2__c = '200542001';
        opportunity.Contract_Signed__c = true;
        opportunity.Contract_Signed_Date__c = date.parse(date.today().format()).addDays(-30);
        
        if (isInsert) {
            insert opportunity;
        }
        return opportunity; 
    }
    public Operation__c initializeOperation(Boolean isInsert) {
        Account account = initializeAccount(true);
        Opportunity opportunity = initializeOpportunity(true);
        
        Operation__c operation = new Operation__c();
        operation.Account__c = account.Id;
        operation.Opportunity__c = opportunity.Id;
        
        if(isInsert){
            insert operation;
        }
        return operation;   
    }
    
    public Credit_Assessment__c initializeCreditAssessment(Boolean isInsert) {
        Opportunity opportunity = initializeOpportunity(true);
        
        Credit_Assessment__c creAssessment = new Credit_Assessment__c();
        creAssessment.Opportunity__c = opportunity.Id;
        
        
        if (isInsert) {
            insert creAssessment;
        }
        return creAssessment;   
    }
    
    public static List<Contact> generateContactList(Integer numberOfContacts, Boolean isInsert, Id accountId) {
        List<Contact> lstContacts = new List<Contact> ();
        RecordType contactType = [SELECT Id FROM RecordType WHERE Name = 'Contact' LIMIT 1];
        for(Integer i = 0; i < numberOfContacts; i++) {
            lstContacts.add(new Contact(Salutation__c = 'Dr.',
                                        FirstName = 'Test',
                                        LastName = 'Contact',
                                        AccountId = accountId,
                                        RecordTypeId = contactType.Id));
        }
        
        if(isInsert)
            insert lstContacts;
        return lstContacts;
    }
    
    public static List<Campaign> generateCampaignList(Integer numberOfCampaigns, Boolean isInsert) {
        List<Campaign> lstCampaigns = new List<Campaign> ();
        for(Integer i = 0; i < numberOfCampaigns; i++){
            lstCampaigns.add(new Campaign(Name = 'Test Campaign ' + i));
        }
        
        if(isInsert)
            insert lstCampaigns;
        return lstCampaigns;
    }
    
    public static List<Guarantors__c> generateODGList(Integer numberOfRecords, Boolean isInsert, Id accountId, Id opportunityId) {
        List<Guarantors__c> lstGuarantors = new List<Guarantors__c> ();
        for(Integer i = 0; i < numberOfRecords; i++) {
            lstGuarantors.add(new Guarantors__c(Account__c = accountId,
                                        Opportunity__c = opportunityId,
                                        Email__c = 'testemail' + i + '@testdomain.com'));
        }
        
        if(isInsert)
            insert lstGuarantors;
        return lstGuarantors;
    }
    
    public static List<Case> generateCaseList(Integer numberOfRecords, Boolean isInsert) {
        List<Case> lstCases = new List<Case> ();
        for(Integer i = 0 ; i < numberOfRecords; i++) {
            lstCases.add(new Case(Status = 'New',
                                Origin = 'Web',
                                CurrencyIsoCode = 'USD'));
        }
        
        if(isInsert)
            insert lstCases;
        return lstCases;
    }
    
    public static List<User> generateUserList(Integer numberOfRecords, Boolean isInsert) {
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name LIKE '%System Administrator%' LIMIT 1];
        Profile chatterProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Chatter Free User' LIMIT 1];
        List<User> lstUsers = new List<User> ();
        
        if(sysAdminProfile != null && chatterProfile != null) {
            system.runAs(generateAdminUser(sysAdminProfile.Id)) {
                for(Integer i = 0; i < numberOfRecords; i++) {
                    lstUsers.add(new User(
                        LastName = 'LastName',
                        Alias = 'alias',
                        Email = 'freeuser' + i + '@testclass.com',
                        UserName = 'freeuser' + i + '@testclassuser.com',
                        ProfileId = chatterProfile.Id,
                        EmailEncodingKey = 'UTF-8',
                        LanguageLocaleKey = 'en_US',
                        LocalesIdKey = 'en_US',
                        TimezonesIdKey = 'America/Los_Angeles'
                    ));
                }
            }
        }
        if(isInsert)
            insert lstUsers;
        return lstUsers;
    }
    
    private static User generateAdminUser(Id profileId) {
        return new User(
            LastName = 'LastName',
            Alias = 'alias',
            Email = 'testuser@testclass.com',
            UserName = 'testclasses@testclassuser.com',
            ProfileId = profileId,
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocalesIdKey = 'en_US',
            TimezonesIdKey = 'America/Los_Angeles'
        );
    }
    
    // Uncomment and re deploy again
    //Method to generate the endpoint custom setting data
    public static void generateEndpoints(){
        List<Endpoints__c> lstEndpoints = new List<Endpoints__c> ();
        lstEndpoints.add( new Endpoints__c (Name='Lead', Value__c='/api/leads') );
        lstEndpoints.add( new Endpoints__c (Name='Opportunity', Value__c='/api/opportunity') );
        lstEndpoints.add( new Endpoints__c (Name='Contact', Value__c='/api/contact') );
        lstEndpoints.add( new Endpoints__c (Name='Account', Value__c='/api/account') );
        lstEndpoints.add( new Endpoints__c (Name='User', Value__c='/api/users') );
        lstEndpoints.add( new Endpoints__c (Name='Task', Value__c='/api/task') );
        lstEndpoints.add( new Endpoints__c (Name='Case', Value__c='/api/case') );
        lstEndpoints.add( new Endpoints__c (Name='Credit_Assessment__c', Value__c='/api/creditassessment') );
        lstEndpoints.add( new Endpoints__c (Name='Guarantors__c', Value__c='/api/odg') );
        lstEndpoints.add( new Endpoints__c (Name='Operation__c', Value__c='/api/operation') );
        lstEndpoints.add( new Endpoints__c (Name='Campaign', Value__c='/api/campaign') );        
        lstEndpoints.add( new Endpoints__c (Name='Additional_Debt__c', Value__c='/api/AdditionalDebts') );
        lstEndpoints.add( new Endpoints__c (Name='Program_Product_ASO__c', Value__c='/api/ProgramProducts') );
        lstEndpoints.add( new Endpoints__c (Name='Product2', Value__c='/api/Products') );
        lstEndpoints.add( new Endpoints__c (Name='Program__c', Value__c='/api/Programs') );
        lstEndpoints.add( new Endpoints__c (Name='Reward__c', Value__c='/api/Rewards') );
        lstEndpoints.add( new Endpoints__c (Name='Loan_Management__c', Value__c='/api/LoanManagements') );
        lstEndpoints.add( new Endpoints__c (Name='Loan_Management_Event__c', Value__c='/api/LoanManagementEvents') );
        insert lstEndpoints;
    }
    
    //Method to fetch the endpoint value for object fetched from record id
    public static String getEndpointValueForObject(Id recordId) {
        Map<String, Endpoints__c> mapEndpointNameValues = Endpoints__c.getAll();
        
        //If account is a person account then send the callout to contact endpoint
        if(recordId.getSObjectType() == Account.getSObjectType()) {
            List<Account> lstAccount = [SELECT isPersonAccount
                                        FROM Account
                                        WHERE Id =: recordId
                                        LIMIT 1];
            
            if(lstAccount != null && !lstAccount.isEmpty() && lstAccount.get(0).isPersonAccount) {
                if(mapEndpointNameValues.containsKey('Contact'))
                    return mapEndpointNameValues.get('Contact').Value__c;
                return '';
            } //End of if account is a person account
        } //End of if sObject is an Account type
        
        String objectApiName = recordId.getSObjectType().getDescribe().getName();
        if(mapEndpointNameValues.containsKey(objectApiName))
            return mapEndpointNameValues.get(objectApiName).Value__c;
        return '';
    }
    
    //Method to fetch the endpoint for the delete operation
    public static String getDeleteEndpoint(Id queueRecordId) {
        Map<String, Endpoints__c> mapEndpointNameValues = Endpoints__c.getAll();
        List<Sync_Queue__c> lstQueue = new List<Sync_Queue__c> ();
        lstQueue = [SELECT DWH_Data_Type__c FROM Sync_Queue__c WHERE Queued_Record_Id__c =: queueRecordId LIMIT 1];
        if(lstQueue != null && !lstQueue.isEmpty()) {
            System.debug('-------> '+CRMS_Constants.mapDataTypeObjectApiName.get(lstQueue[0].DWH_Data_Type__c)+'---->'+mapEndpointNameValues);
            return mapEndpointNameValues.get(CRMS_Constants.mapDataTypeObjectApiName.get(lstQueue[0].DWH_Data_Type__c)).Value__c;
        }
        return '';
    } //End of getDeleteEndpoint method
    
    //Method to get the callout method from operation type
    public static String getCalloutMethodFromOperation(String operationType){
        Map<String, String> mapOperationCalloutMethod = new Map<String, String>{
                                                CRMS_Constants.SYNC_ACTION_INSERT => CRMS_Constants.CALLOUT_METHOD_POST,                                                    
                                                CRMS_Constants.SYNC_ACTION_CREATE => CRMS_Constants.CALLOUT_METHOD_POST,
                                                CRMS_Constants.SYNC_ACTION_UPDATE => CRMS_Constants.CALLOUT_METHOD_POST,
                                                CRMS_Constants.SYNC_ACTION_DELETE => CRMS_Constants.CALLOUT_METHOD_DELETE
                                            };
        return mapOperationCalloutMethod.get(operationType);
    }
    
    public Map<String, String> getObjectFieldSetMap(Id objectId){
        Map<String, String> tempObjectIdFieldSetMap = new Map<String,String>();
        Schema.DescribeSObjectResult describeObject = objectId.getSObjectType().getDescribe();
        Map<String, Schema.FieldSet> FieldSetMap = describeObject .fieldSets.getMap();
        for (Schema.FieldSet fs : FieldSetMap .values()) {
            tempObjectIdFieldSetMap .put(describeObject.getName(),fs.getName());
        }
        return tempObjectIdFieldSetMap;
    }
    
    //Method to return the current date in header format
    public static String generateDateForAuth(){
        return datetime.now().formatGmt('EEE, dd MMM yyyy HH:mm:ss') + ' GMT';
    }
    
    //Method to return the authorization key for callout
    public static String generateAuthKey(String calloutMethod, String endpoint){
        String signature = calloutMethod + '\n\n\n' + generateDateForAuth() + '\n' + endpoint;
        String SharedKey = Label.Auth_Shared_Key;
        Blob convertFrom64 = EncodingUtil.base64Decode(SharedKey);
        Blob dataToHmac = Blob.valueOf(signature);
        Blob hmacComputeHash = Crypto.generateMac('hmacSHA256', dataToHmac, convertFrom64);
        return EncodingUtil.base64Encode(hmacComputeHash);
    }
    
    public static Boolean IsWeekendDay(Date dateParam)
    {
        boolean result = false;	//Recover the day of the week
        Date knownMonday = date.newInstance(2000, 1, 3); // 3 Jan 2000 was Monday
        //Date startOfWeek = dateParam.toStartOfWeek(); // depends on user's locale so it's not safe
        Integer dayOfWeek = Math.mod(knownMonday.daysBetween(dateParam), 7);
        result = dayOfWeek == 5 || dayOfWeek == 6; //Saturday and Sunday
        return result;
    }
    public static Date AddBusinessDays(Date StartDate, integer BusinessDaysToAdd)
    {//Add or decrease in BusinessDaysToAdd days 
        Date finalDate = StartDate;
        integer direction = BusinessDaysToAdd < 0 ? -1 : 1;
        while(BusinessDaysToAdd != 0) 
        {     
            finalDate = finalDate.AddDays(direction);                      
            if (!CRMS_Util.IsWeekendDay(finalDate))     
            {         
                BusinessDaysToAdd -= direction;     
            }
        }
        return finalDate;
    }
    
    public static Integer SumCollectionDays(integer gracePeriod, integer repaymentsNum, integer daysIncrement)
    {
        //Assume the loan always starts on Monday
        
        Integer curr = gracePeriod;
        if (math.mod(gracePeriod, 7) == 5 || math.mod(gracePeriod, 7) == 6)
            curr = gracePeriod + 7 - math.mod(gracePeriod, 7);
        
        Integer result = 0;
        
        for (Integer i = 1; i <= repaymentsNum; i ++)
        {
            if (math.mod(curr, 7) == 5 || math.mod(curr, 7) == 6)
                i --;
            else
                result += curr;
            
            curr += daysIncrement;
        }
        
        //System.Debug(result);
        return result;
    }
    
    public static String DateToString(Date inputDate, String format)
    {
        if (inputDate == null)
            return '';
        
        Datetime dt = datetime.newInstance(inputDate.year(), inputDate.month(), inputDate.day());
        return dt.format(format);
    }
    
    public static Decimal DecimalMod(Decimal num1, Decimal num2)
    {
        Double c = 0;
        Double result;
        result = num1 / num2;
        c= Math.floor(result);
        result = num1 - (num2 * c);
        
        return result;
    }
    
    public static String DecimalToString(Decimal input)
    {
        Decimal tmp = input;
        Decimal decPart = DecimalMod(input, 1);
        Long intPart = input.longValue();
        
        string decPartStr = '';
        string result = '';
        
        while (intPart/1000 > 0)
        {
            result =  ',' + String.valueOf(Math.mod(intPart, 1000)) + result;
            Decimal div = intPart/1000;
            intPart = div.longValue();
            
        }
        
        result = String.valueOf(Math.mod(intPart, 1000)) + result;        
        decPartStr = String.valueOf(decPart).substring(String.valueOf(decPart).indexOf('.') + 1);
        
        result += '.' + decPartStr;
        
        return result;
    }
}