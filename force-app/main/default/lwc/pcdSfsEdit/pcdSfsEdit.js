import { LightningElement, wire, track, api } from 'lwc';
import getDrugListFromFAF from '@salesforce/apex/PCD_SFS_Edit_ScreenController.getDrugListFromFAF';
import getSFSSummaryData from '@salesforce/apex/PCD_SFS_Edit_ScreenController.getSFSSummaryData';
import getPharmacyBenefit from '@salesforce/apex/PCD_SFS_Edit_ScreenController.getPharmacyBenefit';
import { refreshApex } from '@salesforce/apex';

function drugObj(index, id, drugTherapy, drugName, Rates, Notes, Mac) {
    this.index = index;
    this.id = id;
    this.Drug_Therapy__c = drugTherapy;
    this.Drug_Name__c = drugName;
    this.Rate__c = Mac === true ? "MAC" : Rates.toFixed(2) + "%";
    this.Mac__c = Mac;
    this.Notes = Notes;
    this.tempId = '';
    this.Selected = false;
}

function summaryObj(index, Name, Value) {
    this.index = index;
    this.Name = Name;
    this.Value = [];
    Value.split(',').forEach((y, index) => {
        this.Value.push({ "Rate": y == "" ? ' ' : y, "Id": 'Rate' + index });
    });
}

const columns = [{ Id: 'c1', label: 'DRUG THERAPY', fieldName: 'Drug_Therapy__c', hideDefaultActions: false, sortable: true },
{ Id: 'c2', label: 'DRUG NAME', fieldName: 'Drug_Name__c', hideDefaultActions: false, sortable: true },
{ Id: 'c3', label: 'AWP DISCOUNT', fieldName: 'Rate__c', hideDefaultActions: false, sortable: true },
{ Id: 'c8', label: 'NOTES', fieldName: '', hideDefaultActions: false, sortable: false }];
const summaryColumns = [{ Id: 'sc1', label: 'SUMMARY', fieldName: 'Summary__c' },
{ Id: 'sc2', label: '', fieldName: 'Value', hideDefaultActions: false },
{ Id: 'sc3', label: '', fieldName: 'Rates', hideDefaultActions: false }];
const rowsDisplayedOption = [{ key: "cbx20", Value: 20 }, { key: "cbx30", Value: 30 }, { key: "cbx40", Value: 40 }, { key: "cbx50", Value: 50 }];
const opts = [{ label: 'Drug Therapy', value: 'Drug Therapy' },
{ label: 'Drug Name', value: 'Drug Name' },
{ label: 'AWP Discount', value: 'AWP Discount' }];
export default class PcdSfsEdit extends LightningElement {
    showAddDrugModal = false;
    wiredDrugListRefresh;
    drugNames = [];
    drugTherapys = [];
    awpRates = [];
    yearsOptions = {};
    drugData = [];
    unfilteredData = [];
    filteredData = [];
    summaryData = [];
    searchRecords = [];
    columns = columns;
    summaryColumns = summaryColumns;
    pageSizeOptions = rowsDisplayedOption;
    isDrugTherapy = true;
    iconFlag = true;
    hasData = false;
    sumhasData = false;
    LoadingText = false;
    messageFlag = false;
    clearIconFlag = false;
    sortedDirection = 'asc';
    txtclassname = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
    selectedColumn = "Drug Therapy";
    paginationShow = "hideIt";
    selectedRowsDisp = 20;
    sortedColumn;
    pharmacyBenefit;
    errorMsg;
    selectRecordName;
    totalRecords;
    totalDisplayedRecords;
    pageSize;
    totalPages;
    pageNumber;
    allYear = true;
    year1 = false;
    year2 = false;
    year3 = false;
    year4 = false;
    year5 = false;
    allSumYear = true;
    sumYear1 = false;
    sumYear2 = false;
    sumYear3 = false;
    sumYear4 = false;
    sumYear5 = false;
    @api fafId;
    @api specOpId;
    // @api fafId = 'a5X0x0000000e9aEAA';
    // @api specOpId = 'a5u0x0000001t15AAA';

    renderedCallback() {
        if (this.hasRendered) return;
        if (this.allYear) return;
        this.hasRendered = true;
        this.template.querySelectorAll('th').forEach(element => {
            if (element.getAttribute("data-id") == "DRUG THERAPY") {
                var computedStyle = window.getComputedStyle(element, null);
                element.setAttribute("style", "width: 23% !important;");
            }
        });

    }
    changeOption(event) {
        this.selectedColumn = event.target.value;
        this.iconFlag = true;
        this.clearIconFlag = false;
        this.txtclassname = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
        this.LoadingText = false;
        this.selectRecordName = "";

    }

