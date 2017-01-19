/**
    Test class for the campaign trigger
    Author: Saket Joshi
    Created Date: 31/03/2015        Version: 1.0
*/

@isTest
public with sharing class CRMS_CampaignTriggerHandlerTest {

    //Method to test the insert of campaigns
    @isTest
    static void testCampaignInsert() {
        List<Campaign> lstCampaign = new List<Campaign> ();
        lstCampaign = CRMS_Util.generateCampaignList(10, false);
        CRMS_Util.generateEndpoints();
        
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        Test.startTest();
        insert lstCampaign;
        Test.stopTest();
        
        for(Campaign objCampaign : [SELECT DWH_Status__c 
                                    FROM Campaign
                                    WHERE Id IN :lstCampaign]) {
            system.assertNotEquals(null, objCampaign.DWH_Status__c);
        } //End of for loop for all inserted campaigns
    }
    
    //Method to test the insert of synced campaigns
    @isTest
    static void testSyncedCampaigns() {
        List<Campaign> lstCampaign = new List<Campaign> ();
        lstCampaign = CRMS_Util.generateCampaignList(10, false);
        CRMS_Util.generateEndpoints();
        
        for(Campaign objCampaign : lstCampaign)
            objCampaign.DWH_Status__c = CRMS_Constants.DWH_STATUS_SYNCED;
        
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        Test.startTest();
        insert lstCampaign;
        Test.stopTest();
        
        for(Campaign objCampaign : [SELECT DWH_Last_Sync__c 
                                    FROM Campaign
                                    WHERE Id IN :lstCampaign]) {
            system.assertNotEquals(null, objCampaign.DWH_Last_Sync__c);
        } //End of for loop for all inserted campaigns
    }
    
    //Method to test the update of campaigns
    @isTest
    static void testCampaignUpdate() {
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        
        List<Campaign> lstCampaign = new List<Campaign> ();
        lstCampaign = CRMS_Util.generateCampaignList(10, true);
        
        Test.startTest();
        for(Campaign objCampaign : lstCampaign)
            objCampaign.DWH_Status__c = null;
        
        update lstCampaign;
        Test.stopTest();
        
        for(Campaign objCampaign : [SELECT DWH_Status__c 
                                    FROM Campaign
                                    WHERE Id IN :lstCampaign]) {
            system.assertNotEquals(null, objCampaign.DWH_Status__c);
        } //End of for loop for all updated campaigns
    }
    
    
    //Method to test campaign delete
    @isTest
    static void testCampaignDelete() {
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        
        List<Campaign> lstCampaign = new List<Campaign> ();
        lstCampaign = CRMS_Util.generateCampaignList(10, true);
        
        Test.startTest();
        delete lstCampaign;
        Test.stopTest();
        
        for(Sync_Queue__c objQueue : [SELECT DWH_Data_Type__c
                                      FROM Sync_Queue__c]) {
            system.assertEquals(CRMS_Constants.DWH_DATA_TYPE_CAMPAIGN, objQueue.DWH_Data_Type__c);
        } //End of for loop for all created sync queues
    }

    //Method to test campaign delete with sync queue records
    @isTest
    static void testCampaignDeleteWithQueue() {
        CRMS_Util.generateEndpoints();
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        
        List<Campaign> lstCampaign = new List<Campaign> ();
        List<Sync_Queue__c> lstQueueToInsert = new List<Sync_Queue__c> ();
        lstCampaign = CRMS_Util.generateCampaignList(10, true);
        
        for(Campaign objCampaign : lstCampaign) {
            lstQueueToInsert.add ( new Sync_Queue__c ( Campaign__c = objCampaign.Id,
                                                        DWH_Data_Type__c = CRMS_Constants.DWH_DATA_TYPE_CAMPAIGN,
                                                        Queued_Record_ID__c = objCampaign.Id,
                                                        Sync_Status__c = CRMS_Constants.SYNC_QUEUE_STATUS_PENDING) );
        }
        
        insert lstQueueToInsert;
        
        Test.startTest();
        delete lstCampaign;
        Test.stopTest();
        
        for(Sync_Queue__c objQueue : [SELECT Notes__c
                                      FROM Sync_Queue__c]) {
            system.assertEquals(null, objQueue.Notes__c);
        } //End of for loop for all created sync queues
    }

}