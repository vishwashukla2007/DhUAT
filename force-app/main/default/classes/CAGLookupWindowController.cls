/* ================================================
 * @VF Name           : CAGLookupWindowController
 * @author            : Sridevi
 * @created date      : 09/15/2018
 * @Last modified by  : Sridevi
 * @Last modified date: 09/24/2018
 * @Purpose           : This is controller for CAGLookup_VF 
================================================ */

public class CAGLookupWindowController {
     public String searchString { get; set; }  
     public String cagId { get; set; }  
     public String platformId { get; set; } 
     //public String RecordTypeId {get; set; }
     public String RecordTypeName {get; set; }
     public String PlatformName {get; set; }
     public String Status{get;set;}
     public String AccountId {get;set;}
     public String parAccountId {get;set;}
     public String AccountLevel{get;set;}
     public boolean Showhide {get;set;}
     public List<CAG__c> cags { get; set; } 
     public list<Account> AccountList {get;set;}
     public CAG__c cagRecord { get; set; } 
     public integer CagValues {get; set;}
     public CAGLookupWindowController(){  
         cagRecord = new CAG__c();
         cagRecord.Carrier_Name__c = 'Non-Validated';
          CagValues =0;
         AccountCheck = false;
          this.searchString = Apexpages.currentPage().getParameters().get('searchString');  
          this.cagId = Apexpages.currentPage().getParameters().get('cagId');  
          this.platformId = Apexpages.currentPage().getParameters().get('Id'); 
          this.PlatformName = Apexpages.currentPage().getParameters().get('Platform');
          this.RecordTypeName = Apexpages.currentPage().getParameters().get('RecordType');
          this.Status =  Apexpages.currentPage().getParameters().get('Active');
          //this.RecordTypeId = [select id from RecordType where Name =: this.RecordTypeName].Id; 
          this.AccountLevel = Apexpages.currentPage().getParameters().get('AccountLevel');
          this.AccountId = Apexpages.currentPage().getParameters().get('AccountId');
          parAccountId = this.AccountLevel;
          System.debug('this.AccountList Is ' + AccountList);
          this.retrieveTeamMembers(); 
         
     }
     public boolean AccountCheck {get;set;}
     public void retrieveTeamMembers(){  
          if(this.searchString != null && this.searchString != ''){  
               performSearch();  
          } else {
             
               this.Cags = new list<Cag__c>();
                if(AccountCheck == true){
              list<CAG__c> cagLists = [SELECT Id,Carrier_ID__c,Carrier_Name__c,Platform_Name__c,Record_Type__c,Status__c, Name,RecordType.name 
                        FROM CAG__c where Record_Type__c =:  this.RecordTypeName and Status__c in('A','N')
                        and Platform_Name__c =: this.PlatformName limit 100]; 
              list<CAG__c> AllcagLists = [SELECT Id FROM CAG__c where Record_Type__c =:  this.RecordTypeName and Status__c in('A','N') 
                                           and Platform_Name__c =: this.PlatformName]; 
              CagValues = AllcagLists.size();
             
              list<String> CarrierList = new list<string>();            
              for(CAG__c Cag : cagLists){
                   
                        this.Cags.add(Cag);    
               }
            }  
               
               if(Accountcheck == false){
                  list<CAG__c> cagLists = [SELECT Id,Carrier_ID__c,Carrier_Name__c,Platform_Name__c,Record_Type__c,Status__c, Name,RecordType.name 
                        FROM CAG__c where Record_Type__c =:  this.RecordTypeName and Status__c in('A','N') 
                        and Platform_Name__c =: this.PlatformName ];  
                     list<String> CarrierList = new list<string>();
                   for(CAG__c Cag : cagLists){
                       if(Cag.Carrier_Name__c != 'Non-Validated'){
                        CarrierList.add(Cag.Carrier_ID__c);
                       }
                       else {
                        this.Cags.add(Cag);    
                       }
                    }
                   if(CarrierList.size() > 0){ 
                    AccountList = [select id,Account_Level__c,ParentId,Client_ID__c  from Account where Client_ID__c IN: CarrierList and (Id =: parAccountId Or parentId =: parAccountId or SuperClient_Account__c =: parAccountId)];
                  map<string,string> CarrierMap = new map<string,string>();
                   for(Account Acc : AccountList){
                       CarrierMap.put(Acc.Client_ID__c,Acc.Client_ID__c);
                   }
                   
                   integer i= 1;
                   for(CAG__c Cag : cagLists){
                      if(CarrierMap.get(Cag.Carrier_ID__c) != null && i<=100){
                          this.Cags.add(Cag);
                      } 
                      if(CarrierMap.get(Cag.Carrier_ID__c) != null){
                        CagValues = i;
                        i++;
                      }
                   }
              }
            }
        
          }  
      }
      
