public class FAFTriggerCheckRecursive {
    @TestVisible private static boolean runBU = true;
    @TestVisible private static boolean runAU = true;
        public static boolean runBeforeUpdate(){
        if(runBU){
            runBU=false;
            return true;
        }else{
            return runBU;
        }
    }
     public static boolean runAfterUpdate(){
        if(runAU){
            runAU=false;
            return true;
        }else{
            return runAU;
        }
    }
}