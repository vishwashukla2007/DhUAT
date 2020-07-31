public without sharing class UtilClass{     
    public static Map<id,id> validateLinkFAF(List<ID> FAFs) {
    
        Set<ID> fafIds = new Set<ID>();  
        Map<id,Integer> partialCountMap = new Map<id,Integer>(); 
        map<id,id> invalidFafs  = new map<id,id> ();
        List<Central_Hub__c> fafList = [select id,Client_Subtype__c,FAF_Type__c,FAF_Status__c from Central_Hub__c where ID in: FAFs];
         /**
        Changes for W-000497 Salesforce Backlog FAF Linking not required for Partial FAF 
        which belong to TPA or Coalition Master/Member clients :Mohit Srivastava
        **/
        for(Central_Hub__c faf: FAFList){
        
            if(faf.FAF_Type__c == 'Partial' && faf.FAF_Status__c == 'Implemented'
                    && faf.Client_Subtype__c!=system.label.ClientType_TPA_Member && faf.Client_Subtype__c!=system.label.ClientType_TPA_Master
                        && faf.Client_Subtype__c!=system.label.ClientType_Coalition_Member
                            && faf.Client_Subtype__c!=system.label.ClientType_Coalition_Master
                              && faf.Client_Subtype__c!=system.label.ClientType_Health_Plan_Member
                                && faf.Client_Subtype__c!=system.label.ClientType_Health_Plan_Master)
               {               
                  fafIds.add(faf.id);                  
              }
        } 
        list<FAF_Link__c>  fafLinkList = [select id,Full_FAF__c,Partial_FAF__c from FAF_Link__c where Full_FAF__c in: fafIds and Partial_FAF__r.Faf_type__c LIKE 'Full%' ];
        list<FAF_Link__c>  fafLinkFullList = [select id,Full_FAF__c,Partial_FAF__c from FAF_Link__c where Partial_FAF__c in: fafIds and Full_FAF__r.Faf_type__c LIKE 'Full%' ];

        if(!fafLinkList.isempty()){
            for(FAF_Link__c fLink: fafLinkList){
                partialCountMap.put(fLink.Partial_FAF__c,1);        
            }       
        }
        if(!fafLinkFullList.isempty()){
            for(FAF_Link__c fLink: fafLinkFullList ){
                partialCountMap.put(fLink.Partial_FAF__c,1);        
            }       
        }
        /**
        Changes for W-000497 Salesforce Backlog FAF Linking not required for Partial FAF 
        which belong to TPA or Coalition Master/Member clients :Mohit Srivastava
        **/
        for(Central_Hub__c faf: FAFList){
            if(faf.FAF_Type__c == 'Partial' &&  faf.FAF_Status__c == 'Implemented'
                     && faf.Client_Subtype__c!=system.label.ClientType_TPA_Member && faf.Client_Subtype__c!=system.label.ClientType_TPA_Master
                        && faf.Client_Subtype__c!=system.label.ClientType_Coalition_Member
                            && faf.Client_Subtype__c!=system.label.ClientType_Coalition_Master
                             && faf.Client_Subtype__c!=system.label.ClientType_Health_Plan_Member
                                && faf.Client_Subtype__c!=system.label.ClientType_Health_Plan_Master)
 
            {
             if(!partialCountMap.containskey(faf.Id)){
                    invalidFafs.put(faf.id,faf.id);
                 }
            }
        }  
       return invalidFafs;     
                     
    }
    
    public static void fieldComparison( map<Id,sObject> newMap, map<Id,sObject> oldMap, string sObjectName )
    {
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get( sObjectName );
        Map<String,Schema.SObjectField> fieldsMap = targetType.getDescribe().fields.getMap();
        set<string> fields = fieldsMap.keySet(); //new set<string>{'Name','CreatedDate'};
        fields.removeAll( new set<string>{'lastmodifieddate', 'lastmodifiedbyid', 'systemmodstamp'} );
        
        for( sObject rec : newMap.values() )
        {
            sObject oldRec = oldMap.get(rec.Id);
            for( string fld : fields )
            {
                if( rec.get(fld) <> oldRec.get(fld) )
                {
                    system.debug(fieldsMap.get(Fld).getDescribe().label+' changes from '+oldRec.get(fld)+' to '+rec.get(fld));
                }
            }
        }
    }
    
    public static List<SelectOption> getPicklistValues(String ObjectApi_name,String Field_name){ 

        List<SelectOption> lstPickvals=new List<SelectOption>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);
        Sobject Object_name = targetType.newSObject();
        
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); 
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); 
        
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); 
        List<Schema.PicklistEntry> pick_list_values =field_map.get(Field_name).getDescribe().getPickListValues();
        
        for (Schema.PicklistEntry a : pick_list_values) {
            lstPickvals.add(new SelectOption(''+a.getValue(),''+a.getLabel()));
        }
        return lstPickvals;
    }
 //Added by Kiranmai to log transaction history   
 
   public static boolean  logTransactionHistoryFlagAppReq = true;
   public static boolean logTransactionHistoryFlagClentInfo = true;
   public static boolean  logTransactionHistoryFlag = true;
   public static map<Id,AggregateResult> fafMap = new map<Id,AggregateResult>();
   
   //@future
   public static void logTransactionHistory( string newMapString, string oldMapString, string sObjectName, string fafField, 
                                        list<string> fieldsToTrack, string operation  )
    {
        TransactionLogsC__c[] logsList = new TransactionLogsC__c[]{};
        map<Id,sObject> newMap = (map<Id,sObject>)System.JSON.deserialize(newMapString, map<Id,sObject>.class);
        map<Id,sObject> oldMap = (map<Id,sObject>)System.JSON.deserialize(oldMapString, map<Id,sObject>.class);

        Schema.SObjectType targetType = Schema.getGlobalDescribe().get( sObjectName );
        Map<String,Schema.SObjectField> fieldsMap = targetType.getDescribe().fields.getMap();
        string sObjectLabel = targetType.getDescribe().getLabel();
        id recid ;
        string profileName = [SELECT Name FROM Profile WHERE Id=:userInfo.getProfileId()].Name;
        
        if( sObjectName == 'Central_Hub__c' )
        {
            for( Central_Hub__c rec : (list<Central_Hub__c>)newMap.values() )
            {
                recid = rec.Id;
                Central_Hub__c oldRec = operation == 'insert' ? new Central_Hub__c() : (Central_Hub__c)oldMap.get(rec.Id);
                for( string fld : fieldsToTrack )
                {
                    string transType = '';
                    string transDetail = '';
                    
                    if( fld == 'faf_status__c' )
                    {
                        if( operation == 'insert' )
                        {
                            string status = rec.get('faf_status__c')+'';
                            system.debug('status_____'+status);
                            transType = 'FAF Created '+status+' Status';
                            transDetail = 'User Created';
                            
                            if( status =='Uploaded' )
                            {
                                transDetail = 'User Uploaded';
                            }
                            
                            if( rec.get('Clone_Source_FAF_ID__c') <> null  )
                            {
                                transDetail = 'Copied from; FAF '+rec.get('Clone_Source_FAF_ID__c');
                            }
                            
                            
                            
                            logsList.add( new TransactionLogsC__c(
                                    FAFId__c = (Id)rec.get(fafField),
                                    TransactionBy__c= UserInfo.getUserId(),
                                    FafObject__c= sObjectLabel,
                                    TimeStamp__c = DateTime.now(),
                                    TransactionDetail__c = transDetail,
                                    TransactionType__c = transType,
                                    RecordName__c = ''+rec.get('Name'),
                                    UserProfile__c= profileName,
                                    RecordId__c = rec.Id
                                ) );
                                
                                system.debug('log1________'+logsList);
                        }
                        else
                        {
                                string oldVal = oldRec.get(fld)+'';
                                string newVal = rec.get(fld)+'';
                                
                                system.debug('Old val________'+oldVal);
                                system.debug('New val________'+newVal);
                                
                                if(  oldVal == 'Sales Review' && ( newVal == 'Draft' || newVal == 'Peer Review' ) )
                                {
                                logsList.add( new TransactionLogsC__c(
                                    FAFId__c = (Id)rec.get(fafField),
                                    TransactionBy__c= UserInfo.getUserId(),
                                    FafObject__c= sObjectLabel,
                                    TimeStamp__c = DateTime.now(),
                                    TransactionDetail__c = Label.TransactionDetailPR,
                                    TransactionType__c = Label.TransactionType,
                                    RecordName__c = ''+rec.get('Name'),
                                    UserProfile__c= profileName,
                                    RecordId__c = rec.Id
                                    ) );
                                
                                }
                                else
                                if( (newVal == 'Peer Review' || newVal=='Draft') && ( oldVal == 'Sales Approved' || oldVal == 'Implemented') ) 
                                {
                                 
                                   
                                   logsList.add( new TransactionLogsC__c(
                                    FAFId__c = (Id)rec.get(fafField),
                                    TransactionBy__c= UserInfo.getUserId(),
                                    FafObject__c= sObjectLabel,
                                    TimeStamp__c = DateTime.now(),
                                    TransactionDetail__c = Label.TransactionDetailSR,
                                    TransactionType__c = Label.TransactionTypeSR,
                                    RecordName__c = ''+rec.get('Name'),
                                    UserProfile__c= profileName,
                                    RecordId__c = rec.Id
                                    ) );
                                    
                                    logsList.add( new TransactionLogsC__c(
                                    FAFId__c = (Id)rec.get(fafField),
                                    TransactionBy__c= UserInfo.getUserId(),
                                    FafObject__c= sObjectLabel,
                                    TimeStamp__c = DateTime.now(),
                                    TransactionDetail__c = Label.TransactionDetailPR,
                                    TransactionType__c = Label.TransactionType,
                                    RecordName__c = ''+rec.get('Name'),
                                    UserProfile__c= profileName,
                                    RecordId__c = rec.Id
                                    ) );
                                }
                                else
                                if( (newVal == 'Sales Review') && ( oldVal == 'Sales Approved' || oldVal == 'Implemented') ) 
                                {

                                   logsList.add( new TransactionLogsC__c(
                                    FAFId__c = (Id)rec.get(fafField),
                                    TransactionBy__c= UserInfo.getUserId(),
                                    FafObject__c= sObjectLabel,
                                    TimeStamp__c = DateTime.now(),
                                    TransactionDetail__c = Label.TransactionDetailSR,
                                    TransactionType__c = Label.TransactionTypeSR,
                                    RecordName__c = ''+rec.get('Name'),
                                    UserProfile__c= profileName,
                                    RecordId__c = rec.Id
                                    ) );
                                }

                               if( oldVal <> newVal )
                                {
                                    transType = Label.TransactionTypeStatus;
                                    transDetail = rec.get(fld)+'';
                                    logsList.add( new TransactionLogsC__c(
                                    FAFId__c = (Id)rec.get(fafField),
                                    TransactionBy__c= UserInfo.getUserId(),
                                    FafObject__c= sObjectLabel,
                                    TimeStamp__c = DateTime.now(),
                                    TransactionDetail__c = transDetail,
                                    TransactionType__c = transType,
                                    RecordName__c = ''+rec.get('Name'),
                                    UserProfile__c= profileName,
                                    RecordId__c = rec.Id
                                    ) );
                                }
                            }
                    }
                    else if(  fld == 'Approved_By_Sales__c' && 
//                    rec.Approved_By_Sales__c == false && oldRec.Approved_By_Sales__c == true )
                    rec.Approved_By_Sales__c == false && oldRec.Approved_By_Sales__c == true && rec.Source_Copy_FAF_Status__c != 'Disable Validations' )
                    {
                        //rec.FAF_Status__c == oldRec.FAF_Status__c &&
                        logsList.add( new TransactionLogsC__c(
                            FAFId__c = (Id)rec.get(fafField),
                            TransactionBy__c= UserInfo.getUserId(),
                            FafObject__c= sObjectLabel,
                            TimeStamp__c = DateTime.now(),
                            TransactionDetail__c = Label.TransactionDetailSR,
                            TransactionType__c = Label.TransactionTypeSR,
                            RecordName__c = ''+rec.get('Name'),
                            UserProfile__c= profileName,
                            RecordId__c = rec.Id
                        ) );
                        
                        
  
                    }
                    else if(  fld == 'Approved_By_Sales__c' 
                        && rec.Approved_By_Sales__c == true && oldRec.Approved_By_Sales__c == false )
                        
                    {
                        
                        Id fafId = (Id)rec.get(fafField);
                        if( !fafMap.containsKey(fafId) ){
                            logsList.add( new TransactionLogsC__c(
                                FAFId__c = (Id)rec.get(fafField),
                                TransactionBy__c= UserInfo.getUserId(),
                                FafObject__c= sObjectLabel,
                                TimeStamp__c = DateTime.now(),
                                TransactionDetail__c = 'Approved',
                                TransactionType__c = Label.TransactionTypeSR,
                                RecordName__c = ''+rec.get('Name'),
                                UserProfile__c= profileName,
                                RecordId__c = rec.Id
                            ) );
                            
                            logsList.add( new TransactionLogsC__c(
                                FAFId__c = (Id)rec.get(fafField),
                                TransactionBy__c= UserInfo.getUserId(),
                                FafObject__c= sObjectLabel,
                                TimeStamp__c = DateTime.now(),
                                TransactionDetail__c = 'Sales Approved',
                                TransactionType__c = 'FAF Status Updated to',
                                RecordName__c = ''+rec.get('Name'),
                                UserProfile__c= profileName,
                                RecordId__c = rec.Id
                            ) ); 
                            
                        }
                       
                    }  
                    
                    
                    else if(  fld == 'Peer_Reviewed__c' 
//                    && rec.Peer_Reviewed__c  == false && oldRec.Peer_Reviewed__c == true )
                    && rec.Peer_Reviewed__c  == false && oldRec.Peer_Reviewed__c == true && rec.Source_Copy_FAF_Status__c != 'Disable Validations')
                    {
                        logsList.add( new TransactionLogsC__c(
                            FAFId__c = (Id)rec.get(fafField),
                            TransactionBy__c= UserInfo.getUserId(),
                            FafObject__c= sObjectLabel,
                            TimeStamp__c = DateTime.now(),
                            TransactionDetail__c = Label.TransactionDetailPR,
                            TransactionType__c = Label.TransactionType,
                            RecordName__c = ''+rec.get('Name'),
                            UserProfile__c= profileName,
                            RecordId__c = rec.Id
                        ) );
                        
                            logsList.add( new TransactionLogsC__c(
                            FAFId__c = (Id)rec.get(fafField),
                            TransactionBy__c= UserInfo.getUserId(),
                            FafObject__c= sObjectLabel,
                            TimeStamp__c = DateTime.now(),
                            TransactionDetail__c ='Draft',
                            TransactionType__c = 'FAF Status Updated to',
                            RecordName__c = ''+rec.get('Name'),
                            UserProfile__c= profileName,
                            RecordId__c = rec.Id
                        ) );                        

                    }
                    

                    else if(  fld == 'Peer_Reviewed__c' 
                    && rec.Peer_Reviewed__c  == true && oldRec.Peer_Reviewed__c == false )
                    {
                        Id fafId = (Id)rec.get(fafField);
                        if( !fafMap.containsKey(fafId) ){
                        logsList.add( new TransactionLogsC__c(
                            FAFId__c = (Id)rec.get(fafField),
                            TransactionBy__c= UserInfo.getUserId(),
                            FafObject__c= sObjectLabel,
                            TimeStamp__c = DateTime.now(),
                            TransactionDetail__c = 'Approved',
                            TransactionType__c = Label.TransactionType,
                            RecordName__c = ''+rec.get('Name'),
                            UserProfile__c= profileName,
                            RecordId__c = rec.Id
                        ) );
                        
                            logsList.add( new TransactionLogsC__c(
                                FAFId__c = (Id)rec.get(fafField),
                                TransactionBy__c= UserInfo.getUserId(),
                                FafObject__c= sObjectLabel,
                                TimeStamp__c = DateTime.now(),
                                TransactionDetail__c = 'Sales Review',
                                TransactionType__c = 'FAF Status Updated to',
                                RecordName__c = ''+rec.get('Name'),
                                UserProfile__c= profileName,
                                RecordId__c = rec.Id
                            ) );                        
                        }
                    }                    
                }
            }
        }
        else if( sObjectName == 'Platform_Specifics__c' )
        {
            
            list<Platform_Specifics__c> psList = ( operation == 'delete' ) ? oldMap.values() : newMap.values();
            set<Id> levelIdSet = new set<Id>();
            for( Platform_Specifics__c rec : psList )
            {
                levelIdSet.add( rec.Level_1_Record_ID__c);
                levelIdSet.add( rec.Level_2_record_ID__c );
                levelIdSet.add( rec.Level_3_record_ID__c );
            }
            map<Id,CAG__c> cagMap = new map<Id,CAG__c>([SELECT Id, Name, Carrier_ID__c,Group_ID__c,Account_ID__c FROM CAG__c WHERE Id IN:levelIdSet]);
            
            for( Platform_Specifics__c rec : psList )
            {
                System.debug(rec.Id);
                System.debug(oldMap);
                Platform_Specifics__c oldrec;
                if( operation == 'insert') {
                    oldrec= new Platform_Specifics__c();
                } else {
                    oldrec= oldMap.containsKey(rec.Id) ?  (Platform_Specifics__c)oldMap.get(rec.Id) : new Platform_Specifics__c();
                }
                
                if( operation == 'insert' || operation == 'delete' || 
                (  rec.Level_1_Record_ID__c <> oldrec.Level_1_Record_ID__c  ) ||
                (  rec.Level_2_record_ID__c <> oldrec.Level_2_record_ID__c  ) ||
                (  rec.Level_3_record_ID__c <> oldrec.Level_3_record_ID__c  ) ||
                (  rec.Instruction__c <> oldrec.Instruction__c  ) ||
                (  rec.Platform__c <> oldrec.Platform__c  )  )
                {
                    //sObject oldRec = oldMap.get(rec.Id);
                    string[] levels = new string[]{};
                    for( string fld : new string[]{'Level_1_ID__c','Level_2_ID__c','Level_3_ID__c'} )
                    {

                    }
                    
                    string transType = rec.Name+' '+(operation == 'insert' ? 'Add': ( operation == 'update' ? 'Update' : 'Delete' ));
                    string transDetail = rec.Instruction__c+'-'+rec.Platform__c+' '
                                        +(rec.Level_1_ID__c <> null ? rec.Level_1_ID__c:'') +' : '
                                        +(rec.Level_2_ID__c <> null ? rec.Level_2_ID__c:'') +' : '
                                        +(rec.Level_3_ID__c <> null ? rec.Level_3_ID__c:'') +'  ';
                    
                    logsList.add( new TransactionLogsC__c(
                                    FAFId__c = (Id)rec.get(fafField),
                                    TransactionBy__c= UserInfo.getUserId(),
                                    FafObject__c= sObjectLabel,
                                    TimeStamp__c = DateTime.now(),
                                    TransactionDetail__c = transDetail,
                                    TransactionType__c = transType,
                                    RecordName__c = ''+rec.get('Name'),
                                    UserProfile__c= profileName,
                                    RecordId__c = rec.Id
                                ) );
                }
            }
                
        }
        

        else if( sObjectName == 'Apttus_Approval__Approval_Request__c' )
        {
           
            for( sObject rec : newMap.values() )
            {
                Apttus_Approval__Approval_Request__c arObj = (Apttus_Approval__Approval_Request__c)rec;
                Apttus_Approval__Approval_Request__c arObjOld = oldMap <> null ? (Apttus_Approval__Approval_Request__c)oldMap.get(arObj.Id) : null;
                
                string transType;
                string transDetail;
                string objectname;
                string transBy;
                string profiles= arObj.Profile_name__c;
                
                    
                if( arObj.Related_FAF__c <> null 
                    && ( arObj.Apttus_Approval__Step_Name__c == 'Peer Review'  )
                  || arObj.Apttus_Approval__Step_Name__c == 'Sales Review'
                  )
                { 
                    if( arObj.Approval_Status__c == 'Approved' || arObj.Approval_Status__c =='Approved with Updates'||
                    arObj.Approval_Status__c == 'Rejected' ||arObj.Approval_Status__c == 'Manually Approved' )
                    {
                        transType ='FAF '+ arObj.Apttus_Approval__Step_Name__c;
                        objectname=sObjectLabel;
                        transBy=arObj.Apttus_Approval__Actual_Approver__c;
                        if( arObj.Approval_Status__c == 'Rejected'  )
                            transDetail = 'Rejected';
                       else if( arObj.Approval_Status__c == 'Manually Approved')
                            transDetail = 'Approved';     
                        else    
                        transDetail = arObj.Apttus_Approval__Approver_Comments__c <> null 
                            && arObj.Apttus_Approval__Approver_Comments__c.Contains ('Updates:') ? 
                            'Approved with Updates' : 'Approved';
                            UtilClass.logTransactionHistoryFlagAppReq = false;
                       
                    }
                    
                    else if( (operation == 'insert' && 
                    arObj.Apttus_Approval__DateAssigned__c <> null && arObj.Apttus_Approval__StepLabel__c == 'Salesperson') || 
                    (arObjOld <> null && arObjOld.Apttus_Approval__DateAssigned__c == null && arObj.Apttus_Approval__DateAssigned__c <> null &&arObj.Apttus_Approval__StepLabel__c == 'Peer Reviewer') 
                    ||(arObjOld <> null && arObjOld.Apttus_Approval__DateAssigned__c == null && arObj.Apttus_Approval__DateAssigned__c <> null &&arObj.Apttus_Approval__StepLabel__c == 'Salesperson') )
                    {
                       transType = Label.FAFrelease;
                       transBy=UserInfo.getUserId();
                       profiles=profileName; 
                       transDetail = 'Created for '+arObj.Apttus_Approval__Step_Name__c;
                       objectname=sObjectLabel;
                    }
                }
                

                else if( (operation == 'insert' &&
                    arObj.Apttus_Approval__DateAssigned__c <> null && arObj.Apttus_Approval__StepLabel__c == 'FAF MChoice Contract') || 
                    (arObjOld <> null && arObjOld.Apttus_Approval__DateAssigned__c == null && arObj.Apttus_Approval__DateAssigned__c <> null 
                     &&arObj.Apttus_Approval__StepLabel__c == 'FAF MChoice Contract') ) 
                    {
                       transType = 'MChoice LOA Request ';
                       transBy=UserInfo.getUserId();
                       profiles=profileName; 
                       transDetail = 'Created for  Master Client Maintenance Choice LOA';
                       objectname='Client Information';
                    }
                else if( 
                    (operation == 'insert' &&
                    arObj.Apttus_Approval__DateAssigned__c <> null && arObj.Apttus_Approval__StepLabel__c == 'CC:Underwriter') || 
                    (arObjOld <> null && arObjOld.Apttus_Approval__DateAssigned__c == null && arObj.Apttus_Approval__DateAssigned__c <> null 
                     &&arObj.Apttus_Approval__StepLabel__c == 'CC:Underwriter' && 
                     (arObj.Apttus_Approval__Step_Name__c == 'FAF Release for \'Implementation\''
                     || arObj.Apttus_Approval__Step_Name__c == 'FAF Re-release for \'Implementation\'')
                     ) ) 
                    {
                       if(arObj.Apttus_Approval__Step_Name__c == 'FAF Re-release for \'Implementation\''){    
                       transType = 'FAF Re-Released E-mail ';
                       transDetail = 'Re-Released to Implementation';
                       }
                       else{
                       transType = 'FAF Released E-mail ';
                       transDetail = 'Created for Implementation';
                       }
                       transBy=UserInfo.getUserId();
                       profiles=profileName;
                       objectname='FAF';
                    }                    
                    
                else if( (operation == 'insert' &&
                    arObj.Apttus_Approval__DateAssigned__c <> null && arObj.Apttus_Approval__StepLabel__c == 'CC:Underwriter') || 
                    (arObjOld <> null && arObjOld.Apttus_Approval__DateAssigned__c == null && arObj.Apttus_Approval__DateAssigned__c <> null 
                     &&arObj.Apttus_Approval__StepLabel__c == 'CC:Underwriter' && arObj.Apttus_Approval__Step_Name__c=='FAF Release SAAS for Implementation'
                     &&(arObjOld.RELEASED_DATE_PREVIOUS_FROM_FAF__c<>null||arObjOld.RELEASED_DATE_PREVIOUS_FROM_FAF__c==null) )
                     ||
                     arObjOld <> null && arObjOld.Apttus_Approval__DateAssigned__c == null && arObj.Apttus_Approval__DateAssigned__c <> null 
                     &&arObj.Apttus_Approval__StepLabel__c == 'CC:Underwriter' && arObj.Apttus_Approval__Step_Name__c=='FAF Release SAAS TPA Master'
                     &&(arObjOld.RELEASED_DATE_PREVIOUS_FROM_FAF__c<>null||arObjOld.RELEASED_DATE_PREVIOUS_FROM_FAF__c==null)) 
                     {
                     if(arObjOld.RELEASED_DATE_PREVIOUS_FROM_FAF__c==null)
                     {
                         
                         transType = Label.FAFrelease;
                         transDetail = 'Created for Master Client Platform ID Add or Update';
                         
                     }
                     else{
                         transType='FAF Re-Released E-mail ';
                         transDetail=' Master Client Platform ID Add or Update';
                         
                     }
                    {
                       
                       transBy=UserInfo.getUserId();
                       profiles=profileName; 
                       
                       objectname='Client Information';
                    }  }                  
                    
                    if(transType<>null && transDetail <> null)
                    
                    logsList.add( new TransactionLogsC__c(
                                    FAFId__c = (Id)rec.get(fafField),
                                    //TransactionBy__c= UserInfo.getUserId(),
                                    TransactionBy__c =transBy,
                                    FafObject__c= objectname,
                                    TimeStamp__c = DateTime.now(),
                                    
                                    TransactionDetail__c = transDetail,
                                    TransactionType__c = transType,
                                    RecordName__c = ''+rec.get('Name'),
                                   // UserProfile__c= profileName,
                                   UserProfile__c=profiles,
                                    RecordId__c = rec.Id
                                ) );
                    
            }
        }
        
        if(logsList != null && !logsList.isEmpty() && !Test.isRunningTest() ){
            database.insert(logsList);
            if( sObjectName == 'Central_Hub__c'  ){
                UtilClass.logTransactionHistoryFlag = false;
            }
        }   
            system.debug('log2________'+logsList);
    } 
    //_____________________________________________________________________________________________
            
}