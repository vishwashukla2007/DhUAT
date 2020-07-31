/**********************************************

*   Class:              NewPBMServices_Cntrlr.apxc
*   Objective:          Helper will provide the required methods to save FeeService
*   Test Class:         NewPBMServices_Cntrlr_Test.apxc [yet to write]
*   Developer:          

**********************************************/ 

public class NewPBMServices_Cntrlr {
    
    public PBM_Services__c pbm{get; set;}
    public boolean adSerRdnly{get; set;}
    public boolean seqRdnly{get; set;}
    public boolean customRedirect{get; set;}
    Public String redirectURL{get; set;}
    public ApexPages.StandardController currentPageref; 
    
    public NewPBMServices_Cntrlr(ApexPages.StandardController stdCntrlr){
        try{
            currentPageref = stdCntrlr;
            this.pbm = (PBM_Services__c)stdCntrlr.getRecord();
            adSerRdnly = false;
            seqRdnly = false;
            
            if(pbm != null && pbm.id != null){
                pbm = [select Id,Link__c,Notes__c,Name,CreatedById,CreatedDate,Last_Date_Modified__c,FAF_Component__c,Service_Request_Date__c,Service_Effective_Date__c,LastModifiedById,LastModifiedDate,Fee_Services__r.FAF_ID__c, Fee_Services__c,Fee_Service_Template__c,
                       FAF_ID__c,Amount__c,Additional_Service__c,Basis2__c,Election__c,Type__c,Sequence__c,Service__c,Service_Description__c,Service_Description2__c from PBM_Services__c where id=:  pbm.Id ];
            }
            if(pbm.Additional_Service__c != true && pbm.ID != null){
                adSerRdnly = true;
                seqRdnly = true;
            }
            if(pbm.Fee_Services__c == null){
                pbm.Fee_Services__c = ApexPages.currentPage().getParameters().get(Label.PBM_Services);
            }                    
            if(pbm.Fee_Services__c == null){
                pbm.Fee_Services__c = ApexPages.currentPage().getParameters().get(Label.Fee_Services_Commercial);
                pbm.Type__c = 'PBM Services';
            }
            if(pbm.Fee_Services__c == null){
                pbm.Fee_Services__c = ApexPages.currentPage().getParameters().get(Label.Fee_Services_EGWP);
                pbm.Type__c = 'EGWP';
            }
            if(pbm.Fee_Services__c == null){
                pbm.Fee_Services__c = ApexPages.currentPage().getParameters().get(Label.Fee_Services_Medicaid);
                pbm.Type__c = 'Medicaid';
            }
            if(pbm.Fee_Services__c == null){
                pbm.Fee_Services__c = ApexPages.currentPage().getParameters().get(Label.Fee_Services_MAPD);
                pbm.Type__c = 'MAPD';
            }                        
            if(pbm != null && pbm.Fee_Services__c != null && pbm.FAF_ID__c == null){
                Fee_Services__c fs = [select id,name,FAF_ID__c,FAF_ID__r.Name from Fee_Services__c where id=:  pbm.Fee_Services__c ];
                pbm.FAF_ID__c = fs.FAF_ID__c;
            }
            
            // Custom redirect For Lightning
            redirectURL = ApexPages.currentPage().getParameters().get('redUrl');
            customRedirect = string.isNotBlank(redirectURL)?true:false;
                
            if(pbm.Id == null){ 
                pbm.Additional_Service__c = true;
                pbm.Election__c= true; 
//                Fee_Services__c fs = [SELECT Id,Name,Max_Sequence_1__c FROM Fee_Services__c WHERE Id =: pbm.Fee_Services__c];
//                pbm.Sequence__c = fs.Max_Sequence_1__c+1;
                
                AggregateResult[] groupedResults = [SELECT Type__c,MAX(Sequence__c) FROM PBM_Services__c WHERE Fee_Services__c =: pbm.Fee_Services__c AND Type__c =: pbm.Type__c Group by Type__c];
                for (AggregateResult ar : groupedResults)  {
                    System.debug('Max ' + pbm.Type__c + ' ' + ar.get('expr0'));
                    pbm.Sequence__c = Integer.valueOf(ar.get('expr0')) + 1;
                }
            }
            
        }catch(Exception e){
            system.debug(e.getMessage());
        }
    }
    
