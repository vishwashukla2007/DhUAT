import { LightningElement, wire,api,track } from 'lwc';
import { fireEvent } from 'c/pubsub';
import {CurrentPageReference} from 'lightning/navigation';
import getWrapperList from '@salesforce/apex/Offer_PCD_Lwc_Controller.getWrapperList';
let testURL =window.location.href;
let newURL = new URL(testURL).searchParams;

export default class WrapperComponent extends LightningElement {


    @api checkvalue;
    @track offerID;
    @track offerID1;
    @track offerID2;
    @track myID;
    @track conres;
    @track conresfinal;
    @track searchKeyOffer = '';
    @track offStringy;

    
    /*@wire(getWrapperList,{Searchkey:'$searchKeyOffer'})
    getResp({data}){
        if(data){
            window.console.log('DATTTTTTTT'+data);
            this.offerID=data;
            this.offerID1= this.offerID[0].Id;

        }
    }*/
    constructor() {
        super();
        this.searchKeyOffer =newURL.get('c__accountName');
        window.console.log('Search Key '+ this.searchKeyOffer);
        this.doSearch();
        
    }
    connectedCallback(){
        //registerListener('searchKeyChange', this.handleSearchKeyChange, this);
        window.console.log('the OFFFFFFFFFFERRRRRRRRRRRR'+this.offerID1);
        window.console.log('THe Search Key'+ this.searchKeyOffer);
    }
   
    @wire(CurrentPageReference) pageRef;
    @wire(getWrapperList,{Searchkey:'$searchKeyOffer'}) 
    wrappers;
    @track wrapConvert;

   

    showData(event){
		this.ranger = event.currentTarget.dataset.rangerid;
		this.left = event.clientX;
		this.top=event.clientY;
	}
	hideData(event){
        this.ranger = "";
        window.console.log("Event"+event);
	}
	get assignClass() { 
		return this.active ? '' : 'slds-hint-parent';
    }
    doSearch() {
        getWrapperList({Searchkey: this.searchKeyOffer })
            .then(result => {
                this.offStringy=JSON.stringify(result);
                const json=JSON.parse(this.offStringy);
                this.offerID1=json[0].Id;
                window.console.log('Theee my ofer iD'+this.offerID1);
                fireEvent(this.pageRef,'inputChangeEvent',this.offerID1);
                fireEvent(this.pageRef,'inputChangeEventFAF',this.offerID1);
                fireEvent(this.pageRef,'inputChangeEventDocument',this.offerID1);

            })
            .catch(error => {
                window.console.log('Constructor error json'+error);
                //this.error = error;
                //this.contacts = undefined;
            });
    }

    
    renderedCallback(){
        this.searchKeyOffer =newURL.get('c__accountName');
        this.doSearch();
        fireEvent(this.pageRef,'inputChangeEvent',this.offerID1);
        fireEvent(this.pageRef,'inputChangeEventFAF',this.offerID1);
        fireEvent(this.pageRef,'inputChangeEventDocument',this.offerID1);
        window.console.log('test.com'+this.offerID1);
        window.console.log('Acccount Name ===> '+newURL.get('c__accountName'));
       
    }
    handleChangeEvent(event){
        Array.from(this.template.querySelectorAll('lightning-input'))
        .forEach(element => {
            element.checked=false;
        });
        const checkbox = this.template.querySelector('lightning-input[data-value="'+event.target.dataset.value+'"]');
        this.checkvalue=event.target.dataset.value;
        window.console.log('Checked Value checkbox==>'+checkbox);
        checkbox.checked=true;
        fireEvent(this.pageRef,'inputChangeEvent', this.checkvalue);
        fireEvent(this.pageRef,'inputChangeEventFAF', this.checkvalue);
        fireEvent(this.pageRef,'inputChangeEventDocument', this.checkvalue);
    }
}