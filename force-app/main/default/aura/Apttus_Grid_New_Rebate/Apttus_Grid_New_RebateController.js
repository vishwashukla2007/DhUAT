({
	    
   doInit : function(component, event, helper) 
    {  
        component.set("v.DisplaySpinner",false);
        helper.getThisReconciliation(component,helper);
     	
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
            appEvent.fire(); */
            
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
    displayspinner : function(component, event, helper) 
    {
      component.set("v.DisplaySpinner",true);
       
    },
    create : function(component, event, helper) 
    {
        var netobj = component.get("v.netobjects");
        var newobj = new Object(); //component.get("v.newobject");
        if(component.get("v.lob")!=null){
		newobj.LOB2__c=component.get("v.lob");
        }
        newobj.FAF_ID__c =component.get("v.fafid");
        newobj.Rebate_Operations__c= component.get("{!v.objects.Rebate_Operations__c}");
        newobj.Year__c = null;
        newobj.Basis__c = null;
        newobj.Plan_Design__c = null;
        newobj.GSTP__c = null;
        newobj.Non_Specialty_Formulary_2__c = null;
        newobj.Specialty_Formulary__c = null;
		if(component.get("v.percentageCheck")==true){
        newobj.Retail_30_1__c = null;
        newobj.Retail_90_1__c = null;
        newobj.Mchoice_1__c = null;
        newobj.Mail_1__c = null;
        newobj.Specialty_1__c = null;
        newobj.Specialty_Retail_1__c = null;
        newobj.Client_Owned_30_1__c = null;
        newobj.Year_Begin_Date__c = null;
        newobj.Client_Owned_90_1__c = null;  
		newobj.Year_End_Date__c = null;
        }
		else{
        newobj.Retail_30__c = null;
        newobj.Retail_90__c = null;
        newobj.Mchoice__c = null;
        newobj.Mail__c = null;
        newobj.Specialty__c = null;
        newobj.Specialty_Retail__c = null;
        newobj.Client_Owned_30__c = null;
		newobj.Client_Owned_90__c = null;
        newobj.Year_Begin_Date__c = null;
        newobj.Year_End_Date__c = null;   
        }
		
        component.set("v.newobject",newobj);
        netobj.push(component.get("v.newobject"));    
        component.set("v.netobjects",netobj);
        var prcnt = component.get("v.pricingcount");
        prcnt = prcnt + 1;
        component.set("v.pricingcount", prcnt)
        var pricingcount = component.get("v.pricingcount");  
      	var activerownum = pricingcount;
      	component.set("v.activerownum", activerownum);  
        if (component.get("v.pricingcount") >= component.get("v.yearcount"))
        {
             //component.set("v.disablebtn", true);
        }
        else
        {
            //component.set("v.disablebtn", false);
        }
       
    }
})