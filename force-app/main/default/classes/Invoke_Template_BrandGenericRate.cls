/* =================================================================================
 * @Class Name        : Invoke_Template_BrandGenericRate
 * @author            : Soumendu Chowdhury
 * @created date      : 05/24/2019
 * @Purpose           : Populate Brand & Generic Rate with Pricing Effective Date to display in Apttus Template
=======================================================================================*/
public class Invoke_Template_BrandGenericRate{
/*=================================================================================
 * @Method Name       : Template_BrandGenericRate
 * @author            : Soumendu Chowdhury
 * @created date      : 05/24/2019
 * @Last modified by  : Soumendu Chowdhury
 * @Purpose           : Populate Brand Rate with Pricing Effective Date to display in Apttus Template
=======================================================================================*/
@InvocableMethod
public static void Template_BrandGenericRate(List<id> objId)
{ 
try
{
DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
Network_Pricing__c[] ListNpricing = new List<Network_Pricing__c>();
Network_Pricing__c[] ShowinGrid = new List<Network_Pricing__c>();
Boolean BrandExist = false;
Boolean GenericExist = false;
Boolean OEDExist = false;
Boolean GERGenericExist = false;
Boolean PrefExist = false;
Boolean MERGenericExist = false;
Boolean NEDGenericExist = false;
Boolean SSGGenericExist = false;
Boolean NonMacGenericExist = false;
Boolean DispensingExist = false;
Boolean BGDispensing = false;
Boolean BERExist = false;
Boolean ShowGrid = false;

if(DeepCloneUtility.OFF_INVOCABLE_CLASS){
PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
List<string> FAFStat = new List<string>();
for(string s: FAFStatus.Value__c.split(','))
   {
     FAFStat.add(s);
   }        
List<Network_Pricing__c> Nprice =[SELECT Id,Show_in_Grid__c,Maintenance_Choice__c,FAF_ID__c,Brand_Basis__c,Template_Preferred_Brand_Rate__c,Template_Non_Preferred_Brand_Rate__c,
                                         Year_Begin_Date__c,Year_End_Date__c,Custom_Network_Description__c,Generic_Rate__c,FAF_ID__r.LOB2__c,
                                         Network_Name__c,Network_Name_for_Grid__c,Template_Brand_Display__c,Template_BER_Display__c,Network_Type__c, Brand_Rate__c,BER_Guarantee_Rate__c,Year__c,FAF_Network_Ops__c,
                                         Template_Network_Name__c,Template_Preferred_Display__c, Template_Brand_Rate__c,Template_BER_Guarantee_Rate__c,
                                         Template_Network_Name_Text__c,Template_BER_Guarantee_Rate_Text__c,Template_Generic_OR_Mac__c,Template_Generic_OR_Mac_Text__c,
                                         Generic_Basis__c,Template_Generic_Rate__c,Template_Generic_Rate_Text__c,Retail_Network_Ordinal__c,
                                         Template_MER_Guarantee_Rate__c,Template_MER_Guarantee_Rate_Text__c,
                                         Template_NED_Guarantee_Rate__c,Template_NED_Guarantee_Rate_Text__c,
                                         Template_GER_Guarantee_Rate__c,Specialty_Show_in_Grid__c,Template_GER_Guarantee_Rate_Text__c,
                                         Template_SSG_Guarantee_Rate__c,Template_SSG_Guarantee_Rate_Text__c,
                                         Template_Non_MAC_Generic_Rate__c,Template_Non_MAC_Generic_Rate_Text__c,OED_Guarantee_Rate__c,Template_OED_Guarantee_Rate_Text__c,
                                         Template_Brand_Dispensing_Fee__c,Template_Generic_Dispensing_Fee__c,Template_Dispensing_Fee_Text__c,
                                         GER_Guarantee_Rate__c,MER_Guarantee_Rate__c,NED_Guarantee_Rate__c,SSG_Guarantee_Rate__c,Name,
                                         GER_Count__c,MER_Count__c, NED_Count__c,SSG_Guarantee__c,Min_Name__c,Generic_Dispensing_Fee__c,Brand_Dispensing_Fee__c,
                                         Template_Generic_Display__c,Template_GER_Display__c,Template_MER_Display__c,Template_NED_Display__c,Template_NonMacGeneric_Display__c,Template_OED_Display__c
                                         FROM Network_Pricing__c WHERE FAF_ID__r.FAF_Status__c IN:FAFStat AND  Year__c != 'All' 
                                         AND FAF_Network_Ops__c IN:objId ORDER BY Year__c ASC];

                                         
Map<String,AggregateResult> MinYearAgreegate = new Map<String,AggregateResult>([SELECT Template_Network_Name_Text__c Id, min(Year__c) MinYear ,min(Min_Name__c) Name
                                        FROM Network_Pricing__c 
                                        WHERE FAF_ID__r.FAF_Status__c IN:FAFStat  AND 
                                        Template_Network_Name_Text__c <> NULL AND  Year__c != 'All'  AND FAF_Network_Ops__c IN:objId 
                                        GROUP BY  Template_Network_Name_Text__c]);
       
List<Network_Pricing__c> AgreegateRate = new List<Network_Pricing__c>([SELECT Template_BER_Guarantee_Rate__c,Template_Network_Name_Text__c,Template_Brand_Rate__c,Brand_Rate__c,Template_Preferred_Brand_Rate__c,Template_Non_Preferred_Brand_Rate__c,
                                        Generic_Basis__c,Template_OED_Guarantee_Rate__c,Template_Generic_Rate__c,OED_Count__c,Generic_Rate__c,MER_Guarantee_Rate__c,Template_MER_Guarantee_Rate__c,FAF_ID__c,FAF_ID__r.LOB2__c,Preferred_Brand_Rate__c,
                                        NED_Guarantee_Rate__c,OED_Guarantee_Rate__c,Template_NED_Guarantee_Rate__c,BER_Guarantee_Rate__c,GER_Guarantee_Rate__c,Template_GER_Guarantee_Rate__c,SSG_Guarantee_Rate__c,Template_SSG_Guarantee_Rate__c,
                                        Non_MAC_Generic_Rate__c,Template_Non_MAC_Generic_Rate__c,GER_Count__c,MER_Count__c,NED_Count__c,SSG_Guarantee__c,Generic_Dispensing_Fee__c,Brand_Dispensing_Fee__c,Retail_Network_Ordinal__c,Non_Preferred_Brand_Rate__c,
                                        Template_Brand_Dispensing_Fee__c,Template_Generic_Dispensing_Fee__c,Brand_Basis__c,Template_Generic_OR_Mac__c,Template_Generic_OR_Mac_Text__c,Print_FAF_Brand_Rate__c,Print_FAF_Generic_Rate__c,Print_FAF_OED_Guarantee_Rate__c,
                                        Print_FAF_GER_Guarantee_Rate__c,Print_FAF_MER_Guarantee_Rate__c,Print_FAF_NED_Guarantee_Rate__c,Print_FAF_Non_MAC_Generic_Rate__c,Print_FAF_SSG_Guarantee_Rate__c,Print_FAF_Brand_Dispensing_Fee__c,
                                        Print_FAF_Generic_Dispensing_Fee__c,Print_FAF_Preferred_Brand_Rate__c,Print_FAF_Non_Preferred_Brand_Rate__c
                                        FROM Network_Pricing__c 
                                        WHERE Year__c != 'All'  AND FAF_Network_Ops__c IN:objId ORDER BY Year__c ASC]);
 
 for(Network_Pricing__c  netObj : Nprice){
               Boolean SSGexist = false;
               String AggrRate= '';
               String GenericRate= '';
               String GERGenericRate= '';
               String OEDRate= '';
               String MERGenericRate= '';
               String NEDGenericRate= '';
               String SSGGenericRate= '';
               String NonMacGenericRate= '';
               String NonMacGenericORRate= '';
               String DispensingFee= '';
               String BGDispensingFee= '';
               String AggrBERRate= '';
               String BrandDispensingFee= '';
               String AggrPrefRate= '';
               String AggrNonPrefRate= '';
               String GenericDispensingFee= '';
               BrandExist = false;
               GenericExist = false;
               OEDExist=false;
               BERExist = false;
               GERGenericExist = false;
               MERGenericExist = false;
               NEDGenericExist = false;
               SSGGenericExist = false;
               PrefExist = false;
               NonMacGenericExist = false;
               DispensingExist = false;
               BGDispensing = false;
               ShowGrid = false;
               Boolean ifPass = false;
               Boolean ifPrefPass = false;
               Boolean ifGenPass = false;
               Boolean ifGERGenPass = false;
               Boolean ifMERGenPass = false;
               Boolean ifNEDGenPass = false;
               Boolean ifOEDPass = false;
               Boolean ifNonMacGenPass = false;
               Boolean ifSSGGenPass = false;
               Boolean ifBrandGenDispPass = false;
     
     
               if (netObj.FAF_ID__r.LOB2__c=='EGWP' && netObj.Generic_Basis__c==Label.PCD_Generic_Basis && netObj.Network_Name__c!=Label.Med_D_IHS && (netObj.Network_Name__c==Label.Med_D_HIF || netObj.Network_Name__c==Label.Med_D_LTC || netObj.Network_Name__c==Label.Med_D_TER))
               {
                 NonMacGenericRate = 'MAC' + '\n' + 'Non – MAC:' + '\n';
               }
               if(MinYearAgreegate != null && MinYearAgreegate.get(netObj.Template_Network_Name_Text__c) != null)
                {
                  AggregateResult vYear = MinYearAgreegate.get(netObj.Template_Network_Name_Text__c);
                  if ((vYear.get('MinYear') == netObj.Year__c) && (vYear.get('Name') == netObj.Min_Name__c))
                  {
                    for (Network_Pricing__c BrandRate : AgreegateRate){
                      if( AgreegateRate != null && !AgreegateRate.isEmpty() && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c))
                          {
                              if((BrandRate.Brand_Basis__c != Label.Baked_Preferred_Rate) && BrandRate.Brand_Rate__c != null){
                                 AggrRate+= BrandRate.Template_Brand_Rate__c +  '\n' ;  
                              }
                            if (netObj.Brand_Rate__c != null || BrandRate.Brand_Rate__c != null || BrandRate.Brand_Basis__c != Label.Baked_Preferred_Rate)
                              {BrandExist = true;}
                             //Pass_ Through changes By: Parvathi chunduri US51354
                            if(BrandRate.Brand_Basis__c == Label.Pass_Through_Rate){ifPass = true;}  
                          }
                    
                      if(AgreegateRate != null && !AgreegateRate.isEmpty() && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c) && (BrandRate.Generic_Basis__c == Label.Flat_Generic_Discount || BrandRate.Generic_Basis__c == Label.Pass_Through_Rate))
                          {
                              if (BrandRate.Generic_Rate__c != null){
                                   GenericRate+= BrandRate.Template_Generic_Rate__c +  '\n' ; 
                              }
                           // if (netObj.Generic_Rate__c != null || BrandRate.Generic_Rate__c != null) 
                              GenericExist = true;
                             if(BrandRate.Brand_Basis__c == Label.Pass_Through_Rate){ifGenPass = true;}  
                          }
                         
                        //Start :Changes For OED Rate : Mohit Srivastava //Pass_ Through changes By: Parvathi chunduri US51354
                         if( AgreegateRate != null && !AgreegateRate.isEmpty() && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c) && (BrandRate.Generic_Basis__c!= Label.Flat_Generic_Discount) && netObj.Specialty_Show_in_Grid__c==true)
                          {
                              if (BrandRate.OED_Guarantee_Rate__c != null){  
                                   OEDRate+= BrandRate.Template_OED_Guarantee_Rate__c +  '\n' ;
                              }
                                 
                              
                           // if (netObj.Generic_Rate__c != null || BrandRate.Generic_Rate__c != null)
                           if (netObj.OED_Guarantee_Rate__c != null || BrandRate.OED_Guarantee_Rate__c != null || BrandRate.OED_Count__c > 0)
                              {OEDExist = true;}
                              if(BrandRate.Brand_Basis__c == Label.Pass_Through_Rate){ifOEDPass = true;}  //US51354
                
                          }
                        //End :Changes For OED Rate : Mohit Srivastava //Pass_ Through changes By: Parvathi chunduri US51373
                      if(AgreegateRate != null && !AgreegateRate.isEmpty() && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c) && (BrandRate.Generic_Basis__c != Label.Flat_Generic_Discount))
                          {
                              if(BrandRate.GER_Guarantee_Rate__c != null){
                                   GERGenericRate+= BrandRate.Template_GER_Guarantee_Rate__c +  '\n' ; 
                              }
                          
                            if (netObj.GER_Guarantee_Rate__c != null || BrandRate.GER_Guarantee_Rate__c != null || BrandRate.GER_Count__c > 0)
                              {GERGenericExist = true;}
                              
                            if(BrandRate.Brand_Basis__c == Label.Pass_Through_Rate){ifGERGenPass = true;}  
                              
                          }
                      if( AgreegateRate != null && !AgreegateRate.isEmpty() && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c) && (BrandRate.Generic_Basis__c != Label.Flat_Generic_Discount))
                          {
                              if(BrandRate.MER_Guarantee_Rate__c != null){ //US51373
                                  MERGenericRate+= BrandRate.Template_MER_Guarantee_Rate__c +  '\n' ;  
                              } 
                            if (netObj.MER_Guarantee_Rate__c != null || BrandRate.MER_Guarantee_Rate__c != null || BrandRate.MER_Count__c > 0)
                              {MERGenericExist = true;}
                            if(BrandRate.Brand_Basis__c == Label.Pass_Through_Rate){ifMERGenPass = true;} //US51373  
                          }
                      if( AgreegateRate != null && !AgreegateRate.isEmpty() && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c) && (BrandRate.Generic_Basis__c != Label.Flat_Generic_Discount))
                          {
                              if(BrandRate.NED_Guarantee_Rate__c != null){
                                  NEDGenericRate+= BrandRate.Template_NED_Guarantee_Rate__c +  '\n' ; //US51373 
                              }
                            
                            if (netObj.NED_Guarantee_Rate__c != null || BrandRate.NED_Guarantee_Rate__c != null || BrandRate.NED_Count__c > 0)
                              {NEDGenericExist = true;}
                            if(BrandRate.Brand_Basis__c == Label.Pass_Through_Rate){ifNEDGenPass = true;} //US51373
                          }  
                        //Code difference start here - This is not exist in full
                      
                       if( AgreegateRate != null && !AgreegateRate.isEmpty() && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c) && (((BrandRate.Generic_Basis__c != Label.Flat_Generic_Discount) && netObj.FAF_ID__r.LOB2__c!='EGWP') || ((BrandRate.Generic_Basis__c == Label.PCD_Generic_Basis) && netObj.FAF_ID__r.LOB2__c=='EGWP' )) )
                          {
                            if(netObj.Network_Name__c==Label.Med_D_IHS && netObj.FAF_ID__r.LOB2__c=='EGWP')
                            {
                             if(BrandRate.Template_Generic_Rate__c != null)
                             { 
                                    //Pass_ Through changes By: Parvathi chunduri US51374
                                   if (BrandRate.Generic_Rate__c != null){
                                        NonMacGenericRate+= BrandRate.Template_Generic_Rate__c +  '\n' ;
                                      
                                    }
                                 if(BrandRate.Brand_Basis__c == Label.Pass_Through_Rate){ifNonMacGenPass = true;}
                             }
                                
                            } 
                            else
                            {
                                //Pass_ Through changes By: Parvathi chunduri US51374
                                if (BrandRate.Non_MAC_Generic_Rate__c != null){
                                      NonMacGenericRate+= BrandRate.Template_Non_MAC_Generic_Rate__c +  '\n' ;
                                      NonMacGenericORRate+= BrandRate.Template_Generic_OR_Mac__c +  '\n' ;
                                    
                                }
                           
                            }
                           // if (netObj.Generic_Rate__c != null || BrandRate.Generic_Rate__c != null)
                           // Code difference ends here
                            NonMacGenericExist = true;
                            if(BrandRate.Brand_Basis__c == Label.Pass_Through_Rate){ifNonMacGenPass = true;} //US51374 
                      }               
                      if(AgreegateRate != null && !AgreegateRate.isEmpty() && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c))
                          {
                              //Pass_ Through changes By: Parvathi chunduri US51414
                              if(BrandRate.SSG_Guarantee_Rate__c != null){
                                  SSGGenericRate+= BrandRate.Template_SSG_Guarantee_Rate__c +  '\n' ; 
                              }
                              
                           //  if (netObj.SSG_Guarantee_Rate__c != null || BrandRate.SSG_Guarantee_Rate__c != null || BrandRate.SSG_Guarantee__c > 0)
                              SSGGenericExist = true;
                              if (BrandRate.SSG_Guarantee__c >= 1)
                              {
                               SSGexist = true;
                              }
                              if(BrandRate.Brand_Basis__c == Label.Pass_Through_Rate){ifSSGGenPass = true;} //US51414 
                              
                          } 
                      if(AgreegateRate != null && !AgreegateRate.isEmpty() &&  (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c))
                          {
                              //Pass_ Through changes By: Parvathi chunduri US51413
                            if (BrandRate.Generic_Dispensing_Fee__c == BrandRate.Brand_Dispensing_Fee__c)
                            {
                                if (BrandRate.Brand_Dispensing_Fee__c != null ){
                                     BGDispensingFee+= BrandRate.Template_Brand_Dispensing_Fee__c +  '\n' ;        
                                }
                                             
                            }
                            else
                            {
                            BGDispensing = true;
                            }
                             if (BrandRate.Brand_Dispensing_Fee__c != null){
                                     BrandDispensingFee+= BrandRate.Template_Brand_Dispensing_Fee__c + '\n' ;
                             }
                             if(BrandRate.Generic_Dispensing_Fee__c != null) {
                                      GenericDispensingFee+= BrandRate.Template_Generic_Dispensing_Fee__c + '\n' ;    
                             }                              
                             DispensingExist = true;
                            if(BrandRate.Brand_Basis__c == Label.Pass_Through_Rate){ifBrandGenDispPass = true;}   //US51413
                          }
                          // Changes for Brand generic rate for Retail Speciality Grid :Mohit Srivastava //Pass_ Through changes By: Parvathi chunduri US51413
                    if(AgreegateRate!= null && !AgreegateRate.isEmpty() && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c))
                     {
                            AggrBERRate += BrandRate.Template_BER_Guarantee_Rate__c +  '\n';
                            if ((netObj.BER_Guarantee_Rate__c != null || BrandRate.BER_Guarantee_Rate__c != null) && netObj.FAF_ID__r.LOB2__c !='EGWP')
                             { BERExist = true;}
                             
                            if(BrandRate.Brand_Basis__c == Label.Baked_Preferred_Rate && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c))
                            {
                                if (BrandRate.Preferred_Brand_Rate__c != null){
                                    AggrPrefRate += BrandRate.Template_Preferred_Brand_Rate__c +  '\n';
                                }
                                   if (BrandRate.Non_Preferred_Brand_Rate__c != null){  
                                    AggrNonPrefRate += BrandRate.Template_Non_Preferred_Brand_Rate__c +  '\n'; 
                                }
                            
                             
                           // if(netObj.Brand_Rate__c != null || BrandRate.Brand_Rate__c != null || BrandRate.Brand_Basis__c != Label.Baked_Preferred_Rate)
                             PrefExist = true;
                             if(BrandRate.Brand_Basis__c == Label.Pass_Through_Rate){ifPrefPass = true;} //US51354
                            }
                        }  
                                                 
                  }
                  ShowGrid = true;
                  netObj.Template_Generic_Display__c = false;
                  netObj.Template_Non_MAC_Generic_Display__c = true; 
                  if (netObj.Generic_Basis__c == Label.Flat_Generic_Discount)
                   {
                     netObj.Template_Generic_Display__c = true;
                     netObj.Template_Non_MAC_Generic_Display__c = false;  
                   }
                   // Specialty Grid changes : By Mohit Srivastava
                   // Retail NPricing ~ Pass- Through changes : By Parvathi Chunduri 06/01/2020
                   if(PrefExist == true)
                    { 
                        //Pass_ Through changes By: Parvathi chunduri US51373
                        if(ifPrefPass == true){
                           AggrPrefRate+= '\n' + Label.Pass_Through_Text +  '\n' ;
                           AggrNonPrefRate+= '\n' + Label.Pass_Through_Text +  '\n' ;
                        }
                         netObj.Template_Preferred_Brand_Rate_Text__c = AggrPrefRate;     
                         netObj.Template_Non_Preferred_Brand_Rate_Text__c  = AggrNonPrefRate; 
                         netObj.Template_Preferred_Display__c=true;                                          
                    }
                    else
                    {
                         netObj.Template_Preferred_Brand_Rate_Text__c = ' ';     
                         netObj.Template_Non_Preferred_Brand_Rate_Text__c  = ' ';
                         netObj.Template_Preferred_Display__c=false;
                    }
                   if(BrandExist == true && BERExist == false )
                   { 
                       if(ifPass == true){
                           AggrRate+= '\n' + Label.Pass_Through_Text +  '\n' ;
                       }
                       netObj.Template_Brand_Rate_Text__c = AggrRate;  
                       netObj.Template_Brand_Display__c = true;                                              
                   }
                   else
                  {
                      netObj.Template_Brand_Rate_Text__c = ' ';
                      netObj.Template_Brand_Display__c = false;
                  }
                    // End: Specialty grid changes : Mohit Srivastava
                  if (GenericExist == true || GERGenericExist == true || MERGenericExist == true || NEDGenericExist == true)
                  {
                      netObj.Template_Generic_Display__c = true; 
                  }
                  else
                  {
                      netObj.Template_Generic_Display__c = false; 
                  }
                  if(GenericExist == true)
                   { 
                       if(ifGenPass == true){
                          GenericRate+= '\n' + Label.Pass_Through_Text +  '\n' ;
                       }
                       netObj.Template_Generic_Rate_Text__c = GenericRate;                                                  
                   }
                   else
                  {
                      netObj.Template_Generic_Rate_Text__c = ' ';
                  } 
                  //Start :Changes For OED Rate : Mohit Srivastava
                  if(OEDExist == true)
                   { 
                       if(ifOEDPass == true){
                          OEDRate+= '\n' +  Label.Pass_Through_Text +  '\n' ;
                       }
                       netObj.Template_OED_Guarantee_Rate_Text__c = OEDRate;  
                       netObj.Template_OED_Display__c= true;                                                  
                   }
                  else
                  {
                      netObj.Template_OED_Guarantee_Rate_Text__c = ' ';
                      netObj.Template_OED_Display__c= false;
                  } 
                  //End :Changes For OED Rate : Mohit Srivastava
                  if(GERGenericExist == true)
                   { 
                       if(ifGERGenPass == true){
                         GERGenericRate+= '\n' + Label.Pass_Through_Text +  '\n' ;  
                       }
                       netObj.Template_GER_Guarantee_Rate_Text__c = GERGenericRate;                   
                       netObj.Template_GER_Display__c = true;                                               
                   }
                   else
                  {
                      netObj.Template_GER_Guarantee_Rate_Text__c = ' ';
                      netObj.Template_GER_Display__c = false;   
                  }  
                  if(MERGenericExist == true)
                   { 
                       if(ifMERGenPass == true){
                          MERGenericRate+= '\n' + Label.Pass_Through_Text +  '\n' ;    
                       }
                       netObj.Template_MER_Guarantee_Rate_Text__c = MERGenericRate;   
                       netObj.Template_MER_Display__c = true;                                                  
                   }
                   else
                  {
                      netObj.Template_MER_Guarantee_Rate_Text__c = ' ';
                      netObj.Template_MER_Display__c = false; 
                  }  
                  if(NEDGenericExist == true)
                   { 
                       if(ifNEDGenPass == true){
                          NEDGenericRate+= '\n' + Label.Pass_Through_Text +  '\n' ;    
                       }
                       netObj.Template_NED_Guarantee_Rate_Text__c = NEDGenericRate;  
                       netObj.Template_NED_Display__c = true;                                                   
                   }
                   else
                  {
                      netObj.Template_NED_Guarantee_Rate_Text__c = ' ';
                      netObj.Template_NED_Display__c = false;  
                  }  
                   if(NonMacGenericExist == true) 
                   { 
                       if(ifNonMacGenPass == true){
                          NonMacGenericRate+= '\n' + Label.Pass_Through_Text +  '\n' ; 
                          NonMacGenericORRate+= '\n' +  Label.Pass_Through_Text +  '\n' ;
                       }
                       netObj.Template_Non_MAC_Generic_Rate_Text__c = NonMacGenericRate; 
                       netObj.Template_Generic_OR_Mac_Text__c = NonMacGenericORRate;
                       netObj.Template_NonMacGeneric_Display__c = true;   
                        //Code difference start here - This is not exist in full
                       if(NonMacGenericRate == null && netObj.Network_Name__c==Label.Med_D_IHS && netObj.FAF_ID__r.LOB2__c=='EGWP')
                       {
                        netObj.Template_Non_MAC_Generic_Rate_Text__c = 'Message: Rate not defined.';
                       }   
                       if((netObj.Retail_Network_Ordinal__c=='Primary' || netObj.Retail_Network_Ordinal__c=='Secondary' ) && netObj.Template_NED_Display__c == false && netObj.Template_MER_Display__c == false && netObj.Template_GER_Display__c == false && netObj.FAF_ID__r.LOB2__c=='EGWP')
                       {
                        netObj.Template_Non_MAC_Generic_Rate_Text__c = 'MAC' + '\n' + 'Non – MAC:' + '\n' + NonMacGenericRate; 
                       }
                      // Code difference ends here                                         
                   }
                   else
                  {
                      netObj.Template_Non_MAC_Generic_Rate_Text__c = ' ';
                      netObj.Template_Generic_OR_Mac_Text__c = ' ';
                      netObj.Template_NonMacGeneric_Display__c = true;
                  }  
                  if(SSGGenericExist == true && SSGexist == true)
                   { 
                       
                       if(ifSSGGenPass == true){
                          SSGGenericRate+= '\n' + Label.Pass_Through_Text +  '\n' ;    
                       }
                       netObj.Template_SSG_Guarantee_Rate_Text__c = SSGGenericRate; 
                       netObj.SSG_Display__c = true; 
                                               
                   }
                   else
                  {
                      netObj.Template_SSG_Guarantee_Rate_Text__c = ' ';
                      netObj.SSG_Display__c = false; 
                  }  
                  
                  if(DispensingExist == true)  
                   { 
                      if (BGDispensing == true)
                      {
                         if(ifBrandGenDispPass == true){
                            GenericDispensingFee+= '\n' + Label.Pass_Through_Text +  '\n' ; 
                         }
                          if(BrandDispensingFee != null && BrandDispensingFee != ''){
                               DispensingFee = 'Brand' + '\n' + BrandDispensingFee;
                          }
                          
                        String GDispensingFeeVerify = GenericDispensingFee.trim(); 
                        if(GDispensingFeeVerify != Label.Pass_Through_Text){  
                              if(DispensingFee != null  && DispensingFee != '')
                      	         DispensingFee += 'Generic' + '\n' + GenericDispensingFee + '\n';
                              else  DispensingFee = 'Generic' + '\n' + GenericDispensingFee;
                        }else{
                          DispensingFee += GenericDispensingFee; 
                         }
                         
                      }
                      else 
                      {
                      if(ifBrandGenDispPass == true){
                          BGDispensingFee+= '\n' + Label.Pass_Through_Text +  '\n' ;  
                      }
                          String BGDispensingFeeVerify = BGDispensingFee.trim(); 
                          if(BGDispensingFeeVerify != Label.Pass_Through_Text){
                              DispensingFee = '\n' + 'Brand & Generic' + '\n' + BGDispensingFee;
                          }else{
                              DispensingFee =  BGDispensingFee;
                          }
                      
                      }
                      netObj.Template_Dispensing_Fee_Text__c = DispensingFee;                                                   
                   }
                   else
                      {
                       netObj.Template_Dispensing_Fee_Text__c = ' ';
                      }  
                  
                   }   
                  if(ShowGrid != true)
                   { 
                       netObj.Show_in_Grid__c = false;
                       netObj.Specialty_Show_in_Grid__c=false;
                       ShowinGrid.add(netObj); 
                   }               
                }         
                
                if(BrandExist == false && netObj.Template_BER_Guarantee_Rate_Text__c== null && netObj.FAF_ID__r.LOB2__c !='EGWP')
                {netObj.Template_Brand_Rate_Text__c= netObj.Template_Brand_Rate__c;}
                          //netObj.Batch_Update__c = false;  
                          ListNpricing.add(netObj);                           
                          }
     }
if (ListNpricing != null && !ListNpricing.isEmpty())
{
   Update ListNpricing;
}

if (ShowinGrid != null && !ShowinGrid.isEmpty())
{
   Update ShowinGrid;
}

}
catch(DmlException e)
    {
     System.debug(e.getMessage());
    } 
}
}