/* =================================================================================
 * @Class Name        : Invoke_UpdateMailPricing
 * @author            : Mohit Srivastava(Accenture)
 * @created date      : 05/24/2019
 * @Purpose           : PopulatePricingEffective
=======================================================================================*/
global class Invoke_UpdateMailPricing{



/*=================================================================================
 * @Method Name       : UpdateMailPricing
 * @author            : Mohit Srivastava(Accenture)
 * @created date      : 05/24/2019
 * @Last modified by  : Mohit Srivastava(Accenture)
 * @Purpose           : Populate Effective Date
=======================================================================================*/
@InvocableMethod
global static void UpdateMailPricing(List<id> objId)
{
  if(DeepCloneUtility.OFF_INVOCABLE_CLASS){
        DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
        Set<id> ids=new set<id>();
        Set<id> FAFids=new set<id>();
        map<Id,Decimal> mapGuar=new map<Id,Decimal>();
        map<Id,Decimal> mapMER=new map<Id,Decimal>();
        map<Id,Decimal> mapNED=new map<Id,Decimal>();
        map<Id,Decimal> mapGER=new map<Id,Decimal>(); // updated on 06/06
        map<Id,Decimal> mapSSG=new map<Id,Decimal>(); // updated on 06/23
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
        Map<id,date> MapContractDt = new Map<id,date>();
        Map<id,date> MapContractEndDt = new Map<id,date>();
        Map<id,Mail_Pricing__c> MapYearComb = new Map<id,Mail_Pricing__c>();
         Set<String> yearstr=new Set<String>();
        

        PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
        List<string> FAFStat = new List<string>();
        for(string s: FAFStatus.Value__c.split(','))
              {
                 FAFStat.add(s);
              }                                                                                             
        List<Mail_Pricing__c> Scope =[SELECT ID,FAF_Mail_Operations__c,Template_BER_Guarantee_Rate__c,Show_in_Grid__c,FAF_ID__c ,LOB__c,
                                        Year_Begin_Date__c,Generic_Basis__c,Year_End_Date__c,MER_Guarantee_Rate__c,NED_Guarantee_Rate__c,GER_Guarantee_Rate__c,
                                        Invokable_Update__c,BER_Guarantee_Rate__c,SSG_Guarantee_Rate__c,Year__c 
                                        FROM Mail_Pricing__c where FAF_ID__r.FAF_Status__c IN:FAFStat and FAF_Mail_Operations__c IN:objId];
        
            for(Mail_Pricing__c  mailObj : scope){
               ids.add(mailObj.id);
               FAFids.add(mailObj.FAF_ID__c);
               yearstr.add(mailObj.Year__c);
               if(mailObj.Year__c=='All'){
               MapYearComb.put(mailObj.Id,mailObj);
               }
            }
         List<Client_Information__c> clientInfo=[Select ID,FAF_ID__c,Year_1_Begin_Date__c,Year_1_End_Date__c,Year_1__c,
                                                     Year_2__c,Year_2_Begin_Date__c,Year_2_End_Date__c,
                                                     Year_3__c,Year_3_Begin_Date__c,Year_3_End_Date__c,
                                                     Year_4__c,Year_4_Begin_Date__c,Year_4_End_Date__c,
                                                     Year_5__c,Year_5_Begin_Date__c,Year_5_End_Date__c,
                                                     Contract_Effective_Date__c,Contract_End_Date__c
                                                     from Client_Information__c where FAF_ID__c IN:FAFids];
                                                 
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
                MapContractDt.put(clt.FAF_ID__c,clt.Contract_Effective_Date__c);
                MapContractEndDt.put(clt.FAF_ID__c,clt.Contract_End_Date__c);
            }       
        
         /****Brand Rate update according to the gurantee type*****/
            List<Mail_Guarantees__c> Grlist=[SELECT ID ,Type__c,Rate__c,Mail_Pricing__c from Mail_Guarantees__c where Mail_Pricing__c IN :ids Order By LastModifiedDate ASC];
                for (Mail_Guarantees__c guarObj :Grlist ){
                    if(guarObj.Type__c=='BER'){
                    mapGuar.put(guarObj.Mail_Pricing__c,guarObj.Rate__c);
                    }
                    if(guarObj.Type__c=='MER'){
                    mapMER.put(guarObj.Mail_Pricing__c,guarObj.Rate__c);
                    }
                    if(guarObj.Type__c=='NED'){
                    mapNED.put(guarObj.Mail_Pricing__c,guarObj.Rate__c);
                    }
                    if(guarObj.Type__c=='GER'){
                    mapGER.put(guarObj.Mail_Pricing__c,guarObj.Rate__c);
                    }
                    if(guarObj.Type__c=='SSG'){
                    mapSSG.put(guarObj.Mail_Pricing__c,guarObj.Rate__c);
                    }
                    
                }
        /****Brand Rate update according to the gurantee type*****/
                  
            List<Mail_Pricing__c >  mailpriceObj = new List<Mail_Pricing__c>();
          
            for(Mail_Pricing__c  mailObj : scope){
                 mailObj.Show_in_Grid__c=true;
                 for(Mail_Pricing__c mp: MapYearComb.values())
                   {
                    if((mailObj.Year__c=='1'|| mailObj.Year__c=='2' ||mailObj.Year__c=='3' ||mailObj.Year__c=='4'|| mailObj.Year__c=='5') && mp.Year__c=='All' && (mp.LOB__c==mailObj.LOB__c))
                    {
                        mailObj.Show_in_Grid__c=false;
                    }
                   }
                 
                
                
                if(mailObj.Year__c=='All'){
                mailObj.Show_in_Grid__c=true;
                }
                 mailObj.Template_Preferred_Brand_Rate_Text__c= ' ';
                 mailObj.Template_Non_Preferred_Brand_Rate_Text__c=' ';
                 mailObj.Template_BER_Guarantee_Rate_Text__c=' ';
                 mailObj.Template_Brand_Rate_Text__c=' ';
                 mailObj.Template_Generic_Rate_Text__c=' ';
                 mailObj.Template_GER_Guarantee_Rate_Text__c=' ';
                 mailObj.Template_MER_Guarantee_Rate_Text__c=' ';
                 mailObj.Template_NED_Guarantee_Rate_Text__c=' ';
                 mailObj.Template_Non_MAC_Generic_Rate_Text__c=' ';
                 mailObj.Template_SSG_Guarantee_Rate_Text__c=' ';
                 mailObj.Template_Dispensing_Fee_Text__c= ' ';
                
                if(mailObj.Year__c=='1'){
                mailObj.Year_Begin_Date__c=MapYear1Begin.get(mailObj.FAF_ID__c);
                }
                if(mailObj.Year__c=='2'){
                    mailObj.Year_Begin_Date__c=MapYear2Begin.get(mailObj.FAF_ID__c);
                }
                if(mailObj.Year__c=='3'){
                    mailObj.Year_Begin_Date__c=MapYear3Begin.get(mailObj.FAF_ID__c);
                }
                if(mailObj.Year__c=='4' ){
                    mailObj.Year_Begin_Date__c=MapYear4Begin.get(mailObj.FAF_ID__c);
                }
                if(mailObj.Year__c=='5'){
                    mailObj.Year_Begin_Date__c=MapYear5Begin.get(mailObj.FAF_ID__c);
                }
                // Year End Date 
                
                if(mailObj.Year__c=='1' ){
                mailObj.Year_End_Date__c=MapYear1End.get(mailObj.FAF_ID__c);
                }
                if(mailObj.Year__c=='2' ){
                    mailObj.Year_End_Date__c=MapYear2End.get(mailObj.FAF_ID__c);
                }
                if(mailObj.Year__c=='3' ){
                    mailObj.Year_End_Date__c=MapYear3End.get(mailObj.FAF_ID__c);
                }
                if(mailObj.Year__c=='4' ){
                    mailObj.Year_End_Date__c=MapYear4End.get(mailObj.FAF_ID__c);
                }
                if(mailObj.Year__c=='5' ){
                    mailObj.Year_End_Date__c=MapYear5End.get(mailObj.FAF_ID__c);
                }
                //For Year All
                
                if(mailObj.Year__c=='All'){
                    mailObj.Year_End_Date__c=MapContractEndDt.get(mailObj.FAF_ID__c);
                }
                if(mailObj.Year__c=='All'){
                    mailObj.Year_Begin_Date__c=MapContractDt.get(mailObj.FAF_ID__c);
                }
                // For BER Guarantee Rate
                
                mailObj.BER_Guarantee_Rate__c=mapGuar.get(mailObj.id);
                
               // For Updating Flag on Network Pricing
                
                if(mailObj.Invokable_Update__c==false){
                mailObj.Invokable_Update__c=true;}
                else{
                 mailObj.Invokable_Update__c=false;
                }
              
                
                String cLabel = System.Label.Flat_Generic_Discount;
                List<String> choosingGenericRate = new List<String>();
                choosingGenericRate=cLabel.split(',');
                mailObj.MER_Guarantee_Rate__c=null;
                mailObj.NED_Guarantee_Rate__c=null;
                mailObj.GER_Guarantee_Rate__c=null;
                mailObj.SSG_Guarantee_Rate__c=null;
                if(!choosingGenericRate.contains(mailObj.Generic_Basis__c)){
                mailObj.MER_Guarantee_Rate__c=mapMER.get(mailObj.id);
                mailObj.NED_Guarantee_Rate__c=mapNED.get(mailObj.id); 
                mailObj.GER_Guarantee_Rate__c=mapGER.get(mailObj.id);
                }
                mailObj.SSG_Guarantee_Rate__c=mapSSG.get(mailObj.id);  
                mailpriceObj.add(mailObj);
                
            }
    try{
        if(!mailpriceObj.isEmpty()){
            update mailpriceObj;
        }
    }
    
    catch(Exception Ex){
    
    system.debug('Exception....'+ex.getMessage());
    }
  Invoke_Template_Mail_Rate.Template_Mail_Rate(objId);
 }
}
}