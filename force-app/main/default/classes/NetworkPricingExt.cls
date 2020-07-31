/* =============================================================================================================
 * @Class Name        : NetworkPricingExt
 * @author            : Sindhu Alati
 * @created date      : 1/10/2018
 * @Last modified by  : Sindhu Alati
 * @Last modified date: 8/10/2018
 * @Purpose           : This is the controller class for NetworkPricingNewEditPage
================================================================================================================*/
public class NetworkPricingExt {
    public ApexPages.StandardController con;
    public Network_Pricing__c np {get;set;}
    public List<SelectOption> yearOptions {get;set;}
    Network_Operations__c NO = new Network_Operations__c();
    public String fafId {get;set;}
    public String year {get;set;}
    public String lob {get;set;}
    public string urlString {get;set;}
    public Boolean mirrorPricingFieldEnabled {get;set;}
    public Boolean enablessgintofield{get;set;}
    public Boolean enablessglistfield{get;set;}
    public String NetworkOpId{get;set;}
    public String genericBasis{get;set;}
    public Boolean redirect{get;set;}
    public String operationType;// custom clone functionality
    public Boolean NoMailPriceatFAF{get;set;}
    public Boolean fafClientSubtype{get;set;} //PT US318 added by Sneha Inturi
    //added by sonal sharma
    public String clientVar{get;set;}
    public String clientAdju{get;set;} //Added by sonal as per US44230
    public String memberAdju{get;set;}                                
    
    public NetworkPricingExt(ApexPages.StandardController controller) {
        NoMailPriceatFAF=false;
        fafClientSubtype=false; //PT US318 added by Sneha Inturi
        redirect = ApexPages.currentPage().getParameters().containsKey('lightning');
        operationType=ApexPages.currentPage().getParameters().get(ConstantsUtil.TYPE); //for the clone
        con = controller;
        mirrorPricingFieldEnabled = false;
        np = (Network_Pricing__c)controller.getRecord();
        enablessgintofield = false;
        
        if(np.FAF_ID__c == null && ApexPages.currentPage().getParameters().containsKey(Label.FAFIDNetworkPricing)) {
            NetworkOpId = ApexPages.currentPage().getParameters().get(Label.FAFIDNetworkPricing);
            setGenericBasis(np, NetworkOpId);    
        } else {
            setGenericBasis(np, np.FAF_Network_Ops__c);         
        }
        
        
        if(np.id != null){
            List<Retail_Network_Guarantees__c> ngList = [SELECT Id, FAF_ID__c FROM Retail_Network_Guarantees__c WHERE Network_Pricing__c = : np.Id AND Type__c IN ('BER','SSG')];
            if (!ngList.isEmpty()){
               enablessgintofield = true;        
         } 
         }  
 
        enablessglistfield = true;
        if( np.id != null )
        {
           for( Retail_Network_Guarantees__c ng : [SELECT Id,SSG__c, FAF_ID__c FROM Retail_Network_Guarantees__c WHERE Network_Pricing__c = : np.Id])
            {
                if( ng.SSG__c == 'No'  )
                    enablessglistfield = false;
            }
            //added by sonal sharma for us44230
          
            List<Mail_Operations__c> mailOps=[SELECT Id, Client__c,Member__c FROM Mail_Operations__c WHERE FAF_Id__c=:np.FAF_Id__c Limit 1];
            if(mailOps.size()>0){
                clientAdju=mailOps[0].Client__c;
                memberAdju=mailOps[0].Member__c;
            }
        }                        
        List<Mail_Pricing__c> mpList = getMailPCRecords(np.FAF_Id__c, np.Year__c, np.LOB__c);
          //Added for W-000255 to display Warning Message: A Mail Pricing record needs to be created when Network Name starts with characters 'MC'.
          List<Mail_Pricing__c> mpList1 =[SELECT Id FROM Mail_Pricing__c WHERE FAF_Id__c=:np.FAF_Id__c];
          if(mpList1.isEmpty()){
              NoMailPriceatFAF=true;
          }
          
          if(!mpList.isEmpty() && np.Network_Name__c.startswith('MC')) {
              mirrorPricingFieldEnabled = true;
          } else{
              mirrorPricingFieldEnabled = false;
          }
          
          if(!mirrorPricingFieldEnabled) {
              np.Mirror_Mail_Brand_Pricing__c = false;
              np.Mirror_Mail_Generic_Pricing__c = false;
              np.Generic_Basis__c = genericBasis; 
          }
        List<Client_Information__c> c = [SELECT Year_1__c,Year_2__c,Year_3__c,Year_4__c,Year_5__c FROM Client_Information__c
                                         WHERE Escalating_Pricing__c=true AND FAF_ID__c=:np.FAF_ID__c];
        
        yearOptions = new List<SelectOption>();
        
        if(!c.isEmpty()) {
            if(np.id==null) {
                yearOptions.add(new SelectOption('', '--None--'));
            }
            if(c[0].Year_1__c=='1') {
                yearOptions.add(new SelectOption('1', '1'));
            }
            if(c[0].Year_2__c=='2') {
                yearOptions.add(new SelectOption('2', '2'));
            }
            if(c[0].Year_3__c=='3') {
                yearOptions.add(new SelectOption('3', '3'));
            }
            if(c[0].Year_4__c=='4') {
                yearOptions.add(new SelectOption('4', '4'));
            }
            if(c[0].Year_5__c=='5') {
                yearOptions.add(new SelectOption('5', '5'));
            }
            yearOptions.add(new SelectOption('All', 'All'));           
            } else {
            yearOptions.add(new SelectOption('All', 'All'));
            } 
        
      }  

