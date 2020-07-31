({
	doInit : function(component, event, helper) {

	},
   
    clickEdit : function(component, event, helper) { 
        var recordId = component.get("v.ntpricing.Id");
        component.set("v.params", 'lightning=true&id='+recordId);   
        component.set("v.clickEditModal", true);  
		console.log(component.get("v.params"));
        console.log(component.get("v.clickEditModal"));        
    }, 
      /*  var recordId = component.get("v.ntpricing.Id");
        var url = '/apex/NetworkPricingEditNewPage?id=' + recordId;
        window.open(url, '_self'); */
        
	/*	component.set("v.visible", true);
        component.set("v.readonly", false);
       	var priceEvent = $A.get("e.c:Apttus_Network_Pricing");
        priceEvent.setParams({"message" : false, 
                              "priceid" : component.get("v.ntpricing.Id")});
        priceEvent.fire(); */
 	deletePricing : function(component, event, helper) { 
        //alert(component.get("v.networkOperationsId"))
        var recordId = component.get("v.ntpricing.Id");
    	console.log('recordId ::'+recordId);
        component.set("v.isDeleteAlertOpen", true);
		//helper.deleteRecord(component, event);        
    },
    closeDeleteAlert: function(component, event, helper) {
        component.set("v.isDeleteAlertOpen", false);
    },
    deleteRecord : function(component, event, helper) { 
        
		helper.deleteRecord(component, event);        
    }
    
})