public class D_TestMainController 
{
    public Loan_Management_Event__c str { get; set; }
    
	public D_TestMainController()
    {
        str = new Loan_Management_Event__c();
        str.Event_Amount__c = 100;
    }
}