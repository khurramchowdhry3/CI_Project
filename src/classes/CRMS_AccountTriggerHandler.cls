/**
* Handler Class for Account Trigger to perform sync with DWH
* Author : CRMSuperstars
* Version :1.0
**/
public class CRMS_AccountTriggerHandler {
    
    public static Boolean isTriggerCalled = false;
    public static Boolean isTriggerCalledInsert = false;
    public static Boolean isPersonAccountInsert = false;
    public static Boolean isPersonAccountUpdate = false;
    public static Boolean isIDCheck = false;
    
    // Sync LE to TA address for Prospect and Client Accounts
    public void syncAccountAddress( list<Account> lstAccount) {
        set<Id> setRecordtypeId = new set<Id>(); 
        for(Account objAccount : lstAccount){
            //if(!objAccount.IsPersonAccount) {
                if(objAccount.RecordTypeId != null) {
                    setRecordtypeId.add(objAccount.RecordTypeId);
                }
            //}
        }
        
        map<Id, RecordType> mapId_RT;
        if(!setRecordtypeId.isEmpty()) {
            mapId_RT = new map<Id, RecordType> ([Select Id, Name, DeveloperName 
                                                from RecordType 
                                                where Id IN: setRecordtypeId]);
        }
        
        for(Account objAccount : lstAccount){
            //system.debug('objAccount in trigger handler syncAccountAddress before '+objAccount);
            if(!objAccount.IsPersonAccount 
                && !objAccount.Trading_Address_if_different__c 
                && objAccount.RecordTypeId != null
                && mapId_RT.get(objAccount.RecordTypeId) != null 
                && !mapId_RT.get(objAccount.RecordTypeId).DeveloperName.contains('Premise')) {
                    
                    objAccount.TA_Region__c = objAccount.LE_Region__c;
                    objAccount.TA_District__c = objAccount.LE_District__c;
                    objAccount.TA_Country__c = objAccount.LE_Country__c;
            }
            if(!objAccount.IsPersonAccount 
                && objAccount.RecordTypeId != null 
                && mapId_RT.get(objAccount.RecordTypeId) != null 
                && mapId_RT.get(objAccount.RecordTypeId).DeveloperName.contains('Premise')) {
                
                objAccount.Trading_Address_if_different__c = true;
            }
            //if(!objAccount.IsPersonAccount && objAccount.RecordTypeId != null 
            //&& mapId_RT.get(objAccount.RecordTypeId) != null)
            if(objAccount.RecordTypeId != null 
            && mapId_RT.get(objAccount.RecordTypeId) != null) {
                if(mapId_RT.get(objAccount.RecordTypeId).DeveloperName.contains('Hong')
                || mapId_RT.get(objAccount.RecordTypeId).DeveloperName.contains('HK')){
                    objAccount.CurrencyIsoCode = 'HKD';
                }
                else if(mapId_RT.get(objAccount.RecordTypeId).DeveloperName.contains('Philippine')
                || mapId_RT.get(objAccount.RecordTypeId).DeveloperName.contains('PP')){
                    objAccount.CurrencyIsoCode = 'PHP';
                }
                else if(mapId_RT.get(objAccount.RecordTypeId).DeveloperName.contains('Singapore')
                || mapId_RT.get(objAccount.RecordTypeId).DeveloperName.contains('SG')){
                    objAccount.CurrencyIsoCode = 'SGD';
                }
                else if(mapId_RT.get(objAccount.RecordTypeId).DeveloperName.contains('UK')){
                    objAccount.CurrencyIsoCode = 'GBP';
                }
            }
            //system.debug('objAccount in trigger handler syncAccountAddress after '+objAccount); 
        }
    }
    /*
    public void setPersonalAccountAsChildofBusinessAccount(list<Account> lstAccount){
        map<ID, ID> AccountLeadMap = new map<ID, ID>();
        list<ID> LeadPersonContacts = new list<ID>();
        for(Account Ac : lstAccount){
            AccountLeadMap.put(Ac.Id, Ac.Lead_Id__c);
        }
        
        for(Lead L : [Select PersonContactId__c from Lead where Id IN : AccountLeadMap.values()]){
            LeadPersonContacts.add(L.PersonContactId__c);
        }
        
        for(Account AC: [Select a.Id, 
                                    a.Associated_Business__c, 
                                    a.PersonContactId From Account a 
                                    Where PersonContactId IN:LeadPersonContacts]){
                LeadPersonAccountMap.put(LeadPersonContactIdMap.get(AC.PersonContactId),AC);                        
        }
    }*/
    
