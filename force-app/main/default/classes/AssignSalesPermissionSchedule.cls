global class AssignSalesPermissionSchedule implements schedulable
{
    global void execute(SchedulableContext sc)
    {
     AssignSalesPermission b = new AssignSalesPermission(); //batch class
      database.executebatch(b);
    }
}