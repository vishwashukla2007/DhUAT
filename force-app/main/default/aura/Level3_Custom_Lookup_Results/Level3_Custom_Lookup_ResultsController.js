({
  //Method to handle selected record from result set
   selectRecord : function(component, event, helper){ 
    debugger;
    // get the selected record from list  
      var getSelectRecord = component.get("v.oRecord");
    // call the event   
       var recordIden = component.get("v.recordIdentify");
       var sel = component.get("v.selRecord");
       component.set("v.selRecord", getSelectRecord);
       var appEvent = $A.get("e.c:Level3_Custom_Lookup_SelectedRecords");
      // set the Selected sObject Record to the event attribute.  
         appEvent.setParams({"recordByEvent" : getSelectRecord,
                            "recordIdentify" : recordIden});  
      // fire the event  
         appEvent.fire();
    },
})