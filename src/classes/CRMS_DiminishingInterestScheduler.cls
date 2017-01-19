/*
CRMS_DiminishingInterestCalculation is the batch class for calculation Remaining Principal for
Philippines Operations records

Author          Version           Date          Description
Vivian            1.0           08/07/2015      Initial Draft
*/
public class CRMS_DiminishingInterestScheduler implements Schedulable {

    //Class runs everydat at 3 AM.
    public static String cronString = '0 0 3 * * ?';

    public static String scheduleMe() {
        CRMS_DiminishingInterestScheduler SC = new CRMS_DiminishingInterestScheduler(); 
        return System.schedule('Diminishing Interest Calculation '+system.now(), cronString, SC);
    }

    public void execute(SchedulableContext sc) {
        CRMS_DiminishingInterestCalculation objClass = new CRMS_DiminishingInterestCalculation();
        Database.executeBatch(objClass);
    }
}