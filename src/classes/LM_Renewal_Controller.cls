public with sharing class LM_Renewal_Controller extends LM_ComponentController{    
    public override void extendedSetterActions() 
    {	
        if(!bIsComponentInitialized){	//The setter is called multiple times and we don't want to overwrite if initialization is already done
            super.extendedSetterActions();
        	bIsCalculationActive = false;
            /*
            Operation__c o = ((LM_EventProcessor_Controller)pageController).o;
            
            Boolean IsError = false;
            Boolean IsDisbursed = o.Disbursal_Approve__c == null ? false : o.Disbursal_Approve__c;
            String opStatus = o.Status__c;
            
            
            if(!IsDisbursed)
            {
                IsError = true;
                infoMessage = 'The current loan of the client is in disbursal stage yet.';
            }        
            else if (opStatus != 'Completed')
            {
                IsError = true;
                infoMessage = 'The current loan of the client is not yet completed.';
            }
            
            if(IsError)
            {
				disableCalculation();
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, infoMessage);
                ApexPages.addMessage(msg);
            }
			*/
        }
    }
}