({
	initAction : function(component, event, helper) 
    {
		var pageSize = component.get("v.pageSize");
        var action = component.get("c.getTransactionLogs");
        var params = {
          fafId: component.get("v.recordId")
        };
        action.setParams(params);
        //action.setAbortable();
    
        action.setCallback(this, function(actionResult) 
        {
          if (actionResult.getState() === "SUCCESS") {
            	var results = actionResult.getReturnValue();
    			 if (results !== null) {
                     results.sort(function(a, b) {
                        var dateA = new Date(a.TimeStamp__c), dateB = new Date(b.TimeStamp__c);
                        return  dateB.getTime() - dateA.getTime() ;
                    });

                for( var k in results )
                {
                    var dt = new Date(results[k].TimeStamp__c);
                    //str = dt.getUTCFullYear()+'/'+dt.getUTCMonth()+'/'+dt.getUTCDate()+' '+dt.getUTCHours()+':'+dt.getUTCMinutes()+':'+dt.getUTCSeconds();
                    results[k].TimeStamp__c = new Date(dt).toLocaleString();
                }
                    component.set("v.logs", results);
                     //console.log(results);
          
            var errors = actionResult.getError();
            if (errors) {
              if (errors[0] && errors[0].message) {
                this.showToast("error", errors[0].message);
              }
            }
                 }
          }
        });
    
        $A.enqueueAction(action);
    	},
    

    
    	downloadCsv : function(component,event,helper){
            
            // get the Records [contact] list from 'ListOfContact' attribute 
            var logsData = component.get("v.logs");
            
            // call the helper function which "return" the CSV data as a String   
            var csv = helper.convertArrayOfObjectsToCSV(component,logsData);   
             if (csv == null){return;} 
     
    	     var hiddenElement = document.createElement('a');
              hiddenElement.href = 'data:text/csv;charset=utf-8,'+ encodeURI(csv) ;
              hiddenElement.target = '_self'; 
             hiddenElement.download = 'TransactionLogs.csv';  // CSV file Name* you can change it.[only name not .csv] 
              document.body.appendChild(hiddenElement); // Required for FireFox browser
        	  hiddenElement.click(); // using click() js function to download csv file
        }, 
})