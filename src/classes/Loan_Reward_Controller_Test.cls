@isTest
public class Loan_Reward_Controller_Test {
     static testMethod void myUnitTest(){
     Product2 prod = new Product2(Name='UK-Loan-Miro');
     insert prod;
     Program__c prog = new Program__c(Name='UK-Miro');
     insert prog;
     Program_Product_ASO__c aso = new Program_Product_ASO__c(Program__c = prog.id, Product__c = prod.id);
     insert aso;
     Reward__c re = new Reward__c(Program_Product_ASO__c=aso.id); 
     insert re;
        
		ApexPages.StandardController controller = new ApexPages.StandardController(aso);
        Loan_Reward_Controller ctrl1 = new Loan_Reward_Controller(controller);
        
        ApexPages.currentPage().getParameters().put('id', aso.id);

        Loan_Reward_Controller ctrl = new Loan_Reward_Controller(controller);        
        //ctrl.getPPAS();             
        ctrl.newRec();       
        ctrl.newRecord(); 
        ctrl.getPrograms();
        ctrl.getProducts();
         
        ctrl.c.Amount__c = 11;
        ctrl.c.Calculation_method__c = 'Fixed';
        ctrl.c.Type__c = 'Split';
        ctrl.c.Start_Date__c = Date.today();
        ctrl.c.Source__c = 'Commission';     
         
        ctrl.i.Amount__c = 12;
        ctrl.i.Calculation_method__c = 'Fixed';
        ctrl.i.Type__c = 'Split';
        ctrl.i.Start_Date__c = Date.today();
        ctrl.i.Source__c = 'Incentive'; 
         
        ctrl.save();
        ctrl.cancel();
        ctrl.refresh();
        
        ctrl.countIdChosen=0;
        //ctrl.delRow();
        
        system.assertEquals(true, ctrl.c != null);
         ctrl.delRowComm();
         ctrl.delRowInc();
         ctrl.deleteRecord();
    }
}