    public PageReference enableMirrorYearLOB(){
          List<Mail_Pricing__c> mpList = getMailPCRecords(np.FAF_Id__c, year, lob);
          if(!mpList.isEmpty()) {
              mirrorPricingFieldEnabled = true;
          } else{
              mirrorPricingFieldEnabled = false;
          }
          np.Mirror_Mail_Brand_Pricing__c = false;
          np.Mirror_Mail_Generic_Pricing__c = false;
          return null;
      } 
      
      public static List<Mail_Pricing__c> getMailPCRecords(Id fafId, String year, String lob) {
        List<String> yearList;
        if(year!='All') {
            yearList = new List<String>{'All'};
        } else {
            yearList = new List<String>{'1','2','3','4','5'};
        }
        yearList.add(year);        
        List<Mail_Pricing__c> mpList = [SELECT Id FROM Mail_Pricing__c WHERE FAF_Id__c=:fafId AND Year__c IN:yearList AND LOB__c=:lob];          
        return mpList;
      } 
      
       public boolean getNoMailPriceatFAF(){
           return NoMailPriceatFAF;
       }
      public PageReference save() {
        try{ 
           
            urlString='';
            boolean errorFlag = false;

            if(np.Mirror_Mail_Brand_Pricing__c ||np.Mirror_Mail_Generic_Pricing__c){
                np.Client_Adjudication_Logic_Deviation__c=clientAdju;
                  np.Member_Adjudication_Logic_Deviation__c=memberAdju;
                //System.debug('mirror--');
            }                                                                       
            if(np.Mirror_Mail_Generic_Pricing__c) {
                  np.Generic_Basis__c = '';
               } else {
                //commented by Sonal Sharma as per US30559
                  //np.Generic_Basis__c = genericBasis;
               } 
             // Netwrok Adjudication Logic Deviation set to True for Mirrored Mail records ***US 201 added by Sneha Inturi***
            if(!np.Network_Adjudication_Logic_Deviation__c && (np.Mirror_Mail_Brand_Pricing__c || np.Mirror_Mail_Generic_Pricing__c) ){
                np.Network_Adjudication_Logic_Deviation__c =true;   
            }
            //copy netwrok Client Adjudication Logic Deviation and Member Adjudication Logic Deviation from network operations when Network Adjudication Logic Deviation set false ***US148 added by Sneha Inturi***
            if(!np.Network_Adjudication_Logic_Deviation__c && np.FAF_Network_Ops__c!=null &&
                (np.Network_Name__c!='' && np.Network_Name__c!=null && np.Network_Name__c.startswith('MC') &&
                (np.Client_Adjudication_Logic_Deviation__c=='' || np.Client_Adjudication_Logic_Deviation__c==null || np.Member_Adjudication_Logic_Deviation__c =='' || np.Member_Adjudication_Logic_Deviation__c ==null))){
                Network_Operations__c NOtemp = [SELECT Id, FAF_ID__c,client__c,Member__c FROM Network_Operations__c WHERE Id = : np.FAF_Network_Ops__c]; 
                np.Client_Adjudication_Logic_Deviation__c=NOtemp.Client__c;
                np.Member_Adjudication_Logic_Deviation__c=NOtemp.member__c;
            }
           String url;               
            if(ConstantsUtil.CLONE.equals(operationType)){
                SObject cloneSObj;
                cloneSObj=CustomCloneUtility.customCloneMethod(np);
                
                insert cloneSObj;
                
                List<Retail_Network_Guarantees__c>retnetworkGuaranteeList = new List<Retail_Network_Guarantees__c>();
                List<Retail_Network_Guarantees__c>rebNetGurantList = new List<Retail_Network_Guarantees__c>();
                retnetworkGuaranteeList = [SELECT Biosimilars__c,COB__c,Compound__c,FAF_ID__c,Id,LDD_Inclusion_Option__c,LDD__c,Link__c,Mirror_Mail_Guarantees__c,Name,Network_Operations_Link__c,Network_Pricing_link__c,Network_Pricing__c,OTC__c,Paper__c,Rate__c,RecordTypeId,Source_Record_ID__c,SSGs_into_Brands__c,SSG__c,SystemModstamp,Type__c,U_C__c,Vaccine__c,Vaccine_Inclusion_Option__c,X340B_Inclusion_Option__c,X340B__c,ZBD__c FROM Retail_Network_Guarantees__c where Network_Pricing__c = :np.id];
                for(Retail_Network_Guarantees__c rng: retnetworkGuaranteeList){
                    rng.id = null;
                    rng.Network_Pricing__c = cloneSObj.id;
                    rebNetGurantList.add(rng);
                }
                insert rebNetGurantList;
                url = ConstantsUtil.FORWARD_SlASH +cloneSObj.id;
            }else{
                upsert np; 
                clearNetworkGuarantees(np);
                url = '/'+np.Id;
            }
    
    
        if(ApexPages.currentPage().getParameters().containsKey('lightning')) 
            {
            urlString = '/'+np.FAF_Network_Ops__c;
            PageReference ref = new PageReference(urlString);
            return ref;                
            } 
         
            PageReference ref = new PageReference(url);
            return ref;  
   
            
        } 
        catch(exception e) {
          ApexPages.addMessages(e);
          return null;
         }
          
       }
             
       
       
