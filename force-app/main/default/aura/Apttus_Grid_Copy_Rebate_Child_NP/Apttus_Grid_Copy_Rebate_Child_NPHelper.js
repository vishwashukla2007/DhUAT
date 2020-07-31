({
    fetchpicklistvalue : function(component, helper) {
        
        var action = component.get("c.findPicklistOptions");
        action.setParams({
            "objAPIName":  "Rebate_Guarantees__c",
            "fieldAPIname": "Plan_Design__c"
        })
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.Plandesign", response.getReturnValue());
            } else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
        
        var action = component.get("c.findPicklistOptions");
        action.setParams({
            "objAPIName":  "Rebate_Guarantees__c",
            "fieldAPIname": "GSTP__c"
        })
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.GstpOption", response.getReturnValue());
            } else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
        
        var action = component.get("c.findPicklistOptions");
        action.setParams({
            "objAPIName":  "Rebate_Guarantees__c",
            "fieldAPIname": "Non_Specialty_Formulary_2__c"
        })
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.NonSpec", response.getReturnValue());
            } else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
        
        var action = component.get("c.findPicklistOptions");
        action.setParams({
            "objAPIName":  "Rebate_Guarantees__c",
            "fieldAPIname": "Specialty_Formulary__c"
        })
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.Spec", response.getReturnValue());
            } else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
        
        var action = component.get("c.findPicklistOptions");
        action.setParams({
            "objAPIName":  "Rebate_Guarantees__c",
            "fieldAPIname": "Basis__c"
        })
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.brandbasis", response.getReturnValue());
            } else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
    },
    handleValidateHelper:function(component, event, helper){
        //var isMatchToSave = event.getParam("isMatchToSave");
        var isError = false;
        var percentageCheck = component.get("v.percentageCheck");
        var currentSection = component.get("v.planDesignOption");
        var matchToToGrid = event.getParam("matchToToGrid");
		//alert('currentSection--------'+currentSection);   
        //alert('-matchToToGrid-------'+matchToToGrid); 
        //alert('--isMatchToSave------'+isMatchToSave); 
        //alert('handleSaveNew');
        
        if(component.get("v.display") == true) {
            var Req1 = 0; var Req2 = 0; var Req3 = 0; var Req4 = 0; var Req5 = 0; var Req6 = 0; var Req7 = 0; 
            var Req8 = 0; var Req9 = 0; var Req10 = 0; var Req11 = 0;  var Req12 = 0;  var Req13 = 0; var Req14 = 0; var Req15 = 0; var Req16 = 0; var Req17=0; 
            var messagestr;
            if(component.get("v.display") == true) {
                var inputcmp1 = component.find("inputYear");
                var value;
                if(inputcmp1 != undefined)
                    value = inputcmp1.get("v.value");
                if(value == null || value =="") {
                    Req1 =1;       
                    $A.util.addClass(inputcmp1, "slds-has-error");
                    if (messagestr== null)
                        messagestr = 'Year: Required Field. \n';
                    else {
                        messagestr += 'Year: Required Field. \n';
                    }
                } else {
                    $A.util.removeClass(inputcmp1, "slds-has-error");
                }
                
                var inputBasis = component.find("inputBasis");
                var value1;
                if(inputBasis != undefined)
                    value1 = inputBasis.get("v.value");
                if(value1 == null || value1 =="") {
                    Req14 =1;       
                    $A.util.addClass(inputBasis, "slds-has-error");
                    if (messagestr== null)
                        messagestr = 'Basis: Required Field. \n';
                    else {
                        messagestr += 'Basis: Required Field. \n';
                    }
                } else {
                    $A.util.removeClass(inputBasis, "slds-has-error");
                }
                if ((component.get("{!v.desc}")== null || component.get("{!v.desc}")== ""))
                        {
							  if (messagestr== null)
								  messagestr = 'Non-Specialty Formulary Display Name: Required Field. \n';
								else
								   {
									messagestr += 'Non-Specialty Formulary Display Name: Required Field. \n';
									}
								Req17 =1;  
						}
            }
            if(component.get("v.percentageCheck")==true){
                var inputcmp5 = component.find("inputRetail30Per");
                var value5;
                if(inputcmp5 != undefined)
                    value5 = inputcmp5.get("v.value");
                if((value5 == undefined || value5 == null || value5 =="")) { Req2 =1;  }
                
                var inputcmp6 = component.find("inputRetail90Per");
                var value6;
                if(inputcmp6 != undefined)
                    value6 = inputcmp6.get("v.value");
                if((value6 == undefined || value6 == null || value6 =="")) { Req3 =1;   }
                
                var inputcmp9 = component.find("inputMailPer");
                var value9;
                if(inputcmp9 != undefined)
                    value9 = inputcmp9.get("v.value");
                if((value9 == undefined || value9 == null || value9 =="")) { Req4 =1;   }
                
                var inputcmp10 = component.find("inputMChoicePer");
                var value10;
                if(inputcmp10 != undefined)
                    value10 = inputcmp10.get("v.value");
                if((value10 == undefined || value10 == null || value10 =="")) { Req5 =1;   }
                
                var inputcmp11 = component.find("inputSpecialtyRetailPer");
                var value11;
                if(inputcmp11 != undefined)
                    value11 = inputcmp11.get("v.value");
                if((value11 == undefined || value11 == null || value11 =="")) { Req15 =1;   }
                
                var inputcmp7 = component.find("inputClient30Per");
                var value7;
                if(inputcmp7 != undefined)
                    value7 = inputcmp7.get("v.value");
                if((value7 == undefined || value7 == null || value7 =="")) { Req6 =1;   }
                
                var inputcmp8 = component.find("inputClient90Per");
                var value8;
                if(inputcmp8 != undefined)
                    value8 = inputcmp8.get("v.value");
                if((value8 == undefined || value8 == null || value8 =="")) { Req7 =1;   }
            } else if(component.get("v.percentageCheck")==false){
                var inputcmp5 = component.find("inputRetail30Dol");
                var value5;
                if(inputcmp5 != undefined)
                    value5 = inputcmp5.get("v.value");
                if((value5 == undefined || value5 == null || value5 =="")) {  Req8 =1;   }
                
                var inputcmp6 = component.find("inputRetail90Dol");
                var value6;
                if(inputcmp6 != undefined)
                    value6 = inputcmp6.get("v.value");
                if((value6 == undefined || value6 == null || value6 =="")) { Req9 =1;   }
                
                var inputcmp9 = component.find("inputMailDol");
                var value9;
                if(inputcmp9 != undefined)
                    value9 = inputcmp9.get("v.value");
                if((value9 == undefined || value9 == null || value9 =="")) { Req10 =1;   }
                
                var inputcmp10 = component.find("inputMChoiceDol");
                var value10;
                if(inputcmp10 != undefined)
                    value10 = inputcmp10.get("v.value");
                if((value10 == undefined || value10 == null || value10 =="")) { Req11 =1;   }
                
                var inputcmp11 = component.find("inputSpecialtyRetailDol");
                var value11;
                if(inputcmp11 != undefined)
                    value11 = inputcmp11.get("v.value");
                if((value11 == undefined || value11 == null || value11 =="")) { Req16 =1;   }
                
                var inputcmp7 = component.find("inputClient30Dol");
                var value7;
                if(inputcmp7 != undefined)
                    value7 = inputcmp7.get("v.value");
                if((value7 == undefined || value7 == null || value7 =="")) { Req12 =1;   }
                
                var inputcmp8 = component.find("inputClient90Dol");
                var value8;
                if(inputcmp8 != undefined)
                    value8 = inputcmp8.get("v.value");
                if((value8 == undefined || value8 == null || value8 =="")) {  Req13 =1;   }
            }
            
            if(percentageCheck==true && Req2==1 && Req3==1 && Req4==1 && Req5==1 && Req6==1 && Req7==1 && Req15==1){
                
                
                var inputcmp5 = component.find("inputRetail30Per");
                $A.util.addClass(inputcmp5, "slds-has-error");
                
                var inputcmp6 = component.find("inputRetail90Per");
                $A.util.addClass(inputcmp6, "slds-has-error");
                
                var inputcmp9 = component.find("inputMailPer");
                $A.util.addClass(inputcmp9, "slds-has-error");
                
                var inputcmp10 = component.find("inputMChoicePer");
                $A.util.addClass(inputcmp10, "slds-has-error");
                
                var inputcmp11 = component.find("inputSpecialtyRetailPer");
                $A.util.addClass(inputcmp11, "slds-has-error");
                
                var inputcmp7 = component.find("inputClient30Per");
                $A.util.addClass(inputcmp7, "slds-has-error");
                
                var inputcmp8 = component.find("inputClient90Per");
                $A.util.addClass(inputcmp8, "slds-has-error");
                
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "mode": 'sticky',
                    "type": 'error',
                    "title": "Error!",
                    "message": "At least one of the Percentage amount fields needs to be entered."
                });
                toastEvent.fire();
                isError = true;
            } else if(component.get("v.percentageCheck")==false && Req8==1 && Req9==1 && Req10==1 && Req11==1 && Req12==1 && Req13==1 && Req16==1){
                var inputcmp5 = component.find("inputRetail30Dol");
                $A.util.addClass(inputcmp5, "slds-has-error");
                
                var inputcmp6 = component.find("inputRetail90Dol");
                $A.util.addClass(inputcmp6, "slds-has-error");
                
                var inputcmp9 = component.find("inputMailDol");
                $A.util.addClass(inputcmp9, "slds-has-error");
                
                var inputcmp10 = component.find("inputMChoiceDol");
                $A.util.addClass(inputcmp10, "slds-has-error");
                
                var inputcmp11 = component.find("inputSpecialtyRetailDol");
                $A.util.addClass(inputcmp11, "slds-has-error");
                
                var inputcmp7 = component.find("inputClient30Dol");
                $A.util.addClass(inputcmp7, "slds-has-error");
                
                var inputcmp8 = component.find("inputClient90Dol");
                $A.util.addClass(inputcmp8, "slds-has-error");
                
                /*var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Error_Event");
                    appEvent.setParams({ "Error" : "At least one of the Dollar amount fields needs to be entered."});
                    appEvent.fire();*/
                        
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "mode": 'sticky',
                            "type": 'error',
                            "title": "Error!",
                            "message": "At least one of the Dollar amount fields needs to be entered."
                        });
                        toastEvent.fire();
                        isError = true;
                    }
            
            if (Req1 == 1 || Req14 == 1 ||Req17 ==1 ) {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "mode": 'sticky',
                    "type": 'error',
                    "title": "Error!",
                    "message": messagestr
                });
                toastEvent.fire();
            } 
            
            if(Req1 == 0  && Req14 == 0 && Req17==0 && isError == false ) {
                var wr = component.get("v.rebateWrapper");
                var specNew;
                var specRelated;
                var isSpecValid = true;
                var specRec;
                var spec;
                console.log('wr.specialty----------'+wr.specialty);  
                if(wr.specialty) {
                    var len = wr.specialty.length;
                    console.log('len----------'+len);
                    //alert('--len------'+len);
                    console.log('len----*********************************************************------'+len);
                    for(var j = 0 ; j< len ;j++){
                        if(wr.specialty[j] != undefined){
                            console.log('objects.Id----------'+component.get("{!v.objects.Id}"));
                            console.log('wr.specialty[j].Id----------'+wr.specialty[j].Id);
                            console.log('Plan_Design__c----------'+component.get("{!v.objects.Plan_Design__c}"));
                            console.log('wr.specialty[j].Plan_Design__c----------'+wr.specialty[j].Plan_Design__c);
                            
                            console.log('111 objects.Id----------'+(component.get("{!v.objects.Id}") == null || component.get("{!v.objects.Id}") == undefined));
                            console.log('222 wr.specialty[j].Id----------'+(wr.specialty[j].Id == null || wr.specialty[j].Id == undefined));
                            console.log('333 Plan_Design__c----------'+component.get("{!v.objects.Plan_Design__c}") == wr.specialty[j].Plan_Design__c);
                            
                            if(component.get("{!v.objects.Id}") != null && component.get("{!v.objects.Id}") != undefined && 
                               component.get("{!v.objects.Id}") == wr.specialty[j].Id && 
                               component.get("{!v.objects.Plan_Design__c}") == wr.specialty[j].Plan_Design__c){
                                specRec = wr.specialty[j];
                                console.log('specRec----##########  Id match  ###############------');
                                break;
                            } else if((component.get("{!v.objects.Id}") == null || component.get("{!v.objects.Id}") == undefined) && 
                                      (wr.specialty[j].Id == null || wr.specialty[j].Id == undefined) && 
                                      component.get("{!v.objects.Plan_Design__c}") == wr.specialty[j].Plan_Design__c){
                                specRec = wr.specialty[j];
                                console.log('specRec----##########   No Id match  ###############------');
                                break;
                            } 
                        }
                    }
                }
                //alert('--rg--'+rg.Id +' -spec-- '+spec.Id);
                if(specRec != undefined){
                    
                    if(specRec.Specialty_Formulary__c){} else {
                        isSpecValid = false;
                    }
                    if(component.get("v.percentageCheck")==true ) {
                        if(specRec.Specialty_1__c){} else {
                            isSpecValid = false;
                        }
                    } 
                    if(component.get("v.percentageCheck")==false ) { 
                        if(specRec.Specialty__c){} else {
                            isSpecValid = false;
                        }
                    }
                    console.log('isSpecValid----------'+isSpecValid);
                    
                }
                component.set("v.DisplaySpinner",true);
                
                
                var action = component.get("c.isCopyDup");
                action.setParams({
                    //"basis":component.get("{!v.basis}"),
            		"fafid":component.get("{!v.fafid}"),
                    "nonspecForm":component.get("{!v.nonspecForm}"),
                    "gstp":component.get("{!v.gstp}"),
                    "lob":component.get("{!v.lob}"),
                    //"isSpec" : false,
                    "rg":component.get("{!v.objects}"),
                    "rgSP" : specRec
                    //"isPer" : component.get("v.percentageCheck"),
                    //"isMatchTo" : objRG.Is_Match_To_Copy__c
                });
                action.setCallback(this, $A.getCallback(function(response) {
                    var state = response.getState();
                    component.set("{!v.DisplaySpinner}", false);
                    //alert('state---'+state);
                    if (state === "SUCCESS") {
                        component.set("{!v.DisplaySpinner}", false);
                        var isDup = response.getReturnValue();
                        //alert('--isDup--'+isDup );
                        if(isDup && isDup == true){
                            
                            var cmpTarget = component.find("tablerow");
                            $A.util.addClass(cmpTarget, "slds-has-error");
                            var errorStr = 'Rebate Guarantee Record already exists for Year, LOB, Basis, GSTP, Non-Specialty Formulary, Plan Design and Specialty Formulary specified';

                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "mode": 'sticky',
                                "type": 'error',
                                "title": "Error!",
                                "message": errorStr
                            });
                            toastEvent.fire();
                            
                        } else {
                            var cmpTarget = component.find("tablerow");
                            $A.util.removeClass(cmpTarget, "slds-has-error");
                            
                            var appEventS = $A.get("e.c:Apttus_Grid_NT_Notify_Save_Event");
                            appEventS.setParams({ 
                                "SaveRec" : true,
                                "Section" : component.get("v.planDesignOption"),
                                "isSavedAndClose" : component.get("v.isSavedAndClose")
                            });
                            appEventS.fire();     
                        }
                                  
                    } else if (state === "ERROR") {
                        var cmpTarget = component.find("tablerow");
                        $A.util.addClass(cmpTarget, "slds-has-error");
                        
                        var errors = response.getError();
                        var message;
                        if (errors) {
                            if(errors[0] && errors[0].message) {
                                message = "Error message: " + errors[0].message; 
                            }
                        }  else {
                            message = "Error in Updating Rebate Pricing Information";
                        }   
                        component.set("{!v.DisplaySpinner}", false);
                        //helper.cancleDeleteAlertHelper(component,event,helper);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "mode": 'sticky',
                            "type": 'error',
                            "title": "Error!",
                            "message": message
                        });
                        toastEvent.fire();
                    }
                }));
                $A.enqueueAction(action);
                
            }
        }
    },
    handleSaveNewHelper:function(component, event, helper){
        if(component.get("v.display") == true){
            var wr = component.get("v.rebateWrapper");
            //alert('--specialty---s---'+wr.specialty);
            //alert('--len------'+wr.specialty.length);
            var specNew;
            var specRelated;
            var isSpecValid = true;
            var specRec;
			var spec;
            console.log('wr.specialty----------'+wr.specialty);  
            if(wr.specialty) {
                var len = wr.specialty.length;
                console.log('len----------'+len);
                //alert('--len------'+len);
                console.log('len----*********************************************************------'+len);
                for(var j = 0 ; j< len ;j++){
                    if(wr.specialty[j] != undefined){
                        console.log('objects.Id----------'+component.get("{!v.objects.Id}"));
                        console.log('wr.specialty[j].Id----------'+wr.specialty[j].Id);
                        console.log('Plan_Design__c----------'+component.get("{!v.objects.Plan_Design__c}"));
                        console.log('wr.specialty[j].Plan_Design__c----------'+wr.specialty[j].Plan_Design__c);
                        
                        console.log('111 objects.Id----------'+(component.get("{!v.objects.Id}") == null || component.get("{!v.objects.Id}") == undefined));
                        console.log('222 wr.specialty[j].Id----------'+(wr.specialty[j].Id == null || wr.specialty[j].Id == undefined));
                        console.log('333 Plan_Design__c----------'+component.get("{!v.objects.Plan_Design__c}") == wr.specialty[j].Plan_Design__c);
                        
                        if(component.get("{!v.objects.Id}") != null && component.get("{!v.objects.Id}") != undefined && 
                           component.get("{!v.objects.Id}") == wr.specialty[j].Id && 
                           component.get("{!v.objects.Plan_Design__c}") == wr.specialty[j].Plan_Design__c){
                            specRec = wr.specialty[j];
                            console.log('specRec----##########  Id match  ###############------');
                            break;
                        } else if((component.get("{!v.objects.Id}") == null || component.get("{!v.objects.Id}") == undefined) && 
                                  (wr.specialty[j].Id == null || wr.specialty[j].Id == undefined) && 
                                  component.get("{!v.objects.Plan_Design__c}") == wr.specialty[j].Plan_Design__c){
                            specRec = wr.specialty[j];
                            console.log('specRec----##########   No Id match  ###############------');
                            break;
                        } 
                    }
                }
                console.log('specRelated----------'+specRelated);
                //alert('--Specialty_Formulary__c------'+wr.specialty[0].Specialty_Formulary__c);
                //alert('--Specialty_1__c------'+wr.specialty[0].Specialty_1__c);
                //alert('--Specialty__c------'+wr.specialty[0].Specialty__c);
            }
            component.set("v.DisplaySpinner",true);
            if(specRec != undefined){
                
                if(specRec.Specialty_Formulary__c){} else {
                    isSpecValid = false;
                }
                if(component.get("v.percentageCheck")==true ) {
                    if(specRec.Specialty_1__c){} else {
                        isSpecValid = false;
                    }
                } 
                if(component.get("v.percentageCheck")==false ) { 
                    if(specRec.Specialty__c){} else {
                        isSpecValid = false;
                    }
                }
                console.log('isSpecValid----------'+isSpecValid);
                
            }
            var objRG = component.get("{!v.objects}");
            
            component.set("v.DisplaySpinner",true);
            
            
            var action = component.get("c.saveCopyRGs");
            action.setParams({
                //"basis":component.get("{!v.basis}"),
                "nonspecForm":component.get("{!v.nonspecForm}"),
                "gstp":component.get("{!v.gstp}"),
                "lob":component.get("{!v.lob}"),
                "isSpec" : false,
                "rg":component.get("{!v.objects}"),
                "rgSP" : specRec,
                "isPer" : component.get("v.percentageCheck"),
                 "des":component.get("{!v.desc}"),
                "isMatchTo" : objRG.Is_Match_To_Copy__c
            });
            action.setCallback(this, $A.getCallback(function(response) {
                var state = response.getState();
                //alert('state---'+state);
                if (state === "SUCCESS") {
                    component.set("{!v.DisplaySpinner}", false);
                    var rgid = response.getReturnValue();
                    component.set("v.objects.Id",rgid); 
                    //alert('rgid----------'+rgid);
                    
                    var cmpTarget = component.find("tablerow");
                    $A.util.removeClass(cmpTarget, "slds-has-error");
                    component.set("v.duplicaterow","0"); 
                    
                    var appEventS = $A.get("e.c:Apttus_Grid_Copy_Complete_Event");
                    appEventS.setParams({ 
                        "SaveRec" : true,
                        "Section" : component.get("v.planDesignOption"),
                        "isSavedAndClose" : component.get("v.isSavedAndClose")
                    });
                    appEventS.fire();                    
                } else if (state === "ERROR") {
                    var cmpTarget = component.find("tablerow");
                    $A.util.addClass(cmpTarget, "slds-has-error");
                    
                    var errors = response.getError();
                    var message;
                    if (errors) {
                        if(errors[0] && errors[0].message) {
                            message = "Error message: " + errors[0].message; 
                        }
                    }  else {
                        message = "Error in Updating Rebate Pricing Information";
                    }   
                    component.set("{!v.DisplaySpinner}", false);
                    //helper.cancleDeleteAlertHelper(component,event,helper);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "mode": 'sticky',
                        "type": 'error',
                        "title": "Error!",
                        "message": message
                    });
                    toastEvent.fire();
                }
            }));
            $A.enqueueAction(action);
        }
    },
})