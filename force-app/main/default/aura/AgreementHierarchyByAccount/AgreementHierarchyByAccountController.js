({
    
    doInit : function(component, event, helper){
         //modified by John Paul Revilla 04/08/2020 for US41710
        var action = component.get('c.getInstanceURL');
        action.setCallback(this,function(response){
            //store state of response
            var state = response.getState();
            //checks if success
            if (state === "SUCCESS") {
                var urlArray = [];
                //split return string by the character .
                urlArray = response.getReturnValue().split('.');
                if(urlArray.length >  0){
                    //builds the  base url for apptus 
                    var url = urlArray[0] + '--apttus.' + urlArray[urlArray.length - 1];
                    var method = 'AgreementHierarchyByAccount';
                    //checks if object Type is account and updates the method for url
                    if(component.get('v.objectType') !== 'Account'){
                        method = 'AgreementHierarchy';
                    }
                    //fires the navigation to redirect user to visualforce page
                    $A.get("e.force:navigateToURL").setParams({ 
                        "url": url + ".visual.force.com/apex/"+ method +"?id=" + component.get("v.accountId")
                    }).fire();
                }
            }
        });
    $A.enqueueAction(action);
   
    }
})