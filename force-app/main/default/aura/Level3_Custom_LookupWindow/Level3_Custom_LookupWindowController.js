({
  //Method to display initial Group information in Lokkup
	init : function(component, event, helper) {
		   component.set('v.columns', [
            {label: 'Group ID', fieldName: 'Group_ID__c', type: 'text'},
            {label: 'Group Name', fieldName: 'Group_Name__c', type: 'text'}
        ]);
        var platform = component.get("v.platform");
        var lob = component.get("v.lob");
        var fafid = component.get("v.fafid");
        var accinfo = component.get("v.AccountId");
        var accid = accinfo.Account_Name__c;
        helper.searchCarrierRecords(component, platform, lob, fafid, accid); 
	},
  //Method to handle selected record from list and add in lookup
    updateSelectedText: function(component, event, helper) {
      var getSelectRecord = component.get("v.oRecord");
      var selectedRows = event.getParam('selectedRows');
      var carrierid = selectedRows[0].Group_Id__c;
      var recordIden = component.get("v.recordIdentify");
      var carrieridselect = $A.get("e.c:Level3_Custom_CarrierAdd_WSelect");
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
        var accinfo = component.get("v.AccountId");
        var accid = accinfo.Account_Name__c;
        helper.searchkeyCarrierRecords(component, searchkey, platform, lob, fafid, accid); 
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