    // method to set Account status as Queued when updated on SF end
    public void setAccountDWHStatusQueued(List<Account> accList) {
        for (Account account : accList) 
        {
            account.DWH_Status__c = CRMS_Constants.DWH_STATUS_QUEUED;
        }
    }
    // method to check record type send the account to respective function for validation.
    public void checkRecordType( List<Account> listAccount ){
        isIDCheck = true;
        for( Account acc : listAccount ){
           if( acc.Home_Country__pc != null && acc.Home_Country__pc != '' ){
                if( acc.Home_Country__pc == 'Hong Kong')
                    checkHKID(acc);
                else if(  acc.Home_Country__pc == 'Singapore')
                    checkSGID(acc);
           }
        }
    }
    
    // Method to find value of HKID character
    public Integer characterVal( String HKIDChar){
        Integer checkSum = 0;
        if( HKIDChar == 'A' || HKIDChar == 'L' || HKIDChar == 'W' 
            || HKIDChar == 'a' ||  HKIDChar == 'l' || HKIDChar == 'W' )
                checkSum = 10;
        else if( HKIDChar == 'B' || HKIDChar == 'M' || HKIDChar == 'X' 
            || HKIDChar == 'b' ||  HKIDChar == 'm' || HKIDChar == 'x' )
            checkSum = 11;
        else if( HKIDChar == 'C' || HKIDChar == 'N' || HKIDChar == 'Y' 
            || HKIDChar == 'c' ||  HKIDChar == 'n' || HKIDChar == 'y' )
                checkSum = 12;  
        else if( HKIDChar == 'D' || HKIDChar == 'O' || HKIDChar == 'Z' 
            || HKIDChar == 'd' ||  HKIDChar == 'o' || HKIDChar == 'z' )
                checkSum = 13;
        else if( HKIDChar == 'E' || HKIDChar == 'P' 
            || HKIDChar == 'e' ||  HKIDChar == 'p' )
                checkSum = 14;
        else if( HKIDChar == 'F' || HKIDChar == 'Q' 
            || HKIDChar == 'f' ||  HKIDChar == 'q' )
                checkSum = 15;
        else if( HKIDChar == 'G' || HKIDChar == 'R' 
            || HKIDChar == 'g' ||  HKIDChar == 'r' )
                checkSum = 16;
        else if( HKIDChar == 'H' || HKIDChar == 'S' 
            || HKIDChar == 'h' ||  HKIDChar == 's' )
                checkSum = 17;
        else if( HKIDChar == 'I' || HKIDChar == 'T' 
            || HKIDChar == 'i' ||  HKIDChar == 't' )
                checkSum = 18;
        else if( HKIDChar == 'J' || HKIDChar == 'U' 
            || HKIDChar == 'j' ||  HKIDChar == 'u' )
                checkSum = 19;
        else if( HKIDChar == 'K' || HKIDChar == 'V' 
            || HKIDChar == 'k' ||  HKIDChar == 'v' )
                checkSum = 20;
        return checkSum;
    }
    // method to validate HKID
    public void checkHKID( Account acc ){
        String[] HKId = new List<String>();
        Integer checkSum = 0;
        Integer checkDigit;
        if(acc.HKID_Card_No__pc != null && acc.HKID_Card_No__pc != ''){
            String temp;
            if(acc.HKID_Card_No__pc.contains('(') && acc.HKID_Card_No__pc.contains(')'))
            {
                temp = acc.HKID_Card_No__pc.replaceAll('\\(', '');
                temp = temp.replaceAll('\\)', '');
            }
            else
            {
                temp = acc.HKID_Card_No__pc;
            }
            if(temp.length() == 9 || temp.length() == 8)
            {
                if(temp.length() == 8)
                {
                    temp = ' '+temp;
                }
                system.debug('temp>>>>>>>>'+temp);
                if(Pattern.matches('^(?i)[a-z0-9\\s]{1}[a-z]{1}[0-9]{6}[a|A|0-9]{1}$', temp))
                {
                    HKId = temp.split('',0);
                    String str = temp.substring(temp.length() - 1, temp.length());
                    if(str != 'A' || str != 'a')
                    {
                        checkDigit = integer.valueOf(str);
                    }
                    else
                    {
                        checkDigit = 10;
                    }
                    if(HKId[1] == ' ')
                    {
                        checkSum = 58*9;
                    }
                    else if(!HKId[1].isNumeric())
                    {
                        checkSum = characterVal(HKId[1])*9;
                    }
                    else
                    {
                        checkSum = integer.valueOf(HKId[1])*9;
                    }
                    checkSum = checkSum + characterVal(HKId[2])*8 + integer.valueOf(HKId[3])*7 + 
                    integer.valueOf(HKId[4])*6 + integer.valueOf(HKId[5])*5 + integer.valueOf(HKId[6])*4 + 
                    integer.valueOf(HKId[7])*3 + integer.valueOf(HKId[8])*2;
                    checkSum = math.mod(checkSum, 11);
                    if(checkSum != 0)
                    {
                        checkSum  = 11 - checkSum ;
                    }
                    if(checkDigit != checkSum){
                        acc.addError('HKID Card Number Is Invalid');
                    }
                }
                else
                {
                    acc.addError('HKID Card Number Is Incorrect');
                }
            }
            else
            {
                acc.addError('HKID Card Number Is Incorrect');
            }
        }
    }

