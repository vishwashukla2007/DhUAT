public with sharing class ClinicalSolutionNewEditClass{ 
    public Clinical_Solutions__c clinicalSol{get;set;}
    public Clinical_Operations__c clinicalOpr{get;set;}
    public Id clinicalSolId;
    public Id clinicalOprId;
    Public Boolean showerrorBool{get;set;}
    Public Boolean roiMetricFlag{get;set;} 
    Public Boolean amountFlagDisable{get;set;} 
    Public Boolean amountReq{get;set;}     
    Public Boolean percentageFlagDisable{get;set;} 
    Public Boolean percentageReq{get;set;}
    Public Boolean clientSavingsTrue{get;set;}    
    Public Boolean sosFlag{get;set;}
    Public Boolean sosreqFlag{get;set;}  
    Public Boolean guaranteeFlag{get;set;}   
    Public Boolean reconTypeFlag{get;set;}    
    Public Boolean reconTimeframeFlag{get;set;}
    Public Boolean reconLevelFlag{get;set;}
    Public Boolean optInOutFlag{get;set;} 
    Public String feeBasisValue{get;set;}
    Public Boolean feeAmtFlag{get;set;}
    public list<SelectOption> yearOptions {get;set;}  
    public String operationType;// custom clone functionality
    public String CLONE='clone';// custom clone functionality
    
    public ClinicalSolutionNewEditClass(ApexPages.StandardController controller) {
        operationType=ApexPages.currentPage().getParameters().get('type'); //for the clone 
        showerrorBool = false;
        roiMetricFlag = false;
        percentageFlagDisable = false; 
        percentageReq = False;
        amountFlagDisable = false; 
        amountReq = False;
        sosFlag = False;
        sosreqFlag = false;
        feeAmtFlag = true;
        clientSavingsTrue = false;
        reconTypeFlag = False;
        reconTimeframeFlag = false;
        reconLevelFlag =false;
        guaranteeFlag = false;
        optInOutFlag = false;
        clinicalSolId= ApexPages.currentPage().getParameters().get('id');
        
        clinicalOprId = ApexPages.currentPage().getParameters().get(Label.ClinicalSolutionLabel);
        
        clinicalSol = new Clinical_Solutions__c();
        
        
        
        if(clinicalSolId == null){ 
            if(clinicalOprId != null){
                clinicalOpr = [select id,FAF_ID__c from Clinical_Operations__c where id =: clinicalOprId];
                clinicalSol.Clinical_Operations__c = clinicalOprId;
                clinicalSol.FAF_ID__c = clinicalOpr.FAF_ID__c;
                
            }
            
        }else{
            //showerrorBool = false;
            clinicalSol = [select Additional_Info__c,PBM_Services__c,PBM_Services__r.Max_Amount__c,Service_Effective_Date__c,Clinical_Solution2__c,Fee_Basis2__c,Clinical_Operations__r.FAF_ID__c,Client_Share__c,Clinical_Operations__c,
                           Clinical_Solution_Type__c,Clinical_Solution__c,Contingent__c,CreatedById,CreatedDate,CSG_Amount__c,CSG_Basis__c,
                           CSG_Percentage__c,Sync_Source__c,CSG_Type__c,CVS_Share__c,FAF_ID__c,Fee_Amount__c,Fee_Basis__c,Id,
                           Included_In_Client_Savings_Guarantee__c,Link__c,Name,Opt_In_Out__c,Guarantee__c,Recon_Level__c,Recon_Timeframe__c,
                           Recon_Type__c,RecordTypeId,ROI_Amount__c,ROI_Metric__c,ROI_Percentage__c,SOS__c,Year__c from Clinical_Solutions__c where id=: clinicalSolId ];
            
            feeBasisValue = clinicalSol.Fee_Basis__c;
            feeBasisValueAction();
            if(clinicalSol.SOS__c == true ){
                sosFlag = True;
                sosreqFlag = true ;
            }else{
                sosFlag = false;
                sosreqFlag = false;
            }
            
            if(clinicalSol.Clinical_Solution__c!= null && clinicalSol.Clinical_Solution__c.contains('Accordant')){
                optInOutFlag = true;
            }
            
            
            else{
                roiMetricFlag = False;
                percentageFlagDisable = false; 
                percentageReq = False;
                amountFlagDisable = false; 
                amountReq = False;
            }
            
            if(clinicalSol.Guarantee__c == 'Yes') {
                guaranteeFlag = true;
                reconTypeFlag = true;
                reconTimeframeFlag = true;
                reconLevelFlag =true;
            }else{
                guaranteeFlag = false;
                reconTypeFlag = false;
                reconTimeframeFlag = false;
                reconLevelFlag =false;
            } 
            
            if(clinicalSol.ROI_Metric__c == 'Percentage' ){
                percentageFlagDisable = False; 
                percentageReq = true;
            }else{
                percentageFlagDisable = True; 
                percentageReq = False;
            }
            
            if(clinicalSol.ROI_Metric__c == 'Flat Dollar' ){
                amountFlagDisable = false; 
                amountReq = true;
            }else{
                amountFlagDisable = true; 
                amountReq = False;
            }
            if(clinicalSol.ROI_Metric__c == 'Percentage' || clinicalSol.ROI_Metric__c == 'Flat Dollar' )   {
                clientSavingsTrue = true;
            }else{
                clientSavingsTrue = false;
            }                       
        }
        if(String.IsBlank(clinicalSolId)){
            yearOptions = new list<SelectOption>();
            string[] selectedYears = new string[]{};
                for( Client_Information__c cif : [SELECT Year_1__c, 
                                                  Year_2__c, 
                                                  Year_3__c, 
                                                  Year_4__c, 
                                                  Year_5__c 
                                                  FROM Client_Information__c
                                                  WHERE FAF_ID__c = : clinicalSol.FAF_ID__c LIMIT 1] ){
                                                      system.debug('---cif '+cif );                                    
                                                      for( string fld : new list<string>{ 'Year_1__c', 'Year_2__c', 'Year_3__c', 'Year_4__c', 'Year_5__c' })
                                                      {
                                                          if( cif.get(fld) <> null )
                                                          {
                                                              selectedYears.add(cif.get(fld)+'');
                                                          }
                                                      }                                    
                                                  } 
            
            if( selectedYears.isEmpty() )//if escalating price is null
            {
                yearOptions.add(new SelectOption('All','All'));
            }
            else
            {
                yearOptions.add(new SelectOption('','--None--'));// if escalating price have years 
                for( string str:selectedYears )   
                {
                    yearOptions.add(new SelectOption(str,str));
                }
                yearOptions.add(new SelectOption('All','All'));
            }                                       
        } else{    
            yearOptions = new list<SelectOption>();
            string[] selectedYears = new string[]{};
                for( Client_Information__c cif : [SELECT Year_1__c, 
                                                  Year_2__c, 
                                                  Year_3__c, 
                                                  Year_4__c, 
                                                  Year_5__c 
                                                  FROM Client_Information__c
                                                  WHERE FAF_ID__c = : clinicalSol.FAF_ID__c LIMIT 1] ){
                                                      system.debug('---cif '+cif );                                    
                                                      for( string fld : new list<string>{ 'Year_1__c', 'Year_2__c', 'Year_3__c', 'Year_4__c', 'Year_5__c' })
                                                      {
                                                          if( cif.get(fld) <> null )
                                                          {
                                                              selectedYears.add(cif.get(fld)+'');
                                                          }
                                                      }                                    
                                                  } 
            
            if( selectedYears.isEmpty() )//if escalating price is null
            {
                yearOptions.add(new SelectOption('All','All'));
            }
            else
            {
                for( string str:selectedYears )   
                {
                    yearOptions.add(new SelectOption(str,str));
                }
                yearOptions.add(new SelectOption('All','All'));
            } 
            
        }               
    } 
    public void feeBasisValueAction(){
        if(feeBasisValue == 'See Base Admin Fee' || feeBasisValue == 'See Notes for Fee' || feeBasisValue == 'No Charge' || feeBasisValue == 'Fee Waived' || feeBasisValue == 'Included In Admin Fee'){
            feeAmtFlag = false;
        }else{
            feeAmtFlag = true;
        }
        
    }
    
    public pagereference saveUpdateCS(){
        try{
            pagereference pr;
            if(operationType==CLONE){
                SObject cloneSObj;
                cloneSObj=CustomCloneUtility.customCloneMethod(clinicalSol);
                insert cloneSObj;
                pr = new pagereference(ConstantsUtil.FORWARD_SlASH +cloneSObj.id);
            }
            else{
                if(clinicalSolId == null){
                    List<Clinical_Solutions__c> clinicalSolList = new List<Clinical_Solutions__c>();
                    if(string.isBlank(clinicalSol.PBM_Services__c))
                    {
                        clinicalSolList = [select id,Clinical_Solution_Type__c,Alert_Message__c,Year__c,Clinical_Solution__c  from Clinical_Solutions__c where Clinical_Operations__c=:clinicalOprId and Clinical_Solution__c =: clinicalSol.Clinical_Solution__c and Year__c = :clinicalSol.Year__c and Clinical_Solution_Type__c =: clinicalSol.Clinical_Solution_Type__c];
                    }else{
                        clinicalSolList = [select id,Clinical_Solution_Type__c,PBM_Services__r.Max_Amount__c,Alert_Message__c,Year__c,Clinical_Solution__c  from Clinical_Solutions__c where Clinical_Operations__c=:clinicalOprId and Clinical_Solution2__c =: clinicalSol.Clinical_Solution2__c and Year__c = :clinicalSol.Year__c and Clinical_Solution_Type__c =: clinicalSol.Clinical_Solution_Type__c];  
                    }
                    
                    
                    if(clinicalSolList.size()>0){
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.error, 'Clinical Solutions record already exists for Clinical Solution Type, Year, and Clinical Solution specified'));
                        Return null;
                    }else{
                        //                             if(clinicalSol.Alert_Message__c !=''){
                        //                                 Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.error,clinicalSol.Alert_Message__c));
                        //                                 Return null;
                        //                             }
                        if(clinicalSol.Fee_Amount__c == null && (clinicalSol.Fee_Basis__c == 'No Charge' || clinicalSol.Fee_Basis__c == 'Fee Waived'))
                        {
                            clinicalSol.Fee_Amount__c = 0;
                        }
                        List<Fee_Service_Template__c> feetempLst =[select id,Max_Amount__c from Fee_Service_Template__c where Active__c = true AND FAF_Component__c = 'Clinical OPS.Clinical Solutions' AND FAF_Component_Type__c =: clinicalSol.Clinical_Solution_Type__c AND Item__c =: clinicalSol.Clinical_Solution__c];
                        If(feetempLst.size()>0){
                            if(feetempLst[0].Max_Amount__c < clinicalSol.Fee_Amount__c)
                            {
                                Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.error, 'Fee Amount must be between $0.00 and $'+feetempLst[0].Max_Amount__c));
                                Return null;                                
                            }
                        }
                        insert clinicalSol;                             
                        pr = new pagereference('/' + clinicalSol.id);                             
                    }
                    
                }else{
                    system.debug('----clinicalSol-----'+clinicalSol);
                    system.debug('----clinicalOprId-----'+clinicalOprId);
                    List<Clinical_Solutions__c> clinicalSolList = new List<Clinical_Solutions__c>();
                    if(string.isBlank(clinicalSol.PBM_Services__c))
                    {
                        clinicalSolList = [select id,Clinical_Solution_Type__c,Year__c,Clinical_Solution__c  from Clinical_Solutions__c where id!=:clinicalSol.id and Clinical_Operations__c=:clinicalSol.Clinical_Operations__c and Clinical_Solution__c =: clinicalSol.Clinical_Solution__c and Year__c = :clinicalSol.Year__c and Clinical_Solution_Type__c =: clinicalSol.Clinical_Solution_Type__c];
                    }else{
                        clinicalSolList = [select id,Clinical_Solution_Type__c,Year__c,PBM_Services__r.Max_Amount__c,Clinical_Solution__c  from Clinical_Solutions__c where id!=:clinicalSol.id and Clinical_Operations__c=:clinicalSol.Clinical_Operations__c and Clinical_Solution2__c =: clinicalSol.Clinical_Solution2__c and Year__c = :clinicalSol.Year__c and Clinical_Solution_Type__c =: clinicalSol.Clinical_Solution_Type__c];
                        clinicalSol.Sync_Source__c ='Target';
                    }
                    clinicalSol.Sync_Source__c ='Target';
                    system.debug('----clinicalSolList-----'+clinicalSolList);
                    if(clinicalSolList.size()>0){
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.error, 'Clinical Solutions record already exists for Clinical Solution Type, Year, and Clinical Solution specified'));
                        Return null;
                    }else{
                        if(clinicalSol.Fee_Amount__c == null && (clinicalSol.Fee_Basis__c == 'No Charge' || clinicalSol.Fee_Basis__c == 'Fee Waived'))
                        {
                            clinicalSol.Fee_Amount__c = 0;
                        }
                        List<Fee_Service_Template__c> feetempLst =[select id,Max_Amount__c from Fee_Service_Template__c where Active__c = true AND FAF_Component__c = 'Clinical OPS.Clinical Solutions' AND FAF_Component_Type__c =: clinicalSol.Clinical_Solution_Type__c AND Item__c =: clinicalSol.Clinical_Solution__c];
                        If(feetempLst.size()>0){
                            if(feetempLst[0].Max_Amount__c < clinicalSol.Fee_Amount__c)
                            {
                                Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.error, 'Fee Amount must be between $0.00 and $'+feetempLst[0].Max_Amount__c));
                                Return null;                                
                            }
                        }
                        update clinicalSol;
                        pr = new pagereference('/' + clinicalSol.id);
                    }
                    
                }
            }
            return pr;   
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
    }   
    
    public void roiMetricFlagCheck(){ 
        
        String savingTrue = Apexpages.currentPage().getParameters().get('param1');
        
        if(savingTrue == 'Yes' ){
            roiMetricFlag = True;  
            clientSavingsTrue = true; 
            amountFlagDisable = true;  
            amountReq = False;   
            percentageReq = False;
            percentageFlagDisable = true;   
        }else{
            roiMetricFlag = False;  
            clientSavingsTrue = false;  
            amountFlagDisable = true; 
            amountReq = False;   
            percentageFlagDisable = true; 
            percentageReq = False;
        }    
        system.debug('--roiMetricFlag --'+roiMetricFlag );                 
        
    }
    
    public void sosFlagCheck(){ 
        
        String sos = Apexpages.currentPage().getParameters().get('param3');
        
        if(sos == 'True' ){
            clinicalSol.SOS__c = True;
            sosFlag = True;
            sosreqFlag = True;   
        }else{
            clinicalSol.SOS__c = False;    
            sosFlag = False;
            sosreqFlag = false;    
        }    
        system.debug('--sos --'+sos );                 
        
    }
    
    public void guaranteeCheck(){ 
        
        String gurantee = Apexpages.currentPage().getParameters().get('param4');
        
        if(gurantee == 'Yes') {
            guaranteeFlag = true;
            reconTypeFlag = true;
            reconTimeframeFlag = true;
            reconLevelFlag =true;
        }else{
            guaranteeFlag = false;
            reconTypeFlag = false;
            reconTimeframeFlag = false;
            reconLevelFlag =false;
        }  
        system.debug('--gurantee--'+gurantee);                 
        
    }
    
    
    
    public void solutionCheckOptIn(){ 
        string solution = Apexpages.currentPage().getParameters().get('param6');
        if(solution.contains('Accordant')){
            optInOutFlag = true;
        } else{
            optInOutFlag = false;
        }           
        system.debug('--solution--'+solution);
        system.debug('--optInOutFlag --'+optInOutFlag );  
    }
    
    public void amountPercetageCheck(){
        
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
        if(basisValue == 'Percentage' || basisValue == 'Flat Dollar' )   {
            clientSavingsTrue = true;
        }else{
            clientSavingsTrue = false;
        }        
        system.debug('--basisValue--'+basisValue);    
        
    }     
}