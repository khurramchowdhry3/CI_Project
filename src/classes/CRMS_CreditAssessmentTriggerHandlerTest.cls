@isTest
private class CRMS_CreditAssessmentTriggerHandlerTest 
{
	@isTest(SeeAllData=true)
    static void testCRMS_CreditAssessmentTriggerHandler() 
    {
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		Test.startTest();
		
    	 list<RecordType> lstRecType = [Select r.SobjectType, r.Id, r.DeveloperName, r.Name 
                            From RecordType r 
                            where r.SobjectType = 'Opportunity' and r.DeveloperName like 'Application_UK%'];
           
        System.debug('lstRecType'+lstRecType);
        Account objAcc = new Account();
        objAcc.Name = 'UK Corp.';
        objAcc.Preferred_Mailing_Address__c = 'Trading Address';
        objAcc.Type = 'Prospect';
        insert objAcc;
        
        
        Opportunity objOpp = new Opportunity();
        objOpp.Name = 'test';
        objOpp.AccountId = objAcc.Id;
        objOpp.StageName = 'In Progress';
        objOpp.Application_ID2__c = 'appId1';
        objOpp.RecordTypeId = lstRecType[0].Id;
        objOpp.CloseDate = date.today();
        insert objOpp;
        
        Guarantors__c objGuarantor = new Guarantors__c ();
        objGuarantor.Opportunity__c = objOpp.Id;
        objGuarantor.Account__c = objAcc.Id;
        insert objGuarantor;
        
        Credit_Assessment__c objCredit = new Credit_Assessment__c ();
        objCredit.Opportunity__c = objOpp.Id;
        objCredit.Final_Decision__c = 'Approved';
               
        insert objCredit;
        
        objCredit.Additional_Information_Required__c = 'Yes';
        objCredit.Additional_Information_Details__c = 'test';
        objCredit.Additional_Information_Narrative__c = 'test';
        update objCredit;
        
        objCredit.Status__c = 'Approved';
        update objCredit;
        
        
        list<Opportunity> lstOpp1 = [select Id,StageName from Opportunity where Id =: objOpp.Id ];
        System.debug('lstOpp>>'+lstOpp1);
        system.assertEquals('Contract Stage', lstOpp1[0].StageName);
        
        objCredit.Status__c = 'Rejected';
        update objCredit;
        
        objCredit.Additional_Information_Satisfactory__c = 'No';
        objCredit.Status__c = 'Revert';
        update objCredit;
        Test.stopTest();
              
        list<Opportunity> lstOpp = [select Id,StageName from Opportunity where Id =: objOpp.Id ];
        system.assertEquals('Rejected', lstOpp[0].StageName);
       
    }
    
    @isTest(SeeAllData=true)
    static void testCRMS_CreditAssessmentTriggerHandlerUpdate()
    {
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		Test.startTest();
		
        list<RecordType> lstRecType = [Select r.SobjectType, r.Id, r.DeveloperName, r.Name 
                            From RecordType r 
                            where r.SobjectType = 'Opportunity' and r.DeveloperName like 'Application%'];
           
        System.debug('lstRecType'+lstRecType);
        Opportunity objOpp = new Opportunity();
        objOpp.Name = 'test';
        objOpp.StageName = 'Closed Won';
        objOpp.RecordTypeId = lstRecType[0].Id;
        objOpp.CloseDate = date.today();
        
        insert objOpp;
       
        Credit_Assessment__c objCredit = new Credit_Assessment__c ();
        objCredit.Opportunity__c = objOpp.Id;
               
        insert objCredit;
        
        objCredit.Additional_Information_Required__c = 'Yes';
        objCredit.Additional_Information_Details__c = 'test';
        objCredit.Additional_Information_Narrative__c = 'test';
        
        objCredit.Offer_Amount__c = 1000;
        
        update objCredit;
        
        objCredit.Status__c = 'Approved';
        update objCredit;
        
        list<Opportunity> lstOpp1 = [select Id,StageName from Opportunity where Id =: objOpp.Id ];
        
        objCredit.Status__c = 'Rejected';
        update objCredit;
        
        Test.stopTest();
        
        list<Opportunity> lstOpp = [select Id,StageName from Opportunity where Id =: objOpp.Id ];
        system.assertEquals('Rejected', lstOpp[0].StageName);
    }
    
    static testMethod void test_setCreAssessmentDWHStatusSynced_BeforeInsert() {
        CRMS_Util util = new CRMS_Util();
        CRMS_Util.generateEndpoints();
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		
		Test.startTest();
        Credit_Assessment__c creAssessmentObj = util.initializeCreditAssessment(false);
        creAssessmentObj.DWH_Status__c = CRMS_Util.DWH_STATUS_SYNCED;
        insert creAssessmentObj;
        
        Test.stopTest();
        List<Credit_Assessment__c> testCreAssessmentList = [select DWH_Status__c,DWH_Last_Sync__c from Credit_Assessment__c where id = :creAssessmentObj.Id];
        system.assertNotEquals(null, testCreAssessmentList[0].DWH_Last_Sync__c);
    }
    
