@isTest 
public class changeDashboardAlertSchedTest {
	 @isTest 
    static void changeDashboardAlertSchedTestMethod() {
        Test.startTest();
       		changeDashboardAlertSched ab = new changeDashboardAlertSched();
        	String jobId = System.schedule('jobName', '0 5 * * * ?',ab);
        Test.stopTest();
     
    }
}