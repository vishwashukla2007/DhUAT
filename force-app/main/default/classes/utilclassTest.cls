@isTest
private class utilclassTest{

    private static testMethod void testOne() 
    {
       list<Central_Hub__c> fafList = new list<Central_Hub__c>();
       list<Id> fafIds = new list<Id>();
            
            Account acct = TestDataFactory.createAccount();  
            acct.Market_Segment__c='Employer'; 
            //acct.Client_Subtype__c='Coalition Master'; 
            acct.Status__c='Active';
            insert acct;
            
            Opportunity opp = TestDataFactory.createOpportunity(acct.Id);
            insert opp;
            
            Central_Hub__c faf1 = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
            faf1.Salesperson__c= null;
            faf1.Network_Operations__c= true;
            faf1.Specialty_Operations__c= true;
            faf1.Mail_Operations__c= true;
            faf1.FAF_Type__c='Partial';
            faf1.Approved_By_Sales__c= false;
            faf1.Peer_Reviewed__c= false;
            //faf1.Network_Operations_Count__c  = 1;
            //faf1.FAF_Status__c='Implemented';
            
            User salesperson = ClientTestRef.createUser('Apttus Sales');
            insert salesperson;
            
            Central_Hub__c faf2 = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
            faf2.Salesperson__c= null;
            faf2.Network_Operations__c= true;
            faf2.Specialty_Operations__c= true;
            faf2.Mail_Operations__c= true;
            faf2.FAF_Type__c='Partial';
            faf2.FAF_Status__c = 'Draft';
            faf2.Approved_By_Sales__c= false;
            faf2.Peer_Reviewed__c= false;
            
            fafList.add(faf2);
            
            insert fafList;
            
            fafIds.add(fafList[0].id);
            
            Client_Information__c clientInfo = TestDataFactory.createClientInfo(fafList[0].id);
            clientInfo.Pricing_Effective_Date__c = System.Today();
            upsert clientInfo;
            
             Central_Hub__c fullFAF = ClientTestRef.createFAF(acct.id, opp.Id, salesperson.Id);
            fullFAF.Business_Type__c = 'New';
            fullFAF.FAF_Status__c = 'Closed';
            fullFAF.FAF_Type__c  = 'Full';
            insert fullFAF; 
            
           
            
            FAF_Link__c fafLink = new FAF_Link__c();
            fafLink.Full_FAF__c = fullFAF.Id;
            fafLink.Partial_FAF__c = fafList[0].Id;
            insert fafLink;
            
            Network_Operations__c no = new Network_Operations__c();
            no.FAF_ID__c = fafList[0].id;
            no.Client__c='Lower of Discount or U&C or MAC';
            no.Member__c='  Lower of Discount or U&C or Copay - Standard Copay Logic Off';
            insert no;
            
            fafList[0].FAF_Status__c = 'Implemented';
           // fafList[0].Peer_Reviewer__c = salesperson.id;
           // fafList[0].Approved_By_Sales__c  = false;
            fafList[0].Last_Approval_Event__c = system.now();
            
            
            update fafList[0];
            
            map<Id,Central_Hub__c> fafMap = new map<Id,Central_Hub__c>(fafList);
            Id fafId = fafList[0].Id;
            fafMap.get(fafId).FAF_Status__c = 'Draft';
            fafMap.get(fafId).Approved_By_Sales__c = false;
            fafMap.get(fafId).Peer_Reviewed__c = false;
            fafMap.get(fafId).FAF_Released_Date__c = system.toDay();
            string newStr = JSON.serialize(fafMap);
            
            fafMap.get(fafId).FAF_Status__c = 'Sales Review';
            fafMap.get(fafId).Approved_By_Sales__c = true;
            fafMap.get(fafId).Peer_Reviewed__c = true;
            fafMap.get(fafId).FAF_Released_Date__c = null;
            string oldStr = JSON.serialize(fafMap);
            
            UtilClass.validateLinkFAF(fafIds);
            UtilClass.logTransactionHistory( newStr, oldStr, 'Central_Hub__c', 'Id', 
            new list<string>{'faf_status__c','Approved_By_Sales__c','Peer_Reviewed__c','Clone_Source_FAF_ID__c','FAF_Released_Date__c'},
             'update' );
                 
            fafMap.get(fafId).FAF_Status__c = 'Sales Approved';
            oldStr = JSON.serialize(fafMap);
            
            UtilClass.logTransactionHistory( newStr, oldStr, 'Central_Hub__c', 'Id', 
                new list<string>{'faf_status__c','Approved_By_Sales__c','Peer_Reviewed__c','Clone_Source_FAF_ID__c'},
                 'update' );
                 
             fafMap.get(fafId).FAF_Status__c = 'Sales Review';
            newStr = JSON.serialize(fafMap);
            
            UtilClass.logTransactionHistory( newStr, oldStr, 'Central_Hub__c', 'Id', 
                new list<string>{'faf_status__c','Approved_By_Sales__c','Peer_Reviewed__c','Clone_Source_FAF_ID__c','FAF_Released_Date__c'},
                 'update' );
            
            fafMap.get(fafId).FAF_Status__c = 'Uploaded';  
            fafMap.get(fafId).FAF_Released_Date__c = system.toDay();
            fafMap.get(fafId).Clone_Source_FAF_ID__c = 'true'; 
            newStr = JSON.serialize(fafMap);
            UtilClass.logTransactionHistory( newStr, oldStr, 'Central_Hub__c', 'Id', 
                new list<string>{'faf_status__c','Approved_By_Sales__c','Peer_Reviewed__c','Clone_Source_FAF_ID__c'},
                 'insert' );
            
            
            CAG__c cag = new CAG__c();
            cag.Record_Type__c = 'c';
            cag.CAG_ID__c = '657657';
            insert cag;
        
          
       
        
        Platform_Specifics__c psObj = new Platform_Specifics__c( FAF_Client_Information__c = clientInfo.Id );
        psObj.Level_1_Record_ID__c  = cag.id;
            //insert psObj;
            Platform_Specifics__c[] lstPS = new Platform_Specifics__c[]{ psObj };
            
           /* map<Id,Platform_Specifics__c> mapPS = new map<Id,Platform_Specifics__c>(lstPS);
            newStr = JSON.serialize(mapPS);
            oldStr = JSON.serialize(mapPS);
            UtilClass.logTransactionHistory( newStr, oldStr, 'Platform_Specifics__c', 'Id', new list<string>{''}, 'insert' );*/
            
            clientInfo.Approval_Option__c = 'FAF Release';
            map<Id,Client_Information__c> cinfoMap = new map<Id,Client_Information__c>( new Client_Information__c[]{clientInfo} );
            newStr = JSON.serialize(cinfoMap);
            oldStr = JSON.serialize(cinfoMap);
            UtilClass.logTransactionHistory( newStr, oldStr, 'Client_Information__c', 'Id', new list<string>{''}, 'insert' );
            
            Apttus_Approval__Approval_Request__c arObj = new Apttus_Approval__Approval_Request__c(
                    Apttus_Approval__Step_Name__c = 'Peer Review',
                    Apttus_Approval__Approval_Status__c = 'Approved',
                    Related_FAF__c = fafId
                );
            //insert arObj;
           map<Id,Apttus_Approval__Approval_Request__c> mapAR = new map<Id,Apttus_Approval__Approval_Request__c>();//new Apttus_Approval__Approval_Request__c[]{arObj});
           mapAR.put(fafId,arObj);
           newStr = JSON.serialize(mapAR);
            oldStr = JSON.serialize(mapAR);
            UtilClass.logTransactionHistory( newStr, oldStr, 'Apttus_Approval__Approval_Request__c', 'Id', new list<string>{''}, 'insert' );
    
      Apttus_Approval__Approval_Request__c arObj1 = new Apttus_Approval__Approval_Request__c(
                    Apttus_Approval__Step_Name__c = 'FAF Release for \'Implementation\'',
                    Apttus_Approval__Approval_Status__c = 'CC:Underwriter',
                    Related_FAF__c = fafId
                );
           map<Id,Apttus_Approval__Approval_Request__c> mapAR1 = new map<Id,Apttus_Approval__Approval_Request__c>();//new Apttus_Approval__Approval_Request__c[]{arObj});
           mapAR1.put(fafId,arObj1);
           
           newStr = JSON.serialize(mapAR1);
            oldStr = JSON.serialize(mapAR1);                
         UtilClass.logTransactionHistory( newStr, oldStr, 'Apttus_Approval__Approval_Request__c', 'Id', 
          new list<string>{'Apttus_Approval__Step_Name__c','Apttus_Approval__Step_Label__c'}, 'insert' );
         TransactionLogsC__c obj = new TransactionLogsC__c(
                            FAFId__c = fafId,
                            TimeStamp__c = System.now(),
                            TransactionBy__c =UserInfo.getUserId(),
                            FafObject__c = 'FAF',
                            TransactionDetail__c = 'sample',
                            TransactionType__c = 'test1',
                            RecordName__c = 'test',
                            RecordId__c = fafId
                        );
                        insert obj;
        TransactionLogsControllerB.loadBigObject(new list<Id>{fafId});
        TransactionLogsControllerB.getTransactionLogs(fafId);
        
            fafMap = new map<Id,Central_Hub__c>(fafList);
            fafId = fafList[0].Id;
            fafMap.get(fafId).FAF_Status__c = 'Draft';
            fafMap.get(fafId).Approved_By_Sales__c = true;
            fafMap.get(fafId).Peer_Reviewed__c = false;
            fafMap.get(fafId).FAF_Released_Date__c = system.toDay();
            newStr = JSON.serialize(fafMap);
            
            fafMap.get(fafId).FAF_Status__c = 'Implemented';
            fafMap.get(fafId).Approved_By_Sales__c = false;
            fafMap.get(fafId).Peer_Reviewed__c = true;
            fafMap.get(fafId).FAF_Released_Date__c = null;
            oldStr = JSON.serialize(fafMap);
            
        UtilClass.logTransactionHistory( newStr, oldStr, 'Central_Hub__c', 'Id', 
                new list<string>{'faf_status__c','Approved_By_Sales__c','Peer_Reviewed__c','Clone_Source_FAF_ID__c'},
                 'update' );
           
                 
    }
    
    public static testmethod void getPicklistValuesTest(){
        UtilClass.getPicklistValues('Specialty_Pricing__c', 'Pharmacy_Benefit__c');
        
        Account acc = TestDataFactory.createAccount();
        acc.Account_Level__c ='SuperClient';
        acc.iUMS_Client_Subtype__c = 'Health Plan Master';
        insert acc;
        Map<id, Account> acMap=new Map<Id, Account>();
        acMap.put(acc.Id, acc);
        Map<id, Account> acNewMap=new Map<Id, Account>(); 
        acNewMap.put(acc.Id, acc);
        UtilClass.fieldComparison(acMap, acNewMap, 'Account');        
    }

}