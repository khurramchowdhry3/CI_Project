public with sharing class LMRemoter {

    public LMRemoter(LM_LoanDetails_Controller parentController)
    {}
    
    @RemoteAction
    public static List<List<Date>> getPaymentHolidayRanges(string operationId)
    {
        List<List<Date>> lstPaymentHolidays = new List<List<Date>>();
        
        for(Loan_Management_Event__c lme : [SELECT Event_Date__c, Event_End_Date__c 
                                            FROM Loan_Management_Event__c 
                                            WHERE Operation__c =: operationId and Event_Type__c =: 'Payment Holiday' and IsActive__c =: true
                                            ORDER BY Event_Date__c
                                           ])
        {
            List<Date> lstDates = new List<Date>();
            lstDates.add(lme.Event_Date__c);
            lstDates.add(lme.Event_End_Date__c);
            
            lstPaymentHolidays.add(lstDates);
        }
        
        return lstPaymentHolidays;
    }
    
    @RemoteAction
    public static List<List<Date>> getCCARanges(string operationId)
    {
        List<List<Date>> lstCCA = new List<List<Date>>();
        for(Loan_Management_Event__c lme : [SELECT Event_Date__c, Event_End_Date__c 
                                            FROM Loan_Management_Event__c 
                                            WHERE Operation__c =: operationId and Event_Type__c =: 'Change Collection Amount' and IsActive__c =: true
                                            ORDER BY Event_Date__c
                                           ])
        {
            List<Date> lstDates = new List<Date>();
            lstDates.add(lme.Event_Date__c);
            lstDates.add(lme.Event_End_Date__c);
            
            lstCCA.add(lstDates);
        }
        
        return lstCCA;
    }
    
    @RemoteAction
    public static List<List<Date>> getDisabledRanges(string operationId, string eventType)
    {
        List<List<Date>> lstDisabled = new List<List<Date>>();
        List<List<Date>> lstPaymentHolidays = getPaymentHolidayRanges(operationId);
        List<List<Date>> lstCCA = getCCARanges(operationId);
        
        List<Operation__c> lstOperations = [SELECT First_Repayment_Date__c, Final_Repayment_Date__c, Program_Product_ASO__c FROM Operation__c WHERE Id =: operationId];        
        
        if(lstOperations.size() > 0)
        {
            Operation__c o = lstOperations[0];
            List<Loan_Management__c> lstRules = [SELECT Notification_days__c FROM Loan_Management__c WHERE Program_Product_ASO__c =: o.Program_Product_ASO__c];
            
            if (lstRules.size() > 0)
            {
                Loan_Management__c rules = lstRules[0];
                
                Date frd = o.First_Repayment_Date__c; //first repayment date
        		Date lrd = o.Final_Repayment_Date__c; // last repayment date
                Integer nd = Integer.valueOf(rules.Notification_days__c); // notification days
        		Date today = Date.today();
                Date dummyStart = Date.newInstance(2000, 1, 1); //dummy date, representing the Start of Time (1 Jan 2000)
                Date dummyEnd = Date.newInstance(2100, 12, 31); //dummy date, representing the End of Time and AMP (31 Dec 2100)
                List<Date> lstDates;
                
                if (today < CRMS_Util.AddBusinessDays(frd, nd*-1))
                {
                    lstDates = new List<Date>();
                    lstDates.add(dummyStart); 
                    //lstDates.add(today.addDays(-1));
                    lstDates.add(CRMS_Util.AddBusinessDays(frd, -1));
                    lstDisabled.add(lstDates);
                    
                    lstDates = new List<Date>();
                    lstDates.add(CRMS_Util.AddBusinessDays(lrd, 1));
                    lstDates.add(dummyEnd); 
                    lstDisabled.add(lstDates);
                }
                else if (today >= CRMS_Util.AddBusinessDays(frd, nd*-1) && today < CRMS_Util.AddBusinessDays(lrd, nd*-1))
                {
                    lstDates = new List<Date>();
                    lstDates.add(dummyStart);
                    if(lstPaymentHolidays.size() > 0)
                    {
                        Date startDate = today;
                        for(Integer i = 0; i < lstPaymentHolidays.size(); i++)
                        {
                            if (today < lstPaymentHolidays[i][0] && CRMS_Util.AddBusinessDays(today, nd + 1) >= lstPaymentHolidays[i][0] && CRMS_Util.AddBusinessDays(today, nd + 1) <= lstPaymentHolidays[i][1])
                            {
                                startDate = lstPaymentHolidays[i][0];
                                break;
                            }
                            else if (today >= lstPaymentHolidays[i][0] && today <= lstPaymentHolidays[i][1])
                            {
                                if (CRMS_Util.AddBusinessDays(today, nd + 1) <= lstPaymentHolidays[i][1])
                                	break;                                
                                else
                                    startDate = CRMS_Util.AddBusinessDays(today, nd + 1);
                            }
							else
                                startDate = CRMS_Util.AddBusinessDays(today, nd + 1);                            
                        }
                        
                        lstDates.add(CRMS_Util.AddBusinessDays(startDate, -1));
                        /*for(Integer i = 0; i < lstPaymentHolidays.size(); i++)
                        {
                            if(CRMS_Util.AddBusinessDays(today, nd) < lstPaymentHolidays[i][0] && CRMS_Util.AddBusinessDays(today, nd) > lstPaymentHolidays[i][1])
                                lstDates.add(CRMS_Util.AddBusinessDays(today, nd));
                            else 
                                lstDates.add(CRMS_Util.AddBusinessDays(today, -1));
                        }*/
                    }                        
                    else 
                    	lstDates.add(CRMS_Util.AddBusinessDays(today, nd));
                    lstDisabled.add(lstDates);
                    
                    lstDates = new List<Date>();
                    lstDates.add(CRMS_Util.AddBusinessDays(lrd, 1));
                    lstDates.add(dummyEnd);
                    lstDisabled.add(lstDates);
                }
                else
                {
                    lstDates = new List<Date>();
                    lstDates.add(dummyStart);
                    lstDates.add(dummyEnd); 
                    lstDisabled.add(lstDates);
                }
                
                if(eventType == 'Payment Holiday')
                {
                    if (lstPaymentHolidays.size() > 0)
                    {
                        lstDisabled.addAll(lstPaymentHolidays);
                    }
                }
                if(eventType == 'Change Collection Amount')
                {                
                    if (lstPaymentHolidays.size() > 0)
                    {
                        lstDisabled.addAll(lstPaymentHolidays);
                    }
                    if (lstCCA.size() > 0)
                    {
                        lstDisabled.addAll(lstCCA);
                    }
                }
            }
		}
        
        return lstDisabled;
    }
}