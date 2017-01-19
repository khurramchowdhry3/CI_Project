public with sharing virtual class LM_ComponentController extends ComponentControllerBase
{
    public Loan_Management_Event__c lme { get; set; }
    public LM_CalculationResult cr { get; set; }
    public Loan_Management__c rulesEngine { get; set; } // Rules Engine
    public boolean bIsCalculationActive { get; set; }
    public String infoMessage { get; set; }
    public boolean bIsComponentInitialized = false;
       
   	public override virtual void extendedSetterActions()
    {
    	
        if(!bIsComponentInitialized)
        {
            lme = new Loan_Management_Event__c();
            cr = new LM_CalculationResult();
            lme.Operation__c = ((LM_EventProcessor_Controller)pageController).o.Id;
            lme.Event_Type__c = ((LM_EventProcessor_Controller)pageController).EventType;
            
            bIsCalculationActive = true;
            bIsComponentInitialized = true;        
            
            if (((LM_EventProcessor_Controller)pageController).rules != null)
                rulesEngine = ((LM_EventProcessor_Controller)pageController).rules;
            else
            {
                infoMessage = 'Rules Engine is not defined for the Product associated to this loan.';
                disableCalculation();
            }
            
            if (lme.Event_Type__c != 'Change Collection Amount' && lme.Event_Type__c != 'Payment Holiday' && lme.Event_Type__c != 'Debt Collection')
            {
                string getParams = '?LoanId=' + lme.Operation__c + 
                				'&StartDate=' + CRMS_Util.DateToString(Date.today(), LMS_Constants.DATE_FORMAT_DWH) +
                				'&Days=' + String.valueOf(Integer.valueOf(rulesEngine.Notification_days__c) + 1) +
                				'&EventType=' + lme.Event_Type__c.replaceAll(' ', '%20');
            
            	lme.Effective_Date__c = Date.valueOf(((string)LMS_Callout.GetResultsMapFromResponse(LMS_Callout.CallOutGET(LMS_Constants.FirstRepDayEndPoint, getParams)).get('repaymentDay')).replace('T', ' '));
            }         
        }
        
    }
    
    public void disableCalculation()
    {
        lme = null;
        bIsCalculationActive = false;
    }   
    
}