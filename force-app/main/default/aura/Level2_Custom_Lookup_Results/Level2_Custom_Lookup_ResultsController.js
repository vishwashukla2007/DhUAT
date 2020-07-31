({
 // Method to handle selected records from Result set
   selectRecord : function(component, event, helper){      
    // get the selected record from list  
      debugger;
      var getSelectRecord = component.get("v.oRecord");
      var recordIden = component.get("v.recordIdentify");
    // call the event   
      var appEvent = $A.get("e.c:Level2_Custom_Lookup_SelectedRecords");
    // set the Selected sObject Record to the event attribute.  
         appEvent.setParams({"recordByEvent" : getSelectRecord,
                             "recordIdentify" : recordIden});  
    // fire the event  
         appEvent.fire();
    },
})