    setRecordsToDisplay(isShow, data) {
        //console.log(this.pageNumber);
        this.totalRecords = data.length;
        this.drugData = [];
        if (isShow) {
            if (!this.pageSize)
                this.pageSize = 20;
            if (!this.pageNumber)
                this.pageNumber = 1;
            this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
            this.setPaginationControls(data);
            for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
                if (i === this.totalRecords) break;
                this.drugData.push(data[i]);
            }
            this.rowNumberStart = (this.pageNumber - 1) * this.pageSize + 1;
            this.rowNumberEnd = this.pageNumber * this.pageSize <= data.length ? this.pageNumber * this.pageSize : data.length;
            this.totalDisplayedRecords = this.drugData.length;
        }
        else {
            this.drugData = data;
        }
    }

    setPaginationControls(data) {
        if (this.pageNumber == 1 && this.pageSize < data.length) {
            this.previousButton = "slds-button hideIt";
            this.nextButton = "slds-button showIt";
        } else if (this.pageNumber == this.totalPages && (this.pageSize == data.length || this.pageSize > data.length)) {
            this.previousButton = "slds-button hideIt";
            this.nextButton = "slds-button hideIt";
        } else if (this.pageNumber == this.totalPages && this.pageSize < data.length) {
            this.previousButton = "slds-button showIt";
            this.nextButton = "slds-button hideIt";
        }
        else {
            this.previousButton = "slds-button showIt";
            this.nextButton = "slds-button showIt";
        }
    }

    handleRecordsPerPage(event) {
        this.pageSize = parseInt(event.target.value);
        if (this.selectRecordName) {
            this.pageNumber = 1;
            this.setRecordsToDisplay(true, this.filteredData);
        }
        else {
            this.pageNumber = 1;
            this.setRecordsToDisplay(true, this.unfilteredData);
        }
    }

    nextPage() {
        this.pageNumber = this.pageNumber + 1;
        if (this.selectRecordName) {
            this.setRecordsToDisplay(true, this.filteredData);
        }
        else {
            this.setRecordsToDisplay(true, this.unfilteredData);
        }
    }

    previousPage() {
        this.pageNumber = this.pageNumber - 1;
        if (this.selectRecordName) {
            this.setRecordsToDisplay(true, this.filteredData);
        }
        else {
            this.setRecordsToDisplay(true, this.unfilteredData);
        }
    }

    flattenRecord(data, maxYear) {
        let previousRecord;
        let flatData = [];
        let record = {};
        var drugsNotAllYear = [];
        let index = 1;
        var year1Search = new Set();
        var year2Search = new Set();
        var year3Search = new Set();
        var year4Search = new Set();
        var year5Search = new Set();
        var dgNames = new Set();
        var dgTherapy = new Set();
        let rateProc;
        data.filter(rec => rec.Year__c == "All").forEach(z => {
            rateProc = !z.Rate__c ? 0 : z.Rate__c;
            record = this.createProperties(record, z, "All");
            for (var num = 1; num < maxYear + 1; num++) {
                record["year" + num + "RecordId"] = z.Id;
                record["Year" + num] = z.MAC__c ? "MAC" : rateProc.toFixed(2) + "%";
            }
            record["index"] = index;
            dgNames.add(z.Drug_Name__c);
            dgTherapy.add(z.Drug_Therapy__c);
            year1Search.add(z.MAC__c ? "MAC" : rateProc.toFixed(2)) + "%";
            year2Search.add(z.MAC__c ? "MAC" : rateProc.toFixed(2)) + "%";
            year3Search.add(z.MAC__c ? "MAC" : rateProc.toFixed(2)) + "%";
            year4Search.add(z.MAC__c ? "MAC" : rateProc.toFixed(2)) + "%";
            year5Search.add(z.MAC__c ? "MAC" : rateProc.toFixed(2)) + "%";
            index++;
            flatData.push(record);
            previousRecord = undefined;
            record = {};
        });

        drugsNotAllYear = this.sortArrayAsc(data.filter(rec => rec.Year__c != "All"));
        drugsNotAllYear.forEach(x => {
            rateProc = !x.Rate__c ? 0 : x.Rate__c;
            if (!previousRecord) {
                previousRecord = x;
            }
            if (x.Drug_Name__c == previousRecord.Drug_Name__c && x.Drug_Therapy__c == previousRecord.Drug_Therapy__c && x.Pharmacy_Benefit__c == previousRecord.Pharmacy_Benefit__c) {
                if (!record.hasOwnProperty("Drug_Name__c")) {
                    record = this.createProperties(record, x, maxYear);
                    record["index"] = index;
                    dgNames.add(x.Drug_Name__c);
                    dgTherapy.add(x.Drug_Therapy__c);
                    if (x.Year__c == "1") {
                        year1Search.add(x.MAC__c ? "MAC" : rateProc.toFixed(2)) + "%";
                    }
                    else if (x.Year__c == "2") {
                        year2Search.add(x.MAC__c ? "MAC" : rateProc.toFixed(2)) + "%";
                    }
                    else if (x.Year__c == "3") {
                        year3Search.add(x.MAC__c ? "MAC" : rateProc.toFixed(2)) + "%";
                    }
                    else if (x.Year__c == "4") {
                        year4Search.add(x.MAC__c ? "MAC" : rateProc.toFixed(2)) + "%";
                    }
                    else {
                        year5Search.add(x.MAC__c ? "MAC" : rateProc.toFixed(2)) + "%";
                    }
                    index++;
                }
                else {
                    record["year" + x.Year__c + "RecordId"] = x.Id;
                    record["Year" + x.Year__c] = x.MAC__c ? "MAC" : rateProc.toFixed(2) + "%";
                    if (x.Year__c == "1") {
                        year1Search.add(x.MAC__c ? "MAC" : rateProc.toFixed(2)) + "%";
                    }
                    else if (x.Year__c == "2") {
                        year2Search.add(x.MAC__c ? "MAC" : rateProc.toFixed(2)) + "%";
                    }
                    else if (x.Year__c == "3") {
                        year3Search.add(x.MAC__c ? "MAC" : rateProc.toFixed(2)) + "%";
                    }
                    else if (x.Year__c == "4") {
                        year4Search.add(x.MAC__c ? "MAC" : rateProc.toFixed(2)) + "%";
                    }
                    else {
                        year5Search.add(x.MAC__c ? "MAC" : rateProc.toFixed(2)) + "%";
                    }
                }
            }
            else {
                flatData.push(record);
                previousRecord = x;
                record = {};
                record = this.createProperties(record, x, maxYear);
                record["index"] = index;
                dgNames.add(x.Drug_Name__c);
                dgTherapy.add(x.Drug_Therapy__c);
                if (x.Year__c == "1") {
                    year1Search.add(x.MAC__c ? "MAC" : rateProc.toFixed(2)) + "%";
                }
                else if (x.Year__c == "2") {
                    year2Search.add(x.MAC__c ? "MAC" : rateProc.toFixed(2)) + "%";
                }
                else if (x.Year__c == "3") {
                    year3Search.add(x.MAC__c ? "MAC" : rateProc.toFixed(2)) + "%";
                }
                else if (x.Year__c == "4") {
                    year4Search.add(x.MAC__c ? "MAC" : rateProc.toFixed(2)) + "%";
                }
                else {
                    year5Search.add(x.MAC__c ? "MAC" : rateProc.toFixed(2)) + "%";
                }
                index++;
            }
        });
        var arraytoPush = {};
        var dnArr = [];
        var dtArr = [];
        var y1Arr = [];
        var y2Arr = [];
        var y3Arr = [];
        var y4Arr = [];
        var y5Arr = [];
        index = 1;
        Array.from(dgNames).sort().forEach(dn => {
            dnArr.push({ key: index + 'dn', option: dn });
            index++;
        });
        index = 1;
        Array.from(dgTherapy).sort().forEach(dt => {
            dtArr.push({ key: index + 'dt', option: dt });
            index++;
        });
        index = 1;
        Array.from(year1Search).sort().forEach(yO => {
            y1Arr.push({ key: index + 'yO', option: yO + "%" });
            index++;
        });
        index = 1;
        Array.from(year2Search).sort().forEach(yTw => {
            y2Arr.push({ key: index + 'yTw', option: yTw + "%" });
            index++;
        });
        index = 1;
        Array.from(year3Search).sort().forEach(yTr => {
            y3Arr.push({ key: index + 'yTr', option: yTr + "%" });
            index++;
        });
        index = 1;
        Array.from(year4Search).sort().forEach(yFo => {
            y4Arr.push({ key: index + 'yFo', option: yFo + "%" });
            index++;
        });
        index = 1;
        Array.from(year5Search).sort().forEach(yFi => {
            y5Arr.push({ key: index + 'yFi', option: yFi + "%" });
            index++;
        });
        arraytoPush["drugNames"] = dnArr;
        arraytoPush["drugTherapy"] = dtArr;
        arraytoPush["Year1"] = y1Arr;
        arraytoPush["Year2"] = y2Arr;
        arraytoPush["Year3"] = y3Arr;
        arraytoPush["Year4"] = y3Arr;
        arraytoPush["Year5"] = y3Arr;
        this.yearsOptions = arraytoPush;
        flatData.push(record);
        flatData = this.sortArrayAsc(flatData);
        return flatData;
    }
    sortArrayAsc(arr) {
        var dataTable = JSON.parse(JSON.stringify(arr));
        dataTable.sort((sd1, sd2) => {
            if (sd1.Drug_Therapy__c > sd2.Drug_Therapy__c) return 1;
            if (sd1.Drug_Therapy__c < sd2.Drug_Therapy__c) return -1;
            if (sd1.Drug_Name__c > sd2.Drug_Name__c) return 1;
            if (sd1.Drug_Name__c < sd2.Drug_Name__c) return -1;
        });
        return dataTable;
    }
    createProperties(obj, data, maxYear) {
        let rateProc = !data.Rate__c ? 0 : data.Rate__c;
        obj["Drug_Name__c"] = data.Drug_Name__c;
        obj["Drug_Therapy__c"] = data.Drug_Therapy__c;
        obj["LOB__c"] = data.LOB__c;
        obj["Notes"] = data.Notes__c;
        if (maxYear != 'All') {
            for (var num = 1; num < maxYear + 1; num++) {
                if (num == data.Year__c) {
                    obj["year" + num + "RecordId"] = data.Id;
                    obj["Year" + num] = data.MAC__c ? "MAC" : rateProc.toFixed(2) + '%';

                }
                else {
                    obj["year" + num + "RecordId"] = "";
                    obj["Year" + num] = "";
                }
            }
        }
        return obj;
    }
    @wire(getDrugListFromFAF, { fafId: '$fafId', specOpId: '$specOpId' })
    // wiredDrugList({ data, error }) {
    wiredDrugList(value) {
        this.wiredDrugListRefresh = value;
        const { data, error } = value;
        if (data) {
            let recData = JSON.parse(JSON.stringify([...data]));
            let drugs = [];
            let optionList = opts;
            recData = this.sortArrayAsc(recData);
            if (recData.length > 0) {
                var distinctYear = new Set();
                recData.map(x => {
                    if (x.Year__c != "All")
                        distinctYear.add(parseInt(x.Year__c, 10));
                });
                var highestValue = Math.max(undefined || 0, ...Array.from(distinctYear));
                if (highestValue == 1) {
                    this.year1 = true;
                }
                else if (highestValue == 2) {
                    this.year2 = true;
                }
                else if (highestValue == 3) {
                    this.year3 = true;
                }
                else if (highestValue == 4) {
                    this.year4 = true;
                }
                else {
                    this.year5 = true;
                }
                if (highestValue === 0) {
                    recData.forEach((x, index) => {
                        let rateProc = !x.Rate__c ? 0 : x.Rate__c;
                        let drugRec = new drugObj(index, x.Id, x.Drug_Therapy__c, x.Drug_Name__c, rateProc, x.Notes__c, x.MAC__c);
                        drugs.push(drugRec);
                        
                        if (!this.drugNames.some(drugName => drugName.option === x.Drug_Name__c)) {
                            this.drugNames.push({ key: index + 'dn', option: x.Drug_Name__c });
                        }
                        if (!this.drugTherapys.some(drugTh => drugTh.option === x.Drug_Therapy__c)) {
                            this.drugTherapys.push({ key: index + 'dt', option: x.Drug_Therapy__c })
                        }
                        if (x.MAC__c) {
                            if (!this.awpRates.some(rates => rates.option === 'MAC')) {
                                this.awpRates.push({ key: index + 'm', option: 'MAC' });
                            }
                        }
                        if (x.Rate__c) {
                            if (!this.awpRates.some(rates => rates.option === x.Rate__c.toFixed(2) + "%")) {
                                this.awpRates.push({ key: index + 'r', option: x.Rate__c.toFixed(2) + "%" });
                            }
                        }
                    });
                    this.options = optionList;
                }
                else {
                    this.allYear = false;
                    drugs = this.flattenRecord(recData, highestValue);
                    let origCol = this.columns;
                    let searchOption = opts;
                    let colIndex = origCol.map(e => e.label).indexOf('AWP DISCOUNT');

                    if (colIndex != -1) {
                        let colIndex = origCol.map(e => e.label).indexOf('AWP DISCOUNT');
                        let searchData = { label: 'AWP Discount', value: 'AWP Discount' };
                        let searchIndex = searchOption.map(e => e.label).indexOf('AWP DISCOUNT');
                        origCol.splice(colIndex, 1);
                        searchOption.splice(searchIndex, 1);
                        let indexcount = 3;
                        for (let count = 1; count < highestValue + 1; count++) {
                            let colApp = { Id: 'c' + indexcount, label: `AWP DISC - YR` + count, fieldName: "Year" + count, hideDefaultActions: false, sortable: true };
                            origCol.splice(colIndex, 0, colApp);
                            let optionApp = { label: 'AWP DISC - YR' + count, value: 'Year' + count };

                            searchOption.push(optionApp);
                            colIndex++;
                            indexcount++;
                        }
                    }

                    this.drugTherapys = this.yearsOptions.drugTherapy;
                    this.drugNames = this.yearsOptions.drugNames;
                    this.options = searchOption;
                }
            }
            this.unfilteredData = drugs;
            if (this.unfilteredData.length > this.selectedRowsDisp) {
                this.paginationShow = 'showIt';
                this.setRecordsToDisplay(true, drugs);
            }
            else {
                this.paginationShow = 'hideIt';
                this.setRecordsToDisplay(false, drugs);
            }
            if (this.drugData.length > 0) {
                this.hasData = true;
            }
        }
        else if (error) {
            alert(JSON.stringify(errorMsg));

            window.console.log('error' + errorMsg);
        }
    }

    @wire(getSFSSummaryData, { fafId: '$fafId', specOpId: '$specOpId' })
    wiredSFSSummaryList({ data, error }) {
        if (data) {
            let recData = JSON.parse(JSON.stringify([...data]));
            let testsummaryData = [];
            var distinctYear = new Set();
            recData.map(x => {
                if (x.Year__c != "All")
                    distinctYear.add(parseInt(x.Year__c, 10));
            });
            let summaryHighestValue = Math.max(undefined || 0, ...Array.from(distinctYear));
            if (summaryHighestValue == 0) {
                let index = 0;
                recData.forEach(x => {
                    let stringbuilder = "";
                    let arrayBuilder = [];
                    let dataRec;
                    this.summaryColumns.push({ Id: 'sc' + 0, label: '', fieldName: "", hideDefaultActions: false });
                    if (x.Brand_Rate__c == x.Generic_Rate__c) {
                        stringbuilder = "Brand & Generic," + x.Brand_Rate__c.toFixed(2) + "%";
                    }
                    else {
                        stringbuilder = "Brand," + x.Brand_Rate__c.toFixed(2) + "%, ,Generic," + x.Generic_Rate__c.toFixed(2) + "%";
                    }
                    dataRec = new summaryObj('sum' + index, "Default Rate", stringbuilder);
                    index++;
                    testsummaryData.push(dataRec);
                    if (x.OED_Guarantee_Rate__c) {
                        dataRec = new summaryObj('sum' + index, "Overall Effective Discount(OED)", x.OED_Guarantee_Rate__c.toFixed(2) + '%');
                        index++;
                        testsummaryData.push(dataRec);
                    }
                    if (x.BER_Guarantee_Rate__c) {
                        dataRec = new summaryObj('sum' + index, "Brand Effective Rate(BER)", x.BER_Guarantee_Rate__c.toFixed(2) + '%');
                        index++;
                        testsummaryData.push(dataRec);
                    }
                    if (x.GER_Guarantee_Rate__c) {
                        dataRec = new summaryObj('sum' + index, "Generic Effective Discount(GER)", x.GER_Guarantee_Rate__c.toFixed(2) + '%');
                        index++;
                        testsummaryData.push(dataRec);
                    }
                    if (x.MER_Guarantee_Rate__c) {
                        dataRec = new summaryObj('sum' + index, "MAC Effective Discount(MER)", x.MER_Guarantee_Rate__c.toFixed(2) + '%');
                        index++;
                        testsummaryData.push(dataRec);
                    }
                    if (x.Brand_Dispensing_Fee__c == x.Generic_Dispensing_Fee__c) {
                        stringbuilder = "Brand & Generic," + x.Brand_Dispensing_Fee__c.toFixed(2) + "%";
                    }
                    else {
                        stringbuilder = "Brand,$" + x.Brand_Dispensing_Fee__c.toFixed(2) + ", ,Generic,$" + x.Generic_Dispensing_Fee__c.toFixed(2);
                    }
                    dataRec = new summaryObj('sum' + index, "Dispensing Fee", stringbuilder);
                    index++;
                    testsummaryData.push(dataRec);
                });

            }
            else {
                let sumCols = this.summaryColumns;
                let sumColIndex = sumCols.map(e => e.fieldName).indexOf('Rates');
                if (sumColIndex != -1) {
                    sumCols.splice(sumColIndex, 1);
                    let indexcount = 4;
                    for (let count = 1; count < summaryHighestValue + 1; count++) {
                        let colApp = { Id: 'sc' + indexcount, label: `YEAR ` + count, fieldName: "Year" + count, hideDefaultActions: false };
                        sumCols.splice(sumColIndex, 0, colApp);
                        indexcount++;
                        sumColIndex++;
                    }
                    sumCols.splice(sumColIndex, 0, { Id: 'sc' + indexcount, label: '', fieldName: "", hideDefaultActions: false });
                    this.summaryColumns = sumCols;
                }
                this.allSumYear = false;
                if (summaryHighestValue >= 1) {
                    this.sumYear1 = true;
                }
                if (summaryHighestValue >= 2) {
                    this.sumYear2 = true;
                }
                if (summaryHighestValue >= 3) {
                    this.sumYear3 = true;
                }
                if (summaryHighestValue >= 4) {
                    this.sumYear4 = true;
                }
                if (summaryHighestValue >= 5) {
                    this.sumYear5 = true;
                }
                let arrayBuilder = [];
                let str;
                let obj = {};
                recData.filter(rec => rec.Year__c != "All").forEach(x => {
                    if (x.Brand_Rate__c == x.Generic_Rate__c) {
                        str = "Brand & Generic," + x.Brand_Rate__c.toFixed(2) + "%";
                    }
                    else {
                        str = "Brand," + x.Brand_Rate__c.toFixed(2) + "%, ,Generic," + x.Generic_Rate__c.toFixed(2) + "%";
                    }
                    str.split(",").forEach((y, index) => {
                        arrayBuilder.push({ "Rate": y, "Id": 'drRate' + x.Year__c + index });
                    });
                    obj["drY" + x.Year__c] = arrayBuilder;
                    arrayBuilder = [];
                    str = "";
                    if (x.OED_Guarantee_Rate__c) {
                        arrayBuilder.push({ "Rate": x.OED_Guarantee_Rate__c.toFixed(2)+ "%", "Id": 'oedRate' + x.Year__c + 1 });
                        obj["oedY" + x.Year__c] = arrayBuilder;
                        arrayBuilder = [];
                    }
                    if (x.BER_Guarantee_Rate__c) {
                        arrayBuilder.push({ "Rate": x.BER_Guarantee_Rate__c.toFixed(2)+ "%", "Id": 'berRate' + x.Year__c + 1 });
                        obj["berY" + x.Year__c] = arrayBuilder;
                        arrayBuilder = [];
                    }
                    if (x.GER_Guarantee_Rate__c) {
                        arrayBuilder.push({ "Rate": x.GER_Guarantee_Rate__c.toFixed(2)+ "%", "Id": 'gerRate' + x.Year__c + 1 });
                        obj["gerY" + x.Year__c] = arrayBuilder
                        arrayBuilder = [];
                    }
                    if (x.MER_Guarantee_Rate__c) {
                        arrayBuilder.push({ "Rate": x.MER_Guarantee_Rate__c.toFixed(2)+ "%", "Id": 'berRate' + x.Year__c + 1 });
                        obj["merY" + x.Year__c] = arrayBuilder;
                        arrayBuilder = [];
                    }
                    if (x.Brand_Dispensing_Fee__c == x.Generic_Dispensing_Fee__c) {
                        str = "Brand & Generic," + x.Brand_Dispensing_Fee__c.toFixed(2) + "%";
                    }
                    else {
                        str = "Brand," + x.Brand_Dispensing_Fee__c.toFixed(2) + "%, ,Generic," + x.Generic_Dispensing_Fee__c.toFixed(2) + "%";
                    }
                    str.split(",").forEach((y, index) => {
                        arrayBuilder.push({ "Rate": y, "Id": 'dispRate' + x.Year__c + index });
                    });
                    obj["dispY" + x.Year__c] = arrayBuilder;
                    arrayBuilder = [];
                    str = "";
                });
                str = "drY,oedY,berY,gerY,merY,dispY";
                str.split(",").forEach((z, index) => {
                    let dataSum = {};
                    for(let ct = 1; ct < summaryHighestValue +1; ct++){
                        if (obj.hasOwnProperty(z + ct)) {
                            dataSum["index"] = "sum" + index;
    
                            if (z == "drY") {
                                dataSum["Name"] = "Default Rate";
                                    if(obj.hasOwnProperty(z+ct)){
    
                                        dataSum["Value" + ct] = obj[z + ct];
                                    }
                            }
                            else if (z == "oedY") {
                                dataSum["Name"] = "Overall Effective Discount(OED)";
                              
                                    if(obj.hasOwnProperty(z+ct)){
                                        dataSum["Value" + ct] = JSON.parse(JSON.stringify(obj[z + ct]));
                                    }
                            }
                            else if (z == "berY") {
                                dataSum["Name"] = "Brand Effective Rate(BER)";
                               
                                    if(obj.hasOwnProperty(z+ct)){
                                        dataSum["Value" + ct] = JSON.parse(JSON.stringify(obj[z + ct]));
                                    }
    
                            }
                            else if (z == "gerY") {
                                dataSum["Name"] = "Generic Effective Discount(GER)";
                               
                                    if(obj.hasOwnProperty(z+ct)){
                                        dataSum["Value" + ct] = JSON.parse(JSON.stringify(obj[z + ct]));
                                    }
                            }
                            else if (z == "merY") {
                                dataSum["Name"] = "MAC Effective Discount(MER)";
                               
                                    if(obj.hasOwnProperty(z+ct)){
                                        dataSum["Value" + ct] = JSON.parse(JSON.stringify(obj[z + ct]));
                                    }
                            }
                            else {
                                dataSum["Name"] = "Dispensing Fee";
                              
                                    if(obj.hasOwnProperty(z+ct)){
                                        dataSum["Value" + ct] = obj[z + ct];
                                    }
                            }
                        }
                        else{
                             dataSum["Value" + ct] = [{ "Rate": "", "Id": 'ratenull' + ct + index }]
                        }
                        
                    }
                    if (Object.keys(dataSum).length > 0) {
                        testsummaryData.push(dataSum);
                    }                    
                });
            }
            this.summaryData = testsummaryData;
            if (this.summaryData.length > 0) {
                this.sumhasData = true;
            }
        } else if (error) {
            alert(JSON.stringify(error));
        }
    }
    mapSummaryProperty(obj, data, maxYear, z) {
        for (let zd = 1; zd < maxYear + 1; zd++) {
            obj["Value" + zd] = data[z + zd];
        };
    }
    @wire(getPharmacyBenefit, { specOpId: '$specOpId', fafId: '$fafId' })
    wiredPharmacyBenefit({ data, error }) {
        if (data) {
            if (data != 'Client Choice') {
                this.pharmacyBenefit = data;
            }
            else {
                this.pharmacyBenefit = '';
            }
        }
        else if (error) {
            alert(JSON.stringify(error));
        }
    }

    searchField(event) {
        var currentText = event.target.value.toLowerCase();
        this.selectRecordName = event.target.value;
        this.LoadingText = true;
        this.searchRecords = [];
        if (currentText.length > 0) {
            if (this.selectedColumn == "Drug Therapy") {
                this.drugTherapys.forEach(ax => {
                    if (ax.option.toLowerCase().includes(currentText)) {
                        this.searchRecords.push(ax);

                    }
                });
            }
            else if (this.selectedColumn == "Drug Name") {
                this.drugNames.forEach(ax => {
                    if (ax.option.toLowerCase().includes(currentText)) {
                        this.searchRecords.push(ax);
                    }
                });

            }
            else {
                if (this.allYear) {
                    this.awpRates.forEach(ax => {
                        if (ax.option.toLowerCase().includes(currentText)) {
                            this.searchRecords.push(ax);
                        }
                    });
                }
                else {
                    if (this.selectedColumn == "Year1") {
                        this.yearsOptions.Year1.forEach(ax => {
                            if (ax.option.toLowerCase().includes(currentText)) {
                                this.searchRecords.push(ax);
                            }
                        });
                    }
                    else if (this.selectedColumn == "Year2") {
                        this.yearsOptions.Year2.forEach(ax => {
                            if (ax.option.toLowerCase().includes(currentText)) {
                                this.searchRecords.push(ax);
                            }
                        });
                    }
                    else if (this.selectedColumn == "Year3") {
                        this.yearsOptions.Year3.forEach(ax => {
                            if (ax.option.toLowerCase().includes(currentText)) {
                                this.searchRecords.push(ax);
                            }
                        });
                    }
                    else if (this.selectedColumn == "Year4") {
                        this.yearsOptions.Year4.forEach(ax => {
                            if (ax.option.toLowerCase().includes(currentText)) {
                                this.searchRecords.push(ax);
                            }
                        });
                    }
                    else {
                        this.yearsOptions.Year5.forEach(ax => {
                            if (ax.option.toLowerCase().includes(currentText)) {
                                this.searchRecords.push(ax);
                            }
                        });
                    }
                }
            }
            if (currentText.length > 0 && this.searchRecords.length == 0) {
                this.searchRecords.push({ key: 'x', option: 'No Search Result Found..' });
            }
            else {
                this.messageFlag = false;
            }
            this.LoadingText = false;
            this.txtclassname = this.searchRecords.length > 0 ? 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open' : 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
            if (this.selectRecordId != null && this.selectRecordId.length > 0) {
                this.iconFlag = false;
                this.clearIconFlag = true;
            }
            else {
                this.iconFlag = true;
                this.clearIconFlag = false;
            }
        }
        else {
            this.iconFlag = true;
            this.clearIconFlag = false;
            this.txtclassname = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
            this.LoadingText = false;
        }
    }

    searchData(event) {
        this.txtclassname = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
        let rawData = this.unfilteredData;
        let filteredData = [];
        if (this.selectedColumn === "Drug Name") {
            filteredData = rawData.filter(drug => drug.Drug_Name__c.toLowerCase().includes(this.selectRecordName.toLowerCase()));
        }
        else if (this.selectedColumn == "Drug Therapy") {
            filteredData = rawData.filter(drug => drug.Drug_Therapy__c.toLowerCase().includes(this.selectRecordName.toLowerCase()));
        }
        else {
            if (this.allYear) {
                filteredData = rawData.filter(drug => drug.Rate__c.toLowerCase().includes(this.selectRecordName.toLowerCase()));
            }
            else {
                if (this.selectedColumn == "Year1") {
                    filteredData = rawData.filter(drug => drug.Year1.toLowerCase().includes(this.selectRecordName.toLowerCase()));
                }
                else if (this.selectedColumn == "Year2") {
                    filteredData = rawData.filter(drug => drug.Year2.toLowerCase().includes(this.selectRecordName.toLowerCase()));
                }
                else if (this.selectedColumn == "Year3") {
                    filteredData = rawData.filter(drug => drug.Year3.toLowerCase().includes(this.selectRecordName.toLowerCase()));
                }
                else if (this.selectedColumn == "Year4") {
                    filteredData = rawData.filter(drug => drug.Year4.toLowerCase().includes(this.selectRecordName.toLowerCase()));
                }
                else {
                    filteredData = rawData.filter(drug => drug.Year5.toLowerCase().includes(this.selectRecordName.toLowerCase()));
                }
    
            }

        }
        if (this.selectRecordName.length == 0) {
            filteredData = this.unfilteredData;
        }
        if (this.drugData.length == 0) {
            this.hasData = false;
        }
        else {

            this.hasData = true;
        }
        this.pageNumber = 1;
        this.filteredData = filteredData;
        this.setRecordsToDisplay(true, filteredData);
    }

    setSelectedRecord(event) {
        this.txtclassname = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
        this.iconFlag = false;
        this.clearIconFlag = true;
        this.selectRecordName = event.currentTarget.dataset.name;
        let rawData = this.unfilteredData;
        let filteredData = [];
        if (this.selectedColumn === "Drug Name") {
            filteredData = rawData.filter(drug => drug.Drug_Name__c.toLowerCase() == event.currentTarget.dataset.name.toLowerCase());
        }
        else if (this.selectedColumn == "Drug Therapy") {
            filteredData = rawData.filter(drug => drug.Drug_Therapy__c.toLowerCase() == event.currentTarget.dataset.name.toLowerCase());
        }
        else {
            if (this.allYear) {
                filteredData = rawData.filter(drug => drug.Rate__c.toLowerCase() == event.currentTarget.dataset.name.toLowerCase());
            }
            else {
                if (this.selectedColumn == "Year1") {
                    filteredData = rawData.filter(drug => drug.Year1.toLowerCase() == event.currentTarget.dataset.name.toLowerCase());
                }
                else if (this.selectedColumn == "Year2") {
                    filteredData = rawData.filter(drug => drug.Year2.toLowerCase() == event.currentTarget.dataset.name.toLowerCase());
                } 
                else if (this.selectedColumn == "Year2") {
                    filteredData = rawData.filter(drug => drug.Year3.toLowerCase() == event.currentTarget.dataset.name.toLowerCase());
                } 
                 else if (this.selectedColumn == "Year4") {
                    filteredData = rawData.filter(drug => drug.Year4.toLowerCase() == event.currentTarget.dataset.name.toLowerCase());
                }
                else {
                    filteredData = rawData.filter(drug => drug.Year5.toLowerCase() == event.currentTarget.dataset.name.toLowerCase());
                }
            }

        }
        if (this.selectRecordName.length == 0) {
            filteredData = this.unfilteredData;
        }
        if (this.drugData.length == 0) {
            this.hasData = false;
        }
        else {

            this.hasData = true;
        }
        this.pageNumber = 1;
        this.filteredData = filteredData;
        this.setRecordsToDisplay(true, filteredData);
    }

    resetData(event) {
        this.selectRecordName = "";
        this.selectRecordId = "";
        this.inputReadOnly = false;
        this.iconFlag = true;

        this.clearIconFlag = false;
        this.setRecordsToDisplay(true, this.unfilteredData);

    }

    sortColumn(event) {
        // if(this.sortedColumn === event.currentTarget.dataset.id){
        //     this.sortedDirection = this.sortedDirection === 'asc' ? 'desc' : 'asc';
        // }else{
        //     this.sortedDirection = 'asc';
        // }        
        // var reverse = this.sortedDirection === 'asc' ? 1 : -1;
        // console.log('reverse:' + reverse);
        // let dataTable = JSON.parse(JSON.stringify(this.drugData));
        // dataTable.sort((sd1,sd2) => {return sd1[event.currentTarget.dataset.id] > sd2[event.currentTarget.dataset.id] ? 1 * reverse : -1 * reverse});
        // this.sortedColumn = event.currentTarget.dataset.id;        
        // this.drugData = dataTable;
        // if(event.currentTarget.dataset.id){

        //     let existingIcon = this.template.querySelectorAll('span[id="sorticon"]');
        //     if(existingIcon[0]){existingIcon[0].parentNode.removeChild(existingIcon[0]);}

        //     let nodes = this.template.querySelectorAll('a[data-id="' + event.currentTarget.dataset.id +'"]')
        //     var sort = document.createElement('span');
        //     if(this.sortedDirection === 'asc'){
        //         sort.innerHTML = '⇧';
        //         //sort.className = 'slds-text-title_bold';
        //     }
        //     if(this.sortedDirection === 'desc'){
        //         sort = document.createElement('span')
        //         sort.innerHTML = '⇩';
        //         //sort.className = 'slds-text-title_bold';
        //     }
        //     sort.setAttribute('id', 'sorticon');
        //     if(nodes[0]){nodes[0].children[0].appendChild(sort);}
        //}
    }
    showAddDrug(event) {
        if (!this.showAddDrugModal) {
            this.showAddDrugModal = true;
        }
    }

    hanldeCloseModal() {
        if (this.showAddDrugModal) {
            this.showAddDrugModal = false;
            return refreshApex(this.wiredDrugListRefresh);
        }
    }
}