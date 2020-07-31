/* ================================================
 * @VF Name           : CAGLookupWindowController2
 * @author            : Sridevi
 * @created date      : 09/15/2018
 * @Last modified by  : Sridevi
 * @Last modified date: 09/24/2018
 * @Purpose           : This is controller for CAGLookup_VF 
================================================ */

public class CAGLookupWindowController2 {
     public String searchString { get; set; }  
     public String cagId { get; set; }
     public String platformId { get; set; } 
     public String RecordTypeId {get; set; }
     public String RecordTypeName {get; set; }
     public String PlatformName {get; set; }
     public String Status{get;set;}
     public String AccountId {get;set;}
     public String parAccountId {get;set;}
     public String AccountLevel{get;set;}
     public boolean Showhide {get;set;}
     public List<CAG__c> cags { get; set; }
     public String carrierId {get; set; }
     public String carrierName {get; set; }
     public list<Account> AccountList {get;set;}
     public CAG__c cagRecord { get; set; } 
     public integer CagValues {get; set;}
     public CAGLookupWindowController2(){  
         cagRecord = new CAG__c();
         cagRecord.Account_Name__c = 'Non-Validated';
          CagValues =0;
          this.searchString = Apexpages.currentPage().getParameters().get('searchString');  
         // this.cagId = Apexpages.currentPage().getParameters().get('cagId');  
          this.platformId = Apexpages.currentPage().getParameters().get('Id'); 
          this.PlatformName = Apexpages.currentPage().getParameters().get('Platform');
          this.RecordTypeName = Apexpages.currentPage().getParameters().get('RecordType');
          this.Status =  Apexpages.currentPage().getParameters().get('Active');
          this.RecordTypeId = [select id from RecordType where Name =: this.RecordTypeName].Id; 
          this.AccountLevel = Apexpages.currentPage().getParameters().get('AccountLevel');
          this.AccountId = Apexpages.currentPage().getParameters().get('AccountId');
          this.carrierId = Apexpages.currentPage().getParameters().get('cagId');
          this.carrierName = Apexpages.currentPage().getParameters().get('CarrierName');
          parAccountId = this.AccountLevel;
             System.debug('this.AccountList Is ' + AccountList);
          this.retrieveTeamMembers(); 
         
     }
     
     public void retrieveTeamMembers(){  
          if(this.searchString != null && this.searchString != ''){  
               performSearch();  
          } else {
              system.debug(this.RecordTypeId + ' **** '+ this.Status + ' '+ '***** ' + this.carrierId + ' ' +this.carrierName + ' '+this.PlatformName);
               this.Cags = new list<Cag__c>(); 
                this.Cags = [  
                    SELECT Id,Carrier_ID__c,Carrier_Name__c,Account_ID__c,Account_Name__c,Record_Type__c,Platform_Name__c,Status__c, Name,RecordType.name 
                        FROM CAG__c where Record_Type__c =:  this.RecordTypeName and Status__c in('A','N') and Carrier_ID__c =: this.carrierId
                        and Carrier_Name__c =: this.carrierName and Platform_Name__c =: this.PlatformName limit 100]; 
             /*  list<CAG__c> AllcagLists = [SELECT Id FROM CAG__c where Record_Type__c =:  this.RecordTypeName and Status__c =: this.Status 
                                           and Platform_Name__c =: this.PlatformName]; 
              CagValues = AllcagLists.size();*/
             
          }  
      }
      
      public void performSearch(){ 
          Showhide = false;
            this.Cags = new list<Cag__c>();
                String Str = '%' + String.escapeSingleQuotes(this.searchString) + '%';
          //this.cags = database.query(query);  
          this.Cags = [SELECT Id,Carrier_ID__c,Carrier_Name__c,Account_ID__c,Account_Name__c, Name,RecordType.name,Status__c,Platform_Name__c FROM CAG__c 
                        where  Carrier_ID__c =: this.carrierId and Carrier_Name__c =: this.carrierName and Record_Type__c =:  this.RecordTypeName  and Status__c in('A','N') and Platform_Name__c =: this.PlatformName and Account_ID__c LIKE: Str 
                        ];
       /*   list<CAG__c> AllcagLists = [SELECT Id,Carrier_ID__c,Carrier_Name__c,Account_ID__c,Account_Name__c, Name,RecordType.name,Status__c,Platform_Name__c FROM CAG__c 
                        where  Carrier_ID__c =: this.carrierId and Carrier_Name__c =: this.carrierName and Record_Type__c =:  this.RecordTypeName  and Status__c in('A','N') and Platform_Name__c =: this.PlatformName and Account_ID__c LIKE: Str 
                        ];
          CagValues = AllcagLists.size();*/
            
     }
     
     
     public void redirect()
     {
           System.debug('this.AccountLevel Is ' + parAccountId);
           cagRecord.Account_ID__c = '';
           Showhide = true;
           
     }
     
     public void Cancel(){
          Showhide = false;
     }
     public void Save(){
          if(cagRecord.Account_ID__c != null && cagRecord.Account_Name__c != Null){
            
             List<CAG__c> lstCAG = [Select Id, 
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
                          WHERE 
                          //Carrier_ID__c = :cagRecord.Carrier_ID__c
                           Platform_Name__c = :PlatformName
                          and Account_ID__c = :cagRecord.Account_ID__c];
             
           if(lstCAG.size() > 0)
             {  
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Account Record already exists');
                ApexPages.addMessage(myMsg);
       
             }
             else
             {
             cagRecord.Platform_Name__c = PlatformName;
             cagRecord.CAG_ID__c = PlatformName + cagRecord.Carrier_ID__c + cagRecord.Account_ID__c ;
             cagRecord.Carrier_ID__c = CarrierId;
             cagRecord.Account_ID__c = cagRecord.Account_ID__c;
             cagRecord.Carrier_Name__c = carrierName;
             cagRecord.Account_Name__c = cagRecord.Account_Name__c;
             cagRecord.Non_Validated_CAG__c = true;
             cagRecord.Platform_Name__c = PlatformName;
             cagRecord.Status__c = Status;
             //cagRecord.RecordTypeId = RecordTypeId;
             cagRecord.Record_Type__c = RecordTypeName;
             System.debug('this.AccountLevel Is ' + parAccountId);
              insert cagRecord;
              cagRecord = new cag__c();
              cagRecord.Account_Name__c = 'Non-Validated';
              Showhide = false;
              this.retrieveTeamMembers(); 
             }}
     }
      /*    */

}