public with sharing class ClinicalOperationsNewEditClass{ 
    public Clinical_Operations__c clinicalOpr{get;set;}
    public Id clinicalOprId;
    Public Boolean showerrorBool{get;set;}
    Public Boolean typeFlag{get;set;}
    Public Boolean basisFlag{get;set;}   
    Public Boolean percentageFlagDisable{get;set;} 
    Public Boolean percentageReq{get;set;}
    Public Boolean amountFlagDisable{get;set;} 
    Public Boolean amountReq{get;set;}      
    Public string clientSavingsTrue{get;set;} 
    
    public ClinicalOperationsNewEditClass(ApexPages.StandardController controller) {
        showerrorBool = false;
        clientSavingsTrue = 'false';
        typeFlag = false;
        basisFlag = false;
        percentageFlagDisable = false; 
        percentageReq = False;
        amountFlagDisable = false; 
        amountReq = False;
        clinicalOprId= ApexPages.currentPage().getParameters().get('id');
        
        Id fafIdId = ApexPages.currentPage().getParameters().get(Label.ClinicalOperationLabel);
        system.debug('--clinicalOprId---'+clinicalOprId);
        system.debug('--fafIdId---'+fafIdId);
        clinicalOpr = new Clinical_Operations__c();
       
        if(clinicalOprId == null){ 
            if(fafIdId != null){
                clinicalOpr.FAF_Id__c = fafIdId;
                List<Clinical_Operations__c> clinicalOpr = new List<Clinical_Operations__c>();
                clinicalOpr = [select id from Clinical_Operations__c where Faf_Id__c=:fafIdId];
                if(clinicalOpr.size()>0){
                    showerrorBool = true;
                }else{
                        showerrorBool = False;
                        clientSavingsTrue = 'false';                                              
                      }  
            }
           
        }else{
                showerrorBool = false;
                clinicalOpr = [select id, FAF_ID__c,CSG_Amount__c,
                CSG_Basis__c,CSG_Percentage__c,CSG_Type__c,Link__c,Client_Savings__c ,Additional_Clinical_Information__c 
                from Clinical_Operations__c where id=: clinicalOprId ];
                clientSavingsTrue = clinicalOpr.Client_Savings__c; 
                if(clientSavingsTrue == 'Yes'){
                            typeFlag = true;
                            basisFlag = true;
                            system.debug(+clientSavingsTrue);
                            }else{
                                    typeFlag = false;
                                    basisFlag = false;
                                    percentageReq = False;
                                    amountReq = False;
                                    clientSavingsTrue = 'false';
                 }
                 
                 if(clinicalOpr.CSG_Basis__c == 'Percentage' ){
                     percentageFlagDisable = False; 
                     percentageReq = true;
                    }else{
                            percentageFlagDisable = True; 
                            percentageReq = False;
                         }
                 if(clinicalOpr.CSG_Basis__c == 'Flat Dollar' ){
                     amountFlagDisable = false; 
                     amountReq = true;
                    }else{
                            amountFlagDisable = true; 
                            amountReq = False;
                         } 
             }
    } 
    
     public pagereference saveUpdateCO(){
        try{
            pagereference pr;
             if(clinicalOpr.Client_Savings__c == 'yes'){
                 
                 if(clinicalOpr.CSG_Basis__c == 'Flat Dollar'){
                      clinicalOpr.CSG_Percentage__c = null;
                   }
                   
                 if(clinicalOpr.CSG_Basis__c == 'Percentage'){
                       clinicalOpr.CSG_Amount__c = null;
                       
                   }  
                   
                   
               }else{
                         clinicalOpr.CSG_Amount__c = null;
                         clinicalOpr.CSG_Percentage__c = null;
                    }
             if(clinicalOprId == null){
                insert clinicalOpr;
                pr = new pagereference('/' + clinicalOpr.id);
                }else{
                    update clinicalOpr;
                    pr = new pagereference('/' + clinicalOpr.id);
                }
             return pr;   
           }catch(Exception excp){
                    ApexPages.addMessages(excp);
                    return null;
                  }
     }   
     
      public void checkMandatory(){
        
        String savingTrue = Apexpages.currentPage().getParameters().get('param1');
                
        if(savingTrue == 'Yes' ){
            typeFlag = true;
            basisFlag = true;
            clientSavingsTrue = 'true';
            percentageFlagDisable = true; 
            amountFlagDisable = true; 
            }else{
                    typeFlag = false;
                    basisFlag = false;
                    clientSavingsTrue = 'false'; 
                    percentageReq = False;
                    percentageFlagDisable = False; 
                    amountFlagDisable = false; 
                    amountReq = False;
                 }    
                 system.debug('----'+clientSavingsTrue);  
    }
    
    public void checkPercentageFlag(){
        
        String basisValue = Apexpages.currentPage().getParameters().get('param2');
                
        if(basisValue == 'Percentage' ){
             percentageFlagDisable = False; 
             percentageReq = true;
            }else{
                    percentageFlagDisable = True; 
                    percentageReq = False;
                 }
         if(basisValue == 'Flat Dollar' ){
             amountFlagDisable = false; 
             amountReq = true;
            }else{
                    amountFlagDisable = true; 
                    amountReq = False;
                 }         
                    
          system.debug('--basisValue--'+basisValue);       
                   
    }
    
     
}