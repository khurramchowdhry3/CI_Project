public class VF_ForTest_Controller 
{
    public string selectedValue { get; set; }
    public Loan_Management_Event__c lme { get; set; }
    
    public VF_ForTest_Controller()
    {
        lme = new Loan_Management_Event__c();
    }
    
    public void testAction()
    {
        System.debug('Dummy');
    }
}