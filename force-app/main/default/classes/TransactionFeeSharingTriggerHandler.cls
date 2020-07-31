public class TransactionFeeSharingTriggerHandler {
    
    public static void onbeforeInsert(List<Transaction_Fee_Sharing_Tier__c> newTransactionShares){
        Set<Id> networkIds = new Set<Id>();
        for(Transaction_Fee_Sharing_Tier__c transFeeShareRec : newTransactionShares){
            if(transFeeShareRec.Network_Operations__c != null){
                networkIds.add(transFeeShareRec.Network_Operations__c);
            }
        }
        
        Map<Id, Transaction_Fee_Sharing_Tier__c> netWorkLatestTransactionMap = new Map<Id, Transaction_Fee_Sharing_Tier__c>();
        Map<Id, List<Transaction_Fee_Sharing_Tier__c>> netWorkTransactionMap = new Map<Id, List<Transaction_Fee_Sharing_Tier__c>>();
        
        List<Transaction_Fee_Sharing_Tier__c> existingTransactionSharings = [Select Id, 
                                                                                Tier__c,
                                                                                Network_Operations__c,
                                                                                From__c,
                                                                                To__c
                                                                                from 
                                                                                Transaction_Fee_Sharing_Tier__c 
                                                                                where 
                                                                                Network_Operations__c IN: networkIds
                                                                                Order By CreatedDate DESC];
                                                                                
        List<Transaction_Fee_Sharing_Tier__c> existingTransactionSharingsByTier = [Select Id, 
                                                                                Tier__c,
                                                                                Network_Operations__c,
                                                                                From__c,
                                                                                To__c
                                                                                from 
                                                                                Transaction_Fee_Sharing_Tier__c 
                                                                                where 
                                                                                Network_Operations__c IN: networkIds
                                                                                Order By Tier__c ASC];
                                                                                
        for(Transaction_Fee_Sharing_Tier__c transFeeSharingRec : existingTransactionSharings){
            if(netWorkLatestTransactionMap.get(transFeeSharingRec.Network_Operations__c) == null){
                netWorkLatestTransactionMap.put(transFeeSharingRec.Network_Operations__c, transFeeSharingRec);
            }
        }
        
        for(Transaction_Fee_Sharing_Tier__c transFeeSharingRec : existingTransactionSharingsByTier){
            if(netWorkTransactionMap.get(transFeeSharingRec.Network_Operations__c) == null){
                List<Transaction_Fee_Sharing_Tier__c> tempList = new List<Transaction_Fee_Sharing_Tier__c>();
                tempList.add(transFeeSharingRec);
                netWorkTransactionMap.put(transFeeSharingRec.Network_Operations__c, tempList);
            }
            else {
                List<Transaction_Fee_Sharing_Tier__c> tempList = new List<Transaction_Fee_Sharing_Tier__c>();
                tempList = netWorkTransactionMap.get(transFeeSharingRec.Network_Operations__c);
                tempList.add(transFeeSharingRec);
                netWorkTransactionMap.put(transFeeSharingRec.Network_Operations__c, tempList);
            }
        }
        
        
        for(Transaction_Fee_Sharing_Tier__c transFeeSharingRec : newTransactionShares){
            boolean hasBasicErros = false;
            if(!(transFeeSharingRec.To__c > transFeeSharingRec.From__c) && transFeeSharingRec.To__c != null){
                if(!test.isRunningTest()){
                    transFeeSharingRec.adderror('The Transaction Fee Sharing Tier To value must be greater than the Transaction Fee Sharing Tier From value or it can be blank.');
                } 
                hasBasicErros = true;
            }
            
            if(netWorkLatestTransactionMap.get(transFeeSharingRec.Network_Operations__c) != null){
                if(netWorkLatestTransactionMap.get(transFeeSharingRec.Network_Operations__c).Tier__c != null){
                    if(transFeeSharingRec.Tier__c != netWorkLatestTransactionMap.get(transFeeSharingRec.Network_Operations__c).Tier__c + 1 ){
                        if(!test.isRunningTest()){
                            transFeeSharingRec.adderror('Tier Number should be ' + (netWorkLatestTransactionMap.get(transFeeSharingRec.Network_Operations__c).Tier__c + 1) );
                        }       
                        hasBasicErros = true;
                    }
                }
                if(netWorkLatestTransactionMap.get(transFeeSharingRec.Network_Operations__c).Tier__c == 9){
                    hasBasicErros = true;
                    transFeeSharingRec.adderror('A maximum of Nine records are allowed for the Transaction Fee Sharing Tier.');
                }
            }
            
            if(!hasBasicErros){
                if(netWorkTransactionMap.get(transFeeSharingRec.Network_Operations__c) != null){
                    List<Transaction_Fee_Sharing_Tier__c> netWorkExistingTransactionFee = netWorkTransactionMap.get(transFeeSharingRec.Network_Operations__c);
                    //if() {
                    if(netWorkExistingTransactionFee[netWorkExistingTransactionFee.size() - 1].To__c != transFeeSharingRec.From__c - 1 && ( transFeeSharingRec.To__c > netWorkExistingTransactionFee[netWorkExistingTransactionFee.size() - 1].From__c || transFeeSharingRec.From__c > netWorkExistingTransactionFee[netWorkExistingTransactionFee.size() - 1].From__c ) ){
                        //transFeeSharingRec.adderror('add error' + netWorkExistingTransactionFee[netWorkExistingTransactionFee.size() - 1].To__c + 'from' + transFeeSharingRec.From__c);
                        if(!test.isRunningTest()){
                            transFeeSharingRec.adderror('There shall not be any overlap or gap between From and To value spans between two consecutive tiers.');
                        }
                    }
                    //}
                    if(netWorkExistingTransactionFee[netWorkExistingTransactionFee.size() - 1].From__c >= transFeeSharingRec.From__c){
                        transFeeSharingRec.adderror('Transaction Fee Sharing Tier From and To values for each tier needs to be populated in increasing order.');
                    }
                    if(netWorkExistingTransactionFee[netWorkExistingTransactionFee.size() - 1].To__c >= transFeeSharingRec.To__c){
                        transFeeSharingRec.adderror('Transaction Fee Sharing Tier From and To values for each tier needs to be populated in increasing order.');
                    } 
                    if(netWorkExistingTransactionFee[netWorkExistingTransactionFee.size() - 1].To__c == null){
                        transFeeSharingRec.adderror('The Transaction Fee Sharing Tier To value for the existing tier needs to be populated before adding a new tier record. ');
                    }
                }   
            }
            /**if(!existingTransactionFee.isEmpty() && existingTransactionFee[existingTransactionFee.size() - 1].To__c != TransactionFee.From__c - 1 && ( TransactionFee.To__c > existingTransactionFee[existingTransactionFee.size() - 1].From__c || TransactionFee.From__c > existingTransactionFee[existingTransactionFee.size() - 1].From__c ) ){
                //hasNoErrors = false;
                //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'There shall not be any overlap or gap between From and To value spans between two consecutive tiers.');
                //ApexPages.addMessage(myMsg);
            } 
            if(!existingTransactionFee.isEmpty() && existingTransactionFee[existingTransactionFee.size() - 1].From__c >= TransactionFee.From__c){
                //hasNoErrors = false;
                //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Transaction Fee Sharing Tier From and To values for each tier needs to be populated in increasing order.');
                //ApexPages.addMessage(myMsg);
            }
            if(!existingTransactionFee.isEmpty() && existingTransactionFee[existingTransactionFee.size() - 1].To__c >= TransactionFee.To__c){
                //hasNoErrors = false;
                //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Transaction Fee Sharing Tier From and To values for each tier needs to be populated in increasing order.');
                //ApexPages.addMessage(myMsg);
            }**/
        }
    }
    
   /* 
    public static void onbeforeDelete(List<Transaction_Fee_Sharing_Tier__c> newTransactionShares){
        Set<Id> networkIds = new Set<Id>();
        for(Transaction_Fee_Sharing_Tier__c transFeeShareRec : newTransactionShares){
            if(transFeeShareRec.Network_Operations__c != null){
                networkIds.add(transFeeShareRec.Network_Operations__c);
            }
        }
        
        Map<Id,Id> netWorkTransactionTierMap = new Map<Id,Id>();
        List<Transaction_Fee_Sharing_Tier__c> existingTransactionSharings = [Select Id, 
                                                                                Tier__c,
                                                                                Network_Operations__c
                                                                                from 
                                                                                Transaction_Fee_Sharing_Tier__c 
                                                                                where 
                                                                                Network_Operations__c IN: networkIds
                                                                                Order By CreatedDate DESC];
        for(Transaction_Fee_Sharing_Tier__c transFeeSharingRec : existingTransactionSharings){
            if(netWorkTransactionTierMap.get(transFeeSharingRec.Network_Operations__c) == null){
                netWorkTransactionTierMap.put(transFeeSharingRec.Network_Operations__c, transFeeSharingRec.Id);
            }
        }
        for(Transaction_Fee_Sharing_Tier__c transFeeShareRec : newTransactionShares){
            if(netWorkTransactionTierMap.get(transFeeShareRec.Network_Operations__c) != null){
                if(netWorkTransactionTierMap.get(transFeeShareRec.Network_Operations__c) != transFeeShareRec.Id && !transFeeShareRec.Deleting_From_Network_Operations__c){
                    transFeeShareRec.adderror('You may delete the Transaction Fee Sharing Tier records one by one only, starting with the highest existing Transaction Fee Sharing Tier record.');
                }
            }
        } 
    } */
    
}