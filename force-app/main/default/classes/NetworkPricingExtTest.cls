/*********************************************************************************************
* @author   Sindhu Alati
* @date     18 09 2018
* @description:This is the testclass for the class NetworkPricingExt and NetworkPricingTriggerHelper  
 **********************************************************************************************/
@isTest
private class NetworkPricingExtTest {
    static Central_Hub__c faf = new Central_Hub__c();
    static Network_Operations__c nOps = new Network_Operations__c();
    static List<Network_Pricing__c> npList = new List<Network_Pricing__c>();
    
    static {
        User salesperson = TestDataFactory.createUser('Apttus Sales');
        insert salesperson;
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        
        System.runAs(useObj){
                
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            faf = TestDataFactory.createFAF(accObj.id, oppObj.Id, salesperson.Id);
            faf.FAF_Status__c = 'Draft';
            insert faf;
            Client_Information__c cInfo = TestDataFactory.createClientInfo(faf.id);
            /*Client_Information__c cInfo = [SELECT Id, Escalating_Pricing__c, Year_1__c, Year_2__c, Year_3__c, Year_4__c, Year_5__c,
                                           Year_1_Begin_Date__c, Year_2_Begin_Date__c, Year_3_Begin_Date__c, Year_4_Begin_Date__c,
                                           Year_5_Begin_Date__c, Year_1_End_Date__c, Year_2_End_Date__c, Year_3_End_Date__c, 
                                           Year_4_End_Date__c, Year_5_End_Date__c 
                                           FROM Client_Information__c WHERE FAF_ID__c=:faf.Id];*/
            cInfo.Escalating_Pricing__c = true;
            cInfo.Year_1__c = '1';
            cInfo.Year_1_Begin_Date__c = System.today();
            cInfo.Year_1_End_Date__c = System.today()+10;
            cInfo.Year_2__c = '2';
            cInfo.Year_2_Begin_Date__c = cInfo.Year_1_End_Date__c+1;
            cInfo.Year_2_End_Date__c = cInfo.Year_1_End_Date__c+10;        
            cInfo.Year_3__c = '3';
            cInfo.Year_3_Begin_Date__c = cInfo.Year_2_End_Date__c+1;
            cInfo.Year_3_End_Date__c = cInfo.Year_2_End_Date__c+10;        
            cInfo.Year_4__c = '4';
            cInfo.Year_4_Begin_Date__c = cInfo.Year_3_End_Date__c+1;
            cInfo.Year_4_End_Date__c = cInfo.Year_3_End_Date__c+10;        
            cInfo.Year_5__c = '5';
            cInfo.Year_5_Begin_Date__c = cInfo.Year_4_End_Date__c+1;
            cInfo.Year_5_End_Date__c = cInfo.Year_4_End_Date__c+10;        
            insert cInfo; 
            //update cInfo;
            
            nOps.FAF_Id__c = faf.Id;
            nOps.Client__c = 'Lower of Discount or U&C or MAC';
            insert nOps;
            
            Mail_Operations__c mOps = new Mail_Operations__c();
            mOps.FAF_ID__c = faf.Id;
            insert mOps;
            
            Mail_Pricing__c mp = new Mail_Pricing__c();
            mp.FAF_Mail_Operations__c = mOps.Id;
            mp.FAF_ID__c = faf.Id;
            mp.Year__c = 'All';
            mp.LOB__c = 'ACT';
            insert mp;
            
            Mail_Guarantees__c mg = new Mail_Guarantees__c();
            mg.FAF_Id__c = faf.Id;
            mg.Mail_Pricing__c = mp.Id;
            insert mg;
            
            Network_Pricing__c np1 = new Network_Pricing__c();
            np1.FAF_ID__c = faf.Id;
            np1.FAF_Network_Ops__c = nOps.Id;
            np1.Retail_Network_Ordinal__c = 'Primary';
            np1.Year__c = 'All';
            np1.LOB__c = 'ACT';
            np1.Network_Name__c = 'MC(84-90)CP';
            np1.Brand_Rate__c = 5;
            npList.add(np1);

            Network_Pricing__c np2 = new Network_Pricing__c();
            np2.FAF_ID__c = faf.Id;
            np2.FAF_Network_Ops__c = nOps.Id;
            np2.Retail_Network_Ordinal__c = 'Primary';
            np2.Year__c = '1';
            np2.LOB__c = 'ACT';
            np2.Network_Name__c = 'MC(84-90)CP';
            np2.Brand_Rate__c = 5;
            npList.add(np2);
            
            Network_Pricing__c np3 = new Network_Pricing__c();
            np3.FAF_ID__c = faf.Id;
            np3.FAF_Network_Ops__c = nOps.Id;
            np3.Retail_Network_Ordinal__c = 'Primary';
            np3.Year__c = '1';
            np3.LOB__c = 'ACT';
            np3.Network_Name__c = 'MC(84-90)CP';
            np3.Brand_Rate__c = 5;
            np3.Brand_Basis__c='Pass-Through';
            np3.Generic_Basis__c ='Pass-Through';
            npList.add(np3);
                    
            insert npList;  
            
            
            Retail_Network_Guarantees__c ng = new Retail_Network_Guarantees__c();
            ng.FAF_ID__c = faf.Id;
            ng.Network_Pricing__c= npList[1].Id;
            ng.Type__c = 'BER';
            ng.SSG__c = 'No'; 
            ng.Mirror_Mail_Guarantees__c = true; 
            insert ng;                    
        }
    }
    
