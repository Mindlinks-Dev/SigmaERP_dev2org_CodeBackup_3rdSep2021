global with sharing class ScheduleforRenewal implements Schedulable
{
    global void execute(SchedulableContext SC) 
    {
        BatchClassforUpdateRecords be = new BatchClassforUpdateRecords();
        database.executeBatch(be,1);
    }
}