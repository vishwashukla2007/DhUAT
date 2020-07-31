public with sharing class LinkFAFVController {
    private Id CurrentId;
    Private String MargetSegment;
    Public Central_Hub__c faf{get;set;}
    List<CentralHubWrapper> HubList {get;set;}
    public string searchstring {get;set;} 
    public Boolean wraningProceed{get;set;}

    public LinkFAFVController() {
        CurrentId = ApexPages.currentPage().getParameters().get('id');
        MargetSegment = ApexPages.currentPage().getParameters().get('MarketSegment');
        wraningProceed = false;
    }
    
    // instantiate the StandardSetController from a query locator
    public ApexPages.StandardSetController con {
        get {
            if(con == null){
            Set<Id> linkedFAFIds = getFAFLinkList(CurrentId);
            faf = [select FAF_Type__c,FAF_Status__c from Central_Hub__c where Id =:CurrentId ];
          
            String query;
            System.debug('linkedFAFid'+linkedFAFIds);
           // if(faf.FAF_Type__c == 'Partial'){
            query = 'SELECT Id,Name,Client_Name__c,Pricing_Effective_Date__c,FAF_Status__c,Segment__c,LOB_Descriptor__c,LOB2__c,LOB_Subtype__c,FAF_Type__c FROM Central_Hub__c WHERE Id!=:CurrentId AND FAF_Status__c != \'Deleted\' AND Segment__c= :MargetSegment AND Id NOT IN:linkedFAFIds';
           // }
         
            if(searchstring!=null) {
                query += ' AND Name=:searchstring';
            } 
            System.debug('query'+query);           
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
        for (Central_Hub__c Hub : (List<Central_Hub__c>)con.getRecords())
            HubList.add(new CentralHubWrapper(Hub));
         }
        return HubList;
    }

    // displays the selected items
     public PageReference save() {
      wraningProceed = false;
      
         List<FAF_Link__c> updateList = new List<FAF_Link__c>();
         for (CentralHubWrapper cHub : HubList) {
            system.debug('!!!cHub'+cHub);   
             if (cHub.checked) {
                  if(faf.FAF_Status__c == cHub.Hub.FAF_Status__c ){
                       FAF_Link__c fafLink = new FAF_Link__c();
                       fafLink.Partial_FAF__c = CurrentId;
                       fafLink.Full_FAF__c = cHub.Hub.id;
                       updateList.add(fafLink);
                    system.debug('!!!wraningProceed'+wraningProceed);                      
                     }else{
                           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'The FAF Status of the FAFs being linked are not the same.'));
                           wraningProceed = true;
                           system.debug('@@@wraningProceed'+wraningProceed);    
                           return null;
                          }  
             }
         }
         system.debug('!!!updateList'+updateList);
         if(!updateList.isEmpty()) {
             INSERT updateList;
         }
         return cancel();
     }
     
     public PageReference saveOnWarning() {
         List<FAF_Link__c> updateList = new List<FAF_Link__c>();
         for (CentralHubWrapper cHub : HubList) {
             if (cHub.checked) {
                  
                       FAF_Link__c fafLink = new FAF_Link__c();
                       fafLink.Partial_FAF__c = CurrentId;
                       fafLink.Full_FAF__c = cHub.Hub.id;
                       updateList.add(fafLink); 
                      
             }
         }
         if(!updateList.isEmpty()) {
             INSERT updateList;
         }
         return cancel();
     }

    public Set<Id> getFAFLinkList(Id id){
        Set<id> linkedFAFIds = new Set<Id>();
        List<FAF_Link__c> fafLinkList = [SELECT Partial_FAF__c, full_FAF__c FROM FAF_Link__c WHERE Partial_FAF__c =:id  OR Full_FAF__c=:id];
        for(FAF_Link__c fafLink:fafLinkList){
            linkedFAFIds.add(fafLink.Partial_FAF__c);
            linkedFAFIds.add(fafLink.Full_FAF__c);
        }
        return linkedFAFIds;
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
        return new PageReference('/apex/Link_FAFs?id=' + CurrentId);
    }

    public class CentralHubWrapper {

        public Boolean checked{ get; set; }
        public Central_Hub__c Hub { get; set;}

        public CentralHubWrapper(Central_Hub__c h){
            Hub = h;
            checked = false;
        }
    }
}