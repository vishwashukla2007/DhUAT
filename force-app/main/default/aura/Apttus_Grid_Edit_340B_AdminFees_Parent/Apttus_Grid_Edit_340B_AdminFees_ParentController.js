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
     
     	
    },
    handleSaveVerify : function(component, event, helper) 
    {
      var section = event.getParam("Grid");
      if (section == "340B")
        {
         var counter= component.get("v.recordcount");
         var counter= ++counter;
         component.set("v.recordcount" , counter);
         var SaveRecs = event.getParam("SaveRec");
         var AdminGrid = event.getParam("Admin"); 
         var GridNames = event.getParam("Grid"); 
         var admindupobj = component.get("v.admindupobjects");  
         var item = admindupobj.length;
         component.set("v.admincheck",AdminGrid);
         if (counter == 1 && SaveRecs == "false")
         {
             component.set("v.duplicates", true);
         }
        if((component.get("v.duplicates")== true || SaveRecs == "false" ) && counter > 1 )
         {
         if (GridNames == "340B")
          { 
           component.set("v.duplicates",true);
           for(var i=0; i< item; i++)
           {
            var adminobj = admindupobj[i];
            var yr =adminobj.Year__c;
            var lob = adminobj.LOB__c;
            var adminfee= adminobj.Admin_Fee_Type__c;
            if ((yr == component.get("v.admincheck.Year__c")) && (lob == component.get("v.admincheck.LOB__c")) && (adminfee == component.get("v.admincheck.Admin_Fee_Type__c")))
            {  
               component.set("v.recordcount",0); 
               component.set("v.DisplaySpinner",false);
               var appEvent = $A.get("e.c:Apttus_Grid_Duplicate_Event");
               appEvent.setParams({ "Year" : yr});
               appEvent.setParams({ "LOB" : lob});
               appEvent.setParams({ "AdminFee" : adminfee});
               appEvent.fire();
            }           
           }    
          }
         }
         if (counter == 1)
         {
          component.set("v.admindupobjects",AdminGrid);   
         }          
         var item = admindupobj.length;
         if (counter > 1)
         {
           admindupobj.push(AdminGrid);
           component.set("v.admindupobjects",admindupobj);   
         }       
        if (component.get("v.recordcount") == component.get("v.pricingcount"))
        {    
         if (component.get("v.duplicates")== true)
         {   
             var action = component.get("c.saveadmindatalist");
 			 action.setParams({ "mp" : admindupobj,
                               "opid" : component.get("{!v.objects.Billing_Operations__c }")});
 		     action.setCallback(this, function(response) {
       		 var state = response.getState();
             if (state === "SUCCESS") 
               {
                
                 component.set("v.DisplaySpinner",false);
           		 var appEvent = $A.get("e.c:Apttus_Grid_NT_Close_Event");
           		 appEvent.setParams({ "Save" : true });
                         appEvent.setParams({ "Section" : "340B" });
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
                    message = "Error in Updating 340B Administration Fee Information";
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
             appEvent.setParams({ "Section" : "340B"});
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
       }
      /* var section = event.getParam("Grid");
       if (section == "340B")
          {
           var counter= component.get("v.recordcount");
           var counter= ++counter;
           component.set("v.recordcount" , counter);
        if (component.get("v.recordcount") == component.get("v.pricingcount"))
        {    
            component.set("v.DisplaySpinner",false);
            var appEvent = $A.get("e.c:Apttus_Grid_NT_Close_Event");
            appEvent.setParams({ "Save" : true });
            appEvent.setParams({ "Section" : "340B" });
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
       }*/
    },
     handleSave : function(component, event, helper) 
    {   
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
            appEvent.setParams({ "Section" : "340B" });
            appEvent.fire();
        }
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
        var admobj = component.get("v.adminobjects");
        var newobj =  new Object(); //component.get("v.newobject");
        newobj.LOB__c = component.get("v.lob");
        newobj.FAF_ID__c = component.get("v.fafid");
        newobj.Billing_Operations__c = null;
        newobj.Year__c = null;
        newobj.Admin_Fee_Type__c = null;
        newobj.Additive__c = false;
        newobj.Base_Amount__c = null;
        newobj.Broker_Amount__c = null;
        newobj.Year_Begin_Date__c = null;
        newobj.Year_End_Date__c = null;    
        component.set("v.newobject",newobj);
        admobj.push(component.get("v.newobject"));    
        component.set("v.adminobjects",admobj);
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
     var section = event.getParam("message")
     if (section == "340B")
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
     }  
    },
})