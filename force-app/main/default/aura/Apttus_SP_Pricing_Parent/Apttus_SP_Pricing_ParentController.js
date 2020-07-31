({	 
	doInit : function(component, event, helper) {
        helper.getAccessInfo(component, event);  
        var url_string = window.location.href;
        var url = new URL(url_string);
		var soId = url.searchParams.get("soId");
		//component.set("v.ntopId", soId); 
		//
		if( component.get("v.recordId") )
        {
          soId = component.get("v.recordId");
        }
		component.set("v.sopId", soId); 
        helper.getSPricinginfo(component, event);  
        /*
        		 helper.isCreatable(component, event);
        helper.isDeleteAccess(component, event);
        helper.isEditAccess(component, event);
        */
	},
      	clickNew : function(component, event, helper) {
        var spoLabel = $A.get("$Label.c.SpecialtyOpsLabel");            
        var spId = component.get("v.recordId");
        component.set("v.params", 'lightning=true&'+spoLabel+'='+spId);
        component.set("v.clickNewModal", true);
    },
    
    
    
     selectAllRecords : function(component, event, helper){
        var isSeleted = event.getSource().get("v.value");
        var getCheckAllId = component.find("cboxRow");
        var allRecords = component.get("v.spricings");
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
               //  $A.util.removeClass(cmpTarget, 'slds-hide');
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
        var allRecords = component.get("v.spricings");
        if(allRecords.length ===1 && component.find("cboxRow")[0] == undefined) {
            if(seletedRow == false) {
                component.find("cboxRow").set("v.value", false);
                component.find("cbox").set("v.value", false);
              // $A.util.addClass(cmpTarget, 'slds-hide');
                
            } else{
              //  $A.util.removeClass(cmpTarget, 'slds-hide');
                
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
    closeDeleteErrMsg : function(component,event,helper) {
         component.set("v.deleteErrMsglst", []);
    },
    
    openDeletePopUp : function(component,event,helper) {
          var getCheckAllId = component.find("cboxRow");
        var selctedRec = [];
        var getCheckAllId = component.find("cboxRow");
        var allRecords = component.get("v.spricings")
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
        }
    },
    
    deleteSelected : function(component,event,helper) {

        var getCheckAllId = component.find("cboxRow");
        var selctedRec = [];
        var getCheckAllId = component.find("cboxRow");
        var allRecords = component.get("v.spricings")
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
            var recordids=[];
            for(var i=0;i<selctedRec.length;i++){
                recordids.push(selctedRec[i].Id);
            }
          
            var action = component.get("c.beforeDelSpecialtyRecord");
            action.setParams({ recordId :recordids});
            action.setCallback(this, function(result) {
                var state = result.getState();
                if (state === "SUCCESS") {
                    component.set("v.isDeleteAlertOpen", false);
                    var deleteErrMsglst= result.getReturnValue();
                    console.log("deleteErrMsglst,",deleteErrMsglst);
                    component.set("v.deleteErrMsglst", deleteErrMsglst);
                    
                    if(deleteErrMsglst.length==0){
                        helper.deleteSelectedRecords(component,event,selctedRec);
                    }
                }
                 else if (state ==="ERROR") {
                       var errors = result.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                            
                   var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: errors[0].message,
                    type: 'Error',
                    mode: 'pester'
                });
                toastEvent.fire();
                    
                }
				}
			component.set("v.isDeleteAlertOpen", false);
			}
            });
            $A.enqueueAction(action);     
            
        }
    },
    
     deleteSelectedRec : function(component,event,helper) {
        var getCheckAllId = component.find("cboxRow");
        var selctedRec = [];
        var getCheckAllId = component.find("cboxRow");
        var allRecords = component.get("v.spricings")
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