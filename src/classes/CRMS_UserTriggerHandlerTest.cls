/**
	Test class for trigger on User object
	Author: Saket Joshi
	Version: 1.0
*/

@isTest
public with sharing class CRMS_UserTriggerHandlerTest {

	//Method to test for DWH_Import__c = false on insert
	@isTest
	static void testFalseImport() {
		CRMS_Util objUtil = new CRMS_Util();
		CRMS_Util.generateEndpoints();
		
		List<User> lstUser = CRMS_Util.generateUserList(1, false);
		for (User user : lstUser) {
		    user.DWH_Status__c = null;
		}
	    
	    Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		Test.startTest();
		insert lstUser;
		Test.stopTest();
		
		List<User> listUser = new List<User>();
		listUser = [SELECT Id,DWH_Status__c FROM User where Id = :lstUser[0].Id];
		
		system.assertNotEquals(null, listUser[0].DWH_Status__c);
		
	}
	
	//Method to test for DWH_Import__c = true on insert
	@isTest
	static void testTrueImport() {
		CRMS_Util objUtil = new CRMS_Util();
		CRMS_Util.generateEndpoints();
		List<User> lstUser = CRMS_Util.generateUserList(30, false);
		
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		Test.startTest();
		
		for(User objUser : lstUser)
			objUser.DWH_Status__c = CRMS_Util.DWH_STATUS_SYNCED;
		
		insert lstUser;
		Test.stopTest();
		
		List<User> lstUserNew = new List<User> ();
		lstUserNew = [SELECT id,UserName, DWH_Status__c, DWH_Last_Sync__c FROM User WHERE UserName LIKE 'freeuser%'];
		
		system.assertNotEquals(null, lstUserNew[0].DWH_Status__c);

	}

	//Method to test for DWH_Import = true on update
	@isTest
	static void testImportChangeFalseToTrue() {
		CRMS_Util objUtil = new CRMS_Util();
		CRMS_Util.generateEndpoints();
		List<User> lstUser = CRMS_Util.generateUserList(30, false);
		insert lstUser;
		
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		Test.startTest();
		for(User objUser : lstUser)
			objUser.DWH_Status__c = CRMS_Util.DWH_STATUS_SYNCED;
		
		update lstUser;
		Test.stopTest();
		
		List<User> lstUserNew = new List<User> ();
		lstUserNew = [SELECT UserName, DWH_Status__c, DWH_Last_Sync__c FROM User WHERE UserName LIKE 'freeuser%'];
		
		system.assertNotEquals(null, lstUserNew[0].DWH_Status__c);

	}
	
	//Method to test for DWH_Import = false on update
	@isTest
	static void testImportChangeTrueToFalse() {
		CRMS_Util objUtil = new CRMS_Util();
		CRMS_Util.generateEndpoints();
		
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		
		List<User> lstUser = CRMS_Util.generateUserList(30, false);
		for(User objUser : lstUser)
			objUser.DWH_Status__c = CRMS_Util.DWH_STATUS_SYNCED;
		
		insert lstUser;
		
		Test.startTest();
		for(User objUser : lstUser)
			objUser.DWH_Status__c = null;
		
		update lstUser;
		Test.stopTest();
		
		List<User> lstUserNew = new List<User> ();
		lstUserNew = [SELECT UserName, DWH_Status__c, DWH_Last_Sync__c FROM User WHERE UserName LIKE 'freeuser%'];

		system.assertNotEquals(null, lstUserNew[0].DWH_Status__c);

	}

}