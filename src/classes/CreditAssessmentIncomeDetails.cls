public class CreditAssessmentIncomeDetails 
{
    public String MonthId { get; set; }
    public decimal PaidInAmount { get; set;}
    public decimal PaidOutAmount { get; set; }
    
    public CreditAssessmentIncomeDetails( String month, decimal paidin, decimal paidout)
    {
        MonthId = month;
        PaidInAmount = paidin;
        PaidOutAmount = paidout;
    }

}