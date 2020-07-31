import { LightningElement,track,wire } from 'lwc';
import { CurrentPageReference} from 'lightning/navigation';
import { registerListener, unregisterAllListeners} from 'c/pubsub';
import getFAF from '@salesforce/apex/Offer_PCD_Lwc_Controller.getFAF';


export default class LWC_Offer_Fafs extends LightningElement {
    @track ac;
    @track PCD;
    @track PCDFAF;
    @track PCDName;
    @track Task;
    @track Status;
    @track Opportunity;
    @track errorMessage;
    @track inpVal;
    @wire(CurrentPageReference) pageRef;

    connectedCallback() {
      // subscribe to inputChangeEvent event
      registerListener('inputChangeEventFAF', this.handleChange, this);
    }
  disconnectedCallback() {
    // unsubscribe from inputChangeEvent event
    unregisterAllListeners(this);
  }
  handleChange(inpVal) {
    this.inpVal = inpVal;
    window.console.log("this.inpVal"+this.inpVal);
	getFAF({Key:this.inpVal})
	.then(result => {
                if(result!==null){
                    this.PCD=JSON.stringify(result);
                    if(this.PCD.length!==2){
                    window.console.log("this.PCD FAF**"+this.PCD);
                    this.PCDFAF=JSON.parse(this.PCD);
                    this.PCDName=JSON[0];
                    const json =JSON.parse(this.PCD);
                    this.errorMessage='';
                    window.console.log({abc:json});
                    window.console.log("this.PCD FAF"+this.PCD);
                    }
                    else{
                      this.errorMessage='No FAF is Associated with the selected Agreement';
                      this.PCDFAF='';
                    }
                }
                else{
                  this.errorMessage='No FAF is Associated with the selected Agreement';

                }
     })
     
  }
  
  
  
}