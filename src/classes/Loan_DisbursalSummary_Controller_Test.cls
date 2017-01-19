@isTest
public class Loan_DisbursalSummary_Controller_Test {
    public static testmethod void testIt(){
        CRMS_Util.generateEndpoints();        
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());        
        Program__c prog = new Program__c(Country__c = 'UK1');
        insert prog;
        Product2 prod = new Product2(Country__c = 'UK1',Term__c = '55');
        insert prod;    
        Product2 prod2 = new Product2(Country__c = 'UK2');
        insert prod2;        
        Program_Product_ASO__c ppas1 = new Program_Product_ASO__c(Program__c = prog.id, Product__c = prod.Id);
        insert ppas1;       
        Program_Product_ASO__c ppas2 = new Program_Product_ASO__c(Program__c = prog.id, Product__c = prod2.Id);
        insert ppas2;
        
        Loan_Management__c lm = new Loan_Management__c(Program_Product_ASO__c = ppas1.id,Max_number_of_payment_holidays__c = '5',Notification_days__c ='5', Grace_period__c = '5' );
        insert lm; 
        
        Opportunity opp = new Opportunity(Name = 'MiroTestDisbursalSummary', StageName = 'In Progress', CloseDate = Date.today().addDays(10));
        insert opp;
        
        Credit_Assessment__c ca = new Credit_Assessment__c(Opportunity__c = opp.id);
        insert ca;
        
        Operation__c op1 = new Operation__c(Opportunity__c = opp.id, Program_Product_ASO__c = ppas1.Id,Loan_Disbursed_Date__c = Date.today().addDays(-1),
                                            Final_Repayment_Date__c = Date.today().addDays(20), Number_of_Repayments__c = 3);
        insert op1;
        
 		ApexPages.currentPage().getParameters().put('id', op1.id);
        ApexPages.StandardController controller = new ApexPages.StandardController(op1);
        Loan_DisbursalSummary_Controller ctrl1 = new Loan_DisbursalSummary_Controller(controller);
        
        ctrl1.getProgramsFromOperation();
        ctrl1.selectedProgram = prog.id;
        ctrl1.getOps();
        system.assertEquals(false, ctrl1.opListForDisbursal.isEmpty());
        
        ctrl1.info();
        ctrl1.cancel();
        ctrl1.approve();
        
        
        system.assertEquals(true, ctrl1.r.Status__c == 'Disbursed');
    }}