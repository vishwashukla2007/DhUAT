public class NewBillingOtherFeesController {
    
    public Billing_Other_Fees__c bof {get;set;}
    public boolean flag{get;set;}
    public String operationType;
    
    public NewBillingOtherFeesController(ApexPages.StandardController stdCntrlr){
        
        Id bofId = ApexPages.currentPage().getParameters().get('id');
        operationType=ApexPages.currentPage().getParameters().get('type'); //for the clone
        
        if(bofId != null){
            bof = (Billing_Other_Fees__c)stdCntrlr.getRecord();
            bof = [SELECT Id,Name,Billing_Operations__c FROM Billing_Other_Fees__c WHERE Id = :bofId ];
            Billing_Operations__c bo = [SELECT Id,Name,FAF_ID__c FROM Billing_Operations__c WHERE Id =: bof.Billing_Operations__c];
            bof.FAF__c = bo.FAF_ID__c;
            
            bof = [SELECT Id,Name,LOB__c,Year__c,Other_Fee_Type__c,Basis2__c,Basis__c,PBM_Services__c,Service_Effective_Date__c
                   ,Paid_amount__c,Sync_Source__c,Other_Fee_Description__c,Billing_Operations__c,FAF__c,Fee_Amount__c
                   FROM Billing_Other_Fees__c WHERE Id =: bofId];
            hidePaidAmount();
            
        }
        if (bofId == null) {
            bof = (Billing_Other_Fees__c)stdCntrlr.getRecord();
            if(bof.Billing_Operations__c == null)
                bof.Billing_Operations__c = ApexPages.currentPage().getParameters().get(Label.Billing_Other_Fee);
            Billing_Operations__c bo = [SELECT Id,Name,FAF_ID__c FROM Billing_Operations__c WHERE Id =: bof.Billing_Operations__c]; 
            bof.FAF__c = bo.FAF_ID__c;       
        }
    }
    
    
    public PageReference saveBillingOtherFee(){
        try{
            List<Billing_Other_Fees__c> tmpBof = new List<Billing_Other_Fees__c>();
            PageReference pr ;
            
            if(operationType=='Clone'){
                Billing_Other_Fees__c cloneSObj;
                cloneSObj=(Billing_Other_Fees__c)CustomCloneUtility.customCloneMethod(bof);
                tmpBof = [SELECT Id,Name FROM Billing_Other_Fees__c 
                          WHERE Year__c =: bof.Year__c AND LOB__c =: bof.LOB__c AND Billing_Operations__c =: bof.Billing_Operations__c AND
                          Other_Fee_Description__c =: bof.Other_Fee_Description__c AND Other_Fee_Type__c =: bof.Other_Fee_Type__c AND Id !=: cloneSObj.Id];
                if(cloneSObj.Fee_Amount__c < 0){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: Fee Amount must be >= $0.00'));
                    return null;
                }
                if((cloneSObj.Paid_Amount__c < 0 || cloneSObj.Paid_Amount__c == null) && cloneSObj.Other_Fee_Description__c.contains('PSM')){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: Paid Amount is required.'));
                    return null;
                }
                
                if(tmpBof.size() >0){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: Record already exists for Year, LOB, Other Fee Type, Other Fee Description and Fee Basis combination specified. Please enter a unique combination'));
                    return null;
                }
                else{
                    insert cloneSObj;
                    pr = new pagereference(ConstantsUtil.FORWARD_SlASH +cloneSObj.id);
                    return pr;
                }
            }
            else{
                tmpBof = [SELECT Id,Name FROM Billing_Other_Fees__c 
                          WHERE Year__c =: bof.Year__c AND LOB__c =: bof.LOB__c AND Billing_Operations__c =: bof.Billing_Operations__c AND
                          //Other_Fee_Description__c =: bof.Other_Fee_Description__c AND Other_Fee_Type__c =: bof.Other_Fee_Type__c AND Id !=: bof.Id];
                          Other_Fee_Description__c =: bof.Other_Fee_Description__c AND Other_Fee_Type__c =: bof.Other_Fee_Type__c AND Basis__c =: bof.Basis__c AND Id !=: bof.Id];
                if(bof.Fee_Amount__c < 0){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: Fee Amount must be >= $0.00'));
                    return null;
                }
                if((bof.Paid_Amount__c < 0 || bof.Paid_Amount__c == null) && bof.Other_Fee_Description__c.contains('PSM')){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: Paid Amount is required.' ));
                    return null;
                }
                if(tmpBof.size() >0){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: Record already exists for Year, LOB, Other Fee Type, Other Fee Description and Fee Basis combination specified. Please enter a unique combination'));
                    return null;
                }
                else {
                    List<Fee_Service_Template__c> feetempLst =[select id,Max_Amount__c from Fee_Service_Template__c where Active__c = true AND FAF_Component__c = 'Billing Ops.Other Fees' AND FAF_Component_Type__c =: bof.Other_Fee_Type__c];
                    If(feetempLst.size()>0){
                        if(feetempLst[0].Max_Amount__c < bof.Fee_Amount__c)
                        {
                            Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.error, 'Fee Amount must be between $0.00 and $'+feetempLst[0].Max_Amount__c));
                            Return null;                                
                        }
                    }
                    bof.Sync_Source__c ='Target';
                    upsert bof;
                }
            }
            pr = new PageReference('/' + bof.id);
            return pr;
        }catch(exception e){
            //e.getMessage();
            ApexPages.addMessages(e);
            return null;
        }  
    }
    
    Public void hidePaidAmount(){
        system.debug('hiiii');
        flag = bof.Other_Fee_Description__c.contains('PSM') ?true:false;
        if(!bof.Other_Fee_Description__c.contains('PSM'))bof.Paid_Amount__c = null;
    }
}