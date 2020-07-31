@isTest
private class NetworkPricingTriggerHelperTest{
    public static testMethod void NetworkPricingTriggerHelperMethod(){
        Central_Hub__c faf = new Central_Hub__c();
       
        List<Network_Pricing__c> npList = new List<Network_Pricing__c>();
        List<Network_Pricing__c> npList1 = new List<Network_Pricing__c>();
        List<Retail_Network_Guarantees__c> rnList =new List<Retail_Network_Guarantees__c>();
        //Old map and new map for Network_Pricing__c 
        Map<id,Network_Pricing__c > oldMap= new Map<id,Network_Pricing__c >();
        Map<id,Network_Pricing__c > newMap= new Map<id,Network_Pricing__c >();
        
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
       
        System.runAs(useObj){
        
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            Client_Information__c clientINFO= TestDataFactory.createClientInfo(FAFObj.id);
            insert clientINFO;
          
            clientINFO=[select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
                                             Client_Information__c where FAF_ID__c =:FAFObj.id limit 1];
                
            clientINFO.year_1__c='1';
            clientINFO.Year_1_Begin_Date__c=Date.newInstance(2018,7, 1);
            clientINFO.Year_1_End_Date__c=Date.newInstance(2018, 7,7 );
            
            clientINFO.year_2__c='2';
            clientINFO.Year_2_Begin_Date__c=Date.newInstance(2018,7, 8);
            clientINFO.Year_2_End_Date__c=Date.newInstance(2018,7, 14);
            
            clientINFO.year_3__c='3';
            clientINFO.Year_3_Begin_Date__c=Date.newInstance(2018,7,15);
            clientINFO.Year_3_End_Date__c=Date.newInstance(2018,7,21);
            
            clientINFO.year_4__c='4';
            clientINFO.Year_4_Begin_Date__c=Date.newInstance(2018,7,22);
            clientINFO.Year_4_End_Date__c=Date.newInstance(2018,7,28);
            
            clientINFO.year_5__c='5';
            clientINFO.Year_5_Begin_Date__c=Date.newInstance(2018,7,29);
            clientINFO.Year_5_End_Date__c=Date.newInstance(2018,8,4);
            update clientINFO;
            
            Network_Operations__c nOps = TestDataFactory.createNetworkOperation(FAFObj.id);
            nOps.Client__c = 'Lower of Discount or U&C or MAC';
            insert nOps;
           
          
    
            Network_Pricing__c np2 =TestDataFactory.createntwrkPricing(FAFObj.id,nOps.id);
            np2.MER_Guarantee_Rate__c=2.0;
            np2.NED_Guarantee_Rate__c=2.0;
            np2.GER_Guarantee_Rate__c=2.0;
            np2.BER_Guarantee_Rate__c=2.0;
            np2.SSG_Guarantee_Rate__c=2.0;
            np2.Invokable_Update__c=true;
            np2.Batch_Update__c=false;
            np2.FAF_Network_Ops__c=nOps.id;
            //np2.Custom_Network_Description__c=NULL;
            //npList.add(np2);
            //insert npList; 
            
            
             Network_Pricing__c np1 = TestDataFactory.createntwrkPricing(FAFObj.id,nOps.id);
            np1.Network_Name__c='Custom Secondary';
            np1.MER_Guarantee_Rate__c=1.0;
            np1.NED_Guarantee_Rate__c=1.0;
            np1.GER_Guarantee_Rate__c=1.0;
            np1.BER_Guarantee_Rate__c=1.0;
            np1.SSG_Guarantee_Rate__c=3.0;
            np1.Invokable_Update__c=true;
            np1.Batch_Update__c=false;
           // np1.FAF_Network_Ops__c=nOps.id;
           np1.Custom_Network_Description__c='test';
            npList.add(np2);
           npList.add(np1);
            insert npList; 
           
            
            for(Network_Pricing__c npt:npList){
            oldMap.put(npt.id,npt );
            }
            Retail_Network_Guarantees__c ng = TestDataFactory.createretntwrkGuarnt(FAFObj.id,npList[0].Id );
            ng.Type__c = 'MER';
            ng.SSG__c = 'No';
           // ng.BER_Guarantee_Rate__c=25; 
            rnList.add(ng);    
            
            Retail_Network_Guarantees__c ng1 = TestDataFactory.createretntwrkGuarnt(FAFObj.id,npList[0].Id );
            ng1.Type__c = 'BER';
            ng1.SSG__c = 'No'; 
            //ng1.BER_Guarantee_Rate__c=26;
            rnList.add(ng1); 
            
            Retail_Network_Guarantees__c ng2 = TestDataFactory.createretntwrkGuarnt(FAFObj.id,npList[0].Id );
            ng2.Type__c = 'GER';
            ng2.SSG__c = 'No';
            //ng2.BER_Guarantee_Rate__c=27; 
           // ng2.Mirror_Mail_Guarantees__c = true; 
            rnList.add(ng2); 
            
            Retail_Network_Guarantees__c ng3 = TestDataFactory.createretntwrkGuarnt(FAFObj.id,npList[0].Id );
            ng3.Type__c = 'NED';
            ng3.SSG__c = 'No'; 
            //ng3.Mirror_Mail_Guarantees__c = true; 
            //ng3.BER_Guarantee_Rate__c=28;
            rnList.add(ng3);    
            
            Retail_Network_Guarantees__c ng4 = TestDataFactory.createretntwrkGuarnt(FAFObj.id,npList[0].Id );
            ng4.Type__c = 'SSG';
            ng4.SSG__c = 'No'; 
            //ng4.Mirror_Mail_Guarantees__c = true; 
            //ng4.BER_Guarantee_Rate__c=58;
            rnList.add(ng4);  
            
            insert rnList; 
            for(Network_Pricing__c npp:npList){
            npp.MER_Guarantee_Rate__c=8.0;
            npp.NED_Guarantee_Rate__c=8.0;
            npp.GER_Guarantee_Rate__c=8.0;
            npp.BER_Guarantee_Rate__c=8.0;
            npp.SSG_Guarantee_Rate__c=8.0;
            npList1.add(npp);
            }
            //update npList1;
                  
            for(Network_Pricing__c npt:npList1){
            newMap.put(npt.id,npt);
            }
            system.debug('*******newMapnewMap*****'+newMap);
            System.debug('************oldMap oldMap oldMap oldMap *************'+oldMap);
            Test.StartTest();
            NetworkPricingTriggerHelper.ProcessNetworkpricing(oldMap,newmap,npList);
            NetworkPricingTriggerHelper.validateNoOfRecords(npList,true,false);
            NetworkPricingTriggerHelper.validateNoOfRecords(npList,false,true);
            NetworkPricingTriggerHelper.validateLobYearName(npList,false,true);
            NetworkPricingTriggerHelper.validateLobYearName(npList,true,false);
            Test.StopTest();
        }
    }
      public static testMethod void NetworkPricingTriggerHelperMethod2(){
        Central_Hub__c faf = new Central_Hub__c();
       
        List<Network_Pricing__c> npList = new List<Network_Pricing__c>();
        List<Network_Pricing__c> npList2 = new List<Network_Pricing__c>();
        List<Network_Pricing__c> npList1 = new List<Network_Pricing__c>();
        List<Retail_Network_Guarantees__c> rnList =new List<Retail_Network_Guarantees__c>();
        //Old map and new map for Network_Pricing__c 
        Map<id,Network_Pricing__c > oldMap= new Map<id,Network_Pricing__c >();
        Map<id,Network_Pricing__c > newMap= new Map<id,Network_Pricing__c >();
        
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
       
        System.runAs(useObj){
        
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            
            Central_Hub__c FAFObj1 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj1;
            
            Central_Hub__c FAFObj2 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj2;
            
            Client_Information__c clientINFO= TestDataFactory.createClientInfo(FAFObj.id);
            insert clientINFO;
          
            clientINFO=[select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
                                             Client_Information__c where FAF_ID__c =:FAFObj.id limit 1];
                
            clientINFO.year_1__c='1';
            clientINFO.Year_1_Begin_Date__c=Date.newInstance(2018,7, 1);
            clientINFO.Year_1_End_Date__c=Date.newInstance(2018, 7,7 );
            
            clientINFO.year_2__c='2';
            clientINFO.Year_2_Begin_Date__c=Date.newInstance(2018,7, 8);
            clientINFO.Year_2_End_Date__c=Date.newInstance(2018,7, 14);
            
            clientINFO.year_3__c='3';
            clientINFO.Year_3_Begin_Date__c=Date.newInstance(2018,7,15);
            clientINFO.Year_3_End_Date__c=Date.newInstance(2018,7,21);
            
            clientINFO.year_4__c='4';
            clientINFO.Year_4_Begin_Date__c=Date.newInstance(2018,7,22);
            clientINFO.Year_4_End_Date__c=Date.newInstance(2018,7,28);
            
            clientINFO.year_5__c='5';
            clientINFO.Year_5_Begin_Date__c=Date.newInstance(2018,7,29);
            clientINFO.Year_5_End_Date__c=Date.newInstance(2018,8,4);
            update clientINFO;
            
            Network_Operations__c nOps = TestDataFactory.createNetworkOperation(FAFObj.id);
            nOps.Client__c = 'Lower of Discount or U&C or MAC';
            insert nOps;
           
            Network_Operations__c nOps2 = TestDataFactory.createNetworkOperation(FAFObj1.id);
            nOps2.Client__c = 'Lower of Discount or U&C or MAC';
            insert nOps2;
            
             Network_Operations__c nOps3= TestDataFactory.createNetworkOperation(FAFObj2.id);
            nOps3.Client__c = 'Lower of Discount or U&C or MAC';
            insert nOps3;
    
            Network_Pricing__c np2 =TestDataFactory.createntwrkPricing(FAFObj.id,nOps.id);
            np2.MER_Guarantee_Rate__c=2.0;
            np2.NED_Guarantee_Rate__c=2.0;
            np2.GER_Guarantee_Rate__c=2.0;
            np2.BER_Guarantee_Rate__c=2.0;
            np2.SSG_Guarantee_Rate__c=2.0;
            np2.Invokable_Update__c=true;
            np2.Batch_Update__c=false;
            np2.FAF_Network_Ops__c=nOps.id;
            //np2.Custom_Network_Description__c=NULL;
            //npList.add(np2);
            //insert npList; 
            
            
             Network_Pricing__c np1 = TestDataFactory.createntwrkPricing(FAFObj1.id,nOps2.id);
            np1.Network_Name__c='Custom Secondary';
            np1.MER_Guarantee_Rate__c=1.0;
            np1.NED_Guarantee_Rate__c=1.0;
            np1.GER_Guarantee_Rate__c=1.0;
            np1.BER_Guarantee_Rate__c=1.0;
            np1.SSG_Guarantee_Rate__c=3.0;
            np1.Invokable_Update__c=true;
            np1.Batch_Update__c=false;
            np1.FAF_Network_Ops__c=nOps2.id;
           np1.Custom_Network_Description__c='test';
           
           
           
            Network_Pricing__c np3 = TestDataFactory.createntwrkPricing(FAFObj2.id,nOps3.id);
            np3.Network_Name__c='Custom Secondary';
            np3.MER_Guarantee_Rate__c=1.0;
            np3.NED_Guarantee_Rate__c=1.0;
            np3.GER_Guarantee_Rate__c=1.0;
            np3.BER_Guarantee_Rate__c=1.0;
            np3.SSG_Guarantee_Rate__c=3.0;
            np3.Invokable_Update__c=true;
            np3.Batch_Update__c=false;
            np3.FAF_Network_Ops__c=nOps3.id;
            np3.Custom_Network_Description__c='test';
           
            npList.add(np2);
            npList.add(np3);
            npList.add(np1);
            insert npList; 
            
            
           
            
            for(Network_Pricing__c npt:npList){
            oldMap.put(npt.id,npt );
            }
            Retail_Network_Guarantees__c ng = TestDataFactory.createretntwrkGuarnt(FAFObj.id,npList[0].Id );
            ng.Type__c = 'MER';
            ng.SSG__c = 'No';
           // ng.BER_Guarantee_Rate__c=25; 
            rnList.add(ng);    
            
            Retail_Network_Guarantees__c ng1 = TestDataFactory.createretntwrkGuarnt(FAFObj.id,npList[0].Id );
            ng1.Type__c = 'BER';
            ng1.SSG__c = 'No'; 
            //ng1.BER_Guarantee_Rate__c=26;
            rnList.add(ng1); 
            
            Retail_Network_Guarantees__c ng2 = TestDataFactory.createretntwrkGuarnt(FAFObj.id,npList[0].Id );
            ng2.Type__c = 'GER';
            ng2.SSG__c = 'No';
            //ng2.BER_Guarantee_Rate__c=27; 
           // ng2.Mirror_Mail_Guarantees__c = true; 
            rnList.add(ng2); 
            
            Retail_Network_Guarantees__c ng3 = TestDataFactory.createretntwrkGuarnt(FAFObj.id,npList[0].Id );
            ng3.Type__c = 'NED';
            ng3.SSG__c = 'No'; 
            //ng3.Mirror_Mail_Guarantees__c = true; 
            //ng3.BER_Guarantee_Rate__c=28;
            rnList.add(ng3);    
            
            Retail_Network_Guarantees__c ng4 = TestDataFactory.createretntwrkGuarnt(FAFObj.id,npList[0].Id );
            ng4.Type__c = 'SSG';
            ng4.SSG__c = 'No'; 
            //ng4.Mirror_Mail_Guarantees__c = true; 
            //ng4.BER_Guarantee_Rate__c=58;
            rnList.add(ng4);  
            
            insert rnList; 
            for(Network_Pricing__c npp:npList){
            npp.MER_Guarantee_Rate__c=8.0;
            npp.NED_Guarantee_Rate__c=8.0;
            npp.GER_Guarantee_Rate__c=8.0;
            npp.BER_Guarantee_Rate__c=8.0;
            npp.SSG_Guarantee_Rate__c=8.0;
            npList1.add(npp);
            }
            //update npList1;
                  
            for(Network_Pricing__c npt:npList1){
            newMap.put(npt.id,npt);
            }
            system.debug('*******newMapnewMap*****'+newMap);
            System.debug('************oldMap oldMap oldMap oldMap *************'+oldMap);
            Test.StartTest();
            //NetworkPricingTriggerHelper.ProcessNetworkpricing(oldMap,newmap,npList);
            //NetworkPricingTriggerHelper.validateNoOfRecords(npList2,true,false);
            //system.debug('***********npList2********'+npList2[0].FAF_Network_Ops__c);
            //NetworkPricingTriggerHelper.validateNoOfRecords(npList2,false,true);
            NetworkPricingTriggerHelper.validateLobYearName(npList,false,true);
            NetworkPricingTriggerHelper.validateLobYearName(npList,true,false);
            Test.StopTest();
        }
    }
    
