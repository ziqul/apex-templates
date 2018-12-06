/**
 * @author Maxim Sorokin [m.s.v.00a@gmail.com]
 */
public class TimeSpanSchedulable implements Schedulable {

    private String jobName;
    private Executable executable;
    private Integer minutesSpan;

    public TimeSpanSchedulable(
        String jobName,
        Executable executable,
        Integer minutesSpan)
    {
        this.jobName = jobName;
        this.executable = executable;
        this.minutesSpan = minutesSpan;
    }

    public void execute(SchedulableContext sc) {
        List<CronTrigger> thisSchedulerInList =
            [SELECT Id
               FROM CronTrigger
              WHERE CronJobDetail.JobType = '7' AND
                    CronJobDetail.Name = :this.jobName];

        if (thisSchedulerInList.size() > 0) {
            String cronid = thisSchedulerInList.get(0).Id;
            System.abortJob(cronid);
        }

        this.executable.execute(sc);

        Datetime nextRun = Datetime.now().addMinutes(this.minutesSpan);

        String chronExpr =
            nextRun.second() + ' ' + // Seconds
            nextRun.minute() + ' ' + // Minutes
            nextRun.hour() + ' ' + // Hours
            nextRun.day() + ' ' + // Day_of_month
            nextRun.month() + ' ' + // Month
            '?' + ' ' + // Day_of_week
            nextRun.year(); // optional_year

        Schedulable schedulable =
            new TimeSpanSchedulable(
                this.jobName, this.executable,
                this.minutesSpan);

        System.schedule(this.jobName, chronExpr, schedulable);
    }

    public interface Executable {
        void execute(SchedulableContext sc);
    }
}