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
            //alert('Record Count'+component.get("v.recordcount")+'Pricing Count'+component.get("v.pricingcount"));
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
    
    displayspinner : function(component, event, helper) 
    {
      component.set("v.DisplaySpinner",true);
       
    },
    create : function(component, event, helper) 
    {
        var netobj = component.get("v.netobjects");
        var newobj = new Object(); //component.get("v.newobject");
        component.get("v.newobject");
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
        component.set("v.pricingcount", prcnt);
     
    }
})