    public PageReference savePBMServices(){
        try{
            String duppbmId = '';
            PageReference pg = new PageReference('/' + pbm.Fee_Services__c);
            
            if(pbm.Fee_Service_Template__c != null){
                  Fee_Service_Template__c fst =  [select Id,Max_Amount__c,Template_Type__c from Fee_Service_Template__c where 
                                               id =: pbm.Fee_Service_Template__c];
//                                             id =: pbm.Fee_Service_Template__c and Active__c = TRUE];            
                
//                if(fst != null && fst.Template_Type__c == 'PBM Services' && (pbm.Amount__c > fst.Max_Amount__c || pbm.Amount__c < 0)){
                if(fst != null && (pbm.Amount__c > fst.Max_Amount__c || pbm.Amount__c < 0)){                
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: Amount must be between $0.00 and $'+ fst.Max_Amount__c));
                    return null;
                }
            }
            
             if(pbm.Fee_Service_Template__c == null){
                 Fee_Services__c fs = [SELECT Id,Name,PBM_Count__c FROM Fee_Services__c WHERE Id =: pbm.Fee_Services__c];
                 if(fs != null && fs.PBM_Count__c == 0){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'PBM Services Addition Fees can only be added to FAFs with existing PBM Services records.'));
                    return null;
                }
            }
            System.debug('pbm.Service__c--->'+pbm.Service__c);
            System.debug('pbm.FAF_ID__c--->'+pbm.FAF_ID__c);
            System.debug('pbm.Fee_Services__c--->'+pbm.Fee_Services__c);
            if(pbm.Service__c != null && pbm.FAF_ID__c != null && pbm.Fee_Services__c != null){
                String qry = 'select Id,Fee_Services__c,Service__c,FAF_ID__c from PBM_Services__c where  Service__c =\''+ pbm.Service__c +'\'';
                qry = qry +' and Type__c =\''+ pbm.Type__c + '\'';                
                qry = qry +' and FAF_ID__c =\''+ pbm.FAF_ID__c + '\'';
                if(pbm.Id != null){
                    qry = qry + ' and id != \''+ pbm.Id +'\'';                    
                }
                System.debug('qry--->'+qry);
                
                List<PBM_Services__c> pbm_serv_uni_chk_ls = database.query(qry);
                if(pbm_serv_uni_chk_ls != null && !pbm_serv_uni_chk_ls.isEmpty()){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: You must enter a unique Service'));
                    return null;
                }
            }
            
            upsert pbm;
                       
            return pg.setRedirect(true);
            
        }catch(Exception ex){
            system.debug('ex.getLineNumber()=='+ex.getLineNumber());
            ApexPages.addMessages(ex);
            return null;
        }
        /*catch(System.DmlException de){
            String excep = de.getMessage();
            String dupChk = 'DUPLICATE_VALUE, duplicate value found: Service__c';
            String dupErr = 'Error: Service value should be unique';
            if(excep.contains(dupChk) ) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,dupErr));
                pbm.Service__c.addError(dupErr);
            }
            return null;
            // : Insert failed. First exception on row 0; first error: DUPLICATE_VALUE, duplicate value found: Service__c duplicates value on record with id: a7F0x000000QqmB: []
        }catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getCause());
            System.debug(e.getLineNumber());
            System.debug(e.getStackTraceString());
            System.debug(e.getTypeName());
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to create PBM Services.'));
            return null;
        }*/
    }
    public PageReference cancel(){        
        PageReference pg = customRedirect ? new PageReference(redirectURL) : currentPageref.cancel();
        return pg;
    }
}