@isTest
public class Level_PlatformSpecificSaveTest {

    private static Platform_Specifics__c createPlatformSpecific(){
        Central_Hub__c faf = new Central_Hub__c();
        //faf.Name = 'TestFAF';
        insert faf;
        
        CAG__c cag = new CAG__c();
        //cag.Name = 'TestCag';
        cag.CAG_ID__c = '1234567890';
        cag.RecordTypeId = [select id from RecordType where Name ='A'].Id;
        
        insert cag;
        Client_Information__c csInfo = new Client_Information__c();
        csInfo.FAF_ID__c = faf.Id;
        insert csInfo;
        Date dt =System.today();
        String dtformat=dt.format();
        
        Platform_Specifics__c platForm = new Platform_Specifics__c();
        platForm.FAF_Client_Information__c =  csInfo.Id;
        platForm.Level_1_Record_ID__c = cag.Id;
        platForm.Termed__c = false;
        platForm.DifferentGSTPFormularyEffectiveDates__c = false;
        platForm.EffectiveDate__c = dt;
      //  insert platForm;
        return platForm;
    }
    
    @isTest
    public static void retrieveTeamMembersTest(){
        Platform_Specifics__c platForm = createPlatformSpecific();
        String psString = JSON.serialize(platForm);
       // Level_PlatformSpecificSave.SavePlaformSpec(platForm);
    }
     @isTest
    public static void retrieveTeamMemberTest(){
        try{
        Platform_Specifics__c platForm = new Platform_Specifics__c();
        String psString = JSON.serialize(platForm);
        Level_PlatformSpecificSave.SavePlaformSpec(platForm);
        }catch(Exception  ex){
            
        }
    }
}