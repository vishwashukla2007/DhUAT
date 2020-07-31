({
doInit : function(component, event, helper) 
    {
     helper.retrievepcd(component, event, helper); 
     helper.tasksubtype(component, event, helper);  
	},
handleChange: function (component, event, helper) {
        var selectlob = component.find("selectlob");
        var changeValue = selectlob.get("v.value");
        var loblist =  component.get("{!v.loblist}");
        component.set("v.selectedLOBs",component.get("v.newLOBs")); 
        for(var lob in loblist) 
        {
         if (loblist[lob].LobId__c != changeValue)
         {
         var selectedLOBs = component.get("v.selectedLOBs"); 
         selectedLOBs.push({ label: loblist[lob].LOB_Description__c, value: loblist[lob].LOB_Description__c });
         component.set("v.selectedLOBs",selectedLOBs); 
         var addlob = component.find("lobgroup");
         addlob.set("v.value", false);
         }
        }
        component.set("v.options",component.get("v.selectedLOBs"));
    },
handleofferEvent : function(component, event, helper) 
    {
        var offer = event.getParam("offer");
        var offerid = event.getParam("offerid");
        var alertmsg = event.getParam("alertmsg");
        component.set("{!v.offername}",offer);
        component.set("{!v.offerid}",offerid);
        component.set("{!v.alertmsg}",alertmsg);
        helper.retrievepcd(component, event, helper);
        helper.tasksubtype(component, event, helper);  
    },   
 createPCD : function(component, event, helper) 
    {
     component.set("{!v.isCreatePCDOpen}",true);
	},
 startPCD : function(component, event, helper) 
    {
     component.set("{!v.DisplaySpinner}",true);
     helper.createpcd(component, event, helper);   
	},
 closePcdCreate : function(component, event, helper) 
    {
     component.set("{!v.isCreatePCDOpen}",false);
	},
  recentActivity : function(component, event, helper) 
    {
     var acc = component.find("recentact");
        for(var cmp in acc) 
         {
        	$A.util.toggleClass(acc[cmp], 'slds-show');  
        	$A.util.toggleClass(acc[cmp], 'slds-hide');  
         }
    },
})