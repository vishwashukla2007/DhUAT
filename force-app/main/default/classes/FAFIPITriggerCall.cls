/*************************************************************************************
* Name          :    FAFIPITriggerCall 
* Description   :    Apttus IPI Project
* Author        :    Sai Sivamgula
* Test Class    :    FAFIPITriggerCallTest
Modification Log
----------------
Date             Developer                Comments
------------------------------------------------------------------------------------------------------------
9/17/2018        Sai Sivamgula            Created
**************************************************************************************/

public with sharing class FAFIPITriggerCall { 

public static void UpdateFAFIDWAstatus(List<Central_Hub__c> FAFtgrList, MAP<Id, Central_Hub__c> fafOldMap) {

    set<Id> FAFID = new set<Id>();
    set<Id> PSID = new set<Id>();
    set<Id> IPIID = new set<Id>();
    set<string> cids = new set<string>();
    set<string> sids = new set<string>();
    set<date> eds = new set<date>();
    List<Platform_Specifics__c> PSList = new List<Platform_Specifics__c>();
    List<IPI_WA_Tasks__c > IPIList1 = new List<IPI_WA_Tasks__c >();
    List<IPI_WA_Tasks__c > IPIListUp = new List<IPI_WA_Tasks__c >();
    List<Central_Hub__c> FAFList = new List<Central_Hub__c>();
    Set<IPI_WA_Tasks__c> IPISet = new Set<IPI_WA_Tasks__c>();
    List<IPI_WA_Tasks__c> IPIListUp1 = new List<IPI_WA_Tasks__c>();

    if(fafOldMap != null){
    for(Central_Hub__c FAF: FAFtgrList){
         if((FAF.FAF_Status__c != null && fafOldMap.get(FAF.id).FAF_Status__c != FAF.FAF_Status__c 
              &&  FAF.FAF_Status__c == 'Implemented' )|| Test.isRunningTest()){
            System.debug('++++++1 FAFIPITriggerCall');
            FAFID.add(FAF.id);
            //FAFList.add(FAF);
        }  
      }
    }

    if(FAFID.size() >0){
        PSList =[select id,FAF_ID__r.name,Level_1_ID__c,Level_2_ID__c,EffectiveDate__c from Platform_Specifics__c where FAF_ID__c in:FAFID ];
        //System.debug('++++++ PSList'+PSList );
        if (PSList.size() >0){
            for(Platform_Specifics__c  ps1:PSList ){
                If (ps1.Level_1_ID__c != null){
                    cids.add(ps1.Level_1_ID__c) ;
                    }  
                sids.add(ps1.Level_2_ID__c) ;
                eds.add(ps1.EffectiveDate__c) ;
               
            }
            //System.debug('++++++ cids'+cids);
            //System.debug('++++++ sids'+sids);
            //System.debug('++++++ eds'+eds);
            IPIList1 = [select id,Super_Client_ID__c,Pricing_Effective_Date__c,Carrier_ID__c from IPI_WA_Tasks__c where  Pricing_Effective_Date__c IN: eds and Carrier_ID__c IN: cids]; // and Super_Client_ID__c IN:sids]; 07/17 Removed Level 2 change due to Pega Defect
             //System.debug('++++++ IPIList1 '+IPIList1 );
            if (IPIList1.size() >0){
                // System.debug('++++++2 FAFIPITriggerCall');     
                           
                   for(Platform_Specifics__c  ps2:PSList ){  
                                                                                   
                        for (IPI_WA_Tasks__c IWT: IPIList1 ){                        
                            //if(IWT.Super_Client_ID__c == ps2.Level_2_ID__c && IWT.Carrier_ID__c == ps2.Level_1_ID__c && IWT.Pricing_Effective_Date__c == ps2.EffectiveDate__c ){ // 07/17 Removed Level 2 change due to Pega Defect
                           if(IWT.Carrier_ID__c == ps2.Level_1_ID__c && IWT.Pricing_Effective_Date__c == ps2.EffectiveDate__c ){
                               IWT.FAF_ID__c = ps2.FAF_ID__r.name ;                           
                                IWT.Task_Status__c = 'Resolved-Complete';
                                IWT.Transaction_Complete_Timestamp__c = System.now();                   
                                IPIListUp.add(IWT);                           
                            }
                        }
                    }
                // ***Added to fix duplicate level 1 ID issue *** by Sneha Inturi ***
                   IPISet.addAll(IPIListUp);
                   IPIListUp1.addAll(IPISet);
                           
                    if(IPIListUp1.size() >0){
                  //System.debug('++++++3 IPIListUp'+IPIListUp);
                    Update IPIListUp1;
                  }
                            
                }
             }
          }  
       }
}