    static testMethod void test() {
       
        Test.StartTest(); 
        ApexPages.currentPage().getParameters().put(Label.FAFIDNetworkPricing, String.valueOf(nOps.Id));
        ApexPages.currentPage().getParameters().put('lightning', 'true');
        NetworkPricingExt npExt = new NetworkPricingExt(new ApexPages.StandardController(new Network_Pricing__c()));
        npExt.np.FAF_ID__c = faf.Id;
        npExt.np.Retail_Network_Ordinal__c = 'Primary';
        npExt.np.Year__c = 'All';
        npExt.np.LOB__c = 'ACT';
        npExt.np.Network_Name__c = 'MC(84-90)CP';
        npExt.np.Brand_Rate__c = 5;
        npExt.np.Mirror_Mail_Generic_Pricing__c = true;
        npExt.fafId = faf.Id;
        npExt.year = 'All';
        npExt.lob = 'ACT';
        npExt.enableMirrorYearLOB();
        npExt.save();
        npExt.cancel();
        Test.StopTest();
    }
    
    

    static testMethod void test2() {
        
        Test.StartTest(); 
        ApexPages.currentPage().getParameters().put(Label.FAFIDNetworkPricing, String.valueOf(npList[1].FAF_Network_Ops__c));
        ApexPages.currentPage().getParameters().put('lightning', 'true');
        NetworkPricingExt npExt = new NetworkPricingExt(new ApexPages.StandardController(new Network_Pricing__c(Id=npList[1].Id)));
        npExt.np.FAF_ID__c = faf.Id;
        npExt.np.Retail_Network_Ordinal__c = 'Primary';
        npExt.np.Year__c = '1';
        npExt.np.LOB__c = 'ACT';
        npExt.np.Network_Name__c = 'MC(84-90)CP';
        npExt.np.Brand_Rate__c = 5;
        npExt.np.Mirror_Mail_Generic_Pricing__c = true;
        npExt.fafId = faf.Id;
        npExt.year = '1';
        npExt.lob = 'ACT';
        npExt.enableMirrorYearLOB();   
            
        npExt.save();
        npExt.cancel();
        Test.StopTest();
    }
static testMethod void test3() {
        Test.StartTest(); 
        ApexPages.currentPage().getParameters().put(Label.FAFIDNetworkPricing, String.valueOf(npList[1].FAF_Network_Ops__c));
        ApexPages.currentPage().getParameters().put('lightning', 'true');
        NetworkPricingExt npExt = new NetworkPricingExt(new ApexPages.StandardController(new Network_Pricing__c(Id=npList[1].Id)));
        npExt.np.FAF_ID__c = faf.Id;
        npExt.np.Retail_Network_Ordinal__c = 'Primary';
        npExt.np.Year__c = '1';
        npExt.np.LOB__c = 'ACT';
        npExt.np.Network_Name__c = 'Custom'; 
        npExt.np.Brand_Rate__c = 5;
        npExt.np.Mirror_Mail_Generic_Pricing__c = true;
        npExt.fafId = faf.Id;
        npExt.year = '1';
        npExt.lob = 'ACT';
        npExt.enableMirrorYearLOB();        
        npExt.save();
        npExt.cancel();
        Test.StopTest();
    }  
    static testMethod void test4() {
        Test.StartTest(); 
        ApexPages.currentPage().getParameters().put(Label.FAFIDNetworkPricing, String.valueOf(npList[1].FAF_Network_Ops__c));
        //ApexPages.currentPage().getParameters().put('lightning', 'true');
        NetworkPricingExt npExt = new NetworkPricingExt(new ApexPages.StandardController(new Network_Pricing__c(Id=npList[1].Id)));
        npExt.np.FAF_ID__c = faf.Id;
        npExt.np.Retail_Network_Ordinal__c = 'Primary';
        npExt.np.Year__c = '1';
        npExt.np.LOB__c = 'ACT';
        npExt.np.Network_Name__c = 'Custom'; 
        npExt.np.Brand_Rate__c = 5;
        npExt.np.Mirror_Mail_Generic_Pricing__c = true;
        npExt.fafId = faf.Id;
        npExt.year = '1';
        npExt.lob = 'ACT';
        npExt.enableMirrorYearLOB(); 
        npExt.getNoMailPriceatFAF();
        npExt.save();
        npExt.cancel();
        Test.StopTest();
    } 
    
