@isTest
private class FAFTriggerCheckRecursiveTest {
    @isTest static void FAFCheckRecursiveTestM1() {
        FAFTriggerCheckRecursive.runBeforeUpdate();
        FAFTriggerCheckRecursive.runAfterUpdate();
        
    }
    @isTest static void FAFCheckRecursiveTestM2() {
        FAFTriggerCheckRecursive.runBU = false;
        FAFTriggerCheckRecursive.runAU = false;        
        FAFTriggerCheckRecursive.runBeforeUpdate();
        FAFTriggerCheckRecursive.runAfterUpdate();
        
    }
    
}