      public static testMethod void NetworkPricingTriggerHelperMethod3(){
        Central_Hub__c faf = new Central_Hub__c();
       
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
       
        System.runAs(useObj){
        
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            
            Client_Information__c clientINFO= TestDataFactory.createClientInfo(FAFObj.id);
            insert clientINFO;
          
            clientINFO=[select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
                                             Client_Information__c where FAF_ID__c =:FAFObj.id limit 1];
                
            clientINFO.year_1__c='1';
            clientINFO.Year_1_Begin_Date__c=Date.newInstance(2018,7, 1);
            clientINFO.Year_1_End_Date__c=Date.newInstance(2018, 7,7 );
            
            clientINFO.year_2__c='2';
            clientINFO.Year_2_Begin_Date__c=Date.newInstance(2018,7, 8);
            clientINFO.Year_2_End_Date__c=Date.newInstance(2018,7, 14);
            
            clientINFO.year_3__c='3';
            clientINFO.Year_3_Begin_Date__c=Date.newInstance(2018,7,15);
            clientINFO.Year_3_End_Date__c=Date.newInstance(2018,7,21);
            
            clientINFO.year_4__c='4';
            clientINFO.Year_4_Begin_Date__c=Date.newInstance(2018,7,22);
            clientINFO.Year_4_End_Date__c=Date.newInstance(2018,7,28);
            
            clientINFO.year_5__c='5';
            clientINFO.Year_5_Begin_Date__c=Date.newInstance(2018,7,29);
            clientINFO.Year_5_End_Date__c=Date.newInstance(2018,8,4);
            update clientINFO;
            
            Network_Operations__c nOps = TestDataFactory.createNetworkOperation(FAFObj.id);
            nOps.Client__c = 'Lower of Discount or U&C or MAC';
            insert nOps;
           
            Network_Pricing__c np1 = TestDataFactory.createntwrkPricing(FAFObj.id,nOps.id);
            np1.Network_Name__c='Custom Secondary';
            np1.MER_Guarantee_Rate__c=1.0;
            np1.NED_Guarantee_Rate__c=1.0;
            np1.GER_Guarantee_Rate__c=1.0;
            np1.BER_Guarantee_Rate__c=1.0;
            np1.SSG_Guarantee_Rate__c=3.0;
            np1.Invokable_Update__c=true;
            np1.Batch_Update__c=false;
           np1.Custom_Network_Description__c='test';
           np1.Retail_Network_Ordinal__c ='Secondary';
           insert np1;
           
           Test.StartTest();
           
           TPA_Form__c tpafrm= new TPA_Form__c();
           tpafrm.Client_Info_ID__c=clientINFO.id;
           tpafrm.GOVCLP_Network_VA_Claims_1_90_day_supp__c='No';
           tpafrm.MDCAID_Network_Government_Paper_Claims__c='No';
           tpafrm.C_A_G__c='CAG 5';
           tpafrm.Client_Code__c='CAG 5';
           tpafrm.CLIENT_NAME__c='CAG 5';
           insert tpafrm;
           
           np1.Network_Name__c='MC(84-90)CVS';
           update np1;
           
           Network_Pricing__c np2 = TestDataFactory.createntwrkPricing(FAFObj.id,nOps.id);
            np2.Network_Name__c='MC(84-90)CVS';
            insert np2;
            
            np2.Network_Name__c='Custom Secondary';
            np1.MER_Guarantee_Rate__c=1.0;
            np1.NED_Guarantee_Rate__c=1.0;
            np1.GER_Guarantee_Rate__c=1.0;
            np1.BER_Guarantee_Rate__c=1.0;
            np1.SSG_Guarantee_Rate__c=3.0;
            np1.Invokable_Update__c=true;
            np1.Batch_Update__c=false;
           update np2;
           
            Test.StopTest();
        }
    }
 }