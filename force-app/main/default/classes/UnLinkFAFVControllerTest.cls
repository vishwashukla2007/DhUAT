@isTest 
public class UnLinkFAFVControllerTest 
{
    static testMethod void testMethod1() 
    {
        List<Central_Hub__c> fafList = new List<Central_Hub__c>();
        
        Central_Hub__c faf = new Central_Hub__c();
        faf.FAF_Status__c = 'Test';
        fafList.add(faf);
        
        Central_Hub__c faf1 = new Central_Hub__c();
        faf1.FAF_Status__c = 'Test';
        fafList.add(faf1);
        insert fafList;
        
        Test.StartTest(); 
        ApexPages.currentPage().getParameters().put('id', String.valueOf(fafList[0].Id));
        ApexPages.currentPage().getParameters().put('MarketSegment', String.valueOf(fafList[0].Segment__c));
        LinkFAFVController  linkFaf = new LinkFAFVController();
        linkFaf.searchstring = fafList[0].Name;
        List<LinkFAFVController.CentralHUBWrapper> newFafList = linkFaf.getHubList();
        for(LinkFAFVController.CentralHUBWrapper hub:newFafList) {
            hub.checked = true;
        }
        linkFaf.save(); 
        unLinkFAFVController  unlinkFaf = new unLinkFAFVController();
        unlinkFaf.searchstring = fafList[0].Name;
        unlinkFaf.con = null;
        List<unLinkFAFVController.CentralHUBWrapper> newunlinkFafList = unlinkFaf.getHubList();
        Integer pageNo = unlinkFaf.pageNumber;
        Boolean previous= unlinkFaf.hasPrevious;
        Boolean next = unlinkFaf.hasNext;
        unlinkFaf.first();
        unlinkFaf.last();
        unlinkFaf.previous();
        unlinkFaf.next();
        unlinkFaf.cancel();
        for(unLinkFAFVController.CentralHUBWrapper hub:newunlinkFafList) {
            hub.checked = true;
        }
        
        unlinkFaf.save();        
        unlinkFaf.searchHubList();
        unlinkFaf.clear();
        Test.StopTest();
    }
}