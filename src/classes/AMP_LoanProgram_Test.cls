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
private class AMP_LoanProgram_Test {

    static testMethod void TestAMPLoanProgramWithoutTemplate() {
        // TO DO: implement unit test
        
        Account Acnt;
        Program__c LoanProgram;
        
        Profile testProfile = [SELECT Id 
                           FROM profile
                           WHERE Name = 'System Administrator' 
                           LIMIT 1];            
       
       	User testadminuser = new User(alias = 'hasrole', email='userwithrole@roletest1.com',
                                    emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                                    localesidkey='en_US', profileid = testProfile.Id, 
                                    timezonesidkey='America/Los_Angeles', username='userwithrole@testorg.com');
       
        
        System.runAs(testadminuser) {			
            test.startTest();
            	Acnt = new Account(name = 'TEST ACCOUNT');
	            Database.insert(Acnt);
	            
	            LoanProgram = new Program__c(
	            	Start_Date__c	= System.today(),	            	 
	            	Partner_name__c	= Acnt.Id, 
	            	End_Date__c		= System.today().addDays(7), 
	            	Country__c		= 'UK'
	            );	            
	            Database.insert(LoanProgram);
	                    
        	test.stopTest();
        }
        
        AMP_LoanProgram AMPProgram = new AMP_LoanProgram();
        AMPProgram.CheckProgramValidty();        
    }
    
    static testMethod void TestAMPLoanProgramWithTemplate() {
        // TO DO: implement unit test
        
        Account Acnt;
        Contact Cont;
        Program__c LoanProgram;
        
        Profile testProfile = [SELECT Id 
                           FROM profile
                           WHERE Name = 'System Administrator' 
                           LIMIT 1];            
       
       	User testadminuser = new User(alias = 'hasrole', email='userwithrole@roletest1.com',
                                    emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                                    localesidkey='en_US', profileid = testProfile.Id, 
                                    timezonesidkey='America/Los_Angeles', username='userwithrole@testorg.com');
       
        
        System.runAs(testadminuser) {			
            test.startTest();
            	Acnt = new Account(name = 'TEST ACCOUNT');
	            Database.insert(Acnt);
	            Cont = new Contact(AccountId = Acnt.id, lastname = 'lastname', Email = 'testemail@amp-test.com');
	            Database.insert(Cont);
            	
            	Folder F = [Select f.Id, f.DeveloperName From Folder f Where f.DeveloperName  = 'AMP_Credit_Templates' limit 1];
            	EmailTemplate Template = new EmailTemplate(
            		developerName = 'AMP_Program_Expire_Alert_Test', 
            		FolderId = F.Id, 
            		TemplateType= 'Text', 
            		Name = 'Program Expire Alert'            	
            	);
            	
            	Database.insert(Template);
            		            
	            LoanProgram = new Program__c(
	            	Start_Date__c	= System.today(),	            	 
	            	Partner_name__c	= Acnt.Id, 
	            	End_Date__c		= System.today().addDays(7), 
	            	Country__c		= 'UK'
	            );	            
	            Database.insert(LoanProgram);
	                    
        	test.stopTest();
        }
        
        AMP_LoanProgram AMPProgram = new AMP_LoanProgram();
        AMPProgram.CheckProgramValidty();        
    }
}