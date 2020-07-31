/*=======================================================================================*/
public class Invoke_iUMS_FAF_Delete{
/* =================================================================================
 * @Class Name        : Invoke_iUMS_FAF_Delete_Method
 * @author            : Soumendu Chowdhury
 * @created date      : 05/05/2020
 * @Purpose           : Delete older version of iums Record
=======================================================================================*/
    @InvocableMethod
    public static void Invoke_iUMS_FAF_Delete_Method(List<id> objId)
    { 
        try
        {
            DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
            List<Offer__c> offer = [Select ID from Offer__c where iUMSTask__c = :objId];
            List<LOB__c> lob = [Select ID,FAF__c from LOB__c where FAF__c != null and Client_Pricing_Offer__c  = :offer];
            Set<ID> fafid = new Set<ID>();
            for(LOB__c lb:lob)
            {
              fafid.add(lb.FAF__c);
            }
            
            List<Central_Hub__c> faf = [Select ID,Data_Loading__c from Central_Hub__c where ID IN :fafid];
            List<Central_Hub__c> updatefaf = new List<Central_Hub__c>();
            for(Central_Hub__c fafupd : faf)
            {
             fafupd.Data_Loading__c = true;
             fafupd.FAF_Copy_In_Progress__c = true;
             fafupd.Source_Copy_FAF_Status__c='Draft';
             updatefaf.add(fafupd);
            }
            if (!updatefaf.isEmpty() && updatefaf != null)
            {
              update updatefaf;
            }
            
            
            for(LOB__c lb:lob)
            {
            
            IUMSDeleteObjectrecords1 iumsfaf1=new IUMSDeleteObjectrecords1();
            iumsfaf1.query ='Select id from Central_Hub__c where ID =\'' + lb.FAF__c + '\'';
            Database.executeBatch(iumsfaf1);  
            
            }
          
          List<Central_Hub__c> updatefaffalse = new List<Central_Hub__c>();
            for(Central_Hub__c fafupd : faf)
            {
             fafupd.Data_Loading__c = false;
              fafupd.FAF_Copy_In_Progress__c = false;
             fafupd.Source_Copy_FAF_Status__c=null;
             updatefaffalse.add(fafupd);
            }
            if (!updatefaffalse.isEmpty() && updatefaffalse != null)
            {
              update updatefaffalse;
            }
          
           List<iUMS_Task_Setup__c> iumstasksetupd = new List<iUMS_Task_Setup__c>();
           List<iUMS_Task_Setup__c> iumstasksetup = [Select ID,iUMS_Delete__c from iUMS_Task_Setup__c where iUMS_Task__c = :objId];
           for(iUMS_Task_Setup__c iumssetup: iumstasksetup )
            {
             iumssetup.iUMS_Delete__c = false;
             iumstasksetupd.add(iumssetup);
            }
            if (!iumstasksetupd.isEmpty() && iumstasksetupd != null)
             {
              Update iumstasksetupd;
             }
        }

     catch(DmlException e)
            {
             System.debug(e.getMessage());
            } 

    }
}