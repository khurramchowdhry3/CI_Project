public class Loan_Program_Controller {
    public ID recID {get; set;}
    public boolean isStepTwo {get; set;}
    public boolean isNewRecord {get; set;}    
    public boolean isEditRecord {get; set;}
    public boolean isRecordSaved {get; set;}
    public boolean disableIsActive {get; set;}
    public boolean isDeleteActive {get; set;}
    public boolean hasErrors { get; set; }
    
    public Program__c p  {get; set;}      
    public String selectedPartner{get; set;}    
    public String selectedBankVal{get; set;} 
    public String selectedProductVal{get; set;}
    public Account partner {get; set;}
    public Integer countIdChosen{get; set;}
    
    public List<Program__c> allPrograms {get; set;}
    public List<Bank_Detail__c> banks {get; set;}
    public Map<String,Account> accMap {get; set;}
    public List<Program_Product_ASO__c> aso {get; set;} 
    public List<Program_Product_ASO__c> delItemList {get; set;}
    
    public String disableIsActiveHelpMsg {get; set;}
    
    public Loan_Program_Controller(ApexPages.StandardController stdController) {
        
        recID = ApexPages.currentPage().getParameters().get('id');
        isStepTwo = true; 
        
        
        
        if(recID == null)
        {
            this.p = (Program__c)stdController.getRecord();
            isRecordSaved = false;
        }            
        else
        {
            this.p = [Select Id, Channel_partner__c, Country__c, CreatedById, CreatedDate, CurrencyIsoCode, IsDeleted, End_Date__c,
                      LastModifiedById, LastModifiedDate, Name, OwnerId, Partner_name__c, Program_Name__c, RecordTypeId, 
                      Revenue_Share_P__c, Revenue_share__c, Start_Date__c, SystemModstamp, Check_Name__c, isActive__c,
                      Partner_name__r.Name,Partner_name__r.Bank_Account_Number__c,Partner_name__r.Bank_Name__c,
                      Partner_name__r.Bank_Account_Holder_Name__c,Partner_name__r.Bank_Name_Lookup__c,
                      Partner_name__r.Bank_No__c,Partner_name__r.Bank_Branch_No__c,Partner_name__r.Bank_Account_Sort_Code__c,
                      Originator_Name__c,Institution_Code__c                       
                      FROM Program__c Where id = :recID][0];
                      //
            isNewRecord=true;
            isRecordSaved = true;
            selectedPartner = p.Partner_name__c;
            
            partner = new Account(Name = p.Partner_name__r.Name,
                                  Bank_Account_Number__c = p.Partner_name__r.Bank_Account_Number__c,
                                  Bank_Account_Sort_Code__c = p.Partner_name__r.Bank_Account_Sort_Code__c,
                                  //Bank_No__c = p.Partner_name__r.Bank_No__c,
                                  Bank_Name_Lookup__c = p.Partner_name__r.Bank_Name_Lookup__c,
                                  Bank_Account_Holder_Name__c = p.Partner_name__r.Bank_Account_Holder_Name__c,
                                  Bank_Branch_No__c = p.Partner_name__r.Bank_Branch_No__c
                                 );
            aso = [Select Id, Name, Program__c, Product__c, Product__r.Name,
                   //(Select Status__c From Operations__r Where Status__c Not In ('Completed', 'Loan Withdrawn', 'Cancelled')),
                   //(Select IsClosed From Opportunities__r Where IsClosed = false)
                   
                   (Select Status__c From Operations__r),   //LMS-153 - hide Delete/Remove option if a program/product has been used once
                   (Select IsClosed From Opportunities__r)
                   From Program_Product_ASO__c Where Program__c = :p.Id Order By Product__r.Name];
            
            disableIsActive = true;
            
            if([select Id from Operation__c where Program_Product_ASO__r.Program__c =:p.Id and Status__c Not In ('Completed', 'Loan Withdrawn', 'Cancelled')].size() > 0)
                disableIsActiveHelpMsg = 'There is an active Loan using this Program';
            else if([select Id from Opportunity where Program__c  =:p.Id and IsClosed = false].size() > 0)
                disableIsActiveHelpMsg = 'There is a live Opportunity using this Program';
            else if([select Id from Lead where Program__c  =:p.Id and Converted__c = false].size() > 0)
                disableIsActiveHelpMsg = 'There is a live Lead using this Program';
            else 
                disableIsActive = false;
                      
            //LMS-153 - hide Delete/Remove option if a program/product has been used once
            if([select Id from Lead where Program__c  =:p.Id].size() > 0 ||
               [select Id from Opportunity where Program__c  =:p.Id].size() > 0 || 
               [select Id from Operation__c where Program_Product_ASO__r.Program__c =:p.Id].size() > 0)
                    isDeleteActive = false;
                else
                    isDeleteActive = true;
        }
        //if(p.Country__c == null)  p.Country__c = 'UK';
        //if(p.Partner_name__c == null)  {p.Partner_name__r = new Account(); p.Partner_name__r.Name = 'Partner Name';}
        if(isNewRecord != true) getAllPrograms();
        if(accMap == null){ accMap = new Map<String,Account>();}
        if(partner == null ) partner = new Account(Name='Partner Name');
        if(aso == null) aso = new List<Program_Product_ASO__c>();
        if(delItemList == null) delItemList = new List<Program_Product_ASO__c>();
        if(disableIsActive == null) disableIsActive = false;
        if(isDeleteActive == null) isDeleteActive = true;
        
        hasErrors = false;
    }
    
   
    public PageReference addAssociation()
    {
        for(Program_Product_ASO__c ppaso : aso){
            //Avoid duplicate Products
            if(ppaso.Product__c == selectedProductVal) return null;
            
        }
        
        aso.add(new Program_Product_ASO__c(Program__c = p.Id,Product__c=selectedProductVal, CurrencyISOCode = p.CurrencyIsoCode));
        
        //This is here and not in save() because else the Product Name stays empty due to using reference    
        upsert aso;        
         aso = [SELECT Id, Name, Program__c, Product__c, Product__r.Name FROM Program_Product_ASO__c where Program__c = :p.Id Order By Product__r.Name];

            Pagereference pr = new Pagereference('/apex/Loan_Program');
            pr.getParameters().put('ID',p.id);
            pr.setRedirect(true);
            return pr;
    } 
    public PageReference delRow(){
        //system.debug('countIdChosen'+ countIdChosen);
        Program_Product_ASO__c tempItem = aso.get(countIdChosen);//system.debug('tempItem'+ tempItem);
        //if(tempItem.id != null)  delItemList.add(tempItem);//system.debug('delItemList'+ delItemList);
        delete tempItem;
        
        aso = [SELECT Id, Name, Program__c, Product__c, Product__r.Name FROM Program_Product_ASO__c where Program__c = :p.Id Order By Product__r.Name];

            Pagereference pr = new Pagereference('/apex/Loan_Program');
            pr.getParameters().put('ID',p.id);
            pr.setRedirect(true);
            return pr;
    }
    
    private void getAllPrograms(){
        allPrograms = new List<Program__c>();
        allPrograms =[Select id,Name,CreatedBy.Name,CreatedBy.ID, LastModifiedDate, isActive__c from Program__c Order by LastModifiedDate DESC];
    }
    
    public List<SelectOption> getProductOptions(){
        List<SelectOption> optns = new List<SelectOption>();
        List<Product2> prodList = new List<Product2>();
        Set<Id> selectedProdList = new Set<Id>();
        for(Program_Product_ASO__c tempASO : aso){
            selectedProdList.add(tempASO.Product__c);
        }
        prodList = [Select id,Name From Product2 Where Country__c = :p.Country__c And ID NOT IN :selectedProdList Order By Name];
        for(Product2 b : prodList){
           optns.add(new selectOption(b.id, b.Name));
        }            
        return optns;
    }
    public List<SelectOption> getPartnerNameOptions(){
        List<SelectOption> optns = new List<SelectOption>();
        List<Account> accList;
        accList = new List<Account>();
        accMap = new Map<String,Account>();
        //partner = new Account();
        String recType;
        
            //Get Account Record types for Partner dropdown
            Map<String,ID> accPartnerRecTypesMap = new Map<String,ID>();
            List<RecordType> accPartnRecTypes = new List<RecordType>();
            accPartnRecTypes = [Select Name,ID from RecordType where SobjectType = 'Account' and Name like '%Partner%' ];
            for(RecordType rt : accPartnRecTypes){
                accPartnerRecTypesMap.put(rt.Name, rt.Id);
            } 
        system.debug('p.Country__c' + p.Country__c);
        
            if(p.Country__c =='UK') recType = 'Partner UK';
            else if (p.Country__c =='SG') recType = 'Partner SG';        
            else if (p.Country__c =='PH') recType = 'Partner PP';
            else if (p.Country__c =='HK') recType = 'Partner HK';       
        accList = [Select ID,Name,Bank_Account_Number__c,Bank_Account_Holder_Name__c,Bank_No__c,Bank_Branch_No__c,Bank_Account_Sort_Code__c,Bank_Name__c from Account where RecordTypeID = : accPartnerRecTypesMap.get(recType) order by Name]; //
        optns.add(new selectOption('','--None--'));
        // before getting here you must populate your queryResult list with required fields
        for(Account a : accList){
           accMap.put(a.id,a);
           optns.add(new selectOption(a.Id, a.Name));

        }
        
                
        return optns;
    }
    public PageReference getPartnerAccount(){
        if(selectedPartner!=null&&!accMap.isEmpty()){
            partner = accMap.get(selectedPartner);
             system.debug('inside:'+selectedPartner);
            
        }
        system.debug('partner:'+partner);
        
        return null; 
    } 
    
    public PageReference save (){
        
        try{
            p.Partner_name__c = selectedPartner;
            p.CurrencyIsoCode = AMP_Utils.getCurrencyISOByCountryCode(p.Country__c);
            system.debug('p'+p);
            p.Partner_name__r = null;
            upsert p;
            isStepTwo = true;  
            
            if(!delItemList.isEmpty()){
                delete delItemList;
            }
            
            isRecordSaved = true;
            //system.debug('aso:'+JSON.serializePretty(selectedProductVal));
            
            Pagereference pr = new Pagereference('/apex/Loan_Program');
            //pr.getParameters().put('ID',p.id);
            pr.setRedirect(true);
            return pr;
            
        }catch(DmlException e){
            String mess = e.getMessage();
            system.debug('mess :: '+mess);
            String existingID = mess.substringAfter('id: ').removeEnd(': []');
            system.debug('existingID:' + existingID);
            boolean checkName = mess.containsIgnoreCase('Check_Name__c');
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'A program with the same name already exists. You can open it <b><a href="Loan_Program?ID='+existingID+'" style="margin:0 0px;">here</a></b> ');
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, checkName ? 'A program with the same name already exists. You can open it <b><a href="Loan_Program?ID='+existingID+'" style="margin:0 0px;">here</a></b> ' : 'Sorry :/');
            system.debug(' myMsg :: '+myMsg);
            ApexPages.addMessage(myMsg);
            if(existingID != null && existingID != '')
                hasErrors = true;
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,mess));
        }   
        return null;
        
    }
     
    public PageReference newRec()
    {
        isNewRecord = true;
        return null;
    } 
    public PageReference deleteRecord () {
        delete aso;
        delete p;
        
        Pagereference pr = new Pagereference('/apex/Loan_Program');
        pr.setRedirect(true);
        return pr;
    }    
    public PageReference cancel () {
        Pagereference pr = new Pagereference('/apex/Loan_Program');
        pr.setRedirect(true);
        return pr;
    }

}