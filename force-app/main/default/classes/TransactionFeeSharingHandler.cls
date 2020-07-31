public class TransactionFeeSharingHandler {
    
      Public boolean showErrorMessage{get; set;}
      Public string recordId{get; set;}
      public TransactionFeeSharingHandler(ApexPages.StandardController stdController){
          showErrorMessage = false;
          recordId = ApexPages.Currentpage().getParameters().get('id');
       }
      public pageReference deleteRecord(){
         try{
            System.debug('************');
            Transaction_Fee_Sharing_Tier__c transFeeShareRec = [Select id, Deleting_From_Network_Operations__c, Network_Operations__c from Transaction_Fee_Sharing_Tier__c where Id =: recordId];
            Id networkId = transFeeShareRec.Network_Operations__c;
            
            System.debug(transFeeShareRec+'************'+networkId);
            Map<Id,Id> netWorkTransactionTierMap = new Map<Id,Id>();
        List<Transaction_Fee_Sharing_Tier__c> existingTransactionSharings = [Select Id, 
                                                                                Tier__c,
                                                                                Network_Operations__c
                                                                                from 
                                                                                Transaction_Fee_Sharing_Tier__c 
                                                                                where 
                                                                                Network_Operations__c =: transFeeShareRec.Network_Operations__c
                                                                                Order By Tier__c DESC];
        for(Transaction_Fee_Sharing_Tier__c transFeeSharingRec : existingTransactionSharings){
            if(netWorkTransactionTierMap.get(transFeeSharingRec.Network_Operations__c) == null){
                netWorkTransactionTierMap.put(transFeeSharingRec.Network_Operations__c, transFeeSharingRec.Id);
            }
        }
        
        if(netWorkTransactionTierMap.get(transFeeShareRec.Network_Operations__c) != null){
            if(netWorkTransactionTierMap.get(transFeeShareRec.Network_Operations__c) != transFeeShareRec.Id && !transFeeShareRec.Deleting_From_Network_Operations__c){
                 showErrorMessage = true;
                 System.debug('Condition 1'+showErrorMessage);
                 //return new PageReference(‘/apex/TransactionOnDeletePage’);
            }
            else{
                    System.debug('Condition 2');
                    showErrorMessage = false;
                    delete transFeeShareRec;
                    PageReference pageRef = new PageReference('/'+networkId);
                    pageRef.setRedirect(true);
                    return pageRef;
                //return new PageReference(‘/’+transFeeShareRec.Network_Operations__c);
            }    
        }
        
        
    }
      catch(Exception exp){
             ApexPages.addMessages(exp); 
             return null;
        }
      return null;
   }
}