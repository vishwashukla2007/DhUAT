/**********************************************

*	Class: 				NewFeeServicePage_Cntrlr.apxc
*	Objective: 			Helper will provide the required methods to save FeeService
*	Test Class:  		NewFeeServicePage_Cntrlr_Test.apxc
*	Developer: 			

**********************************************/ 

public class NewFeeServicePage_Cntrlr {
    
    public boolean isInsrtd{get; set;}
    Public String currentRecordId {get;set;}
    public String fafName {get; set;}
    public String fafId {get; set;}
    public String fsId {get; set;}
    public boolean validErr{get; set;}
    public boolean rdsShow{get; set;}
    public Fee_Services__c fs{get; set;}
    private final ApexPages.StandardController cntrlr;
    
    public NewFeeServicePage_Cntrlr(ApexPages.StandardController stdCntrlr){
        
        //fsId = stdCntrlr.getId();
        
        this.cntrlr = stdCntrlr;
        this.fs = (Fee_Services__c)stdCntrlr.getRecord();
        this.rdsShow = false;
        
        if(fs != null && fs.id != null){
            fsId = fs.Id;
            fs = [select Id,FAF_ID__c,FAF_ID__r.LOB2__c,Retiree_Drug_Subsidy__c,Additional_Fee_Service_Information__c,Name from Fee_Services__c where id=:  fsId ];
        }else{
            
            string FAFId = ApexPages.currentPage().getParameters().get(Label.FAF_Object_Id);
            system.debug('Hi'+FAFId);
            if(string.isNotBlank(FAFId)){
                Central_Hub__c fafObj = [select id,LOB2__c from Central_Hub__c where id=:FAFId];
                system.debug('fafObj.LOB2__c---->'+fafObj.LOB2__c);
                if(fafObj.LOB2__c == 'STD'){
                    this.rdsShow = true;
                }                
            }
        }
        
        //String fafId = ApexPages.CurrentPage().getparameters().get('CF00N2v00000YCwAx_lkid');
        fafId = fs.FAF_ID__c;
        system.debug('fs.FAF_ID__c---->'+ApexPages.CurrentPage().getparameters().get('CF00N2v00000YCwAx_lkid'));
        system.debug('fs.FAF_ID__r.LOB2__c---->'+fs.FAF_ID__r.LOB2__c);
        system.debug('rdsShow---->'+rdsShow);
        
        if(fs != null && fs.FAF_ID__c != null)
            fafName = [select id,name from Central_Hub__c where id=: fs.FAF_ID__c].Name;
        
        
        isInsrtd = false;
        validErr = false;
    }
    
    public PageReference saveFeeService(){
        try{
            String dupFsId = '';
            PageReference pg;
            System.debug('FS :'+fs);
            List<Fee_Services__c> dupFs_ls = new List<Fee_Services__c>(); 
            
            if(fsId != null)  
                dupFs_ls  =  [Select Id,FAF_ID__c from Fee_Services__c where FAF_ID__c =: fafId and id !=: fsId limit 1];
            else
                dupFs_ls  =  [Select Id,FAF_ID__c from Fee_Services__c where FAF_ID__c =: fafId limit 1];
            
            if(dupFs_ls != null && dupFs_ls.size() >0)
                dupFsId =  dupFs_ls[0].Id;
            
            if(dupFsId != ''){
                validErr =  true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error :: FAF can only contain one Fee Services record'));
                return null;
            }else if(fs.id == null){
                insert fs;
                // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Success :: Fee Services created successfully'));
                isInsrtd = true;
                pg= new PageReference('/' + fs.Id);
            }else if(fs.id != null || fsId != null){
                update fs;
                pg= new PageReference('/' + fs.Id);
            }
            
            
            
            if(fafName != '' && fafName != null)
                pg= new PageReference('/' + fs.Id);
            
            if(fs.Id != null)
                return pg.setRedirect(true);
            else
                return null;
            
            
        }catch(Exception e){
            System.debug(e.getStackTraceString());
            System.debug(e.getCause());
            System.debug(e.getLineNumber());
            System.debug(e.getMessage());
            System.debug(e.getTypeName());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to create Fee Services.'));
        }
        return null;
    }
    
    
    public PageReference redirectToRequiredPage(){
        
        PageReference pg = new PageReference('/' + fafId);
        if(fs.Id != null)
            return pg.setRedirect(true);
        else
            return null;
    }
    
}