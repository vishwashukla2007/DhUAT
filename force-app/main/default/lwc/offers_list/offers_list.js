import { LightningElement, wire, track,api} from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';
import { fireEvent } from 'c/pubsub'
import getAccountLocations from '@salesforce/apex/AccountHelper_test_PCD.getAccountLocations';
export default class RadioButtonsInLWC extends LightningElement {
    @api selectedValue;
    @track options = [];
    @track Accounts;
    @wire(CurrentPageReference) pageRef;
    // Getting Account Type Picklist values using wire service
    @wire(getAccountLocations)
    typePicklistValues({error, data}) {
        if(data) {
            this.Accounts=data;
            let optionsValues = [];
            window.console.log('data.values.length; ===> '+this.Accounts.length);
            for(let i = 0; i <this.Accounts.length; i++) {
                window.console.log('data.values.length; ===> '+data.values.length);
                optionsValues.push({
                    label: this.Accounts[i].Name,
                    value: this.Accounts[i].Id
                })
            }
            this.options = optionsValues;
            window.console.log('optionsValues ===> '+JSON.stringify(optionsValues));
        }
        else if(error) {
            window.console.log('error ===> '+JSON.stringify(error));
        }
    }

    // handle the selected value
    handleChange(event) {
        this.selectedValue = event.target.value;
        fireEvent(this.pageRef, 'inputChangeEvent', this.selectedValue);
    }

}