    static testMethod void test_setCreAssessmentDWHStatusQueued_BeforeInsert() {
        CRMS_Util util = new CRMS_Util();
        CRMS_Util.generateEndpoints();
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		
		Test.startTest();
        Credit_Assessment__c creAssessmentObj = util.initializeCreditAssessment(false);
        creAssessmentObj.DWH_Status__c = CRMS_Util.DWH_STATUS_QUEUED;
        insert creAssessmentObj;
        
        Test.stopTest();
        List<Credit_Assessment__c> testCreAssessmentList = [select DWH_Status__c,DWH_Last_Sync__c from Credit_Assessment__c where id = :creAssessmentObj.Id];
        system.assertEquals(null, testCreAssessmentList[0].DWH_Last_Sync__c);
    }
    
    
    static testMethod void test_setCreAssessmentDWHStatusQueued_BeforeUpdate() {
        CRMS_Util util = new CRMS_Util();
       	CRMS_Util.generateEndpoints();
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		
		Test.startTest();
        Credit_Assessment__c creAssessmentObj = util.initializeCreditAssessment(false);
        creAssessmentObj.DWH_Status__c = CRMS_Util.DWH_STATUS_SYNCED;
        insert creAssessmentObj;
        
        creAssessmentObj.DWH_Status__c = CRMS_Util.DWH_STATUS_QUEUED;
        update creAssessmentObj;
        
        Test.stopTest();
        List<Credit_Assessment__c> testCreAssessmentList = [select DWH_Status__c,DWH_Last_Sync__c from Credit_Assessment__c where id = :creAssessmentObj.Id];
        system.assertNotEquals(null, testCreAssessmentList[0].DWH_Last_Sync__c);
    }
    
    static testMethod void test_setCreAssessmentDWHStatusSynced_BeforeUpdate() {
        CRMS_Util util = new CRMS_Util();
        
        CRMS_Util.generateEndpoints();
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		Test.startTest();
		
        Credit_Assessment__c creAssessmentObj = util.initializeCreditAssessment(false);
        creAssessmentObj.DWH_Status__c = CRMS_Util.DWH_STATUS_QUEUED;
        insert creAssessmentObj;
        
        creAssessmentObj.DWH_Status__c = CRMS_Util.DWH_STATUS_SYNCED;
        update creAssessmentObj;
        
        Test.stopTest();
        List<Credit_Assessment__c> testCreAssessmentList = [select DWH_Status__c,DWH_Last_Sync__c from Credit_Assessment__c where id = :creAssessmentObj.Id];
        system.assertNotEquals(null, testCreAssessmentList[0].DWH_Last_Sync__c);
    }
    static testMethod void test_updateSyncQueueRecord_BeforeDelete() {
        CRMS_Util util = new CRMS_Util();
        CRMS_Util.generateEndpoints();
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		Test.startTest();
        //Query ��Sync Queue� for records matching the criteria of Lead = Lead, Sync Status is �Pending�.  If a record if found
        
        //If Sync Queue record meeting criteria is not found
        Credit_Assessment__c creAssessmentObj1 = util.initializeCreditAssessment(false);
        creAssessmentObj1.DWH_Status__c = CRMS_Util.DWH_STATUS_QUEUED;
        insert creAssessmentObj1;
        
        String creAssessmentId = creAssessmentObj1.Id;
       
        delete creAssessmentObj1;
        Test.stopTest();
        
        List<Sync_Queue__c> syncQueListTest1 =[
            SELECT Credit_Assessment__c
                 , Id
                 , Notes__c
                 , Action__c
                 , Queued_Record_ID__c
                 , Sync_Status__c
                 , DWH_Data_Type__c
               FROM Sync_Queue__c 
              WHERE Queued_Record_ID__c = :creAssessmentId
        ];
        
        system.assertEquals(CRMS_Util.DWH_DATA_TYPE_CREDIT_ASSESSMENT,syncQueListTest1[0].DWH_Data_Type__c);
        system.assertEquals(creAssessmentId, syncQueListTest1[0].Queued_Record_ID__c);
        system.assertEquals(CRMS_Util.SYNC_STATUS_DELETE, syncQueListTest1[0].Action__c);
        system.assertEquals(CRMS_Util.SYNC_QUEUE_STATUS_PENDING, syncQueListTest1[0].Sync_Status__c);
        
    }
    static testMethod void test_updateExistingSyncQueueRecord_BeforeDelete() {
        CRMS_Util util = new CRMS_Util();
        CRMS_Util.generateEndpoints();
		Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
		Test.startTest();
        //Query ��Sync Queue� for records matching the criteria of Lead = Lead, Sync Status is �Pending�.  If a record if found
        
        //If Sync Queue record meeting criteria is not found
        Credit_Assessment__c creAssessmentObj1 = util.initializeCreditAssessment(false);
        creAssessmentObj1.DWH_Status__c = CRMS_Util.DWH_STATUS_QUEUED;
        insert creAssessmentObj1;
        
        Sync_Queue__c syncQueue = new Sync_Queue__c();
        syncQueue.Credit_Assessment__c = creAssessmentObj1.Id;
        syncQueue.Sync_Status__c = CRMS_Util.SYNC_QUEUE_STATUS_PENDING;
        insert syncQueue;
        String creAssessmentId = creAssessmentObj1.Id;
       
        delete creAssessmentObj1;
        
        Test.stopTest();
        List<Sync_Queue__c> syncQueListTest1 =[
            SELECT Credit_Assessment__c
                 , Id
                 , Notes__c
                 , Action__c
                 , Queued_Record_ID__c
                 , Sync_Status__c
                 , DWH_Data_Type__c
               FROM Sync_Queue__c 
              WHERE Queued_Record_ID__c = :creAssessmentId
        ];
        
        system.assertEquals(CRMS_Util.SYNC_STATUS_DELETE, syncQueListTest1[0].Action__c);
        system.assertEquals(CRMS_Util.SYNC_STATUS_STALE, syncQueListTest1[0].Sync_Status__c);
        
    }
}