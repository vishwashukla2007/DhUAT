public class CustomLookupController 
{
  public sObject sObj {get;set;} 
  public string sObjName {get;set;}
  public string nameFld {get;set;}
  public List<sObject> results{get;set;} // search results
  public string searchString{get;set;}// search keyword
  //public string nam {get;set;}
 
  
  public CustomLookupController() {
     nameFld='Name'; 
     sObjName = System.currentPageReference().getParameters().get('objectName');
     sObj = Schema.getGlobalDescribe().get(sObjName).newSObject() ;
    // get the current search string
    searchString = System.currentPageReference().getParameters().get('lksrch');
    
    runSearch(); 
  }
   
  
  // performs the keyword search
  public PageReference search() {
    runSearch();
    return null;
  }
  
  // prepare the query and issue the search command
  private void runSearch() {
    // TODO prepare query string for complex serarches & prevent injections
    results = performSearch(searchString);               
  } 
  
  // run the search and return the records found. 
  private List<sObject> performSearch(string searchString) {

    String soql = 'select id, name from '+sObjName;
    if(searchString != '' && searchString != null)
      soql = soql +  ' where name LIKE \'%' + searchString +'%\'';
    soql = soql + ' limit 25';
    System.debug(soql);
    return database.query(soql); 

  }
 public void saveRecord() 
 {
     try{
      insert sobj;
      //sObj = Schema.getGlobalDescribe().get(sObjName).newSObject() ;
     }
     catch(exception e)
     {
         ApexPages.addMessages(e);
     }
 }
// used by the visualforce page to send the link to the right dom element
  public string getFormTag() {
    return System.currentPageReference().getParameters().get('frm');
  }
    
  // used by the visualforce page to send the link to the right dom element for the text box
  public string getTextBox() {
    return System.currentPageReference().getParameters().get('txt');
  }
}