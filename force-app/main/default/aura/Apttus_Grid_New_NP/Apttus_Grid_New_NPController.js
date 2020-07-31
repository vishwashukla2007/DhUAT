({
	    
   doInit : function(component, event, helper) 
    {  
        component.set("v.DisplaySpinner",false);
        component.set("v.displaychild", false);
        if (component.get("v.objects.Network_Name__c") == "MC(84-90)CP" || component.get("v.objects.Network_Name__c") == "MC(84-90)CVS")
        {
            component.set("v.typereadonly",true);
        }
        else
        {
            component.set("v.typereadonly",false);
        }
        
        if (component.get("v.objects.Network_Name__c") == "Custom" || component.get("v.objects.Network_Name__c") == "Custom Secondary")
        {
            component.set("v.descreadonly",false);
            component.set("v.descrequired",true);
        }
        else
        {
            component.set("v.descreadonly",true);
            component.set("v.descrequired",false);
        }
        component.set("v.displaychild", false);
        component.set("v.networkname",component.get("v.objects.Network_Name__c"));
        component.set("v.networktype",component.get("v.objects.Network_Type__c"));
        component.set("v.desc",component.get("v.objects.Custom_Network_Description__c"));
        component.set("v.lob",component.get("v.objects.LOB__c"));
        helper.fetchpicklist(component, helper);
        if (component.get("v.pricingcount") >= component.get("v.yearcount"))
        {
             component.set("v.disablebtn", true);
        }
        else
        {
            component.set("v.disablebtn", false);
        }
     
     	
    },
  handleCreate : function(component, event, helper) 
    {
        
        if (component.get("v.networkname") == "Custom" || component.get("v.networkname") == "Custom Secondary")
        {
            component.set("v.descreadonly",false);
        }
        else
        {
            component.set("v.descreadonly",true);
            //component.set("v.objects.Custom_Network_Description__c", null);
            component.set("v.desc", null);
        }
        if (component.get("v.objects.Network_Name__c") == "MC(84-90)CP" || component.get("v.objects.Network_Name__c") == "MC(84-90)CVS")
        {
            component.set("v.typereadonly",true);
            component.set("{!v.objects.Network_Type__c}","Transparent");
            component.set("{!v.networktype}","Transparent");
        }
        if(component.get("v.networkname") == null || component.get("v.networktype") == null || component.get("v.lob") == null)
        {
           var toastEvent = $A.get("e.force:showToast");
           toastEvent.setParams({
           "title": "Warning!",
           "message": "Please fill-in Required information."
                             });
            toastEvent.fire();
        }
        else
        {
        component.set("v.DisplaySpinner",true);
        helper.createpricing(component,event,helper);
        }

    },
    handleSaveVerify : function(component, event, helper) 
    {
           var counter= component.get("v.recordcount");
           var counter= ++counter;
           component.set("v.recordcount" , counter);
        if (component.get("v.recordcount") == component.get("v.pricingcount"))
        {    
            component.set("v.DisplaySpinner",false);
            component.set("v.displaychild", true);
            var appEvent = $A.get("e.c:Apttus_Grid_NT_Close_Event");
            appEvent.setParams({ "Save" : true });
            appEvent.fire();
        }
    },
     handleSave : function(component, event, helper) 
    {   
        component.set("v.recordcount",0);
        component.set("v.DisplaySpinner",true);
    },

     handleError : function(component, event, helper) 
    {   
         component.set("v.DisplaySpinner",false);
    },
    update : function(component, event, helper) 
    {
        component.set("v.networkname",component.find("Network").get("v.value"));
        if (component.find("Network").get("v.value") == "Custom" || component.find("Network").get("v.value") == "Custom Secondary")
        {
            component.set("v.descreadonly",false);
            component.set("v.descrequired",true);
        }
        else
        {
            component.set("v.descreadonly",true);
            component.set("v.descrequired",false);
        }
        if (component.get("v.objects.Network_Name__c") == "MC(84-90)CP" || component.get("v.objects.Network_Name__c") == "MC(84-90)CVS")
        {
            component.set("v.typereadonly",true);
            component.set("{!v.objects.Network_Type__c}","Transparent");
        }
        else
        {
            component.set("v.typereadonly",false);
        }
        var appEvent = $A.get("e.c:Apttus_Grid_Copy_Event");
        appEvent.setParams({
            "networkname" : component.get("v.networkname"),
             "networktype" : component.get("v.networktype"),
              "lob" : component.get("v.lob"),
              "desc" : component.get("v.desc")});
        appEvent.fire();
    },
    updatetype : function(component, event, helper) 
    {
        component.set("v.networktype",component.find("Type").get("v.value"));
        var appEvent = $A.get("e.c:Apttus_Grid_Copy_Event");
        appEvent.setParams({
            "networkname" : component.get("v.networkname"),
             "networktype" : component.get("v.networktype"),
              "lob" : component.get("v.lob"),
              "desc" : component.get("v.desc")});
        appEvent.fire();
    },
    updatedesc : function(component, event, helper) 
    {
        component.set("v.desc",component.find("Desc").get("v.value"));
        var appEvent = $A.get("e.c:Apttus_Grid_Copy_Event");
        appEvent.setParams({
            "networkname" : component.get("v.networkname"),
             "networktype" : component.get("v.networktype"),
              "lob" : component.get("v.lob"),
              "desc" : component.get("v.desc")});
        appEvent.fire();
    },
    updatelob : function(component, event, helper) 
    {
        component.set("v.lob",component.find("LOB").get("v.value"));
        var appEvent = $A.get("e.c:Apttus_Grid_Copy_Event");
        appEvent.setParams({
            "networkname" : component.get("v.networkname"),
             "networktype" : component.get("v.networktype"),
              "lob" : component.get("v.lob"),
              "desc" : component.get("v.desc")});
        appEvent.fire();
    },
    refreshpricing : function(component, event, helper) 
    {   
         helper.getThisReconciliation(component,event,helper);
       
    },
    displayspinner : function(component, event, helper) 
    {
      component.set("v.DisplaySpinner",true);
       
    },
    deletecount : function(component, event, helper) 
    {
      var prcnt = component.get("v.pricingcount");
        prcnt = prcnt - 1;
      component.set("v.pricingcount", prcnt)
      var pricingcount = component.get("v.pricingcount");  
      var activerownum = pricingcount;
      component.set("v.activerownum", activerownum);   
      if (component.get("v.pricingcount") >= component.get("v.yearcount"))
        {
             component.set("v.disablebtn", true);
        }
      else
        {
            component.set("v.disablebtn", false);
        }
        
    },
    create : function(component, event, helper) 
    {
        
        var netobj = component.get("v.netobjects");
        var newobj = component.get("v.newobject");
        newobj.Network_Name__c = component.get("v.networkname");
        newobj.Network_Type__c = component.get("v.networktype");
        newobj.LOB__c = component.get("v.lob");
        newobj.Custom_Network_Description__c = component.get("v.desc");
        newobj.FAF_ID__c = component.get("v.fafid");
        newobj.FAF_Network_Ops__c = component.get("{!v.objects.FAF_Network_Ops__c}");
        newobj.Generic_Basis__c = component.get("{!v.objects.Generic_Basis__c}");
        newobj.Year__c = null;
        newobj.Brand_Rate__c = null;
        newobj.Preferred_Brand_Rate__c = null;
        newobj.Non_Preferred_Brand_Rate__c = null;
        newobj.Generic_Rate__c = null;
        newobj.GER_Guarantee_Rate__c = null;
        newobj.MER_Guarantee_Rate__c = null;
        newobj.BER_Guarantee_Rate__c = null;
        newobj.NED_Guarantee_Rate__c = null;
        newobj.SSG_Guarantee_Rate__c = null;
        newobj.Non_MAC_Generic_Rate__c = null;
        newobj.Brand_Dispensing_Fee__c = null;
        newobj.Generic_Dispensing_Fee__c = null;
        newobj.Year_Begin_Date__c = null;
        newobj.Year_End_Date__c = null;   
        newobj.Brand_Basis__c = null;  
        newobj.Retail_Network_Ordinal__c = null;
        component.set("v.newobject",newobj);
        netobj.push(component.get("v.newobject"));    
        component.set("v.netobjects",netobj);
        var prcnt = component.get("v.pricingcount");
        prcnt = prcnt + 1;
        component.set("v.pricingcount", prcnt)
        var activerownum = pricingcount;
      	component.set("v.activerownum", activerownum); 
        if (component.get("v.pricingcount") >= component.get("v.yearcount"))
        {
             component.set("v.disablebtn", true);
        }
        else
        {
            component.set("v.disablebtn", false);
        }
       
    }
})