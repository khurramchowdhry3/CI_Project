public with sharing class LM_PaymentHoliday_Controller extends LM_ComponentController {

    public String maxHolidayDur {get; set;}
    public String notDays {get; set;}

    public override void extendedSetterActions() 
    {	
        if(!bIsComponentInitialized){	//The setter is called multiple times and we don't want to overwrite if initialization is already done
        
            super.extendedSetterActions();
            
            Operation__c o = ((LM_EventProcessor_Controller)pageController).o;
            Loan_Management__c rules = ((LM_EventProcessor_Controller)pageController).rules;
            
            notDays = rules.Notification_days__c;
            maxHolidayDur = rules.Max_payment_holiday_duration__c;
            String maxHolidays = rules.Max_number_of_payment_holidays__c;
            Integer remHolidays = Integer.valueOf(rules.Max_number_of_payment_holidays__c) - Integer.valueOf(o.Number_Payment_Holidays__c);
            
            if (maxHolidays == '0' || maxHolidayDur == '0') 
            {
                disableCalculation();
                infoMessage = 'Payment Holiday is not allowed for the Program - Product association which is used.';
            }            
            else if(remHolidays == 0)
            {
                disableCalculation();
                infoMessage = 'The client has reached the allowed Payment Holidays.';
            }
            
        }
    }
}