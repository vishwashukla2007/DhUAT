public class changeDashboardPrintPageController {
    public String getAString(){
        return ApexPages.currentPage().getParameters().get('id');
    }
    public String getTString(){
        return ApexPages.currentPage().getParameters().get('type');
    }
}