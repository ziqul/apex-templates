/**
 * @author Maxim Sorokin [m.s.v.00a@gmail.com]
 */
@isTest
private class TimeSpanSchedulableTest {

    private static final String jobName = 'TestJob';

    @isTest
    private static void positive_execute() {
        Schedulable timeSpanSchedulable =
            new TimeSpanSchedulable(jobName, new ExecutableStub(), 5);

        Datetime nextRun = Datetime.now().addMinutes(5);

        String chronExpr =
            nextRun.second() + ' ' + // Seconds
            nextRun.minute() + ' ' + // Minutes
            nextRun.hour() + ' ' + // Hours
            nextRun.day() + ' ' + // Day_of_month
            nextRun.month() + ' ' + // Month
            '?' + ' ' + // Day_of_week
            nextRun.year(); // optional_year

        System.schedule(jobName, chronExpr, timeSpanSchedulable);
        timeSpanSchedulable.execute(null);
    }

    private class ExecutableStub
        implements TimeSpanSchedulable.Executable
    {
        public void execute(System.SchedulableContext sc) {
        }
    }
}