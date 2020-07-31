@isTest
private class TransactionLogsControllerBTest {

    private static testMethod void testOne() 
    {
       list<Central_Hub__c> fafList = new list<Central_Hub__c>();
            
            Account acct = TestDataFactory.createAccount();  
            acct.Market_Segment__c='Employer'; 
            acct.Status__c='Active';
            insert acct;
            
            Opportunity opp = TestDataFactory.createOpportunity(acct.Id);
            insert opp;
            
            //Central_Hub__c faf1 = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
            Central_Hub__c faf1 = new Central_Hub__c();
            faf1.FAF_Status__c = 'Draft';
            faf1.FAF_Close_On_Date__c = Date.today()-1;
            insert faf1;
            faf1.Salesperson__c= null;
            faf1.Network_Operations__c= false;
            faf1.Specialty_Operations__c= false;
            faf1.Mail_Operations__c= false;
            //faf1.FAF_Type__c='Partial';
            faf1.Approved_By_Sales__c= true;
            faf1.Peer_Reviewed__c= true;
            faf1.Initiate_FAF_Release__c = false;
            // faf1.FAF_Status__c='Implemented';
            
            fafList.add(faf1);
            
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
                 
                 
             fafMap.get(fafId).Peer_Reviewed__c = true;
             //fafMap.get(fafId).Action_Source__c = 'Manual';
            newStr = JSON.serialize(fafMap);
            
            UtilClass.logTransactionHistory( newStr, oldStr, 'Central_Hub__c', 'Id', 
                new list<string>{'faf_status__c','Approved_By_Sales__c','Peer_Reviewed__c','Action_Source__c','FAF_Released_Date__c'},
                 'update' );                 
            
            fafMap.get(fafId).FAF_Status__c = 'Uploaded';  
            fafMap.get(fafId).FAF_Released_Date__c = system.toDay();
            fafMap.get(fafId).Clone_Source_FAF_ID__c = 'true'; 
            newStr = JSON.serialize(fafMap);
            UtilClass.logTransactionHistory( newStr, oldStr, 'Central_Hub__c', 'Id', 
                new list<string>{'faf_status__c','Approved_By_Sales__c','Peer_Reviewed__c','Clone_Source_FAF_ID__c'},
                 'insert' );
            
            Client_Information__c clientInfo = TestDataFactory.createClientInfo(fafid);
            upsert clientInfo;
            CAG__c cag = new CAG__c(CAG_ID__c='112233');
            insert cag;
            Platform_Specifics__c psObj = new Platform_Specifics__c( FAF_Client_Information__c = clientInfo.Id, 
                                                                      Level_1_Record_ID__c = cag.Id,
                                                                      Level_2_record_ID__c= cag.Id);
          //  insert psObj;
            Platform_Specifics__c[] lstPS = new Platform_Specifics__c[]{ psObj };
            
        //    map<Id,Platform_Specifics__c> mapPS = new map<Id,Platform_Specifics__c>(lstPS);
        //    newStr = JSON.serialize(mapPS);
         //   oldStr = JSON.serialize(mapPS);
         //   UtilClass.logTransactionHistory( newStr, oldStr, 'Platform_Specifics__c', 'Id', new list<string>{''}, 'insert' );
            
            clientInfo.Approval_Option__c = 'FAF Release';
            map<Id,Client_Information__c> cinfoMap = new map<Id,Client_Information__c>( new Client_Information__c[]{clientInfo} );
            newStr = JSON.serialize(cinfoMap);
            oldStr = JSON.serialize(cinfoMap);
            UtilClass.logTransactionHistory( newStr, oldStr, 'Client_Information__c', 'Id', new list<string>{''}, 'insert' );
          
            Apttus_Approval__Approval_Request__c arObj = new Apttus_Approval__Approval_Request__c(
                    Apttus_Approval__Step_Name__c = 'Peer Review',
                    Apttus_Approval__Approval_Status__c = 'Approved',
                    Apttus_Approval__Approver_Comments__c = 'Test comments'
                    //Related_FAF__c = fafId
                );
           insert arObj;
           map<Id,Apttus_Approval__Approval_Request__c> mapAR = new map<Id,Apttus_Approval__Approval_Request__c>();//new Apttus_Approval__Approval_Request__c[]{arObj});
           mapAR.put(fafId,arObj);
           
           newStr = JSON.serialize(mapAR);
            oldStr = JSON.serialize(mapAR);
            UtilClass.logTransactionHistory( newStr, oldStr, 'Apttus_Approval__Approval_Request__c', 'Id', 
          new list<string>{''}, 'insert' );
          
           mapAR = new map<Id,Apttus_Approval__Approval_Request__c>();//new Apttus_Approval__Approval_Request__c[]{arObj});
           arObj = [select Related_FAF__c, Approval_Status__c, Id,Apttus_Approval__Step_Name__c, Apttus_Approval__Approver_Comments__c
                    FROM Apttus_Approval__Approval_Request__c where Id = :arObj.Id ];
           arObj.Related_FAF__c = faf1.Id;  
           mapAR.put(fafId,arObj);
           
           newStr = JSON.serialize(mapAR);
            oldStr = JSON.serialize(mapAR);
            UtilClass.logTransactionHistory( newStr, oldStr, 'Apttus_Approval__Approval_Request__c', 'Id', 
          new list<string>{''}, 'insert' );

TransactionLogsC__c obj = new TransactionLogsC__c(
                            FAFId__c = faf1.Id,
                            TimeStamp__c = System.now(),
                            TransactionBy__c =UserInfo.getUserId(),
                            FafObject__c = 'FAF',
                            TransactionDetail__c = 'sample',
                            TransactionType__c = 'test1',
                            RecordName__c = 'test',
                            RecordId__c = fafId
                        );
                        insert obj;
        TransactionLogsControllerB.loadBigObject(new list<Id>{obj.Id});
        TransactionLogsControllerB.getTransactionLogs(fafId);
        
    }

}