@isTest
public class CustomLookupControllerTest {
  
    static testmethod void LookupMethod(){
    
      Account accObj =  ClientTestRef.createAccount();
      insert accObj;
      System.currentPageReference().getParameters().put('objectName', 'Account');
      System.currentPageReference().getParameters().put('lksrch', accObj.name);
      System.currentPageReference().getParameters().put('frm', 'test');
      System.currentPageReference().getParameters().put('txt', 'test');
      CustomLookupController customnew = new CustomLookupController();
      customnew.search();
      customnew.saveRecord();
      customnew.getFormTag();
      customnew.getTextBox();
     // customnew.runSearch();
      //customnew.performSearch('test');
     // customnew.getTextBox();
        
    }
 }