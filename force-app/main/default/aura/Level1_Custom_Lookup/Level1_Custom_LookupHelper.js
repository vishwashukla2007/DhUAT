({
	searchHelper : function(component,event,getInputkeyWord) {
	  // call the apex class method 
	 var accinfo = component.get("v.AccountId");
     var accid = accinfo.Account_Name__c;
     var action = component.get("c.fetchLookUpValues");
      // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : component.get("v.objectAPIName"),
            'AccountId' : accid,
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
                    component.set("v.Message", 'No active Level 1/Carrier');
                    component.set("v.Message1",'information found');
                } else {
                    component.set("v.Message", '');
                    component.set("v.Message1", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }
 
        });
      
        $A.enqueueAction(action);
    
	},
    UpdateCarrierPlatformSpec : function(component,event,carrierrowid) {
	 debugger;
     var platformId = component.get("v.platformId");
     var action = component.get("c.UpdatePlatformSpecCarrierID");
      // set param to method  
        action.setParams({
            'PlatformID': platformId,
            'CarrierID' : carrierrowid,
            'PlatformName' : component.get("v.platform")
          });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                  // No need to provide message;
                } 
            else {
               component.set("v.Message", 'Problem in Plaform Specfics Level1 Lookup');
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
         component.set("v.selectedRecord.Carrier_ID__c" , null);
         component.set("v.isLevel2Visible", 'true' );
         component.set("v.isLevel3Visible", 'true' );
         var rec = component.get("v.recordIdentify");
         var platformId = component.get("v.platformId");
		 var carrieridselect = $A.get("e.c:Level1_Clear_SelectedValue");
     	 carrieridselect.setParams({
           					 "carrier" : null,
             "recordIdentify" : rec});
      	 carrieridselect.fire(); 
       var lookupvisibility= $A.get("e.c:LevelLookupVisibilitylevel3");
    // set the Lookup visibility to the event attribute.  
         lookupvisibility.setParams({"isLevel2Visible" : 'true',
                            "isLevel3Visible" : 'true',
                            "recordIdentify" : rec});  
    // fire the event  
         lookupvisibility.fire();
    },
    
})