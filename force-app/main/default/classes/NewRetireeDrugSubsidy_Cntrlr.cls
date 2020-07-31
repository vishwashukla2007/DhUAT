/**********************************************

*   Class:              NewRetireeDrugSubsidy_Cntrlr.apxc
*   Objective:          Helper will provide the required methods to save FeeService
*   Test Class:         NewRetireeDrugSubsidy_Cntrlr_Test.apxc [yet to write]
*   Developer:          

**********************************************/ 

public class NewRetireeDrugSubsidy_Cntrlr {
    
    public Retiree_Drug_Subsidy__c rds{get; set;}
    public boolean adSerRdnly{get; set;}
    public boolean showHelptext{get;set;}
    Public String helpTextMessage {get;set;}
    public Decimal sequence;
    
    public NewRetireeDrugSubsidy_Cntrlr(ApexPages.StandardController stdCntrlr){
        try{
            this.rds = (Retiree_Drug_Subsidy__c)stdCntrlr.getRecord();
            adSerRdnly = false;
            
            if(rds != null && rds.id != null){
                rds = [select Id,Link__c,Name,CreatedById,CreatedDate,LastModifiedById,Notes__c,FAF_Component__c,Last_Date_Modified__c,Service_Request_Date__c,Service_Effective_Date__c,LastModifiedDate,Fee_Services__r.FAF_ID__c, Fee_Services__c,Fee_Service_Template__c,Fee_Service_Template__r.Item_Description__c,
                       fee_service_template__r.active__c,fee_service_template__r.template_type__c,fee_service_template__r.sequence__c, Fee_Service_Template__r.Item_Description2__c,
                       fee_service_template__r.item__c,FAF_ID__c,Service_Description__c,Service_Description2__c,Additional_Service__c,Amount__c,Basis__c,Basis2__c,Election__c,Sequence__c,Service__c from Retiree_Drug_Subsidy__c where id=:  rds.Id ];
                if(!rds.Additional_Service__c)
                    adSerRdnly = true;
                showHelpText = True;
                helpTextMessage = rds.Service_Description2__c;
            }
            if(rds.Fee_Services__c == null)
                rds.Fee_Services__c = ApexPages.currentPage().getParameters().get(Label.Retiree_Drug_subsidy);
            if(rds != null && rds.Fee_Services__c != null && rds.FAF_ID__c == null){
                
                Fee_Services__c fs = [select id,name,FAF_ID__c,FAF_ID__r.Name from Fee_Services__c where id=:  rds.Fee_Services__c ];
                rds.FAF_ID__c = fs.FAF_ID__c;
            }
            
            /*If(rds.Fee_Service_Template__c!=null && rds.fee_service_template__r.template_type__c == 'RDS Services' &&
                rds.fee_service_template__r.active__c && rds.fee_service_template__r.sequence__c == rds.sequence__c &&
                rds.fee_service_template__r.Item__c == rds.service__c){
                showHelpText = True;
                helpTextMessage = rds.Service_Description__c;
                
                }else{
                // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'ERROR:Service:This service is not active please contact your Underwriter Administrator'));
                // return null;
                showHelpText = True;
                helpTextMessage = 'ERROR:Service:This service is not active please contact your Underwriter Administrator';
                }
            */           
            
            
            if(rds.Id == null){
                rds.Additional_Service__c = true;
                rds.Election__c = true;
                Fee_Services__c fs = [SELECT Id,Name,Max_Sequence__c FROM Fee_Services__c WHERE Id =: rds.Fee_Services__c];
                rds.Sequence__c = fs.Max_Sequence__c+1;
                sequence = rds.Sequence__c;
                
            }
            
        }catch(Exception e){
            system.debug(e.getMessage());
        }
    }
    
    public PageReference saveRetireeDrugSubsidy(){
        try{
            String dupRdsId = '';
            PageReference pg = new PageReference('/' + rds.Fee_Services__c);
            
            if(rds.Fee_Service_Template__c != null){
                Fee_Service_Template__c fst = [select Id,Max_Amount__c,Sequence__c,Item__c from Fee_Service_Template__c where 
//                                               id =: rds.Fee_Service_Template__c AND Template_Type__c =: 'RDS Services' and Active__c = TRUE ];
                                               id =: rds.Fee_Service_Template__c AND Template_Type__c =: 'RDS Services' ];

                if(fst != null && (rds.Amount__c > fst.Max_Amount__c|| rds.Amount__c < 0)){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: Amount must be between $0.00 and $'+ fst.Max_Amount__c));
                    return null;
                }
            }
            
            if(rds.Fee_Service_Template__c == null){
                Fee_Services__c fs = [SELECT Id,Name,RDS_Count__c FROM Fee_Services__c WHERE Id =: rds.Fee_Services__c];
                if(fs != null && fs.RDS_Count__c == 0){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Retiree Drug Subsidy (RDS) Additional Fees can only be added to FAFs with existing Retiree Drug Subsidy Services records.'));
                    return null;
                }
            }
            
            if(rds.Service__c != null && rds.FAF_ID__c != null && rds.Fee_Services__c != null){
                String qry = 'select Id,Fee_Services__c,Service__c,FAF_ID__c from Retiree_Drug_Subsidy__c where  Service__c =\''+ rds.Service__c +'\'';
                qry = qry +' and FAF_ID__c =\''+ rds.FAF_ID__c + '\'';
                if(rds.Id != null)
                    qry = qry + ' and id != \''+ rds.Id +'\'';
                System.debug('qry--->'+qry);
                
                List<Retiree_Drug_Subsidy__c> rds_serv_uni_chk_ls = database.query(qry);
                if(rds_serv_uni_chk_ls != null && !rds_serv_uni_chk_ls.isEmpty()){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: You must enter a unique Service'));
                    return null;
                }
            }
            
            List<Retiree_Drug_Subsidy__c> duplicateRDSSeq = [SELECT Id,Name FROM Retiree_Drug_Subsidy__c WHERE Sequence__c =: rds.Sequence__c AND Fee_Services__c =: rds.Fee_Services__c AND Id !=: rds.Id];
            if(!duplicateRDSSeq.isEmpty()){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Sequence Must be unique.'));
                //rds.Sequence__c.addError('Error: Sequence Must be unique.');
                return null;
            }
            /*if(rds.Id == null && sequence != rds.Sequence__c){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Sequence should be'+sequence));
            // rds.Sequence__c.addError('Sequence should be'+sequence);
            return null;
            }*/
            upsert rds;
            
            return pg.setRedirect(true);
            
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
        /*catch(System.DmlException de){
        String excep = de.getMessage();
        String dupChk = 'DUPLICATE_VALUE, duplicate value found: Service__c';
        String dupErr = 'Error: Service value should be unique';
        if(excep.contains(dupChk) ) {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,dupErr));
        rds.Service__c.addError(dupErr);
        }
        return null;
        // : Insert failed. First exception on row 0; first error: DUPLICATE_VALUE, duplicate value found: Service__c duplicates value on record with id: a7F0x000000QqmB: []
        }catch(Exception e){
        System.debug(e.getMessage());
        System.debug(e.getCause());
        System.debug(e.getLineNumber());
        System.debug(e.getStackTraceString());
        System.debug(e.getTypeName());
        
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to create Retiree Drug Subsidy(RDS).'));
        return null;
        }*/
    }
}