    // Method is used to check / validate SG od 
    public void checkSGID( Account acc ){
         String[] SGId = new List<String>();
        Integer checkSum = 0, actualVal;
        if( acc.NRIC_Number__pc != null && acc.NRIC_Number__pc != ''){
            if(Pattern.matches('^(?i)[s|f|t|g]{1}[0-9]{7}(?i)[a-z]{1}$', acc.NRIC_Number__pc)){
             
                SGId = (acc.NRIC_Number__pc).split('(?!^)');
                checkSum = ((integer.ValueOf(SGId[1]))*2) + ((integer.ValueOf(SGId[2]))*7)
                       + ((integer.ValueOf(SGId[3]))*6) + ((integer.ValueOf(SGId[4]))*5) 
                        + ((integer.ValueOf(SGId[5]))*4) + ((integer.ValueOf(SGId[6]))*3) 
                        + ((integer.ValueOf(SGId[7]))*2);
                
                if( SGId[0] == 's' || SGId[0] == 't'
                    || SGId[0] == 'S' || SGId[0] == 'T'){
    
                    if(  SGId[8] == 'A' || SGId[8] == 'a' )
                        actualVal = 10;
                    if(  SGId[8] == 'B' || SGId[8] == 'b' )
                        actualVal = 9;
                    if(  SGId[8] == 'C' || SGId[8] == 'c' )
                        actualVal = 8;
                    if(  SGId[8] == 'D' || SGId[8] == 'd' )
                        actualVal = 7;
                    if(  SGId[8] == 'E' || SGId[8] == 'e' )
                        actualVal = 6;
                    if(  SGId[8] == 'F' || SGId[8] == 'f' )
                        actualVal = 5;
                    if(  SGId[8] == 'G' || SGId[8] == 'g' )
                        actualVal = 4;
                    if(  SGId[8] == 'H' || SGId[8] == 'h' )
                        actualVal = 3;
                    if(  SGId[8] == 'I' || SGId[8] == 'i' )
                        actualVal = 2;
                    if(  SGId[8] == 'J' || SGId[8] == 'j' )
                        actualVal = 0;
                    if(  SGId[8] == 'Z' || SGId[8] == 'z' )
                        actualVal = 1;
                }else if( SGId[0] == 'F' || SGId[0] == 'G'
                    || SGId[0] == 'f' || SGId[0] == 'g'){
                    if(  SGId[8] == 'K' || SGId[8] == 'k' )
                        actualVal = 10; 
                    if(  SGId[8] == 'L' || SGId[8] == 'l' )
                        actualVal = 9;
                    if(  SGId[8] == 'M' || SGId[8] == 'm' )
                        actualVal = 8;
                    if(  SGId[8] == 'N' || SGId[8] == 'n' )
                        actualVal = 7;
                    if(  SGId[8] == 'P' || SGId[8] == 'p' )
                        actualVal = 6;
                    if(  SGId[8] == 'Q' || SGId[8] == 'q' )
                        actualVal = 5;
                    if(  SGId[8] == 'R' || SGId[8] == 'r' )
                        actualVal = 4;
                    if(  SGId[8] == 'T' || SGId[8] == 't' )
                        actualVal = 3;
                    if(  SGId[8] == 'U' || SGId[8] == 'u' )
                        actualVal = 2;
                    if(  SGId[8] == 'W' || SGId[8] == 'w' )
                        actualVal = 1;
                    if(  SGId[8] == 'X' || SGId[8] == 'x' )
                        actualVal = 0;
                }
            
                // Add extra 4 into total.
                if ( SGId[0] == 'T' || SGId[0] == 't'
                    || SGId[0] == 'G' || SGId[0] == 'g')
                        checkSum  = checkSum + 4;
                // Find mod
                checkSum  = math.mod(checkSum, 11);
                if (checkSum != actualVal ){
                    acc.addError('NRIC Number Is Invalid');
                }
            }else
                acc.addError('NRIC Number Is InCorrect');
        }
    }
    
