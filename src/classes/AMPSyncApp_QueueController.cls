/**
 * AMP Sync Application
 * 
 * This file is the part of the AMP Sync Application used to handle list view of Queue Object.
 * 
 * Copyright (c) 2016 - xoomworks.com
 * 
 * @author Khurram Shahzad (Sr. Software Engineer .at. XoomWorks) <a href="http://www.xoomworks.com/">XoomWorks</a>
 * @created 2016
 * 
 * Controller Class to handle list view of Queue Object.
 * 
 */ 
public with sharing class AMPSyncApp_QueueController {
    
    public transient ID SelectedRecordToSync    {get; set;}
    public transient list<AMPSync_Queue__c> ListOfQueueMembers	{get; set;}
    
    public AMPSyncApp_QueueController(){
        ListOfQueueMembers = new AMPSyncApp_SyncQueue().getRecordsFromQueue();
    }
    
    public void syncPendingRecord(){
        AMPSyncApp_SyncHandler.SyncQueueWithCAIROS(SelectedRecordToSync);
    }
}