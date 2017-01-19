public class D_TestMidController 
{
    public Loan_Management_Event__c mstr { get; set; }
    public D_TestMainController mcon { get; set; }
    
	public D_TestMidController(D_TestMainController pcon)
    {
		mcon = pcon; 
        System.debug(pcon);
        System.debug(mcon);
    }
    
    /*public D_TestMidController()
    {
        
    }*/
}