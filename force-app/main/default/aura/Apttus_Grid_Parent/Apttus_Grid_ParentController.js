({
    doInit : function(component, event, helper) {
         helper.doInitHelper(component, event, helper);
    },
    handleMLOBSaveEvent : function(component, event, helper) 
    {
       if(component.get("{!v.ObjectName}")=="Rebate_Guarantee__c")   
       {  
           component.set("{!v.AddAdditionalRebate}",false);
           helper.doInitHelper(component, event, helper);
       }
    },
    handleLOB : function(component, event, helper) 
    {
       if(component.get("{!v.ObjectName}")=="Network_Pricing__c")   
       {  
           component.set("{!v.AddAdditionalNP}",true);
       }
        if(component.get("{!v.ObjectName}")=="Billing_Admin_Fee__c")   
       {  
           component.set("{!v.AddAdditionalAdmin}",true);
       }
       if(component.get("{!v.ObjectName}")=="Rebate_Guarantee__c")   
       {  
           component.set("{!v.AddAdditionalRebate}",true);
       }
       if(component.get("{!v.ObjectName}")=="Mail_Pricing__c")   
       {  
           component.set("{!v.AddAdditionalMP}",true);
       } 
       if(component.get("{!v.ObjectName}")=="Specialty_Pricing__c")   
       {  
           component.set("{!v.AddAdditionalSpecialty}",true);
       } 
    },
    handleSaveAndClose : function (component, event, helper) {
        var isSavedAndClose = event.getParam("isSavedAndClose");
        component.set("v.isSavedAndClose", isSavedAndClose);
    },
    closeEdit : function(component, event, helper)  {
        var section = event.getParam("Section");
        if(component.get("{!v.ObjectName}")=="Billing_Admin_Fee__c")   {
            if (section == "ELECTRONIC") {
                component.set("v.AddGridElectronic", true);
            }
            if (section == "MANUAL") {
                component.set("v.AddGridManual", true);
            }
            if (section == "340B") {
                component.set("v.AddGridM340B", true);
            }
            if(component.get("v.AddGridElectronic")== true && component.get("v.AddGridManual")== true && component.get("v.AddGridM340B")== true) {
                helper.updatealistatus(component, event, helper);
                helper.getlineitem(component, event, helper); 
            }
        }
        if( component.get("{!v.ObjectName}") == "Rebate_Guarantee__c")  {  
            
            var section = event.getParam("Section");
            var isSaved = event.getParam("Save");
            var isCopyComplete = event.getParam("isCopyComplete");
            var isSavedAndClose =  event.getParam("isSavedAndClose");
            component.set("v.isSavedAndClose", isSavedAndClose);
            if(isCopyComplete == undefined || isCopyComplete == false){
                console.log('-                                            - ');  
                console.log('is2TQSaved ppppppp '+component.get("v.is2TQSaved"));
                console.log('is3TQSaved ppppppp '+component.get("v.is3TQSaved"));
                console.log('is3TNQSaved ppppppp '+component.get("v.is3TNQSaved"));
                console.log('isClosedSaved ppppppp '+component.get("v.isClosedSaved"));
                console.log('isSpecSaved ppppppp '+component.get("v.isSpecSaved"));
                console.log('-                                            - ');  
                if (section == "2TQ" && isSaved){
                    component.set("v.is2TQSaved", isSaved); 
                }
                if (section == "3TQ"  && isSaved){
                    component.set("v.is3TQSaved", isSaved);
                }
                if (section == "3TNQ"  && isSaved){
                    component.set("v.is3TNQSaved", isSaved);
                }
                if (section == "Closed"  && isSaved){
                    component.set("v.isClosedSaved", isSaved);
                }
                if (section == "Specialty"  && isSaved){
                    component.set("v.isSpecSaved", isSaved);
                }
                var isClose2TQEdit = false;
                var isClose3TQEdit = false;
                var isClose3TNQEdit = false;
                var isCloseClosedEdit = false;
                var isCloseSpecEdit = false;
				console.log('-                                            - '); 
				console.log('is2TQAvailable ppppppppppppppp  '+component.get("v.is2TQAvailable"));
                console.log('is3TQAvailable ppppppppppppppp  '+component.get("v.is3TQAvailable"));
                console.log('is3TNQAvailable ppppppppppppppp  '+component.get("v.is3TNQAvailable"));
                console.log('is3TNQAvailable ppppppppppppppp  '+component.get("v.isClosedAvailable"));
                console.log('isSpecAvailable ppppppppppppppp  '+component.get("v.isSpecAvailable"));    
                   
                
                if(component.get("v.is2TQAvailable")== true){
                    if(component.get("v.is2TQSaved")== true){
                        isClose2TQEdit = true;
                    }
                } else {
                    isClose2TQEdit = true;
                }
                if(component.get("v.is3TQAvailable")== true){
                    if(component.get("v.is3TQSaved")== true){
                        isClose3TQEdit = true;
                    }
                } else {
                    isClose3TQEdit = true;
                }
                if(component.get("v.is3TNQAvailable")== true){
                    if(component.get("v.is3TNQSaved")== true){
                        isClose3TNQEdit = true;
                    }
                } else {
                    isClose3TNQEdit = true;
                }
                if(component.get("v.isClosedAvailable")== true){
                    if(component.get("v.isClosedSaved")== true){
                        isCloseClosedEdit = true;
                    }
                } else {
                    isCloseClosedEdit = true;
                }
                if(component.get("v.isSpecAvailable")== true){
                    if(component.get("v.isSpecSaved")== true){
                        isCloseSpecEdit = true;
                    }
                } else {
                    isCloseSpecEdit = true;
                }
                
                console.log('-                                            - '); 
                console.log('isClose2TQEdit ppppppppppp  '+isClose2TQEdit);
                console.log('isClose3TQEdit ppppppppppp  '+isClose3TQEdit);
                console.log('isClose3TNQEdit ppppppppppp  '+isClose3TNQEdit);
                console.log('isCloseClosedEdit ppppppppppp  '+isCloseClosedEdit);
                console.log('isCloseSpecEdit ppppppppppp  '+isCloseSpecEdit);
                console.log('-                                            - '); 
                if(isClose2TQEdit ==  true && isClose3TQEdit ==  true && isClose3TNQEdit ==  true && isCloseClosedEdit ==  true  && isCloseSpecEdit == true) {
                    console.log('-                 parent close                           - '); 
                    helper.updatealistatus(component, event, helper);
                    helper.getlineitem(component, event, helper);	
                }
            } else if(isCopyComplete == true) {
                helper.updatealistatus(component, event, helper);
                helper.getlineitem(component, event, helper);	
            } 
        }
        if(component.get("{!v.ObjectName}") != "Billing_Admin_Fee__c" && component.get("{!v.ObjectName}") != "Rebate_Guarantee__c")  {  
            helper.updatealistatus(component, event, helper);
            helper.getlineitem(component, event, helper);	
        }
        
    },
    handleSave : function(component, event, helper)  {
        if(component.get("{!v.ObjectName}")=="Billing_Admin_Fee__c") 
        {
            component.set("v.AddGridElectronic", false);
            component.set("v.AddGridManual", false);
            component.set("v.AddGridM340B", false);
        }
        if(component.get("{!v.ObjectName}")=="Rebate_Guarantee__c")  {
            component.set("v.is2TQSaved" , false);
            component.set("v.is3TQSaved" , false);
            component.set("v.is3TNQSaved" , false);
            component.set("v.isClosedSaved" , false);
            component.set("v.isSpecSaved" , false);
        }
    },
    stylechange : function(component, event, helper)  {
        var cmpTarget = component.find('modalheight');
        $A.util.addClass(cmpTarget, 'finalheight');
        component.set("v.disablesavebtn", false);
    },
    handleClose : function(component, event, helper)  {
         component.set("v.clickNewModal", false);
        	
    },
    handleCloseEdit : function(component, event, helper) {
         component.set("v.clickNewModal", false);
    },
    handleError : function(component, event, helper)  {   
        var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Error_Event");
        var Errmsg = event.getParam("Error")
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error!',
            mode : 'sticky',
            type : 'error',
            message : Errmsg,
            mode: 'sticky',
            duration:' 4000'
        });
        toastEvent.fire();
    },
    handleSelect : function (component, event, helper) {
        var stepName = event.getParam("detail").value;
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "Toast from " + stepName
        });
        toastEvent.fire();
    },
    GridChange : function (component, event, helper)  {
        var gridname =  event.getParam("gridname");
        component.set("{!v.ObjectName}",gridname);
        
        if(gridname == "Specialty_Pricing__c") {
            component.set("v.isSpecialty", true);
        } else {
            component.set("v.isSpecialty", false);
        }
        
        if(gridname == "Rebate_Guarantee__c") {
            component.set("v.isRebate", true);
        } else {
            component.set("v.isRebate", false);
        }
        
        if(gridname == "Network_Pricing__c") {
            component.set("v.btnvisible", true);
        } else {
            component.set("v.btnvisible", false);
        }
        
        helper.getThisReconciliation(component, helper);
        if (component.get("v.OpsId")==null || component.get("v.OpsId")=="") {
            
            component.set("v.disablebtn", true);
        } else {
            component.set("v.disablebtn", false);
        }
    },
    create : function(component, event, helper)  {
        component.set("v.disablesavebtn", true);
        if (component.get("{!v.ObjectName}")=="Network_Pricing__c") {
            component.set("v.disablesavebtn", true);
            var npoId = component.get("v.OpsId");
            component.set("v.clickNewModal", true);
            var cmpTarget = component.find('modalheight');
            $A.util.addClass(cmpTarget, 'initheight');
            component.set("v.DisplaySpinner", true);
        }
        
        if (component.get("{!v.ObjectName}")=="Mail_Pricing__c") {
            var npoId = component.get("v.OpsId");
            component.set("v.clickNewModal", true);
        }
    },
    cancel : function(component, event, helper)  
     {
       if(component.get("{!v.ObjectName}")=="Network_Pricing__c")   
       {  
           component.set("{!v.AddAdditionalNP}",false);
       }
        if(component.get("{!v.ObjectName}")=="Billing_Admin_Fee__c")   
       {  
           component.set("{!v.AddAdditionalAdmin}",false);
       }
       if(component.get("{!v.ObjectName}")=="Rebate_Guarantee__c")   
       {  
           component.set("{!v.AddAdditionalRebate}",false);
       }
       if(component.get("{!v.ObjectName}")=="Mail_Pricing__c")   
       {  
           component.set("{!v.AddAdditionalMP}",false);
       }  
       if(component.get("{!v.ObjectName}")=="Specialty_Pricing__c")   
       {  
           component.set("{!v.AddAdditionalSpecialty}",false);
       } 
        component.set("v.clickNewModal", false);
        var appEvent = $A.get("e.c:Apttus_Grid_NT_Close_Event");
        appEvent.fire();
    },
     updatelobpricing : function(component, event, helper)   {
         if(component.get("{!v.ObjectName}")=="Rebate_Guarantee__c") 
         {
              var appEventR = $A.get("e.c:Apttus_Grid_Add_MLOB_Rebate_Event");
              appEventR.setParams({ "rebate" : component.get("v.rebatedefault") });
              appEventR.fire();
              var appEventM = $A.get("e.c:Apttus_Grid_Add_MLOB_Count_Event");
			  appEventM.setParams({ "count" : 0});
              appEventM.fire();
         }
     },
    updateMail : function(component, event, helper){
        var mailAddComp = component.find('mailAdd');
        mailAddComp.saveMethod();
        component.set("{!v.AddAdditionalMP}",false);
    },
    updatepricing : function(component, event, helper)   {
         if(component.get("{!v.ObjectName}")=="Rebate_Guarantee__c") 
         {
             
         }
        var appEvent = $A.get("e.c:Apttus_Grid_NT_Save_Event");
        appEvent.setParams({ "SaveRec" : true});
        appEvent.fire();	
        if(component.get("{!v.ObjectName}")=="Rebate_Guarantee__c")  {
            component.set("v.is2TQSaved" , false);
            component.set("v.is3TQSaved" , false);
            component.set("v.is3TNQSaved" , false);
            component.set("v.isClosedSaved" , false);
            component.set("v.isSpecSaved" , false);
        }
    },
    
    handleRebateSection : function(component, event, helper)  {
        var section = event.getParam("section");
        var isAvailable = event.getParam("isAvailable");
        if (section == "2TQ"){
            component.set("v.is2TQAvailable", isAvailable);
        }
        if (section == "3TQ"){
            component.set("v.is3TQAvailable", isAvailable);
        }
        if (section == "3TNQ"){
            component.set("v.is3TNQAvailable", isAvailable);
        }
        if (section == "Closed"){
            component.set("v.isClosedAvailable", isAvailable);
        }
        if (section == "Specialty"){
            component.set("v.isSpecAvailable", isAvailable);
        }
    },
    handleAddProg : function(component, event, helper)  {
        //var checkCmp = component.find("chkbox").get("v.value");
        //alert(checkCmp);
        //alert(component.get("v.isDiaplayAddProg"));
        //component.set("v.chkboxvalue",checkCmp);
        var action1 = component.get("c.update_AgreementObj");
        action1.setParams({"RecId":  component.get("v.record"),
                          "isDisplayAdProg":  component.get("v.isDiaplayAddProg")})
        action1.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                
            } 
        }));
        $A.enqueueAction(action1); 
    },
    handleNPSeqNumberChange : function(component, event, helper)  {
        helper.handleSeqNumberChange(component, event, helper, 'Network_Pricing__c');
    },
    handleMPSeqNumberChange : function(component, event, helper)  {
        helper.handleSeqNumberChange(component, event, helper, 'Mail_Pricing__c');
    },
    handleSpecialtySeqNumberChangeHelper : function(component, event, helper)  {
        helper.handleSeqNumberChange(component, event, helper,'Specialty_Pricing__c');
    },
    handleNPUpClick : function(component, event, helper)  {
        helper.handleUpClick(component, event, helper, 'Network_Pricing__c');
    },
    handleNPDownClick : function(component, event, helper)  {
        helper.handleDownClick(component, event, helper, 'Network_Pricing__c');
    },
    handleNPDownClick : function(component, event, helper)  {
        helper.handleDownClick(component, event, helper, 'Network_Pricing__c');
    },
    //changes By Mohit Srivastava : Specialty 
    handleSpecUpClick : function(component, event, helper)  {
        helper.handleUpClick(component, event, helper, 'Specialty_Pricing__c');
    },
    handleSpecDownClick : function(component, event, helper)  {
        helper.handleDownClick(component, event, helper, 'Specialty_Pricing__c');
    },
    
     handleMPUpClick : function(component, event, helper)  {
        helper.handleUpClick(component, event, helper, 'Mail_Pricing__c');
    },
    handleMPDownClick : function(component, event, helper)  {
        helper.handleDownClick(component, event, helper, 'Mail_Pricing__c');
    },
    //////////////////////////////////////////////////
    handleRGSeqNumberChange : function(component, event, helper)  {
        helper.handleSeqNumberChange(component, event, helper, 'Rebate_Guarantees__c');
    },
    handleRGUpClick : function(component, event, helper)  {
        helper.handleUpClick(component, event, helper, 'Rebate_Guarantees__c');
    },
    handleRGDownClick : function(component, event, helper)  {
        helper.handleDownClick(component, event, helper, 'Rebate_Guarantees__c');
    },

})