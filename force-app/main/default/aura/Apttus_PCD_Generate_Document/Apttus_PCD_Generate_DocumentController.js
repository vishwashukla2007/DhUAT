({

    doInit : function(component, event, helper) 
    {
       helper.getaccount(component, event, helper);
       helper.retrieverecord(component, event, helper);
      if (component.get("v.caveats") == null)
       {
       	var today = new Date();
	    var dd = String(today.getDate()).padStart(2, '0');
	    var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
        var yyyy = today.getFullYear();
        today = mm + '-' + dd + '-' + yyyy; 
        var defaultcaveats0 = component.get("v.defaultcaveats0")
        var defaultcaveats = component.get("v.defaultcaveats")
        var defaultcaveats2 = component.get("v.defaultcaveats2")
        var defaultcaveats2substr1 = defaultcaveats.substring(0,defaultcaveats.indexOf("X year"));
        var defaultcaveats2substr2 = defaultcaveats.substring(defaultcaveats.indexOf("X year")+1,defaultcaveats.length);
        var defaultcaveats2substr3 = defaultcaveats2substr2.substring(0,defaultcaveats2substr2.indexOf("@@/@@/@@@"));
        var defaultcaveats2substr4 = defaultcaveats2substr2.substring(defaultcaveats2substr2.indexOf("@@/@@/@@@")+9,defaultcaveats2substr2.length);
        component.set("v.defaultcaveats2substr1",defaultcaveats2substr1);
        component.set("v.defaultcaveats2substr3",defaultcaveats2substr3);
        component.set("v.defaultcaveats2substr4",defaultcaveats2substr4);
        defaultcaveats2 = defaultcaveats2 + ' ' + today;
        var defaultcaveats3 = component.get("v.defaultcaveats3")    
        var totalcaveats = defaultcaveats + "\n" + "\n" + defaultcaveats2 + "\n" + "\n" + defaultcaveats3;      
        //component.set("v.caveats",totalcaveats);
       }
        
    },
    doctype : function(component, event, helper) 
    {
        component.set("v.docname",component.find("docnames").get("v.value"));
    },
    onselectRadiodoc : function(component, event, helper) 
    {
           component.find("pdf").set("v.value", false);
           component.find("docx").set("v.value", true);
	},
    onselectRadiopdf : function(component, event, helper) 
    {
           component.find("pdf").set("v.value", true);
           component.find("docx").set("v.value", false);       
	},
    onselecttermyes : function(component, event, helper) 
    {
           component.find("termyes").set("v.value", true);
           component.find("termno").set("v.value", false);
            component.set("{!v.displayclause}",true);
	},
    onselecttermno : function(component, event, helper) 
    {
           component.find("termyes").set("v.value", false);
           component.find("termno").set("v.value", true);  
           component.set("{!v.displayclause}",false);
	},
    onselectTemplate : function(component, event, helper) 
    {
		
	},
    handleGenerate : function(component, event, helper) 
    {
        var Req1 =0;
        var messagestr;
        var inputcmp1 = component.find("yearinput");
        var value1 = inputcmp1.get("v.value");
        var inputcmp2 = component.find("escyearinput");
        var value2 = inputcmp2.get("v.value");
        var inputcmp3 = component.find("duedateinput");
        var value3 = inputcmp3.get("v.value");
        $A.util.removeClass(inputcmp1, "slds-has-error");
        $A.util.removeClass(inputcmp2, "slds-has-error");
        $A.util.removeClass(inputcmp3, "slds-has-error");
        if((value1 == null || value1 =="") || (value2 == null || value2 =="") || (value3 == null || value3 ==""))
        {
           messagestr = 'Proposal Year(s), Effective Date and PCD Creation Date are required. \n ';
        Req1 =1;       
        if(value1 == null || value1 =="")
        $A.util.addClass(inputcmp1, "slds-has-error");
        if(value2 == null || value2 =="")
        $A.util.addClass(inputcmp2, "slds-has-error");    
        if(value3 == null || value3 =="")
        $A.util.addClass(inputcmp3, "slds-has-error");         
        }
        if (Req1 == 0)
        {
         component.set("v.DisplaySpinner",true);
		 helper.generatedocument(component, event, helper);
        }
        if (Req1 == 1)
        {
       		var toastEvent = $A.get("e.force:showToast");
    		toastEvent.setParams({
            "type": 'error',
        	"title": "Error!",
        	"message": messagestr
    });
    toastEvent.fire();
        }
	},
    closePCDFile : function(component, event, helper) 
    {
        component.set("v.OpenFile",false);
	},
     accountPage : function(component, event, helper) 
    {
         var urlEvent = $A.get("e.force:navigateToURL");
         urlEvent.setParams({
         "url": 'https://'+ component.get("{!v.vfHost}") + '/lightning/cmp/c__PCD_OFFER_AccountPage_header?c__accountName='+ component.get("{!v.accountid}")
                           });
         urlEvent.fire();
	},
    changeinformation : function(component, event, helper) 
    {
        component.set("{!v.proposalyear}",component.find("yearinput").get("v.value"));
        component.set("{!v.pricingDate}",component.find("escyearinput").get("v.value"));
        component.set("{!v.duedate}",component.find("duedateinput").get("v.value"));
        component.set("{!v.caveats}",component.find("expinput").get("v.value"));
        
    }
})