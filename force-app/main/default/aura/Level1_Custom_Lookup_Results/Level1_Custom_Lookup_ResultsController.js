({
 //Method to Handle selected records from result set
   selectRecord : function(component, event, helper){      
    // get the selected record from list  
      debugger;
      var getSelectRecord = component.get("v.oRecord");
    // call the event   
      var recordIden = component.get("v.recordIdentify");
       var sel = component.get("v.selRecord");
      var appEvent = $A.get("e.c:Level1_Custom_Lookup_SelectedRecords");
    // set the Selected sObject Record to the event attribute.  
         appEvent.setParams({"recordByEvent" : getSelectRecord,
                            "recordIdentify" : recordIden});  
    // fire the event  
         appEvent.fire();
    },
})