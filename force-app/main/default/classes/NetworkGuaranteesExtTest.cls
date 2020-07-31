/*********************************************************************************************
* @author   Sindhu Alati
* @date     18 09 2018
* @description:This is the testclass for the class NetworkGuaranteesExt   
 **********************************************************************************************/
@isTest
private class NetworkGuaranteesExtTest {
    static Central_Hub__c faf = new Central_Hub__c();
    static List<Network_Pricing__c> npList = new List<Network_Pricing__c>();
    static Retail_Network_Guarantees__c ng = new Retail_Network_Guarantees__c();
    static {
        Account accRec=TestDataFactory.createAccount();
        insert accRec; 
        faf.FAF_Status__c = 'Draft';
        faf.LOB2__c = 'ACT';
        faf.Account_Name__c=accRec.Id;
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
        
        Network_Operations__c nOps = new Network_Operations__c();
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
                
        insert npList;  
                     
       
        ng.FAF_ID__c = faf.Id;
        ng.Network_Pricing__c= npList[1].Id;
        ng.Type__c = 'GER';
        ng.SSG__c = 'Yes'; 
        ng.Mirror_Mail_Guarantees__c = true; 
        insert ng;   
    }
    
    static testMethod void test() {
        Test.StartTest(); 
        ApexPages.currentPage().getParameters().put(Label.FAFIDNetworkGuarantee, String.valueOf(npList[0].Id));
        ApexPages.currentPage().getParameters().put('lightning', 'true');
        NetworkGuaranteesExt ngExt = new NetworkGuaranteesExt(new ApexPages.StandardController(new Retail_Network_Guarantees__c()));
        ngExt.ng.FAF_ID__c = faf.Id;
        ngExt.ng.Type__c = 'BER';
        ngExt.ng.SSG__c = 'No';        
        ngExt.populateratessg();
        ngExt.saveNetworkGuarantees();
        ngExt.cancel(); 
        Test.StopTest();
    }

    static testMethod void test2() {
        Test.StartTest(); 
        ApexPages.currentPage().getParameters().put(Label.FAFIDNetworkGuarantee, String.valueOf(npList[1].Id));
        NetworkGuaranteesExt ngExt = new NetworkGuaranteesExt(new ApexPages.StandardController(new Retail_Network_Guarantees__c()));
        ngExt.ng.FAF_ID__c = faf.Id;
        ngExt.ng.Type__c = 'GER';
        ngExt.ng.SSG__c = 'Yes';        
        ngExt.populateratessg();
        ngExt.saveNetworkGuarantees();
        ngExt.cancel();
        Test.StopTest();
    }    
}