public class Loan_RulesEngine_Controller {
    
    public ID recID {get;set;}
    public List<Loan_Management__c> rList {get;set;}
    public Loan_Management__c r {get;set;}
    public Program_Product_ASO__c rec {get;set;}
    public Map<id,string> PPASCurrency {get;set;}
    public boolean disableAssociationDropdown {get;set;}
    public string BounceBack1    {get;set;}
    public string BounceBack2    {get;set;}
    public string BounceBack3    {get;set;}
    
    public boolean isNewOrEditRecord {get; set;}
    public boolean flagNoOpportunityExist   {get; set;}{
        flagNoOpportunityExist = false;
    }
    
    public String selectedRolesVal1{get;set;}   
    public String selectedRolesVal2{get;set;}    
    public String selectedRolesVal3{get;set;}

    public String selectedProgramVal{get;set;}      
    public String selectedPPVal{get;set;}
    public String currencyISO {get;set;}    
    Map<ID,String> programCurrencyCodeMap; 
    
 public Loan_RulesEngine_Controller (ApexPages.StandardController stdController) {
        
        if(PPASCurrency==null)  PPASCurrency = new Map<ID,String>();
        if (programCurrencyCodeMap==null) programCurrencyCodeMap = new Map<ID,String>();
     
        rList = new List<Loan_Management__c>();
     
        r = new Loan_Management__c();
    
        recID = ApexPages.currentPage().getParameters().get('id');
        if(recID == null)
            this.rec = (Program_Product_ASO__c)stdController.getRecord();
        
        else
        {
            this.rec = [SELECT Id, Program__c,Program__r.CurrencyISOCode, Product__c, Product__r.Product_Type__c
                        FROM Program_Product_ASO__c Where id = :recID][0];
            
            rList = [SELECT Id, Name, Program_Product_ASO__r.Program__r.CurrencyISOCode, LastModifiedDate, LastModifiedById, Repayment_method__c, 
                          Action1__c, Action2__c, Action3__c, Num_of_Bounce_Backs__c, Num_of_Bounce_Backs2__c, Num_of_Bounce_Backs3__c, Assigned_to1__c, Assigned_to2__c, Assigned_to3__c, 
                          Charges_waiver__c, Top_ups__c, Min_principal_repaid__c, Second_Person_Approval__c, Second_Level_Limit__c, Allow_Cancellation__c, Cancellation_Period__c,
                          Documentary_Stamp_Tax__c, Loan_Cancellation_Amount__c, Loan_Cancellation_Minimum__c, Loan_Early_Payoff_Amount__c, Loan_Early_Payoff_Minimum__c, 
                          Loan_Restructure_Amount__c, Loan_Restructure_Minimum__c, Manual_Repayment_Handling_Fixed__c, Origination_Fee_Amount__c, Origination_Fee_Minimum__c, 
                          Reversal_Fee_Fixed__c, Value_Added_Tax__c, Wire_Transfer_Handling_Fee_Fixed__c, Funding_Pool__c, Second_Level_Signatory__c,  Program_Product_ASO__c,
                          Program_Product_ASO__r.Program__c, Program_Product_ASO__r.Program__r.Name, Completion_Days__c,
                          Grace_period__c, Notification_days__c, Max_number_of_payment_holidays__c, Max_payment_holiday_duration__c, Minimum_of_principal_repaid__c,
                          Origination_Fee_Fixed__c, Wire_Transfer_Handling_Fee_Amount__c, Wire_Transfer_Handling_Fee_Minimum__c, Loan_Cancellation_Fixed__c, 
                          Loan_Early_Payoff_Fixed__c, Loan_Restructure_Fixed__c, Reversal_Fee_Amount__c, Reversal_Fee_Minimum__c, Manual_Repayment_Handling_Amount__c, 
                          Manual_Repayment_Handling_Minimum__c, Fee_payment_method__c,CreatedById,CreatedDate
                     FROM Loan_Management__c where Program_Product_ASO__c = :recID];
            if(!rList.isEmpty()){
                r = rList[0];
                BounceBack1 = r.Num_of_Bounce_Backs__c; 
                BounceBack2 = r.Num_of_Bounce_Backs2__c; 
                BounceBack3 = r.Num_of_Bounce_Backs3__c; 
            }
            currencyISO = rec.Program__r.CurrencyISOCode;
            selectedProgramVal = rec.Program__c;
            selectedPPVal = rec.id;
            
            if([select Id from Opportunity where Program_Product_ASO__c =:recID].size() > 0 || 
               [select Id from Operation__c where Program_Product_ASO__c =:recID].size() > 0){
            	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'There are loans in the system assigned to this rule. Changes on this page, will affect their loan behavior and fee calculation.'));
                flagNoOpportunityExist = false;     
            }else flagNoOpportunityExist = true;
            
