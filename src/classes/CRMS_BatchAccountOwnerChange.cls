/**
 * This class used to change the owner of accounts as per the contract sign date.
 *
 * Initial Draft            Author           Date
 * Version 1.0              Yogesh          25/5/2015 

 *
 
 */
global without sharing class CRMS_BatchAccountOwnerChange implements Database.Batchable<SObject> {

    public Database.QueryLocator start( Database.BatchableContext bc ) {
        Integer noOfDays = Integer.valueOf(Label.No_of_Day_s);
        // query to find opportunity with condition contract sign date + 30 = today()
        Date compareDate = date.parse(date.today().format()).addDays(-noOfDays);
        
        return Database.getQueryLocator('SELECT id, Accountid FROM Opportunity WHERE Contract_Signed__c != false AND'
                            +' Contract_Signed_Date__c = :compareDate');
    }
    // Execute Logic
    global void execute( Database.BatchableContext BC, List<sObject> listsObjectData ){
        
        // Store all opportunity.
        List<Opportunity> listOpp = (List<Opportunity>)listsObjectData;
        // Store all Business Account id
        Set<ID> accId = new Set<ID>();
        
        // Get all Business account id
        for( Opportunity opp: listOpp ){
            accId.add(opp.Accountid);
        }// End For
        
        // Query to fetch all person account related to set of id
        List<Account> listPersonAcc = [SELECT ID, 
                                              Associated_Business__r.Account_Manager__c,
                                              isPersonAccount,
                                              Account_Manager__c,
                                              ownerId
                                       FROM Account
                                       WHERE Associated_Business__c IN :accId OR ID IN : accId 
                                             OR ParentId IN : accId];
                                       
        // Fetch owners active owner
         Map<ID, User> mapOfIDWithActiveStatus = new Map<ID, User>([SELECT ID,
                                                                           Name,
                                                                           IsActive
                                                                    FROM User
                                                                    Where IsActive = true]);
        
        if( listPersonAcc != null && !listPersonAcc.isEmpty() ) {
            // It is used to change the owner                               
            for( Account acc: listPersonAcc ){

                if (  acc.Account_Manager__c != null
                      && mapOfIDWithActiveStatus.get( acc.Account_Manager__c ) != null 
                      && !acc.isPersonAccount  ){
                        acc.ownerId = acc.Account_Manager__c;
                }else if( acc.Associated_Business__r.Account_Manager__c != null 
                    && mapOfIDWithActiveStatus.get( acc.Associated_Business__r.Account_Manager__c ) != null ){
                        acc.ownerId = acc.Associated_Business__r.Account_Manager__c;
                }
                
            }//End For
            
            // Update account
            update listPersonAcc;
        }// End If
        
    }// End execute
         
    
    // 
    public void finish( Database.BatchableContext info ) {
        system.scheduleBatch(new CRMS_DwhSyncBatch (), Label.AccountOwnerChange+system.Today().addDays(1),5,200);
    }
}