    // method to set Account status as Synced when successfully synced with DWH
    public void setAccountDWHStatusSynced(List<Account> accList) {
        for (Account account : accList) 
        {
            account.DWH_Last_Sync__c = Datetime.now();
        }
    }
    
    // method to create/update Sync Queue records
    public void updateSyncQueueRecord(List<Account> lstAccount){
        Map<Id,List<Sync_Queue__c>> accountIdToSynchQueListMap = new  Map<Id,List<Sync_Queue__c>>();
        Set<Id> accountIdSet = new Set<Id>();
        Sync_Queue__c[] synchQueueUpdateList = new Sync_Queue__c[]{};
        Sync_Queue__c[] synchQueueCreateList = new Sync_Queue__c[]{};
        
        for (Account account : lstAccount) {
            accountIdSet.add(account.Id);
        }
        List<Sync_Queue__c> syncQueueList = [
            SELECT Account__c
                 , Notes__c
                 , Action__c
                 , Queued_Record_ID__c
                 , Sync_Status__c
                 , DWH_Data_Type__c
               FROM Sync_Queue__c 
              WHERE Sync_Status__c = :CRMS_Constants.SYNC_QUEUE_STATUS_PENDING
                AND Account__c IN :accountIdSet
         ];
         
        for (Sync_Queue__c syncQueue : syncQueueList) {
            if (accountIdToSynchQueListMap.containsKey(syncQueue.Account__c) == true) {
                accountIdToSynchQueListMap.get(syncQueue.Account__c).add(syncQueue);
            } else {
                accountIdToSynchQueListMap.put(syncQueue.Account__c, new Sync_Queue__c[] {syncQueue});
            }
        }
        
        for (Account account : lstAccount) {
            Sync_Queue__c[] synchQueueList = accountIdToSynchQueListMap.get(account.Id);
            if (synchQueueList != null && !synchQueueList.isEmpty()) {
                for (Sync_Queue__c synchQue : synchQueueList) {
                    if (synchQue.Action__c != CRMS_Constants.SYNC_ACTION_DELETE) {
                        synchQue.Sync_Status__c = CRMS_Constants.SYNC_STATUS_STALE;
                    }
                    String currentDateTime = Datetime.now().format() + CRMS_Constants.DWH_DELETE_TRIGGER;
                    //synchQue.Notes__c = currentDateTime;
                    synchQue.Queued_Record_ID__c = account.Id;
                    synchQue.Action__c = CRMS_Constants.SYNC_ACTION_DELETE;
                    synchQue.Sync_Status__c = CRMS_Constants.SYNC_STATUS_STALE;
                    synchQueueUpdateList.add(synchQue);
                }
            } 
            
            Sync_Queue__c syncQueue = new Sync_Queue__c();
            syncQueue.Queued_Record_ID__c = account.Id;
            if(account.isPersonAccount == true)
                syncQueue.DWH_Data_Type__c = CRMS_Constants.DWH_DATA_TYPE_CONTACT;
            else 
                syncQueue.DWH_Data_Type__c = CRMS_Constants.DWH_DATA_TYPE_ACCOUNT;
            syncQueue.Action__c = CRMS_Constants.SYNC_ACTION_DELETE;
            syncQueue.Sync_Status__c = CRMS_Constants.SYNC_QUEUE_STATUS_PENDING;
            String currentDateTime = Datetime.now().format() + CRMS_Constants.SYNC_STATUS_ACCOUNT_DELETED;
            //syncQueue.Notes__c = currentDateTime;
            synchQueueCreateList.add(syncQueue);
            
            
        }
        if (!synchQueueUpdateList.isEmpty()) {
            update synchQueueUpdateList;
        }
        if (!synchQueueCreateList.isEmpty()) {
            insert synchQueueCreateList;
        }
    } // end of updateSyncQueueRecord
    public void setBankDetails(List<Account> accList) {
        Map<String,Account> bankAccountMap = new Map<String,Account>();
        Map<String,Bank_Detail__c> bankNameBankObjectMap = new Map<String,Bank_Detail__c>();
        Set<String> bankNamesSet = new Set<String>();
        List<Bank_Detail__c> banksList = new List<Bank_Detail__c>();
        /*
        for(Account tempA : accList){
            bankNamesSet.add(tempA.Bank_Name__c);
            bankAccountMap.put( tempA.Bank_Name__c, tempA);            
        }
        
        banksList = [SELECT Id, Name, Country__c, Bank_Code__c, Bank_No__c,Account_Number__c,Sort_Code__c FROM Bank_Detail__c Where Name in :bankNamesSet];
       
        Account tempA;
        for (Bank_Detail__c tempBank : banksList) {
         tempA =  bankAccountMap.get(tempBank.Name);
            if(tempA != null) {
                system.debug('Miro - >>>tempA.Bank_Name__c '+tempA.Bank_Name__c + 'tempA.Bank_Account_Sort_Code__c ' + tempA.Bank_Account_Sort_Code__c);
                system.debug('Miro - >>>tempBank '+tempBank);
                if(tempA.Bank_No__c == null && tempBank.Bank_No__c != '') tempA.Bank_No__c = tempBank.Bank_No__c;
                if(tempA.Bank_Account_Sort_Code__c == null && tempBank.Sort_Code__c != '') tempA.Bank_Account_Sort_Code__c =  tempBank.Sort_Code__c;
                if(tempA.Bank_Account_Sort_Code__c   == null && tempBank.Bank_Code__c  != '') tempA.Bank_Account_Sort_Code__c   = tempBank.Bank_Code__c ;
                
                
            } 
        }
        */
        //system.debug('Miro ->>>bankAccountMap '+ bankAccountMap);
        //system.debug('Miro ->>> bankNameBankObjectMap'+ bankNameBankObjectMap);
        //system.debug('Miro ->>> bankNamesSet'+ bankNamesSet);
        //system.debug('Miro ->>> banksList '+ banksList);
        //system.debug('Miro ->>> accList'+ accList);
    }
    
