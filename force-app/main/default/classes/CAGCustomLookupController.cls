public class CAGCustomLookupController 
{
  public sObject sObj {get;set;} 
  public string sObjName {get;set;}
  public string nameFld {get;set;}
  public List<sObject> results{get;set;} // search results
  public string searchString{get;set;}// search keyword
  //public string nam {get;set;}
  List<Platform_Specifics__c> platfromSpecList = new List<Platform_Specifics__c>();
  List<Platform_Specifics__c> psSpecList = new List<Platform_Specifics__c>();
  public String fafId {get; set;}
  public String level {get; set;} 
  public String platfromSpecStr{get; set;}
  public List<String> levelList= new List<String>();
  List<Platform_Specifics__c> psList= new List<Platform_Specifics__c>();
  List<CAG__c> caglist=new List<CAG__c>();
  public string cagName{get;set;}
  
  public CAGCustomLookupController() {
     
     sObjName = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('objectName'));
     fafId = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('strFaf'));
     level = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('level'));
     sObj = Schema.getGlobalDescribe().get(sObjName).newSObject() ;
    // get the current search string
    searchString = String.escapeSingleQuotes(System.currentPageReference().getParameters().get('lksrch'));
    if(level=='l1'){
            nameFld='Level_1_Record_ID__c'; 
            cagName='Carrier_ID__c'; 
    }else if(level=='l2'){
            nameFld='Level_2_record_ID__c'; 
            cagName='Account_ID__c'; 
    }else{
            nameFld='Level_3_record_ID__c';
            cagName='Group_ID__c';  
    }
    
   
    runSearch(); 
  }
   
  
  // performs the keyword search
  public PageReference search(){
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
  try{
      String keyString='\'%' + String.escapeSingleQuotes(searchString ) +'%\'';
    String soql = 'select id, '+String.escapeSingleQuotes(nameFld) +' from Platform_Specifics__c where  FAF_ID__c=:fafId AND '+String.escapeSingleQuotes(nameFld) +'!=\'\'';
    if(searchString != '' && searchString != null){
      soql = soql +  ' AND '+String.escapeSingleQuotes(nameFld) +' LIKE ' +keyString ;
      }
    soql = soql +' order by '+String.escapeSingleQuotes(nameFld)+' DESC limit 25';
    platfromSpecList =database.query(soql);
    Set<id> psID = new Set<ID>();
    
    for(Platform_Specifics__c ps :platfromSpecList){
        if(level=='l1'){
            if(levelList.contains(ps.Level_1_record_ID__c)){
                psID.add(ps.id);
            }else if(!levelList.contains(ps.Level_1_record_ID__c)){
                levelList.add(ps.Level_1_record_ID__c);
                psList.add(ps);
            }
        }else if(level=='l2'){
            if(levelList.contains(ps.Level_2_record_ID__c)){
                psID.add(ps.id);
            }else if(!levelList.contains(ps.Level_2_record_ID__c)){
                levelList.add(ps.Level_2_record_ID__c);
                psList.add(ps);
            }
        }else{
            if(levelList.contains(ps.Level_3_record_ID__c)){
                psID.add(ps.id);
            }else if(!levelList.contains(ps.Level_3_record_ID__c)){
                levelList.add(ps.Level_3_record_ID__c);
                psList.add(ps);
            }
        }
    }
    if(!levelList.isEmpty()){
        String cagString = 'select id,Name,'+String.escapeSingleQuotes(cagName)+' from CAG__c where id In: levelList';
        caglist =database.query(cagString);
        
    }
    return  caglist ;
    }catch(Exception e){
        System.debug('exception ===  '+e);
        return null;
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