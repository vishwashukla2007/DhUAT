({
    
    doInit : function(component, event, helper)  {  
        component.set("v.DisplaySpinner",false);
        
        //component.set("{!v.lob}",component.get("{!v.objects.LOB__c}"));
        helper.getThisReconciliation(component, helper);
         //component.set("v.desc",component.get("v.customdesc"));
         component.set("v.desc",component.get("{!v.objects.Custom_Description__c}"));
        console.log('INITcomponent.get("v.customdesc")'+component.get("{!v.objects.Custom_Description__c}"));
    },
    handleSaveVerify : function(component, event, helper)  {
        var counter= component.get("v.recordValidcount");
        var counter= ++counter;
        component.set("v.recordValidcount" , counter);
        if (component.get("v.recordValidcount") == component.get("v.pricingcount"))  { 
            component.set("v.recordcount",0);
            component.set("v.recordValidcount",0);
            
            var appEventC = $A.get("e.c:Apttus_Grid_Copy_Start_Event");
            appEventC.setParams({ 
                "SaveRec" : true
            });
            appEventC.fire();	
            
        }
    },
    copycomplete : function(component, event, helper)  {
        var isSaved = event.getParam("SaveRec");
        console.log('isSaved   '+isSaved);
        
        if (isSaved){
            var counter= component.get("v.recordcount");
            var counter= ++counter;
            component.set("v.recordcount" , counter);
            if (component.get("v.recordcount") == component.get("v.pricingcount"))  {    
                //save complete
                //alert('save complete--------------');
                //component.set("v.DisplaySpinner",false);
                var appEvent = $A.get("e.c:Apttus_Grid_NT_Close_Event");
                appEvent.setParams({ "Save" : true });
                appEvent.fire();
                
            }
        }
    },
    handleSave : function(component, event, helper)  { 
        if (component.get("v.pricingcount") > 0 )  {
            component.set("v.recordcount",0);
            component.set("v.recordValidcount",0);
            
        }
        if (component.get("v.pricingcount") == 0 ) {
            var appEvent = $A.get("e.c:Apttus_Grid_NT_Close_Event");
            appEvent.setParams({ "Save" : true });
            appEvent.fire();
        }
    },
    handleError : function(component, event, helper)  {   
        component.set("v.DisplaySpinner",false);
    },
    displayspinner : function(component, event, helper)  {
        component.set("v.DisplaySpinner",true);
    },
    updatedesc : function(component, event, helper){
        component.set("v.desc",component.find("Desc").get("v.value"));
        var appEvent = $A.get("e.c:Apttus_Grid_Copy_Event");
        appEvent.setParams({
         "desc" :component.get("v.desc")
        });
        appEvent.fire();
    },
    create : function(component, event, helper)  {
        var spobj = component.get("v.spobjects");
        var newobj =  new Object(); 
        newobj.FAF_ID__c = component.get("v.fafid");
        newobj.Year__c = null;
        console.log('component.get("v.customdesc")'+component.get("v.customdesc")+'component.get("v.desc")'+component.get("v.desc"));
        newobj.Custom_Description__c =component.get("v.desc");
        newobj.LOB__c = null; 
        newobj.Clinical_Solution_Type__c = null;
        newobj.Clinical_Solution__c = null;
        newobj.Opt_In_Out__c = null;
        newobj.Contingent__c = null;
        newobj.Fee_Basis__c = null;  
        newobj.Fee_Amount__c = null;
        
        newobj.Clinical_Operations__c = component.get("{!v.opid}");  
        
        component.set("v.newobject",newobj);
        spobj.push(component.get("v.newobject"));    
        component.set("v.spobjects",spobj);
        
        var prcnt = component.get("v.pricingcount");
        prcnt = prcnt + 1;
        component.set("v.pricingcount", prcnt);
        
        /*if (component.get("v.pricingcount") >= component.get("v.yearcount"))  {
            component.set("v.disablebtn", true);
        } else {
            component.set("v.disablebtn", false);
        } */    
    },
    deletedRGRow : function(component, event, helper)  {
        
        var isDeleteSuccess = event.getParam("isDeleteSuccess");     
        var delIndex = event.getParam("delIndex"); 
        var count = component.get("v.pricingcount");
        count = count - 1;
        component.set("v.pricingcount", count);
        var data = component.get("v.spobjects");
        data.splice(delIndex, 1);
        component.set("v.spobjects", data); 
    },
 
})