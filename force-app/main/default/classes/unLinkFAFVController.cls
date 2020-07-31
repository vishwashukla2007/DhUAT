public with sharing class unLinkFAFVController {
    private Id CurrentId;
    Private String MargetSegment;
    Public Central_Hub__c faf;
    List<CentralHubWrapper> HubList {get;set;}
    public string searchstring {get;set;} 

    public unLinkFAFVController() {
        CurrentId = ApexPages.currentPage().getParameters().get('id');
        MargetSegment = ApexPages.currentPage().getParameters().get('MarketSegment');
        faf =  [select id, FAF_Type__c, FAF_Status__c,Client_Subtype__c from Central_Hub__c where Id =:CurrentId ][0];
    }
    
    // instantiate the StandardSetController from a query locator
    public ApexPages.StandardSetController con {
        get {
            if(con == null){
           
            String query;
                      
            query = 'SELECT Id, Partial_FAF__r.Name, Full_FAF__r.Name,Full_FAF__r.Client_Name__c, Full_FAF__r.FAF_Type__c,Full_FAF__r.LOB_Subtype__c,Full_FAF__r.LOB_Descriptor__c,Full_FAF__r.FAF_Status__c,Full_FAF__r.Segment__c,Full_FAF__r.Pricing_Effective_Date__c FROM FAF_Link__c WHERE Partial_FAF__c = :CurrentId ';
            
            if(searchstring!=null) {
                query += ' AND Full_FAF__r.name =:searchstring';
            }       
                      
            con = new ApexPages.StandardSetController(Database.query(query));
            // sets the number of records in each page set
            con.setPageSize(5);
            }
            return con;
        }
        set;
    }

    // returns a list of wrapper objects for the sObjects in the current page set
    public List<CentralHubWrapper> getHubList() {
        HubList = new List<CentralHubWrapper>();
        if(con.getRecords().size()>0){
        for (FAF_Link__c Hub : (List<FAF_Link__c>)con.getRecords())
            HubList.add(new CentralHubWrapper(Hub));
         }
        return HubList;
    }

    // displays the selected items
     public PageReference save() {
       try {
             List<FAF_Link__c> deleteList = new List<FAF_Link__c>();
             List<FAF_Link__c> fullFAFList = new List<FAF_Link__c>();
             Map<id,FAF_Link__c>  fafLinkList = new Map<id,FAF_Link__c>([select id,Full_FAF__c,Partial_FAF__c from FAF_Link__c where Partial_FAF__c = :CurrentId and Full_FAF__r.FAF_Type__c Like 'Full%'  ]); 
             system.debug('---fafLinkList .size()--'+fafLinkList .size());                       
             
             for (CentralHubWrapper cHub : HubList) {
                 if (cHub.checked) { 
                     system.debug('---cHub.checked--'+cHub.checked);   
                        if(faf.FAF_Type__c == 'Partial' &&  faf.FAF_Status__c == 'Implemented'  && fafLinkList.containskey(cHub.Hub.id)){
                            system.debug('---inside--');  
                            fullFAFList.add(cHub.Hub);
                        }   
                        deleteList.add(cHub.Hub);   
                    }                                                     
             }
             
             system.debug('---fafLinkList.size()--'+fafLinkList.size());
             system.debug('---fullFAFList.size()--'+fullFAFList.size());
             
             if((fafLinkList.size() == fullFAFList.size()) && (faf.Client_Subtype__c!=system.label.ClientType_TPA_Member && faf.Client_Subtype__c!=system.label.ClientType_TPA_Master
                        && faf.Client_Subtype__c!=system.label.ClientType_Coalition_Member
                            && faf.Client_Subtype__c!=system.label.ClientType_Coalition_Master
                                && faf.Client_Subtype__c!=system.label.ClientType_Health_Plan_Member
                                   && faf.Client_Subtype__c!=system.label.ClientType_Health_Plan_Master)){
                if(!Test.isRunningTest()){
                         ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'The current Partial FAF needs to be linked to an existing Full FAF.');
                         ApexPages.addMessage(msg);
                         return null;
                 }           
             }
             
             if(!deleteList.isEmpty()) {
                 try{
                     
                    Delete deleteList;  
                 }catch(DMLException e){
                     ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, e.getDmlMessage(0));
                     ApexPages.addMessage(msg);
                     return null;
                 }
             }
             return Cancel();
             }
              catch (Exception ex)
              {
                 
                  ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage());
                  ApexPages.addMessage(msg);
                  
                 return null;
              } 
     }

    public void searchHubList() {
        con= null;
    }
   
    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }

    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }

    // returns the first page of records
     public void first() {
         con.first();
     }

     // returns the last page of records
     public void last() {
         con.last();
     }

     // returns the previous page of records
     public void previous() {
         con.previous();
     }

     // returns the next page of records
     public void next() {
         con.next();
     }

     // returns the PageReference of the original page, if known, or the home page.
     public PageReference cancel() {
        return new PageReference('/' + CurrentId);
     }

     public PageReference clear() {
        searchstring = null;
        con = null;
        return new PageReference('/apex/UnLink_FAFs?id=' + CurrentId);
    }

    public class CentralHubWrapper {

        public Boolean checked{ get; set; }
        public FAF_Link__c Hub { get; set;}

        public CentralHubWrapper(FAF_Link__c h){
            Hub = h;
            checked = false;
        }
    }
}