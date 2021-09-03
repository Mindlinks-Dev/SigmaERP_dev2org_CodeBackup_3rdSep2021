({
    getCurrentKeyValue : function(component, event, helper){
        
        //Fetching the Map.
        var mapObject= component.get('v.myMap');
        
        //Fetching the key of the current Iteration.
        var mapKey = component.get('v.key');
        component.set('v.mapValue',mapObject[mapKey]);
        
        //Converting MapObject to Array. 
        var convert_array = Object.entries(mapObject[mapKey]);
        
        //Passing the above array to a Map constructor.
        var innerMap = new Map(convert_array);
        
        //Fetching array of Keys.
        var arrayOfInnerMapKeys = Array.from(innerMap.keys());
        
        //Fetching array of Values.
        var arrayOfInnerMapValues = Array.from(innerMap.values());
        
        var arrayDates = component.get('v.arrDateUI');
        var listOfProductObject = [];
        
        var arrayOfProductAvailable = new Array();
        var totalNeeded = 0;
        
        //Iterating through All the map values to check if ProductNeeded for every date is Null or not.
        for(var i=0;i< arrayOfInnerMapValues.length;i++){
            //If not Null get a cumulative value of product needed across all dates.
            if(arrayOfInnerMapValues[i].productNeeded!=null){
                var productObject = new Object();
                productObject.productNeeded = arrayOfInnerMapValues[i].productNeeded;
                productObject.date = arrayDates[i];
                totalNeeded = totalNeeded + arrayOfInnerMapValues[i].productNeeded;
                listOfProductObject.push(productObject);
            }
            else{
                //If PN is = NULL, then initialise it to 0.
                var productObject = new Object();
                productObject.productNeeded = 0;
                productObject.date = arrayDates[i];
                listOfProductObject.push(productObject);
            }
            //Get all the ProductAvailable Values into one array.
            if(arrayOfInnerMapValues[i].productAvailable!=null){
                arrayOfProductAvailable.push(arrayOfInnerMapValues[i].productAvailable);
                
            }
            else{
                //Nothing.
            }
            
        }
        
        //Iterating through Map Keys to check if the Total Product needed across all dates is > or <= to Product available.
        for(var i=0;i< arrayOfInnerMapKeys.length;i++){
            if(arrayOfInnerMapValues[i].productAvailable!=null){
                if(totalNeeded>arrayOfProductAvailable[i]){
                    
                    component.set('v.red',true);
                }
                else{
                    component.set('v.red',false);
                }
            }
        }
        
        component.set('v.totalProductNeeded',totalNeeded);
        component.set('v.arrayOfInnerMapKeys',arrayOfInnerMapKeys);
        component.set('v.arrayOfInnerMapValues',listOfProductObject);
        
        //Iterating through productAvaible array across all products to make sure that there are no null values.
        for(var i=0;i<arrayOfProductAvailable.length;i++){
            if(arrayOfProductAvailable[i]!=null){
                var productAvailable = arrayOfProductAvailable[i];
                component.set('v.productAvailable',productAvailable);
                break;
            }
        }
    }
})