@isTest(seeAllData = true)
public class Loan_Management_Controller_Test {
    public static testmethod void  testIt () {
        
        //CRMS_Util.generateEndpoints();
        
        Test.setMock(HttpCalloutMock.class, new CRMS_HttpCalloutMock());
        Program__c prog = new Program__c(Country__c = 'UK1');
        insert prog;
        Product2 prod = new Product2(Country__c = 'UK1',Term__c = '55');
        insert prod;    
        Program_Product_ASO__c ppas1 = new Program_Product_ASO__c(Program__c = prog.id, Product__c = prod.Id);
        insert ppas1;   
        
        Account acc = new Account(Type = 'Client', Name = 'MiroTestLMAccount');
        insert acc;
        Account accResult = [Select Id, Name, Client_ID__c From Account Where ID = :acc.id][0];
        Loan_Management__c lm = new Loan_Management__c(Program_Product_ASO__c = ppas1.id,Max_number_of_payment_holidays__c = '5',
                                                       Notification_days__c ='5', Grace_period__c = '5' );
        insert lm;         
        Opportunity opp = new Opportunity(Name = 'MiroTestDisbursalSummary', StageName = 'In Progress', CloseDate = Date.today().addDays(10),
                                         AccountId   = acc.id,  Country__c = 'UK');
        insert opp;        
        Credit_Assessment__c ca = new Credit_Assessment__c(Opportunity__c = opp.id, Business_Trading_Name__c   = acc.Id);
        insert ca;
        Operation__c op1 = new Operation__c(Account__c = acc.id, Opportunity__c = opp.id, Program_Product_ASO__c = ppas1.Id,Loan_Disbursed_Date__c = Date.today().addDays(-1),
                                            Final_Repayment_Date__c = Date.today().addDays(20), Number_of_Repayments__c = 3);
        insert op1;       
        Loan_Ledger__c lr = new Loan_Ledger__c(Account__c = acc.id, Program_Product_ASO__c = ppas1.id, Sign_Off_Date__c = Date.today(),
                                               LoanID__c = op1.id, Agreed_by_client__c = true,InputFromScreen__c = 'bounceBackSection',
                                              Borrowed_Amount__c = 10000, Outstanding_Amount__c = 5000);
        insert lr;
        
        Loan_Management_Controller wrongC = new Loan_Management_Controller();
        
         ApexPages.currentPage().getParameters().put('AccountID', acc.id);     
         Loan_Management_Controller c = new Loan_Management_Controller();
        
         c.clientID = accResult.Client_ID__c;
         c.getClients();
         system.assertEquals(false, c.clientList.isEmpty());
         c.clientList = null;
         c.clientID = null;
         c.clientName = accResult.Name;
         c.getClients();      
         system.assertEquals(false, c.clientList.isEmpty());
        
         c.getProgramsWithLedger();
         c.selectedProgram = prog.id;
         c.getLedgerFromProgram();
        
        system.assertEquals(false, c.loanList.isEmpty());
        
        c.moveToSuspension();
        
        List<Loan_Ledger__c> result1 = [Select Id, Move_to_Suspension__c From Loan_Ledger__c Where Account__c = :acc.Id];
        
        system.assertEquals(true, result1[0].Move_to_Suspension__c);
        c.AccountID = acc.Id;
        c.lr.InputFromScreen__c = 'restructureSection';
        c.screenSelected = 'restructureSection';
        c.agreedByClient = true;
        c.signOff();
        
        c.screenSelected = 'topUpSection';
        c.lr.InputFromScreen__c = 'topUpSection';
        c.signOff();
        
        List<Opportunity> result2 = [Select Id,Type  From Opportunity Where AccountID = :acc.Id And ID != :opp.id];
        
        system.assertEquals('Restructure', result2[0].Type);
        system.assertEquals('Top-up', result2[1].Type);
        
        c.calculation();
        
        c.EventStartDate = String.valueOf(Date.today());
         c.EventEndDate = String.valueOf(Date.today().addDays(1));
        c.EventAmount = '10000';
        c.EventAmountAllocation1 = '';
        c.EventAmountAllocation2 = '';
         System.HttpResponse response = new System.HttpResponse ();    
            response.setStatus('OK');
            response.setStatusCode(200);
        String body = '{"requestId":"","objectName":"LoanScheduleDetail","timestamp":"2015-12-17T09:27:38.9588006Z","results":[{"result":"Success","reason":"Success",'+
            '"newEndDate":"2016-04-02T00:00:00","newPrincipalAmount":1111,"newInterestAmount":2222,"loanVATAmount":33.00,"loanChargesAmount":44,'+
            '"programProductSFId":"' +ppas1.id + '"}]}';
            response.setBody(body);
        
        c.calculationResponse(response);
    }
}