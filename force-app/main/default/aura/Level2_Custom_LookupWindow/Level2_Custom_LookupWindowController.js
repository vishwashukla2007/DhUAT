({
  //Init method to display initial Account information in the lookup
	init : function(component, event, helper) {
		   component.set('v.columns', [
            {label: 'Account ID', fieldName: 'Account_ID__c', type: 'text'},
            {label: 'Account Name', fieldName: 'Account_Name__c', type: 'text'}
        ]);
        var platform = component.get("v.platform");
        var lob = component.get("v.lob");
        var fafid = component.get("v.fafid");
        helper.searchCarrierRecords(component, platform, lob, fafid); 
	},
  //Method fires when user select record from available list in the lookup
    updateSelectedText: function(component, event, helper) {
      var getSelectRecord = component.get("v.oRecord");
      var selectedRows = event.getParam('selectedRows');
      var Accountid = selectedRows[0].Account_ID__c;
      var recordIden = component.get("v.recordIdentify");
      var carrieridselect = $A.get("e.c:Level2_Custom_CarrierAdd_Wselect");
      carrieridselect.setParams({
           					 "carrier" : selectedRows,
                             "recordIdentify" : recordIden});
      carrieridselect.fire(); 
      // for Hide/Close Model,set the "isOpen" attribute to "False"  
      component.set("v.isOpen", false); 
   },
    closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "False"  
      component.set("v.isOpen", false);
      component.set("v.isMessage", false);
   },
    performsearch: function(component, event, helper) {
        var searchkey = component.get("v.SearchKeyWord");
        var platform = component.get("v.platform");
        var lob = component.get("v.lob");
        var fafid = component.get("v.fafid");
        helper.searchkeyCarrierRecords(component, searchkey, platform, lob, fafid); 
      // for Hide/Close Model,set the "isOpen" attribute to "False"  
      component.set("v.isClear", true);
      component.set("v.isSearch", false);
      component.set("v.isMessage", false);
   },
    clearsearch: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "False"  
        var platform = component.get("v.platform");
        var lob = component.get("v.lob");
        var fafid = component.get("v.fafid");
        helper.searchCarrierRecords(component, platform, lob, fafid); 
        component.set("v.SearchKeyWord" , "");
        component.set("v.isClear", false);
        component.set("v.isSearch", true);
        component.set("v.isMessage", false);
   },
   closesave: function(component, event, helper) {
         var carid = component.get("v.carrid");
         var platform = component.get("v.platform");
         var lob = component.get("v.lob");
         helper.createCarrierRecords(component, platform, lob, carid); 
  		 component.set("v.isOpen", false);

   }
})