       public void clearNetworkGuarantees(Network_Pricing__c np) {
           if(mirrorPricingFieldEnabled && !np.Network_Name__c.startswith('MC')) {
               List<Retail_Network_Guarantees__c> ngList = [SELECT Id, Mirror_Mail_Guarantees__c FROM Retail_Network_Guarantees__c WHERE Network_Pricing__c=:np.Id AND Mirror_Mail_Guarantees__c=true];
               for(Retail_Network_Guarantees__c ng:ngList) {
                   ng.Mirror_Mail_Guarantees__c = false;
               }
               update ngList;
           }
       }
       
       public PageReference cancel() {
        try{
        if(ApexPages.currentPage().getParameters().containsKey('lightning')) {
               String url = '/c/Apttus_Specialty_Pricing_EV.app';
               redirect = true;
               return null;
            } else {
                return con.cancel();
            }   
                   
        }
        catch(Exception excp){
            ApexPages.addMessages(excp);
            return null;
        }
      }   
     
     //added by sonal sharma
     public PageReference BrandGenericBasis(){
         np.Generic_Basis__c = genericBasis;
         if(genericBasis=='Pass-Through'){
             np.MAC_Modeled__c ='';
         }
         return null;
     }
     
      public void setGenericBasis(Network_Pricing__c np, String NetworkOpId) {
            String passTrough='Pass-Through'; //added by sonal sharma to store the picklist value for generic basis and brand basis
            Network_Operations__c NO = [SELECT Id, FAF_ID__c,client__c,Member__c,FAF_ID__r.Client_Subtype__c FROM Network_Operations__c WHERE Id = : NetworkOpId]; 
            //modified by sonal sharma as per US30559
            if(np.Brand_Basis__c==passTrough){
                genericBasis=passTrough;
                 if(NetworkOperationsTriggerHelper.groupA.contains(NO.client__c) ) {
                    clientVar='MAC Modeled';
                } else if(NetworkOperationsTriggerHelper.groupB.contains(NO.client__c)) {
                    clientVar='Flat Generic';
                }
            }else{
                if(NetworkOperationsTriggerHelper.groupA.contains(NO.client__c) ) {
                    clientVar='MAC Modeled';
                    genericBasis = 'MAC Modeled & Non-MAC';
                } else if(NetworkOperationsTriggerHelper.groupB.contains(NO.client__c)) {
                    clientVar='Flat Generic';
                    genericBasis = 'Flat Generic Discount';
                } else {
                    genericBasis = '';
                } 
            }
            //set FAF client subtype flag PT US318 updated by Sneha Inturi
            if(NO!=null && NO.FAF_ID__r.Client_Subtype__c=='Stand-alone'){
                fafClientSubtype=true;
            }
            if(np.Id == null) {
                np.FAF_Network_Ops__c = NO.Id;
                np.FAF_ID__c = NO.FAF_ID__c;
                np.Generic_Basis__c = genericBasis; 
           }            
      }
}