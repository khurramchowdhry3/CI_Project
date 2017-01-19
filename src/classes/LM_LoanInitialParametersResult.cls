public class LM_LoanInitialParametersResult {
    public String Reason { get; set; }
    public String Result { get; set; }
    public DateTime FirstRepaymentDate { get; set; }
    public DateTime FinalRepaymentDate { get; set; }   
    public Decimal interestAmount { get; set; } 
    public Decimal vatAmount    {get; set;}
    public Decimal repaymentPerInstallment  {get; set;}
    public Integer repaymentsNum { get; set; }
    public Decimal principalAmount    {get; set;}
   
   
   
   /*  
   
   public DateTime FirstRepaymentDate { get; set; }
    public DateTime FinalRepaymentDate { get; set; }
    public Decimal ActualInterestAmount { get; set; }
    public Decimal RemainingInterestAmount { get; set; }
    public Decimal ActualPrincipalAmount { get; set; }
    public Decimal RemainingPrincipalAmount { get; set; }
    public Integer ActualRepaymentsNum { get; set; }
    public Integer RemainingRepaymentsNum { get; set; }
   
   
    "reason": "Success",
      "result": "Success",
      "firstRepaymentDate": "2016-09-22T00:00:00",
      "finalRepaymentDate": "2016-12-13T00:00:00",
      "principalAmount": 70000.0,
      "interestAmount": 4832.88,
      "vatAmount": 579.95,
      "repaymentPerInstallment": 1278.2,
      "repaymentsNum": 59

.{"requestId":"","objectName":"LoanInitialParameters","timestamp":"2016-09-16T12:02:25.1417238Z","results":[{"reason":"Success","result":"Success","firstRepaymentDate":"2016-09-23T00:00:00","finalRepaymentDate":"2016-12-14T00:00:00","principalAmount":70000.00,"interestAmount":4832.88,"vatAmount":579.95,"repaymentPerInstallment":1278.20,"repaymentsNum":59}]}

Original Principal -> Principal_Amount__c
Original Interest -> Interest_Amount__c
Original VAT -> VAT_Amount__c
Actual VAT Amount -> Actual_VAT_Amount__c (the VAT corresponding to Actual_Interest_Amount__c, we may not need it for Loan Detail panel)
Outstanding VAT -> Loan_Outstanding_VAT_Amount__c (we may not need it for current status panel)
Original Installment -> Repayment_Per_Installment__c
Current Installment -> Actual_Repayment_Per_Installment__c


please note that at the beginning Principal_Amount__c = Actual_Principal_Amount__c = Loan_Outstanding_Principal_Amount__c

The same is for Interest 3 fields and VAT 3 fields
*/
}