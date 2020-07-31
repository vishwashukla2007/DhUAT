/* =================================================================================
 * @Class Name        : PopulateWizardID
 * @author            : Mohit Srivastava(Accenture)
 * @created date      : 01/04/2019
 * @Purpose           : PopulateWizardID
=======================================================================================*/
public class PopulateWizardID{

/*=================================================================================
 * @Method Name       : PopulateWizardID
 * @author            : Mohit Srivastava(Accenture)
 * @created date      : 01/04/2019
 * @Last modified by  : Mohit Srivastava(Accenture)
 * @Purpose           : PopulateWizardID
=======================================================================================*/
@InvocableMethod
public static void populateWizardIdOnLineItem(List<id> objId)
{
    map<Id,date> mapClient=new map<Id,date>();
    Set<String> setLobs=new Set<String>();
     Map<String,String> mapStr=new  Map<String,String>();
    List<String> lstString=new List<String>();
    List<Apttus__AgreementLineItem__c> ApttusListUpdate=new List<Apttus__AgreementLineItem__c>();
    List<Network_Pricing__c> ApttusListUpdate2=new List<Network_Pricing__c>();
    List<Network_Operations__c> ApttusListUpdate3=new List<Network_Operations__c>();
    List<Retail_Network_Guarantees__c> ApttusListUpdate4=new List<Retail_Network_Guarantees__c>();
                    
        String CustomLabelWizard=System.Label.DefaultWizard;
        lstString=CustomLabelWizard.split(',');
        integer i=0;
        if(!lstString.isEmpty()){
            for(String str:lstString)
            {
                //string str1;
                if(Math.Mod(i,2)== 0)
                    String str1=str;
                
                else
                    mapStr.put(str1,str);
                    i=i+1;
                
                system.debug('mapStrmapStrmapStr'+mapStr);
            }
        }
        for(Apttus__AgreementLineItem__c cl:[select id, PCD_FAF__c, Apttus__AgreementId__c, Default_Wizard__c,LOB__c from Apttus__AgreementLineItem__c where ID in:objId ]){
              system.debug('mapStr.get(cl.LOB__c)mapStr.get(cl.LOB__c)mapStr.get(cl.LOB__c)mapStr.get(cl.LOB__c)'+mapStr.get(cl.LOB__c));
            cl.Default_Wizard__c=mapStr.get(cl.LOB__c);
            ApttusListUpdate.add(cl);

            for(Network_Operations__c no:[select id, Agreement_Line_Item__c from Network_Operations__c where FAF_ID__c =: cl.PCD_FAF__c]){
                system.debug('--Network Operations--'+no.id);
                no.Agreement_Line_Item__c = cl.id;
                ApttusListUpdate3.add(no);
            }            

            for(Network_Pricing__c np:[select id, Agreement_Line_Item__c from Network_Pricing__c where FAF_ID__c =: cl.PCD_FAF__c]){
                system.debug('--Network Pricing--'+np.id);
                np.Agreement_Line_Item__c = cl.id;
                np.Agreement__c= cl.Apttus__AgreementId__c;
                ApttusListUpdate2.add(np);
           }   

            for(Retail_Network_Guarantees__c ng:[select id, Agreement_Line_Item__c from Retail_Network_Guarantees__c where FAF_ID__c =: cl.PCD_FAF__c]){
                system.debug('--Network Guarantees--'+ng.id);
                ng.Agreement_Line_Item__c = cl.id;
                ng.Agreement__c= cl.Apttus__AgreementId__c;
                ApttusListUpdate4.add(ng);
           }                     
        }
        
        try{
            if(!ApttusListUpdate.isEmpty()){
                Database.Update(ApttusListUpdate);
            }
            if(!ApttusListUpdate2.isEmpty()){
                Database.Update(ApttusListUpdate2);
            } 
            if(!ApttusListUpdate3.isEmpty()){
                Database.Update(ApttusListUpdate3);
            }                        
        }
        Catch(Exception ex){
           system.debug('The Excepttion Occured '+ ex);
        }
    }
}