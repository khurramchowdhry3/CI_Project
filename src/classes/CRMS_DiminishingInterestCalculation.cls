/*
CRMS_DiminishingInterestCalculation is the batch class for calculation Remaining Principal for
Philippines Operations records

Author          Version           Date          Description
Vivian            1.0           07/07/2015      Initial Draft
*/
global class CRMS_DiminishingInterestCalculation implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([Select o.Total_Daily_Repayment__c, o.No_of_Days__c,
                                        o.Principal_Daily_Repayments__c, o.Number_of_Repayments__c,
                                        o.Name, o.Monthly_Interest__c, o.Loan_Disbursed_Date__c,
                                        o.Loan_Amount__c, o.Interest_Daily_Repayment__c, o.Id,
                                        o.RecordType.Name, o.Total_Amount_Repayable__c,
                                        o.Outstanding_Principal__c, o.Repayments_Made__c,
                                        o.days__c
                                        From Operation__c o
                                        where o.RecordType.Name like '%Philippines'
                                        and o.Loan_Disbursed_Date__c != null
                                        and o.Outstanding_Principal__c >= 0]);
    }

    global void execute(Database.BatchableContext BC, List<Operation__c> lstOperations) {
        list<Operation__c> lstToUpdate = new list<Operation__c>();
        map<String,Integer> mapDayOfWeek_Days = new map<String,Integer>();
        mapDayOfWeek_Days.put('Monday',5);
        mapDayOfWeek_Days.put('Tuesday',7);
        mapDayOfWeek_Days.put('Wednesday',6);
        mapDayOfWeek_Days.put('Thursday',5);
        mapDayOfWeek_Days.put('Friday',5);

        for(Operation__c objOperation : lstOperations) {
            objOperation.days__c = objOperation.days__c != null? (objOperation.days__c + 1): 0;
            Datetime dt = DateTime.newInstance(objOperation.Loan_Disbursed_Date__c,
            Time.newInstance(0, 0, 0, 0));
            //String disbursedDayOfWeek = dt.format('EEEE');
            if(objOperation.Loan_Disbursed_Date__c.daysBetween(date.today()) >=
            mapDayOfWeek_Days.get(dt.format('EEEE'))
            && objOperation.Loan_Disbursed_Date__c.daysBetween(date.today()) <=
            objOperation.No_of_Days__c) {
                Datetime currentDate = DateTime.newInstance(date.today(),
                Time.newInstance(0, 0, 0, 0));
                if(currentDate.format('EEEE') != 'Saturday'
                && currentDate.format('EEEE') != 'Sunday') {
	                objOperation.Outstanding_Principal__c = objOperation.Outstanding_Principal__c -
	                objOperation.Principal_Daily_Repayments__c;
	                objOperation.Repayments_Made__c = objOperation.Repayments_Made__c + 1;
                } // reduce outstanding principal only on Weekdays
            }
            lstToUpdate.add(objOperation);
        }

        if(!lstToUpdate.isEmpty()){
            update lstToUpdate;
        }
    } // end of execute

    public void finish(Database.BatchableContext info) {
    }
} // end of class