/* =================================================================================
 * @Class Name        : Invoke_Update_FAF 
 * @author            : Soumendu Chowdhury
 * @created date      : 06/12/2019
 * @Purpose           : Update FAF to update PCD Warning message 
=======================================================================================*/
public class Invoke_Update_FAF{
/*=================================================================================
 * @Method Name       : Invoke_Update_FAF_Update
 * @author            : Soumendu Chowdhury
 * @created date      : 06/12/2019
 * @Last modified by  : Soumendu Chowdhury
 * @Purpose           : Update FAF to update PCD Warning message 
=======================================================================================*/
@InvocableMethod
public static void Invoke_Update_FAF_Update(List<Id> objId)
{ 
try
{
Invoke_Update_FAF_Update_Async(objId);
/*
if (DeepCloneUtility.OFF_INVOCABLE_CLASS == true)
{
  DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = true;
}
Central_Hub__c[] ListFAF = new List<Central_Hub__c>();
Map<Id,Central_Hub__c> FAF = new Map<Id,Central_Hub__c>([SELECT Id,PCD_Warning_Change__c 
                                        FROM Central_Hub__c 
                                        WHERE ID IN:objId]);
for(Central_Hub__c  FAFlst: FAF.values())
{
 if (FAFlst.PCD_Warning_Change__c == false)
 {
   FAFlst.PCD_Warning_Change__c=true;
 }
 else 
 {
   FAFlst.PCD_Warning_Change__c=false;
 }
 ListFAF.add(FAFlst);
} 
if (ListFAF!= null && !ListFAF.isEmpty())
{
   Update ListFAF;
}       */                             
}
catch(DmlException e)
    {
     System.debug(e.getMessage());
    } 
}
/*=================================================================================
 * @Method Name       : Invoke_Update_FAF_Update_Async
 * @author            : Soumendu Chowdhury
 * @created date      : 06/12/2019
 * @Last modified by  : Soumendu Chowdhury
 * @Purpose           : Update FAF to update PCD Warning message in Async process
=======================================================================================*/
@future
public static void Invoke_Update_FAF_Update_Async(List<Id> objId)
{ 
try
{
if (DeepCloneUtility.OFF_INVOCABLE_CLASS == true)
{
  DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = true;
}
Central_Hub__c[] ListFAF = new List<Central_Hub__c>();
Map<Id,Central_Hub__c> FAF = new Map<Id,Central_Hub__c>([SELECT Id,PCD_Warning_Change__c 
                                        FROM Central_Hub__c 
                                        WHERE ID IN:objId]);
for(Central_Hub__c  FAFlst: FAF.values())
{
 if (FAFlst.PCD_Warning_Change__c == false)
 {
   FAFlst.PCD_Warning_Change__c=true;
 }
 else 
 {
   FAFlst.PCD_Warning_Change__c=false;
 }
 ListFAF.add(FAFlst);
} 
if (ListFAF!= null && !ListFAF.isEmpty())
{
   Update ListFAF;
}                                    
}
catch(DmlException e)
    {
     System.debug(e.getMessage());
    } 
}
}