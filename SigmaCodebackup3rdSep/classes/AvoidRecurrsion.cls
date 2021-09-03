public class AvoidRecurrsion {
    public static Boolean isFirst = true;
    public static Boolean isFirstAUI = true;
    public static Boolean isFirstAU = true;
    public static Boolean isRecurssive(){
        
        if(isFirst){
            isFirst = false;
           	return true;
        }
        else{
            return isFirst;
        }
    }
    
    public static Boolean isRecurssiveAUI(){
        
        if(isFirstAUI){
            isFirstAUI = false;
           	return true;
        }
        else{
            return isFirstAUI;
        }
    }
    public static Boolean isRecurssiveAU(){
        
        if(isFirstAU){
            isFirstAU = false;
           	return true;
        }
        else{
            return isFirstAU;
        }
    }
}