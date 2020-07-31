({

    closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "False"  
      component.set("v.isOpen", false);
   },
 
   closesave: function(component, event, helper) {
      var carid = component.get("v.carrid");
     /* If (carid != undefined)
      {  */
         var platform = component.get("v.platform");
         var lob = component.get("v.lob");
         helper.createCarrierRecords(component, platform, lob, carid); 
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