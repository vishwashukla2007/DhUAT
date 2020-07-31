({

    closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "False"  
      component.set("v.isOpen", false);
   },
 
   closesave: function(component, event, helper) {
     /* If (carid != undefined)
      {  */
         var platform = component.get("v.platform");
         var lob = component.get("v.lob");
         helper.createGroupRecords(component, platform, lob); 
  		 component.set("v.isOpen", false);
     // } 
       /*else {
        var nocarrier = $A.get("e.force:showToast");
        nocarrier.setParams({
            title: "Carrier ID : ",
        message: "Please Input Carrier ID"
        });
        nocarrier.fire();
      } */
   }

})