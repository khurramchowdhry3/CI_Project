@isTest
public class Loan_RulesEngine_Controller_Test {
    static testMethod void myUnitTest(){
     Product2 prod = new Product2(Name='UK-Loan-Miro');
     insert prod;
     Program__c prog = new Program__c(Name='UK-Miro');
     insert prog;
     Program_Product_ASO__c aso = new Program_Product_ASO__c(Program__c = prog.id, Product__c = prod.id);
     insert aso;
     Loan_Management__c re = new Loan_Management__c(Program_Product_ASO__c=aso.id); 
     insert re;
        
		ApexPages.StandardController controller = new ApexPages.StandardController(aso);
        Loan_RulesEngine_Controller ctrl1 = new Loan_RulesEngine_Controller(controller);
        
        ApexPages.currentPage().getParameters().put('id', aso.id);

        Loan_RulesEngine_Controller ctrl = new Loan_RulesEngine_Controller(controller);   
        ctrl.getPrograms();
        ctrl.getProducts();
        ctrl.getProfiles();
        ctrl.newRec();
        ctrl.refresh();
        ctrl.newRecord();
        
        List<Loan_Management__c> result = [Select ID From Loan_Management__c Where Program_Product_ASO__c = :aso.id];
        System.assertEquals(true, result!=null);
        ctrl.cancel();
        ctrl.deleteRecord();
        
    }
}