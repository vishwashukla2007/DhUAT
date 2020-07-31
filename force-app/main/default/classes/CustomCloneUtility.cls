/* =================================================================================
 * @Class Name        : CustomCloneUtility
 * @author            : Mohit Srivastava(Accenture)
 * @created date      : 09/10/2018
 * @Purpose           : Deep Clone functionality
=======================================================================================*/
public without sharing class CustomCloneUtility{

    
    
    /* =================================================================================
    * @Method Name       : customCloneMethod
    * @author            : Mohit Srivastava(Accenture)
    * @created date      : 10/09/2018
    * @Purpose           : Deep Clone functionality
    =======================================================================================*/
    public static sobject customCloneMethod(Sobject sobj) {
        SObject cloneSObj;
        cloneSObj= sobj.clone(false, true);
        //insert cloneSObj;
        return cloneSObj;
    }
    
}