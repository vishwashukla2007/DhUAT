({
    
    doInit : function(component, event, helper)  {  
        component.set("v.DisplaySpinner",false);
        
        component.set("{!v.lob}",component.get("{!v.objects.LOB__c}"));
        helper.getThisReconciliation(component, helper);
        if (component.get("v.pricingcount") >= component.get("v.yearcount")) {
            component.set("v.disablebtn", true);
        } else {
            component.set("v.disablebtn", false);
        }
        component.set("{!v.desc}",component.get("{!v.objects.Custom_Description__c}"));
    },
    handleSaveVerify : function(component, event, helper)  {
        var counter= component.get("v.recordcount");
        var counter= ++counter;
        component.set("v.recordcount" , counter);
        if (component.get("v.recordcount") == component.get("v.pricingcount"))  {    
            component.set("v.DisplaySpinner",false);
            var appEvent = $A.get("e.c:Apttus_Grid_NT_Close_Event");
            appEvent.setParams({ "Save" : true });
            appEvent.fire();
            if (component.get("v.pricingcount") >= component.get("v.yearcount")) {
                component.set("v.disablebtn", true);
            } else {
                component.set("v.disablebtn", false);
            }
        }
    },
    handleSave : function(component, event, helper)  { 
      if (component.get("v.pricingcount") > 0 )
        {
        component.set("v.recordcount",0);
        component.set("v.DisplaySpinner",true);
        component.set("v.recordcount",0);
        }
       if (component.get("v.pricingcount") == 0 )
        {
            var appEvent = $A.get("e.c:Apttus_Grid_NT_Close_Event");
            appEvent.setParams({ "Save" : true });
            appEvent.fire();
        }
    },
    handleError : function(component, event, helper)  {   
        component.set("v.DisplaySpinner",false);
    },
    update : function(component, event, helper)  {
        component.set("v.networkname",component.find("Network").get("v.value"));
        if (component.find("Network").get("v.value") == "Custom" || component.find("Network").get("v.value") == "Custom Secondary") {
            component.set("v.descreadonly",false);
            component.set("v.descrequired",true);
        }
        else {
            component.set("v.descreadonly",true);
            component.set("v.descrequired",false);
        }
        if (component.get("v.objects.Network_Name__c") == "MC(84-90)CP" || component.get("v.objects.Network_Name__c") == "MC(84-90)CVS") {
            component.set("v.typereadonly",true);
            component.set("{!v.objects.Network_Type__c}","Transparent");
        }  else {
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
    updatetype : function(component, event, helper)  {
        component.set("v.networktype",component.find("Type").get("v.value"));
        var appEvent = $A.get("e.c:Apttus_Grid_Copy_Event");
        appEvent.setParams({
            "networkname" : component.get("v.networkname"),
            "networktype" : component.get("v.networktype"),
            "lob" : component.get("v.lob"),
            "desc" : component.get("v.desc")});
        appEvent.fire();
    },
    updatedesc : function(component, event, helper)  {
        component.set("v.desc",component.find("Desc").get("v.value"));
        var appEvent = $A.get("e.c:Apttus_Grid_Copy_Event");
        appEvent.setParams({
            "networkname" : component.get("v.networkname"),
            "networktype" : component.get("v.networktype"),
            "lob" : component.get("v.lob"),
            "desc" : component.get("v.desc")});
        appEvent.fire();
    },
    updatelob : function(component, event, helper)  {
        component.set("v.lob",component.find("LOB").get("v.value"));
        var appEvent = $A.get("e.c:Apttus_Grid_Copy_Event");
        appEvent.setParams({
            "networkname" : component.get("v.networkname"),
            "networktype" : component.get("v.networktype"),
            "lob" : component.get("v.lob"),
            "desc" : component.get("v.desc")});
        appEvent.fire();
    },
    displayspinner : function(component, event, helper)  {
        component.set("v.DisplaySpinner",true);
        
    },
    create : function(component, event, helper)  {
        var spobj = component.get("v.spobjects");
        var newobj =  new Object(); 
        newobj.FAF_ID__c = component.get("v.fafid");
        newobj.Year__c = null;
         newobj.Custom_Description__c = null;
        newobj.LOB__c = null; 
        newobj.Pharmacy_Benefit__c = null;
        newobj.Price_List__c = null;
        newobj.Specialty_Compare_Logic_On__c = component.get("{!v.objects.Specialty_Compare_Logic_On__c}");  
        newobj.Brand_Rate__c = null;
        newobj.Brand_Basis__c = null;  
        newobj.Brand_Dispensing_Fee__c = null;
        newobj.Generic_Basis__c = null;
        newobj.Generic_Rate__c = null;
        newobj.Generic_Dispensing_Fee__c = null; 
        //alert('---'+component.get("{!v.objects.Specialty_Operations__c}"));
        
        newobj.Specialty_Operations__c = component.get("{!v.opid}");  
        
        newobj.Limited_Distribution_Drug_LDD_Rate__c = null;
        newobj.New_to_Market_Brand_Rate__c = null;  
        newobj.LDD_No_Access_Rate__c = null;  
        newobj.Biosimilar_Rate__c = null;  
        component.set("v.newobject",newobj);
        spobj.push(component.get("v.newobject"));    
        component.set("v.spobjects",spobj);
        var prcnt = component.get("v.pricingcount");
        prcnt = prcnt + 1;
        component.set("v.pricingcount", prcnt)
        if (component.get("v.pricingcount") >= component.get("v.yearcount"))  {
            component.set("v.disablebtn", true);
        } else {
            component.set("v.disablebtn", false);
        }     
    },
 
})