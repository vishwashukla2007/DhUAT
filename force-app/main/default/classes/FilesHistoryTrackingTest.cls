@isTest(seeAllData=true)
public class FilesHistoryTrackingTest{
    static testMethod void doTest(){
       
        ContentVersion cv= new ContentVersion(
        title='test title',
        PathOnClient = 'TestFile'+'.txt',
        VersionData = Blob.valueOf('Created for test class'),
         IsMajorVersion = false
       );
        insert cv;
        
        cv=[select id,contentdocumentid from contentversion where id=:cv.id];
        
        Central_Hub__c FAF=[select id from Central_Hub__c limit 1];
        
        contentdocumentlink cdl=new contentdocumentlink();
        cdl.contentdocumentid=cv.contentdocumentid;
        cdl.Visibility='AllUsers';
        cdl.ShareType='I';
        cdl.LinkedEntityId=FAF.id;
        insert cdl;
        
        contentDocument cd1=[select id from contentdocument where id=:cv.contentdocumentid];
        delete cd1;
        
        
    }
    
   static testMethod void doTest1(){   
        
        Central_Hub__c FAF=[select id from Central_Hub__c limit 1];        
        attachment att= new attachment(
        name='Test Attachment',
        body=Blob.valueof('Test'),
        parentId = FAF.id
        );
        insert att;
            
        attachment att1=[select id from attachment where id=:att.id];
        delete att1;
        
        
    } 
}