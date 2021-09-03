/*=====================================================================================================
Author     : Vidit Kumar
Company    : Mindlinks Solution Pvt Ltd.
Date       : 18 Jul 2018
Description: Scheduler to call BudgetServiceClass to insert Budget Transaction
=======================================================================================================*/
global with sharing class BudgetSchedule implements Schedulable 
{
   global void execute(SchedulableContext SC) 
   {
        BudgetServiceClass B = new BudgetServiceClass (); 
        B.createBudgetTransaction();
        b.BudgetNotification();
   }
}