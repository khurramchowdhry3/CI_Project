public with sharing class Loan_Program_Product_Redirect {
    
    private Program_Product_ASO__c Rec; 
    
    public Loan_Program_Product_Redirect(ApexPages.StandardController controller){
        this.Rec = (Program_Product_ASO__c)controller.getRecord();
    }
    
    Public PageReference RedirectToProductView(){
        Program_Product_ASO__c Rec = [Select Product__c from Program_Product_ASO__c Where Id=: this.Rec.id limit 1];
        PageReference ref = new PageReference('/apex/Loan_Product?id='+Rec.Product__c+'&sfdc.override=1');
        ref.setredirect(true);
        return ref;
    }
}