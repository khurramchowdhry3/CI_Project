@isTest
public class Loan_Product_Controller_Test {

    static testMethod void myUnitTest(){ 
        Product2 p = new Product2();
            p.Country__c ='UK1';
            p.Full_Term__c ='06 (180 days)';
            p.Product_Type__c = 'Loan';
            p.Interest_Type__c = 'Flat';
            p.Schedule_Type__c='Diminishing';
            p.Interest_Rate__c= 40;
            
        insert p;
        ApexPages.StandardController controller = new ApexPages.StandardController(p);
        Loan_Product_Controller ctrl1 = new Loan_Product_Controller(controller);
        
        ApexPages.currentPage().getParameters().put('id', p.id);

        Loan_Product_Controller ctrl = new Loan_Product_Controller(controller);
        ctrl.newRec();
        ctrl.save();
        ctrl.p.id=null;
        ctrl.p.Interest_Rate__c = 11;
        ctrl.save();
        ctrl.cancel();
        system.assertEquals(true, ctrl.p!=null);
        Loan_Product_Controller ctrl2 = new Loan_Product_Controller(controller);
        ctrl2.deleteRecord();
    }
}