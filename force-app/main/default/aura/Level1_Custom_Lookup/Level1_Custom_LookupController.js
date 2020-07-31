({
    
   	doInit : function(component, event, helper) {
        console.log('doinit');
        console.log(component.set("v.isLevelrequired"));
		var carrid = component.get("v.SelectedCarrier");
        if (carrid != null)
        {
			component.set("v.isnewpill", false);
            component.set("v.iseditpill", true);
            var forclose = component.find("lookup-pill");
           $A.util.addClass(forclose, 'slds-show');
           $A.util.removeClass(forclose, 'slds-hide');

           var lookUpTarget = component.find("lookupField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show'); 
            
        }
        else { 
            component.set("v.isnewpill", true);
            component.set("v.iseditpill", false);
        }
        
	},
   onfocus : function(component,event,helper){
       $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC  
         var getInputkeyWord = '';
         helper.searchHelper(component,event,getInputkeyWord);
    },
    openwindow : function(component,event,helper){
        component.set("v.iswindow", false );
        component.set("v.iswindow", true );
    },
    addcarrier : function(component,event,helper){
        component.set("v.isop", false );
        component.set("v.isop", true );
    },
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    handleCarrierEvent : function(component,event,helper){
        var recordchange =  event.getParam("recordIdentify");
        var rec = component.get("v.recordIdentify");
        if (recordchange == rec )
       {
        var carrier = event.getParam("carrierid");
        var carrId = carrier[0].Carrier_ID__c;
        var carrierrowid = carrier[0].Id;
        component.set("v.SelectedCarrier", carrId );
        component.set("v.isnewpill", false);
        component.set("v.iseditpill", true);
        var platformId = component.get("v.platformId");
        if (platformId != null) {
            //helper.UpdateCarrierPlatformSpec(component,event,carrierrowid); Don't need to update record
        }
        var forclose = component.find("lookup-pill");
           $A.util.addClass(forclose, 'slds-show');
           $A.util.removeClass(forclose, 'slds-hide');
        var lookUpTarget = component.find("lookupField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show');  
       }
    },
   handleCarrierWEvent : function(component,event,helper){ 
        var carrier = event.getParam("carrier");
        var recordchange =  event.getParam("recordIdentify");
        var rec = component.get("v.recordIdentify");
       if (recordchange == rec )
       {
       var carrId = carrier[0].Carrier_ID__c;
       var carrierrowid = carrier[0].Id;
	   component.set("v.SelectedCarrier" , carrId); 
       component.set("v.isnewpill", false);
       component.set("v.iseditpill", true);
        var platformId = component.get("v.platformId");
        if (platformId != null) {
            //helper.UpdateCarrierPlatformSpec(component,event,carrierrowid);
        }
  	       var forclose = component.find("lookup-pill");
           $A.util.addClass(forclose, 'slds-show');
           $A.util.removeClass(forclose, 'slds-hide');

           var lookUpTarget = component.find("lookupField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show'); 
       }
    },
    keyPressController : function(component, event, helper) {
       // get the search Input keyword   
         var getInputkeyWord = component.get("v.SearchKeyWord");
       // check if getInputKeyWord size id more then 0 then open the lookup result List and 
       // call the helper 
       // else close the lookup result List part.   
        if( getInputkeyWord.length > 0 ){
             var forOpen = component.find("searchRes");
               $A.util.addClass(forOpen, 'slds-is-open');
               $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
             component.set("v.listOfSearchRecords", null ); 
             var forclose = component.find("searchRes");
               $A.util.addClass(forclose, 'slds-is-close');
               $A.util.removeClass(forclose, 'slds-is-open');
          }
	},
    
  // function for clear the Record Selaction 
    clear :function(component,event,helper){
	  helper.clearvalues(component,event,helper);
    },
    
  // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
    // get the selected Carrier record from the COMPONENT event  
       var selectedCarrierGetFromEvent = event.getParam("recordByEvent");
       var recordchange =  event.getParam("recordIdentify");
        console.log('selectedCarrierGetFromEvent'+selectedCarrierGetFromEvent);

       var rec = component.get("v.recordIdentify");
       if (recordchange == rec )
        {
       var Carrier = selectedCarrierGetFromEvent.Carrier_ID__c;
       var carrierrowid = selectedCarrierGetFromEvent.Id;
	   component.set("v.SelectedCarrier" , Carrier); 
       var platformId = component.get("v.platformId");
        if (platformId != null) {
            //helper.UpdateCarrierPlatformSpec(component,event,carrierrowid);
        }
        component.set("v.isnewpill", false);
        component.set("v.iseditpill", true);
        var forclose = component.find("lookup-pill");
           $A.util.addClass(forclose, 'slds-show');
           $A.util.removeClass(forclose, 'slds-hide');
  
        var forclose = component.find("searchRes");
           $A.util.addClass(forclose, 'slds-is-close');
           $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show');  
        }
	},
    RequiredHighlight: function(component, event, helper) 
       {
         debugger;
         var recordchange =  event.getParam("recordIdentify");
         var rec = component.get("v.recordIdentify");
         if (recordchange == rec )
        {
           component.set("v.isLevelrequired" , true);
        }
       },
    
    handleLookupVisibility: function(component, event, helper)
      {
         var recordchange =  event.getParam("recordIdentify");
         var rec = component.get("v.recordIdentify");
      	 if (recordchange == rec )
       		{   
                helper.clearvalues(component,event,helper);
   
       		 }
      },
    showLevelRequired: function(component, event, helper)
     {
        document.getElementById("cmp_level1").style.display = 'block';
       },
    showSpinner : function (component, event, helper) {
  	   component.set("v.Spinner", true);   
    },

    hideSpinner : function (component, event, helper) {
	   component.set("v.Spinner", false);   
    },
})