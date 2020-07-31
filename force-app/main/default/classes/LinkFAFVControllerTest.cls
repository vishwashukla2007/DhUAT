@isTest 
public class LinkFAFVControllerTest 
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
        Integer pageNo = linkFaf.pageNumber;
        Boolean previous= linkFaf.hasPrevious;
        Boolean next = linkFaf.hasNext;
        linkFaf.first();
        linkFaf.last();
        linkFaf.previous();
        linkFaf.next();
        linkFaf.cancel();
        for(LinkFAFVController.CentralHUBWrapper hub:newFafList) {
            hub.checked = true;
        }
        linkFaf.save(); 
        linkFaf.saveOnWarning();       
        linkFaf.searchHubList();
        linkFaf.clear();
        Test.StopTest();
    }
}