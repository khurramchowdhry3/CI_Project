public class Loan_OpportunitySelectProduct_Controller {

    public Opportunity opp {get;set;}    
    public ID oppID {get;set;}
    public String selectedProduct {get;set;}
    public Boolean isWeekly {get;set;}
    
    public Loan_OpportunitySelectProduct_Controller(ApexPages.StandardController stdController){
		oppID = stdController.getID();
        opp = [Select ID,Program__c,Program_Product_ASO__r.Product__r.Schedule_Type__c, Program_Product_ASO__c,
               No_of_Repayments_Daily__c,Principal_Daily_Repayment__c,Interest_Daily_Repayment__c,Total_Amount_Repayable_Daily__c,Quotation_Total_Repaid_Daily__c,
               No_of_Repayments_Weekly__c,Principal_Weekly_Repayment__c,Interest_Weekly_Repayment__c,Total_Amount_Repayable_Weekly__c,Quotation_Total_Repaid_Weekly__c,
               Loan_Frequency__c,Loan_Interest__c,Loan_Term__c,Amount
               From Opportunity where id =: oppID][0];
        if(opp.Program_Product_ASO__r.Product__r.Schedule_Type__c == 'Weekly') isWeekly = true; 
        else if (opp.Program_Product_ASO__r.Product__r.Schedule_Type__c == 'Daily') isWeekly = false;
        selectedProduct = opp.Program_Product_ASO__c;
    }
    
    
    
    public List<SelectOption> getProducts () {
        List<SelectOption> optns = new List<SelectOption>();
        List<Program_Product_ASO__c> aso = new List<Program_Product_ASO__c>();
        
        aso = [Select id,Product__c, Product__r.Name From Program_Product_ASO__c where Program__c = :opp.Program__c];
         optns.add(new SelectOption('','--None--'));
        for(Program_Product_ASO__c pp:aso){
            optns.add(new SelectOption(pp.id,pp.Product__r.Name));
            
        }
        return optns;
    }
    
    public PageReference save(){
        system.debug('Opportunity save:'+ opp);
        opp.Program_Product_ASO__c = selectedProduct;
        update opp;
        
        System.debug('Dani' + UserInfo.getSessionId());
        
        PageReference ref = new PageReference('/'+opp.id);
        ref.setRedirect(true);
        return ref;     
    }
    
}