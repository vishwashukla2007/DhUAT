({
    doInit : function(component, event, helper) {
      component.set("v.desc",component.get("v.customdesc"));
    },
	updatedesc : function(component, event, helper){
        component.set("v.desc",component.find("Desc").get("v.value"));
        console.log("Desription"+component.find("Desc").get("v.value"));
        var appEvent = $A.get("e.c:Apttus_Grid_Copy_Event");
        appEvent.setParams({
         "desc" :component.get("v.desc")
        });
        appEvent.fire();
    },
    handleSave : function(component, event, helper) { 
       var messagestr;
        console.log('Errors in method+'+component.get("{!v.desc}"));
       if ((component.get("{!v.desc}")== null || component.get("{!v.desc}")== ""))
        {
        if (messagestr== null)
        messagestr = 'Administrative Fees Display Name: Required Field. \n';
        else
        {
        messagestr += 'Administrative Fees Display Name: Required Field. \n';
        } 
        var appEvent1 = $A.get("e.c:Apttus_Grid_Edit_Admin_Custom_Des_Event");
         appEvent1.setParams({ "Error" :"true"});
         appEvent1.fire(); 
         var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Error_Event");
         appEvent.setParams({ "Error" : messagestr});
         appEvent.fire(); 
        }
        else{
            var appEvent1 = $A.get("e.c:Apttus_Grid_Edit_Admin_Custom_Des_Event");
         appEvent1.setParams({ "Error" :"false"});
         appEvent1.fire(); 
        }
        
    },
     handleError : function(component, event, helper) 
    {   
         component.set("v.DisplaySpinner",false);
    },
})