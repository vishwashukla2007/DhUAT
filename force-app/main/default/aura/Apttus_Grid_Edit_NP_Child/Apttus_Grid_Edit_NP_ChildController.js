({
	doInit : function(component, event, helper) {

    var yr = [];
    for (var i = 0; i < component.get("v.yearcount"); i++) 
    {
      var j = i+1;
      yr.push({value: j});
    }
    yr.push({
        value: 'All'
      });
     component.set("{!v.yearoptions}", yr);
     component.set("{!v.custdesc}",component.get("{!v.objects.Custom_Description__c}"));
     helper.fetchpicklistvalue(component, helper);
     if (component.get("{!v.objects.Brand_Basis__c}") != "Baked-Preferred & Non-Preferred")
        {
            component.set("{!v.disabled}",true);
            component.set("{!v.brdisabled}",false);
            component.set("{!v.brandrequired}",true);
            component.set("{!v.prefrequired}",false);
        }
        else
        {
            component.set("{!v.disabled}",false);
            component.set("{!v.brdisabled}",true);
            component.set("{!v.brandrequired}",false);
            component.set("{!v.prefrequired}",true);
        }
        
        if (component.get("{!v.objects.Generic_Basis__c}") != "Flat Generic Discount")
        {
            component.set("{!v.nonmacdisabled}",false);
            component.set("{!v.flatdisabled}",true);
            component.set("{!v.nonmacrequired}",true);
            component.set("{!v.flatrequired}",false);
        }
        else
        {
            component.set("{!v.nonmacdisabled}",true);
            component.set("{!v.flatdisabled}",false);
            component.set("{!v.nonmacrequired}",false);
            component.set("{!v.flatrequired}",true);
        }
        if (component.get("{!v.objects.Brand_Basis__c}") == "Pass-Through")
        {
            component.set("{!v.brandrequired}",false);
            component.set("{!v.flatrequired}",false);
            component.set("{!v.nonmacrequired}",false);
            component.set("{!v.branddispensingrequired}",false);
            component.set("{!v.genericdispensingrequired}",false);
        } 
        if (component.get("{!v.objects.SSG_Guarantee__c}") == 0 || component.get("{!v.objects.Id}") == null)
        {
            component.set("{!v.ssgdisabled}",true);
        }
        if (component.get("{!v.objects.NED_Count__c}") == 0 || component.get("{!v.objects.Id}") == null)
        {
            component.set("{!v.neddisabled}",true);
        }
        if (component.get("{!v.objects.MER_Count__c}") == 0 || component.get("{!v.objects.Id}") == null)
        {
            component.set("{!v.merdisabled}",true);
        }
        if (component.get("{!v.objects.GER_Count__c}") == 0 || component.get("{!v.objects.Id}") == null)
        {
            component.set("{!v.gerdisabled}",true);
        }
        if (component.get("{!v.objects.BER_Guarantee__c}") == 0 || component.get("{!v.objects.Id}") == null)
        {
            component.set("{!v.berdisabled}",true);
        }
        // pass-through copy from brand basis to generic basis By Parvathi US51534
        if (component.get("{!v.objects.Brand_Basis__c}") == "Pass-Through")
        {
            component.set("{!v.objects.Generic_Basis__c}","Pass-Through");
        }
	},
    handleChange : function(component, event, helper) {
		var inputcmp1 = component.find("input1");
        var value = inputcmp1.get("v.value");
        component.set("{!v.objects.Year__c}",value);
        
        var inputcmp131 = component.find("input131");
        var value = inputcmp131.get("v.value");
        component.set("{!v.objects.Brand_Basis__c}",value);
        
        var inputcmp411 = component.find("input411");
        var value = inputcmp411.get("v.value");
        component.set("{!v.objects.Generic_Basis__c}",value);
    
        var inputcmp2 = component.find("input2");
        var value = inputcmp2.get("v.value");
        component.set("{!v.objects.Brand_Rate__c}",value);
    
        var inputcmp3 = component.find("input3");
        var value = inputcmp3.get("v.value");
        component.set("{!v.objects.Preferred_Brand_Rate__c}",value);
        
        var inputcmp4 = component.find("input4");
        var value = inputcmp4.get("v.value");
        component.set("{!v.objects.Non_Preferred_Brand_Rate__c}",value);
        
        var inputcmp5 = component.find("input5");
        var value = inputcmp5.get("v.value");
        component.set("{!v.objects.Generic_Rate__c}",value);
        
        var inputcmp6 = component.find("input6");
        var value = inputcmp6.get("v.value");
        component.set("{!v.objects.BER_Guarantee_Rate__c}",value);
        
        var inputcmp7 = component.find("input7");
        var value = inputcmp7.get("v.value");
        component.set("{!v.objects.GER_Guarantee_Rate__c}",value);
        
        var inputcmp8 = component.find("input8");
        var value = inputcmp8.get("v.value");
        component.set("{!v.objects.MER_Guarantee_Rate__c}",value);
        
        var inputcmp9 = component.find("input9");
        var value = inputcmp9.get("v.value");
        component.set("{!v.objects.NED_Guarantee_Rate__c}",value);
        
        var inputcmp10 = component.find("input10");
        var value = inputcmp10.get("v.value");
        component.set("{!v.objects.SSG_Guarantee_Rate__c}",value);
        
        var inputcmp11 = component.find("input11");
        var value = inputcmp11.get("v.value");
        component.set("{!v.objects.Non_MAC_Generic_Rate__c}",value);
        
        var inputcmp12 = component.find("input12");
        var value = inputcmp12.get("v.value");
        component.set("{!v.objects.Brand_Dispensing_Fee__c}",value);
        
        var inputcmp13 = component.find("input13");
        var value = inputcmp13.get("v.value");
        component.set("{!v.objects.Generic_Dispensing_Fee__c}",value);
        
        if (component.get("{!v.objects.Brand_Basis__c}") != "Baked-Preferred & Non-Preferred")
        {
            component.set("{!v.disabled}",true);
            component.set("{!v.brdisabled}",false);
            component.set("{!v.objects.Preferred_Brand_Rate__c}",null);
            component.set("{!v.objects.Non_Preferred_Brand_Rate__c}",null);
            component.set("{!v.brandrequired}",true);
            component.set("{!v.prefrequired}",false);
        }
        else
        {
            component.set("{!v.disabled}",false);
            component.set("{!v.brdisabled}",true);
            component.set("{!v.objects.Brand_Rate__c}",null);
            component.set("{!v.brandrequired}",false);
            component.set("{!v.prefrequired}",true);
        }
        if (component.get("{!v.objects.Generic_Basis__c}") != "Flat Generic Discount")
        {
            component.set("{!v.nonmacdisabled}",false);
            component.set("{!v.flatdisabled}",true);
            component.set("{!v.objects.Generic_Rate__c}",null);
            component.set("{!v.nonmacrequired}",true);
            component.set("{!v.flatrequired}",false);
        }
        else
        {
            component.set("{!v.nonmacdisabled}",true);
            component.set("{!v.flatdisabled}",false);
            component.set("{!v.objects.Non_MAC_Generic_Rate__c}",null);
            component.set("{!v.nonmacrequired}",false);
            component.set("{!v.flatrequired}",true);
        }
        // pass-through copy from brand basis to generic basis By Parvathi US51534
        if (component.get("{!v.objects.Brand_Basis__c}") == "Pass-Through")
        {
            component.set("{!v.objects.Generic_Basis__c}","Pass-Through");
        }
        
       if (component.get("{!v.objects.Brand_Basis__c}") == "Pass-Through")
        {
            component.set("{!v.brandrequired}",false);
            component.set("{!v.flatrequired}",false);
            component.set("{!v.nonmacrequired}",false);
            component.set("{!v.branddispensingrequired}",false);
            component.set("{!v.genericdispensingrequired}",false);
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
        var messagestr;
        var inputcmp1 = component.find("input1");
        var value = inputcmp1.get("v.value");
        if(value == null || value =="")
        {
        messagestr = 'Year: Required Field. \n ';
        Req1 =1;       
        $A.util.addClass(inputcmp1, "slds-has-error");
        }
        var inputcmp131 = component.find("input131");
        var value = inputcmp131.get("v.value");
        var brandbasisvalue = inputcmp131.get("v.value");
        if(value == null || value =="")
        {
        $A.util.addClass(inputcmp131, "slds-has-error");
        if (messagestr== null)
        messagestr = 'Brand Basis: Required Field. \n';
        else
        {
        messagestr += 'Brand Basis: Required Field. \n';
        }
        Req2 =1;       
        }
        
        var inputcmp2 = component.find("input2");
        var value = inputcmp2.get("v.value");
        if(brandbasisvalue !="Pass-Through" && (value == null || value =="") && component.get("v.brandrequired")==true && value !="0")
        {
     
        $A.util.addClass(inputcmp2, "slds-has-error");
        if (messagestr== null)
        messagestr = 'Brand Rate: Required Field. \n';
        else
        {
        messagestr += 'Brand Rate: Required Field. \n';
        }
        Req3 =1;  
        }
        
        var inputcmp3 = component.find("input3");
        var value = inputcmp3.get("v.value");
        if((value == null || value =="") && component.get("v.prefrequired")==true && value !="0")
        {
     
        $A.util.addClass(inputcmp3, "slds-has-error");
        if (messagestr== null)
        messagestr = 'Preferred Brand Rate: Required Field. \n';
        else
        {
        messagestr += 'Preferred Brand Rate: Required Field. \n';
        }
        Req4 =1;  
        }
        
        var inputcmp4 = component.find("input4");
        var value = inputcmp4.get("v.value");
        if((value == null || value =="") && component.get("v.prefrequired")==true && value !="0")
        {
     
        $A.util.addClass(inputcmp4, "slds-has-error");
        if (messagestr== null)
        messagestr = 'Non-Preferred Brand Rate: Required Field. \n';
        else
        {
        messagestr += 'Non-Preferred Brand Rate: Required Field. \n';
        }
        Req5 =1;  
        }
        
        var inputcmp5 = component.find("input5");
        var value = inputcmp5.get("v.value");
        if(brandbasisvalue !="Pass-Through" && (value == null || value =="") && component.get("v.flatrequired")==true && value !="0")
        {
     
        $A.util.addClass(inputcmp5, "slds-has-error");
        if (messagestr== null)
        messagestr = 'Flat Generic Rate: Required Field. \n';
        else
        {
        messagestr += 'Flat Generic Rate: Required Field. \n';
        }
        Req6 =1;  
        }
        
        var inputcmp11 = component.find("input11");
        var value = inputcmp11.get("v.value");
        if(brandbasisvalue !="Pass-Through" && (value == null || value =="") && component.get("v.nonmacrequired")==true && value !="0")
        {
     
        $A.util.addClass(inputcmp11, "slds-has-error");
        if (messagestr== null)
        messagestr = 'Non-MAC Generic Rate: Required Field. \n';
        else
        {
        messagestr += 'Non-MAC Generic Rate: Required Field. \n';
        }
        Req7 =1;  
        }
        
        var inputcmp12 = component.find("input12");
        var value = inputcmp12.get("v.value");
        if(brandbasisvalue !="Pass-Through" && (value == null || value =="") && value !="0")
        {
     
        $A.util.addClass(inputcmp12, "slds-has-error");
        if (messagestr== null)
        messagestr = 'Brand Disp. Fee $: Required Field. \n';
        else
        {
        messagestr += 'Brand Disp. Fee $: Required Field. \n';
        }
        Req8 =1;  
        }
        
        var inputcmp13 = component.find("input13");
        var value = inputcmp13.get("v.value");
        if(brandbasisvalue !="Pass-Through" && (value == null || value =="") && value !="0")
        {
     
        $A.util.addClass(inputcmp13, "slds-has-error");
        if (messagestr== null)
        messagestr = 'Generic Disp. Fee $: Required Field. \n';
        else
        {
        messagestr += 'Generic Disp. Fee $: Required Field. \n';
        }
        Req9 =1;  
        }
        
        if (component.get("{!v.objects.Network_Name__c}")== null)
        {
        if (messagestr== null)
        messagestr = 'Network Name: Required Field. \n';
        else
        {
        messagestr += 'Network Name: Required Field. \n';
        }
        Req10 =1;  
        }
    
        if (component.get("{!v.objects.Network_Type__c}")== null)
        {
        if (messagestr== null)
        messagestr = 'Network Type: Required Field. \n';
        else
        {
        messagestr += 'Network Type: Required Field. \n';
        }
        Req11 =1;  
        }
 
        if (component.get("{!v.objects.LOB__c}")== null)
        {
        if (messagestr== null)
        messagestr = 'LOB: Required Field. \n';
        else
        {
        messagestr += 'LOB: Required Field. \n';
        }
        Req12 =1;  
        }
    
        if ((component.get("{!v.objects.Custom_Network_Description__c}")== null || component.get("{!v.objects.Custom_Network_Description__c}")== "")&& (component.get("{!v.objects.Network_Name__c}")=="Custom" || component.get("{!v.objects.Network_Name__c}")=="Custom Secondary"))
        {
        if (messagestr== null)
        messagestr = 'Custom Network Description: Required Field. \n';
        else
        {
        messagestr += 'Custom Network Description: Required Field. \n';
        }
        Req13 =1;  
        }
		if ((component.get("{!v.objects.Custom_Description__c}")== null || component.get("{!v.objects.Custom_Description__c}")== ""))
        {
        if (messagestr== null)
        messagestr = 'Network Display Name: Required Field. \n';
        else
        {
        messagestr += 'Network Display Name: Required Field. \n';
        }
        Req14 =1;  
        }
     
        if (Req1 == 1 || Req2 == 1 || Req3 == 1 || Req4 == 1 || Req5 == 1 || Req6 == 1 || Req7 == 1 || Req8 == 1 || Req9 == 1 || Req10 == 1 || Req11 == 1 || Req12 == 1 || Req13 == 1||Req14==1)
        {
                var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Error_Event");
                appEvent.setParams({ "Error" : messagestr});
                appEvent.fire();   
        }

        if(Req1 == 0 && Req2 == 0 && Req3 == 0 && Req4 == 0 && Req5 == 0 && Req6 == 0 && Req7 == 0 && Req8 == 0 && Req9 == 0 && Req10 == 0 && Req11 == 0 && Req12 == 0 && Req13 == 0 && Req14==0)
        {
        var action = component.get("c.get_savedata");
        action.setParams({ "np" : component.get("{!v.objects}")});
        // Create a callback that is executed after 
        // the server-side action returns
       action.setCallback(this, function(response) {
       var state = response.getState();
            if (state === "SUCCESS") 
               {
                if (response.getReturnValue() == 0)
                {
                component.set("v.duplicaterow","0"); 
                var cmpTarget = component.find("tablerow");
                $A.util.removeClass(cmpTarget, "slds-has-error");
                var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Save_Event");
                appEvent.setParams({ "SaveRec" : true});
                appEvent.fire();
                }
                else
                {
                /*message = "Retail Network Pricing record already exists for the Year, LOB, Network Name and Custom Network Description combination. Please create a unique record using the combination.";  
                var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Error_Event");
                appEvent.setParams({ "Error" : message});
                appEvent.fire(); */
                }
               }
            else if (state === "ERROR")
               {
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
                    message = "Error in Updating Network Pricing Information";
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
               /* var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Save_Event");
                appEvent.setParams({ "SaveRec" : true});
                appEvent.fire(); */    
        
        }     
        
    },
     handleupdate : function(component, event, helper) {
        component.set("{!v.networkname}", event.getParam("networkname"));
        component.set("{!v.networktype}", event.getParam("networktype"));
        component.set("{!v.lob}", event.getParam("lob"));
        component.set("{!v.desc}", event.getParam("desc"));
        component.set("{!v.custdesc}",event.getParam("custdesc"));
        component.set("{!v.objects.Network_Name__c}",component.get("{!v.networkname}"));
        component.set("{!v.objects.Network_Type__c}",component.get("{!v.networktype}"));
        component.set("{!v.objects.LOB__c}",component.get("{!v.lob}"));
        component.set("{!v.objects.Custom_Network_Description__c}",component.get("{!v.desc}"));
		component.set("{!v.objects.Custom_Description__c}",component.get("{!v.custdesc}"));
        
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
        var appEvent = $A.get("e.c:Apttus_Delete_Verify_Event");
        appEvent.fire();    
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