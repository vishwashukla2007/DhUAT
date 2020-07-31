global class changeDashboardAlertSched implements Schedulable {
   global void execute(SchedulableContext ctx) {
       changeDashboardAlertBatch p = new changeDashboardAlertBatch(null,false);
       database.executeBatch(p,1);
   }   
}