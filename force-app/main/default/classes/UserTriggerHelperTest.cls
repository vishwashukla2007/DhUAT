/* ================================================
* @Class Name : UserTriggerHelperTest
* @author : Accenture
* @Purpose: Test Class for Handler class of TR_User_PubliGrpAssignment
* @created date:07/20/2018
* @Last modified date:
* @Last modified by : Accenture
================================================*/
@isTest(seeAllData=true)
public with sharing class UserTriggerHelperTest{
    
    
    /* ================================================
* @Method Name : userTriggerHelperTestMethod1
* @author : Accenture
* @Purpose: Test methood to cover insert method
* @Parameters: NA
* @return: Void
* @created date:07/20/2018
* @Last modified date:
* @Last modified by : Accenture
================================================*/
    @isTest
    static void userTriggerHelperTestMethod1(){
        
        User useObj1 = TestDataFactory.createUserWithoutSegment(Label.ApttusUnderwritingProfileLabel);
        insert useObj1;
        useObj1.isActive=false;
        update useObj1;
        User useObj2 = TestDataFactory.createUserWithoutSegment(Label.ApttusUnderwritingProfileLabel);
        insert useObj2;
        useObj2.Operational_Area__c='Auditor';
        useObj2.isActive=true;
        update useObj2;
        List<User> userlistTest=new List<User>();
        Map<ID,User> mapUserold=new Map<ID,User> ();
        mapUserold.put(useObj1.id,useObj1);
        Map<ID,User> mapUserNew=new Map<ID,User>();
        mapUserNew.put(useObj2.id,useObj2);
        userlistTest.add(useObj2);
        Test.StartTest();
        userTriggerHelper.updatePublicGrpOnInsert(userlistTest,True,false,mapUserold,mapUserNew);
        Test.StopTest();
        System.assertEquals(useObj1.isActive,false);
        
    }
    /* ================================================
* @Method Name : userTriggerHelperTestMethod2
* @author : Accenture
* @Purpose: Test methood to cover update method
* @Parameters: NA
* @return: Void
* @created date:07/20/2018
* @Last modified date:
* @Last modified by : Accenture
================================================*/
    @isTest static void userTriggerHelperTestMethod2(){
        
        User useObj1 = TestDataFactory.createUserWithoutSegment(Label.ApttusUnderwritingProfileLabel);
        insert useObj1;
        User useObj2 = [select Id,IsActive,ProfileID,Market_Segment__c from User where ID=:useObj1.id];
        useObj2.Operational_Area__c='Auditor';
        useObj2.Market_Segment__c='Aetna';
        useObj2.isActive=true;
        update useObj2;
        List<User> userlistTest=new List<User>();
        Map<ID,User> mapUserold=new Map<ID,User> ();
        mapUserold.put(useObj1.id,useObj1);
        Map<ID,User> mapUserNew=new Map<ID,User>();
        mapUserNew.put(useObj2.id,useObj2);
        userlistTest.add(useObj2);
        Group grp = new Group();
        grp.name = 'Test Group1';
        grp.Type = 'Regular'; 
        Insert grp; 
        GroupMember grpMem1 = new GroupMember();
        grpMem1.UserOrGroupId = UserInfo.getUserId();
        grpMem1.GroupId = grp.Id;
        Insert grpMem1;
        
        Test.StartTest();
        userTriggerHelper.updatePublicGrpOnInsert(userlistTest,True,false,mapUserold,mapUserNew);
        userTriggerHelper.updatePublicGrpOnUpdate(userlistTest,true,false,mapUserold,mapUserNew);
        Test.StopTest();
        System.assertEquals(useObj2.isActive,true);
        
    }
    @isTest(seeAllData=true)
    static void userTriggerHelperTestMethod12(){
        
        User useObj1 = TestDataFactory.createUserWithoutSegment(Label.ApttusUnderwritingProfileLabel);
        useObj1.Operational_Area__c='Rebate Ops User';
        useObj1.Change_Order_Permission__c='RCO-Clinical Advisor';
        useObj1.isActive=true;
        
        insert useObj1;
        useObj1.isActive=true;
        useObj1.ProfileId=Label.Apttus_Operations_Profile_Id;
        update useObj1;
        useObj1.isActive=false;
        update useObj1;
        
        
        User useObj2 = TestDataFactory.createUserWithoutSegment(Label.ApttusUnderwritingProfileLabel);
        insert useObj2;
        useObj2.Operational_Area__c='Rebate Ops User'; 
        useObj2.Change_Order_Permission__c='RCO-ANCS';
        useObj2.isActive=true;
        useObj2.ProfileId=Label.Apttus_Operations_Profile_Id;
        update useObj2;
        List<User> userlistTest=new List<User>();
        Map<ID,User> mapUserold=new Map<ID,User> ();
        mapUserold.put(useObj1.id,useObj1);
        Map<ID,User> mapUserNew=new Map<ID,User>();
        mapUserNew.put(useObj2.id,useObj2);
        userlistTest.add(useObj2);
        Test.StartTest();
        userTriggerHelper.updatePublicGrpOnInsert(userlistTest,True,false,mapUserold,mapUserNew);
        Test.StopTest();
        
        
    }   
}