      public void performSearch(){ 
          Showhide = false;
            this.Cags = new list<Cag__c>();
            String Str = '%' + String.escapeSingleQuotes(this.searchString) + '%';
          //this.cags = database.query(query);
           if(AccountCheck == true){
          System.debug('*****Mytest ' + Status +'***'+ RecordTypeName +'***'+PlatformName);
          list<Cag__c> cagLists = [SELECT Id,Carrier_ID__c,Carrier_Name__c,Record_Type__c, Name,RecordType.name,Status__c,Platform_Name__c FROM CAG__c 
                        where Record_Type__c =:  this.RecordTypeName  and Status__c in('A','N') and Platform_Name__c =: this.PlatformName and Carrier_ID__c LIKE: Str 
                        limit 100];
                        
          list<CAG__c> AllcagLists = [SELECT Id FROM CAG__c where Record_Type__c =:  this.RecordTypeName and Status__c in('A','N') 
                                           and Platform_Name__c =: this.PlatformName and Carrier_ID__c LIKE: Str ]; 
          CagValues = AllcagLists.size();
             
                         System.debug('*****Mytest ' + Status + RecordTypeName +PlatformName);
            list<String> CarrierList = new list<string>();            
            for(CAG__c Cag : cagLists){   
                        this.Cags.add(Cag);    
               }
           } 
                if(Accountcheck == false){
             
                   list<Cag__c> cagLists = [SELECT Id,Carrier_ID__c,Carrier_Name__c,Record_Type__c, Name,RecordType.name,Status__c,Platform_Name__c FROM CAG__c 
                        where Record_Type__c =:  this.RecordTypeName  and Status__c in('A','N') and Platform_Name__c =: this.PlatformName and Carrier_ID__c LIKE: Str 
                        ];
                  list<String> CarrierList = new list<string>();
                   for(CAG__c Cag : cagLists){
                       if(Cag.Carrier_Name__c != 'Non-Validated'){
                        CarrierList.add(Cag.Carrier_ID__c);
                       }
                       else {
                        this.Cags.add(Cag);    
                       }
                    }
                    if(CarrierList.size() > 0){ 
                  AccountList = [select id,Account_Level__c,ParentId,Client_ID__c  from Account where Client_ID__c IN: CarrierList and (Id =: parAccountId Or parentId =: parAccountId or SuperClient_Account__c =: parAccountId)];
                  map<string,string> CarrierMap = new map<string,string>();
                   for(Account Acc : AccountList){
                       CarrierMap.put(Acc.Client_ID__c,Acc.Client_ID__c);
                   }
                   
                   integer i= 1;
                   for(CAG__c Cag : cagLists){
                      if(CarrierMap.get(Cag.Carrier_ID__c) != null && i<=100){
                          this.Cags.add(Cag);
                      } 
                      if(CarrierMap.get(Cag.Carrier_ID__c) != null){
                        CagValues = i;
                        i++;
                      }
                   }
             
                }
     }
      }
     
     public void redirect()
     {
           System.debug('this.AccountLevel Is ' + parAccountId);
           cagRecord.Carrier_ID__c = '';
           Showhide = true;
           
     }
     
     public void Cancel(){
          Showhide = false;
     }
     public void Save(){
        if(cagRecord.Carrier_ID__c != null && cagRecord.Carrier_Name__c != Null){
             List<CAG__c> lstCAG = new List<CAG__c>();
             lstCAG = [Select Id, 
                          Platform_Name__c, 
                          Carrier_ID__c, 
                          CAG_ID__c,
                          Carrier_Name__c, 
                          Account_ID__c, 
                          Account_Name__c, 
                          Group_ID__c, 
                          Group_Name__c,
                          Record_Type__c
                          FROM CAG__c
                          WHERE Carrier_ID__c = :cagRecord.Carrier_ID__c
                          and Platform_Name__c = :PlatformName];
             if(lstCAG != null && !lstCAG.isEmpty())
             {  
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Carrier Record already exists');
                ApexPages.addMessage(myMsg);
             }
             else
             {
             cagRecord.Platform_Name__c = PlatformName;
             cagRecord.CAG_ID__c = PlatformName + cagRecord.Carrier_ID__c;
             cagRecord.Status__c = Status;
             cagRecord.Non_Validated_CAG__c = true;
             cagRecord.Record_Type__c = RecordTypeName;
             //cagRecord.RecordTypeId = RecordTypeId;
             System.debug('this.AccountLevel Is ' + parAccountId);
            //  Account AccRecord = [select id,Account_Level__c,ParentId from Account where Id =: parAccountId];
            //  if(AccRecord.Account_Level__c == 'Super Client'){
            //     cagRecord.PBM_Level0_Account__c = AccRecord.Id; 
            //     list<Account> AccRecList = [select id from Account where parentId=: AccRecord.Id];
            //     if(AccRecList.size() > 0){
            //         cagRecord.PBM_Level1_Account__c = AccRecList[0].Id;
            //     }
                
            //  }
            //  else if(AccRecord.Account_Level__c == 'Level 1'){
                cagRecord.PBM_Level1_Account__c = parAccountId; 
                cagRecord.PBM_Level0_Account__c = parAccountId;
             //}
             insert cagRecord;
             cagRecord = new cag__c();
             cagRecord.Carrier_Name__c = 'Non-Validated';
             Showhide = false;
             this.retrieveTeamMembers(); 
             }}
        
        
     }
     
     public void hideaccountmethod(){
         accountCheck  = true; 
         retrieveTeamMembers();
     }
      public void showaccountmethod(){
         accountCheck  = false; 
         retrieveTeamMembers();
     }
      /*    */

}