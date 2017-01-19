public class Loan_BounceBackEastAsiaScheduler implements Schedulable {

    //Class runs everydat at 0 AM GMT+8. 
    public static String cronString = '0 0 8 * * ?';

    public static String scheduleMe() {
        Loan_BounceBackEastAsiaScheduler SC = new Loan_BounceBackEastAsiaScheduler(); 
        return System.schedule('Bounce Back Asia Scheduled Job '+system.now().format('dd/MM/yyyy', 'GMT+08:00'), cronString, SC);
    }

    public void execute(SchedulableContext sc) {
        Loan_BounceBackBatch objClass = new Loan_BounceBackBatch();
        Database.executeBatch(objClass);
    }
 
}