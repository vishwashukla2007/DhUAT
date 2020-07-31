global class Batch_NetworkPricingUpdateSchedule implements Schedulable {
    
    global void execute(SchedulableContext sc){
        Database.executeBatch(new Batch_UpdateNetworkPricing(),200);
    }

}