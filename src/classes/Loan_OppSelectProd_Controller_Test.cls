@isTest
public class Loan_OppSelectProd_Controller_Test {
    public static testmethod void testIt(){
        Program__c prog = new Program__c(Country__c = 'UK1');
        insert prog;
        Product2 prod = new Product2(Country__c = 'UK1');
        insert prod;    
        Program_Product_ASO__c ppas1 = new Program_Product_ASO__c(Program__c = prog.id, Product__c = prod.Id);
        insert ppas1; 
        
        Opportunity opp = new Opportunity(Program__c = prog.id, Name = 'MiroOppSelectProdTest', StageName = 'In Progress', CloseDate = Date.today().addDays(10));
        insert opp;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(opp);
        Loan_OpportunitySelectProduct_Controller ctrl1 = new Loan_OpportunitySelectProduct_Controller(controller);
        ctrl1.getProducts ();
        
        ctrl1.selectedProduct = ppas1.id;
        
        ctrl1.save();
        
        List<Opportunity> result = [Select ID,Program_Product_ASO__c From Opportunity Where id = :opp.Id];
        
        System.assertEquals(true, result[0].Program_Product_ASO__c == ppas1.id);
    }
}