({
	doInit : function(component, event, helper) 
	{
	    //component.set("v.vfHost",window.location.hostname);
		//console.log(window.location.hostname);
        var action = component.get("c.getMailGuarantees");
         action.setParams({ mpId : component.get("v.mpId") });
         action.setCallback(this, function(result) 
         {
           var state = result.getState();
           if (state === "SUCCESS") 
           {
                component.set("v.mailGuranteeList", result.getReturnValue());
           }
           else if (state === "INCOMPLETE") {
                // Need to Provide Error Message
                
             } 
           else if (state === "ERROR") {
              var errors = result.getError();
              if (errors) {
                  if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                        errors[0].message);
                     }
                } else {
                   console.log("Unknown error");
                }
           } 
        });
        $A.enqueueAction(action);
        /*
        		 helper.isCreatable(component, event);
        helper.isDeleteAccess(component, event);
        helper.isEditAccess(component, event);
        */
	},
	clickNew : function(component, event, helper) 
	{
	    component.set("v.mgNew",true);
        component.set("v.vfHost",window.location.hostname);
        var mpId = component.get("v.mpId");
        var mailPricinglabel = $A.get("$Label.c.MailPricingFieldId");  
		component.set("v.mgParams",mailPricinglabel+'='+mpId+'&isExpandableView=true');
	},
    
    
    selectAllRecords : function(component, event, helper){
        var isSeleted = event.getSource().get("v.value");
        var getCheckAllId = component.find("cboxRow");
        var allRecords = component.get("v.mailGuranteeList");
         var cmpTarget = component.find("changeIt");
         
         if(allRecords.length ===1 && getCheckAllId[0] === undefined ){
             if (isSeleted) {
                 getCheckAllId.set("v.value", true)
                 $A.util.removeClass(cmpTarget, 'slds-hide');

             } else{
                // $A.util.addClass(cmpTarget, 'slds-hide');
                 getCheckAllId.set("v.value", false)
             }
         } else{
             
             if (isSeleted) {
                 //$A.util.removeClass(cmpTarget, 'slds-hide');
                 for (var i = 0; i < getCheckAllId.length; i++) {
                     component.find("cboxRow")[i].set("v.value", true); 
                     
                 }
             } else {
                // $A.util.addClass(cmpTarget, 'slds-hide');
                 for (var i = 0; i < getCheckAllId.length; i++) {
                     component.find("cboxRow")[i].set("v.value", false);
                 }
             }
         }
    },
    onCheckboxSelect : function(component, event, helper) {
        var seletedRow = event.getSource().get("v.value");
        var getCheckAllId = component.find("cbox");
        var cmpTarget = component.find("changeIt"); // if single record present
        var allRecords = component.get("v.mailGuranteeList");
        if(allRecords.length ===1 && component.find("cboxRow")[0] == undefined) {
            if(seletedRow == false) {
                component.find("cboxRow").set("v.value", false);
                component.find("cbox").set("v.value", false);
               //$A.util.addClass(cmpTarget, 'slds-hide');
                
            } else{
               // $A.util.removeClass(cmpTarget, 'slds-hide');
                
            }
        } else {
           // $A.util.addClass(cmpTarget, 'slds-hide');
            if(seletedRow == false) {
                component.find("cbox").set("v.value", false);
               // $A.util.addClass(cmpTarget, 'slds-hide');
            }
            var getCheckAllId1 = component.find("cboxRow");
            if(getCheckAllId1.length != 0) {
                for (var i = 0; i < getCheckAllId1.length; i++) {
                    if(getCheckAllId1[i].get("v.value")){
                        $A.util.removeClass(cmpTarget, 'slds-hide');
                        break;
                    }
                }
            }
            
            
        }
        
    },
    
    deleteSelected : function(component,event,helper) {
        var getCheckAllId = component.find("cboxRow");
        var selctedRec = [];
        var getCheckAllId = component.find("cboxRow");
        var allRecords = component.get("v.mailGuranteeList")
        if(allRecords.length ===1 && getCheckAllId[0] === undefined) {
            if(getCheckAllId.get("v.value")){
                selctedRec.push(getCheckAllId.get("v.text")); 
            }
        } else {
            if(getCheckAllId.length != 0) {
                for (var i = 0; i < getCheckAllId.length; i++) {
                    if(getCheckAllId[i].get("v.value")){
                        selctedRec.push(getCheckAllId[i].get("v.text")); 
                    }
                }
            }
        }
        
        if(selctedRec.length != 0) {
            component.set("v.isDeleteAlertOpen", true);
            //helper.deleteSelectedRecords(component,event,selctedRec);
        }
    },
    
     deleteSelectedRec : function(component,event,helper) {
        var getCheckAllId = component.find("cboxRow");
        var selctedRec = [];
        var getCheckAllId = component.find("cboxRow");
        var allRecords = component.get("v.mailGuranteeList")
        if(allRecords.length ===1 && getCheckAllId[0] === undefined) {
            if(getCheckAllId.get("v.value")){
                selctedRec.push(getCheckAllId.get("v.text")); 
            }
        } else {
            if(getCheckAllId.length != 0) {
                for (var i = 0; i < getCheckAllId.length; i++) {
                    if(getCheckAllId[i].get("v.value")){
                        selctedRec.push(getCheckAllId[i].get("v.text")); 
                    }
                }
            }
        }
        helper.deleteSelectedRecords(component,event,selctedRec);
        component.set("v.isDeleteAlertOpen", false);

    },
    
    closeDeleteAlert: function(component, event, helper) {
        component.set("v.isDeleteAlertOpen", false);
    },

})