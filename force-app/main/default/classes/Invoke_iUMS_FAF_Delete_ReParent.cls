/*=======================================================================================*/
public class Invoke_iUMS_FAF_Delete_ReParent{
/* =================================================================================
 * @Class Name        : Invoke_iUMS_FAF_Delete_ReParent
 * @author            : Soumendu Chowdhury
 * @created date      : 05/08/2020
 * @Purpose           : Update Parent of Pricing Records
=======================================================================================*/
    @InvocableMethod
    public static void Invoke_iUMS_FAF_Delete_ReParent(List<id> objId)
    { 
       Invoke_iUMS_FAF_Delete_ReParentfuture(objId);
    }

 public static void Invoke_iUMS_FAF_Delete_ReParentfuture(List<id> objId)
    { 
        try
        {
            DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
            DeepCloneUtility.OFF_INVOCABLE_CLASS = false;
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
             updatefaf.add(fafupd);
            }
            if (!updatefaf.isEmpty() && updatefaf != null)
            {
              update updatefaf;
            }
            DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
            
            for(LOB__c lb:lob)
            {
          
              IUMS_FAF_Delete_ReParentbatch iumsfaf=new IUMS_FAF_Delete_ReParentbatch();
              iumsfaf.query ='select id from Central_Hub__c where ID =\'' + lb.FAF__c +'\'';
              Database.executeBatch(iumsfaf);
                
             }
          DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;   
          List<Central_Hub__c> updatefaffalse = new List<Central_Hub__c>();
            for(Central_Hub__c fafupd : faf)
            {
             fafupd.Data_Loading__c = false;
             updatefaffalse.add(fafupd);
            }
            if (!updatefaffalse.isEmpty() && updatefaffalse != null)
            {
              update updatefaffalse;
            }  
            
          }
          
         
            //DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = true;
          
   
     catch(DmlException e)
            {
             System.debug(e.getMessage());
            } 
}


}