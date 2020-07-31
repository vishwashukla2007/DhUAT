({
	    
   doInit : function(component, event, helper) 
    {  
        component.set("v.DisplaySpinner",false);
        component.set("v.deletedcount",0); 
        component.set("v.addedcount",0); 
        
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
        component.set("{!v.networkname}",component.get("{!v.objects.Network_Name__c}"));
        component.set("{!v.networktype}",component.get("{!v.objects.Network_Type__c}"));
        component.set("{!v.desc}",component.get("{!v.objects.Custom_Network_Description__c}"));
        component.set("{!v.lob}",component.get("{!v.objects.LOB__c}"));
        component.set("{!v.custdesc}",component.get("{!v.objects.Custom_Description__c}"));
        
        helper.getThisReconciliation(component, helper);
        if (component.get("v.pricingcount") >= component.get("v.yearcount"))
        {
             component.set("v.disablebtn", true);
        }
        else
        {
            component.set("v.disablebtn", false);
        }
     
     	
    },
    setScriptLoaded : function(component, event, helper){
        
    },
    handleSaveVerify : function(component, event, helper) 
    {
           var counter= component.get("v.recordcount");
           var counter= ++counter;
           component.set("v.recordcount" , counter);
        if (component.get("v.recordcount") == component.get("v.pricingcount"))
        {    
            component.set("v.recordcount",0);
            var appEvent = $A.get("e.c:Apttus_Grid_Copy_Start_Event");
                appEvent.fire();
            /*component.set("v.DisplaySpinner",false);
            var appEvent = $A.get("e.c:Apttus_Grid_NT_Close_Event");
            appEvent.setParams({ "Save" : true });
            appEvent.fire();*/
        }
    },
    copycomplete : function(component, event, helper) 
    {
        var counter= component.get("v.recordcount");
        var counter= ++counter;
        component.set("v.recordcount" , counter);
        if (component.get("v.recordcount") == component.get("v.pricingcount"))
        {    
        component.set("v.DisplaySpinner",false);
            var appEvent = $A.get("e.c:Apttus_Grid_NT_Close_Event");
            appEvent.setParams({ "Save" : true });
            appEvent.fire();
        }
    },
     handleSave : function(component, event, helper) 
    {   
        component.set("v.recordcount",0);
        component.set("v.DisplaySpinner",true);
        component.set("v.recordcount",0);
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
              "desc" : component.get("v.desc"),
            "custdesc":component.get("v.custdesc")});
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
              "desc" : component.get("v.desc"),
               "custdesc":component.get("v.custdesc")});
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
              "desc" : component.get("v.desc"),
            "custdesc":component.get("v.custdesc")});
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
              "desc" : component.get("v.desc"),
            "custdesc":component.get("v.custdesc")});
        appEvent.fire();
    },
    updateCustomdesc : function(component, event, helper)  {
        component.set("v.custdesc",component.find("custDesc").get("v.value"));
        var appEvent = $A.get("e.c:Apttus_Grid_Copy_Event");
        appEvent.setParams({
            "networkname" : component.get("v.networkname"),
            "networktype" : component.get("v.networktype"),
            "lob" : component.get("v.lob"),
            "desc" : component.get("v.desc"),
            "custdesc":component.get("v.custdesc")});
        appEvent.fire();
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
        var newobj =  new Object(); //component.get("v.newobject");
        newobj.Network_Name__c = component.get("v.networkname");
        newobj.Network_Type__c = component.get("v.networktype");
        newobj.LOB__c = component.get("v.lob");
        newobj.Custom_Network_Description__c = component.get("v.desc");
        newobj.Custom_Description__c = component.get("v.custdesc");
        newobj.FAF_ID__c = component.get("v.fafid");
        newobj.FAF_Network_Ops__c = component.get("{!v.objects.FAF_Network_Ops__c}");
        //newobj.Generic_Basis__c = component.get("{!v.objects.Generic_Basis__c}");  // changes By Parvathi US51534
        newobj.Generic_Basis__c = null;  // changes By Parvathi US51534
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
        var prcnt = component.get("v.pricingcount");
        prcnt = prcnt + 1;
        component.set("v.pricingcount", prcnt)
        var pricingcount = component.get("v.pricingcount");  
      	var activerownum = pricingcount;
      	component.set("v.activerownum", activerownum);   
        component.set("v.newobject",newobj);
        netobj.push(component.get("v.newobject"));    
        component.set("v.netobjects",netobj);

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