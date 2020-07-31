/* =================================================================================
 * @Class Name        : Invoke_Template_Mail_Rate
 * @author            : Soumendu Chowdhury
 * @created date      : 06/28/2019
 * @Purpose           : Populate Rate fields at Mail Pricing record with Pricing Effective Date to display in Apttus Template
=======================================================================================*/
public class Invoke_Template_Mail_Rate{
/*=================================================================================
 * @Method Name       : Template_Mail_Rate
 * @author            : Soumendu Chowdhury
 * @created date      : 06/28/2019
 * @Last modified by  : Soumendu Chowdhury
 * @Purpose           : Populate Rate fields at Mail Pricing record with Pricing Effective Date to display in Apttus Template
=======================================================================================*/
@InvocableMethod
public static void Template_Mail_Rate(List<id> objId)
{ 
try
{
if(DeepCloneUtility.OFF_INVOCABLE_CLASS){
DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
Mail_Pricing__c[] ListMpricing = new List<Mail_Pricing__c>();
Mail_Pricing__c[] ShowinGrid = new List<Mail_Pricing__c>();
Boolean BrandExist = false;
Boolean PrefExist = false;
Boolean BERExist = false;
Boolean GenericExist = false;
Boolean GERGenericExist = false;
Boolean MERGenericExist = false;
Boolean NEDGenericExist = false;
Boolean SSGGenericExist = false;
Boolean NonMacGenericExist = false;
Boolean DispensingExist = false;
Boolean BGDispensing = false;
Set<id> FAFids=new set<id>();
Set<String> mailLob=new set<String>();
Map<String,String> MapGridDisplay = new Map<String,String>();
Boolean ShowGrid = false;
PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
        List<string> FAFStat = new List<string>();
        for(string s: FAFStatus.Value__c.split(','))
              {
                 FAFStat.add(s);
              }        
List<Mail_Pricing__c> Mprice =[SELECT Id,Show_in_Grid__c,FAF_ID__c,FAF_ID__r.LOB2__c,IUMS_Upload__c,
                                         Year_Begin_Date__c,Custom_Description__c,Year_End_Date__c,Generic_Rate__c,
                                         Brand_Rate__c,BER_Guarantee_Rate__c,Year__c,FAF_Mail_Operations__c,
                                         Template_Brand_Rate__c,Template_BER_Guarantee_Rate__c,
                                         Template_BER_Guarantee_Rate_Text__c,Generic_Basis__c,Template_Generic_Rate__c,Template_Generic_Rate_Text__c,
                                         Template_MER_Guarantee_Rate__c,Template_MER_Guarantee_Rate_Text__c,
                                         Template_NED_Guarantee_Rate__c,Template_NED_Guarantee_Rate_Text__c,
                                         Template_GER_Guarantee_Rate__c,Template_GER_Guarantee_Rate_Text__c,
                                         Template_SSG_Guarantee_Rate__c,Template_Brand_Rate_Text__c,Template_SSG_Guarantee_Rate_Text__c,
                                         Template_Non_MAC_Generic_Rate__c,Template_Non_MAC_Generic_Rate_Text__c,
                                         Template_Brand_Dispensing_Fee__c,Template_Generic_Dispensing_Fee__c,Template_Dispensing_Fee_Text__c,
                                         GER_Guarantee_Rate__c,MER_Guarantee_Rate__c,NED_Guarantee_Rate__c,SSG_Guarantee_Rate__c,Name,
                                         GER_Count__c,MER_Count__c, NED_Count__c,SSG_Guarantee__c,Generic_Dispensing_Fee__c,Brand_Dispensing_Fee__c,
                                         Brand_Basis__c,Template_Preferred_Brand_Rate__c,Template_Non_Preferred_Brand_Rate__c,Template_Preferred_Brand_Rate_Text__c,
                                         Template_Non_Preferred_Brand_Rate_Text__c,LOB__c,Template_Brand_Display__c,Template_BER_Display__c,Template_NonMacGeneric_Display__c,
                                         Template_GER_Display__c,Template_MER_Display__c,Template_NED_Display__c,Template_Preferred_Display__c
                                         FROM Mail_Pricing__c WHERE FAF_ID__r.FAF_Status__c IN:FAFStat  AND Show_in_Grid__c = true
                                         AND FAF_Mail_Operations__c IN:objId];

                                         
Map<String,AggregateResult> MinNameAgreegate = new Map<String,AggregateResult>([SELECT LOB__c Id, min(Name) MinName
                                        FROM Mail_Pricing__c 
                                        WHERE FAF_ID__r.FAF_Status__c IN:FAFStat  
                                        AND   Show_in_Grid__c = true AND FAF_Mail_Operations__c IN:objId
                                        GROUP BY LOB__c]);
                                        
Map<Id,AggregateResult> MCList = new Map<Id,AggregateResult>([SELECT FAF_ID__c Id, count(Id) MC FROM Network_Pricing__c WHERE (Network_Name__c =:Label.MCCP OR Network_Name__c =: Label.MCCVS)
AND FAF_ID__c != null AND Network_Type__c='Transparent' GROUP BY FAF_ID__c]);
       
List<Mail_Pricing__c> AgreegateRate = new List<Mail_Pricing__c>([SELECT Id,BER_Guarantee_Rate__c,Template_BER_Guarantee_Rate__c,Template_Brand_Rate__c,Brand_Rate__c,FAF_ID__r.LOB2__c,
                                        Generic_Basis__c,Template_Generic_Rate__c,Generic_Rate__c,MER_Guarantee_Rate__c,Template_MER_Guarantee_Rate__c,
                                        NED_Guarantee_Rate__c,Template_NED_Guarantee_Rate__c,GER_Guarantee_Rate__c,Template_GER_Guarantee_Rate__c,SSG_Guarantee_Rate__c,Template_SSG_Guarantee_Rate__c,
                                        Non_MAC_Generic_Rate__c,Template_Non_MAC_Generic_Rate__c,GER_Count__c,MER_Count__c,NED_Count__c,SSG_Guarantee__c,Generic_Dispensing_Fee__c,Brand_Dispensing_Fee__c,
                                        Template_Brand_Dispensing_Fee__c,Template_Generic_Dispensing_Fee__c,Template_Preferred_Brand_Rate__c,Template_Non_Preferred_Brand_Rate__c,Brand_Basis__c,LOB__c
                                        FROM Mail_Pricing__c 
                                        WHERE  Show_in_Grid__c = true AND FAF_Mail_Operations__c IN:objId
                                        ORDER BY Year__c]);
                                        
        
        for(Mail_Pricing__c  mailObj : Mprice){
        if(mailObj.IUMS_Upload__c==true){
            mailLob.add(mailObj.LOB__c);
         }
         FAFids.add(mailObj.FAF_ID__c);
        }  
        if(!mailLob.isEmpty()){         
            List<Grid_Display_Name_Setting__c> gridDisplayList=[Select ID,Mail_Grid_Display_Name__c,Mail_LOB__c,Object_Name__c,FAF__c FROM Grid_Display_Name_Setting__c where FAF__c IN:FAFids and Object_Name__c='Mail Pricing' and Mail_LOB__c IN:mailLob];
            for(Grid_Display_Name_Setting__c gdr:gridDisplayList){
                MapGridDisplay.put(gdr.Mail_LOB__c,gdr.Mail_Grid_Display_Name__c);
            }
        }
 
 for(Mail_Pricing__c  mailObj : Mprice){
               Boolean SSGexist = false;
               String AggrRate= '';
               String AggrPrefRate= '';
               String AggrNonPrefRate= '';
               String AggrBERRate= '';
               String GenericRate= '';
               String GERGenericRate= '';
               String MERGenericRate= '';
               String NEDGenericRate= '';
               String SSGGenericRate= '';
               String NonMacGenericRate= '';
               String DispensingFee= '';
               String BGDispensingFee= '';
               String BrandDispensingFee= '';
               String GenericDispensingFee= '';
               BrandExist = false;
               PrefExist = false;
               BERExist = false;
               GenericExist = false;
               GERGenericExist = false;
               MERGenericExist = false;
               NEDGenericExist = false;
               SSGGenericExist = false;
               NonMacGenericExist = false;
               DispensingExist = false;
               BGDispensing = false;
               ShowGrid = false;
           /* if (mailObj.FAF_ID__r.LOB2__c=='EGWP')
               {
                 NonMacGenericRate = 'MAC' + '\n' + 'Non – MAC:' + '\n';
               } */
               if(MinNameAgreegate != null && MinNameAgreegate.get(mailObj.LOB__c) != null)
                {
                  AggregateResult  vName = MinNameAgreegate.get(mailObj.LOB__c);
                  if ((vName.get('MinName') == mailObj.Name) && (vName.get('Id')==mailObj.LOB__c))
                  {
                     for (Mail_Pricing__c BrandRate : AgreegateRate){
                    
                    if(MCList != null && MCList.get(mailObj.FAF_ID__c) != null)
                    {
                      AggregateResult MC = MCList.get(mailObj.FAF_ID__c);
                      Integer MCCount = Integer.valueof(MC.get('MC'));
                      //Changes DOne By MOhit Srivastava : Custom Description
                            if (MCCount >= 1){
                                mailObj.Grid_Name__c = Label.Mail_Grid_Name;
                                if(mailObj.IUMS_Upload__c==true){
                                    if(mailObj.Custom_Description__c==''||mailObj.Custom_Description__c==null){
                                            if(!MapGridDisplay.isEmpty()){
                                                 mailObj.Custom_Description__c=MapGridDisplay.get(mailObj.LOB__c); 
                                            }
                                            else{
                                                if(mailObj.Custom_Description__c==''||mailObj.Custom_Description__c==null){
                                                  mailObj.Custom_Description__c=Label.Mail_Grid_Name;
                                                }
                                                if(mailObj.Custom_Description__c=='MAIL'){
                                                  mailObj.Custom_Description__c=Label.Mail_Grid_Name;
                                                }
                                            }
                                    }
                                }
                                else{
                                    if(mailObj.Custom_Description__c==''||mailObj.Custom_Description__c==null){
                                      mailObj.Custom_Description__c=Label.Mail_Grid_Name;
                                    }
                                    if(mailObj.Custom_Description__c=='MAIL'){
                                      mailObj.Custom_Description__c=Label.Mail_Grid_Name;
                                    }
                                }
                            }
                    }
                    else
                    {
                         mailObj.Grid_Name__c = 'MAIL'; 
                         
                        if(mailObj.IUMS_Upload__c==true){
                            if(mailObj.Custom_Description__c==''||mailObj.Custom_Description__c==null){
                                if(!MapGridDisplay.isEmpty()){
                                     mailObj.Custom_Description__c=MapGridDisplay.get(mailObj.LOB__c); 
                                }
                                else{
                                    if(mailObj.Custom_Description__c==''||mailObj.Custom_Description__c==null){
                                       mailObj.Custom_Description__c='MAIL';
                                    }
                                    if(mailObj.Custom_Description__c==Label.Mail_Grid_Name){
                                       mailObj.Custom_Description__c='MAIL';
                                    }
                            
                                }
                            }
                        }
                        else{
                                if(mailObj.Custom_Description__c==''||mailObj.Custom_Description__c==null){
                                   mailObj.Custom_Description__c='MAIL';
                                }
                                if(mailObj.Custom_Description__c==Label.Mail_Grid_Name){
                                   mailObj.Custom_Description__c='MAIL';
                                }
                        }
                    }
                    
                      if(AgreegateRate!= null && !AgreegateRate.isEmpty() && BrandRate.LOB__c == mailObj.LOB__c)
                          {
                            AggrBERRate += BrandRate.Template_BER_Guarantee_Rate__c +  '\n';
                            if ((mailObj.BER_Guarantee_Rate__c != null || BrandRate.BER_Guarantee_Rate__c != null) && mailObj.FAF_ID__r.LOB2__c !='EGWP')
                             { BERExist = true;}
                             
                            if(BrandRate.Brand_Basis__c == Label.Baked_Preferred_Rate)
                            {
                             AggrPrefRate += BrandRate.Template_Preferred_Brand_Rate__c +  '\n';
                             AggrNonPrefRate += BrandRate.Template_Non_Preferred_Brand_Rate__c +  '\n';
                             PrefExist = true;
                            }
                          }
                      if(AgreegateRate != null && !AgreegateRate.isEmpty() && BrandRate.LOB__c == mailObj.LOB__c)
                          {
                            if(BrandRate.Brand_Basis__c != Label.Baked_Preferred_Rate)
                            {
                            AggrRate+= BrandRate.Template_Brand_Rate__c +  '\n' ;
                            }
                            if (mailObj.Brand_Rate__c != null || BrandRate.Brand_Rate__c != null || BrandRate.Brand_Basis__c != Label.Baked_Preferred_Rate)
                              {BrandExist = true;}
                          }
                          
                      if( AgreegateRate != null && !AgreegateRate.isEmpty()  && (BrandRate.Generic_Basis__c == Label.Flat_Generic_Discount) && BrandRate.LOB__c == mailObj.LOB__c)
                          {
                            GenericRate+= BrandRate.Template_Generic_Rate__c +  '\n' ;
                           // if (mailObj.Generic_Rate__c != null || BrandRate.Generic_Rate__c != null)
                              GenericExist = true;
                          }
                      if( AgreegateRate != null && !AgreegateRate.isEmpty() && (BrandRate.Generic_Basis__c != Label.Flat_Generic_Discount) && BrandRate.LOB__c == mailObj.LOB__c)
                          {
                            GERGenericRate+= BrandRate.Template_GER_Guarantee_Rate__c +  '\n' ;
                            if (mailObj.GER_Guarantee_Rate__c != null || BrandRate.GER_Guarantee_Rate__c != null || BrandRate.GER_Count__c > 0)
                              {GERGenericExist = true;}
                          }
                      if( AgreegateRate != null && !AgreegateRate.isEmpty()  && (BrandRate.Generic_Basis__c != Label.Flat_Generic_Discount) && BrandRate.LOB__c == mailObj.LOB__c)
                          {
                            MERGenericRate+= BrandRate.Template_MER_Guarantee_Rate__c +  '\n' ;
                            if (mailObj.MER_Guarantee_Rate__c != null || BrandRate.MER_Guarantee_Rate__c != null || BrandRate.MER_Count__c > 0)
                              {MERGenericExist = true;}
                          }
                      if( AgreegateRate != null && !AgreegateRate.isEmpty()  && (BrandRate.Generic_Basis__c != Label.Flat_Generic_Discount) && BrandRate.LOB__c == mailObj.LOB__c)
                          {
                            NEDGenericRate+= BrandRate.Template_NED_Guarantee_Rate__c +  '\n' ;
                            if (mailObj.NED_Guarantee_Rate__c != null || BrandRate.NED_Guarantee_Rate__c != null || BrandRate.NED_Count__c > 0)
                              {NEDGenericExist = true;}
                          }  
                       if( AgreegateRate != null && !AgreegateRate.isEmpty()  && (BrandRate.Generic_Basis__c != Label.Flat_Generic_Discount)  && BrandRate.LOB__c == mailObj.LOB__c)
                          {
                            NonMacGenericRate+= BrandRate.Template_Non_MAC_Generic_Rate__c +  '\n' ;
                           // if (mailObj.Generic_Rate__c != null || BrandRate.Generic_Rate__c != null)
                              NonMacGenericExist = true;
                          }               
                      if( AgreegateRate != null && !AgreegateRate.isEmpty() && BrandRate.LOB__c == mailObj.LOB__c)
                          {
                            SSGGenericRate+= BrandRate.Template_SSG_Guarantee_Rate__c +  '\n' ;
                            //if (mailObj.SSG_Guarantee_Rate__c != null || BrandRate.SSG_Guarantee_Rate__c != null || BrandRate.SSG_Guarantee__c > 0)
                              SSGGenericExist = true;
                               if (BrandRate.SSG_Guarantee__c >= 1)
                              {
                               SSGexist = true;
                              }
                          } 
                      if( AgreegateRate != null && !AgreegateRate.isEmpty() && BrandRate.LOB__c == mailObj.LOB__c)
                          {
                            if (BrandRate.Generic_Dispensing_Fee__c == BrandRate.Brand_Dispensing_Fee__c)
                            {
                            BGDispensingFee+= BrandRate.Template_Brand_Dispensing_Fee__c +  '\n' ;                          
                            }
                            else
                            {
                            BGDispensing = true;
                            }
                            BrandDispensingFee+= BrandRate.Template_Brand_Dispensing_Fee__c +  '\n' ;
                            GenericDispensingFee+= BrandRate.Template_Generic_Dispensing_Fee__c +  '\n' ;
                            DispensingExist = true;
                          }           
                                                 
                  }
                  ShowGrid = true;
                  mailObj.Template_Generic_Display__c = false;
                  mailObj.Template_Non_MAC_Generic_Display__c = true; 
                  if (mailObj.Generic_Basis__c == Label.Flat_Generic_Discount)
                   {
                     mailObj.Template_Generic_Display__c = true;
                     mailObj.Template_Non_MAC_Generic_Display__c = false;  
                   }
                  if(PrefExist == true)
                   { 
                     mailObj.Template_Preferred_Brand_Rate_Text__c = AggrPrefRate;     
                     mailObj.Template_Non_Preferred_Brand_Rate_Text__c  = AggrNonPrefRate; 
                     mailObj.Template_Preferred_Display__c=true;                                          
                   }
                  else
                  {
                     mailObj.Template_Preferred_Brand_Rate_Text__c = ' ';     
                     mailObj.Template_Non_Preferred_Brand_Rate_Text__c  = ' ';
                     mailObj.Template_Preferred_Display__c=false;
                  }
                  if(BERExist == true)
                   { 
                     mailObj.Template_BER_Guarantee_Rate_Text__c = AggrBERRate;   
                     mailObj.Template_BER_Display__c = true;                                             
                   }
                  else
                  {
                      mailObj.Template_BER_Guarantee_Rate_Text__c = ' ';
                      mailObj.Template_BER_Display__c = false; 
                  }
                  if(BrandExist == true && BERExist == false )
                   { 
                       mailObj.Template_Brand_Rate_Text__c = AggrRate;  
                       mailObj.Template_Brand_Display__c = true;                                               
                   }
                   else
                  {
                      mailObj.Template_Brand_Rate_Text__c = ' ';
                      mailObj.Template_Brand_Display__c = false;
                  }  
                  if (GenericExist == true || GERGenericExist == true || MERGenericExist == true || NEDGenericExist == true)
                  {
                      mailObj.Template_Generic_Display__c = true; 
                  }
                  else
                  {
                      mailObj.Template_Generic_Display__c = false; 
                  }
                  if(GenericExist == true)
                   { 
                       mailObj.Template_Generic_Rate_Text__c = GenericRate;                                                    
                   }
                   else
                  {
                      mailObj.Template_Generic_Rate_Text__c = ' ';
                  }  
                  if(GERGenericExist == true)
                   { 
                       mailObj.Template_GER_Guarantee_Rate_Text__c = GERGenericRate;
                       mailObj.Template_GER_Display__c = true;                                                                    
                   }
                   else
                  {
                      mailObj.Template_GER_Guarantee_Rate_Text__c = ' ';
                      mailObj.Template_GER_Display__c = false; 
                  }  
                  if(MERGenericExist == true)
                   { 
                       mailObj.Template_MER_Guarantee_Rate_Text__c = MERGenericRate;
                       mailObj.Template_MER_Display__c = true;                                                   
                   }
                   else
                  {
                      mailObj.Template_MER_Guarantee_Rate_Text__c = ' ';
                      mailObj.Template_MER_Display__c = false;
                  }  
                  if(NEDGenericExist == true)
                   { 
                       mailObj.Template_NED_Guarantee_Rate_Text__c = NEDGenericRate;
                       mailObj.Template_NED_Display__c = true;                                                    
                   }
                   else
                  {
                      mailObj.Template_NED_Guarantee_Rate_Text__c = ' ';
                      mailObj.Template_NED_Display__c = false;
                  }  
                   if(NonMacGenericExist == true) 
                   { 
                       mailObj.Template_Non_MAC_Generic_Rate_Text__c = NonMacGenericRate;  
                       mailObj.Template_NonMacGeneric_Display__c = true;                                                   
                   }
                   else
                  {
                      mailObj.Template_Non_MAC_Generic_Rate_Text__c = ' ';
                      mailObj.Template_NonMacGeneric_Display__c = false;  
                  }  
                  if(SSGGenericExist == true && SSGexist == true)
                   { 
                       mailObj.Template_SSG_Guarantee_Rate_Text__c = SSGGenericRate;  
                       mailObj.SSG_Display__c = true;                                                    
                   }
                   else
                  {
                      mailObj.Template_SSG_Guarantee_Rate_Text__c = ' ';
                      mailObj.SSG_Display__c = false;  
                  }  
                  
                  if(DispensingExist == true)  
                   { 
                      if (BGDispensing == true)
                      {
                      DispensingFee = 'Brand' + '\n' + BrandDispensingFee + '\n' + 'Generic' + '\n' + GenericDispensingFee + '\n';
                      }
                      else
                      {
                      DispensingFee = 'Brand & Generic' + '\n' + BGDispensingFee;
                      }
                       mailObj.Template_Dispensing_Fee_Text__c = DispensingFee;                                                   
                   }
                   else
                      {
                       mailObj.Template_Dispensing_Fee_Text__c = ' ';
                      }  
                  
                   }   
                }         
                if(ShowGrid != true)
                   { 
                       mailObj.Show_in_Grid__c = false;
                       ShowinGrid.add(mailObj); 
                   }               
                if(BrandExist == false && mailObj.Template_BER_Guarantee_Rate_Text__c== null && mailObj.FAF_ID__r.LOB2__c !='EGWP')
                {mailObj.Template_Brand_Rate_Text__c= mailObj.Template_Brand_Rate__c;}
                          ListMpricing.add(mailObj);                           
                          }

if (ListMpricing != null && !ListMpricing.isEmpty())
{
   Update ListMpricing;
}

if (ShowinGrid != null && !ShowinGrid.isEmpty())
{
   Update ShowinGrid;
}
 }
//DeepCloneUtility.OFF_INVOCABLE_CLASS = false;
}
catch(DmlException e)
    {
     System.debug(e.getMessage());
    } 
}
}