            isNewOrEditRecord=true;
        }
     
     disableAssociationDropdown = (selectedPPVal != null);
     selectedRolesVal1 = r.Assigned_to1__c; selectedRolesVal2 = r.Assigned_to2__c ; selectedRolesVal3 = r.Assigned_to3__c;
 }
    
    public void RefreshBounceBackList(){
        integer index = this.ProfileIndex();
        if(BounceBack1 != NULL && BounceBack1 != 'None'){
            r.Action1__c = 'Refer case';            
            selectedRolesVal1 = this.getProfiles()[index].getValue();
        }else {
            r.Action1__c = null;
            selectedRolesVal1 = this.getProfiles()[0].getValue();
        }
        if(BounceBack2 != NULL && BounceBack2 != 'None'){
            r.Action2__c = 'Refer case';
            selectedRolesVal2 = this.getProfiles()[index].getValue();
        }else {
            r.Action2__c = null;
            selectedRolesVal2 = this.getProfiles()[0].getValue();
        }
        if(BounceBack3 != NULL && BounceBack3 != 'None'){
            r.Action3__c = 'Refer case';
            selectedRolesVal3 = this.getProfiles()[index].getValue();
        }else {
            r.Action3__c = null;
            selectedRolesVal3 = this.getProfiles()[0].getValue();
        }
        
        //system.debug('BounceBack1 :: '+BounceBack1);
        //system.debug('BounceBack2 :: '+BounceBack2);
        //system.debug('BounceBack3 :: '+BounceBack3);
    }
    
    private integer ProfileIndex(){
       
        if(currencyISO == 'HKD'){
            return 15;
        }else if(currencyISO == 'PHP'){
            return 16;
        }else if(currencyISO == 'SGD'){
            return 17;
        }else if(currencyISO == 'GBP'){
            return 18;
        }
        return 0;
    }
    
    public list<SelectOption> getBounceBacks1(){
        list<SelectOption> BounceBackList = new list<SelectOption>();
        BounceBackList.add(new SelectOption('None', '--None--'));
        for(integer i=1; i<=10; i++){        
            if(BounceBack2 == string.valueOf(i) || BounceBack3 == string.valueOf(i)) continue;      
            BounceBackList.add(new SelectOption(string.valueOf(i),string.valueOf(i)));
        }        
        return BounceBackList;       
    }
    
    public list<SelectOption> getBounceBacks2(){
        list<SelectOption> BounceBackList = new list<SelectOption>();
        BounceBackList.add(new SelectOption('None', '--None--'));
        for(integer i=1; i<=10; i++){        
            if(BounceBack1 == string.valueOf(i) || BounceBack3 == string.valueOf(i)) continue;      
            BounceBackList.add(new SelectOption(string.valueOf(i),string.valueOf(i)));
        }               
        return BounceBackList;
    }
    
    public list<SelectOption> getBounceBacks3(){
        list<SelectOption> BounceBackList = new list<SelectOption>();
        BounceBackList.add(new SelectOption('None', '--None--'));
        for(integer i=1; i<=10; i++){
            if(BounceBack1 == string.valueOf(i) || BounceBack2 == string.valueOf(i)) continue;      
            BounceBackList.add(new SelectOption(string.valueOf(i),string.valueOf(i)));
        }        
        return BounceBackList;
    }
    
    public List<SelectOption> getPrograms(){
        List<SelectOption> optns = new List<SelectOption>();
        Set<ID> addedPrograms = new Set<ID>();
        List<Program_Product_ASO__c> ppList = new List<Program_Product_ASO__c>();
        
        if (disableAssociationDropdown) //rules engine already created
            optns.add(new SelectOption(r.Program_Product_ASO__r.Program__c, r.Program_Product_ASO__r.Program__r.Name));
        else
        {
            ppList = [Select Program__c,Program__r.Name,Program__r.CurrencyISOCode From Program_Product_ASO__c Where Rules_Engine__c = false Order By Program__r.Name];
            optns.add(new selectOption('', '--None--' ));
            for(Program_Product_ASO__c p : ppList){
                if(!addedPrograms.contains(p.Program__c)){                 
                    programCurrencyCodeMap.put(p.Program__c, p.Program__r.CurrencyISOCode);  
                    optns.add(new selectOption(p.Program__c, p.Program__r.Name));
                    addedPrograms.add(p.Program__c);
                }
            } 
        }
        return optns;
    }    
    public List<SelectOption> getProducts(){
        //currencyISO = programCurrencyCodeMap.get(selectedProgramVal);
        if(!disableAssociationDropdown)
            if(selectedProgramVal != null && selectedProgramVal != 'null' && selectedProgramVal != '')
                currencyISO = programCurrencyCodeMap.get(selectedProgramVal);
            else 
                currencyISO = '';
                
        List<SelectOption> optns = new List<SelectOption>();
        List<Program_Product_ASO__c> ppList = new List<Program_Product_ASO__c>();
        ppList = [Select Id,Product__r.Name 
                  From Program_Product_ASO__c 
                  Where Program__c = :selectedProgramVal And Rules_Engine__c = false
                  Order By Product__r.Name];
        if(disableAssociationDropdown== true) {
            ppList = [Select Id,Product__r.Name 
                  From Program_Product_ASO__c 
                  Where ID =: selectedPPVal];
        }
        optns.add(new selectOption('', '--None--' ));
                
        for(Program_Product_ASO__c p : ppList){
           optns.add(new selectOption(p.ID, p.Product__r.Name));
        } 
        
        return optns;
    }
    

    public List<SelectOption> getProfiles(){
        List<SelectOption> optns = new List<SelectOption>();
        List<Profile> profList = new List<Profile>();
        profList = [Select id, Name from Profile Order By Name];  
            optns.add(new selectOption('', '--None--'));
         for(Profile p : profList){
            optns.add(new selectOption(p.ID, p.Name));
        }       
        
        return optns;
    }
        
    public PageReference newRec()
    {
        isNewOrEditRecord = true;
        return null;
    }
     public PageReference refresh()
    {
       // system.debug(logLevel, 'selectedProductVal:' + selectedProductVal);
        //system.debug(logLevel, 'productIDandTypeMap.get(selectedProductVal):' + productIDandTypeMap.get(selectedProductVal));
        return null;
    }  
    
    public PageReference newRecord()
    {   
        r.Assigned_to1__c = selectedRolesVal1; r.Assigned_to2__c = selectedRolesVal2; r.Assigned_to3__c = selectedRolesVal3;
        r.Num_of_Bounce_Backs__c = BounceBack1; 
        r.Num_of_Bounce_Backs2__c = BounceBack2; 
        r.Num_of_Bounce_Backs3__c = BounceBack3;        
                       
        if(rec.id == null) {
            
            rec.id = selectedPPVal;          
            disableAssociationDropdown= true;
            r.CurrencyIsoCode = rec.Program__r.CurrencyISOCode;
        } 
                    
        if(r.Program_Product_ASO__c == null) r.Program_Product_ASO__c = rec.id;
        upsert r; 
        
        rec.Rules_Engine__c = true;
        update rec;
        
        Pagereference pr = new Pagereference('/apex/Loan_RulesEngine');
        pr.setRedirect(true);
        return pr;
    }    
    public PageReference deleteRecord () {
        
        delete r; 
        
        rec.Rules_Engine__c = false;
        update rec;
        
        Pagereference pr = new Pagereference('/apex/Loan_RulesEngine');
        pr.setRedirect(true);
        return pr;
    }    
    public PageReference cancel () {
        Pagereference pr = new Pagereference('/apex/Loan_RulesEngine');
        pr.setRedirect(true);
        return pr;
    }
}