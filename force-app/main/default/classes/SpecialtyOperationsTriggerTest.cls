@isTest
private class SpecialtyOperationsTriggerTest{
    @isTest static void SpecialtyOperationsm1() {
         
        Account acct = TestDataFactory.createAccount();  
        acct.Market_Segment__c='Employer';     
        insert acct;
        
        Opportunity opp = TestDataFactory.createOpportunity(acct.Id);
        insert opp;     
        
        Central_Hub__c FAF = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
        FAF.Salesperson__c= null;
        FAF.Network_Operations__c= true;
        FAF.Specialty_Operations__c= true;
        FAF.Mail_Operations__c= true;
        insert FAF;
        
         Central_Hub__c FAF1 = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
        FAF1.Salesperson__c= null;
        FAF1.Network_Operations__c= true;
        FAF1.Specialty_Operations__c= true;
        FAF1.Mail_Operations__c= true;
        insert FAF1;
           
                
                Client_Information__c ClientInformation = TestDataFactory.createClientInfo(FAF.Id);
                Insert ClientInformation;
                
                Rebate_Operations__c createRebOps=TestDataFactory.createRebOps(FAF.Id);
                insert createRebOps;
                createRebOps.Non_Specialty_Formulary_Option__c='Client Choice';
                createRebOps.GSTP_Option__c='Choice';
                createRebOps.Specialty_Formulary_Option__c='Client Choice';
                update createRebOps;
                List<Platform_Specifics__c> Platlist =new List<Platform_Specifics__c>();
                // CAG__c cg =TestDataFactory.createCAG('C','RxClaim');
                 //cg.Carrier_ID__c=ps.Level_1_ID_XAE__c;
                 
                 //insert cg;
                
                CAG__c cg =TestDataFactory.createCAG('C','RxClaim');
                cg.Carrier_ID__c='Test';
                cg.Record_Type__c='C';
                cg.Platform_Name__c='RxCLAIM';
                insert cg;
                
                CAG__c cg1 =TestDataFactory.createCAG('A','RxClaim');
                cg1.Account_ID__c='Test2';
                cg1.Carrier_ID__c='Test';
                cg1.Record_Type__c='A';
                cg1.Platform_Name__c='RxCLAIM';
                //insert cg1;
                
                CAG__c cag1 = new CAG__c();
                cag1.CAG_ID__c = '12345678901';
                cag1.Carrier_ID__c = 'Test';
                cag1.Non_Validated_CAG__c = true;
                cag1.Platform_Name__c ='RxCLAIM';
                cag1.Record_Type__c='A';
                cag1.Account_ID__c='Test1';
                cag1.RecordTypeId = [select id from RecordType where Name ='A'].Id;
                insert cag1;
                
                 CAG__c cag2 = new CAG__c();
                cag2.CAG_ID__c = '123456789071';
                cag2.Carrier_ID__c = 'Test';
                cag2.Non_Validated_CAG__c = true;
                cag2.Platform_Name__c ='RxCLAIM';
                cag2.Record_Type__c='G';
                cag2.Account_ID__c='Test1';
                cag2.Group_ID__c='Test2';
                cag2.RecordTypeId = [select id from RecordType where Name ='G'].Id;
                insert cag2;
                
                 
                Platform_Specifics__c ps = TestDataFactory.createPlatFormSpecificManagement();
                ps.FAF_Client_Information__c = ClientInformation.Id;
                ps.Rebate_Operations__c=createRebOps.id;
                ps.LOB__c='STD';
                ps.CAG_ID__c='A'; 
                ps.FAF_Client_Information__c=ClientInformation.id;
                ps.DeleteRow__c=false;
                ps.XAE__c= true;
                ps.Platform__c='RxCLAIM';
                ps.LOB__c='PDP';
                ps.Instruction__c='Include';
                ps.Level_1_ID_XAE__c='Test';
                ps.Level_2_ID_XAE__c='Test1';
                ps.Level_3_ID_XAE__c='Test2';
                ps.Specialty_Pharmacy_Benefit_Price_List__c='Exclusive (Retail Lockout)-Custom';
                Platlist.add(ps);
               insert Platlist; 
            
            List<Specialty_Operations__c> specilist=new List<Specialty_Operations__c>();
            Map<ID,Specialty_Operations__c> mapsec=new  Map<ID,Specialty_Operations__c>();
            Specialty_Operations__c so = new Specialty_Operations__c();
            so.FAF_ID__c = FAF.id;
            so.Billing_Type__c='Automatic';
            so.Medical_Benefit__c='Exclusive';
            so.Discount_Basis__c='Fixed';
            
            Specialty_Operations__c so1 = new Specialty_Operations__c();
            so1.FAF_ID__c = FAF1.id;
            so1.Billing_Type__c='Automatic';
            so1.Medical_Benefit__c='Exclusive';
            so1.Discount_Basis__c='Fixed';
            specilist.add(so);
            specilist.add(so1);
            insert specilist;
            
            for(Specialty_Operations__c mp:specilist){
            mapsec.put(mp.id,mp);
            }
                                                        
        Test.startTest();
            SpecialtyOperationsTriggerHelper.updatePlatfrmSpecific(specilist,mapsec);
            SpecialtyOperationsTriggerHelper.checkCountOnBeforeInsert(specilist);
            
            delete so;
            
        Test.stopTest();
       }    
       
