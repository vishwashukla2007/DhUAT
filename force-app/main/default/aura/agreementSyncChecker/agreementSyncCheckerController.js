({
    onPageReferenceChange : function(component, event, helper) {        
        var action = component.get("c.compareAgreementAndFAF");
        action.setParams({"agreementId": component.get("v.recordId"),
                          "IsBatchJob" : false,
                          "agreeList" : null,
                          "owea" : null,
                          "IsForceRun" : false});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){                
                var action2 = component.get("c.checkLegalDocSync");
                action2.setParams({"agreementId": component.get("v.recordId")});
                action2.setCallback(this, function(response){
                    var state2 = response.getState();
                    if (state2 === "SUCCESS"){                        
                        var result2 = response.getReturnValue();
                        if(result2 == true){                            
                            var action3 = component.get("c.compareAgreementExtVspbmReq");
                            action3.setParams({"agreementId": component.get("v.recordId"),
                                               "sendEmail": false,
                                               "updateAgreement": true
                                              });
                            action3.setCallback(this, function(response){
                                var state3 = response.getState();
                                if (state3 === "SUCCESS"){                                    
                                    var result3 = response.getReturnValue();                                    
                                    $A.get('e.force:refreshView').fire();
                                }
                            });
                            $A.enqueueAction(action3);                            
                        }else{                          
                          $A.get('e.force:refreshView').fire();  
                        }                                                                                                                        
                    }
                });
                $A.enqueueAction(action2);
            }
        });
        $A.enqueueAction(action);   
    },
    showSpinner : function(component, event, helper) {        
        component.set("v.IsSpinner", true); 
    },
    hideSpinner : function(component, event, helper) {        
        component.set("v.IsSpinner", false);
    },
})