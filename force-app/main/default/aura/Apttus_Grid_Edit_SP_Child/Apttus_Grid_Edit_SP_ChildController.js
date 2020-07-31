({
    doInit : function(component, event, helper) {
        
        var yr = [];
        for (var i = 0; i < component.get("v.yearcount"); i++)  {
            var j = i+1;
            yr.push({value: j});
        }
        yr.push({  value: 'All' });
        component.set("{!v.yearoptions}", yr);
        helper.fetchpicklistvalue(component, helper);
        if (component.get("{!v.objects.Brand_Basis__c}") != "Baked-Preferred & Non-Preferred") {
            component.set("{!v.disabled}",true);
            component.set("{!v.brdisabled}",false);
            component.set("{!v.brandrequired}",true);
            component.set("{!v.prefrequired}",false);
        }  else {
            component.set("{!v.disabled}",false);
            component.set("{!v.brdisabled}",true);
            component.set("{!v.brandrequired}",false);
            component.set("{!v.prefrequired}",true);
        }
        
        if (component.get("{!v.objects.Generic_Basis__c}") != "Flat Generic Discount") {
            component.set("{!v.nonmacdisabled}",false);
            component.set("{!v.flatdisabled}",true);
            component.set("{!v.nonmacrequired}",true);
            component.set("{!v.flatrequired}",false);
        } else {
            component.set("{!v.nonmacdisabled}",true);
            component.set("{!v.flatdisabled}",false);
            component.set("{!v.nonmacrequired}",false);
            component.set("{!v.flatrequired}",true);
        }
        component.set("{!v.objects.Custom_Description__c}",component.get("v.desc"));
    },
    handleChange : function(component, event, helper) {
        
        var inputcmp1 = component.find("input1");
        var value = inputcmp1.get("v.value");
        component.set("{!v.objects.Year__c}",value);
        
        var inputcmp3 = component.find("input3");
        var value = inputcmp3.get("v.value");
        component.set("{!v.objects.Pharmacy_Benefit__c}",value);
        
        var inputcmp4 = component.find("input4");
        var value = inputcmp4.get("v.value");
        component.set("{!v.objects.Price_List__c}",value);
        
        var inputcmp5 = component.find("input5");
        var value = inputcmp5.get("v.value");
        component.set("{!v.objects.LOB__c}",value);
        
        var inputcmp6 = component.find("input6");
        var value = inputcmp6.get("v.value");
        component.set("{!v.objects.Brand_Basis__c}",value);
        
        var inputcmp7 = component.find("input7");
        var value = inputcmp7.get("v.value");
        component.set("{!v.objects.Brand_Rate__c}",value);
        
        var inputcmp8 = component.find("input8");
        var value = inputcmp8.get("v.value");
        component.set("{!v.objects.Brand_Dispensing_Fee__c}",value);
        
        var inputcmp9 = component.find("input9");
        var value = inputcmp9.get("v.value");
        component.set("{!v.objects.Generic_Basis__c}",value);
        
        var inputcmp10 = component.find("input10");
        var value = inputcmp10.get("v.value");
        component.set("{!v.objects.Generic_Rate__c}",value);
        
        var inputcmp11 = component.find("input11");
        var value = inputcmp11.get("v.value");
        component.set("{!v.objects.Generic_Dispensing_Fee__c}",value);
        
        var inputcmp12 = component.find("input12");
        var value = inputcmp12.get("v.value");
        component.set("{!v.objects.Limited_Distribution_Drug_LDD_Rate__c}",value);
        
        var inputcmp13 = component.find("input13");
        var value = inputcmp13.get("v.value");
        component.set("{!v.objects.New_to_Market_Brand_Rate__c}",value);
        
        var inputcmp14 = component.find("input14");
        var value = inputcmp14.get("v.value");
        component.set("{!v.objects.LDD_No_Access_Rate__c}",value);
        
        var inputcmp15 = component.find("input15");
        var value = inputcmp15.get("v.value");
        component.set("{!v.objects.Biosimilar_Rate__c}",value);
        
        if (component.get("{!v.objects.Brand_Basis__c}") != "Baked-Preferred & Non-Preferred") {
            component.set("{!v.disabled}",true);
            component.set("{!v.brdisabled}",false);
        } else {
            component.set("{!v.disabled}",false);
            component.set("{!v.brdisabled}",true);
            component.set("{!v.objects.Brand_Rate__c}",null);
        } 
    },
    handleSave : function(component, event, helper) {
        
    if(component.get("v.display") == true)
       {   
        var Req1 = 0;
        var Req2 = 0;
        var Req3 = 0;
        var Req4 = 0;
        var Req5 = 0;
        var Req6 = 0;
        var Req7 = 0;
        var Req8 = 0;
        var Req9 = 0;
        var Req10 = 0;
        var Req11 = 0;
        var Req12 = 0;
        var Req13 = 0;
        var Req14 = 0;
        var Req15 = 0;
        var messagestr;
        var inputcmp1 = component.find("input1");
        var value = inputcmp1.get("v.value");
        if(value == null || value =="") {
            messagestr = 'Year: Required Field. \n ';
            Req5 =1;       
            $A.util.addClass(inputcmp1, "slds-has-error");
        }
        
        var inputcmp6 = component.find("input6");
        var value = inputcmp6.get("v.value");
        if(value == null || value =="") {
            $A.util.addClass(inputcmp6, "slds-has-error");
            if (messagestr== null)
                messagestr = 'Brand Basis: Required Field. \n';
            else {
                messagestr += 'Brand Basis: Required Field. \n';
            }
            Req2 =1;       
        }
        
        var inputcmp7 = component.find("input7");
        var value = inputcmp7.get("v.value");
        if((value == null || value =="") && component.get("v.brandrequired")==true && value !="0") {
            $A.util.addClass(inputcmp7, "slds-has-error");
            if (messagestr== null)
                messagestr = 'Brand Rate: Required Field. \n';
            else {
                messagestr += 'Brand Rate: Required Field. \n';
            }
            Req3 =1;  
        }
        
        var inputcmp9 = component.find("input9");
        var value = inputcmp9.get("v.value");
        if((value == null || value =="") && component.get("v.brandrequired")==true) {
            $A.util.addClass(inputcmp9, "slds-has-error");
            if (messagestr== null)
                messagestr = 'Generic Basis: Required Field. \n';
            else {
                messagestr += 'Generic Basis: Required Field. \n';
            }
            Req4 =1;  
        }
        
        var inputcmp5 = component.find("input5");
        var value = inputcmp5.get("v.value");
        if(value == null || value =="") {
            $A.util.addClass(inputcmp5, "slds-has-error");
            if (messagestr== null)
                messagestr = 'LOB: Required Field. \n';
            else {
                messagestr += 'LOB: Required Field. \n';
            }
            Req6 =1;       
        }
        
        var inputcmp4 = component.find("input4");
        var value = inputcmp4.get("v.value");
        if(value == null || value =="") {
            $A.util.addClass(inputcmp4, "slds-has-error");
            if (messagestr== null)
                messagestr = 'PRICE LIST: Required Field. \n';
            else {
                messagestr += 'PRICE LIST: Required Field. \n';
            }
            Req7 =1;       
        }
        
        var inputcmp8 = component.find("input8");
        var value = inputcmp8.get("v.value");
        if((value == null || value =="") && value !="0") {
            $A.util.addClass(inputcmp8, "slds-has-error");
            if (messagestr== null)
                messagestr = 'BRAND DISPENSING FEE: Required Field. \n';
            else {
                messagestr += 'BRAND DISPENSING FEE: Required Field. \n';
            }
            Req8 =1;       
        }
        
        var inputcmp10 = component.find("input10");
        var value = inputcmp10.get("v.value");
        if((value == null || value =="") && value !="0") {
            $A.util.addClass(inputcmp10, "slds-has-error");
            if (messagestr== null)
                messagestr = 'GENERIC RATE: Required Field. \n';
            else {
                messagestr += 'GENERIC RATE: Required Field. \n';
            }
            Req9 =1;       
        }
        
        var inputcmp11 = component.find("input11");
        var value = inputcmp11.get("v.value");
        if((value == null || value =="") && value !="0") {
            $A.util.addClass(inputcmp11, "slds-has-error");
            if (messagestr== null)
                messagestr = 'GENERIC DISPENSING FEE: Required Field. \n';
            else {
                messagestr += 'GENERIC DISPENSING FEE: Required Field. \n';
            }
            Req10 =1;       
        }
        
        var inputcmp12 = component.find("input12");
        var value = inputcmp12.get("v.value");
        if((value == null || value =="") && value !="0") {
            $A.util.addClass(inputcmp12, "slds-has-error");
            if (messagestr== null)
                messagestr = 'LIMITED DISTRIBUTION DRUG(LDD) RATE: Required Field. \n';
            else {
                messagestr += 'LIMITED DISTRIBUTION DRUG(LDD) RATE: Required Field. \n';
            }
            Req11 =1;       
        }
        
        var inputcmp14 = component.find("input14");
        var value = inputcmp14.get("v.value");
        if((value == null || value =="") && value !="0") {
            $A.util.addClass(inputcmp14, "slds-has-error");
            if (messagestr== null)
                messagestr = 'LDD NO ACCESS: Required Field. \n';
            else {
                messagestr += 'LDD NO ACCESS: Required Field. \n';
            }
            Req12 =1;       
        }
        
        var inputcmp15 = component.find("input15");
        var value = inputcmp15.get("v.value");
        if((value == null || value =="") && value !="0") {
            $A.util.addClass(inputcmp15, "slds-has-error");
            if (messagestr== null)
                messagestr = 'BIOSIMILAR RATE: Required Field. \n';
            else {
                messagestr += 'BIOSIMILAR RATE: Required Field. \n';
            }
            Req13 =1;       
        }
           
        var inputcmp13 = component.find("input13");
        var value = inputcmp13.get("v.value");
        if((value == null || value =="") && value !="0") {
            $A.util.addClass(inputcmp13, "slds-has-error");
            if (messagestr== null)
                messagestr = 'NEW TO MARKET GENERIC RATE: Required Field. \n';
            else {
                messagestr += 'NEW TO MARKET GENERIC RATE: Required Field. \n';
            }
            Req14 =1;       
        }
           //alert('component.get("{!v.objects.Custom_Description__c}'+component.get("{!v.objects.Custom_Description__c}"));
        if ((component.get("{!v.objects.Custom_Description__c}")== null || component.get("{!v.objects.Custom_Description__c}")==""))
        {
        if (messagestr== null)
        messagestr = 'Specialty Display Name: Required Field. \n';
        else
        {
        messagestr += 'Specialty Display Name: Required Field. \n';
        }
        Req15 =1;  
        }
        
        if (Req1 == 1 || Req2 == 1 || Req3 == 1 || Req4 == 1 || Req5 == 1 || Req6 == 1 || Req7 == 1 
            || Req8 == 1 || Req9 == 1 || Req10 == 1 || Req11 == 1 || Req12 == 1 || Req13 == 1 || Req14 == 1|| Req15 == 1) {
            var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Error_Event");
            appEvent.setParams({ "Error" : messagestr});
            appEvent.fire();   
        }
        
        if(Req1 == 0 && Req2 == 0 && Req3 == 0 && Req4 == 0 && Req5 == 0 && Req6 == 0 && Req7 == 0 
           && Req8 == 0 && Req9 == 0 && Req10 == 0 && Req11 == 0 && Req12 == 0 && Req13 == 0 && Req14 == 0 &&  Req15 == 0) {
            var action = component.get("c.get_saveSpecialtydata");
            action.setParams({ 
                "sp" : component.get("{!v.objects}"),
                "opid" : component.get("{!v.opid}")
            });
            // Create a callback that is executed after 
            // the server-side action returns
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS")   {
                    if (response.getReturnValue() == 0) {
                        component.set("v.duplicaterow","0"); 
                        var cmpTarget = component.find("tablerow");
                        $A.util.removeClass(cmpTarget, "slds-has-error");
                        var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Save_Event");
                        appEvent.setParams({ "SaveRec" : true});
                        appEvent.fire();
                        
                        var appEvent = $A.get("e.c:Apttus_Grid_Name_Event");
                        appEvent.setParams({ "gridname" : 'Specialty_Pricing__c'});
                        //appEvent.fire();
                    } else {
                       /* message = "Specialty Pricing record already exists for the Year, LOB. Please create a unique record using the combination.";  
                        var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Error_Event");
                        appEvent.setParams({ "Error" : message});
                        appEvent.fire(); */
                    }
                } else if (state === "ERROR")  {
                    //var errors = "Error in Updating Network Pricing Information";
                    component.set("v.duplicaterow","1"); 
                    var cmpTarget = component.find("tablerow");
                    $A.util.addClass(cmpTarget, "slds-has-error");
                    var errors = response.getError();
                    var message;
                    if (errors) {
                        if(errors[0] && errors[0].message) {
                            message = "Error message: " + errors[0].message; 
                        }
                    } 
                    else {
                        message = "Error in Updating Specialty Pricing Information";
                    }   
                    var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Error_Event");
                    appEvent.setParams({ "Error" : message});
                    appEvent.fire();        
                }
            });
            $A.enqueueAction(action);
        }
    }  
     if(component.get("v.display") == false)
        {    
               var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Save_Event");
                appEvent.setParams({ "SaveRec" : true});
                appEvent.fire();   
        
        }   
        
    },
    handleupdate : function(component, event, helper) {
        component.set("{!v.networkname}", event.getParam("networkname"));
        component.set("{!v.networktype}", event.getParam("networktype"));
        component.set("{!v.lob}", event.getParam("lob"));
        component.set("{!v.desc}", event.getParam("desc"));
        component.set("{!v.objects.Network_Name__c}",component.get("{!v.networkname}"));
        component.set("{!v.objects.Network_Type__c}",component.get("{!v.networktype}"));
        component.set("{!v.objects.LOB__c}",component.get("{!v.lob}"));
        component.set("{!v.objects.Custom_Description__c}",component.get("{!v.desc}"));
    },
    handledelete : function(component, event, helper) {
        var cmpTarget = component.find("tablerow");
        $A.util.addClass(cmpTarget, "slds-has-error");
        component.set("{!v.isDeleteAlertOpen}", true);
    },
    closeDeleteAlert : function(component, event, helper) {
        var cmpTarget = component.find("tablerow");
        $A.util.removeClass(cmpTarget, "slds-has-error");
        component.set("{!v.isDeleteAlertOpen}", false);
    },
    deleteSelectedRec : function(component, event, helper) {
        component.set("{!v.isDeleteAlertOpen}", false);
        if (component.get("{!v.objects.Id}") == null || component.get("{!v.objects.Id}") == 'undefined')
        {
        component.set("{!v.display}", false); 
        var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success Message',
                    message: 'Selected record(s) were deleted.',
                    type: 'success',
                    mode: 'pester'
                });
        toastEvent.fire();
        }
        if (component.get("{!v.objects.Id}") != null && component.get("{!v.objects.Id}") != 'undefined')
        {
         var appEvent = $A.get("e.c:Apttus_Grid_Inactive_Parent_Event");
         appEvent.fire();
         helper.deleteSelectedRecords(component,event,helper);
        }
    }
})