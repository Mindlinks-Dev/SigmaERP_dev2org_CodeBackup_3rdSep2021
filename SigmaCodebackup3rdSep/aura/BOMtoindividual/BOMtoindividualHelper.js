({
	  openModalHelper : function(component, event, helper,data) {
       
        var individual=component.get('v.wrapper');
        var productname= component.get('v.wrapper.record.sigmaerpdev2__Products__c');
        var srlLength = individual[data.parentIndex].IndPros[data.index].eachserialNo?SRP[data.parentIndex].IndPros[data.index].eachserialNo.length:0;
        var serialData = component.get("v.wrapper")[data.parentIndex].IndPros[data.index].eachserialNo;
        //alert(serialData);
        // alert(JSON.stringify(individual[data.parentIndex].IndPros[data.index].eachserialNo));
        var prodName = individual[data.parentIndex].IndPros[data.index].productname;
        component.set('v.selectedProdName',prodName);
        var serialList = [];
        if(srlLength >0 && srlLength == data.qty)
        {
           
            serialList = serialData;
        }
        else if(srlLength >0 && data.qty > srlLength)
        {
            serialList = serialData;
          //   alert('serialList-->'+serialList);
          //  alert('data.qty-->'+data.qty);
            for(var i=srlLength;i<data.qty;i++)
            {
               
                serialList[i] = {'sigmaerpdev2__Serial_Number__c':''};
            }
        }
            else if(srlLength >0 && data.qty < srlLength)
            {
               //  alert('data.qty-->'+data.qty);
                for(var i=0;i<data.qty;i++)
                {
                    serialList[i] = serialData[i];
                }
            }else
            {
                for(var i=0;i<data.qty;i++)
                {
                   //  alert('data.qty-->'+data.qty);
                    serialList[i] = {'sigmaerpdev2__Serial_Number__c':''};
                }
            }
        
        //component.set('v.StockReceivingWrap[data.parentIndex].TransLineItems[data.index].serialNo',serialList);
        component.set('v.serials',serialList);	
        component.set('v.openModal',true);
    },
})