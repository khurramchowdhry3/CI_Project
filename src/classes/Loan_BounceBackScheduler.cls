public class Loan_BounceBackScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        Loan_BounceBackBatch objClass = new Loan_BounceBackBatch();
        Database.executeBatch(objClass);
    }
}