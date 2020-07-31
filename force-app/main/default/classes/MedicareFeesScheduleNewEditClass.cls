/*********************************************************************************************
* @author   Abhishek Tiwari(Accenture)
* @Created Date     07 09 2018
* @description:This is the controller class for MedicareFeesScheduleNewEditPage
**********************************************************************************************/

public with sharing class MedicareFeesScheduleNewEditClass{ 
    public Medicare_Part_D_Fees_Schedule__c medFeeSchedObj{get;set;}//Define the object for record Insert and Update
    public Id medicareScheduleFeeId; //for store the recoed Id
    public String operationType;//clone page variable
    public boolean showTextBool{get;set;}
    public boolean PMPMFeeRequired{get;set;}
    public boolean FeeDescRequired{get;set;}
    
    //Constructor for MedicareFeesScheduleNewEditClass class
    public MedicareFeesScheduleNewEditClass(ApexPages.StandardController controller) {
        medicareScheduleFeeId = ApexPages.currentPage().getParameters().get('id'); //Get the id of the current record from URL
        Id billingOprId = ApexPages.currentPage().getParameters().get(Label.medicareScheduleFeeLable); //Get the id of the Parent record from URL
        medFeeSchedObj = new Medicare_Part_D_Fees_Schedule__c();
        operationType=ApexPages.currentPage().getParameters().get('type'); //for the clone
        if(operationType=='Clone'){
            showTextBool=true;
        }else{
            showTextBool=false;
        }
        FeeDescRequired=true; 
        //Check id is blank to identify we are creating a record or updating
        if(medicareScheduleFeeId == null){
            if(billingOprId != null){
                
                //Fetching the info from parent Object(Billing Operation)
                Billing_Operations__c billingOprObj = [select id, FAF_Id__c, FAF_Id__r.LOB2__c  from Billing_Operations__c 
                                                       where id =: billingOprId limit 1];
                medFeeSchedObj.FAF_Id__c = billingOprObj.FAF_Id__c; //Assign FAF Id
                medFeeSchedObj.Billing_Operations__c = billingOprObj.id; //Assign billing Operation Id
                
                //check PMPM fee flag
                PMPMFeeRequired=(billingOprObj.FAF_Id__c!=null && billingOprObj.FAF_Id__r.LOB2__c!=null && billingOprObj.FAF_Id__r.LOB2__c!='WRAP' )?true:false;
                
            }
        }else{  // This condition will execute when we Edit a Medicare Part D record
            medFeeSchedObj = [select id, name, Sync_Source__c,FAF_ID__c,Service_Effective_Date__c,Retiree_Drug_Subsidy__c,Basis2__c,FAF_Id__r.LOB2__c, Billing_Operations__c, Year__c, Effective__c,
                              Type__c, PMPM_Fee__c, PATH__c, Additional_Information__c, Fee_Description__c, Basis__c, Billing_Operations__r.FAF_Id__r.LOB2__c
                              from Medicare_Part_D_Fees_Schedule__c where id=: medicareScheduleFeeId]; 
            
            //check PMPM fee flag
            PMPMFeeRequired=(medFeeSchedObj.FAF_Id__c!=null && medFeeSchedObj.FAF_Id__r.LOB2__c!=null && medFeeSchedObj.FAF_Id__r.LOB2__c!='WRAP' )?true:false;
            if (medFeeSchedObj.Type__c == 'Retiree Drug Subsidy')
            {
//                medFeeSchedObj.Basis__c = 'PMPM';
                FeeDescRequired=false;
            }
            else
                medFeeSchedObj.Fee_Description__c=null;    
        }   
    } 
    
    //Method for Insert Or Update the Record
    public pagereference saveUpdateMFS(){
        try{
            pagereference pr;
            String url;
            if(operationType=='Clone'){
                SObject cloneSObj;
                cloneSObj=CustomCloneUtility.customCloneMethod(medFeeSchedObj);
                insert cloneSObj;
                pr = new pagereference(ConstantsUtil.FORWARD_SlASH +cloneSObj.id);
            }
            else{
                if (medFeeSchedObj.Type__c != 'Retiree Drug Subsidy'){
                    medFeeSchedObj.Fee_Description__c=null; 
                }
                if (medFeeSchedObj.Type__c == 'Retiree Drug Subsidy' && medFeeSchedObj.Fee_Description__c==''){   
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter Fee Description.'));
                    return null; 
                }
                
                List<Fee_Service_Template__c> feetempLst =[select id,Max_Amount__c from Fee_Service_Template__c where Active__c = true AND FAF_Component__c = 'Billing Ops.Medicare Part D Fees Schedules'AND Template_Type__c = 'RDS Services'  AND Item__c =: medFeeSchedObj.Fee_Description__c];
                If(feetempLst.size()>0){
                    if(feetempLst[0].Max_Amount__c < medFeeSchedObj.PMPM_Fee__c)
                    {
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.error, 'Fee must be between $0.00 and $'+feetempLst[0].Max_Amount__c));
                        Return null;                                
                    }
                }
                
                if(medicareScheduleFeeId == null){
                    insert medFeeSchedObj; // Insert Record
                }else{
                    medFeeSchedObj.Sync_Source__c ='Target';
                    update medFeeSchedObj; // UPdate Record
                }
                //pr = new pagereference('/' + medFeeSchedObj.id);
                url = '/'+medFeeSchedObj.id;
            }
            //pr.setRedirect(true);
            //return pr;
            PageReference ref = new PageReference(url);
            ref.setRedirect(true);
            return ref;   
        }catch(DMLException excp){
            ApexPages.addMessages(excp);
            return null;
        }
    } 
}