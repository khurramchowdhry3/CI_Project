/**
    Trigger on Account to perform sync with DWH
    Author: Saket Joshi
    Created Date: 31/03/2015    Version: 1.0
*/ 
trigger CRMS_AccountTrigger on Account (after insert, after update, before delete, before insert, before update) {
    CRMS_AccountTriggerHandler accountTriggerHandler = new CRMS_AccountTriggerHandler();
    List<Account> accountImportedList = new List<Account>();
    List<Account> accountList = new List<Account>();
    
    system.debug('New Account >>> '+trigger.new);
    system.debug('Old Account >>> '+trigger.old);
    
    if (trigger.isInsert && trigger.isBefore) {
        
        for (Account account : Trigger.new) 
        {
                if (account.DWH_Status__c == CRMS_Constants.DWH_STATUS_SYNCED) {
                    accountImportedList.add(account);
                } else {
                    accountList.add(account);
                }
            if(!account.IsPersonAccount){
                /*if (account.DWH_Status__c == CRMS_Constants.DWH_STATUS_SYNCED) {
                    accountImportedList.add(account);
                } else {
                    accountList.add(account);
                }*/
            }
            else
            {
                if(account.Salutation != account.Salutation__pc)
                {
                    account.Salutation__pc = account.Salutation;
                }
                accountTriggerHandler.checkRecordType(trigger.new);
            }
        }
        accountTriggerHandler.syncAccountAddress(trigger.new);
        if (!accountImportedList.isEmpty()) {
            accountTriggerHandler.setAccountDWHStatusSynced(accountImportedList);
        }
        if (!accountList.isEmpty()) {
            accountTriggerHandler.setAccountDWHStatusQueued(accountList);
            //accountTriggerHandler.setBankDetails(accountList);
        }
    }
    
    if (trigger.isUpdate && trigger.isBefore) {
              
        for (Account account : trigger.new) 
        {
            if (account.DWH_Status__c == CRMS_Constants.DWH_STATUS_SYNCED){
                    accountImportedList.add(account);
                }
            if(!account.IsPersonAccount){
                /*if (account.DWH_Status__c == CRMS_Constants.DWH_STATUS_SYNCED){
                    accountImportedList.add(account);
                }*/
            }
            else
            {
                if(account.Salutation != account.Salutation__pc)
                {
                    account.Salutation__pc = account.Salutation;
                }
                if( CRMS_AccountTriggerHandler.isIDCheck == false )
                    accountTriggerHandler.checkRecordType(trigger.new);
            }
        }
        accountTriggerHandler.syncAccountAddress(trigger.new);
        //accountTriggerHandler.setBankDetails(trigger.new);
        if (!accountImportedList.isEmpty()) {
            accountTriggerHandler.setAccountDWHStatusSynced(accountImportedList);
        }
    }
    
    if (trigger.isInsert && trigger.isAfter) {
                    
        List<Id> lstBusinessAccount = new List<Id> ();
        List<Id> lstPersonAccount = new List<Id> ();
        
        for(Account objAccount : trigger.new){
            if(objAccount.isPersonAccount)
                lstPersonAccount.add(objAccount.Id);
            else
                lstBusinessAccount.add(objAccount.Id);
        }
        if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER          
            && !lstBusinessAccount.isEmpty() 
            && !system.isFuture() 
            && !system.isBatch() 
            && !system.isScheduled() 
            && !CRMS_AccountTriggerHandler.isTriggerCalledInsert){
            
            AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_CREATE);            
            CRMS_AccountTriggerHandler.isTriggerCalledInsert = true;
        }
        
        if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER 
            && !lstPersonAccount.isEmpty() 
            && !system.isFuture() 
            && !system.isBatch() 
            && !system.isScheduled() 
            && !CRMS_AccountTriggerHandler.isPersonAccountInsert){
            
            AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_CREATE);
            CRMS_AccountTriggerHandler.isPersonAccountInsert = true;
        }   
    }
    
    if (trigger.isUpdate && trigger.isAfter) {
               
        List<Id> lstBusinessAccount = new List<Id> ();
        List<Id> lstPersonAccount = new List<Id> ();
                        
        for(Account objAccount : trigger.new){
            
            if(objAccount.isPersonAccount == true)
                lstPersonAccount.add(objAccount.Id);
            else
                lstBusinessAccount.add(objAccount.Id);
                
            
        }
        
        if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER 
            && !CRMS_AccountTriggerHandler.isTriggerCalled 
            && !system.isFuture() 
            && !system.isBatch() 
            && !system.isScheduled() 
            && !lstBusinessAccount.isEmpty()) {
            
            AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_UPDATE);
            //CRMS_DwhSyncHandler.doSynchronizationFromFuture(lstBusinessAccount, CRMS_Constants.SYNC_ACTION_UPDATE);
            new CRMS_AccountTriggerHandler().UpdatePartnerProgramName(trigger.oldMap, trigger.newMap);
            CRMS_AccountTriggerHandler.isTriggerCalled = true;
        }
        
            
        if(userinfo.getUserName() != AMPSyncApp_Constants.AMP_INTEGRATION_USER && !system.isFuture() && !system.isBatch() && !system.isScheduled() && !CRMS_AccountTriggerHandler.isPersonAccountUpdate && !lstPersonAccount.isEmpty()){
                        
            AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.new, AMPSyncApp_Constants.SYNC_ACTION_UPDATE);
            //CRMS_DwhSyncHandler.doSynchronizationFromFuture(lstPersonAccount, CRMS_Constants.SYNC_ACTION_CREATE);
            
            CRMS_AccountTriggerHandler.isPersonAccountUpdate = true;
        }
        
    }
    
    if (trigger.isDelete && trigger.isBefore) {
        List<Account> lstAccount = new List<Account>();
        for (Account account : trigger.old) {
            //if (!account.IsPersonAccount) {
                accountList.add(account);
            //}
        }
        
        if(!CRMS_AccountTriggerHandler.isTriggerCalled 
            && !system.isFuture() 
            && !system.isBatch() 
            && !system.isScheduled()) {           
            AMPSyncApp_SyncHandler.SyncWithCAIROS(trigger.old, AMPSyncApp_Constants.SYNC_ACTION_DELETE);
            CRMS_AccountTriggerHandler.isTriggerCalled = true;
        }
        
        if (!accountList.isEmpty()) {
            accountTriggerHandler.updateSyncQueueRecord(accountList);
        }
    }  
}