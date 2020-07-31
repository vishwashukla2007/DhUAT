({
    
 //Init method to display intial information
	init : function(component, event, helper) {
		   component.set('v.columns', [
            {label: 'Carrier ID', fieldName: 'Carrier_ID__c', type: 'text'},
            {label: 'Carrier Name', fieldName: 'Carrier_Name__c', type: 'text'}
        ]);
        var platform = component.get("v.platform");
        var lob = component.get("v.lob");
        var fafid = component.get("v.fafid");
        var accinfo = component.get("v.AccountId");
        var accid = accinfo.Account_Name__c;
        helper.searchCarrierRecords(component, platform, lob, fafid, accid); 
	},
 // Method to identify selected record and send to parent components to perform action
    updateSelectedText: function(component, event, helper) {
      var getSelectRecord = component.get("v.oRecord");
      var selectedRows = event.getParam('selectedRows');
     var carrierid = selectedRows[0].Carrier_ID__c;
     var recordIden = component.get("v.recordIdentify");
     var carrierselect = $A.get("e.c:Level1_Custom_CarrierAdd_WSelect");
      carrierselect.setParams({
           					 "carrier" : selectedRows,
                             "recordIdentify" : recordIden});
      carrierselect.fire();
      // for Hide/Close Model,set the "isOpen" attribute to "False"   
     component.set("v.isOpen", false);
   },
    closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "False"  
      component.set("v.isOpen", false);
      component.set("v.isMessage", false);
      component.set('v.issummaryMessage', false); 
      component.set("v.isClearFilter", false);
   },
    performsearch: function(component, event, helper) {
        var searchkey = component.get("v.SearchKeyWord");
        var platform = component.get("v.platform");
        var lob = component.get("v.lob");
        var fafid = component.get("v.fafid");
        var accinfo = component.get("v.AccountId");
        var accid = accinfo.Account_Name__c;
        var clearFilter = component.get("v.isClearFilter");
        if (clearFilter == false)
        {
        	helper.searchkeyCarrierRecords(component, searchkey, platform, lob, fafid, accid);
        }
        else{
            helper.fetchclearFilterSearchValues(component, searchkey, platform, lob, fafid, accid);
        }
      // for Hide/Close Model,set the "isOpen" attribute to "False"  
       component.set("v.isClear", true);
       component.set("v.isSearch", false);
       component.set("v.isMessage", false);
       component.set('v.issummaryMessage', false);
   },
  clearFilter: function(component, event, helper) {
        var searchkey = component.get("v.SearchKeyWord");
        var platform = component.get("v.platform");
        var lob = component.get("v.lob");
        var fafid = component.get("v.fafid");
        var accinfo = component.get("v.AccountId");
        var accid = accinfo.Account_Name__c;
        helper.clearFilterCarrierRecords(component, platform, lob, fafid, accid); 

      // Clear Account Filter after Level1 lookup Open"  
     	component.set("v.isClear", false);
        component.set("v.isClearFilter", true);
        component.set("v.isSearch", true);
        component.set("v.isMessage", false);
        component.set('v.issummaryMessage', false);
   },
    clearsearch: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "False"  
        var platform = component.get("v.platform");
        var lob = component.get("v.lob");
        var fafid = component.get("v.fafid");
        var accinfo = component.get("v.AccountId");
        var accid = accinfo.Account_Name__c;
        var clearFilter = component.get("v.isClearFilter");
        if (clearFilter == false)
        {
        helper.searchCarrierRecords(component, platform, lob, fafid, accid); 
        }
        else{
        helper.clearFilterCarrierRecords(component, platform, lob, fafid, accid);     
        }
        component.set("v.SearchKeyWord" , "");
        component.set("v.isClear", false);
        component.set("v.isSearch", true);
        component.set("v.isMessage", false);
        component.set('v.issummaryMessage', false);
   },
   closesave: function(component, event, helper) {
        var carid = component.get("v.carrid");
         var platform = component.get("v.platform");
         var lob = component.get("v.lob");
         helper.createCarrierRecords(component, platform, lob, carid); 
  		 component.set("v.isOpen", false);
         component.set("v.isClearFilter", false);
   }
})