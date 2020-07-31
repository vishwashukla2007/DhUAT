({
    doInit : function(component, event, helper) {
         component.set("v.coldisplay",true);
        if(component.get("{!v.ObjectName}")=="Network_Pricing__c" && component.get("v.objects.Network_Name_for_Grid__c") != null)  {
            component.set("{!v.isNetwork}",true);
            component.set("{!v.isMail}",false);
            component.set("{!v.isSpecialtyPrice}",false);
            component.set("{!v.isRebate}",false);
            component.set("{!v.isAddProgram}",false);
            component.set("{!v.isClinical}",false);
            var cols = [
                {label: 'RETAIL NON SPECIALTY'},
                {label: 'TRADITIONAL'}
            ];
            component.set("v.tableCols", cols); 
           component.set("v.Col1", component.get("v.objects.Custom_Description__c")); 
            if(component.get("v.objects.Network_Type__c")=="Locked") {
                component.set("v.Col2", "TRADITIONAL"); 
            } else {
                component.set("v.Col2", "TRANSPARENT");
            }
            if(component.get("v.objects.Network_Type__c")=="Locked" && component.get("v.objects.FAF_ID__r.LOB2__c") == "EGWP") {
                component.set("v.Col2", ""); 
            }
            component.set("v.Row1Display", true);
            component.set("v.Row1Col1", "NETWORK"); 
            component.set("v.Row1Col2", component.get("v.objects.Network_Name_for_Grid__c")); 
            component.set("v.Row2Display", true);
            component.set("v.Row2Col1", "BRAND"); 
            var Row2Col2Text;
            if((component.get("v.objects.Template_Brand_Rate_Text__c") != null ) || (component.get("v.objects.FAF_ID__r.LOB2__c") == "EGWP" && component.get("v.objects.Template_Brand_Display__c")==true)) {
                if(component.get("v.objects.Template_Brand_Rate_Text__c") != $A.get("$Label.c.Pass_Through_Text")){
                    Row2Col2Text =  "Brand Rate" + "\n" + component.get("v.objects.Template_Brand_Rate_Text__c") + "\n";
                } else{
                    Row2Col2Text =  component.get("v.objects.Template_Brand_Rate_Text__c") + "\n";
                }
                
            }
            
            if(component.get("v.objects.Template_Preferred_Display__c") == true) {
                if (Row2Col2Text != null) {
                     if(component.get("v.objects.Template_Preferred_Brand_Rate_Text__c") != $A.get("$Label.c.Pass_Through_Text")){
                        Row2Col2Text +=  "Preferred Brand Rate" + "\n" + component.get("v.objects.Template_Preferred_Brand_Rate_Text__c") + "\n";
                      } else {
                       Row2Col2Text +=  component.get("v.objects.Template_Preferred_Brand_Rate_Text__c") + "\n";
                     }
                    if(component.get("v.objects.Template_Non_Preferred_Brand_Rate_Text__c") != $A.get("$Label.c.Pass_Through_Text")){  
                       Row2Col2Text +=  "Non-Preferred Brand Rate" + "\n" + component.get("v.objects.Template_Non_Preferred_Brand_Rate_Text__c") + "\n";
                      } else {
                       Row2Col2Text +=  component.get("v.objects.Template_Non_Preferred_Brand_Rate_Text__c") + "\n";
                     }
                        
                } else {
                   if(component.get("v.objects.Template_Preferred_Brand_Rate_Text__c") != $A.get("$Label.c.Pass_Through_Text")){
                      Row2Col2Text  =  "Preferred Brand Rate" + "\n" + component.get("v.objects.Template_Preferred_Brand_Rate_Text__c") + "\n";
                    } else {
                       Row2Col2Text =  component.get("v.objects.Template_Preferred_Brand_Rate_Text__c") + "\n";
                    } 
                   if(component.get("v.objects.Template_Non_Preferred_Brand_Rate_Text__c") != $A.get("$Label.c.Pass_Through_Text")){
                       Row2Col2Text +=  "Non-Preferred Brand Rate" + "\n" + component.get("v.objects.Template_Non_Preferred_Brand_Rate_Text__c") + "\n";
                    } else {
                       Row2Col2Text +=  component.get("v.objects.Template_Non_Preferred_Brand_Rate_Text__c") + "\n";
                    }
                }
            }
            if(component.get("v.objects.Template_BER_Display__c") == true && component.get("v.objects.FAF_ID__r.LOB2__c") != "EGWP" ) {
                if (Row2Col2Text != null)  {
                   if(component.get("v.objects.Template_BER_Guarantee_Rate_Text__c") != $A.get("$Label.c.Pass_Through_Text")){ 
                      Row2Col2Text +=  "Brand Effective Rate" + "\n" + component.get("v.objects.Template_BER_Guarantee_Rate_Text__c") + "\n";
                    } else {
                      Row2Col2Text +=  component.get("v.objects.Template_BER_Guarantee_Rate_Text__c") + "\n";
                    } 
                    
                }  else {
                    if(component.get("v.objects.Template_BER_Guarantee_Rate_Text__c") != $A.get("$Label.c.Pass_Through_Text")){ 
                       Row2Col2Text =  "Brand Effective Rate" + "\n" + component.get("v.objects.Template_BER_Guarantee_Rate_Text__c") + "\n";  
                     } else {
                       Row2Col2Text =  component.get("v.objects.Template_BER_Guarantee_Rate_Text__c") + "\n";
                    }
                }
            }
            
            component.set("v.Row2Col2", Row2Col2Text);
            component.set("v.Row3Col1", "GENERIC"); 
            var Row3Col2Text;
            if((component.get("v.objects.Template_Generic_Display__c") == true && component.get("v.objects.FAF_ID__r.LOB2__c") != "EGWP") && 
                ((component.get("v.objects.Template_Generic_Rate_Text__c") != null && component.get("v.objects.Template_Generic_Rate_Text__c") != "undefined" )
                  || (component.get("v.objects.Template_GER_Guarantee_Rate_Text__c") != null && component.get("v.objects.Template_GER_Guarantee_Rate_Text__c") != "undefined")
                  || (component.get("v.objects.Template_MER_Guarantee_Rate_Text__c") != null && component.get("v.objects.Template_MER_Guarantee_Rate_Text__c") != "undefined")
                  || (component.get("v.objects.Template_NED_Guarantee_Rate_Text__c") != null && component.get("v.objects.Template_NED_Guarantee_Rate_Text__c") != "undefined")
                  || (component.get("v.objects.Template_OED_Guarantee_Rate_Text__c") != null && component.get("v.objects.Template_OED_Guarantee_Rate_Text__c") != "undefined")
                  || (component.get("v.objects.Template_Generic_OR_Mac_Text__c") != null && component.get("v.objects.Template_Generic_OR_Mac_Text__c") != "undefined"
                   && component.get("v.objects.Network_Name__c")=="Specialty" && component.get("v.objects.Template_Generic_Display__c") == false 
                   && component.get("v.objects.Template_OED_Display__c") == false && (component.get("v.objects.FAF_ID__r.LOB2__c") != "EGWP"
                   || (component.get("v.objects.FAF_ID__r.LOB2__c") == "EGWP" && component.get("v.objects.Retail_Network_Ordinal__c")!="Tertiary"))
                   ) ) 
              || (component.get("v.objects.FAF_ID__r.LOB2__c") == "EGWP" && component.get("v.objects.Template_Non_MAC_Generic_Rate_Text__c")!=null
                   && component.get("v.objects.Template_Non_MAC_Generic_Rate_Text__c")!="undefined" && component.get("v.objects.Network_Name__c")!="Med D - IHS")   
              || (component.get("v.objects.FAF_ID__r.LOB2__c") == "EGWP" && component.get("v.objects.Template_Generic_Rate_Text__c")!=null 
                   && component.get("v.objects.Template_Generic_Rate_Text__c")!="undefined"
                   && component.get("v.objects.Network_Name__c")=="Med D - IHS") ) {
                component.set("v.Row3Display", true);
            } 
            else {
                component.set("v.Row3Display", false);
            }
            if(component.get("v.objects.Template_Generic_Rate_Text__c") != null
               && (component.get("v.objects.FAF_ID__r.LOB2__c") != "EGWP" 
                   || (component.get("v.objects.FAF_ID__r.LOB2__c") == "EGWP" && component.get("v.objects.Retail_Network_Ordinal__c")!="Tertiary")))  {
                if(component.get("v.objects.Brand_Basis__c") != $A.get("$Label.c.Pass_Through_Rate")) {
                     Row3Col2Text =  "Flat Generic Discount" + "\n" + component.get("v.objects.Template_Generic_Rate_Text__c") + "\n";  
                } else {
                     Row3Col2Text =  component.get("v.objects.Template_Generic_Rate_Text__c") + "\n";  
                }
               
            } 
            if(component.get("v.objects.Network_Name__c")=="Med D - IHS" 
               && (component.get("v.objects.FAF_ID__r.LOB2__c") == "EGWP" 
                   || (component.get("v.objects.FAF_ID__r.LOB2__c") == "EGWP" && component.get("v.objects.Retail_Network_Ordinal__c")!="Tertiary")))  {
                Row3Col2Text =   component.get("v.objects.Template_Generic_Rate_Text__c") + "\n";
            } 
            if(component.get("v.objects.Template_GER_Display__c") == true 
               && (component.get("v.objects.FAF_ID__r.LOB2__c") != "EGWP" 
                   || (component.get("v.objects.FAF_ID__r.LOB2__c") == "EGWP" && component.get("v.objects.Retail_Network_Ordinal__c")!="Tertiary"))) {
                if (Row3Col2Text !=null) {
                     if(component.get("v.objects.Brand_Basis__c") != $A.get("$Label.c.Pass_Through_Rate")) {
                        Row3Col2Text +=  "Generic Effective Rate" + "\n" + component.get("v.objects.Template_GER_Guarantee_Rate_Text__c") + "\n";
                       } else {
                        Row3Col2Text +=  component.get("v.objects.Template_GER_Guarantee_Rate_Text__c") + "\n";  
                     }
                } else {
                      if(component.get("v.objects.Brand_Basis__c") != $A.get("$Label.c.Pass_Through_Rate")) {
                         Row3Col2Text =  "Generic Effective Rate" + "\n" + component.get("v.objects.Template_GER_Guarantee_Rate_Text__c") + "\n"; 
                        } else {
                         Row3Col2Text =  component.get("v.objects.Template_GER_Guarantee_Rate_Text__c") + "\n";  
                     }   
                }
            } 
            if(component.get("v.objects.Generic_Basis__c") == "MAC Modeled & Non-MAC"
               && component.get("v.objects.Template_GER_Display__c") == true 
               && (component.get("v.objects.FAF_ID__r.LOB2__c") != "EGWP" 
                   || (component.get("v.objects.FAF_ID__r.LOB2__c") == "EGWP" && component.get("v.objects.Retail_Network_Ordinal__c")!="Tertiary"))) { 
                Row3Col2Text +=  "(MAC Modeled & Non-MAC)" + "\n";     
            } 
            
            if(component.get("v.objects.Template_MER_Display__c") == true 
               && (component.get("v.objects.FAF_ID__r.LOB2__c") != "EGWP" 
                   || (component.get("v.objects.FAF_ID__r.LOB2__c") == "EGWP" && component.get("v.objects.Retail_Network_Ordinal__c")!="Tertiary"))) {
                if (Row3Col2Text !=null) {
                     if(component.get("v.objects.Brand_Basis__c") != $A.get("$Label.c.Pass_Through_Rate")) { 
                       Row3Col2Text +=  "MAC Effective Rate" + "\n" + component.get("v.objects.Template_MER_Guarantee_Rate_Text__c") + "\n";
                      } else {
                         Row3Col2Text +=  component.get("v.objects.Template_MER_Guarantee_Rate_Text__c") + "\n";  
                     }     
                } else {
                    if(component.get("v.objects.Brand_Basis__c") != $A.get("$Label.c.Pass_Through_Rate")) { 
                      Row3Col2Text =  "MAC Effective Rate" + "\n" + component.get("v.objects.Template_MER_Guarantee_Rate_Text__c") + "\n";
                    } else {
                      Row3Col2Text =  component.get("v.objects.Template_MER_Guarantee_Rate_Text__c") + "\n";  
                    }   
                }
            } 
            
            if(component.get("v.objects.Template_NED_Display__c") == true 
               && (component.get("v.objects.FAF_ID__r.LOB2__c") != "EGWP" 
                   || (component.get("v.objects.FAF_ID__r.LOB2__c") == "EGWP" && component.get("v.objects.Retail_Network_Ordinal__c")!="Tertiary"))) {
                if (Row3Col2Text !=null) {
                   if(component.get("v.objects.Brand_Basis__c") != $A.get("$Label.c.Pass_Through_Rate")) { 
                      Row3Col2Text +=  "Net Effective Discount" + "\n" + component.get("v.objects.Template_NED_Guarantee_Rate_Text__c") + "\n";
                    } else {
                      Row3Col2Text +=  component.get("v.objects.Template_NED_Guarantee_Rate_Text__c") + "\n";  
                    }   
                } else  {
                   if(component.get("v.objects.Brand_Basis__c") != $A.get("$Label.c.Pass_Through_Rate")) {  
                     Row3Col2Text =  "Net Effective Discount" + "\n" + component.get("v.objects.Template_NED_Guarantee_Rate_Text__c") + "\n";   
                   } else {
                      Row3Col2Text =  component.get("v.objects.Template_NED_Guarantee_Rate_Text__c") + "\n";  
                   }
                }
            } 
            if(component.get("v.objects.Generic_Basis__c") == "MAC Modeled & Non-MAC"
               && component.get("v.objects.Template_NED_Display__c") == true 
               && (component.get("v.objects.FAF_ID__r.LOB2__c") != "EGWP" 
                   || (component.get("v.objects.FAF_ID__r.LOB2__c") == "EGWP" && component.get("v.objects.Retail_Network_Ordinal__c")!="Tertiary"))) { 
                Row3Col2Text +=  "(MAC Modeled & Non-MAC)" + "\n";     
            }
            
            if(component.get("v.objects.Network_Name__c")=="Specialty"
               && component.get("v.objects.Template_OED_Display__c") == true 
               && (component.get("v.objects.FAF_ID__r.LOB2__c") != "EGWP" 
                   || (component.get("v.objects.FAF_ID__r.LOB2__c") == "EGWP" && component.get("v.objects.Retail_Network_Ordinal__c")!="Tertiary")))  {
                if (Row3Col2Text !=null) {
                   if(component.get("v.objects.Brand_Basis__c") != $A.get("$Label.c.Pass_Through_Rate")) {  
                     Row3Col2Text +=  "Overall Effective Discount" + "\n" + component.get("v.objects.Template_OED_Guarantee_Rate_Text__c") + "\n";
                    } else {
                      Row3Col2Text +=  component.get("v.objects.Template_OED_Guarantee_Rate_Text__c") + "\n";  
                   }  
                } else  {
                   if(component.get("v.objects.Brand_Basis__c") != $A.get("$Label.c.Pass_Through_Rate")) { 
                     Row3Col2Text =  "Overall Effective Discount" + "\n" + component.get("v.objects.Template_OED_Guarantee_Rate_Text__c") + "\n";  
                   } else {
                      Row3Col2Text =  component.get("v.objects.Template_OED_Guarantee_Rate_Text__c") + "\n";  
                   } 
                }
            } 
            if(component.get("v.objects.Network_Name__c")=="Specialty" 
               && component.get("v.objects.Generic_Basis__c") == "MAC Modeled & Non-MAC" 
               && component.get("v.objects.Template_OED_Display__c") == true && 
               (component.get("v.objects.FAF_ID__r.LOB2__c") != "EGWP" 
                || (component.get("v.objects.FAF_ID__r.LOB2__c") == "EGWP" 
                    && component.get("v.objects.Retail_Network_Ordinal__c")!="Tertiary"))) { 
                
                Row3Col2Text +=  "(MAC Modeled & Non-MAC)" + "\n";     
            }   
            
            if(component.get("v.objects.Network_Name__c")=="Specialty"
               && component.get("v.objects.Template_Generic_Display__c") == false 
               && component.get("v.objects.Template_OED_Display__c") == false 
               && (component.get("v.objects.FAF_ID__r.LOB2__c") != "EGWP" 
                   || (component.get("v.objects.FAF_ID__r.LOB2__c") == "EGWP" 
                       && component.get("v.objects.Retail_Network_Ordinal__c")!="Tertiary"))) { 
                
                if (Row3Col2Text !=null) {
                    Row3Col2Text +=   component.get("v.objects.Template_Generic_OR_Mac_Text__c") + "\n";
                } else {
                    Row3Col2Text =  component.get("v.objects.Template_Generic_OR_Mac_Text__c") + "\n";    
                }
            }      
            
            if(component.get("v.objects.FAF_ID__r.LOB2__c") == "EGWP" && component.get("v.objects.Network_Name__c") != "Med D - IHS")  {
                if (Row3Col2Text !=null) {
                    Row3Col2Text += component.get("v.objects.Template_Non_MAC_Generic_Rate_Text__c") + "\n";
                } else {
                    Row3Col2Text =  component.get("v.objects.Template_Non_MAC_Generic_Rate_Text__c") + "\n";
                }
                component.set("v.Row4Display", false);
            } 
            
            component.set("v.Row3Col2", Row3Col2Text);
            
            if (component.get("v.objects.Generic_Basis__c") != "Flat Generic Discount" && component.get("v.objects.FAF_ID__r.LOB2__c") != "EGWP") {
                component.set("v.Row4Display", true);
            } else  {
                component.set("v.Row4Display", false);
            }
            
            component.set("v.Row4Col1", "NON-MAC GENERICS");
            var Row4Col2Text;
            Row4Col2Text =  component.get("v.objects.Template_Non_MAC_Generic_Rate_Text__c") + "\n";
            component.set("v.Row4Col2", Row4Col2Text);
            
            if (component.get("v.objects.SSG_Display__c") == true) {
                component.set("v.Row5Display", true);
            }
            component.set("v.Row5Col1", "SSG GUARANTEE");
            var Row5Col2Text;
            Row5Col2Text =  component.get("v.objects.Template_SSG_Guarantee_Rate_Text__c") + "\n";
            component.set("v.Row5Col2", Row5Col2Text);
            
            component.set("v.Row6Display", true);
            component.set("v.Row6Col1", "DISPENSING FEE");
            var Row6Col2Text;
            Row6Col2Text =  component.get("v.objects.Template_Dispensing_Fee_Text__c") + "\n";
            component.set("v.Row6Col2", Row6Col2Text);
        }
        
        
        if(component.get("{!v.ObjectName}")=="Mail_Pricing__c") {
            component.set("{!v.isNetwork}",false);
            component.set("{!v.isMail}",true);
            component.set("{!v.isSpecialtyPrice}",false);
            component.set("{!v.isRebate}",false);
            component.set("{!v.isAddProgram}",false);
            component.set("{!v.isClinical}",false);
            var cols = [
                {label: component.get("v.objects.Mail_Pricing_Grid_Name__c")},
                {label: ''}
            ];
            component.set("v.tableCols", cols); 
            component.set("v.Col1", component.get("v.objects.Custom_Description__c")); 
            component.set("v.Col2", ""); 
            component.set("v.Row1Display", false);
            component.set("v.Row1Col1", ""); 
            component.set("v.Row1Col2", ""); 
            component.set("v.Row2Display", true);
            component.set("v.Row2Col1", "BRAND"); 
            var Row2Col2Text;
            if((component.get("v.objects.Template_Brand_Rate_Text__c") != null && (component.get("v.objects.Template_BER_Display__c") == false && component.get("v.objects.FAF_ID__r.LOB2__c") != "EGWP") ) || component.get("v.objects.FAF_ID__r.LOB2__c") == "EGWP") {
                Row2Col2Text =  "Brand Rate" + "\n" + component.get("v.objects.Template_Brand_Rate_Text__c") + "\n";
            }
            
            if(component.get("v.objects.Template_Preferred_Display__c") == true) {
                if (Row2Col2Text != null)  {
                    Row2Col2Text +=  "Preferred Brand Rate" + "\n" + component.get("v.objects.Template_Preferred_Brand_Rate_Text__c") + "\n";
                    Row2Col2Text +=  "Non-Preferred Brand Rate" + "\n" + component.get("v.objects.Template_Non_Preferred_Brand_Rate_Text__c") + "\n";
                } else {
                    Row2Col2Text  =  "Preferred Brand Rate" + "\n" + component.get("v.objects.Template_Preferred_Brand_Rate_Text__c") + "\n";
                    Row2Col2Text +=  "Non-Preferred Brand Rate" + "\n" + component.get("v.objects.Template_Non_Preferred_Brand_Rate_Text__c") + "\n";
                }
            }
            if(component.get("v.objects.Template_BER_Display__c") == true && component.get("v.objects.FAF_ID__r.LOB2__c") != "EGWP") {
                if (Row2Col2Text != null) {
                    Row2Col2Text +=  "Brand Effective Rate" + "\n" + component.get("v.objects.Template_BER_Guarantee_Rate_Text__c") + "\n";
                } else {
                    Row2Col2Text =  "Brand Effective Rate" + "\n" + component.get("v.objects.Template_BER_Guarantee_Rate_Text__c") + "\n";    
                }
                
            }
            
            component.set("v.Row2Col2", Row2Col2Text);
            component.set("v.Row3Col1", "GENERIC"); 
            var Row3Col2Text;
            if(component.get("v.objects.Template_Generic_Display__c") == true )  {
                component.set("v.Row3Display", true);
            }  else {
                component.set("v.Row3Display", false);
            }
            if(component.get("v.objects.Template_Generic_Rate_Text__c") != null)  {
                Row3Col2Text =  "Flat Generic Discount" + "\n" + component.get("v.objects.Template_Generic_Rate_Text__c") + "\n";
            } 
            if(component.get("v.objects.Template_GER_Display__c") == true) {
                if (Row3Col2Text !=null) {
                    Row3Col2Text +=  "Generic Effective Rate" + "\n" + component.get("v.objects.Template_GER_Guarantee_Rate_Text__c") + "\n";
                } else  {
                    Row3Col2Text =  "Generic Effective Rate" + "\n" + component.get("v.objects.Template_GER_Guarantee_Rate_Text__c") + "\n";    
                }
            } 
            if(component.get("v.objects.Generic_Basis__c") == "MAC Modeled & Non-MAC"
               && component.get("v.objects.Template_GER_Display__c") == true) { 
                Row3Col2Text +=  "(MAC Modeled & Non-MAC)" + "\n";     
            } 
            
            if(component.get("v.objects.Template_MER_Display__c") == true) {
                if (Row3Col2Text !=null) {
                    Row3Col2Text +=  "MAC Effective Rate" + "\n" + component.get("v.objects.Template_MER_Guarantee_Rate_Text__c") + "\n";
                }
                else  {
                    Row3Col2Text =  "MAC Effective Rate" + "\n" + component.get("v.objects.Template_MER_Guarantee_Rate_Text__c") + "\n";    
                }
            } 
            
            if(component.get("v.objects.Template_NED_Display__c") == true) {
                if (Row3Col2Text !=null) {
                    Row3Col2Text +=  "Net Effective Discount" + "\n" + component.get("v.objects.Template_NED_Guarantee_Rate_Text__c") + "\n";
                } else  {
                    Row3Col2Text =  "Net Effective Discount" + "\n" + component.get("v.objects.Template_NED_Guarantee_Rate_Text__c") + "\n";    
                }
            } 
            if(component.get("v.objects.Generic_Basis__c") == "MAC Modeled & Non-MAC" 
               && component.get("v.objects.Template_NED_Display__c") == true) { 
                Row3Col2Text +=  "(MAC Modeled & Non-MAC)" + "\n";     
            }
            component.set("v.Row3Col2", Row3Col2Text);
            component.set("v.Row4Display", true);
            if (component.get("v.objects.Generic_Basis__c") == "Flat Generic Discount" || component.get("v.objects.Generic_Basis__c") == "Pass-Through") {
                component.set("v.Row4Display", false);
            }
            component.set("v.Row4Col1", "NON-MAC GENERICS");
            var Row4Col2Text;
            Row4Col2Text =  component.get("v.objects.Template_Non_MAC_Generic_Rate_Text__c") + "\n";
            component.set("v.Row4Col2", Row4Col2Text);
            
            if (component.get("v.objects.SSG_Display__c") == true) {
                component.set("v.Row5Display", true);
            }
            component.set("v.Row5Col1", "SSG GUARANTEE");
            var Row5Col2Text;
            Row5Col2Text =  component.get("v.objects.Template_SSG_Guarantee_Rate_Text__c") + "\n";
            component.set("v.Row5Col2", Row5Col2Text);
            
            component.set("v.Row6Display", true);
            component.set("v.Row6Col1", "DISPENSING FEE");
            var Row6Col2Text;
            Row6Col2Text =  component.get("v.objects.Template_Dispensing_Fee_Text__c") + "\n";
            component.set("v.Row6Col2", Row6Col2Text);
        }
        
        
        if(component.get("{!v.ObjectName}")=="Specialty_Pricing__c" && component.get("{!v.isSpecialty}")==false) {
            component.set("{!v.isNetwork}",false);
            component.set("{!v.isMail}",false);
            component.set("{!v.isSpecialtyPrice}",true);
            component.set("{!v.isRebate}",false);
            component.set("{!v.isAddProgram}",false);
            component.set("{!v.isClinical}",false);
            var cols = [
                {label: component.get("{!v.objects.Custom_Description__c}")},
                {label: component.get("v.objects.Pharmacy_Benefit_Text__c")}
            ];
            var column1 = "SPECIALTY AT CVS SPECIALTY MAIL, INCLUDING SPECIALTY CONNECT";
            component.set("v.tableCols", cols); 
            component.set("v.Col1", component.get("{!v.objects.Custom_Description__c}")); 
            component.set("v.Col2", component.get("v.objects.Pharmacy_Benefit_Text__c")); 
            component.set("v.Row1Display", true);
            component.set("v.Row1Col1", column1); 
            component.set("v.Row1Col2", "See Specialty Fee Schedule"); 
            component.set("v.Row2Display", false);
            component.set("v.Row3Display", false);
            component.set("v.Row4Display", false);
            component.set("v.Row5Display", false);
            component.set("v.Row6Display", false);
        }
        
        if(component.get("{!v.ObjectName}")=="Specialty_Pricing__c" && component.get("{!v.isSpecialty}")==true) {
            component.set("{!v.isNetwork}",false);
            component.set("{!v.isMail}",false);
            component.set("{!v.isSpecialtyPrice}",true);
            component.set("{!v.isRebate}",false);
            component.set("{!v.isAddProgram}",false);
            component.set("{!v.isClinical}",false);
            var cols = [
                {label: 'SPECIALTY'},
                {label: ''}
            ];
            component.set("v.tableCols", cols); 
            component.set("v.Col1", 'SPECIALTY'); 
            component.set("v.Col2", ''); 
            component.set("v.Row1Display", true);
            component.set("v.Row1Col1", "Open"); 
            component.set("v.Row1Col2", component.get("v.objects.Specialty_Legacy_Drug_Level_Pharmacy__c")); 
            component.set("v.Row2Display", false);
            component.set("v.Row3Display", false);
            component.set("v.Row4Display", false);
            component.set("v.Row5Display", false);
            component.set("v.Row6Display", false);
        }
        
        if(component.get("{!v.ObjectName}")=="Clinical_Solutions__c") {
            component.set("{!v.isNetwork}",false);
            component.set("{!v.isMail}",false);
            component.set("{!v.isSpecialtyPrice}",false);
            component.set("{!v.isRebate}",false);
            component.set("{!v.isAddProgram}",false);
            component.set("{!v.isClinical}",true);
            var cols = [
                {label: component.get("v.objects.Custom_Description__c")},
                {label: ''}
            ];
            component.set("v.tableCols", cols); 
            component.set("v.Col1",component.get("v.objects.Custom_Description__c")); 
            component.set("v.Col2", ''); 
            component.set("v.Row1Col1", component.get("v.objects.Clinical_Solution__c")); 
            var Row1Col2Text;
            Row1Col2Text = component.get("v.objects.Template_Fee_Basis_Text__c");
            component.set("v.Row1Col2", Row1Col2Text); 
            if (component.get("v.indexvar") > 0)
            {
             component.set("v.coldisplay",true);  
             var cmpTarget = component.find('card');
             $A.util.removeClass(cmpTarget, 'container');
             $A.util.removeClass(cmpTarget, 'slds-grid');
             $A.util.removeClass(cmpTarget, 'slds-card__header');
             $A.util.removeClass(cmpTarget, 'header');
            }
            component.set("v.Row1Display", true);
            component.set("v.Row2Display", false);
            component.set("v.Row3Display", false);
            component.set("v.Row4Display", false);
            component.set("v.Row5Display", false);
            component.set("v.Row6Display", false);
        }
        
        if(component.get("{!v.ObjectName}")=="Billing_Admin_Fee__c")  {
            component.set("{!v.isNetwork}",false);
            component.set("{!v.isMail}",false);
            component.set("{!v.isSpecialtyPrice}",false);
            component.set("{!v.isRebate}",false);
            component.set("{!v.isAddProgram}",true);
            component.set("{!v.isClinical}",false);
            var cols = [
                {label: 'ADMINISTRATIVE FEES'},
                {label: ''}
            ];
            component.set("v.tableCols", cols); 
            component.set("v.Col1", component.get("{!v.objects.Custom_Description__c}")); 
            component.set("v.Col2", ''); 
            component.set("v.Row1Col1", "ELECTRONIC CLAIM ADMINISTRATION FEE"); 
            var Row1Col2Text;
            Row1Col2Text = component.get("v.objects.Template_Master_Electronic_Fee_Text__c");
            component.set("v.Row1Col2", Row1Col2Text); 
            component.set("v.Row1Display", true);
            
            component.set("v.Row2Col1", "MANUAL CLAIM ADMINISTRATION FEE"); 
            var Row2Col2Text;
            Row2Col2Text = component.get("v.objects.Template_Master_Manual_Claim_Fee_Text__c");
            component.set("v.Row2Col2", Row2Col2Text);       
            component.set("v.Row2Display", true);
            
            component.set("v.Row3Col1", "340B ADMINISTRATION FEE"); 
            var Row3Col2Text;
            Row3Col2Text = component.get("v.objects.Template_Master_340B_Type_Text__c");
            component.set("v.Row3Col2", Row3Col2Text);  
            if (component.get("v.objects.Template_340B_Display__c")== true)  {
                component.set("v.Row3Display", true);
            } else {
                component.set("v.Row3Display", false);   
            }
            
            component.set("v.Row4Col1", "SELF-FUNDED EGWP ADMINISTRATIVE FEE"); 
            var Row4Col2Text;
            Row4Col2Text = component.get("v.objects.Template_Master_EGWPPMPM_Type_Text__c");
            component.set("v.Row4Col2", Row4Col2Text);  
            if (component.get("v.objects.LOB2__c")== "EGWP" && component.get("v.objects.Template_EGWPPMPM_Display__c")== true) {
                component.set("v.Row4Display", true);
            } else {
                component.set("v.Row4Display", false);   
            }  
            
            component.set("v.Row5Display", false);
            component.set("v.Row6Display", false);
        }
        
             //Changes by Mohit Srivastava
        if(component.get("{!v.ObjectName}")=="Rebate_Guarantee__c" && component.get("{!v.isCarveOut}")==false)  
        {
            console.log("IN Child Object Name"+component.get("{!v.ObjectName}"));
            console.log("Specialty Flag"+component.get("v.objects.Show_in_Specialty_Grid__c"));
            console.log("Non Specialty Flag"+component.get("v.objects.Show_in_Non_Specialty_Grid__c"));
            component.set("{!v.isNetwork}",false);
            component.set("{!v.isMail}",false);
            component.set("{!v.isSpecialtyPrice}",false);
            component.set("{!v.isRebate}",true);
            component.set("{!v.isAddProgram}",false);
            component.set("{!v.isClinical}",false);
            component.set("{!v.isGrid}",component.get("v.objects.Grid_flag__c"));
                                             
             if(component.get("v.objects.PCD_Same_dollar_and_Percentage_Value__c")==true && component.get("v.objects.Non_Specialty_Grid__c")==true) 
             {
                var cols = [
                {label: ''},
                {label: ''}
                ];
             
                component.set("v.tableCols", cols); 
                component.set("v.isNONSpecialtyGrid",true);
                 
                if(component.get("v.objects.Non_Specialty_Grid__c")==true){
                component.set("v.Col1",component.get("v.objects.Custom_Description__c")); 
                component.set("v.Col2",component.get("v.objects.Plan_Design__c")); 
                }
                 //Updated by Parvathi 3/27
                
                if(component.get("v.objects.Template_Retail_Display__c")==true && component.get("v.objects.Non_Specialty_Grid__c")==true){
                    
                    component.set("v.Row1Display", true);
                    component.set("v.Row1Col1", "RETAIL"); 
                     var resString = '';
                    // added by Parvathi
                    var concatRes;
                    if(component.get("v.objects.Percentage_Check__c")==true){
						if(component.get("v.objects.RETAIL_Y1_Percentage__c")!=null){
                        concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.RETAIL_Y1_Percentage__c"), component.get("v.objects.Basis_Y1__c"), true);
						}
						else{
							 concatRes =''; 
							
						}
                    }else{
                        if(component.get("v.objects.RETAIL_Y1__c")!=null){
                         concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.RETAIL_Y1__c"), component.get("v.objects.Basis_Y1__c"), false);
					    }
						else{
							 concatRes =''; 
						}
                    }
                    
                    if(concatRes) resString = resString + concatRes;
                       
                    var concatRes1;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                      if(component.get("v.objects.RETAIL_Y2_Percentage__c")!=null){
                       concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.RETAIL_Y2_Percentage__c"), component.get("v.objects.Basis_Y2__c"), true);
					  }
					  else{
							 concatRes1 =''; 
						}
					}else{
                       if(component.get("v.objects.RETAIL_Y2__c")!=null){
                        concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.RETAIL_Y2__c"), component.get("v.objects.Basis_Y2__c"), false);
                       } 
                       else{
							 concatRes1 =''; 
						}
					}
                    
                    if(concatRes1) resString = resString + concatRes1;
                   
                    var concatRes2;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.RETAIL_Y3_Percentage__c")!=null){
                          concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.RETAIL_Y3_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
						}
						else{
							 concatRes2 =''; 
						}
                    }else{
                       if(component.get("v.objects.RETAIL_Y3__c")!=null){
                        concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.RETAIL_Y3__c"), component.get("v.objects.Basis_Y3__c"), false);
					   }
					    else{
							 concatRes2 =''; 
						}
                    }
                      if(concatRes2) resString = resString + concatRes2;
                    
                    var concatRes3;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.RETAIL_Y4_Percentage__c")!=null){
                         concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.RETAIL_Y4_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
						}
						else{
							 concatRes3=''; 
						}
                    }else{
                       if(component.get("v.objects.RETAIL_Y4__c")!=null){
                        concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.RETAIL_Y4__c"), component.get("v.objects.Basis_Y4__c"), false);
					   }
					   else{
							 concatRes3=''; 
						}
					}
                     if(concatRes3) resString = resString + concatRes3;
                    
                     var concatRes4;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                         if(component.get("v.objects.RETAIL_Y5_Percentage__c")!=null){
                         concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.RETAIL_Y5_Percentage__c"), component.get("v.objects.Basis_Y5__c"), true);
						 }
						 else{
							 concatRes4=''; 
						}
                    }else{
                        if(component.get("v.objects.RETAIL_Y5__c")!=null){
                            concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.RETAIL_Y5__c"), component.get("v.objects.Basis_Y5__c"), false);
						}
						else{
							 concatRes4=''; 
						}
					}
                     if(concatRes4) resString = resString + concatRes4;
                    
                     var concatRes5;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.RETAIL_Y6_Percentage__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.RETAIL_Y6_Percentage__c"), component.get("v.objects.Basis_Y6__c"), true);
						}
						else{
							 concatRes5=''; 
						}
                    }else{
                        if(component.get("v.objects.RETAIL_Y6__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.RETAIL_Y6__c"), component.get("v.objects.Basis_Y6__c"), false);
                        }
						else{
							 concatRes5=''; 
						}
					}
                    if(concatRes5) resString = resString + concatRes5;
                   
                                      
                      component.set("v.Row1Col2", resString);
                } 

                     if(component.get("v.objects.Template_Retail30_Display__c")==true && component.get("v.objects.Non_Specialty_Grid__c")==true){
                    component.set("v.Row2Display", true);
                    component.set("v.Row2Col1", "RETAIL 30");
                     var resString = '';
                    // added by Parvathi
                    var concatRes;
                    if(component.get("v.objects.Percentage_Check__c")==true){
						if(component.get("v.objects.RETAIL30_Y1_Percentage__c")!=null){
                        concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.RETAIL30_Y1_Percentage__c"), component.get("v.objects.Basis_Y1__c"), true);
						}
						else{
						concatRes ='';
						}
                    }else{
                         if(component.get("v.objects.RETAIL30_Y1__c")!=null){
                         concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.RETAIL30_Y1__c"), component.get("v.objects.Basis_Y1__c"), false);
						 }
						 else{
							 concatRes = '';
						 }
						 
                    }
                    
                    if(concatRes) resString = resString + concatRes;
                       
                    var concatRes1;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                      if(component.get("v.objects.RETAIL30_Y2_Percentage__c")!=null){
                          concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.RETAIL30_Y2_Percentage__c"), component.get("v.objects.Basis_Y2__c"), true);
					  }
					  else{
						  concatRes1 =''; 
						  
					  }
                    }else{
						 if(component.get("v.objects.RETAIL30_Y2__c")!=null){
                        concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.RETAIL30_Y2__c"), component.get("v.objects.Basis_Y2__c"), false);
                         }
						else{
						  concatRes1 =''; 
					    }
					}
                    
                    if(concatRes1) resString = resString + concatRes1;
                    
                    var concatRes2;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                         if(component.get("v.objects.RETAIL30_Y3_Percentage__c")!=null){
                          concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.RETAIL30_Y3_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
						 }
						 else{
							concatRes2 = ''; 
						 }
                    }else{
                        if(component.get("v.objects.RETAIL30_Y3__c")!=null){
                        concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.RETAIL30_Y3__c"), component.get("v.objects.Basis_Y3__c"), false);
						}
						else{
							concatRes2 = ''; 
						 }
					}
                      if(concatRes2) resString = resString + concatRes2;
                    
                    var concatRes3;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.RETAIL30_Y4_Percentage__c")!=null){
                         concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.RETAIL30_Y4_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
						}
						else{
							concatRes3= ''; 
						 }
					}else{
                       if(component.get("v.objects.RETAIL30_Y4__c")!=null){
                        concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.RETAIL30_Y4__c"), component.get("v.objects.Basis_Y4__c"), false);
					   }
					   else{
							concatRes3 = ''; 
						 }
					}
                     if(concatRes3) resString = resString + concatRes3;
                    
                     var concatRes4;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                         if(component.get("v.objects.RETAIL30_Y5_Percentage__c")!=null){
                         concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.RETAIL30_Y5_Percentage__c"), component.get("v.objects.Basis_Y5__c"), true);
						 }
						 else{
							concatRes4 = ''; 
						 }
                    }else{
                        if(component.get("v.objects.RETAIL30_Y5__c")!=null){
                        concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.RETAIL30_Y5__c"), component.get("v.objects.Basis_Y5__c"), false);
						}
						else{
							concatRes4 = ''; 
						 }
						
					}
                     if(concatRes4) resString = resString + concatRes4;
                    
                     var concatRes5;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                         if(component.get("v.objects.RETAIL30_Y6_Percentage__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.RETAIL30_Y6_Percentage__c"), component.get("v.objects.Basis_Y6__c"), true);
						 }
						 else{
							 concatRes5 ='';
						 }
					}else{
                       if(component.get("v.objects.RETAIL30_Y6__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.RETAIL30_Y6__c"), component.get("v.objects.Basis_Y6__c"), false);
                       }
					   else{
							 concatRes5 ='';
						 }
					}
                    if(concatRes5) resString = resString + concatRes5;
                   
                                      
                      component.set("v.Row2Col2", resString);
                  
                }
                if(component.get("v.objects.Template_Retail90_Display__c")==true && component.get("v.objects.Non_Specialty_Grid__c")==true){
                    component.set("v.Row3Display", true);
                    component.set("v.Row3Col1", "RETAIL 90"); 
                     var resString = '';
                    // added by Parvathi
                    var concatRes;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                       if(component.get("v.objects.RETAIL90_Y1_Percentage__c")!=null){
                        concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.RETAIL90_Y1_Percentage__c"), component.get("v.objects.Basis_Y1__c"), true);
                       }
					   else{
						 concatRes = '';  
					   }
					}else{
                        if(component.get("v.objects.RETAIL90_Y1__c")!=null){
                         concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.RETAIL90_Y1__c"), component.get("v.objects.Basis_Y1__c"), false);
						}
						else{
						 concatRes = '';  
					   }
                    }
                    
                    if(concatRes) resString = resString + concatRes;
                       
                    var concatRes1;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.RETAIL90_Y2_Percentage__c")!=null){
                       concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.RETAIL90_Y2_Percentage__c"), component.get("v.objects.Basis_Y2__c"), true);
						}
						else{
						 concatRes1 = '';  
					   }
					}else{
                        if(component.get("v.objects.RETAIL90_Y2__c")!=null){
                        concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.RETAIL90_Y2__c"), component.get("v.objects.Basis_Y2__c"), false);
                        }
						else{
						 concatRes1 = '';  
					   }
					}
                    
                    if(concatRes1) resString = resString + concatRes1;
                    
                    var concatRes2;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.RETAIL90_Y3_Percentage__c")!=null){
                          concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.RETAIL90_Y3_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
                        }
						else{
						 concatRes2 = '';  
					   }
					}else{
                       if(component.get("v.objects.RETAIL90_Y3__c")!=null){
                        concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.RETAIL90_Y3__c"), component.get("v.objects.Basis_Y3__c"), false);
                        }
						else{
						 concatRes2 = '';  
					   }
					}
                      if(concatRes2) resString = resString + concatRes2;
                    
                    var concatRes3;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.RETAIL90_Y4_Percentage__c")!=null){
                         concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.RETAIL90_Y4_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
                        }
						else{
						 concatRes3 = '';  
					   }
					}else{
                        if(component.get("v.objects.RETAIL90_Y4__c")!=null){
                        concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.RETAIL90_Y4__c"), component.get("v.objects.Basis_Y4__c"), false);
                        }
						else{
						 concatRes3 = '';  
					   }
					}
                     if(concatRes3) resString = resString + concatRes3;
                    
                     var concatRes4;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                         if(component.get("v.objects.RETAIL90_Y5_Percentage__c")!=null){
                         concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.RETAIL90_Y5_Percentage__c"), component.get("v.objects.Basis_Y5__c"), true);
                         }
						 else{
						 concatRes4 = '';  
					     }
					}else{
                       if(component.get("v.objects.RETAIL90Y5__c")!=null){
                        concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.RETAIL90Y5__c"), component.get("v.objects.Basis_Y5__c"), false);
                        }
						else{
						 concatRes4 = '';  
					   }
					}
                     if(concatRes4) resString = resString + concatRes4;
                    
                     var concatRes5;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                         if(component.get("v.objects.RETAIL90_Y6_Percentage__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.RETAIL90_Y6_Percentage__c"), component.get("v.objects.Basis_Y6__c"), true);
                         }
						 else{
						 concatRes5 = '';  
					   }
					}else{
                       if(component.get("v.objects.RETAIL90Y6__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.RETAIL90Y6__c"), component.get("v.objects.Basis_Y6__c"), false);
                        }
						else{
						 concatRes5 = '';  
					   }
					}
                    if(concatRes5) resString = resString + concatRes5;
                   
                                      
                      component.set("v.Row3Col2", resString);
                
                }
                 
                 //Updated by Parvathi
                if(component.get("v.objects.Template_ClientOwned_Display__c")==true && component.get("v.objects.Non_Specialty_Grid__c")==true){
                    component.set("v.Row4Display", true);
                    component.set("v.Row4Col1", "CLIENT OWNED"); 
                    var resString = '';
                    // added by Parvathi
                    var concatRes;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                       if(component.get("v.objects.CLIENTOWNED_Y1_Percentage__c")!=null){
                        concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.CLIENTOWNED_Y1_Percentage__c"), component.get("v.objects.Basis_Y1__c"), true);
                        }
						else{
						 concatRes = '';  
					   }
					
					}else{
                        if(component.get("v.objects.CLIENT_OWNED_Y1__c")!=null){
                         concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.CLIENT_OWNED_Y1__c"), component.get("v.objects.Basis_Y1__c"), false);
                        }
						else{
						 concatRes = '';  
					   }
					}
                    
                    if(concatRes) resString = resString + concatRes;
                       
                    var concatRes1;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                      if(component.get("v.objects.CLIENTOWNED_Y2_Percentage__c")!=null){
                       concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.CLIENTOWNED_Y2_Percentage__c"), component.get("v.objects.Basis_Y2__c"), true);
                      }
					  else{
						 concatRes1 = '';  
					   }
					}else{
                       if(component.get("v.objects.CLIENT_OWNED_Y2__c")!=null){
                        concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.CLIENT_OWNED_Y2__c"), component.get("v.objects.Basis_Y2__c"), false);
                       }
					   else{
						 concatRes1 = '';  
					   }
					}
                    
                    if(concatRes1) resString = resString + concatRes1;
                    
                    var concatRes2;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.CLIENTOWNED_Y3_Percentage__c")!=null){
                          concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.CLIENTOWNED_Y3_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
                        }
						else{
						 concatRes2 = '';  
					   }
					}else{
                        if(component.get("v.objects.CLIENT_OWNED_Y3__c")!=null){
                        concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.CLIENT_OWNED_Y3__c"), component.get("v.objects.Basis_Y3__c"), false);
                        }
						else{
						 concatRes2 = '';  
					   }
					}
                      if(concatRes2) resString = resString + concatRes2;
                    
                    var concatRes3;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.CLIENTOWNED_Y4_Percentage__c")!=null){
                         concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.CLIENTOWNED_Y4_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
                        }
						else{
						 concatRes3 = '';  
					   }
					}else{
                       if(component.get("v.objects.CLIENT_OWNED_Y4__c")!=null){
                        concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.CLIENT_OWNED_Y4__c"), component.get("v.objects.Basis_Y4__c"), false);
                       }
					   else{
						 concatRes3= '';  
					   }
					
					}
                     if(concatRes3) resString = resString + concatRes3;
                    
                     var concatRes4;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                         if(component.get("v.objects.CLIENTOWNED_Y5_Percentage__c")!=null){
                         concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.CLIENTOWNED_Y5_Percentage__c"), component.get("v.objects.Basis_Y5__c"), true);
                        }
						else{
						 concatRes4= '';  
					   }
					}else{
                          if(component.get("v.objects.CLIENT_OWNED_Y5__c")!=null){
                        concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.CLIENT_OWNED_Y5__c"), component.get("v.objects.Basis_Y5__c"), false);
                         }
						 else{
						 concatRes4 = '';  
					   }
					
					}
                     if(concatRes4) resString = resString + concatRes4;
                    
                     var concatRes5;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                          if(component.get("v.objects.CLIENTOWNED_Y6_Percentage__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.CLIENTOWNED_Y6_Percentage__c"), component.get("v.objects.Basis_Y6__c"), true);
                        }
						else{
						 concatRes5 = '';  
					   }
					}else{
                        if(component.get("v.objects.CLIENT_OWNED_Y6__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.CLIENT_OWNED_Y6__c"), component.get("v.objects.Basis_Y6__c"), false);
                        }
						else{
						 concatRes5 = '';  
					   }
					
					}
                    if(concatRes5) resString = resString + concatRes5;
                   
                                      
                      component.set("v.Row4Col2", resString);
                  
                  
                }
                if(component.get("v.objects.Template_ClientOwned30_Display__c")==true && component.get("v.objects.Non_Specialty_Grid__c")==true){
                    component.set("v.Row5Display", true);
                    component.set("v.Row5Col1", "CLIENT OWNED 30"); 
                    
                    var resString = '';
                    // added by Parvathi
                    var concatRes;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                       if(component.get("v.objects.CLIENTOWNED30_Y1_Percentage__c")!=null){
                        concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.CLIENTOWNED30_Y1_Percentage__c"), component.get("v.objects.Basis_Y1__c"), true);
                        }
						else{
						 concatRes = '';  
					   }
					}else{
                       if(component.get("v.objects.CLIENT_OWNED30_Y1__c")!=null){
                         concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.CLIENT_OWNED30_Y1__c"), component.get("v.objects.Basis_Y1__c"), false);
                        }
						else{
						 concatRes= '';  
					   }
					}
                    
                    if(concatRes) resString = resString + concatRes;
                       
                    var concatRes1;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                       if(component.get("v.objects.CLIENTOWNED30_Y2_Percentage__c")!=null){
                       concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.CLIENTOWNED30_Y2_Percentage__c"), component.get("v.objects.Basis_Y2__c"), true);
                        }
						else{
						 concatRes1 = '';  
					   }
					
					}else{
                        if(component.get("v.objects.CLIENT_OWNED30_Y2__c")!=null){
                        concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.CLIENT_OWNED30_Y2__c"), component.get("v.objects.Basis_Y2__c"), false);
                        }
						else{
						 concatRes1 = '';  
					   }
					
					}
                    
                    if(concatRes1) resString = resString + concatRes1;
                    
                    var concatRes2;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.CLIENTOWNED30_Y3_Percentage__c")!=null){
                          concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.CLIENTOWNED30_Y3_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
                        }
						else{
						 concatRes2 = '';  
					   }
					
					}else{
                       if(component.get("v.objects.CLIENT_OWNED30_Y3__c")!=null){
                        concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.CLIENT_OWNED30_Y3__c"), component.get("v.objects.Basis_Y3__c"), false);
                       }
					   else{
						 concatRes2 = '';  
					   }
					
					}
                      if(concatRes2) resString = resString + concatRes2;
                    
                    var concatRes3;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                          if(component.get("v.objects.CLIENTOWNED30_Y4_Percentage__c")!=null){
                         concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.CLIENTOWNED30_Y4_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
                        }
						else{
						 concatRes3= '';  
					   }
					
					}else{
                         if(component.get("v.objects.CLIENT_OWNED30_Y4__c")!=null){
                        concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.CLIENT_OWNED30_Y4__c"), component.get("v.objects.Basis_Y4__c"), false);
                        }
						else{
						 concatRes3 = '';  
					   }
					
					}
                     if(concatRes3) resString = resString + concatRes3;
                    
                     var concatRes4;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                         if(component.get("v.objects.CLIENTOWNED30_Y5_Percentage__c")!=null){
                         concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.CLIENTOWNED30_Y5_Percentage__c"), component.get("v.objects.Basis_Y5__c"), true);
                         }
						 else{
						 concatRes4 = '';  
					     }
					
					}else{
                        if(component.get("v.objects.CLIENT_OWNED30_Y5__c")!=null){
                        concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.CLIENT_OWNED30_Y5__c"), component.get("v.objects.Basis_Y5__c"), false);
                        }
						else{
						 concatRes4 = '';  
					   }
					}
                     if(concatRes4) resString = resString + concatRes4;
                    
                     var concatRes5;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                         if(component.get("v.objects.CLIENTOWNED30_Y6_Percentage__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.CLIENTOWNED30_Y6_Percentage__c"), component.get("v.objects.Basis_Y6__c"), true);
                        }
						else{
						 concatRes5 = '';  
					     }
					
					}else{
                        if(component.get("v.objects.CLIENT_OWNED30_Y6__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.CLIENT_OWNED30_Y6__c"), component.get("v.objects.Basis_Y6__c"), false);
                        }
						else{
						 concatRes5= '';  
					    }
					}
                    if(concatRes5) resString = resString + concatRes5;
                   
                                      
                      component.set("v.Row5Col2", resString);
             
                }
                if(component.get("v.objects.Template_ClientOwned90_Display__c")==true && component.get("v.objects.Non_Specialty_Grid__c")==true){
                    component.set("v.Row6Display", true);
                    component.set("v.Row6Col1", "CLIENT OWNED 90"); 
                    
                    var resString = '';
                    // added by Parvathi
                    var concatRes;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                       if(component.get("v.objects.CLIENTOWNED90_Y1_Percentage__c")!=null){
                        concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.CLIENTOWNED90_Y1_Percentage__c"), component.get("v.objects.Basis_Y1__c"), true);
                        }
						else{
						 concatRes= '';  
					   }
					}else{
                         if(component.get("v.objects.CLIENT_OWNED90_Y1__c")!=null){
                         concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.CLIENT_OWNED90_Y1__c"), component.get("v.objects.Basis_Y1__c"), false);
				        }
						else{
						 concatRes= '';  
					   }
					}
                    
                    if(concatRes) resString = resString + concatRes;
                       
                    var concatRes1;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                       if(component.get("v.objects.CLIENTOWNED90_Y2_Percentage__c")!=null){
                       concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.CLIENTOWNED90_Y2_Percentage__c"), component.get("v.objects.Basis_Y2__c"), true);
                       }
					   else{
						 concatRes1 = '';  
					   }
					
					}else{
                        if(component.get("v.objects.CLIENT_OWNED90_Y2__c")!=null){
                        concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.CLIENT_OWNED90_Y2__c"), component.get("v.objects.Basis_Y2__c"), false);
                        }
						else{
						 concatRes1 = '';  
					   }
					}
                    
                    if(concatRes1) resString = resString + concatRes1;
                    
                    var concatRes2;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.CLIENTOWNED90_Y3_Percentage__c")!=null){
                          concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.CLIENTOWNED90_Y3_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
                        }
						else{
						 concatRes2 = '';  
					   }
					
					}else{
                       if(component.get("v.objects.CLIENT_OWNED90_Y3__c")!=null){
                        concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.CLIENT_OWNED90_Y3__c"), component.get("v.objects.Basis_Y3__c"), false);
                       }
					   else{
						 concatRes2 = '';  
					   }
					}
                      if(concatRes2) resString = resString + concatRes2;
                    
                    var concatRes3;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                         if(component.get("v.objects.CLIENTOWNED90_Y4_Percentage__c")!=null){
                         concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.CLIENTOWNED90_Y4_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
                        }
						else{
						 concatRes3 = '';  
					   }
					
					}else{
                        if(component.get("v.objects.CLIENT_OWNED90_Y4__c")!=null){
                        concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.CLIENT_OWNED90_Y4__c"), component.get("v.objects.Basis_Y4__c"), false);
                        }
						else{
						 concatRes3 = '';  
					   }
					}
                     if(concatRes3) resString = resString + concatRes3;
                    
                     var concatRes4;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.CLIENTOWNED90_Y5_Percentage__c")!=null){
                         concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.CLIENTOWNED90_Y5_Percentage__c"), component.get("v.objects.Basis_Y5__c"), true);
                        }
						else{
						 concatRes4 = '';  
					   }
					}else{
                       if(component.get("v.objects.CLIENT_OWNED90_Y5__c")!=null){
                        concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.CLIENT_OWNED90_Y5__c"), component.get("v.objects.Basis_Y5__c"), false);
                        }
						else{
						 concatRes4 = '';  
					   }
					}
                     if(concatRes4) resString = resString + concatRes4;
                    
                     var concatRes5;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.CLIENTOWNED90_Y6_Percentage__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.CLIENTOWNED90_Y6_Percentage__c"), component.get("v.objects.Basis_Y6__c"), true);
                        }
						else{
						 concatRes5 = '';  
					   }
					
					}else{
                         if(component.get("v.objects.CLIENT_OWNED90_Y6__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.CLIENT_OWNED90_Y6__c"), component.get("v.objects.Basis_Y6__c"), false);
				       }
					   else{
						 concatRes5= '';  
					   }
					
					}
                    if(concatRes5) resString = resString + concatRes5;
                   
                                      
                      component.set("v.Row6Col2", resString);
                  
               
                }
                if(component.get("v.objects.Template_Mail_Display__c")==true && component.get("v.objects.Non_Specialty_Grid__c")==true){
                    component.set("v.Row7Display", true);
                    component.set("v.Row7Col1",component.get("v.objects.Template_Mail_Label__c")); 
                    //Added by Parvathi
                     var resString = '';
                    
                    var concatRes;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                       if(component.get("v.objects.MAIL_Y1_Percentage__c")!=null){
                        concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.MAIL_Y1_Percentage__c"), component.get("v.objects.Basis_Y1__c"), true);
                        }
						else{
						 concatRes= '';  
					   }
					}else{
                        if(component.get("v.objects.MAILY1__c")!=null){
                         concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.MAILY1__c"), component.get("v.objects.Basis_Y1__c"), false);
                        }
						else{
						 concatRes= '';  
					   }
					
					}
                    
                    if(concatRes) resString = resString + concatRes;
                       
                    var concatRes1;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                       if(component.get("v.objects.MAIL_Y2_Percentage__c")!=null){
                       concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.MAIL_Y2_Percentage__c"), component.get("v.objects.Basis_Y2__c"), true);
                       }
					   else{
						 concatRes1= '';  
					   }
					
					}else{
                        if(component.get("v.objects.MAILY2__c")!=null){
                        concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.MAILY2__c"), component.get("v.objects.Basis_Y2__c"), false);
                        }
						else{
						 concatRes1 = '';  
					   }
					}
                    
                    if(concatRes1) resString = resString + concatRes1;
                    
                    var concatRes2;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.MAIL_Y3_Percentage__c")!=null){
                          concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.MAIL_Y3_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
                        }
						else{
						 concatRes2 = '';  
					   }
					}else{
                       if(component.get("v.objects.MAILY3__c")!=null){
                        concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.MAILY3__c"), component.get("v.objects.Basis_Y3__c"), false);
                       }
					   else{
						 concatRes2 = '';  
					   }
					}
                      if(concatRes2) resString = resString + concatRes2;
                    
                    var concatRes3;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                         if(component.get("v.objects.MAIL_Y4_Percentage__c")!=null){
                         concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.MAIL_Y4_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
                        }
						else{
						 concatRes3 = '';  
					   }
					}else{
                        if(component.get("v.objects.MAILY4__c")!=null){
                        concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.MAILY4__c"), component.get("v.objects.Basis_Y4__c"), false);
                        }
						else{
						 concatRes3 = '';  
					   }
					}
                     if(concatRes3) resString = resString + concatRes3;
                    
                     var concatRes4;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.MAIL_Y5_Percentage__c")!=null){
                         concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.MAIL_Y5_Percentage__c"), component.get("v.objects.Basis_Y5__c"), true);
				        }
						else{
						 concatRes4 = '';  
					   }
						
					}else{
                       if(component.get("v.objects.MAILY5__c")!=null){
                        concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.MAILY5__c"), component.get("v.objects.Basis_Y5__c"), false);
			           }
					   else{
						 concatRes4 = '';  
					   }
					}
                     if(concatRes4) resString = resString + concatRes4;
                    
                     var concatRes5;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.MAIL_Y6_Percentage__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.MAIL_Y6_Percentage__c"), component.get("v.objects.Basis_Y6__c"), true);
                        }
						else{
						 concatRes5 = '';  
					   }
					}else{
                        if(component.get("v.objects.MAILY6__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.MAILY6__c"), component.get("v.objects.Basis_Y6__c"), false);
				       }
					   else{
						 concatRes5 = '';  
					   }
				    }
                    if(concatRes5) resString = resString + concatRes5;
                      component.set("v.Row7Col2", resString);
                }
                if(component.get("v.objects.Template_Mchoice_Display__c")==true && component.get("v.objects.Non_Specialty_Grid__c")==true){
                    component.set("v.Row8Display",true);  
                    component.set("v.Row8Col1", "MAINTENANCE CHOICE "); 
                     //Added by Parvathi
                     var resString = '';
                    
                    var concatRes;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.MCHOICE_Y1_Percentage__c")!=null){
                        concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.MCHOICE_Y1_Percentage__c"), component.get("v.objects.Basis_Y1__c"), true);
                         }
						 else{
						 concatRes = '';  
					   }
					}else{
                        if(component.get("v.objects.MCHOICEY1__c")!=null){
                         concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.MCHOICEY1__c"), component.get("v.objects.Basis_Y1__c"), false);
                        }
						else{
						 concatRes = '';  
					   }
					}
                    
                    if(concatRes) resString = resString + concatRes;
                       
                    var concatRes1;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                       if(component.get("v.objects.MCHOICE_Y2_Percentage__c")!=null){
                       concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.MCHOICE_Y2_Percentage__c"), component.get("v.objects.Basis_Y2__c"), true);
                       }
					   else{
						 concatRes1 = '';  
					   }
					}else{
                        if(component.get("v.objects.MCHOICEY2__c")!=null){
                        concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.MCHOICEY2__c"), component.get("v.objects.Basis_Y2__c"), false);
                       }
					   else{
						 concatRes1 = '';  
					   }
					}
                    
                    if(concatRes1) resString = resString + concatRes1;
                    
                    var concatRes2;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                         if(component.get("v.objects.MCHOICE_Y3_Percentage__c")!=null){
                          concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.MCHOICE_Y3_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
                        }
						else{
						 concatRes2 = '';  
					   }
					}else{
                        if(component.get("v.objects.MCHOICEY3__c")!=null){
                        concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.MCHOICEY3__c"), component.get("v.objects.Basis_Y3__c"), false);
                        }
						else{
						 concatRes2 = '';  
					   }
					}
                      if(concatRes2) resString = resString + concatRes2;
                    
                    var concatRes3;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.MCHOICE_Y4_Percentage__c")!=null){
                         concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.MCHOICE_Y4_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
                        }
						else{
						 concatRes3 = '';  
					   }
					
					}else{
                       if(component.get("v.objects.MCHOICEY4__c")!=null){
                        concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.MCHOICEY4__c"), component.get("v.objects.Basis_Y4__c"), false);
                       }
					   else{
						 concatRes3 = '';  
					   }
					 }
                     if(concatRes3) resString = resString + concatRes3;
                    
                     var concatRes4;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.MCHOICE_Y5_Percentage__c")!=null){
                         concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.MCHOICE_Y5_Percentage__c"), component.get("v.objects.Basis_Y5__c"), true);
                        }
						else{
						 concatRes4= '';  
					   }
					}else{
                       if(component.get("v.objects.MCHOICEY5__c")!=null){
                        concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.MCHOICEY5__c"), component.get("v.objects.Basis_Y5__c"), false);
                      }
					  else{
						 concatRes4 = '';  
					   }
					
					}
                     if(concatRes4) resString = resString + concatRes4;
                    
                     var concatRes5;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.MCHOICE_Y6_Percentage__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.MCHOICE_Y6_Percentage__c"), component.get("v.objects.Basis_Y6__c"), true);
                      }
					  else{
						 concatRes5= '';  
					   }
					}else{
                       if(component.get("v.objects.MCHOICEY6__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.MCHOICEY6__c"), component.get("v.objects.Basis_Y6__c"), false);
                       }
					   else{
						 concatRes5= '';  
					   }
					
					}
                    if(concatRes5) resString = resString + concatRes5;
                   
                                      
                      component.set("v.Row8Col2", resString);

                }
                 
                if(component.get("v.objects.Template_SpecialtyatRetail_Display__c")==true){
                    component.set("v.Row9Display",true);  
                    component.set("v.Row9Col1", "SPECIALTY AT RETAIL"); 
                      //Added by Parvathi
                     var resString = '';
                    
                    var concatRes;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                       if(component.get("v.objects.SPECIALTY_RETAIL_Y1_Percentage__c")!=null){
                        concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.SPECIALTY_RETAIL_Y1_Percentage__c"), component.get("v.objects.Basis_Y1__c"), true);
				       }
					   else{
						 concatRes = '';  
					   }
					
					}else{
                        if(component.get("v.objects.SPECIALTY_RETAIL_Y1__c")!=null){
                         concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.SPECIALTY_RETAIL_Y1__c"), component.get("v.objects.Basis_Y1__c"), false);
				        }
						else{
						 concatRes = '';  
					   }
					}
                    
                    if(concatRes) resString = resString + concatRes;
                       
                    var concatRes1;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.SPECIALTY_RETAIL_Y2_Percentage__c")!=null){
                       concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.SPECIALTY_RETAIL_Y2_Percentage__c"), component.get("v.objects.Basis_Y2__c"), true);
                        }
						else{
						 concatRes1 = '';  
					   }
					}else{
                         if(component.get("v.objects.SPECIALTY_RETAIL_Y2__c")!=null){
                        concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.SPECIALTY_RETAIL_Y2__c"), component.get("v.objects.Basis_Y2__c"), false);
                         }
						 else{
						 concatRes1= '';  
					   }
					
					}
                    
                    if(concatRes1) resString = resString + concatRes1;
                    
                    var concatRes2;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                         if(component.get("v.objects.SPECIALTY_RETAIL_Y3_Percentage__c")!=null){
                          concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.SPECIALTY_RETAIL_Y3_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
                        }
						else{
						 concatRes2= '';  
					   }
					
					}else{
                        if(component.get("v.objects.SPECIALTY_RETAIL_Y3__c")!=null){
                        concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.SPECIALTY_RETAIL_Y3__c"), component.get("v.objects.Basis_Y3__c"), false);
                      }
					  else{
						 concatRes2 = '';  
					   }
					}
                      if(concatRes2) resString = resString + concatRes2;
                    
                    var concatRes3;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.SPECIALTY_RETAIL_Y4_Percentage__c")!=null){
                         concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.SPECIALTY_RETAIL_Y4_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
                        }
						else{
						 concatRes3 = '';  
					   }
					}else{
                       if(component.get("v.objects.SPECIALTY_RETAIL_Y4__c")!=null){
                        concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.SPECIALTY_RETAIL_Y4__c"), component.get("v.objects.Basis_Y4__c"), false);
                      }
					  else{
						 concatRes3= '';  
					   }
					
					}
                     if(concatRes3) resString = resString + concatRes3;
                    
                     var concatRes4;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                         if(component.get("v.objects.SPECIALTY_RETAIL_Y5_Percentage__c")!=null){
                         concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.SPECIALTY_RETAIL_Y5_Percentage__c"), component.get("v.objects.Basis_Y5__c"), true);
                        }
						else{
						 concatRes4 = '';  
					   }
					}else{
                        if(component.get("v.objects.SPECIALTY_RETAIL_Y5__c")!=null){
                        concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.SPECIALTY_RETAIL_Y5__c"), component.get("v.objects.Basis_Y5__c"), false);
                        }
						else{
						 concatRes4 = '';  
					   }
					}
                     if(concatRes4) resString = resString + concatRes4;
                    
                     var concatRes5;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.SPECIALTY_RETAIL_Y6_Percentage__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.SPECIALTY_RETAIL_Y6_Percentage__c"), component.get("v.objects.Basis_Y6__c"), true);
                        }
						else{
						 concatRes5 = '';  
					   }
					
					}else{
                       if(component.get("v.objects.SPECIALTY_RETAIL_Y6__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.SPECIALTY_RETAIL_Y6__c"), component.get("v.objects.Basis_Y6__c"), false);
                       }
					   else{
						 concatRes5= '';  
					   }
					}
                    if(concatRes5) resString = resString + concatRes5;
                   
                                      
                      component.set("v.Row9Col2", resString);

                       }
             
            /*  if(component.get("v.objects.Template_SpecialtyatCVS_Display__c")==true && component.get("v.objects.Non_Specialty_Grid__c")==true){ // This is Non-Speciality grid
                  
                    component.set("v.Row10Display",true);
                    component.set("v.Row10Col1", "SPECIALTY AT CVS HEALTH SPECIALTY"); 
                      //Added by Parvathi
                }*/
                
                
            }
       
           if(component.get("v.objects.Non_Specialty_Grid__c")==true && component.get("v.objects.PCD_Same_dollar_and_Percentage_Value__c")==false) 
                 
            {
                var cols = [
                {label: ''},
                {label: ''}
                ];
             
                component.set("v.tableCols", cols); 
                component.set("v.isNONSpecialtyGrid",true);
                 
                if(component.get("v.objects.Non_Specialty_Grid__c")==true){
                component.set("v.Col1",component.get("v.objects.Custom_Description__c")); 
                component.set("v.Col2",component.get("v.objects.Plan_Design__c")); 
                }
                 //Updated by Parvathi 3/27
                
                if(component.get("v.objects.Template_Retail_Display__c")==true && component.get("v.objects.Non_Specialty_Grid__c")==true){
                    
                    component.set("v.Row1Display", true);
                    component.set("v.Row1Col1", "RETAIL"); 
                     var resString = '';
                    // added by Parvathi
                    var concatRes;
                    if(component.get("v.objects.Percentage_Check__c")==true){
						if(component.get("v.objects.RETAIL_Y1_Percentage__c")!=null){
                        concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.RETAIL_Y1_Percentage__c"), component.get("v.objects.Basis_Y1__c"), true);
						}
						else{
							 concatRes =''; 
							
						}
                    }else{
                        if(component.get("v.objects.RETAIL_Y1__c")!=null){
                         concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.RETAIL_Y1__c"), component.get("v.objects.Basis_Y1__c"), false);
					    }
						else{
							 concatRes =''; 
						}
                    }
                    
                    if(concatRes) resString = resString + concatRes;
                       
                    var concatRes1;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                      if(component.get("v.objects.RETAIL_Y2_Percentage__c")!=null){
                       concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.RETAIL_Y2_Percentage__c"), component.get("v.objects.Basis_Y2__c"), true);
					  }
					  else{
							 concatRes1 =''; 
						}
					}else{
                       if(component.get("v.objects.RETAIL_Y2__c")!=null){
                        concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.RETAIL_Y2__c"), component.get("v.objects.Basis_Y2__c"), false);
                       } 
                       else{
							 concatRes1 =''; 
						}
					}
                    
                    if(concatRes1) resString = resString + concatRes1;
                   
                    var concatRes2;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.RETAIL_Y3_Percentage__c")!=null){
                          concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.RETAIL_Y3_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
						}
						else{
							 concatRes2 =''; 
						}
                    }else{
                       if(component.get("v.objects.RETAIL_Y3__c")!=null){
                        concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.RETAIL_Y3__c"), component.get("v.objects.Basis_Y3__c"), false);
					   }
					    else{
							 concatRes2 =''; 
						}
                    }
                      if(concatRes2) resString = resString + concatRes2;
                    
                    var concatRes3;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.RETAIL_Y4_Percentage__c")!=null){
                         concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.RETAIL_Y4_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
						}
						else{
							 concatRes3=''; 
						}
                    }else{
                       if(component.get("v.objects.RETAIL_Y4__c")!=null){
                        concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.RETAIL_Y4__c"), component.get("v.objects.Basis_Y4__c"), false);
					   }
					   else{
							 concatRes3=''; 
						}
					}
                     if(concatRes3) resString = resString + concatRes3;
                    
                     var concatRes4;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                         if(component.get("v.objects.RETAIL_Y5_Percentage__c")!=null){
                         concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.RETAIL_Y5_Percentage__c"), component.get("v.objects.Basis_Y5__c"), true);
						 }
						 else{
							 concatRes4=''; 
						}
                    }else{
                        if(component.get("v.objects.RETAIL_Y5__c")!=null){
                            concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.RETAIL_Y5__c"), component.get("v.objects.Basis_Y5__c"), false);
						}
						else{
							 concatRes4=''; 
						}
					}
                     if(concatRes4) resString = resString + concatRes4;
                    
                     var concatRes5;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.RETAIL_Y6_Percentage__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.RETAIL_Y6_Percentage__c"), component.get("v.objects.Basis_Y6__c"), true);
						}
						else{
							 concatRes5=''; 
						}
                    }else{
                        if(component.get("v.objects.RETAIL_Y6__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.RETAIL_Y6__c"), component.get("v.objects.Basis_Y6__c"), false);
                        }
						else{
							 concatRes5=''; 
						}
					}
                    if(concatRes5) resString = resString + concatRes5;
                   
                                      
                      component.set("v.Row1Col2", resString);
                } 

                     if(component.get("v.objects.Template_Retail30_Display__c")==true && component.get("v.objects.Non_Specialty_Grid__c")==true){
                    component.set("v.Row2Display", true);
                    component.set("v.Row2Col1", "RETAIL 30");
                     var resString = '';
                    // added by Parvathi
                    var concatRes;
                    if(component.get("v.objects.Percentage_Check__c")==true){
						if(component.get("v.objects.RETAIL30_Y1_Percentage__c")!=null){
                        concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.RETAIL30_Y1_Percentage__c"), component.get("v.objects.Basis_Y1__c"), true);
						}
						else{
						concatRes ='';
						}
                    }else{
                         if(component.get("v.objects.RETAIL30_Y1__c")!=null){
                         concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.RETAIL30_Y1__c"), component.get("v.objects.Basis_Y1__c"), false);
						 }
						 else{
							 concatRes = '';
						 }
						 
                    }
                    
                    if(concatRes) resString = resString + concatRes;
                       
                    var concatRes1;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                      if(component.get("v.objects.RETAIL30_Y2_Percentage__c")!=null){
                          concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.RETAIL30_Y2_Percentage__c"), component.get("v.objects.Basis_Y2__c"), true);
					  }
					  else{
						  concatRes1 =''; 
						  
					  }
                    }else{
						 if(component.get("v.objects.RETAIL30_Y2__c")!=null){
                        concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.RETAIL30_Y2__c"), component.get("v.objects.Basis_Y2__c"), false);
                         }
						else{
						  concatRes1 =''; 
					    }
					}
                    
                    if(concatRes1) resString = resString + concatRes1;
                    
                    var concatRes2;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                         if(component.get("v.objects.RETAIL30_Y3_Percentage__c")!=null){
                          concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.RETAIL30_Y3_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
						 }
						 else{
							concatRes2 = ''; 
						 }
                    }else{
                        if(component.get("v.objects.RETAIL30_Y3__c")!=null){
                        concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.RETAIL30_Y3__c"), component.get("v.objects.Basis_Y3__c"), false);
						}
						else{
							concatRes2 = ''; 
						 }
					}
                      if(concatRes2) resString = resString + concatRes2;
                    
                    var concatRes3;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.RETAIL30_Y4_Percentage__c")!=null){
                         concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.RETAIL30_Y4_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
						}
						else{
							concatRes3= ''; 
						 }
					}else{
                       if(component.get("v.objects.RETAIL30_Y4__c")!=null){
                        concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.RETAIL30_Y4__c"), component.get("v.objects.Basis_Y4__c"), false);
					   }
					   else{
							concatRes3 = ''; 
						 }
					}
                     if(concatRes3) resString = resString + concatRes3;
                    
                     var concatRes4;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                         if(component.get("v.objects.RETAIL30_Y5_Percentage__c")!=null){
                         concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.RETAIL30_Y5_Percentage__c"), component.get("v.objects.Basis_Y5__c"), true);
						 }
						 else{
							concatRes4 = ''; 
						 }
                    }else{
                        if(component.get("v.objects.RETAIL30_Y5__c")!=null){
                        concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.RETAIL30_Y5__c"), component.get("v.objects.Basis_Y5__c"), false);
						}
						else{
							concatRes4 = ''; 
						 }
						
					}
                     if(concatRes4) resString = resString + concatRes4;
                    
                     var concatRes5;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                         if(component.get("v.objects.RETAIL30_Y6_Percentage__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.RETAIL30_Y6_Percentage__c"), component.get("v.objects.Basis_Y6__c"), true);
						 }
						 else{
							 concatRes5 ='';
						 }
					}else{
                       if(component.get("v.objects.RETAIL30_Y6__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.RETAIL30_Y6__c"), component.get("v.objects.Basis_Y6__c"), false);
                       }
					   else{
							 concatRes5 ='';
						 }
					}
                    if(concatRes5) resString = resString + concatRes5;
                   
                                      
                      component.set("v.Row2Col2", resString);
                  
                }
                if(component.get("v.objects.Template_Retail90_Display__c")==true && component.get("v.objects.Non_Specialty_Grid__c")==true){
                    component.set("v.Row3Display", true);
                    component.set("v.Row3Col1", "RETAIL 90"); 
                     var resString = '';
                    // added by Parvathi
                    var concatRes;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                       if(component.get("v.objects.RETAIL90_Y1_Percentage__c")!=null){
                        concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.RETAIL90_Y1_Percentage__c"), component.get("v.objects.Basis_Y1__c"), true);
                       }
					   else{
						 concatRes = '';  
					   }
					}else{
                        if(component.get("v.objects.RETAIL90_Y1__c")!=null){
                         concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.RETAIL90_Y1__c"), component.get("v.objects.Basis_Y1__c"), false);
						}
						else{
						 concatRes = '';  
					   }
                    }
                    
                    if(concatRes) resString = resString + concatRes;
                       
                    var concatRes1;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.RETAIL90_Y2_Percentage__c")!=null){
                       concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.RETAIL90_Y2_Percentage__c"), component.get("v.objects.Basis_Y2__c"), true);
						}
						else{
						 concatRes1 = '';  
					   }
					}else{
                        if(component.get("v.objects.RETAIL90_Y2__c")!=null){
                        concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.RETAIL90_Y2__c"), component.get("v.objects.Basis_Y2__c"), false);
                        }
						else{
						 concatRes1 = '';  
					   }
					}
                    
                    if(concatRes1) resString = resString + concatRes1;
                    
                    var concatRes2;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.RETAIL90_Y3_Percentage__c")!=null){
                          concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.RETAIL90_Y3_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
                        }
						else{
						 concatRes2 = '';  
					   }
					}else{
                       if(component.get("v.objects.RETAIL90_Y3__c")!=null){
                        concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.RETAIL90_Y3__c"), component.get("v.objects.Basis_Y3__c"), false);
                        }
						else{
						 concatRes2 = '';  
					   }
					}
                      if(concatRes2) resString = resString + concatRes2;
                    
                    var concatRes3;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.RETAIL90_Y4_Percentage__c")!=null){
                         concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.RETAIL90_Y4_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
                        }
						else{
						 concatRes3 = '';  
					   }
					}else{
                        if(component.get("v.objects.RETAIL90_Y4__c")!=null){
                        concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.RETAIL90_Y4__c"), component.get("v.objects.Basis_Y4__c"), false);
                        }
						else{
						 concatRes3 = '';  
					   }
					}
                     if(concatRes3) resString = resString + concatRes3;
                    
                     var concatRes4;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                         if(component.get("v.objects.RETAIL90_Y5_Percentage__c")!=null){
                         concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.RETAIL90_Y5_Percentage__c"), component.get("v.objects.Basis_Y5__c"), true);
                         }
						 else{
						 concatRes4 = '';  
					     }
					}else{
                       if(component.get("v.objects.RETAIL90Y5__c")!=null){
                        concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.RETAIL90Y5__c"), component.get("v.objects.Basis_Y5__c"), false);
                        }
						else{
						 concatRes4 = '';  
					   }
					}
                     if(concatRes4) resString = resString + concatRes4;
                    
                     var concatRes5;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                         if(component.get("v.objects.RETAIL90_Y6_Percentage__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.RETAIL90_Y6_Percentage__c"), component.get("v.objects.Basis_Y6__c"), true);
                         }
						 else{
						 concatRes5 = '';  
					   }
					}else{
                       if(component.get("v.objects.RETAIL90Y6__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.RETAIL90Y6__c"), component.get("v.objects.Basis_Y6__c"), false);
                        }
						else{
						 concatRes5 = '';  
					   }
					}
                    if(concatRes5) resString = resString + concatRes5;
                   
                                      
                      component.set("v.Row3Col2", resString);
                
                }
                 
                 //Updated by Parvathi
                if(component.get("v.objects.Template_ClientOwned_Display__c")==true && component.get("v.objects.Non_Specialty_Grid__c")==true){
                    component.set("v.Row4Display", true);
                    component.set("v.Row4Col1", "CLIENT OWNED"); 
                    var resString = '';
                    // added by Parvathi
                    var concatRes;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                       if(component.get("v.objects.CLIENTOWNED_Y1_Percentage__c")!=null){
                        concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.CLIENTOWNED_Y1_Percentage__c"), component.get("v.objects.Basis_Y1__c"), true);
                        }
						else{
						 concatRes = '';  
					   }
					
					}else{
                        if(component.get("v.objects.CLIENT_OWNED_Y1__c")!=null){
                         concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.CLIENT_OWNED_Y1__c"), component.get("v.objects.Basis_Y1__c"), false);
                        }
						else{
						 concatRes = '';  
					   }
					}
                    
                    if(concatRes) resString = resString + concatRes;
                       
                    var concatRes1;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                      if(component.get("v.objects.CLIENTOWNED_Y2_Percentage__c")!=null){
                       concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.CLIENTOWNED_Y2_Percentage__c"), component.get("v.objects.Basis_Y2__c"), true);
                      }
					  else{
						 concatRes1 = '';  
					   }
					}else{
                       if(component.get("v.objects.CLIENT_OWNED_Y2__c")!=null){
                        concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.CLIENT_OWNED_Y2__c"), component.get("v.objects.Basis_Y2__c"), false);
                       }
					   else{
						 concatRes1 = '';  
					   }
					}
                    
                    if(concatRes1) resString = resString + concatRes1;
                    
                    var concatRes2;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.CLIENTOWNED_Y3_Percentage__c")!=null){
                          concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.CLIENTOWNED_Y3_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
                        }
						else{
						 concatRes2 = '';  
					   }
					}else{
                        if(component.get("v.objects.CLIENT_OWNED_Y3__c")!=null){
                        concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.CLIENT_OWNED_Y3__c"), component.get("v.objects.Basis_Y3__c"), false);
                        }
						else{
						 concatRes2 = '';  
					   }
					}
                      if(concatRes2) resString = resString + concatRes2;
                    
                    var concatRes3;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.CLIENTOWNED_Y4_Percentage__c")!=null){
                         concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.CLIENTOWNED_Y4_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
                        }
						else{
						 concatRes3 = '';  
					   }
					}else{
                       if(component.get("v.objects.CLIENT_OWNED_Y4__c")!=null){
                        concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.CLIENT_OWNED_Y4__c"), component.get("v.objects.Basis_Y4__c"), false);
                       }
					   else{
						 concatRes3= '';  
					   }
					
					}
                     if(concatRes3) resString = resString + concatRes3;
                    
                     var concatRes4;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                         if(component.get("v.objects.CLIENTOWNED_Y5_Percentage__c")!=null){
                         concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.CLIENTOWNED_Y5_Percentage__c"), component.get("v.objects.Basis_Y5__c"), true);
                        }
						else{
						 concatRes4= '';  
					   }
					}else{
                          if(component.get("v.objects.CLIENT_OWNED_Y5__c")!=null){
                        concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.CLIENT_OWNED_Y5__c"), component.get("v.objects.Basis_Y5__c"), false);
                         }
						 else{
						 concatRes4 = '';  
					   }
					
					}
                     if(concatRes4) resString = resString + concatRes4;
                    
                     var concatRes5;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                          if(component.get("v.objects.CLIENTOWNED_Y6_Percentage__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.CLIENTOWNED_Y6_Percentage__c"), component.get("v.objects.Basis_Y6__c"), true);
                        }
						else{
						 concatRes5 = '';  
					   }
					}else{
                        if(component.get("v.objects.CLIENT_OWNED_Y6__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.CLIENT_OWNED_Y6__c"), component.get("v.objects.Basis_Y6__c"), false);
                        }
						else{
						 concatRes5 = '';  
					   }
					
					}
                    if(concatRes5) resString = resString + concatRes5;
                   
                                      
                      component.set("v.Row4Col2", resString);
                  
                  
                }
                if(component.get("v.objects.Template_ClientOwned30_Display__c")==true && component.get("v.objects.Non_Specialty_Grid__c")==true){
                    component.set("v.Row5Display", true);
                    component.set("v.Row5Col1", "CLIENT OWNED 30"); 
                    
                    var resString = '';
                    // added by Parvathi
                    var concatRes;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                       if(component.get("v.objects.CLIENTOWNED30_Y1_Percentage__c")!=null){
                        concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.CLIENTOWNED30_Y1_Percentage__c"), component.get("v.objects.Basis_Y1__c"), true);
                        }
						else{
						 concatRes = '';  
					   }
					}else{
                       if(component.get("v.objects.CLIENT_OWNED30_Y1__c")!=null){
                         concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.CLIENT_OWNED30_Y1__c"), component.get("v.objects.Basis_Y1__c"), false);
                        }
						else{
						 concatRes= '';  
					   }
					}
                    
                    if(concatRes) resString = resString + concatRes;
                       
                    var concatRes1;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                       if(component.get("v.objects.CLIENTOWNED30_Y2_Percentage__c")!=null){
                       concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.CLIENTOWNED30_Y2_Percentage__c"), component.get("v.objects.Basis_Y2__c"), true);
                        }
						else{
						 concatRes1 = '';  
					   }
					
					}else{
                        if(component.get("v.objects.CLIENT_OWNED30_Y2__c")!=null){
                        concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.CLIENT_OWNED30_Y2__c"), component.get("v.objects.Basis_Y2__c"), false);
                        }
						else{
						 concatRes1 = '';  
					   }
					
					}
                    
                    if(concatRes1) resString = resString + concatRes1;
                    
                    var concatRes2;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.CLIENTOWNED30_Y3_Percentage__c")!=null){
                          concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.CLIENTOWNED30_Y3_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
                        }
						else{
						 concatRes2 = '';  
					   }
					
					}else{
                       if(component.get("v.objects.CLIENT_OWNED30_Y3__c")!=null){
                        concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.CLIENT_OWNED30_Y3__c"), component.get("v.objects.Basis_Y3__c"), false);
                       }
					   else{
						 concatRes2 = '';  
					   }
					
					}
                      if(concatRes2) resString = resString + concatRes2;
                    
                    var concatRes3;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                          if(component.get("v.objects.CLIENTOWNED30_Y4_Percentage__c")!=null){
                         concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.CLIENTOWNED30_Y4_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
                        }
						else{
						 concatRes3= '';  
					   }
					
					}else{
                         if(component.get("v.objects.CLIENT_OWNED30_Y4__c")!=null){
                        concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.CLIENT_OWNED30_Y4__c"), component.get("v.objects.Basis_Y4__c"), false);
                        }
						else{
						 concatRes3 = '';  
					   }
					
					}
                     if(concatRes3) resString = resString + concatRes3;
                    
                     var concatRes4;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                         if(component.get("v.objects.CLIENTOWNED30_Y5_Percentage__c")!=null){
                         concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.CLIENTOWNED30_Y5_Percentage__c"), component.get("v.objects.Basis_Y5__c"), true);
                         }
						 else{
						 concatRes4 = '';  
					     }
					
					}else{
                        if(component.get("v.objects.CLIENT_OWNED30_Y5__c")!=null){
                        concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.CLIENT_OWNED30_Y5__c"), component.get("v.objects.Basis_Y5__c"), false);
                        }
						else{
						 concatRes4 = '';  
					   }
					}
                     if(concatRes4) resString = resString + concatRes4;
                    
                     var concatRes5;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                         if(component.get("v.objects.CLIENTOWNED30_Y6_Percentage__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.CLIENTOWNED30_Y6_Percentage__c"), component.get("v.objects.Basis_Y6__c"), true);
                        }
						else{
						 concatRes5 = '';  
					     }
					
					}else{
                        if(component.get("v.objects.CLIENT_OWNED30_Y6__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.CLIENT_OWNED30_Y6__c"), component.get("v.objects.Basis_Y6__c"), false);
                        }
						else{
						 concatRes5= '';  
					    }
					}
                    if(concatRes5) resString = resString + concatRes5;
                   
                                      
                      component.set("v.Row5Col2", resString);
             
                }
                if(component.get("v.objects.Template_ClientOwned90_Display__c")==true && component.get("v.objects.Non_Specialty_Grid__c")==true){
                    component.set("v.Row6Display", true);
                    component.set("v.Row6Col1", "CLIENT OWNED 90"); 
                    
                    var resString = '';
                    // added by Parvathi
                    var concatRes;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                       if(component.get("v.objects.CLIENTOWNED90_Y1_Percentage__c")!=null){
                        concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.CLIENTOWNED90_Y1_Percentage__c"), component.get("v.objects.Basis_Y1__c"), true);
                        }
						else{
						 concatRes= '';  
					   }
					}else{
                         if(component.get("v.objects.CLIENT_OWNED90_Y1__c")!=null){
                         concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.CLIENT_OWNED90_Y1__c"), component.get("v.objects.Basis_Y1__c"), false);
				        }
						else{
						 concatRes= '';  
					   }
					}
                    
                    if(concatRes) resString = resString + concatRes;
                       
                    var concatRes1;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                       if(component.get("v.objects.CLIENTOWNED90_Y2_Percentage__c")!=null){
                       concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.CLIENTOWNED90_Y2_Percentage__c"), component.get("v.objects.Basis_Y2__c"), true);
                       }
					   else{
						 concatRes1 = '';  
					   }
					
					}else{
                        if(component.get("v.objects.CLIENT_OWNED90_Y2__c")!=null){
                        concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.CLIENT_OWNED90_Y2__c"), component.get("v.objects.Basis_Y2__c"), false);
                        }
						else{
						 concatRes1 = '';  
					   }
					}
                    
                    if(concatRes1) resString = resString + concatRes1;
                    
                    var concatRes2;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.CLIENTOWNED90_Y3_Percentage__c")!=null){
                          concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.CLIENTOWNED90_Y3_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
                        }
						else{
						 concatRes2 = '';  
					   }
					
					}else{
                       if(component.get("v.objects.CLIENT_OWNED90_Y3__c")!=null){
                        concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.CLIENT_OWNED90_Y3__c"), component.get("v.objects.Basis_Y3__c"), false);
                       }
					   else{
						 concatRes2 = '';  
					   }
					}
                      if(concatRes2) resString = resString + concatRes2;
                    
                    var concatRes3;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                         if(component.get("v.objects.CLIENTOWNED90_Y4_Percentage__c")!=null){
                         concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.CLIENTOWNED90_Y4_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
                        }
						else{
						 concatRes3 = '';  
					   }
					
					}else{
                        if(component.get("v.objects.CLIENT_OWNED90_Y4__c")!=null){
                        concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.CLIENT_OWNED90_Y4__c"), component.get("v.objects.Basis_Y4__c"), false);
                        }
						else{
						 concatRes3 = '';  
					   }
					}
                     if(concatRes3) resString = resString + concatRes3;
                    
                     var concatRes4;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.CLIENTOWNED90_Y5_Percentage__c")!=null){
                         concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.CLIENTOWNED90_Y5_Percentage__c"), component.get("v.objects.Basis_Y5__c"), true);
                        }
						else{
						 concatRes4 = '';  
					   }
					}else{
                       if(component.get("v.objects.CLIENT_OWNED90_Y5__c")!=null){
                        concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.CLIENT_OWNED90_Y5__c"), component.get("v.objects.Basis_Y5__c"), false);
                        }
						else{
						 concatRes4 = '';  
					   }
					}
                     if(concatRes4) resString = resString + concatRes4;
                    
                     var concatRes5;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.CLIENTOWNED90_Y6_Percentage__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.CLIENTOWNED90_Y6_Percentage__c"), component.get("v.objects.Basis_Y6__c"), true);
                        }
						else{
						 concatRes5 = '';  
					   }
					
					}else{
                         if(component.get("v.objects.CLIENT_OWNED90_Y6__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.CLIENT_OWNED90_Y6__c"), component.get("v.objects.Basis_Y6__c"), false);
				       }
					   else{
						 concatRes5= '';  
					   }
					
					}
                    if(concatRes5) resString = resString + concatRes5;
                   
                                      
                      component.set("v.Row6Col2", resString);
                  
               
                }
                if(component.get("v.objects.Template_Mail_Display__c")==true && component.get("v.objects.Non_Specialty_Grid__c")==true){
                    component.set("v.Row7Display", true);
                    component.set("v.Row7Col1",component.get("v.objects.Template_Mail_Label__c")); 
                    //Added by Parvathi
                     var resString = '';
                    
                    var concatRes;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                       if(component.get("v.objects.MAIL_Y1_Percentage__c")!=null){
                        concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.MAIL_Y1_Percentage__c"), component.get("v.objects.Basis_Y1__c"), true);
                        }
						else{
						 concatRes= '';  
					   }
					}else{
                        if(component.get("v.objects.MAILY1__c")!=null){
                         concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.MAILY1__c"), component.get("v.objects.Basis_Y1__c"), false);
                        }
						else{
						 concatRes= '';  
					   }
					
					}
                    
                    if(concatRes) resString = resString + concatRes;
                       
                    var concatRes1;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                       if(component.get("v.objects.MAIL_Y2_Percentage__c")!=null){
                       concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.MAIL_Y2_Percentage__c"), component.get("v.objects.Basis_Y2__c"), true);
                       }
					   else{
						 concatRes1= '';  
					   }
					
					}else{
                        if(component.get("v.objects.MAILY2__c")!=null){
                        concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.MAILY2__c"), component.get("v.objects.Basis_Y2__c"), false);
                        }
						else{
						 concatRes1 = '';  
					   }
					}
                    
                    if(concatRes1) resString = resString + concatRes1;
                    
                    var concatRes2;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.MAIL_Y3_Percentage__c")!=null){
                          concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.MAIL_Y3_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
                        }
						else{
						 concatRes2 = '';  
					   }
					}else{
                       if(component.get("v.objects.MAILY3__c")!=null){
                        concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.MAILY3__c"), component.get("v.objects.Basis_Y3__c"), false);
                       }
					   else{
						 concatRes2 = '';  
					   }
					}
                      if(concatRes2) resString = resString + concatRes2;
                    
                    var concatRes3;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                         if(component.get("v.objects.MAIL_Y4_Percentage__c")!=null){
                         concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.MAIL_Y4_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
                        }
						else{
						 concatRes3 = '';  
					   }
					}else{
                        if(component.get("v.objects.MAILY4__c")!=null){
                        concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.MAILY4__c"), component.get("v.objects.Basis_Y4__c"), false);
                        }
						else{
						 concatRes3 = '';  
					   }
					}
                     if(concatRes3) resString = resString + concatRes3;
                    
                     var concatRes4;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.MAIL_Y5_Percentage__c")!=null){
                         concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.MAIL_Y5_Percentage__c"), component.get("v.objects.Basis_Y5__c"), true);
				        }
						else{
						 concatRes4 = '';  
					   }
						
					}else{
                       if(component.get("v.objects.MAILY5__c")!=null){
                        concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.MAILY5__c"), component.get("v.objects.Basis_Y5__c"), false);
			           }
					   else{
						 concatRes4 = '';  
					   }
					}
                     if(concatRes4) resString = resString + concatRes4;
                    
                     var concatRes5;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.MAIL_Y6_Percentage__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.MAIL_Y6_Percentage__c"), component.get("v.objects.Basis_Y6__c"), true);
                        }
						else{
						 concatRes5 = '';  
					   }
					}else{
                        if(component.get("v.objects.MAILY6__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.MAILY6__c"), component.get("v.objects.Basis_Y6__c"), false);
				       }
					   else{
						 concatRes5 = '';  
					   }
				    }
                    if(concatRes5) resString = resString + concatRes5;
                      component.set("v.Row7Col2", resString);
                }
                if(component.get("v.objects.Template_Mchoice_Display__c")==true && component.get("v.objects.Non_Specialty_Grid__c")==true){
                    component.set("v.Row8Display",true);  
                    component.set("v.Row8Col1", "MAINTENANCE CHOICE "); 
                     //Added by Parvathi
                     var resString = '';
                    
                    var concatRes;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.MCHOICE_Y1_Percentage__c")!=null){
                        concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.MCHOICE_Y1_Percentage__c"), component.get("v.objects.Basis_Y1__c"), true);
                         }
						 else{
						 concatRes = '';  
					   }
					}else{
                        if(component.get("v.objects.MCHOICEY1__c")!=null){
                         concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.MCHOICEY1__c"), component.get("v.objects.Basis_Y1__c"), false);
                        }
						else{
						 concatRes = '';  
					   }
					}
                    
                    if(concatRes) resString = resString + concatRes;
                       
                    var concatRes1;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                       if(component.get("v.objects.MCHOICE_Y2_Percentage__c")!=null){
                       concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.MCHOICE_Y2_Percentage__c"), component.get("v.objects.Basis_Y2__c"), true);
                       }
					   else{
						 concatRes1 = '';  
					   }
					}else{
                        if(component.get("v.objects.MCHOICEY2__c")!=null){
                        concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.MCHOICEY2__c"), component.get("v.objects.Basis_Y2__c"), false);
                       }
					   else{
						 concatRes1 = '';  
					   }
					}
                    
                    if(concatRes1) resString = resString + concatRes1;
                    
                    var concatRes2;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                         if(component.get("v.objects.MCHOICE_Y3_Percentage__c")!=null){
                          concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.MCHOICE_Y3_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
                        }
						else{
						 concatRes2 = '';  
					   }
					}else{
                        if(component.get("v.objects.MCHOICEY3__c")!=null){
                        concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.MCHOICEY3__c"), component.get("v.objects.Basis_Y3__c"), false);
                        }
						else{
						 concatRes2 = '';  
					   }
					}
                      if(concatRes2) resString = resString + concatRes2;
                    
                    var concatRes3;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.MCHOICE_Y4_Percentage__c")!=null){
                         concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.MCHOICE_Y4_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
                        }
						else{
						 concatRes3 = '';  
					   }
					
					}else{
                       if(component.get("v.objects.MCHOICEY4__c")!=null){
                        concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.MCHOICEY4__c"), component.get("v.objects.Basis_Y4__c"), false);
                       }
					   else{
						 concatRes3 = '';  
					   }
					 }
                     if(concatRes3) resString = resString + concatRes3;
                    
                     var concatRes4;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.MCHOICE_Y5_Percentage__c")!=null){
                         concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.MCHOICE_Y5_Percentage__c"), component.get("v.objects.Basis_Y5__c"), true);
                        }
						else{
						 concatRes4= '';  
					   }
					}else{
                       if(component.get("v.objects.MCHOICEY5__c")!=null){
                        concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.MCHOICEY5__c"), component.get("v.objects.Basis_Y5__c"), false);
                      }
					  else{
						 concatRes4 = '';  
					   }
					
					}
                     if(concatRes4) resString = resString + concatRes4;
                    
                     var concatRes5;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.MCHOICE_Y6_Percentage__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.MCHOICE_Y6_Percentage__c"), component.get("v.objects.Basis_Y6__c"), true);
                      }
					  else{
						 concatRes5= '';  
					   }
					}else{
                       if(component.get("v.objects.MCHOICEY6__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.MCHOICEY6__c"), component.get("v.objects.Basis_Y6__c"), false);
                       }
					   else{
						 concatRes5= '';  
					   }
					
					}
                    if(concatRes5) resString = resString + concatRes5;
                   
                                      
                      component.set("v.Row8Col2", resString);

                }
                 
                if(component.get("v.objects.Template_SpecialtyatRetail_Display__c")==true){
                    component.set("v.Row9Display",true);  
                    component.set("v.Row9Col1", "SPECIALTY AT RETAIL"); 
                      //Added by Parvathi
                     var resString = '';
                    
                    var concatRes;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                       if(component.get("v.objects.SPECIALTY_RETAIL_Y1_Percentage__c")!=null){
                        concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.SPECIALTY_RETAIL_Y1_Percentage__c"), component.get("v.objects.Basis_Y1__c"), true);
				       }
					   else{
						 concatRes = '';  
					   }
					
					}else{
                        if(component.get("v.objects.SPECIALTY_RETAIL_Y1__c")!=null){
                         concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.SPECIALTY_RETAIL_Y1__c"), component.get("v.objects.Basis_Y1__c"), false);
				        }
						else{
						 concatRes = '';  
					   }
					}
                    
                    if(concatRes) resString = resString + concatRes;
                       
                    var concatRes1;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.SPECIALTY_RETAIL_Y2_Percentage__c")!=null){
                       concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.SPECIALTY_RETAIL_Y2_Percentage__c"), component.get("v.objects.Basis_Y2__c"), true);
                        }
						else{
						 concatRes1 = '';  
					   }
					}else{
                         if(component.get("v.objects.SPECIALTY_RETAIL_Y2__c")!=null){
                        concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.SPECIALTY_RETAIL_Y2__c"), component.get("v.objects.Basis_Y2__c"), false);
                         }
						 else{
						 concatRes1= '';  
					   }
					
					}
                    
                    if(concatRes1) resString = resString + concatRes1;
                    
                    var concatRes2;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                         if(component.get("v.objects.SPECIALTY_RETAIL_Y3_Percentage__c")!=null){
                          concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.SPECIALTY_RETAIL_Y3_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
                        }
						else{
						 concatRes2= '';  
					   }
					
					}else{
                        if(component.get("v.objects.SPECIALTY_RETAIL_Y3__c")!=null){
                        concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.SPECIALTY_RETAIL_Y3__c"), component.get("v.objects.Basis_Y3__c"), false);
                      }
					  else{
						 concatRes2 = '';  
					   }
					}
                      if(concatRes2) resString = resString + concatRes2;
                    
                    var concatRes3;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.SPECIALTY_RETAIL_Y4_Percentage__c")!=null){
                         concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.SPECIALTY_RETAIL_Y4_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
                        }
						else{
						 concatRes3 = '';  
					   }
					}else{
                       if(component.get("v.objects.SPECIALTY_RETAIL_Y4__c")!=null){
                        concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.SPECIALTY_RETAIL_Y4__c"), component.get("v.objects.Basis_Y4__c"), false);
                      }
					  else{
						 concatRes3= '';  
					   }
					
					}
                     if(concatRes3) resString = resString + concatRes3;
                    
                     var concatRes4;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                         if(component.get("v.objects.SPECIALTY_RETAIL_Y5_Percentage__c")!=null){
                         concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.SPECIALTY_RETAIL_Y5_Percentage__c"), component.get("v.objects.Basis_Y5__c"), true);
                        }
						else{
						 concatRes4 = '';  
					   }
					}else{
                        if(component.get("v.objects.SPECIALTY_RETAIL_Y5__c")!=null){
                        concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.SPECIALTY_RETAIL_Y5__c"), component.get("v.objects.Basis_Y5__c"), false);
                        }
						else{
						 concatRes4 = '';  
					   }
					}
                     if(concatRes4) resString = resString + concatRes4;
                    
                     var concatRes5;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.SPECIALTY_RETAIL_Y6_Percentage__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.SPECIALTY_RETAIL_Y6_Percentage__c"), component.get("v.objects.Basis_Y6__c"), true);
                        }
						else{
						 concatRes5 = '';  
					   }
					
					}else{
                       if(component.get("v.objects.SPECIALTY_RETAIL_Y6__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.SPECIALTY_RETAIL_Y6__c"), component.get("v.objects.Basis_Y6__c"), false);
                       }
					   else{
						 concatRes5= '';  
					   }
					}
                    if(concatRes5) resString = resString + concatRes5;
                   
                                      
                      component.set("v.Row9Col2", resString);

                       }
             
            /*  if(component.get("v.objects.Template_SpecialtyatCVS_Display__c")==true && component.get("v.objects.Non_Specialty_Grid__c")==true){ // This is Non-Speciality grid
                  
                    component.set("v.Row10Display",true);
                    component.set("v.Row10Col1", "SPECIALTY AT CVS HEALTH SPECIALTY"); 
                      //Added by Parvathi
                }*/
                
                
                    //component.set("v.Row9Col2",component.get("v.objects.Template_SpecialtyatRetail_Text__c"));
        }
                                 
            if(component.get("v.objects.Specialty_Grid__c")==true)
            {
                var cols = [
                {label: ''},
                {label: ''}
                ];
                component.set("v.isNONSpecialtyGrid",false); 
                component.set("v.isNONSpecialtyGrid",false); 
                component.set("v.tableCols",cols); 
                component.set("v.Col1", component.get("v.objects.Specialty_Display_Name__c"));
                component.set("v.Col2", "");
                
                if(component.get("v.objects.Template_SpecialtyatCVS_Display__c" )==true && component.get("v.objects.Specialty_Grid__c")==true){
                component.set("v.Row1Display", true);
                component.set("v.Row1Col1", "SPECIALTY AT CVS HEALTH SPECIALTY"); 
                   //Added by Parvathi
                     var resString = '';
                   
                    var concatRes;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.SPECIALTY_Y1_Percentage__c")!=null){
                        concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.SPECIALTY_Y1_Percentage__c"), component.get("v.objects.Basis_Y1__c"), true);
                    }}else{
                         if(component.get("v.objects.SPECIALTYY1__c")!=null){
                         concatRes = helper.getConcatString(component.get("v.objects.Plan_Year_Y1__c"), component.get("v.objects.SPECIALTYY1__c"), component.get("v.objects.Basis_Y1__c"), false);
                    }}
                    
                    if(concatRes) resString = resString + concatRes;
                       
                    var concatRes1;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                       if(component.get("v.objects.SPECIALTY_Y2_Percentage__c")!=null){
                       concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.SPECIALTY_Y2_Percentage__c"), component.get("v.objects.Basis_Y2__c"), true);
                    }}else{
                        if(component.get("v.objects.SPECIALTYY2__c")!=null){
                        concatRes1 = helper.getConcatString(component.get("v.objects.Plan_Year_Y2__c"), component.get("v.objects.SPECIALTYY2__c"), component.get("v.objects.Basis_Y2__c"), false);
                    }}
                    
                    if(concatRes1) resString = resString + concatRes1;
                    
                    var concatRes2;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                         if(component.get("v.objects.SPECIALTY_Y3_Percentage__c")!=null){
                          concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.SPECIALTY_Y3_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
                    }}else{
                        if(component.get("v.objects.SPECIALTY_Y3__c")!=null){
                        concatRes2 = helper.getConcatString(component.get("v.objects.Plan_Year_Y3__c"), component.get("v.objects.SPECIALTY_Y3__c"), component.get("v.objects.Basis_Y3__c"), false);
                    }}
                      if(concatRes2) resString = resString + concatRes2;
                    
                    var concatRes3;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                         if(component.get("v.objects.SPECIALTY_Y4_Percentage__c")!=null){
                         concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.SPECIALTY_Y4_Percentage__c"), component.get("v.objects.Basis_Y3__c"), true);
                    }}else{
                        if(component.get("v.objects.SPECIALTY_Y4__c")!=null){
                        concatRes3 = helper.getConcatString(component.get("v.objects.Plan_Year_Y4__c"), component.get("v.objects.SPECIALTY_Y4__c"), component.get("v.objects.Basis_Y4__c"), false);
                    }}
                     if(concatRes3) resString = resString + concatRes3;
                    
                     var concatRes4;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                        if(component.get("v.objects.SPECIALTY_Y5_Percentage__c")!=null){
                         concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.SPECIALTY_Y5_Percentage__c"), component.get("v.objects.Basis_Y5__c"), true);
                    }}else{
                       if(component.get("v.objects.SPECIALTY_Y5__c")!=null){
                        concatRes4 = helper.getConcatString(component.get("v.objects.Plan_Year_Y5__c"), component.get("v.objects.SPECIALTY_Y5__c"), component.get("v.objects.Basis_Y5__c"), false);
                    }}
                     if(concatRes4) resString = resString + concatRes4;
                    
                     var concatRes5;
                    if(component.get("v.objects.Percentage_Check__c")==true){
                          if(component.get("v.objects.SPECIALTY_Y6_Percentage__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.SPECIALTY_Y6_Percentage__c"), component.get("v.objects.Basis_Y6__c"), true);
                    }}else{
                         if(component.get("v.objects.SPECIALTY_Y6__c")!=null){
                        concatRes5 = helper.getConcatString(component.get("v.objects.Plan_Year_Y6__c"), component.get("v.objects.SPECIALTY_Y6__c"), component.get("v.objects.Basis_Y6__c"), false);
                    }}
                    if(concatRes5) resString = resString + concatRes5;
                   
                                      
                      component.set("v.Row1Col2", resString);

               // component.set("v.Row2Col2",component.get("v.objects.Template_SpecialtyatCVS_Text__c")); 
            } 
            
          }
        }
        if(component.get("{!v.ObjectName}")=="Rebate_Guarantee__c" && component.get("{!v.isCarveOut}")==true) {
            if(component.get("v.objects.Template_Specialty_Carveout_Label_Text__c")!=null){
                console.log("IN Child Object CarveOUT"+component.get("{!v.ObjectName}"));
                component.set("{!v.isNetwork}",false);
                component.set("{!v.isMail}",false);
                component.set("{!v.isSpecialtyPrice}",false);
                component.set("{!v.isRebate}",true);
                component.set("{!v.isAddProgram}",false);
                component.set("{!v.isClinical}",false);
                var cols = [
                    {label: ''},
                    {label: ''}
                ];
                
                component.set("v.tableCols", cols); 
                
                component.set("v.Col1","REBATES - Carve Out"); 
                component.set("v.Col2",""); 
                component.set("v.Row1Display",true);
                component.set("v.Row12Display",true);
                
                component.set("v.Row1Col1",component.get("v.objects.Template_Specialty_Carveout_Label_Text__c")); 
                component.set("v.Row1Col2",component.get("v.objects.Template_Specialty_Carveout_Text__c")); 
            }
        }
    },
    openEdit : function(component, event, helper) 
    {
        component.set("v.Edit", true);
        if(component.get("{!v.ObjectName}")=="Billing_Admin_Fee__c") 
        {
            component.set("v.AddGridElectronic", false);
            component.set("v.AddGridManual", false);
            component.set("v.AddGridM340B", false);  
        }
    },
    openCopy : function(component, event, helper)   { 
        
        if(component.get("v.isNetwork") == true)  {
            var npoLabel = $A.get("$Label.c.FAFIDNetworkPricing");
            var npid = component.get("v.objects.Id");
            component.set("v.params", '/apex/NetworkPricingEditNewPage?lightning=true&id='+npid + '&type=clone');
            component.set("v.clickNewModal", true);
            var appEvent = $A.get("e.c:Apttus_Grid_NT_Open_Event");
            appEvent.setParams({ "message" : component.get("v.params")});
            appEvent.fire();	
        }
        
        if(component.get("v.isMail") == true)  {
            var npoLabel = $A.get("$Label.c.MailOperationsFieldId");
            var mpid = component.get("v.objects.Id");
            component.set("v.params",'/apex/MailPricingEditNewPage?lightning=true&id='+mpid +'&type=clone');
            component.set("v.clickNewModal", true);
            var appEvent = $A.get("e.c:Apttus_Grid_NT_Open_Event");
            appEvent.setParams({ "message" : component.get("v.params")});
            appEvent.fire();	
        }
        if(component.get("v.isRebate") == true)  {
            var npoLabel = $A.get("$Label.c.Rebate_Carveouts_Show_Dollar_Record_Type");
            var mpid = component.get("v.objects.Id");
            component.set("v.params",'/apex/RebateguaranteeNewEditPage?lightning=true&id='+mpid +'&type=clone');
            component.set("v.clickNewModal", true);
            var appEvent = $A.get("e.c:Apttus_Grid_NT_Open_Event");
            appEvent.setParams({ "message" : component.get("v.params")});
            appEvent.fire();	
        }
    },
    updatepricing : function(component, event, helper)  {
        
        var appEventSave = $A.get("e.c:Apttus_Grid_NT_Save_Event");
        appEventSave.setParams({ 
            "SaveRec" : true,
            "isMatchToSave" : false, 
            "isSavedAndClose" : true
        });
        appEventSave.fire();
        
        var appEventSaveClose = $A.get("e.c:Apttus_RebateSaveAndCloseEvent");
        appEventSaveClose.setParams({  
            "isSavedAndClose" : true
        });
        appEventSaveClose.fire();
             
        if(component.get("{!v.ObjectName}")=="Rebate_Guarantee__c")  {
            component.set("v.is2TQSaved" , false);
            component.set("v.is3TQSaved" , false);
            component.set("v.is3TNQSaved" , false);
            component.set("v.isClosedSaved" , false);
            component.set("v.isSpecSaved" , false);
        }
    },
    updatepricingSave : function(component, event, helper)  {
        
        var appEventSave = $A.get("e.c:Apttus_Grid_NT_Save_Event");
        appEventSave.setParams({ 
            "SaveRec" : true,
            "isMatchToSave" : false, 
            "isSavedAndClose" : false
        });
        appEventSave.fire();	
        
        var appEventSaveClose = $A.get("e.c:Apttus_RebateSaveAndCloseEvent");
        appEventSaveClose.setParams({  
            "isSavedAndClose" : false
        });
        appEventSaveClose.fire();
             
        if(component.get("{!v.ObjectName}")=="Rebate_Guarantee__c")  {
            component.set("v.is2TQSaved" , false);
            component.set("v.is3TQSaved" , false);
            component.set("v.is3TNQSaved" , false);
            component.set("v.isClosedSaved" , false);
            component.set("v.isSpecSaved" , false);
        }
    },
    handleSave : function(component, event, helper)  {
          
        if(component.get("{!v.ObjectName}")=="Rebate_Guarantee__c")  {
            component.set("v.is2TQSaved" , false);
            component.set("v.is3TQSaved" , false);
            component.set("v.is3TNQSaved" , false);
            component.set("v.isClosedSaved" , false);
            component.set("v.isSpecSaved" , false);
        }
    },
    cancel : function(component, event, helper)  {
        
        var appEvent = $A.get("e.c:Apttus_Grid_Cancel_Event");
        appEvent.fire();	
        var appEvent2 = $A.get("e.c:Apttus_Grid_Name_Event");
        appEvent2.setParams({ "gridname" : component.get("{!v.ObjectName}")});
        appEvent2.fire();
        component.set("v.Edit", false);	
        component.set("v.clickNewModal", false);	
    },
    handleCloseEdit : function(component, event, helper)  {
        
        var section = event.getParam("Section");
        if(component.get("{!v.ObjectName}")=="Billing_Admin_Fee__c")  {
            if (section == "ELECTRONIC") {
                component.set("v.AddGridElectronic", true);
            }
            if (section == "MANUAL") {
                component.set("v.AddGridManual", true);
            }
            if (section == "340B") {
                component.set("v.AddGridM340B", true);
            }
            if(component.get("v.AddGridElectronic")== true && component.get("v.AddGridManual")== true && component.get("v.AddGridM340B")== true) {
                var appEvent1 = $A.get("e.c:Apttus_Grid_Name_Event");
                appEvent1.setParams({ "gridname" : component.get("{!v.ObjectName}")});
                appEvent1.fire();
                component.set("v.Edit", false);
                component.set("v.clickNewModal", false);	 
            }
        } else if(component.get("{!v.ObjectName}") == "Rebate_Guarantee__c"){
            var section = event.getParam("Section");
            var isSaved = event.getParam("Save");
            var isCopyComplete = event.getParam("isCopyComplete");
            //alert('isCopyComplete-------'+isCopyComplete);
            if(isCopyComplete == undefined || isCopyComplete == false){
                console.log('-                                            - ');  
                console.log('is2TQSaved ------------ '+component.get("v.is2TQSaved"));
                console.log('is3TQSaved ------------ '+component.get("v.is3TQSaved"));
                console.log('is3TNQSaved ------------ '+component.get("v.is3TNQSaved"));
                console.log('isClosedSaved ----------- '+component.get("v.isClosedSaved"));
                console.log('isSpecSaved ------------ '+component.get("v.isSpecSaved"));
                console.log('-                                            - ');  
                if (section == "2TQ" && isSaved){
                    component.set("v.is2TQSaved", isSaved);
                }
                if (section == "3TQ"  && isSaved){
                    component.set("v.is3TQSaved", isSaved);
                }
                if (section == "3TNQ"  && isSaved){
                    component.set("v.is3TNQSaved", isSaved);
                }
                if (section == "Closed"  && isSaved){
                    component.set("v.isClosedSaved", isSaved);
                }
                if (section == "Specialty"  && isSaved){
                    component.set("v.isSpecSaved", isSaved);
                }
                var isClose2TQEdit = false;
                var isClose3TQEdit = false;
                var isClose3TNQEdit = false;
                var isCloseClosedEdit = false;
                var isCloseSpecEdit = false;
                /*alert('component.get("v.is2TQAvailable") '+component.get("v.is2TQAvailable"));
                alert('component.get("v.is3TQAvailable") '+component.get("v.is3TQAvailable"));
                alert('component.get("v.is3TNQAvailable") '+component.get("v.is3TNQAvailable"));
                alert('component.get("v.isClosedAvailable") '+component.get("v.isClosedAvailable"));*/
                
				console.log('-                                            - ');                 
                console.log('is2TQAvailable ------------'+component.get("v.is2TQAvailable"));
                console.log('is3TQAvailable ------------'+component.get("v.is3TQAvailable"));
                console.log('is3TNQAvailable ------------'+component.get("v.is3TNQAvailable"));
                console.log('is3TNQAvailable ------------'+component.get("v.isClosedAvailable"));
                console.log('isSpecAvailable ------------'+component.get("v.isSpecAvailable"));
                
                if(component.get("v.is2TQAvailable")== true){
                    if(component.get("v.is2TQSaved")== true){
                        isClose2TQEdit = true;
                    }
                } else {
                    isClose2TQEdit = true;
                }
                if(component.get("v.is3TQAvailable")== true){
                    if(component.get("v.is3TQSaved")== true){
                        isClose3TQEdit = true;
                    }
                } else {
                    isClose3TQEdit = true;
                }
                if(component.get("v.is3TNQAvailable")== true){
                    if(component.get("v.is3TNQSaved")== true){
                        isClose3TNQEdit = true;
                    }
                } else {
                    isClose3TNQEdit = true;
                }
                if(component.get("v.isClosedAvailable")== true){
                    if(component.get("v.isClosedSaved")== true){
                        isCloseClosedEdit = true;
                    }
                } else {
                    isCloseClosedEdit = true;
                }
                //alert('component.get("v.isSpecAvailable") '+component.get("v.isSpecAvailable"));
                if(component.get("v.isSpecAvailable")== true){
                    if(component.get("v.isSpecSaved")== true){
                        isCloseSpecEdit = true;
                    }
                } else {
                    isCloseSpecEdit = true;
                }
                /*alert('isClose2TQEdit '+isClose2TQEdit);
                alert('isClose3TQEdit '+isClose3TQEdit);
                alert('isClose3TNQEdit '+isClose3TNQEdit);
                alert('isCloseClosedEdit '+isCloseClosedEdit);*/
                //alert('isCloseSpecEdit '+isCloseSpecEdit);
                console.log('isClose2TQEdit ------------'+isClose2TQEdit);
                console.log('isClose3TQEdit ------------'+isClose3TQEdit);
                console.log('isClose3TNQEdit ------------'+isClose3TNQEdit);
                console.log('isCloseClosedEdit ------------'+isCloseClosedEdit);
                console.log('isCloseSpecEdit ------------'+isCloseSpecEdit);
                console.log('-                                            - '); 
                if(isClose2TQEdit ==  true && isClose3TQEdit ==  true && isClose3TNQEdit ==  true && isCloseClosedEdit ==  true && isCloseSpecEdit == true) {
                    //alert('isClose2TQEdit '+isClose2TQEdit);
                    console.log('-                   child close                         - '); 
                    var appEvent1 = $A.get("e.c:Apttus_Grid_Name_Event");
                    appEvent1.setParams({ "gridname" : component.get("{!v.ObjectName}")});
                    appEvent1.fire();
                    component.set("v.Edit", false);
                    component.set("v.clickNewModal", false);	 
                }
            } else if(isCopyComplete == true) {
                var appEvent1 = $A.get("e.c:Apttus_Grid_Name_Event");
                appEvent1.setParams({ "gridname" : component.get("{!v.ObjectName}")});
                appEvent1.fire();
                component.set("v.Edit", false);
                component.set("v.clickNewModal", false);	 
            } 
        } else {  
            var appEvent1 = $A.get("e.c:Apttus_Grid_Name_Event");
            appEvent1.setParams({ "gridname" : component.get("{!v.ObjectName}")});
            appEvent1.fire();
            component.set("v.Edit", false);
            component.set("v.clickNewModal", false);	
        }
    },
    handleError : function(component, event, helper) {   
        var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Error_Event");
        var Errmsg = event.getParam("Error")
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error!',
            mode : 'sticky',
            type : 'error',
            message : Errmsg,
            mode: 'sticky',
            duration:' 4000'
        });
        toastEvent.fire();
    },
    handleModal : function(component, event, helper)  
    { 
        component.set("v.clickNewModal", false);
    },
    deletepricing : function(component, event, helper)  {     
        component.set("{!v.isDeleteAlertOpen}", true);
    }, 
    closeDeleteAlert : function(component, event, helper)  {
        component.set("{!v.isDeleteAlertOpen}", false);
    },
    deleteSelectedRec : function(component, event, helper)  {
        component.set("{!v.isDeleteAlertOpen}", false);
        component.set("{!v.DisplaySpinner}", true);
        helper.deleteSelectedRecords(component,event,helper);
    },
    handleRebateSection : function(component, event, helper)  {
        var section = event.getParam("section");
        var isAvailable = event.getParam("isAvailable");
        if (section == "2TQ"){
            component.set("v.is2TQAvailable", isAvailable);
        }
        if (section == "3TQ"){
            component.set("v.is3TQAvailable", isAvailable);
        }
        if (section == "3TNQ"){
            component.set("v.is3TNQAvailable", isAvailable);
        }
        if (section == "Closed"){
            component.set("v.isClosedAvailable", isAvailable);
        }
        if (section == "Specialty"){
            component.set("v.isSpecAvailable", isAvailable);
        }
    }
        
    
})