/**
    Class for executing batch for Account owner change
    Author: Yogesh Mahajan.
    Version: 1.0
*/

global with sharing class CRMS_AccountBatchSchedulable implements Schedulable {
    
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new CRMS_BatchAccountOwnerChange());
    }
    
}