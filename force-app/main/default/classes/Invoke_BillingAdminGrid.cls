/* =================================================================================
 * @Class Name        : Invoke_BillingAdminGrid
 * @author            : Soumendu Chowdhury
 * @created date      : 07/12/2019
 * @Purpose           : Populate Data Structure to finalyze Data structure at Customer Facing Template
                        Exclude four Field in FAF from Copy
=======================================================================================*/
global class Invoke_BillingAdminGrid{

/*=================================================================================
 * @Method Name       : BillingAdminGrid
 * @author            : Soumendu Chowdhury
 * @created date      : 07/12/2019
 * @Last modified by  : Soumendu Chowdhury
 * @Purpose           : Populate Data Structure to finalyze Data structure at Customer Facing Template
=======================================================================================*/
@InvocableMethod
global static void BillingAdminGrid(List<id> objId)
{
try
{
if(DeepCloneUtility.OFF_INVOCABLE_CLASS)
{
Boolean ElectronicFeeExist;
Boolean ManualFeeExist;
Boolean Fee340BExist;
Boolean  EGWPPMPMExist;
String ElectronicFeeType;
String ManualFeeType;
String CustomDes;
String Fee340BType;
String EGWPPMPMType;
DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
        List<string> FAFStat = new List<string>();
        for(string s: FAFStatus.Value__c.split(','))
              {
                 FAFStat.add(s);
              }        
List<Central_Hub__c> BadminFee =[SELECT ID,Name,Custom_Description__c,Template_340B_Display__c,Template_EGWPPMPM_Display__c,Template_Master_EGWPPMPM_Type_Text__c,Template_Master_340B_Type_Text__c,Template_Master_Electronic_Fee_Text__c,Template_Master_Manual_Claim_Fee_Text__c
                                                 FROM Central_Hub__c WHERE FAF_Status__c IN:FAFStat  AND ID IN:objId];


List<Billing_Administrative_Fees__c> AgreegateAdminFee  =[SELECT ID,Custom_Description__c,Name,Admin_Fee_Type__c,Total__c,Base_Amount__c,Broker_Amount__c,LOB__c,PCD_Manual_Claim_Fee__c,PCD_Unique_EGWPPMPM_Fee_Type__c,Template_EGWPPMPM_Fee_Type_Text__c,
                                                 PCD_Unique_Fee_Type__c,Show_in_Grid__c,Template_340B_Type_Text__c,Template_Admin_Fee_Type_Text__c,Billing_Operations__c,
                                                 Template_Manual_Claim_Admin_Text__c,Year__c,PCD_Unique_Manual_Fee_Type__c,PCD_Unique_340B_Fee_Type__c,Year_Start_Date__c,Year_End_Date__c
                                                 FROM Billing_Administrative_Fees__c WHERE FAF_ID__r.FAF_Status__c IN:FAFStat AND 
                                                 (PCD_Unique_Fee_Type__c = true OR PCD_Unique_Manual_Fee_Type__c = true OR PCD_Unique_340B_Fee_Type__c = true OR PCD_Unique_EGWPPMPM_Fee_Type__c=true)  AND FAF_ID__c IN:objId ORDER BY Year__c ASC];

List<Central_Hub__c> Fafupdate = new List<Central_Hub__c>();
for(Central_Hub__c  Adminfee: BadminFee )
{  
ElectronicFeeExist = false;
ManualFeeExist = false;
Fee340BExist = false;
EGWPPMPMExist = false;
ElectronicFeeType = '';
ManualFeeType = '';
Fee340BType = '';
EGWPPMPMType='';
Adminfee.Template_Master_Electronic_Fee_Text__c =' ';
Adminfee.Template_Master_Manual_Claim_Fee_Text__c =' ';
Adminfee.Template_Master_340B_Type_Text__c =' ';
                     for (Billing_Administrative_Fees__c billing : AgreegateAdminFee)
                     {
                        if (billing.PCD_Unique_Fee_Type__c == true)
                        {
                         ElectronicFeeType += billing.Template_Admin_Fee_Type_Text__c + '\n';
                         ElectronicFeeExist = true;
                        }
                        if (billing.PCD_Unique_Manual_Fee_Type__c == true)
                        {
                         ManualFeeType += billing.Template_Manual_Claim_Admin_Text__c + '\n';
                         ManualFeeExist = true;
                        }
                        if (billing.PCD_Unique_340B_Fee_Type__c == true)
                        {
                         Fee340BType += billing.Template_340B_Type_Text__c + '\n';
                         Adminfee.Template_340B_Display__c = true;
                         Fee340BExist = true;
                        }
                        if (billing.PCD_Unique_EGWPPMPM_Fee_Type__c == true)
                        {
                         EGWPPMPMType+= billing.Template_EGWPPMPM_Fee_Type_Text__c + '\n';
                         Adminfee.Template_EGWPPMPM_Display__c = true;
                         EGWPPMPMExist = true;
                        }
                        if(billing.Custom_Description__c!=null){
                          CustomDes=billing.Custom_Description__c;
                         }
                        
                     }
                     if (ElectronicFeeExist == true)
                     {
                       Adminfee.Template_Master_Electronic_Fee_Text__c = ElectronicFeeType;
                     }
                     else
                     {
                       Adminfee.Template_Master_Electronic_Fee_Text__c = 'Per All Claims' + '\n' + '$0.00';
                     }
                     if (ManualFeeExist == true)
                     {
                       Adminfee.Template_Master_Manual_Claim_Fee_Text__c = ManualFeeType;
                     }
                     else
                     {
                       Adminfee.Template_Master_Manual_Claim_Fee_Text__c = 'Per All Claims' + '\n' + '$1.50';
                     }
                     if (Fee340BExist == true)
                     {
                       Adminfee.Template_Master_340B_Type_Text__c = Fee340BType;
                     }
                     else
                     {
                     Adminfee.Template_340B_Display__c = false;
                     }
                     
                     if (EGWPPMPMExist == true)
                     {
                       Adminfee.Template_Master_EGWPPMPM_Type_Text__c  = EGWPPMPMType;
                     }
                     else
                     {
                     Adminfee.Template_EGWPPMPM_Display__c = false;
                     }
                     system.debug('AgreegateAdminFee.size()'+AgreegateAdminFee.size());
                     if(CustomDes!=null ){
                      Adminfee.Custom_Description__c=CustomDes;
                     }
                     else{
                     if(AgreegateAdminFee.isEmpty() || CustomDes==null||CustomDes==''){
                      Adminfee.Custom_Description__c='Administrative Fees';
                      }
                     }
                     Fafupdate.add(Adminfee);
}
 if(!Fafupdate.isEmpty())
            {
             Database.update(Fafupdate);
            }
}
}
catch(Exception Ex)
{ 
    system.debug('Exception....'+ex.getMessage());
}
DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=true;
}

}