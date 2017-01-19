@isTest
public class Loan_Program_Controller_Test {
 static testMethod void myUnitTest(){ 

 List<RecordType> accPartnRecTypes = new List<RecordType>();
            accPartnRecTypes = [Select Name,ID from RecordType where SobjectType = 'Account' and Name like '%Partner%'];
     for(RecordType rt : accPartnRecTypes)  {
         
     }  
 Product2 prod = new Product2();  
 insert prod;    
     
 Program__c prog = new Program__c();
 insert prog;
     
 ApexPages.StandardController controller = new ApexPages.StandardController(prog);
 Loan_Program_Controller ctrl1 = new Loan_Program_Controller(controller);
     
 ApexPages.currentPage().getParameters().put('id', prog.id);

 Loan_Program_Controller ctrl = new Loan_Program_Controller(controller);
     
     ctrl.selectedProductVal = prod.id;
     ctrl.countIdChosen = 0;
     
 ctrl.addAssociation();  
 ctrl.newRec();
 ctrl.delRow();   
     
 ctrl.save();
     
 //ctrl.getBankOptions();    
 ctrl.getProductOptions();
 ctrl.getPartnerAccount();
 ctrl.getPartnerNameOptions();
     
     
 ctrl.p.id = null;
 ctrl.save();
     
 system.assertEquals(true, ctrl.p!=null);
 }   
}