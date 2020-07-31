/******
Test Class: Test_FilesManagmentHelper
******/
public class FilesManagmentHelper{
    
    //add file restriction error if current user profile is one of the restricted profile.
    public static void displayFileRestrictionError(sobject obj,string errMsg){
        if(label.RestrictFileUploadforProfiles.contains(userInfo.getProfileId().subString(0,15))){
            obj.adderror(errMsg);
        }
    }
    
    //share every content document uploaded with underwriter team
    public static void shareCDTOUnderwriters(list<ContentVersion> CVList){
        list<ContentDocumentLink> CDLList=new list<ContentDocumentLink>();
        set<id> cids=new set<id>();
        
        for(ContentVersion c:CVList){
            cids.add(c.contentdocumentid);
        }
        set<id> ecids=new set<id>();
        
        for(ContentDocumentLink cdl:[select id,contentdocumentid from ContentDocumentLink where LinkedEntityId=:label.ShareFilesWithGroup and contentdocumentid IN:cids]){
            ecids.add(cdl.contentdocumentid );
        }
        
        for(ContentVersion c:CVList){
           if( ecids.isempty() || !ecids.contains(c.contentdocumentid)){
               ContentDocumentLink c1=new ContentDocumentLink(); 
               c1.contentdocumentid=c.contentdocumentid;
               c1.Visibility='AllUsers';
               c1.ShareType='C';
               c1.LinkedEntityId=label.ShareFilesWithGroup;
               CDLList.add(c1);
           }
        }
        insert CDLList;
    }
}