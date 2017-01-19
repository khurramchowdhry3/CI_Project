/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class AMPSyncApp_Util_Test {
 
    private static final AMPSync_Queue__c[] Queue = new AMPSync_Queue__c[]{};
    private static final Lead[] Leads = new Lead[]{};    
    private static final Account[] Accounts = new Account[]{};
    private static final Program__c[] LoanPrograms = new Program__c[]{};
    private static final integer RECORDLIMIT = 10;
        
    static testMethod void TestScheduleJobToRemoveFromQueue() {
        // TO DO: implement unit test
        
       Profile testProfile = [SELECT Id 
                           FROM profile
                           WHERE Name = 'System Administrator' 
                           LIMIT 1];            
       
       User testadminuser = new User(alias = 'hasrole', email='userwithrole@roletest.com',
                                    emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                                    localesidkey='en_US', profileid = testProfile.Id, 
                                    timezonesidkey='America/Los_Angeles', username='userwithrole@testorg.com');
                  
       system.runAs(testadminuser){
            test.startTest();
            
            RecordType RecTypeAcc = [Select r.Id From RecordType r 
                            Where SobjectType = 'Account' AND DeveloperName like 'Partner_UK' limit 1];
            
            for(integer i=1; i<=1; i++){
                Accounts.add( new Account(
                    RecordTypeId = RecTypeAcc.Id, 
                    Name         = 'Standard Charted Bank Branch',              
                    Bank_Account_Number__c      = '809647175001'                
                )); 
            }
            
            Database.insert(Accounts);
            /*
            for(integer i=1; i<=RECORDLIMIT; i++){
                Leads.add( new Lead(
                    Program__c              =,
                    LastName                =,
                    FirstName               =,  
                    Company                 =,
                    Accepts_Credit_Cards__c =,
                    Convert_Lead__c         =,
                    LeadSource              =,
                    CurrencyISOCode         =,
                    HasOptedOutOfEmail      =,
                    IsConverted             =,
                    DoNotCall               =,
                    HasOptedOutOfFax        =,
                    Business_Legal_Name__c  =,
                    Converted__c            =,
                    Partner_Website_Tracker__c  =,
                    Callback_Requested__c       =,
                    Business_Nature__c          =,
                    TA_Country__c           =,
                    LE_Country__c           =,
                    IsUnreadByOwner         =,
                    Do_Not_Mail__c          =,
                    Do_Not_Txt__c           =,
                    DWH_Import__c           =,
                    Trading_Address_if_different__c             =,
                    Business_Registered_in_UK__c                =,
                    Business_Registered_In_Hong_Kong__c         =,
                    Business_Registered_In_Philippines__c       =,
                    Business_Registered_In_Singapore__c         =,
                    Business_In_Operation_Minimum_3_Months__c   =,
                    Business_In_Operation_Minimum_6_Months__c   =
                ));
            }*/             
                   
            test.stopTest();
        }
    }    
}