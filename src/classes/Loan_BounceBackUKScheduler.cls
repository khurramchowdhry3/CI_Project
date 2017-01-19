public class Loan_BounceBackUKScheduler implements Schedulable  {

    //Class runs everydat at 0 AM. 
    public static String cronString = '0 0 0 * * ?';

    public static String scheduleMe() {
        Loan_BounceBackUKScheduler SC = new Loan_BounceBackUKScheduler(); 
        return System.schedule('Bounce Back UK Scheduled Job '+system.now().format('dd/MM/yyyy', 'GMT+00:00'), cronString, SC);
    }

    public void execute(SchedulableContext sc) {
        Loan_BounceBackBatch objClass = new Loan_BounceBackBatch();
        Database.executeBatch(objClass);
    }
}