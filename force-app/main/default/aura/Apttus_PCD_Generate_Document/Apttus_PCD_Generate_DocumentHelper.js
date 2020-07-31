({
    
    getaccount : function(component,event,helper) {
		var action = component.get("c.get_account");
        action.setParams({"recordId": component.get("v.record")})
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
              component.set("{!v.accountid}", response.getReturnValue());
            }
            else {
                //helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
	 },
	retrieverecord : function(component, event, helper) {
		
        var action = component.get("c.getTemplates");
       			     action.setParams({"pageSize":  "1",
                                       "pageNumber": "1"})
        			 action.setCallback(this, $A.getCallback(function(response) {
           			 var state = response.getState();
            	     if (state === "SUCCESS") {
                      component.set("v.data", response.getReturnValue());
                    
           		   }
            	else {
                   //helper.counselLogErrors(response.getError());
            }
       		 }));
             $A.enqueueAction(action); 
        
        // Retrieve Agreement Record
        var action = component.get("c.get_agreementterms");
        action.setParams({"recordId": component.get("v.record")})
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("{!v.agreementline}", response.getReturnValue());
                component.set("{!v.tasksubtype}", component.get("{!v.agreementline.Task_SubType__c}"));
                component.set("{!v.caveats}", component.get("{!v.agreementline.PCD_Clause_Previous_Terms__c}"));
                 component.set("{!v.escalatingdate}", component.get("{!v.agreementline.Escalating_Effective_Date__c}"));
                 component.set("{!v.pricingDate}", component.get("{!v.agreementline.Pricing_Effective_Date__c}"));
                  component.set("{!v.duedate}", component.get("{!v.agreementline.Due_Date__c}"));
                 if (component.get("v.pricingDate") == null && component.get("v.escalatingdate") != null)
                 {
                    component.set("{!v.pricingDate}", component.get("v.escalatingdate")); 
                 }
                 component.set("{!v.proposalyear}", component.get("{!v.agreementline.Proposal_Year__c}"));
                if (component.get("{!v.agreement.Previous_Termed_No__c}")== "1")
                {
                    //component.find("termno").set("v.value",true);
                    //component.find("termyes").set("v.value",false);
                    //component.set("{!v.displayclause}",false);
                }
                else
                {
                     //component.set("{!v.displayclause}",true);
                }
            }
            else {
                //helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
        
        
        
         var action = component.get("c.getDocName");
       			     action.setParams({"RecId":  component.get("v.record")})
        			 action.setCallback(this, $A.getCallback(function(response) {
           			 var state = response.getState();
            	     if (state === "SUCCESS") {
                      component.set("v.docname", response.getReturnValue());
                      component.set("v.defdocname", response.getReturnValue());
           		   }
            	else {
                   //helper.counselLogErrors(response.getError());
            }
       		 }));
                  $A.enqueueAction(action); 
        
	},
    
    generatedocument : function(component, event, helper)
    {
         var filetype = "docx";
         if(component.find("pdf").get("v.value") == true)
         {
             filetype = "pdf";
         }
        else
        {
            filetype = "docx";
        }
              var terms = "NO";
              /*if (component.find("termyes").get("v.value") == true)
              {
                  terms = "YES";
              }
              else
              {
                  terms = "NO";
              } */
              var agreeterms=null;
             /* if(terms == "YES")
              {
                agreeterms = component.find("terms").get("v.value");
              }
              else
              {
                agreeterms = null;  
              } */
             var documentname = component.get("v.docname");
             if (documentname == null || documentname=='' )
             {
                 documentname = component.get("v.defdocname");
             }
              var action = component.get("c.generatedocument");
       			     action.setParams({"filename":  documentname,
                                       "filetype": filetype,
                                       "agrid" : component.get("v.record"),
                                       "terms" : terms,
                                       "agreeterms" : component.get("v.caveats"),
                                       "proposalyear" : component.get("v.proposalyear"),
                                       "pricingdate" : component.get("v.pricingDate"),
                                       "duedate" : component.get("v.duedate")})
        			 action.setCallback(this, $A.getCallback(function(response) {
           			 var state = response.getState();
            	     if (state === "SUCCESS") 
                        {
                            component.set("v.documentversiondtl", response.getReturnValue());
                            var action = component.get("c.mergedocument");
       			     		action.setParams({"agrid" : component.get("v.record"),
                                               "filetype": filetype})
        			 		action.setCallback(this, $A.getCallback(function(response) {
                         	var state = response.getState();
            	     		if (state === "SUCCESS") 
                       		 {
                                var action = component.get("c.contentdocument");
       			       			action.setParams({"RecId" : component.get("v.documentversiondtl.Id")})
        		      		    action.setCallback(this, $A.getCallback(function(response) {
                         		var state = response.getState();
            	     			if (state === "SUCCESS") 
                       		 		{
                                        component.set("v.documentversiondtl", response.getReturnValue());
                                        component.set("v.url", "/servlet/servlet.FileDownload?file=" + component.get("v.documentversiondtl.Apttus__ContentId__c"));
                                        var action = component.get("c.updatefilename");
       			       					action.setParams({"RecId" : component.get("v.documentversiondtl.Id"),
                                                         "Filename": documentname,
                                       					 "Filetype": filetype})
        		      		   			action.setCallback(this, $A.getCallback(function(response) {
                         				var state = response.getState();
            	     					if (state === "SUCCESS") 
                       		 				{    component.set("v.url", "/servlet/servlet.FileDownload?file=" + response.getReturnValue());
                                                 helper.updatealistatus(component, event, helper);
                                                 component.set("v.DisplaySpinner",false);
                                                 component.set("v.OpenFile",true);
           		                    		}
            				  			else 
                                    		{
                                  	 		component.set("v.DisplaySpinner",false);
                                     		var toastEvent = $A.get("e.force:showToast");
                                     		toastEvent.setParams({
                                     				"title": "Error!",
                                     				 "message": "Problem in PCD Document Generation."
                                                      });
                                      	    toastEvent.fire();
            			            		}
       		                         		}));
                                   			$A.enqueueAction(action); 
                                        
           		                    }
            				  else 
                                    {
                                  	 component.set("v.DisplaySpinner",false);
                                     var toastEvent = $A.get("e.force:showToast");
                                     toastEvent.setParams({
                                     "title": "Error!",
                                     "message": "Problem in PCD Document Generation."
                                                      });
                                      toastEvent.fire();
            			            }
       		                         }));
                                   $A.enqueueAction(action); 
           		        	       }
            				 else {
                   				//helper.counselLogErrors(response.getError());
                   				  component.set("v.DisplaySpinner",false);
    							  var toastEvent = $A.get("e.force:showToast");
    							  toastEvent.setParams({
                                  "title": "Error!",
                                  "message": "Problem in PCD Document Generation."
                                                      });
                                   toastEvent.fire();
            			         }
       		       }));
                   $A.enqueueAction(action);  

           		        }
            	else {
                   //helper.counselLogErrors(response.getError());
            }
       		 }));
            $A.enqueueAction(action);  
        
    },
    updatealistatus : function(component, event, helper) 
    {
        
        var action = component.get("c.get_updatestatusali");
        action.setParams({ "stageName":  "Generate Document",
                           "recordId":  component.get("v.record")})
         action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state == "SUCCESS") 
            {
             // Remove BAFO Message
            } 
           else 
            {
             
            }
        }));
        $A.enqueueAction(action); 
    },
})