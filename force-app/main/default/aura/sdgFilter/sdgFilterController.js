/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
({
  doInit: function(component, event, helper) {
    var FieldType = component.get("v.SDGField").FieldType;

    var pref = component.get("v.SDGField").Preferences;
    //suppress any exceptions during preference setting:
    try {
      if (pref !== null) {
        component.set("v.FilterOperatorPreference", pref.FilterOperator);
        component.set("v.FilterValuePreference", pref.FilterValue);
        if (FieldType === "DATE" || FieldType === "DATETIME") {
          if (pref.FilterValue !== "")
            component.set("v.DateValue", pref.FilterValue);
        }
      } else {
        component.set("v.FilterValuePreference", null);
      }
    } catch (err) {
      //Suppress errors in setting preferences
    }

    if (FieldType === "DATE" || FieldType === "DATETIME") {
      component.set("v.isDate", true);
      component.set("v.canFilter", true);
    }
    if (
      FieldType === "INTEGER" ||
      FieldType === "DOUBLE" ||
      FieldType === "CURRENCY" ||
      FieldType === "PERCENT"
    ) {
      component.set("v.isNumber", true);
      component.set("v.canFilter", true);
    }
    if (
      FieldType === "ID" ||
      FieldType === "STRING" ||
      FieldType === "EMAIL" ||
      FieldType === "URL" ||
      FieldType === "PHONE" ||
      FieldType === "HYPERLINK"
    ) {
      component.set("v.isString", true);
      component.set("v.canFilter", true);
    }
    //Other acceptable types
    if (FieldType === "BOOLEAN" || FieldType === "PICKLIST") {
      component.set("v.canFilter", true);
    }
  },

  updateString: function(component, event, helper) {
    var value = component.find("StringField").get("v.value");
    var operator = component.find("StringOperatorField").get("v.value");

    helper.fireUpdate(component, value, operator);
  },
  updateCheckbox: function(component, event, helper) {
    var value = component.find("CheckboxField").get("v.value");

    helper.fireUpdate(component, value, "");
  },
  updateDate: function(component, event, helper) {
      debugger;
    var value = component.find("DateField").get("v.value");
    if (value !== null) {
    var Datevalue = value.split("-");
    var yearformat = Datevalue[0];
    var month = Datevalue[1];
    var day = Datevalue[2];
    if((month >= 1 && month <=12 ) && (day >= 1 && day <= 31) && (yearformat >= 1900 && yearformat <=2999)) 
       {      
       var operator = component.find("DateOperatorField").get("v.value");
       helper.fireUpdate(component, value, operator);
        }
      else {
          //component.find("DateField").set("v.DateValue", null);
          var toastEvent = $A.get("e.force:showToast");
          toastEvent.setParams({
                        mode: 'sticky',
                        message: 'Invalid Date Format - Use the date selector to specify the date',
                        type : 'info'
                    });
          toastEvent.fire();
           
      }}
  },
  updateNumber: function(component, event, helper) {
    var value = component.find("NumberField").get("v.value");
    var operator = component.get("v.NumberOperator");

    helper.fireUpdate(component, value, operator);
  },
  updatePicklist: function(component, event, helper) {
    var value = component.find("PicklistField").get("v.value");

    helper.fireUpdate(component, value, "");
  }
});