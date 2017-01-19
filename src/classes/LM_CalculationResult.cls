public class LM_CalculationResult 
{
    public Loan_Management_Event__c lme  { get; set; }
    public Program_Product_ASO__c PPASO { get; set; }
    
    public decimal AccFeesAmount { get; set;}
    public decimal InterestVATAmount { get; set; }
    public decimal AccFeesVatAmount { get; set; }
    public decimal EventFeeAmount { get; set; }
    public decimal EventFeeVATAmount { get; set; }
    public DateTime LoanEndDate { get; set; }
    public decimal InterestAmount { get; set; }
    public decimal PrincipalAmount { get; set; }
    public Id ProgramProductSFId 
    { 
        get; 
        set
        {
            ProgramProductSFId = value;
            if (ProgramProductSFId != null)
            	PPASO = [SELECT Product__r.Full_Term__c, Product__r.Schedule_Type__c, Product__r.Interest_Rate__c
                        FROM Program_Product_ASO__c 
                        WHERE Id =: this.ProgramProductSFId][0];
        }
    }
    public String Reason { get; set; }
    public String Result { get; set; }
    public decimal ActualTotalInterestAmount { get; set; }
    public decimal ActualTotalVATAmount { get; set; }
    public integer ActualTotalRepaymentsNum { get; set; }
    public integer RepaymentsNum { get; set; }
    public decimal RepaymentPerInstallment { get; set; }
    public String LoanStatus { get; set; }
    
    public string EventFeeAmountWithVAT
    {
        get
        {
            return CRMS_Util.DecimalToString(EventFeeAmount + EventFeeVATAmount) + ' (incl. VAT ' + CRMS_Util.DecimalToString(EventFeeVATAmount) + ')';
        }        
    }
    
    public string AccFeesAmountWithVAT
    {
        get
        {
            return CRMS_Util.DecimalToString(AccFeesAmount + AccFeesVatAmount) + ' (incl. VAT ' + CRMS_Util.DecimalToString(AccFeesVatAmount) + ')';
        }
    }
    
    public decimal TotalAmountNoInterest
    {
        get
        {
            return (PrincipalAmount != null ? PrincipalAmount : 0) + 
                	(lme.Event_Type__c == 'Top-up' ? lme.Event_Amount__c : 0) +
                			(AccFeesAmount != null ? AccFeesAmount : 0) +
                			(AccFeesVATAmount != null ? AccFeesVATAmount : 0) +
                			(lme.Waive_Fee__c ? 0 : (EventFeeAmount != null ? EventFeeAmount : 0)) +
                			(lme.Waive_Fee__c ? 0 : (EventFeeVATAmount != null ? EventFeeVATAmount : 0));
        }
    }
    
    public decimal TotalAmount
    {
        get
        {
            return TotalAmountNoInterest +
                		(InterestAmount != null ? InterestAmount : 0) +
                		(InterestVATAmount != null ? InterestVATAmount : 0);
        }
    }
    
    public decimal EventAmount
    {
        get
        {
            return lme.Event_Amount__c;
        }
    }

	public string LoanTerm
    {
        get
        {
            return PPASO.Product__r.Full_Term__c;
        }
    }
    
    public string LoanFrequency
    {
        get
        {
            return PPASO.Product__r.Schedule_Type__c;
        }
    }
    
    public decimal LoanInterest
    {
        get
        {
            return PPASO.Product__r.Interest_Rate__c;
        }
    }
}