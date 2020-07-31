public with sharing class TPAFormTriggerHelper{
/*=================================================================================
* @Method Name       : updateTPAForm
* @author            : Sonal Sharma(Accenture)
* @created date      : 
* @Last modified by  : Sonal Sharma(Accenture)
* @Purpose           : Update TPA Form with Maintenance Choice Network and 90 Day Network based on Network Name
======================================================================================= */
    Public static void updateTPAForm(List<TPA_Form__c> NewList){
        Set<ID> clientId = new Set<ID>();
        Map<id,String> tpa =new Map<id,String>();
        Map<id,TPA_Form__c> tpaMap =new Map<id,TPA_Form__c>(); //map should contain id of fafobj and tpa form id.
        List<TPA_Form__c> tpList=new List<TPA_Form__c>();
        Map<id,TPA_Form__c> fafTpaMap= new Map<id,TPA_Form__c>();
        Map<id, id> networkFAFMap= new Map<id,id>();
        List<Central_Hub__c> fafList= new List<Central_Hub__c>();
        List<Network_Pricing__c> ntwrkList= new List<Network_Pricing__c>();
        try{
            for(TPA_Form__c tpaForm: NewList){
                clientId.add(tpaForm.Client_Info_ID__c); //get client id related to tpa form
                tpaMap.put(tpaForm.Client_Info_ID__c, tpaForm);
            }
            
            if(clientId.size()>0){
            //list to get the faf id from client info
            
                fafList= [select id, Client_Info__c from Central_Hub__c where Client_Info__c IN: clientId];
            }
            
            //iterate the list for network pricing. then check if the same faf id exists. if fafid exits then map to that fafid in a map otherwise create a new map id with the faf name.
            if(!fafList.isEmpty()){
                ntwrkList= [Select id, Network_Name__c, FAF_ID__c from Network_Pricing__c where FAF_ID__c IN: fafList];
                for(Central_Hub__c fafObj :fafList){
                    fafTpaMap.put(fafObj.id, tpaMap.get(fafObj.Client_Info__c)); //map of faf and tpa form 
                }
                //iterate over faf list and associated network pricing
            }
            
            
            if(!ntwrkList.isEmpty()){
                for(Network_Pricing__c ntwrkObj : ntwrkList){
                        if(ntwrkObj.Network_Name__c.startsWith('MC')){
                            //if Maintenance_Choice_Network1__c is already yes than skip the part
                            if(fafTpaMap.get(ntwrkObj.FAF_ID__c).Maintenance_Choice_Network1__c!='yes'){
                                fafTpaMap.get(ntwrkObj.FAF_ID__c).Maintenance_Choice_Network1__c='Yes';
                                fafTpaMap.get(ntwrkObj.FAF_ID__c).X90_Day_Network__c='No';
                                tpList.add(fafTpaMap.get(ntwrkObj.FAF_ID__c));
                                networkFAFMap.put(ntwrkObj.FAF_ID__c,ntwrkObj.id);
                            }
                            
                        }else if(!ntwrkObj.Network_Name__c.startsWith('MC') && (ntwrkObj.Network_Name__c.contains('90'))){
                            if(fafTpaMap.get(ntwrkObj.FAF_ID__c).X90_Day_Network__c!='yes'){
                                fafTpaMap.get(ntwrkObj.FAF_ID__c).X90_Day_Network__c='Yes';
                                fafTpaMap.get(ntwrkObj.FAF_ID__c).Maintenance_Choice_Network1__c='No';
                                tpList.add(fafTpaMap.get(ntwrkObj.FAF_ID__c));
                                networkFAFMap.put(ntwrkObj.FAF_ID__c,ntwrkObj.id);
                            }
                            
                        }else if(!ntwrkObj.Network_Name__c.startsWith('MC') && (!ntwrkObj.Network_Name__c.contains('90'))){
                            System.debug('if network name does not conatins 90');
                            if(!networkFAFMap.containsKey(ntwrkObj.FAF_ID__c)){
                                fafTpaMap.get(ntwrkObj.FAF_ID__c).X90_Day_Network__c='No';
                                fafTpaMap.get(ntwrkObj.FAF_ID__c).Maintenance_Choice_Network1__c='No';
                                tpList.add(fafTpaMap.get(ntwrkObj.FAF_ID__c));
                            }
                            
                        }
                }
            }
            
        }catch(Exception e){
            System.debug('exception '+e);
        }
    }
}