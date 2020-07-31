/* =================================================================================
 * @Class Name        : Batch_UpdateNetworkPricing
 * @author            : Mohit Srivastava(Accenture)
 * @created date      : 13/07/2018
 * @Purpose           : Deep Clone functionality
=======================================================================================*/
global class Batch_UpdateNetworkPricing implements Database.Batchable<sObject>, Database.Stateful {
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(Label.Batch_UpdateNetworkPricing_Label);
        

    }
    global void execute(Database.BatchableContext bc, List<Network_Pricing__c> scope){
    
        Set<id> ids=new set<id>();
        Set<id> FAFids=new set<id>();
        map<Id,Decimal> mapGuar=new map<Id,Decimal>();
        map<Id,Boolean> mapBol=new map<Id,Boolean>();
        map<String,String> mapstr=new map<String,String>();
        Map<id,date> MapYear1Begin = new Map<id,date>();
        Map<id,date> MapYear1End = new Map<id,date>();
        Map<id,date> MapYear2Begin = new Map<id,date>();
        Map<id,date> MapYear2End = new Map<id,date>();
        Map<id,date> MapYear3Begin = new Map<id,date>();
        Map<id,date> MapYear3End = new Map<id,date>();
        Map<id,date> MapYear4Begin = new Map<id,date>();
        Map<id,date> MapYear4End = new Map<id,date>();
        Map<id,date> MapYear5Begin = new Map<id,date>();
        Map<id,date> MapYear5End = new Map<id,date>();
        Map<id,Set<String>> MapYearComb = new Map<id,Set<String>>();
          Set<String> yearstr=new Set<String>();
        
       List<Retail_Network_Name_Translations__mdt> CustomMetaList=[SELECT Label,Translated_Network_Name__c FROM Retail_Network_Name_Translations__mdt];
      
            for(Network_Pricing__c  netObj : scope){
               ids.add(netObj.id);
               FAFids.add(netObj.FAF_ID__c);
               
            }
           for(Network_Pricing__c  netObj : scope){
               yearstr.add(netObj.Year__c);
               if(netObj.Year__c=='All'){
               MapYearComb.put(netObj.FAF_Network_Ops__c,yearstr);
               }
               
            }
            
            List<Client_Information__c> clientInfo=[Select ID,FAF_ID__c,Year_1_Begin_Date__c,Year_1_End_Date__c,Year_1__c,
                                                     Year_2__c,Year_2_Begin_Date__c,Year_2_End_Date__c,
                                                     Year_3__c,Year_3_Begin_Date__c,Year_3_End_Date__c,
                                                     Year_4__c,Year_4_Begin_Date__c,Year_4_End_Date__c,
                                                     Year_5__c,Year_5_Begin_Date__c,Year_5_End_Date__c from Client_Information__c where FAF_ID__c IN:FAFids];
                                                 
            for(Client_Information__c clt:clientInfo){
                MapYear1Begin.put(clt.FAF_ID__c,clt.Year_1_Begin_Date__c);
                MapYear2Begin.put(clt.FAF_ID__c,clt.Year_2_Begin_Date__c);
                MapYear3Begin.put(clt.FAF_ID__c,clt.Year_3_Begin_Date__c);
                MapYear4Begin.put(clt.FAF_ID__c,clt.Year_4_Begin_Date__c);
                MapYear5Begin.put(clt.FAF_ID__c,clt.Year_5_Begin_Date__c);
                MapYear1End.put(clt.FAF_ID__c,clt.Year_1_End_Date__c);
                MapYear2End.put(clt.FAF_ID__c,clt.Year_2_End_Date__c);
                MapYear3End.put(clt.FAF_ID__c,clt.Year_3_End_Date__c);
                MapYear4End.put(clt.FAF_ID__c,clt.Year_4_End_Date__c);
                MapYear5End.put(clt.FAF_ID__c,clt.Year_5_End_Date__c);
            }
            
         /*** Transalation Name Update ****/
            for(Retail_Network_Name_Translations__mdt nr:CustomMetaList){
              mapstr.put(nr.Label,nr.Translated_Network_Name__c);
            }
         /*** Transalation Name Update ****/
         /****Brand Rate update according to the gurantee type*****/
            List<Retail_Network_Guarantees__c> Grlist=[SELECT ID ,Type__c,Rate__c,Network_Pricing__c from Retail_Network_Guarantees__c where Network_Pricing__c IN :ids Order By LastModifiedDate ASC];
                for (Retail_Network_Guarantees__c guarObj :Grlist ){
                    if(guarObj .Type__c=='BER'){
                    mapGuar.put(guarObj.Network_Pricing__c,guarObj.Rate__c);
                    }
            }
        /****Brand Rate update according to the gurantee type*****/
           
         
           
            List<Network_Pricing__c >  netpriceObj = new List<Network_Pricing__c>();
          
            
             for(Network_Pricing__c  netObj :scope){
              //netObj.Show_in_Grid__c=true;
                if(MapYearComb.get(netObj.FAF_Network_Ops__c)!=null)
                {
                    if(netObj.Year__c=='1'|| netObj.Year__c=='2' ||netObj.Year__c=='3' ||netObj.Year__c=='4'|| netObj.Year__c=='5')
                    {
                        netObj.Show_in_Grid__c=false;
                    }
                    
                }
                else{
                 netObj.Show_in_Grid__c=true;
                }
                
                if(netObj.Year__c=='All'){
                netObj.Show_in_Grid__c=true;
                 //netObj.Template_Network_Name_Text__c=netObj.Template_Network_Name__c;
                }
                
                if(netObj.Network_Name__c=='Specialty'){
                netObj.Show_in_Grid__c=false;
                }
                if(netObj.Maintenance_Choice__c!=null){
                netObj.Show_in_Grid__c=false;
                }
               netObj.Batch_Update__c=true;
               if(netObj.Network_Name__c!='Custom' && netObj.Network_Name__c!='Custom Secondary'){
                netObj.Network_Name_for_Grid__c=mapstr.get(netObj.Network_Name__c);
                netObj.Template_Network_Name_Text__c=mapstr.get(netObj.Network_Name__c)+'-'+netObj.Network_Type__c;
                
                }
                else{
                 netObj.Network_Name_for_Grid__c= netObj.Custom_Network_Description__c;
                  netObj.Template_Network_Name_Text__c=netObj.Custom_Network_Description__c+'-'+netObj.Network_Type__c;
                }
                netObj.Template_BER_Guarantee_Rate_Text__c=' ';
                netObj.Template_Brand_Rate_Text__c=' ';
                
                if(netObj.Year__c=='1' && netObj.Year_Begin_Date__c==null){
                netObj.Year_Begin_Date__c=MapYear1Begin.get(netObj.FAF_ID__c);
                }
                if(netObj.Year__c=='2' && netObj.Year_Begin_Date__c==null){
                    netObj.Year_Begin_Date__c=MapYear2Begin.get(netObj.FAF_ID__c);
                }
                if(netObj.Year__c=='3' && netObj.Year_Begin_Date__c==null){
                    netObj.Year_Begin_Date__c=MapYear3Begin.get(netObj.FAF_ID__c);
                }
                if(netObj.Year__c=='4' && netObj.Year_Begin_Date__c==null){
                    netObj.Year_Begin_Date__c=MapYear4Begin.get(netObj.FAF_ID__c);
                }
                if(netObj.Year__c=='5' && netObj.Year_Begin_Date__c==null){
                    netObj.Year_Begin_Date__c=MapYear5Begin.get(netObj.FAF_ID__c);
                }
                // Year End Date 
                
                if(netObj.Year__c=='1' && netObj.Year_End_Date__c==null){
                netObj.Year_End_Date__c=MapYear1End.get(netObj.FAF_ID__c);
                }
                if(netObj.Year__c=='2' && netObj.Year_End_Date__c==null){
                    netObj.Year_End_Date__c=MapYear2End.get(netObj.FAF_ID__c);
                }
                if(netObj.Year__c=='3' && netObj.Year_End_Date__c==null){
                    netObj.Year_End_Date__c=MapYear3End.get(netObj.FAF_ID__c);
                }
                if(netObj.Year__c=='4' && netObj.Year_End_Date__c==null){
                    netObj.Year_End_Date__c=MapYear4End.get(netObj.FAF_ID__c);
                }
                if(netObj.Year__c=='5' && netObj.Year_End_Date__c==null){
                    netObj.Year_End_Date__c=MapYear5End.get(netObj.FAF_ID__c);
                }
                netObj.BER_Guarantee_Rate__c=mapGuar.get(netObj.id);
                netpriceObj.add(netObj);
            }
    
        if(!netpriceObj.isEmpty()){
            update netpriceObj;
        }
    }   
    global void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records processed');
             AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
        // call some utility to send email
       // EmailUtils.sendMessage(job, recordsProcessed);
    }    
}