    public void UpdatePartnerProgramName(map<ID, Account> OldMapAccounts, map<ID, Account> NewMapAccounts){
        map<ID, string> AccountRecordTypeMap = new map<ID, string>();
        list<ID> PartnerAccounts = new list<ID>();
        
        for(RecordType Rt : [Select r.Id,
                                r.Name 
                                From RecordType r 
                                where r.SobjectType = 'Account' AND r.DeveloperName like 'Partner%']){
            AccountRecordTypeMap.put(Rt.Id, Rt.Name);
        }
        
        for(Account Ac : NewMapAccounts.Values()){
            
            if(OldMapAccounts.get(Ac.Id).Name != Ac.Name 
                && AccountRecordTypeMap.get(Ac.RecordTypeId) != null){
                PartnerAccounts.add(Ac.Id);
            }
        }
        
        if(PartnerAccounts != null && PartnerAccounts.size() > 0){
            list<Program__c> ProgramsToUpdate = new list<Program__c>();
            for(Program__c prog : [Select p.Id,
                                    p.Name,
                                    p.Program_Name__c,
                                    p.Partner_name__r.Name,                                 
                                    p.Country__c 
                                    From Program__c p 
                                    Where Partner_name__c IN : PartnerAccounts]){
                ProgramsToUpdate.add(new Program__c(
                    Id = prog.Id,
                    Name = prog.Country__c + '-' + prog.Partner_name__r.Name
                ));
            }
            
            if(ProgramsToUpdate.size() > 0){
                update ProgramsToUpdate;
            }
        }       
    }
} // end of class