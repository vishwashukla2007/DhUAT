@isTest
public class PBMQuestionParentControllerTest {

    @testSetup 
    static void dataSetup() {
        
        //Create user
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
        salesperson.Manager_Level_2__c = userInfo.getUserName();
        salesperson.Manager_Level_3__c = userInfo.getUserName();
        salesperson.Manager_Level_4__c = userInfo.getUserName();
        salesperson.Manager_Level_5__c = userInfo.getUserName();
        salesperson.ManagerId = userInfo.getUserId();
        update salesperson;
        
        //Create Account
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        accObj.iUMS_Client_Subtype__c = 'Health Plan Master';
        update accObj;
        
        //Create Opportunity
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        
        //Create FAF
        Central_Hub__c fafObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        fafObj.Business_Type__c = 'New';
        insert fafObj;
        
        //Create Client Info
        Client_Information__c clientInfoObj = TestDataFactory.createClientInfo(fafObj.id); 
        insert clientInfoObj;
        
        //Create Rebate Info
        Rebate_Operations__c rebateOpsObj = TestDataFactory.createRebOps(fafObj.id);
        rebateOpsObj.Pass_MAF__c = false;
        insert rebateOpsObj;
        
        //Create billing ops
        Billing_Operations__c billOpsObj = TestDataFactory.createBillOps(fafObj.id);
        insert billOpsObj;
        
        //Create Questions
        List<PBM_Questions__c> pbmQuestions = TestDataFactoryCLM.createPBMQuestions();
        insert pbmQuestions;
    }

    @isTest 
    static void getSaveRecord() {
        List<PBM_Questions_Answers__c> result = new List<PBM_Questions_Answers__c>();
        list<PBM_Questions__c> pbmQuestion = [SELECT Id, Data_Type__c,Field_API__c FROM PBM_Questions__c 
                                              WHERE Field_API__c NOT IN ('Client_Name__c','iUMS_Client_Subtype__c')];
        Central_Hub__c fafObj = [SELECT Id FROM Central_Hub__c LIMIT 1];
        List<String> pbmQuestAnsList = new List<String>();
        for(PBM_Questions__c eachQuest: pbmQuestion){
            if(eachQuest.Data_Type__c == 'Picklist' || eachQuest.Data_Type__c == 'Text' ){
                if(eachQuest.Field_API__c=='Pharmacy_Audit_Retention__c'){
                    pbmQuestAnsList.add(eachQuest.Id+'-'+'Base (80/20)');
                }else if(eachQuest.Field_API__c=='Segment__c'){
                    pbmQuestAnsList.add(eachQuest.Id+'-'+'Aetna');
                }else if(eachQuest.Field_API__c=='Specialty_Rebates__c'){
                    pbmQuestAnsList.add(eachQuest.Id+'-'+'Pass to Client');
                }else{
                    pbmQuestAnsList.add(eachQuest.Id+'-'+'testAns1');
                }
            }else if(eachQuest.Data_Type__c == 'Number'){
                 pbmQuestAnsList.add(eachQuest.Id+'-'+'2'); 
            }else if(eachQuest.Data_Type__c == 'Date'){
                pbmQuestAnsList.add(eachQuest.Id+'-'+ string.valueof(System.today())); 
            }      
        }
        
        Test.startTest(); 
        result = pbmQuestionParentController.getSaveRecord(pbmQuestAnsList, fafObj.Id);
        Test.stopTest();
        System.assert(!result.isEmpty());
    }

}