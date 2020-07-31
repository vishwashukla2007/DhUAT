({
	    
   doInit : function(component, event, helper) 
    {  
        component.set("v.DisplaySpinner",false);
        component.set("{!v.lob}",component.get("{!v.objects.LOB__c}"));
        helper.getThisReconciliation(component, helper);
        if (component.get("v.pricingcount") >= component.get("v.yearcount"))
        {
             component.set("v.disablebtn", true);
        }
        else
        {
            component.set("v.disablebtn", false);
        }
        component.set("{!v.desc}",component.get("{!v.objects.Custom_Description__c}"));
     
     	
    },
    handleSaveVerify : function(component, event, helper) 
    {
         
         var counter= component.get("v.recordcount");
         var counter= ++counter;
         component.set("v.recordcount" , counter);
         var SaveRecs = event.getParam("SaveRec");
         var MailGrid = event.getParam("Mail"); 
         var GridNames = event.getParam("Grid"); 
         var maildupobj = component.get("v.maildupobjects");  
         var item = maildupobj.length;
         component.set("v.mailcheck",MailGrid);
         if (counter == 1 && SaveRecs == "false")
         {
             component.set("v.duplicates", true);
         }
        if((component.get("v.duplicates")== true || SaveRecs == "false" ) && counter > 1 )
         {
         if (GridNames == "Mail")
          { 
           component.set("v.duplicates",true);
           for(var i=0; i< item; i++)
           {
            var mailobj = maildupobj[i];
            var yr =mailobj.Year__c;
            var lob = mailobj.LOB__c;
            if ((yr == component.get("v.mailcheck.Year__c")) && (lob == component.get("v.mailcheck.LOB__c")))
            {  
               component.set("v.recordcount",0); 
               component.set("v.DisplaySpinner",false);
               var appEvent = $A.get("e.c:Apttus_Grid_Duplicate_Event");
               appEvent.setParams({ "Year" : yr});
               appEvent.setParams({ "LOB" : lob});
               appEvent.fire();
            }           
           }    
          }
         }
         if (counter == 1)
         {
          component.set("v.maildupobjects",MailGrid);   
         }          
         var item = maildupobj.length;
         if (counter > 1)
         {
           maildupobj.push(MailGrid);
           component.set("v.maildupobjects",maildupobj);   
         }       
        if (component.get("v.recordcount") == component.get("v.pricingcount"))
        {    
         if (component.get("v.duplicates")== true)
         {   
             var action = component.get("c.get_savemaildatalist");
 			 action.setParams({ "mp" : maildupobj,
                               "opid" : component.get("{!v.objects.FAF_Mail_Operations__c}")});
 		     action.setCallback(this, function(response) {
       		 var state = response.getState();
             if (state === "SUCCESS") 
               {
                
                 component.set("v.DisplaySpinner",false);
           		 var appEvent = $A.get("e.c:Apttus_Grid_NT_Close_Event");
           		 appEvent.setParams({ "Save" : true });
            	 appEvent.fire();
                 if (component.get("v.pricingcount") >= component.get("v.yearcount"))
                 {
                  component.set("v.disablebtn", true);
       	         }
                 else
                {
                 component.set("v.disablebtn", false);
                }   
                   
                 }
              else if (state === "ERROR")
                {
              
                   var errors = response.getError();
                   var message;
                   if (errors) 
                   {
                   if(errors[0] && errors[0].message) {
                        message = "Error message: " + errors[0].message; 
                           }
                   } 
                  else 
                  {
                    message = "Error in Updating Mail Pricing Information";
                  }   
                  var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Error_Event");
                  appEvent.setParams({ "Error" : message});
                  appEvent.fire();         
                }
              });
             $A.enqueueAction(action);  
         }   
         else
         {
            component.set("v.DisplaySpinner",false);
            var appEvent = $A.get("e.c:Apttus_Grid_NT_Close_Event");
            appEvent.setParams({ "Save" : true });
            appEvent.fire();
            if (component.get("v.pricingcount") >= component.get("v.yearcount"))
            {
             component.set("v.disablebtn", true);
       	   }
           else
           {
            component.set("v.disablebtn", false);
           }
        }
        }
    },
     handleSave : function(component, event, helper) 
    {   
        component.set("v.recordcount",0);
        component.set("v.DisplaySpinner",true);
        component.set("v.recordcount",0);
        component.set("v.duplicates",false);
        var appEvent = $A.get("e.c:Apttus_Grid_Copy_Event");
        appEvent.setParams({
        "desc" : component.get("v.desc")});
        appEvent.fire();
    },
    update : function(component, event, helper)  {
        var appEvent = $A.get("e.c:Apttus_Grid_Copy_Event");
        appEvent.setParams({
            "desc" : component.get("v.desc")});
        appEvent.fire();
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
        var mailobj = component.get("v.mailobjects");
        var newobj =  new Object(); //component.get("v.newobject");
        newobj.LOB__c = component.get("v.lob");
        newobj.FAF_ID__c = component.get("v.fafid");
        newobj.FAF_Mail_Operations__c = component.get("{!v.objects.FAF_Mail_Operations__c}");
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
        component.set("v.newobject",newobj);
        mailobj.push(component.get("v.newobject"));    
        component.set("v.mailobjects",mailobj);
        var prcnt = component.get("v.pricingcount");
        prcnt = prcnt + 1;
        component.set("v.pricingcount", prcnt)
        if (component.get("v.pricingcount") >= component.get("v.yearcount"))
        {
             component.set("v.disablebtn", true);
        }
        else
        {
            component.set("v.disablebtn", false);
        }
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
     updatedesc : function(component, event, helper)  {
        component.set("v.desc",component.find("Desc").get("v.value"));
         //alert('Desc'+component.find("Desc").get("v.value"));
         //alert('Desc-->'+component.get("v.desc"));
        var appEvent = $A.get("e.c:Apttus_Grid_Copy_Event");
        appEvent.setParams({
            "desc" : component.get("v.desc")});
        appEvent.fire();
    },
})