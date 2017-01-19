/**
	Test class for Json Generator class
	Author: Saket Joshi
	Version: 1.0
*/

@isTest
public with sharing class CRMS_JsonGeneratorTest {

	//Method to test Json generation for list of users
	@isTest
	static void testJsonGenerationForUser() {
		CRMS_Util.generateEndpoints();
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		
		List<User> lstUser = CRMS_Util.generateUserList(1, true);
		List<CRMS_CalloutObjects.Values> lstValues = new List<CRMS_CalloutObjects.Values> ();
		for(User objUser : lstUser) {
			List<CRMS_CalloutObjects.FieldInformation> lstFields = new List<CRMS_CalloutObjects.FieldInformation> ();
			lstFields.add(new CRMS_CalloutObjects.FieldInformation('ProfileId', objUser.ProfileId));
			lstFields.add(new CRMS_CalloutObjects.FieldInformation('Username', objUser.Username));
			lstFields.add(new CRMS_CalloutObjects.FieldInformation('LastName', objUser.LastName));
			lstFields.add(new CRMS_CalloutObjects.FieldInformation('AboutMe', ''));
			lstFields.add(new CRMS_CalloutObjects.FieldInformation('Email', objUser.Email));
			lstFields.add(new CRMS_CalloutObjects.FieldInformation('Id', objUser.Id));
			lstValues.add( new CRMS_CalloutObjects.Values ( 'Insert', lstFields ) );
		}
		String expectedJson = Json.serialize(lstValues);
		
		Test.startTest();
		List<User> actualUsers = [SELECT LastName,
									Email,
									UserName,
									ProfileId,
									AboutMe
								FROM User
								WHERE UserName LIKE 'freeuser%'];
		
		String actualJson = CRMS_JsonGenerator.generateJson(actualUsers, 'Insert');
		Test.stopTest();
		
		system.assertNotEquals(null, actualJson);
	}

	//Method to test delete Json generation for list of contact
	@isTest
	static void testDeleteJson() {
		CRMS_Util objUtil = new CRMS_Util();
		CRMS_Util.generateEndpoints();
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		
		Account objAccount = objUtil.initializeAccount(true);
		List<Contact> lstContact = CRMS_Util.generateContactList(10, true, objAccount.Id);
		List<String> lstContactId = new List<String> ();
		
		for(Contact objContact : lstContact)
			lstContactId.add(objContact.Id);
		
		Test.startTest();
		String expectedJson = CRMS_JsonGenerator.generateJsonForDelete(lstContactId);
		Test.stopTest();
		
		system.assertNotEquals(null, expectedJson);
	}
	
}