@isTest
private class CRMS_LeadManagementControllerTest 
{
    static testMethod void testCRMS_LeadManagementController() 
    {
        Profile objProfile = [SELECT Id FROM Profile WHERE Name like '%Partner%' limit 1]; 
        String struserName = 'tester'+system.today()+'@noemail.com';
        String struserName1 = struserName.replaceAll('\\s+', '');
        String struserName2 = struserName1.replaceAll(':+', '');
        String struserName3 = struserName2.replaceAll('-+', '');
        System.debug('&&&&&&&&&&&'+struserName3);
        
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());//mock callout
        ApexPages.StandardController conObj = new ApexPages.StandardController(new Lead());
        CRMS_LeadManagementController leadObj = new CRMS_LeadManagementController(conObj);
        leadObj.getFinishLocation();
        Account objAccount = new Account();
        objAccount.Name = 'Rosesh';
        insert objAccount; 
       
        Contact objContact = new Contact();
        objContact.LastName ='testCon';
        objContact.AccountId = objAccount.Id;
        insert objContact;  
                  
        User objUser = new User(alias = 'test123', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = objProfile.Id, ContactId = objContact.Id,
                timezonesidkey='America/Los_Angeles', username=struserName3);
       
        System.debug('&&&&&&&&&&&&&&&&&&'+objUser);
        insert objUser;
        System.debug('*****************'+objUser);
        System.runAs(objUser){
         // The following code runs as user 'u' 
         System.debug('Current User: ' + UserInfo.getUserName());
         System.debug('Current Profile: ' + UserInfo.getProfileId()); 
        }
    }
}