public class Loan_Overview_Controller {
    
    public Boolean isSearchedProgramLedgers {get;set;}  
    public Boolean isLoanSelected {get;set;}    
    public List<Loan_Ledger__c> loanList {get;set;}
    public Loan_Ledger__c r {get;set;}
    public ID recID{get;set;}        
    public String selectedProgram {get;set;}
    
    public Loan_Overview_Controller(){      
        recID = ApexPages.currentPage().getParameters().get('id');
            if(recID !=null) {
                r = [SELECT Id,Name,Status__c, LoanID__c, LoanStartDate__c, LoanEndDate__c, Borrowed_Amount__c, 
                      Outstanding_Amount__c, NewLoanEndDate__c, NumAvailablePaymentHolidays__c, Rules_Engine__c,
                      Rules_Engine__r.Max_payment_holiday_duration__c, Rules_Engine__r.Notification_days__c,Move_to_Suspension__c,
                      NewTotalPrincipalAmount__c, NewTotalInterestAmount__c, LoanCharges__c, LoanVAT__c,
                      NewRepaymentAmountPerInstallment__c, Account__c, Sign_Off_Date__c,Agreed_by_client__c,
                      EventStartDate__c, EventEndDate__c, EventAmount__c, EventProcessMethod__c, EventLoanTerm__c,
             		  EventAmountAllocation1__c, EventAmountAllocation2__c,BB_Num__c,BB_Date__c,BB_Amount__c, Rules_Engine__r.Repayment_method__c,
                      Total_Amount__c,Program_Product_ASO__r.Program__c, Progress__c,
                     LoanID__r.Contract_Signed_Received_Date__c,LoanID__r.Loan_Amount__c,LoanID__r.Total_Amount_Repayable__c,
                     Program_Product_ASO__r.Product__r.Name, Program_Product_ASO__r.Program__r.CurrencyISOCode, Program_Product_ASO__r.Product__r.Schedule_Type__c,
                     Program_Product_ASO__r.Product__r.Interest_Type__c,Program_Product_ASO__r.Product__r.Term__c,
                     Program_Product_ASO__r.Product__r.Interest_Rate__c
                      FROM Loan_Ledger__c where id = :recID][0];
            isLoanSelected = true;
            }
    }
                
    public List<SelectOption> getProgramsWithLedger(){
        List<SelectOption> optns = new List<SelectOption>();
        Map <Id,String> progNameMap = new Map <Id,String>();
        
        List<Loan_Ledger__c> ledg = new List<Loan_Ledger__c>();
        ledg = [Select LoanID__r.Program_Product_ASO__r.Program__c, LoanID__r.Program_Product_ASO__r.Program__r.Name From Loan_Ledger__c Where  LoanID__r.Program_Product_ASO__c != null];
        Map<ID,String> programNameMap = new Map <ID,String>();
        
        for(Loan_Ledger__c tempLedger : ledg){
            programNameMap.put(tempLedger.LoanID__r.Program_Product_ASO__r.Program__c, tempLedger.LoanID__r.Program_Product_ASO__r.Program__r.Name);
            //optns.add(new SelectOption(tempLedger.LoanID__r.Program_Product_ASO__r.Program__c,tempLedger.LoanID__r.Program_Product_ASO__r.Program__r.Name));
        } 
        
        for(ID tempProgID : programNameMap.keySet()){
            optns.add(new SelectOption(tempProgID,programNameMap.get(tempProgID)));
        }
        
        return optns;
    }    
    public void getLedgerFromProgram (){
        
        isSearchedProgramLedgers = true;
        loanList = new List<Loan_Ledger__c>();
        
        		system.debug('selectedProgram:'+selectedProgram);
        
        loanList = [Select Id,Account__c,Account__r.Name,LoanEndDate__c,Outstanding_Amount__c,LoanID__c, LoanID__r.Name, LoanID__r.Status__c, LoanID__r.Loan_Disbursed_Date__c,
                    LoanID__r.Total_Amount_Repayable__c, Total_Amount_Per_Installment__c,BB_Num__c, Progress__c,Borrowed_Amount__c
                    From Loan_Ledger__c Where LoanID__r.Program_Product_ASO__c != '' And LoanID__r.Program_Product_ASO__r.Program__c = :selectedProgram 
                    And Status__c != 'Completed'];
    }  
    public PageReference cancel(){
        PageReference pr = new PageReference('/apex/Loan_Overview');
        pr.setRedirect(true);
        return pr;
    }
}