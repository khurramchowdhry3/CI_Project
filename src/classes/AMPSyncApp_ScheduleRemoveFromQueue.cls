/**
 * AMP Sync Application
 * 
 * This file is the part of the AMP Sync Application used to Schedule Removed Successfully Synced Records from Queue
 * 
 * Copyright (c) 2016 - xoomworks.com
 * 
 * @author Khurram Shahzad (Sr. Software Engineer .at. XoomWorks) <a href="http://www.xoomworks.com/">XoomWorks</a>
 * @created 2016
 * 
 * Batch Scheudle Class to Remove successfully synced records from Queue. 
 *
 */

public with sharing class AMPSyncApp_ScheduleRemoveFromQueue implements Database.Batchable<SObject> {

    private static final integer SCHEDULE_MINS_FROM_NOW = 720; // 12 Hours
    private static final integer BATCH_SIZE = 200; 
    
    //Batch Apex Job Start Method to query successfully synced records from past 2 days
    public Database.Querylocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([select Id 
                    from AMPSync_Queue__c where Status__c = 'Success' AND Last_Sync_DateTime__c < LAST_N_DAYS:2]);
    }
        
    public void execute (Database.Batchablecontext BC, list<AMPSync_Queue__c> scop){
        list<AMPSync_Queue__c> records = new list<AMPSync_Queue__c>();
        for(AMPSync_Queue__c Queue : scop){
            records.add(Queue);
        }
        if(records!= null && records.size()>0){
            delete records; 
        }        
    }
    
    //Schedule Batch
    public void finish(Database.Batchablecontext BC){
        if(!test.isRunningTest()){
            system.scheduleBatch(new AMPSyncApp_ScheduleRemoveFromQueue(), 'Remove From Queue',SCHEDULE_MINS_FROM_NOW, BATCH_SIZE);
        }
    }

}