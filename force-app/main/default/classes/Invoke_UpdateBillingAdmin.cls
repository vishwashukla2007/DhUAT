/* =================================================================================
 * @Class Name        : Invoke_UpdateBillingAdmin
 * @author            : Soumendu Chowdhury
 * @created date      : 07/12/2019
 * @Purpose           : Populate Data Structure for Billing Admin Fee require at Customer Facing Template
=======================================================================================*/
global class Invoke_UpdateBillingAdmin{

/*=================================================================================
 * @Method Name       : UpdateBillingAdmin
 * @author            : Soumendu Chowdhury
 * @created date      : 07/12/2019
 * @Last modified by  : Soumendu Chowdhury
 * @Purpose           : Populate Data Structure for Billing Admin Fee require at Customer Facing Apttus Template
=======================================================================================*/
@InvocableMethod
global static void UpdateBillingAdmin(List<id> objId)
{
try
{
if(DeepCloneUtility.OFF_INVOCABLE_CLASS)
{
Set<id> ids=new set<id>();
Set<id> FAFids=new set<id>();
String TotalFeeType;
String TotalManualFeeType;
String Total340BFeeType;
String TotalEGWPPMPMFeeType;
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
Map<id,Billing_Administrative_Fees__c> MapYearComb = new Map<id,Billing_Administrative_Fees__c>();
Map<id,Billing_Administrative_Fees__c> ExcludeAdmin = new Map<id,Billing_Administrative_Fees__c>();
Set<String> yearstr=new Set<String>();
List<Billing_Administrative_Fees__c> Billupdate = new List<Billing_Administrative_Fees__c>();
List<Billing_Administrative_Fees__c> BillDateupdate = new List<Billing_Administrative_Fees__c>();
DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
        List<string> FAFStat = new List<string>();
        for(string s: FAFStatus.Value__c.split(','))
              {
                 FAFStat.add(s);
              }        
List<Billing_Administrative_Fees__c> BadminFee =[SELECT ID,FAF_ID__c,Name,Admin_Fee_Type__c,Total__c,Base_Amount__c,Broker_Amount__c,LOB__c,PCD_Manual_Claim_Fee__c,PCD_Unique_EGWPPMPM_Fee_Type__c,Template_EGWPPMPM_Fee_Type_Text__c,FAF_ID__r.LOB2__c,
                                                 PCD_Unique_Fee_Type__c,Show_in_Grid__c,Template_340B_Type_Text__c,Template_Admin_Fee_Type_Text__c,Billing_Operations__c,
                                                 Template_Manual_Claim_Admin_Text__c,Year__c,PCD_Unique_Manual_Fee_Type__c,PCD_Unique_340B_Fee_Type__c,Year_Start_Date__c,Year_End_Date__c
                                                 FROM Billing_Administrative_Fees__c WHERE FAF_ID__r.FAF_Status__c IN:FAFStat  AND Billing_Operations__c IN:objId ORDER BY Year__c ASC];

Map<String,AggregateResult> MinAgreegate = new Map<String,AggregateResult>([SELECT Admin_Fee_Type__c Id, Min(Name) MinName
                                                 FROM Billing_Administrative_Fees__c 
                                                 WHERE FAF_ID__r.FAF_Status__c IN:FAFStat 
                                                 AND Billing_Operations__c IN:objId
                                                 GROUP BY Admin_Fee_Type__c]);

List<String> AdminFeeType = new List<String>(getPickListValuesIntoList());
for(Billing_Administrative_Fees__c  billadmObjfaf : BadminFee)
               {
               FAFids.add(billadmObjfaf.FAF_ID__c);
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
for(Billing_Administrative_Fees__c  billadmObj : BadminFee)
               {
               ids.add(billadmObj.id);
               yearstr.add(billadmObj.Year__c);
               if(billadmObj.Year__c=='All')
               {
               MapYearComb.put(billadmObj.Id,billadmObj);
               }
               system.debug('ccccccc');
                if(billadmObj.Year__c=='1'){
                 system.debug('ccccccc1');
                billadmObj.Year_Start_Date__c=MapYear1Begin.get(billadmObj.FAF_ID__c);
                }
                if(billadmObj.Year__c=='2' ){
                 system.debug('ccccccc2');
                    billadmObj.Year_Start_Date__c=MapYear2Begin.get(billadmObj.FAF_ID__c);
                }
                if(billadmObj.Year__c=='3'){
                    billadmObj.Year_Start_Date__c=MapYear3Begin.get(billadmObj.FAF_ID__c);
                }
                if(billadmObj.Year__c=='4'){
                    billadmObj.Year_Start_Date__c=MapYear4Begin.get(billadmObj.FAF_ID__c);
                }
                if(billadmObj.Year__c=='5'){
                    billadmObj.Year_Start_Date__c=MapYear5Begin.get(billadmObj.FAF_ID__c);
                }
                // Year End Date 
                
                if(billadmObj.Year__c=='1' ){
                billadmObj.Year_End_Date__c=MapYear1End.get(billadmObj.FAF_ID__c);
                }
                if(billadmObj.Year__c=='2' ){
                    billadmObj.Year_End_Date__c=MapYear2End.get(billadmObj.FAF_ID__c);
                }
                if(billadmObj.Year__c=='3' ){
                    billadmObj.Year_End_Date__c=MapYear3End.get(billadmObj.FAF_ID__c);
                }
                if(billadmObj.Year__c=='4' ){
                    billadmObj.Year_End_Date__c=MapYear4End.get(billadmObj.FAF_ID__c);
                }
                if(billadmObj.Year__c=='5' ){
                    billadmObj.Year_End_Date__c=MapYear5End.get(billadmObj.FAF_ID__c);
                }
                //For Year All
                
                if(billadmObj.Year__c=='All'){
                    billadmObj.Year_End_Date__c=MapContractEndDt.get(billadmObj.FAF_ID__c);
                }
                if(billadmObj.Year__c=='All'){
                    billadmObj.Year_Start_Date__c=MapContractDt.get(billadmObj.FAF_ID__c);
                }
                BillDateupdate.add(billadmObj);
               }
 if(!BillDateupdate.isEmpty())
            {
             Database.update(BillDateupdate);
            }
List<Billing_Administrative_Fees__c> AgreegateAdminFee  =[SELECT ID,Name,Admin_Fee_Type__c,Total__c,Base_Amount__c,Broker_Amount__c,LOB__c,PCD_Manual_Claim_Fee__c,PCD_Unique_EGWPPMPM_Fee_Type__c,Template_EGWPPMPM_Fee_Type_Text__c,
                                                 PCD_Unique_Fee_Type__c,Show_in_Grid__c,Template_340B_Type_Text__c,Template_Admin_Fee_Type_Text__c,Billing_Operations__c,
                                                 Template_Manual_Claim_Admin_Text__c,Year__c,PCD_Unique_Manual_Fee_Type__c,PCD_Unique_340B_Fee_Type__c,Year_Start_Date__c,Year_End_Date__c
                                                 FROM Billing_Administrative_Fees__c WHERE FAF_ID__r.FAF_Status__c IN:FAFStat  AND Billing_Operations__c IN:objId ORDER BY Year__c ASC];

for(Billing_Administrative_Fees__c  billadmObj : BadminFee)
               {
                 for(Billing_Administrative_Fees__c bill: MapYearComb.values())
                   {
                    if((billadmObj.Year__c=='1'|| billadmObj.Year__c=='2' ||billadmObj.Year__c=='3' ||billadmObj.Year__c=='4'|| billadmObj.Year__c=='5') && bill.Year__c=='All' && (billadmObj.Admin_Fee_Type__c == bill.Admin_Fee_Type__c))
                    {
                        ExcludeAdmin.put(billadmObj.Id,billadmObj);
                    }
                   } 
               }        
                                         
for(Billing_Administrative_Fees__c  Adminfee: BadminFee )
{                                                 
    Adminfee.PCD_Unique_Fee_Type__c = false;
    Adminfee.PCD_Unique_Manual_Fee_Type__c = false;
    Adminfee.PCD_Unique_340B_Fee_Type__c = false;
    Adminfee.PCD_Unique_EGWPPMPM_Fee_Type__c = false;
    Adminfee.Show_in_Grid__c = false;
    Adminfee.Template_340B_Type_Text__c = ' ';
    Adminfee.Template_Admin_Fee_Type_Text__c = ' ';
    Adminfee.Template_Manual_Claim_Admin_Text__c = ' ';     
    Adminfee.Template_EGWPPMPM_Fee_Type_Text__c = ' ';                                       
    TotalFeeType = '';
    TotalManualFeeType = '';
    Total340BFeeType = '';
    TotalEGWPPMPMFeeType = '';
    
    if(MinAgreegate != null && MinAgreegate.get(Adminfee.Admin_Fee_Type__c) != null ) 
                {
                  AggregateResult  vName = MinAgreegate.get(Adminfee.Admin_Fee_Type__c); 
                  if (vName.get('MinName') == Adminfee.Name) 
                  {
                    for (Billing_Administrative_Fees__c billing : AgreegateAdminFee)
                     {
                        //Changes for year issue : Mohit
                        Datetime stdt = billing.Year_Start_Date__c;
                        Datetime eddt = billing.Year_End_Date__c;
                        if (Adminfee.Admin_Fee_Type__c == billing.Admin_Fee_Type__c && Adminfee.Admin_Fee_Type__c != Label.PCD_Manual_Fee_Type && !Label.PCD_340B_Fee_Type.Contains(Adminfee.Admin_Fee_Type__c) && ExcludeAdmin.get(billing.Id)== null)
                        {
                          if(Adminfee.FAF_ID__r.LOB2__c != 'EGWP' || (Adminfee.FAF_ID__r.LOB2__c == 'EGWP' && Adminfee.Admin_Fee_Type__c != Label.EGWP_Per_Member_Per_Month))
                          {
                          Adminfee.PCD_Unique_Fee_Type__c = true;
                            if (billing.Year__c == 'All')
                            {
                                if (billing.Total__c != null)
                                TotalFeeType += '$' + billing.Total__c + '\n';
                                else
                                TotalFeeType += '$' + '\n';
                            }
                            else
                            {
                               if (billing.Total__c != null)
                                {
                                    TotalFeeType += stdt.formatGMT('MM/dd/yyyy') + ' - ' + eddt.formatGMT('MM/dd/yyyy')  +': $' + billing.Total__c + '\n';
                                    System.debug('++++++++++++TotalFeeType1++++++++'+TotalFeeType);
                                }
                                   else
                                    TotalFeeType += stdt.formatGMT('MM/dd/yyyy') + ' - ' + eddt.formatGMT('MM/dd/yyyy')  +': $' + '\n';
                            }
                           }
                        }
                        
                        if (Adminfee.Admin_Fee_Type__c == billing.Admin_Fee_Type__c && Adminfee.Admin_Fee_Type__c == Label.PCD_Manual_Fee_Type && !Label.PCD_340B_Fee_Type.Contains(Adminfee.Admin_Fee_Type__c) && ExcludeAdmin.get(billing.Id)== null)
                        {
                           Adminfee.PCD_Unique_Manual_Fee_Type__c = true;
                           if (billing.Year__c == 'All')
                            {
                                if (billing.Total__c != null)
                                TotalManualFeeType += '$' + billing.Total__c + '\n';
                                else
                                TotalManualFeeType += '$' + '\n';
                            }
                          else
                          {
                           if (billing.Total__c != null)
                           { TotalManualFeeType +=  stdt.formatGMT('MM/dd/yyyy') + ' - ' + eddt.formatGMT('MM/dd/yyyy')  +': $' + billing.Total__c + '\n';
                            System.debug('++++++++++++TotalManualFeeType ++++++++'+TotalManualFeeType );}
                           else
                            TotalManualFeeType += stdt.formatGMT('MM/dd/yyyy') + ' - ' + eddt.formatGMT('MM/dd/yyyy')  +': $' + '\n';
                          }
                           
                        }
                        
                        if (Adminfee.Admin_Fee_Type__c == billing.Admin_Fee_Type__c && Adminfee.Admin_Fee_Type__c != Label.PCD_Manual_Fee_Type && Label.PCD_340B_Fee_Type.Contains(Adminfee.Admin_Fee_Type__c) && ExcludeAdmin.get(billing.Id)== null)
                        {
                          Adminfee.PCD_Unique_340B_Fee_Type__c = true;
                                              
                          if (billing.Year__c == 'All')
                          {
                            if (billing.Total__c != null)
                            Total340BFeeType += '$' + billing.Total__c + '\n';
                            else
                            Total340BFeeType += '$' + '\n';
                          }
                          else
                          {
                           if (billing.Total__c != null)
                            Total340BFeeType += stdt.formatGMT('MM/dd/yyyy') + ' - ' + eddt.formatGMT('MM/dd/yyyy') +': $' + billing.Total__c + '\n';
                           else
                            Total340BFeeType += stdt.formatGMT('MM/dd/yyyy') + ' - ' + eddt.formatGMT('MM/dd/yyyy')  +': $' + '\n';
                          }
                                
                          
                        }
                        
                        if (Adminfee.Admin_Fee_Type__c == billing.Admin_Fee_Type__c && Adminfee.Admin_Fee_Type__c == Label.EGWP_Per_Member_Per_Month  && ExcludeAdmin.get(billing.Id)== null)
                        {
                          Adminfee.PCD_Unique_EGWPPMPM_Fee_Type__c = true;
                                              
                          if (billing.Year__c == 'All')
                          {
                            if (billing.Total__c != null)
                            TotalEGWPPMPMFeeType += '$' + billing.Total__c + '\n';
                            else
                            TotalEGWPPMPMFeeType += '$' + '\n';
                          }
                          else
                          {
                           if (billing.Total__c != null)
                            TotalEGWPPMPMFeeType += stdt.formatGMT('MM/dd/yyyy') + ' - ' + eddt.formatGMT('MM/dd/yyyy') +': $' + billing.Total__c + '\n';
                           else
                            TotalEGWPPMPMFeeType += stdt.formatGMT('MM/dd/yyyy') + ' - ' + eddt.formatGMT('MM/dd/yyyy')  +': $' + '\n';
                          }
                                
                          
                        }
                    
                     }
                     if (Adminfee.PCD_Unique_Fee_Type__c == true)
                     {
                         Adminfee.Template_Admin_Fee_Type_Text__c = Adminfee.Admin_Fee_Type__c + '\n' + TotalFeeType;
                     }
                    
                    if (Adminfee.PCD_Unique_Manual_Fee_Type__c == true)
                     {
                         Adminfee.Template_Manual_Claim_Admin_Text__c = Adminfee.Admin_Fee_Type__c + '\n' + TotalManualFeeType;
                     }
                     
                    if (Adminfee.PCD_Unique_340B_Fee_Type__c == true)
                     {
                         Adminfee.Template_340B_Type_Text__c = Adminfee.Admin_Fee_Type__c + '\n' + Total340BFeeType;
                     }
                     if (Adminfee.PCD_Unique_EGWPPMPM_Fee_Type__c == true)
                     {
                         Adminfee.Template_EGWPPMPM_Fee_Type_Text__c = Adminfee.Admin_Fee_Type__c + '\n' + TotalEGWPPMPMFeeType ;
                     }
                    
                  }     
                }   
                Billupdate.add(Adminfee);                      
}        

 if(!Billupdate.isEmpty())
            {
             Database.update(Billupdate);
            }
                                         
}
}
catch(Exception Ex)
{ 
    system.debug('Exception....'+ex.getMessage());
}
DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=true;
}


// Extract Billing Admin Fee Picklist Value in Dynamic way
public static List<String> getPickListValuesIntoList(){
       List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Billing_Administrative_Fees__c.Admin_Fee_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }


}