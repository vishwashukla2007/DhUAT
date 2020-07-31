@isTest
public class PCDQuestionAnswerTriggerHandlerTest {
  //Method 1
    static testmethod void TestMethod1(){
        
       /* User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        insert FAFObj;
        FAFObj.FAF_Status__c='Uploaded';
        FAFObj.Manual_LOB_ID__c='1';
        FAFObj.Manual_Task_ID__c='1';
        FAFObj.Manual_Offer_ID__c='1';
        
        Update FAFObj;
        
        Rebate_Operations__c rebOpsObj = TestDataFactory.createRebOps(FAFObj.id);
        rebOpsObj.Rebate_Offering_Type__c='Guarantee Only';
        insert rebOpsObj;
        
        Rebate_Guarantees__c rebateGuarantees = TestDataFactory.createRebateGuarantee(FAFObj.id,rebOpsObj.id);            
        insert rebateGuarantees;
         
        Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
        specOpsObj.Pharmacy_Benefit__c = 'Client Choice';
        insert specOpsObj;
            
            Specialty_Drug_Level_Pricing__c specDrugObj= TestDataFactory.createspecDrugObject(FAFObj.id, specOpsObj.id);
            insert specDrugObj;
            
            Specialty_Pricing__c specPricObj= TestDataFactory.createspecPricingObject(FAFObj.id, specOpsObj.id);
            insert specPricObj;
        
        Formulary_Option__c fopt=new Formulary_Option__c();
        fopt.Name='Standard PDL Formulary Opt In';
        fopt.Active__c=true;
        fopt.Specialty__c=true;
        insert fopt;
        
        Formulary_Option__c fopt2=new Formulary_Option__c();
        fopt2.Name='Standard PDL Formulary Opt Out';
        fopt2.Active__c=true;
        fopt2.Specialty__c=true;
        insert fopt2;
        
        
        Non_Specialty_Formulary_Option__c nop=new Non_Specialty_Formulary_Option__c();
        nop.Name='Comm Standard Control with PA';
        nop.Active__c=true;
        //nop.Specialty__c=true;
        insert nop;
        
        
        Non_Specialty_Formulary_Option__c nop1=new Non_Specialty_Formulary_Option__c();
        nop1.Name='Comm Advanced Control';
        nop1.Active__c=true;
        //nop.Specialty__c=true;
        insert nop1;
        
        
        Non_Specialty_Formulary_Option__c nop2=new Non_Specialty_Formulary_Option__c();
        nop2.Name='EGWP Bronze without Exclusions';
        nop2.Active__c=true;
        //nop.Specialty__c=true;
        insert nop2;
        
        
        Network_Name__c nt1=new Network_Name__c();
        nt1.Name ='EDS 90 - No WAG';
        nt1.Active__c=true;
        insert nt1;
        
        Network_Name__c nt2=new Network_Name__c();
        nt2.Name ='MC(84-90)CP';
        nt2.Active__c=true;
        insert nt2;
        
        Network_Name__c nt3=new Network_Name__c();
        nt3.Name ='Access Based Network';
        nt3.Active__c=true;
        insert nt3;
        
        Network_Name__c nt4=new Network_Name__c();
        nt4.Name ='Med D Preferred Discount 30';
        nt4.Active__c=true;
        insert nt4;
        
        Network_Name__c nt5=new Network_Name__c();
        nt5.Name ='EDS 90 - No WAG';
        nt5.Active__c=true;
        insert nt5;
        
        
        Client_Information__c clientInfo2 = TestDataFactory.createClientInfo(FAFObj.id);
        insert clientInfo2;
        List<Client_Information__c> clientINFO1= new List<Client_Information__c>();
        List<Client_Information__c> clientINFO=[select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
                                             Client_Information__c where FAF_ID__c =:FAFObj.id limit 1];
                                             
            for(Client_Information__c cl:clientINFO){
                
            cl.year_1__c='1';
            cl.Year_1_Begin_Date__c=Date.newInstance(2018,7, 1);
            cl.Year_1_End_Date__c=Date.newInstance(2018, 7,7 );
            
            cl.year_2__c='2';
            cl.Year_2_Begin_Date__c=Date.newInstance(2018,7, 8);
            cl.Year_2_End_Date__c=Date.newInstance(2018,7, 14);
            
            cl.year_3__c='3';
            cl.Year_3_Begin_Date__c=Date.newInstance(2018,7,15);
            cl.Year_3_End_Date__c=Date.newInstance(2018,7,21);
            
            cl.year_4__c='4';
            cl.Year_4_Begin_Date__c=Date.newInstance(2018,7,22);
            cl.Year_4_End_Date__c=Date.newInstance(2018,7,28);
            
            cl.year_5__c='5';
            cl.Year_5_Begin_Date__c=Date.newInstance(2018,7,29);
            cl.Year_5_End_Date__c=Date.newInstance(2018,8,4);
            clientINFO1.add(cl);
            }
            update clientINFO1;
        
        
        Test.startTest();
         List<Network_Operations__c> npos=new List<Network_Operations__c>();
        Network_Operations__c NetworkOps = new Network_Operations__c(
        client__c = 'No MAC with U&C',
        member__c = 'Lower of U&C or Copay - Standard Copay Logic On',
        Retail_90_Days_Supply_84__c = true,
        Days_Supply__c = 45,
        FAF_ID__c = FAFObj.Id);
        
        npos.add(NetworkOps);
        insert npos;
        
       
        
        List<network_Pricing__c> nplist=new  List<network_Pricing__c>();
        Network_Pricing__c np1 = new Network_Pricing__c();
        np1.FAF_ID__c = FAFObj.Id;
        np1.FAF_Network_Ops__c = npos[0].Id;
        np1.Retail_Network_Ordinal__c = 'Primary';
        np1.Year__c = 'All';
        np1.LOB__c = 'ACT';
       //np1.FAF_ID__r.FAF_Status__c='Uploaded';
        np1.Network_Name__c = 'MC(84-90)CP';
        np1.Brand_Rate__c = 5;
        insert np1;
        
        np1.Year__c='2';
        update np1;
        
        np1.Year__c='3';
        update np1;
        
        np1.Year__c='4';
        update np1;
        
        np1.Year__c='5';
        update np1;
        
         np1.Year__c='All';
        update np1;
        
        Retail_Network_Guarantees__c RNG=TestDataFactory.createretntwrkGuarnt(FAFObj.id,NP1.id);
       RNG.Type__c='BER';
       insert RNG;
       
       RNG.Type__c='SSG';
        update RNG;
       
       RNG.Type__c='MER';
       update RNG;
       
       RNG.Type__c='NED';
       update RNG;
       
       RNG.Type__c='GER';
       update RNG;
        
       list<id> fafidsList = new List<ID>();
           for( Network_Operations__c c :npos){
                  fafidsList.add(c.id);
        }
        Apttus__WizardDesign__c wrddesin=new Apttus__WizardDesign__c();
        wrddesin.Name='PCD Questions2';
        insert wrddesin;
        
        
        Apttus__Wizard2__c aptwrd=new Apttus__Wizard2__c();
        aptwrd.Apttus__Status__c='In Progress';
        aptwrd.Name='PCD Questions2';
        aptwrd.Apttus__WizardDesignId__c=wrddesin.id;
        insert aptwrd;
        
        Apttus__WizardInputControl2__c wti=new Apttus__WizardInputControl2__c();
        wti.Apttus__Sequence__c=0;
        wti.Name='LOB';
        insert wti;
        
        Apttus__WizardInputControl2__c wti2=new Apttus__WizardInputControl2__c();
        wti2.Apttus__Sequence__c=0;
        wti2.Name='Agreement line Item ID';
        insert wti2;
        
        Apttus__APTS_Agreement__c agr=new Apttus__APTS_Agreement__c();
        agr.Apttus__Account__c=accObj.id;
        agr.Opportunity__c=oppObj.id;
        insert agr;
        
        Apttus__AgreementLineItem__c agrline=new Apttus__AgreementLineItem__c();
        agrline.Apttus__AgreementId__c=agr.id;
        agrline.PCD_FAF__c=FAFObj.id;
        agrline.Apttus_CMConfig__LineNumber__c=0;
        agrline.Apttus_CMConfig__ItemSequence__c=0;
        insert agrline;
        
        Network_Name__c nmame= new Network_Name__c();
        nmame.Name='Access Based Network';
        nmame.Active__c=true;
        insert nmame;
        
        Apttus__WizardRuntimeInput__c aptwd1=new Apttus__WizardRuntimeInput__c();
        aptwd1.Name=wti.id;
        aptwd1.Apttus__Sequence__c= 0;
        aptwd1.Apttus__ResponseValue__c=agrline.id;
        aptwd1.Apttus__Enabled__c=true;
        aptwd1.CreatedDate=System.now();
        aptwd1.Apttus__WizardInputControlId__c=wti.id;
        aptwd1.Apttus__WizardId__c=aptwrd.id;
        //aptwd.Control_Name__c='LOB';
        insert aptwd1;
        
         Apttus__WizardRuntimeInput__c aptwd=new Apttus__WizardRuntimeInput__c();
        aptwd.Name=wti.id;
        aptwd.Apttus__Sequence__c= 0;
        aptwd.Apttus__ResponseValue__c=agrline.id;
        aptwd.Apttus__Enabled__c=true;
        aptwd.CreatedDate=System.now();
        aptwd.Apttus__WizardInputControlId__c=wti2.id;
        aptwd.Apttus__WizardId__c=aptwrd.id;
        //aptwd.Control_Name__c='LOB';
        insert aptwd;
        
       
        
        PCD_Question_Answer__c pdq=new PCD_Question_Answer__c();
        pdq.Agreement__c=agr.id;
        pdq.Agreement_Line_Item__c=agrline.id;
        pdq.Are_there_Any_Changes__c='Yes';
        pdq.Network_Name_Optional1_LK__c=nmame.id;
        pdq.test__c=aptwd1.id;
        pdq.Specialty_Formulary_option1_LK__c=fopt.id;
        pdq.Formulary_Type_Rebates__c='Yes';
        pdq.Tier_Option_s__c='2 Tier Q; 3 Tier NQ; 3 Tier Q; Closed';
        pdq.Specialty_Formulary_option2_LK__c=fopt2.id;
        pdq.Non_Speciality_Formulary1_option_LK__c=nop.id;
        pdq.Non_Specialty_Formulary_option2_LK__c=nop1.id;
        pdq.Non_Specialty_Formulary_option3_LK__c=nop2.id;
        pdq.Speciality_level_Pharamacy_Benifit_Carve__c='YES';
        pdq.Carve_Out_Option_1__c='Anemia';
        pdq.Carve_Out_Option_2__c='Gout';
        pdq.Carve_Out_Option_3__c='Lipid Disorder';
        pdq.Speciality_Option__c='YES';
        pdq.Additional_Speciality_Option__c='Open';
        pdq.Network_Type5__c='Locked';
        pdq.Network_Type2__c='Locked';
        pdq.Network_Type3__c='Locked';
        pdq.Network_Type4__c='Locked';
        pdq.Network_Type1__c='Locked';
        pdq.Network_Name_Optional1_LK__c=nt1.id;
        
        pdq.Optional_Network_Name2_LK__c=nt2.id;
        pdq.Optional_Network_Name3_LK__c=nt3.id;   
        pdq.Optional_Network_Name4_LK__c=nt4.id;
        pdq.Optional_Network_Name5_LK__c=nt5.id;
        pdq.Include_Optional_Network_Option_to_T_T__c='YES';
        pdq.Do_you_want_to_provide_Network_name__c='NO';
        pdq.Additional_Tier_Options__c='YES';
        
        
        PCD_Question_Answer__c pdq1=new PCD_Question_Answer__c();
        pdq1.Agreement__c=agr.id;
        pdq1.Agreement_Line_Item__c=agrline.id;
        pdq1.Are_there_Any_Changes__c='Yes';
        pdq1.Network_Name_Optional1_LK__c=nmame.id;
        pdq1.test__c=aptwd.id;
        
        List<PCD_Question_Answer__c> pcdlist=new List<PCD_Question_Answer__c>();
        
        pcdlist.add(pdq);
         pcdlist.add(pdq1);
        insert pcdlist;
        
        system.debug('****pdqpdq********'+pdq);
        
        PCDQuestionAnswerTriggerHandler.FAFupdateafterinsert(pcdlist);
        PCDQuestionAnswerTriggerHandler1.FetchAgreementLineItem(pcdlist);
       
        Test.stopTest();*/
        
    } 
  
 
    
  
}