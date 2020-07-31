@isTest
public class Test_TPANIFFORMcontroller {

    static testMethod void doTest(){
          try{
              User salesperson = ClientTestRef.createUser('Apttus Sales');
            insert salesperson;
                    
            Account accObj =  ClientTestRef.createAccount();
            insert accObj;
            Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
            insert oppObj;
            Central_Hub__c FAFObj = ClientTestRef.createFAF1(accObj.id, oppObj.Id, salesperson.Id);
            insert FAFObj;
               
            Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
            insert clientInfo;
            
            test.startTest();
            FAFObj.Client_Info__c =clientInfo.id;
            update FAFObj;
            
            Network_Operations__c nOps = TestDataFactory.createNetworkOperation(FAFObj.id);
            nOps.Client__c = 'Lower of Discount or U&C or MAC';
            insert nOps;
            
            Network_Pricing__c np1 = TestDataFactory.createntwrkPricing(FAFObj.id,nOps.id);
            np1.Network_Name__c='MC(84-90)CVS';
            insert np1;
          
               
               TPA_Form__c tpafrm=new TPA_Form__c ();
               tpafrm.GOVCLP_Network_VA_Claims_1_90_day_supp__c='No';
               tpafrm.MDCAID_Network_Government_Paper_Claims__c='No';
               tpafrm.C_A_G__c='CAG 5';
               tpafrm.Client_Code__c='CAG 5';
               tpafrm.CLIENT_NAME__c='CAG 5';
               
               ApexPages.currentPage().getParameters().put(Label.ClientInfoTpaLab,clientInfo.id);
                ApexPages.currentPage().getParameters().put('id', tpafrm.Id);
                ApexPages.StandardController tpaFrmSC = new ApexPages.StandardController(tpafrm);
               TPANIFFORMcontroller controller=new TPANIFFORMcontroller(tpaFrmSC);
               
                controller.Save();
               controller.Cancel();
               test.stopTest();
               
          }catch(exception e){system.debug('+++++++++++=no coveragre++++++++'+e.getmessage());}
    }
    
        static testMethod void doTest1(){
          try{
              User salesperson = ClientTestRef.createUser('Apttus Sales');
            insert salesperson;
                    
            Account accObj =  ClientTestRef.createAccount();
            insert accObj;
            Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
            insert oppObj;
            Central_Hub__c FAFObj = ClientTestRef.createFAF1(accObj.id, oppObj.Id, salesperson.Id);
            insert FAFObj;
               
            Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
            insert clientInfo;
            
            test.startTest();
            FAFObj.Client_Info__c =clientInfo.id;
            update FAFObj;
            
            Network_Operations__c nOps = TestDataFactory.createNetworkOperation(FAFObj.id);
            nOps.Client__c = 'Lower of Discount or U&C or MAC';
            insert nOps;
            
            Network_Pricing__c np1 = TestDataFactory.createntwrkPricing(FAFObj.id,nOps.id);
            np1.Network_Name__c='EDS 90 - Blended';
            insert np1;
          
               
               TPA_Form__c tpafrm=new TPA_Form__c ();
               tpafrm.GOVCLP_Network_VA_Claims_1_90_day_supp__c='No';
               tpafrm.MDCAID_Network_Government_Paper_Claims__c='No';
               tpafrm.C_A_G__c='CAG 5';
               tpafrm.Client_Code__c='CAG 5';
               tpafrm.CLIENT_NAME__c='CAG 5';
               
               ApexPages.currentPage().getParameters().put(Label.ClientInfoTpaLab,clientInfo.id);
                ApexPages.currentPage().getParameters().put('id', tpafrm.Id);
                ApexPages.StandardController tpaFrmSC = new ApexPages.StandardController(tpafrm);
               TPANIFFORMcontroller controller=new TPANIFFORMcontroller(tpaFrmSC);
               
                controller.Save();
               controller.Cancel();
               test.stopTest();
               
          }catch(exception e){system.debug('+++++++++++=no coveragre++++++++'+e.getmessage());}
    }
    
            static testMethod void doTest2(){
          try{
              User salesperson = ClientTestRef.createUser('Apttus Sales');
            insert salesperson;
                    
            Account accObj =  ClientTestRef.createAccount();
            insert accObj;
            Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
            insert oppObj;
            Central_Hub__c FAFObj = ClientTestRef.createFAF1(accObj.id, oppObj.Id, salesperson.Id);
            insert FAFObj;
               
            Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
            insert clientInfo;
            
            test.startTest();
            FAFObj.Client_Info__c =clientInfo.id;
            update FAFObj;
            
            Network_Operations__c nOps = TestDataFactory.createNetworkOperation(FAFObj.id);
            nOps.Client__c = 'Lower of Discount or U&C or MAC';
            insert nOps;
            
            Network_Pricing__c np1 = TestDataFactory.createntwrkPricing(FAFObj.id,nOps.id);
            np1.Network_Name__c='Custom Secondary';
            insert np1;
          
               
               TPA_Form__c tpafrm=new TPA_Form__c ();
               tpafrm.GOVCLP_Network_VA_Claims_1_90_day_supp__c='No';
               tpafrm.MDCAID_Network_Government_Paper_Claims__c='No';
               tpafrm.C_A_G__c='CAG 5';
               tpafrm.Client_Code__c='CAG 5';
               tpafrm.CLIENT_NAME__c='CAG 5';
               
               ApexPages.currentPage().getParameters().put(Label.ClientInfoTpaLab,clientInfo.id);
                ApexPages.currentPage().getParameters().put('id', tpafrm.Id);
                ApexPages.StandardController tpaFrmSC = new ApexPages.StandardController(tpafrm);
               TPANIFFORMcontroller controller=new TPANIFFORMcontroller(tpaFrmSC);
               
                controller.Save();
               controller.Cancel();
               test.stopTest();
               
          }catch(exception e){system.debug('+++++++++++=no coveragre++++++++'+e.getmessage());}
    }
}