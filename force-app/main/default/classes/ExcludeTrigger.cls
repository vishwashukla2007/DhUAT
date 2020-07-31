Public class ExcludeTrigger{ 
@InvocableMethod
public static void SuppressTrigger()
{ 
try
{
 DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
}
catch(DmlException e)
    {
     System.debug(e.getMessage());
    } 
}
                           }