       @isTest
       static void SpecialtyOperationsm2() {
         
                Account acct = TestDataFactory.createAccount();     
                insert acct;
                
                Opportunity opp = TestDataFactory.createOpportunity(acct.Id);
                insert opp;     
                
                Central_Hub__c FAF = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
                FAF.Salesperson__c= null;
                FAF.Network_Operations__c= true;
                FAF.Specialty_Operations__c= true;
                FAF.Mail_Operations__c= true;
                insert FAF;
                
                 Central_Hub__c FAF1 = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
                FAF1.Salesperson__c= null;
                FAF1.Network_Operations__c= true;
                FAF1.Specialty_Operations__c= true;
                FAF1.Mail_Operations__c= true;
                insert FAF1;
           
                
                Client_Information__c ClientInformation = TestDataFactory.createClientInfo(FAF.Id);
                Insert ClientInformation;
                
                Rebate_Operations__c createRebOps=TestDataFactory.createRebOps(FAF.Id);
                insert createRebOps;
                createRebOps.Non_Specialty_Formulary_Option__c='Client Choice';
                createRebOps.GSTP_Option__c='Choice';
                createRebOps.Specialty_Formulary_Option__c='Client Choice';
                update createRebOps;
                List<Platform_Specifics__c> Platlist =new List<Platform_Specifics__c>();
                // CAG__c cg =TestDataFactory.createCAG('C','RxClaim');
                 //cg.Carrier_ID__c=ps.Level_1_ID_XAE__c;
                 
                 //insert cg;
                
                CAG__c cg =TestDataFactory.createCAG('C','RxClaim');
                cg.Carrier_ID__c='Test';
                cg.Record_Type__c='C';
                cg.Platform_Name__c='RxCLAIM';
                insert cg;
                
                CAG__c cg1 =TestDataFactory.createCAG('A','RxClaim');
                cg1.Account_ID__c='Test2';
                cg1.Carrier_ID__c='Test';
                cg1.Record_Type__c='A';
                cg1.Platform_Name__c='RxCLAIM';
                //insert cg1;
                
                CAG__c cag1 = new CAG__c();
                cag1.CAG_ID__c = '12345678901';
                cag1.Carrier_ID__c = 'Test';
                cag1.Non_Validated_CAG__c = true;
                cag1.Platform_Name__c ='RxCLAIM';
                cag1.Record_Type__c='A';
                cag1.Account_ID__c='Test1';
                cag1.RecordTypeId = [select id from RecordType where Name ='A'].Id;
                insert cag1;
                
                 CAG__c cag2 = new CAG__c();
                cag2.CAG_ID__c = '123456789071';
                cag2.Carrier_ID__c = 'Test';
                cag2.Non_Validated_CAG__c = true;
                cag2.Platform_Name__c ='RxCLAIM';
                cag2.Record_Type__c='G';
                cag2.Account_ID__c='Test1';
                cag2.Group_ID__c='Test2';
                cag2.RecordTypeId = [select id from RecordType where Name ='G'].Id;
                insert cag2;
                
                 
                Platform_Specifics__c ps = TestDataFactory.createPlatFormSpecificManagement();
                ps.FAF_Client_Information__c = ClientInformation.Id;
                ps.Rebate_Operations__c=createRebOps.id;
                ps.LOB__c='STD';
                ps.CAG_ID__c='A'; 
                ps.FAF_Client_Information__c=ClientInformation.id;
                ps.DeleteRow__c=false;
                ps.XAE__c= true;
                ps.Platform__c='RxCLAIM';
                ps.LOB__c='PDP';
                ps.Instruction__c='Include';
                ps.Level_1_ID_XAE__c='Test';
                ps.Level_2_ID_XAE__c='Test1';
                ps.Level_3_ID_XAE__c='Test2';
                ps.Specialty_Pharmacy_Benefit_Price_List__c='Exclusive (Retail Lockout)-Custom';
                Platlist.add(ps);
               insert Platlist; 
            
            
            
            Specialty_Operations__c so = new Specialty_Operations__c();
            so.FAF_ID__c = FAF.id;
            so.Billing_Type__c='Automatic';
            so.Medical_Benefit__c='Exclusive';
            so.Discount_Basis__c='Fixed';
            
            insert so;
            
            so.Medical_Benefit__c ='Open';
            update so;
            
            
        Test.startTest();
        Field_History_Tracking__c fht=new Field_History_Tracking__c();
            fht.Specialty_Operations__c=true;
            delete so;
            
        Test.stopTest();
       }    
}