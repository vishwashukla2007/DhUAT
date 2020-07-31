({
	doInit : function(component, event, helper) {
         helper.getAccessInfo(component, event);  
        var url_string = window.location.href;
        var url = new URL(url_string);
		var ROId = url.searchParams.get("ROId");
      //  ROId = component.get("v.recordId");
     //   alert('ROId'+component.get("v.recordId"));
      console.log('___'+component.get("v.recordId"));
        
        if( component.get("v.recordId") )
        {
          ROId = component.get("v.recordId");
        }
        
	     component.set("v.RGOpId", ROId); 
         //component.set("v.RGOpId", "a6A1D0000004IvjUAE"); 
     //   console.log(ROId);
        
        helper.getRGTinfo(component, event);  
        /*
        		 helper.isCreatable(component, event);
        helper.isDeleteAccess(component, event);
        helper.isEditAccess(component, event);
        */
	},
    
    clickNew : function(component, event, helper) 
	{
	    component.set("v.RGNew",true);
        component.set("v.vfHost",window.location.hostname);
        var RGOpId = component.get("v.recordId");
        var rebateGuarLabel = $A.get("$Label.c.rebateGuaranteerOperations");
        component.set("v.RGParams",rebateGuarLabel+'='+RGOpId+'&isExpandableView=true');
		//component.set("v.RGParams","CF00N1D000001KehK_lkid="+RGOpId+'&isExpandableView=true');
	},
    
     selectAllRecords : function(component, event, helper){
        var isSeleted = event.getSource().get("v.value");
        var getCheckAllId = component.find("cboxRow");
        var allRecords = component.get("v.RebateGuarlist");
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
               //$A.util.addClass(cmpTarget, 'slds-hide');
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
        var allRecords = component.get("v.RebateGuarlist");
        if(allRecords.length ===1 && component.find("cboxRow")[0] == undefined) {
            if(seletedRow == false) {
                component.find("cboxRow").set("v.value", false);
                component.find("cbox").set("v.value", false);
            // $A.util.addClass(cmpTarget, 'slds-hide');
                
            } else{
                //$A.util.removeClass(cmpTarget, 'slds-hide');
                
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
        var allRecords = component.get("v.RebateGuarlist")
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
        var allRecords = component.get("v.RebateGuarlist")
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