    static testMethod void test5() {
        
        Test.StartTest(); 
        ApexPages.currentPage().getParameters().put(Label.FAFIDNetworkPricing, String.valueOf(npList[1].FAF_Network_Ops__c));
        ApexPages.currentPage().getParameters().put('lightning', 'true');
        NetworkPricingExt npExt = new NetworkPricingExt(new ApexPages.StandardController(new Network_Pricing__c(Id=npList[2].Id)));
        npExt.np.FAF_ID__c = faf.Id;
        npExt.np.Retail_Network_Ordinal__c = 'Primary';
        npExt.np.Year__c = '1';
        npExt.np.LOB__c = 'ACT';
        npExt.np.Network_Name__c = 'MC(84-90)CP';
        npExt.np.Brand_Rate__c = 5;
        npExt.np.Mirror_Mail_Generic_Pricing__c = true;
        npExt.np.Brand_Basis__c='Pass-Through';
        npExt.np.Generic_Basis__c ='Pass-Through';
        npExt.fafId = faf.Id;
        npExt.year = '1';
        npExt.lob = 'ACT';
        npExt.BrandGenericBasis();
        npExt.np.Network_Name__c = 'Adv Choice - 2020';
        npExt.clearNetworkGuarantees(npExt.np); 
        npExt.save();
        npExt.cancel();
        Test.StopTest();
    }
    
    static testMethod void test6() {
        Test.StartTest(); 
        ApexPages.currentPage().getParameters().put(Label.FAFIDNetworkPricing, String.valueOf(nplist[0].FAF_Network_Ops__c));
        ApexPages.currentPage().getParameters().put('lightning', 'true');
        ApexPages.currentPage().getParameters().put('type','clone');
        NetworkPricingExt npExt = new NetworkPricingExt(new ApexPages.StandardController(new Network_Pricing__c(Id=npList[0].Id)));
        //delete nplist[0];
        npExt.save();
        npExt.cancel();
        Test.StopTest();
    }
    
}