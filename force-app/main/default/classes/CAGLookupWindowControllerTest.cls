@isTest
public class CAGLookupWindowControllerTest {
    private static Account createAccount(){
        Account accnt1= new Account();
        accnt1.Name =  'TestAccount1';
        Account acc= new Account();
        acc.Name =  'TestAccount';
        acc.Account_Level__c = 'Level 1';
        acc.ParentId = accnt1.id;
        acc.Client_ID__c = '4444';
        insert acc;
        return acc;
    }
    private static CAG__c createCag(){
        CAG__c cag1 = new CAG__c();
        cag1.CAG_ID__c = 'Test123';
        cag1.Carrier_ID__c = '4444';
        cag1.Carrier_Name__c = 'Non-Validated';
        insert cag1;
        return cag1;
    }
    @isTest
    public static void retrieveTeamMembersTest(){
        Account acc1 = createAccount();
        Account acc2 = createAccount();
        System.currentPageReference().getParameters().put('searchString', 'searchString');
        System.currentPageReference().getParameters().put('cagId', '');
        System.currentPageReference().getParameters().put('Id', '');
        System.currentPageReference().getParameters().put('Platform', 'Platform');
        System.currentPageReference().getParameters().put('RecordType', 'C');
        System.currentPageReference().getParameters().put('Active', 'A');
        System.currentPageReference().getParameters().put('AccountLevel', acc2.Id);
        System.currentPageReference().getParameters().put('AccountId', acc1.Id);
        Test.startTest();
        CAGLookupWindowController lookupWindowController = new CAGLookupWindowController();
        CAGLookupWindowController2 lookupWindowController2 = new CAGLookupWindowController2();
        CAGLookupWindowController3 lookupWindowController3 = new CAGLookupWindowController3();
        lookupWindowController.performSearch();
        lookupWindowController.redirect();
        lookupWindowController.Cancel();
        lookupWindowController.Save();
        lookupWindowController.hideaccountmethod();
        lookupWindowController.showaccountmethod();
        lookupWindowController2.performSearch();
        lookupWindowController2.redirect();
        lookupWindowController2.Cancel();
        lookupWindowController2.Save();
        lookupWindowController3.performSearch();
        lookupWindowController3.redirect();
        lookupWindowController3.Cancel();
        lookupWindowController3.Save();
        
        System.currentPageReference().getParameters().put('searchString', null);
        CAGLookupWindowController lookupWindowController1= new CAGLookupWindowController();
        CAGLookupWindowController2 lookupWindowController21= new CAGLookupWindowController2();
        CAGLookupWindowController3 lookupWindowController31= new CAGLookupWindowController3();
        Test.stopTest();
    }
    
      @isTest
    public static void retrieveTeamMembersTest1(){
        Account acc1 = createAccount();
        Account acc2 = createAccount();
        CAG__c cag2 = new CAG__c();
        cag2.CAG_ID__c = 'tst4444';
        cag2.Carrier_ID__c = '4444';
        cag2.Carrier_Name__c = '123Validated';
        cag2.Platform_Name__c = 'RxCLAIM';
        cag2.Record_Type__c = 'C';
        cag2.Status__c = 'A';
        insert cag2;
        System.currentPageReference().getParameters().put('searchString', '4444');
        System.currentPageReference().getParameters().put('cagId', '');
        System.currentPageReference().getParameters().put('Id', '');
        System.currentPageReference().getParameters().put('Platform', 'RxCLAIM');
        System.currentPageReference().getParameters().put('RecordType', 'C');
        System.currentPageReference().getParameters().put('Active', 'A');
        System.currentPageReference().getParameters().put('AccountLevel', acc2.Id);
        System.currentPageReference().getParameters().put('AccountId', acc1.Id);
         Test.startTest();
        CAGLookupWindowController lookupWindowController = new CAGLookupWindowController();
        CAGLookupWindowController2 lookupWindowController2 = new CAGLookupWindowController2();
        CAGLookupWindowController3 lookupWindowController3 = new CAGLookupWindowController3();
        lookupWindowController.performSearch();
        lookupWindowController.redirect();
        lookupWindowController.Cancel();
        lookupWindowController.Save();
        lookupWindowController.hideaccountmethod();
        lookupWindowController.showaccountmethod();
        lookupWindowController2.performSearch();
        lookupWindowController2.redirect();
        lookupWindowController2.Cancel();
        lookupWindowController2.Save();
        lookupWindowController3.performSearch();
        lookupWindowController3.redirect();
        lookupWindowController3.Cancel();
        lookupWindowController3.Save();
        
        System.currentPageReference().getParameters().put('searchString', '4444');
        CAGLookupWindowController lookupWindowController1= new CAGLookupWindowController();
        CAGLookupWindowController2 lookupWindowController21= new CAGLookupWindowController2();
        CAGLookupWindowController3 lookupWindowController31= new CAGLookupWindowController3();
         Test.stopTest();
    }
    
        @isTest
    public static void retrieveTeamMembersTest2(){
        Account acc1 = new Account();
        acc1.Name = 'Test_FAF';
          acc1.Client_ID__c = '4444';
          insert acc1;
        Account acc2 = createAccount();
        CAG__c cag2 = new CAG__c();
        cag2.CAG_ID__c = 'tst4444';
        cag2.Carrier_ID__c = '4444';
        cag2.Carrier_Name__c = 'Carrier444';
        insert cag2;
        System.currentPageReference().getParameters().put('searchString', '4444');
        System.currentPageReference().getParameters().put('cagId', '');
        System.currentPageReference().getParameters().put('Id', '');
        System.currentPageReference().getParameters().put('Platform', 'Platform');
        System.currentPageReference().getParameters().put('RecordType', 'C');
        System.currentPageReference().getParameters().put('Active', 'A');
        System.currentPageReference().getParameters().put('AccountLevel', acc1.Id);
        System.currentPageReference().getParameters().put('AccountId', cag2.Carrier_ID__c);
         Test.startTest();
        CAGLookupWindowController lookupWindowController = new CAGLookupWindowController();
       
        lookupWindowController.performSearch();
      

        System.currentPageReference().getParameters().put('searchString', '4444');
        CAGLookupWindowController lookupWindowController1= new CAGLookupWindowController();
       
         Test.stopTest();
    }
}