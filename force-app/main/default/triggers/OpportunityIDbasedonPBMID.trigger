/*************************************************************************************
* Name          :    OpportunityIDbasedonPBMID 
* Description   :    Trigger to update opportunity ID on record based on PBM opportunityID
                     & Pega integration call - PegaIpiWaSOAPcall.callPegaWAIPI()
* Author        :    Sai Sivamgula
* Test Class    :    PegaIpiWaSOAPcallTest
Modification Log
----------------
Date             Developer                Comments
------------------------------------------------------------------------------------------------------------
8/20/2018        Sai Sivamgula            Created
**************************************************************************************/

trigger OpportunityIDbasedonPBMID on IPI_WA_Tasks__c (before insert,before update, after update) 
{
set<Id> WACaseId = new set<Id>();
set<Id> IPIPegaIds = new set<Id>();
List<Opportunity> OppList = new List<Opportunity>();
List<IPI_WA_Tasks__c > IPIList = new List<IPI_WA_Tasks__c >();
List<IPI_WA_Tasks__c > IPIList1 = new List<IPI_WA_Tasks__c >();
List<IPI_WA_Tasks__c > IPIList2 = new List<IPI_WA_Tasks__c >();
set<string> PBMOppID= new set<string>();
for(IPI_WA_Tasks__c  IP: trigger.new){
    ////  Trigger to update opportunity ID on record based on PBM opportunityID
    if(IP.IPI_Opp_Id__c != null && 
       Trigger.isBefore && 
       (Trigger.isInsert || (trigger.isUpdate && trigger.oldMap.get(IP.id).IPI_Opp_Id__c != IP.IPI_Opp_Id__c ))){
       PBMOppID.add(IP.IPI_Opp_Id__c);
       IPIList.add(IP);
    }
    
    //// For Pega integration call 
    if(Trigger.isAfter && Trigger.isUpdate && IP.Task_Status__c != null && trigger.oldMap.get(IP.id).Task_Status__c  != IP.Task_Status__c 
    &&  IP.Task_Status__c == 'Resolved-Complete' ){
    IPIPegaIds.add(IP.id);
    IPIList2.add(IP);
    }
    
    
}


////  Trigger to update opportunity ID on record based on PBM opportunityID
if(PBMOppID.size()>0 && IPIList.size()>0){
OppList = [Select id, PBM_18_digit_ID__c from Opportunity where PBM_18_digit_ID__c =: PBMOppID];

    for (IPI_WA_Tasks__c Ip1: IPIList){
        for (Opportunity op:OppList){
            if(op.PBM_18_digit_ID__c == Ip1.IPI_Opp_Id__c){
                Ip1.Opportunity__c = op.id;
                break;
            }
        }
    }
    system.debug('++Finallist'+IPIList);
}


//// For Pega integration call 
if(IPIPegaIds.size() >0 && RecursiveHelperClass.IPIWAfirstRun){
    system.debug('++++IPIPegaIds'+IPIPegaIds);
    if(IPIPegaIds.size() >= 20){
            //Error Message
            for(IPI_WA_Tasks__c  IP2: IPIList2){
            IP2.addError('Cannot update for bulk items for task status - completed. Please upload 20 or <20 records at a time');
            }
    }else {
          for (id ipi: IPIPegaIds){
          system.debug('++++IPI'+ipi);
          PegaIpiWaSOAPcall.callPegaWAIPI(String.valueOf(ipi));
          RecursiveHelperClass.IPIWAfirstRun=false;
          }
    }
}



}