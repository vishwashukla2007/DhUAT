({
    doInit : function(component, event, helper) {
        var record = component.get("v.recordId");
        var action = component.get('c.createapproval');
		action.setParams({
            "FAFRecId" : record
        })
        action.setCallback(this,function(response){
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
			
                console.log('==> '+ response.getReturnValue() );
                //set response value in objClassController attribute on component
                component.set('v.showEditBtn', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        //Added by: ryan.francis.m.roque@accenture.com
    	//Date Modified: 01/21/2020
    	//CLM US: US22856
        //Check PBM custom permission
        var action2 = component.get('c.checkPBMCustomPermission');
        action2.setParams({
            "FAFRecId" : record
        })
        action2.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('==> '+ response.getReturnValue() );
                component.set('v.showReqPBM', response.getReturnValue());
            }
        });
        $A.enqueueAction(action2);
    }, 
    handleEditBtn : function(component, event, helper) 
    {
        component.set("v.showModal", true);
        component.set("v.vfHost",window.location.hostname);
        var cinfo = component.get("v.recordId");
        component.set("v.params", 'id'+'='+cinfo);
    },
      printBtn : function(component, event, helper) 
    {
        component.set("v.showPrint", true);
        component.set("v.vfHost",window.location.hostname);
        var cinfo = component.get("v.recordId");
        component.set("v.params", 'id'+'='+cinfo);
    },
    //Added by: ryan.francis.m.roque@accenture.com
    //Date Modified: 01/21/2020
    //CLM US: US22856
    reqPBM : function(component, event, helper) {
        var evt = $A.get("e.force:navigateToComponent");
        console.log('Event '+evt);
        var fafId = component.get("v.recordId");     
        evt.setParams({
            componentDef  : "c:flowHandlerComp" ,
            componentAttributes : {
                fafid : fafId
            }          
        });        
        evt.fire();
    },
    reqPBMNew : function(component, event, helper) {       
        var c__myAttr = '';
        var c__myAttr2 = '';
        var action = component.get("c.getFAF");
        action.setParams({
            "FAFId": component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){              
                var result = response.getReturnValue();                
                var isValid = true;
                if(result.masterAgreementId != 'undefined' && result.masterAgreementId != null){
                    isValid = false;                                                            
                }else if(result.FAFStatus == 'Deleted' || result.FAFStatus == 'Closed' || result.FAFStatus == 'Template'){
                    isValid = false;
                }else{                                        
                    component.set("v.FAFName", result.FAFName);
                    if(result.pbmRequestId == 'undefined' || result.pbmRequestId == null){
                        c__myAttr = component.get("v.recordId");
                        c__myAttr2 = component.get("v.sObjectName");
                    }else{
                        c__myAttr = result.pbmRequestId;
                        c__myAttr2 = 'PBMRequest__c';
                    }                                                
                    component.find("navService").navigate({
                        type: "standard__component",
                        attributes: {
                            componentName: "c__PBMRequestAuraHolderLWC" 
                        },
                        state: { 
                            "c__myAttr": c__myAttr,
                            "c__myAttr2": c__myAttr2,
                        }
                    });                                                                                
                }
                if(!isValid){
                    var toastMessage;
                    if(result.masterAgreementId != 'undefined' && result.masterAgreementId != null){
                        toastMessage = $A.get("$Label.c.pbmRequestMasterAgreementAlreadyAvailable");                                                            
                    }else if(result.FAFStatus == 'Deleted' || result.FAFStatus == 'Closed' || result.FAFStatus == 'Template'){
                        toastMessage = $A.get("$Label.c.pbmRequestInvalidStatus");                                                            
                    }
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : '',
                        message: toastMessage,                        
                        duration:' 2000',                      
                        type: 'error',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                                       
                    var navLink = component.find("navService");
                    var pageRef = {
                        type: 'standard__recordPage',
                        attributes: {
                            actionName: 'view',
                            objectApiName: 'Central_Hub__c',
                            recordId : component.get("v.recordId") // change record id. 
                        },
                    };
                    navLink.navigate(pageRef, true);
                }                
            }                                  
        });
        $A.enqueueAction(action);
    },
    
})