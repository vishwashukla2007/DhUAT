({
	searchHelper : function(component,event,getInputkeyWord) {
	  // call the apex class method 
     var accid = component.get("v.SelectedAccount");
     var carrid = component.get("v.SelectedCarrier");
     var action = component.get("c.fetchLookUpValues");
      // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'AccountId' : accid,
            'CarrierId' : carrid,
            'Platform' : component.get("v.platform")
          });
      // set a callBack    
        action.setCallback(this, function(response) {
          $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
              // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No active Level 3/Group');
                    component.set("v.Message1",'information found');
                } else {
                    component.set("v.Message", '');
                    component.set("v.Message1", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }
 
        });
      // enqueue the Action  
        $A.enqueueAction(action);
    
	},
    UpdateCarrierPlatformSpec : function(component,event,GrouprowId) {
	  // call the apex class method 
     var platformId = component.get("v.platformId");
     var action = component.get("c.UpdatePlatformSpecGroupID");
      // set param to method  
        action.setParams({
            'PlatformID': platformId,
            'GroupID' : GrouprowId,
            'PlatformName' : component.get("v.platform")
          });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                  // No need to provide message;
                } 
            else {
               component.set("v.Message", 'Problem in Plaform Specfics Level3 Lookup');
                 }
 
        });
      // enqueue the Action  
        $A.enqueueAction(action);
      
 },
    
 // function for clear the Record Selaction 
    clearvalues :function(component,event,helper){
         var pillTarget = component.find("lookup-pill");
         var lookUpTarget = component.find("lookupField"); 
        
         $A.util.addClass(pillTarget, 'slds-hide');
         $A.util.removeClass(pillTarget, 'slds-show');
        
         $A.util.addClass(lookUpTarget, 'slds-show');
         $A.util.removeClass(lookUpTarget, 'slds-hide');
         component.set("v.SearchKeyWord",null);
         component.set("v.listOfSearchRecords", null );
         component.set("v.selectedRecord", {} );  
         component.set("v.selectedRecord.Group_ID__c" , null);
         var grouprowid = null;
         var rec = component.get("v.recordIdentify");
         var platformId = component.get("v.platformId");  
		 var carrieridselect = $A.get("e.c:Level3_Clear_SelectedValue");
     	 carrieridselect.setParams({
           					 "carrier" : null,
             "recordIdentify" : rec});
      	 carrieridselect.fire(); 
    },
    
})