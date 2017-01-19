public class Loan_Reward_Controller {
    public ID recID {get;set;}
    public static LoggingLevel logLevel = LoggingLevel.ERROR;
    public Program_Product_ASO__c r {get;set;}
    public List<Reward__c> commList {get;set;}
    public List<Reward__c> incList {get;set;}
    public Reward__c c {get;set;}
    public Reward__c i {get;set;}
    public boolean isNewOrEditRecord {get; set;}  
    public boolean disableAssociationDropdown {get;set;}
    
    public String selectedProgramVal{get;set;}    
    public String selectedProductVal{get;set;}    
    public String selectedProductType{get;set;}
    public String selectedPPVal{get;set;}
    public String currencyISO {get;set;}
    
    public List<Reward__c> delItemList;
    public Reward__c tempItem;
    public Integer countIdChosen {get; set;}
    public static Map<id,string> productIDandTypeMap = new Map<id,string>();
    Map<ID,String> programCurrencyCodeMap;     
    
    
    public String rewardType { get; set; }
    private map<string,string> mapCommission = new map<string,string>();
        
    
public Loan_Reward_Controller (ApexPages.StandardController stdController) {
    
         
        delItemList = new List<Reward__c>();
    
        recID = ApexPages.currentPage().getParameters().get('id');
        if (c==null) c = new Reward__c ();
        if (i==null) i = new Reward__c ();
        if (commList==null) commList = new List<Reward__c>();
        if (incList==null) incList = new List<Reward__c>();
        if (programCurrencyCodeMap==null) programCurrencyCodeMap = new Map<ID,String>();
        if(recID == null){
            this.r = (Program_Product_ASO__c)stdController.getRecord();
            
        }
        else
        {
            this.r = [SELECT Id, Program__c,Program__r.CurrencyISOCode, Product__c, Product__r.Product_Type__c,
                              (SELECT Id,Source__c, Type__c,Program_Product_ASO__c, Calculation_method__c, Amount__c,Disburse_Type__c,Sales_role__c,
                               Split_Start__c, Split_End__c
                               FROM Commissions__r) , CreatedByID,LastModifiedById,CreatedDate,LastModifiedDate 
                    FROM Program_Product_ASO__c Where id = :recID][0];
            currencyISO = r.Program__r.CurrencyISOCode;
            selectedProgramVal = r.Program__c;
            selectedPPVal = r.id;
            isNewOrEditRecord=true;
            //system.debug(logLevel, JSON.serializePretty(r));
            for (Reward__c tempReward : r.Commissions__r){
                if(tempReward.Source__c == 'Commission') {
                    commList.add(tempReward);
                    mapCommission.put(tempReward.Disburse_Type__c,tempReward.Type__c);
                }else if (tempReward.Source__c == 'Incentive'){
                    incList.add(tempReward);                    
                }
            }
            selectedProductType = r.Product__r.Product_Type__c;
            
        }   
        if(r.id != null) disableAssociationDropdown= true;
    
        
    }
    
    public List<SelectOption> getPrograms(){
        List<SelectOption> optns = new List<SelectOption>();
        Set<ID> addedPrograms = new Set<ID>();
        List<Program_Product_ASO__c> ppList = new List<Program_Product_ASO__c>();
        ppList = [Select Program__c,Program__r.Name,Program__r.CurrencyISOCode From Program_Product_ASO__c Where Reward__c = false];
        
        
        if(disableAssociationDropdown == true) {
            ppList = [Select Id,Program__c,Program__r.Name,Program__r.CurrencyISOCode From Program_Product_ASO__c Where ID =: selectedPPVal];
        }
        
        
        optns.add(new selectOption('null', '--None--' ));
         for(Program_Product_ASO__c p : ppList){   
           if(!addedPrograms.contains(p.Program__c)){   
               programCurrencyCodeMap.put(p.Program__c, p.Program__r.CurrencyISOCode);  
               optns.add(new selectOption(p.Program__c, p.Program__r.Name));               
               addedPrograms.add(p.Program__c);
           }
        }       
        return optns;
    }    
    public List<SelectOption> getProducts(){
        currencyISO = programCurrencyCodeMap.get(selectedProgramVal);
        List<SelectOption> optns = new List<SelectOption>();
        List<Program_Product_ASO__c> ppList = new List<Program_Product_ASO__c>();
        ppList = [Select Id,Product__r.Name 
                  From Program_Product_ASO__c 
                  Where Program__c = :selectedProgramVal And Reward__c = false
                  Order By Product__r.Name];
         
             
            system.debug('selectedProgramVal'+selectedProgramVal);
        if(disableAssociationDropdown == true) { 
             
            system.debug('in');
            ppList = [Select Id,Product__r.Name From Program_Product_ASO__c Where ID =: selectedPPVal];
        }
        optns.add(new selectOption('null', '--None--' ));
         for(Program_Product_ASO__c p : ppList){
           optns.add(new selectOption(p.ID, p.Product__r.Name));
        }        
        return optns;
    }
    public PageReference refresh()
    {
        selectedProductType = productIDandTypeMap.get(selectedProductVal);
        return null;
    }
    
    public PageReference save()
    { 
        if(rewardType == 'Commission' ){                              
            if(mapCommission.get(c.Disburse_Type__c) == null){
                c.Source__c = 'Commission';                
                commList.add(c);
                mapCommission.put(c.Disburse_Type__c,c.Type__c); 
            }else ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Commission has already been added for the &#8216;'+c.Disburse_Type__c+'&#8217; disburse Type'));
            c = new Reward__c (); 
        }
        if(rewardType == 'Incentive'){ 
            for(Reward__c Incentive : incList){
                if(Incentive.Sales_role__c == i.Sales_role__c && Incentive.Disburse_Type__c == i.Disburse_Type__c){            
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'For &#8216;'+i.Sales_role__c+'&#8217;, incentive has already been added for the &#8216;'+i.Disburse_Type__c+'&#8217; disburse type'));
                    i = new Reward__c ();                    
                    return null;
                }
            }
            i.Source__c = 'Incentive';   
            incList.add(i);            
            i = new Reward__c ();
        }
        return null;
    }
    public PageReference newRecord()
    {  
        
        if (commList.size() + incList.size() == 0)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No rewards were defined, the record will not be saved'));
            return null;
        }
        for(Reward__c cc : commList)
        {
            if(cc.Program_Product_ASO__c == null) cc.Program_Product_ASO__c = selectedPPVal;
        }        
        for(Reward__c ii : incList)
        {
            if(ii.Program_Product_ASO__c == null) ii.Program_Product_ASO__c = selectedPPVal;
        }
        
        upsert commList;        
        upsert incList;
        
        if(r.Id == null) r.id = selectedPPVal;
        r.Reward__c = true;
        update r;
        
        if(!delItemList.isEmpty()){
            delete delItemList;
        }
                 
        Pagereference pr = new Pagereference('/apex/Loan_Reward');
        if(recID == null) pr.getParameters().put('ID',r.id);
        pr.setRedirect(true);
        return pr;
    }
    public PageReference newRec()
    {
        isNewOrEditRecord = true;
        return null;
    }
    public PageReference deleteRecord () {
        delete commList;
        delete incList;
        
        r.Reward__c = false;
        update r;
        
        Pagereference pr = new Pagereference('/apex/Loan_Reward');
        pr.setRedirect(true);
        return pr;
    }
    public PageReference cancel () {        
        Pagereference pr = new Pagereference('/apex/Loan_Reward');
        pr.setRedirect(true);
        return pr;
    }
    public PageReference delRowComm(){
        Reward__c tempItem = commList.get(countIdChosen);
        if(tempItem.id != null) delItemList.add(tempItem);
        mapCommission.remove(tempItem.Disburse_Type__c);        
        commList.remove(countIdChosen);        
        return null;
    }    
    public PageReference delRowInc(){
        Reward__c tempItem = incList.get(countIdChosen);
        if(tempItem.id != null) delItemList.add(tempItem);
        incList.remove(countIdChosen);        
        return null;
    }
}