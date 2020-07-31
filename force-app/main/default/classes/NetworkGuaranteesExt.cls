/* =============================================================================================================
 * @Class Name        : NetworkGuaranteesExt
 * @author            : Sindhu Alati
 * @created date      : 1/10/2018
 * @Last modified by  : Sindhu Alati
 * @Last modified date: 8/10/2018
 * @Purpose           : This is the controller class for NetworkGuaranteesNewEditPage
================================================================================================================*/
public class NetworkGuaranteesExt {
    public ApexPages.StandardController con;
    public Retail_Network_Guarantees__c ng {get;set;}
    Network_Operations__c NO = new Network_Operations__c();
    Network_Pricing__c np = new Network_Pricing__c();
    public Boolean mirrorMailGuarantee {get;set;}
    public boolean hasMethodExists {get;set;}
    public Boolean redirect{get;set;}
    public String urlString{get;set;}
    public string networkOperationsId {get;set;}
    public Boolean NoMailPriceatFAF{get;set;}
    public NetworkGuaranteesExt(ApexPages.StandardController controller) {
         NoMailPriceatFAF=false;
        redirect = ApexPages.currentPage().getParameters().containsKey('lightning');
        con = controller;
        ng = (Retail_Network_Guarantees__c)controller.getRecord();
        mirrorMailGuarantee = ng.Mirror_Mail_Guarantees__c;
        string NetworkPrId;
        hasMethodExists = true;
        
        if(ApexPages.currentPage().getParameters().containsKey(Label.FAFIDNetworkGuarantee)) {
            NetworkPrId = ApexPages.currentPage().getParameters().get(Label.FAFIDNetworkGuarantee);
        } else {
            NetworkPrId =  ng.Network_Pricing__c;
        }   
        Network_Pricing__c np = [SELECT Id, FAF_ID__c,Brand_Rate__c,Year__c,LOB__c,Network_Name__c,
                                 FAF_Network_Ops__c,
                                 FAF_Network_Ops__r.Method__c,
                                 FAF_Network_Ops__r.Time_Frame__c,
                                 FAF_Network_Ops__r.Level__c
                                 FROM Network_Pricing__c WHERE Id = :NetworkPrId];  
        networkOperationsId = np.FAF_Network_Ops__c;                         
        if(ng.FAF_ID__c == null) {
          ng.Network_Pricing__c = np.Id;
          ng.FAF_ID__c = np.FAF_ID__c;   
        }
        //Added By Kiran.
        if(ng.id== null && np.FAF_Network_Ops__r.Method__c == null && np.FAF_Network_Ops__r.Time_Frame__c ==null && np.FAF_Network_Ops__r.Level__c == null){
            
                hasMethodExists = false;
                ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.FATAL,  
                'Cannot create a Retail Network Guarantee record when Retail Network Guarantee Reconciliation Method, Level and Timeframe are not specified on Network Operations.'));
        }
          
        List<String> yearList;
        if(np.Year__c!='All') {
            yearList = new List<String>{'All'};
        } else {
            yearList = new List<String>{'1','2','3','4','5'};
        }
        yearList.add(np.Year__c);    
        List<Mail_Pricing__c> mpList = [SELECT Id FROM Mail_Pricing__c WHERE FAF_Id__c=:np.FAF_ID__c AND Year__c=:yearList AND LOB__c=:np.LOB__c];
        //Added for W-000293 to display Warning Message: A Mail Pricing record needs to be created when Network Name on the Network Pricing starts with characters 'MC'.
        List<Mail_Pricing__c> mpList1 =[SELECT Id FROM Mail_Pricing__c WHERE FAF_Id__c=:np.FAF_Id__c];
        if(mpList1.isEmpty() && np.Network_Name__c!='' && np.Network_Name__c!=null && np.Network_Name__c.startswith('MC'))
              NoMailPriceatFAF=true;

        if(!mpList.isEmpty() && np.Network_Name__c.startsWith('MC')) {
          //List<Mail_Guarantees__c> mgList = [SELECT Id FROM Mail_Guarantees__c WHERE  Mail_Pricing__c IN:mpList];
          //if(!mgList.isEmpty()) {
              mirrorMailGuarantee = true;
          //}
        }
        
        
    } 
    
    Public pagereference populateratessg(){ 
        Network_Pricing__c np = [SELECT Id, FAF_ID__c,Brand_Rate__c FROM Network_Pricing__c WHERE Id = :ng.Network_Pricing__c];           
        ng.Rate__c = np.Brand_Rate__c;   
        return null;
    }   
   public PageReference saveNetworkGuarantees(){
       try{
           urlString='';
           if(ng.LDD__c == 'Yes' )
           {
             ng.LDD_Inclusion_Option__c = null;
           }
           if(ng.X340B__c == 'Yes' )
           {
             ng.X340B_Inclusion_Option__c = null;
           }
           if(ng.Vaccine__c == 'Yes')
           {
             ng.Vaccine_Inclusion_Option__c = null;
           }
           upsert ng;
           Boolean SSGIntoBrandUpdate = false;
           Boolean SSGListUpdate = false;
           Retail_Network_Guarantees__c[] ngList = [SELECT Id, Type__c, SSG__c from Retail_Network_Guarantees__c WHERE Network_Pricing__c = :ng.Network_Pricing__c];
           if(!ngList.isEmpty() )  
           {    
               Network_Pricing__c np = new Network_Pricing__c(Id = ng.Network_Pricing__c);
               for(Retail_Network_Guarantees__c ng:ngList) {
                   if(ng.Type__c=='BER' || ng.Type__c=='SSG') {
                       SSGIntoBrandUpdate = true;                       
                   }
                   if(ng.SSG__c=='No') {
                       SSGListUpdate = true;
                   }
               }
               if(!SSGIntoBrandUpdate) {
                   np.SSGs_into_Brands__c = false;
               }
               
               if(!SSGListUpdate) {
                   np.SSG_Exclusion_List__c = '';
                   np.SSG_Exclusivity_Period__c= '';                   
               }
               update np;
           }
           String url = '/'+ng.Id;

               
        if(ApexPages.currentPage().getParameters().containsKey('lightning')) {
            urlString = '/'+networkOperationsId;
           PageReference ref = new PageReference(urlString);
            return ref; 
            } 
           PageReference ref = new PageReference(url);
            return ref;
        }
       catch(exception e)
       {
           ApexPages.addMessages(e);
           return null;
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
        }catch(Exception excp){
            ApexPages.addMessages(excp);
            return null;
        }
    }   
}