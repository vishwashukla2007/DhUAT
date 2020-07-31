trigger Check_Delete on PBM_Services__c (Before Delete) {
    if (Trigger.isBefore == true && Trigger.isDelete == true) {
        for (PBM_Services__c a: Trigger.old) {
            if (a.Additional_Service__c == False )  
                a.addError('Only Additional Services can be deleted');         
        }
    }
}