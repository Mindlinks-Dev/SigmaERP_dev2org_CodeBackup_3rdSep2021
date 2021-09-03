/*=====================================================================================
Author : Mahantesh B H
Company : Mindlinks solution Private ltd
Date : 23-12-2019
Description : This class is written to upload the Sales order file from Retailer order community.
===================================================================================================*/
public with sharing class UploadSOctrl {
    @AuraEnabled
    public static responceWrapper UploadSO(String fileName, String base64Data, String contentType)
    {
        responceWrapper ResWrap= new responceWrapper();
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Order__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Order_Price_Book__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Dimension_Tag__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('Account',new Set<String>{'id','name','Exchange_Currency__c','AccountNumber','Email__c','ShippingAddress','sigmaerpdev2__Customer_Type__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('Contact',new set<String>{'id','name'})
           && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new set<String>{'Name','sigmaerpdev2__Product_Price__c','sigmaerpdev2__Stock_Item__c'})   
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new set<String>{'id','sigmaerpdev2__ProductCode__c','sigmaerpdev2__ProductCode__r.Name','sigmaerpdev2__Available_Qty__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Order__c',new set<String>{'id','sigmaerpdev2__Order_Numbers__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'id' ,'name','sigmaerpdev2__Net_Quantity__c', 'sigmaerpdev2__Remaining_Qty_To_Package__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Delivary_Date__c','sigmaerpdev2__Total_Amount__c','sigmaerpdev2__Total_Price__c','sigmaerpdev2__Ordered_Amount__c','sigmaerpdev2__Order_Status__c','sigmaerpdev2__Back_Order__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Dimension_Tag__c',new set<String>{'id','sigmaerpdev2__Account__c','sigmaerpdev2__Base_Credit_Limit__c','sigmaerpdev2__Due_Amount__c','sigmaerpdev2__Ordered_Amount__c','sigmaerpdev2__Paid_Amount__c','sigmaerpdev2__Remaining_Credit_Limit__c'}) 
           
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Order__c',new set<String>{'sigmaerpdev2__Order_Numbers__c','sigmaerpdev2__BillingPersonNew__c','sigmaerpdev2__Billing_Person__c','sigmaerpdev2__Delivary_Date__c','sigmaerpdev2__Currency__c','sigmaerpdev2__Orders_Status__c','sigmaerpdev2__Order_Created_Via__c','sigmaerpdev2__Order_Type__c','sigmaerpdev2__Auto_Allocate__c','sigmaerpdev2__Customer_Email__c','sigmaerpdev2__Shipping_Street__c','sigmaerpdev2__ShippingState__c','sigmaerpdev2__ShippingCountry__c','sigmaerpdev2__ShippingCity__c','sigmaerpdev2__ShippingPostalCode__c','sigmaerpdev2__Customer_Type__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'sigmaerpdev2__Product__c','sigmaerpdev2__Net_Quantity__c', 'sigmaerpdev2__Remaining_Qty_To_Package__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Delivary_Date__c','sigmaerpdev2__Total_Amount__c','sigmaerpdev2__Total_Price__c','sigmaerpdev2__Ordered_Amount__c','sigmaerpdev2__Order_Status__c','sigmaerpdev2__Back_Order__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Dimension_Tag__c',new set<String>{'sigmaerpdev2__Ordered_Amount__c'})
           && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Product_Order_Price_Book__c',new Set<String>{'sigmaerpdev2__Sigma_Order__c'})
           && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Sigma_Order__c',new Set<String>{'sigmaerpdev2__AccountId__c'})
          )
        {
            String[] readCSVData = new String[]{};
                base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
            Blob b = EncodingUtil.base64Decode(base64Data);
            
            boolean NoAccount = false;
            boolean NoStatus = false;
            boolean NoQuantity = false;
            boolean NoProduct = false;
            
            try
            {
                readCSVData = b.toString().split('\n');
                String[] inputvalues = new String[]{};          
                    String[] inputvaluesHeader = new String[]{};
                        inputvaluesHeader = readCSVData[0].split(',');
                System.debug('Test11 '+inputvaluesHeader);
                Integer NoOfCol = inputvaluesHeader.size();
                salesOrderWrap SOwrap;
                Map<String, List<Product_Order_Price_Book__c>>  SOMap = new Map<String, List<Product_Order_Price_Book__c>>();
                List<String> accNumberList = new List<String>();
                List<String> conNumberList = new List<String>();
                List<String> prodList = new List<String>();
                List<String> currList = new List<String>();
                List<String> SaleordList = new List<String>();
                Map<String,Account> accountMap = new Map<String,Account>();
                Map<String,Id> contactMap = new Map<String,Id>();
                Map<String,Product2> productMap = new Map<String,Product2>();
                Map<String,Id> currMap = new Map<String,Id>();
                Map<String,Decimal> ProdInvMap = new Map<String,Decimal>();
                for(Integer i=0; i< NoOfCol; i++)
                {  if(inputvaluesHeader[i].trim() == 'Order Number')
                        NoAccount = true;
                    if(inputvaluesHeader[i].trim() == 'Product Name')
                        NoProduct = true;
                    if(inputvaluesHeader[i].trim() == 'Ordered Quantity')
                        NoQuantity = true;
                }
                
                //Displaying Error Messages for Order number,Product and Quantity
                if(!NoAccount)
                {
                    responceWrapper Errors = new responceWrapper();
                    Errors.errorMessage = 'Order Number Column is missing from the uploading file';
                    Errors.Status = 'Error';
                    return Errors;
                }
                if(!NoProduct)
                {
                    responceWrapper Errors = new responceWrapper();
                    Errors.errorMessage = 'Product column is missing from uploading file';
                    Errors.Status = 'Error';
                    return Errors;
                }
                if(!NoQuantity)
                {
                    responceWrapper Errors = new responceWrapper();
                    Errors.errorMessage = 'Quantity Column is missing from File';
                    Errors.Status = 'Error';
                    return Errors;
                }//till here
                
                //getting Contact, account and userid
                utilityClass.userWrapper ConDetail = utilityClass.Userdetails();
                Id UserId= ConDetail.UserIds;
                User currentuser = ConDetail.Userobj;
                Contact ConId = ConDetail.ContactsId;
                Account Acc = ConDetail.AccountsID;
                
                //getting Account records
               /*for(Account accs : [Select Id,Name,Exchange_Currency__c,AccountNumber,Email__c,ShippingStreet,ShippingState,ShippingCountry,ShippingCity,ShippingPostalCode,Customer_Type__c from Account where Name != null])
                {
                    accountMap.put(accs.Name.toLowerCase().escapeCsv(),accs);    
                }*/
                
                //getting Contact records
                for(Contact conn : [select Id, Name,LastName from Contact where LastName != null])
                {
                    contactMap.put(conn.Name.toLowerCase().escapeCsv(), conn.Id);
                }
                
                //getting Product records
                for(Product2 Prod : [select Id,Name,Product_Price__c,Stock_Item__c from Product2 where Name != null])
                {
                    productMap.put(Prod.Name.trim().toLowerCase().escapeCsv(), Prod);
                }
                
                //getting product inventories
                for(Inventory__c ProdInv : [select Id,ProductCode__c,ProductCode__r.Name,Available_Qty__c from Inventory__c where ProductCode__c != null])
                {
                    if(ProdInv.ProductCode__r.Name != null && ProdInv.ProductCode__r.Name !='')
                        ProdInvMap.put(ProdInv.ProductCode__r.Name.trim().escapeCsv().toLowerCase(), ProdInv.Available_Qty__c);
                }
                
                //getting Sales Order
                for(Sigma_Order__c SalesOrd : [select id,Order_Numbers__c from Sigma_Order__c where Order_Created_Via__c = 'Community'])
                {
                    SaleordList.add(SalesOrd.Order_Numbers__c);
                }
                
                List<Sigma_Order__c> OrderList = new List<Sigma_Order__c>();
                List<Product_Order_Price_Book__c> OrderLineLists = new List<Product_Order_Price_Book__c>();
                Id recordTypeIds = Schema.SObjectType.Sigma_Order__c.getRecordTypeInfosByDeveloperName().get('Product_Order').getRecordTypeId();
                //Reading the file to insert Sales order
                SET<ID> OrderId = new SET<ID>();
                SET<ID> OrderProdID = new SET<ID>();
                SET<ID> AccountID = new SET<ID>();
                List<Product_Order_Price_Book__c> PriceBookdetaie = new List<Product_Order_Price_Book__c>();
                List<Product_Order_Price_Book__c> autostock = new List<Product_Order_Price_Book__c>();
                Map<String,List<String>> OneordOneProd = new Map<String,List<String>>();
                for(Integer i=1;i<readCSVData.size();i++)
                {
                    inputvalues = readCSVData[i].split(',');
                    if(String.isNotBlank(inputvalues[3].trim()) && !productMap.containsKey(inputvalues[3].trim().toLowerCase()))
                    {
                        responceWrapper Errors = new responceWrapper();
                        Errors.errorMessage = 'Product is not Valid at line'+ i;
                        Errors.Status = 'Error';
                        return Errors;
                    }
                    if(!String.isNotBlank(inputvalues[0].trim()))
                    {
                        responceWrapper Errors = new responceWrapper();
                        Errors.errorMessage = 'Order Number should not be blank at line number'+ i;
                        Errors.Status = 'Error';
                        return Errors;
                    }
                    
                    List<Product_Order_Price_Book__c> OrderLineList = new List<Product_Order_Price_Book__c>();
                    String OrderNumber = String.isNotBlank(inputvalues[0].trim()) ? inputvalues[0].trim().escapeCsv() : '';
                    
                    OrderProdID.add(productMap.get(inputvalues[3].trim().toLowerCase()).Id);
                    List<String> ProdNames = new List<String>();
                    AccountID.add(Acc.Id);
                    if(!productMap.get(inputvalues[3].trim().toLowerCase()).Stock_Item__c)
                    {
                        responceWrapper Errors = new responceWrapper();
                        Errors.errorMessage = 'Error at line '+ i+', Product '+productMap.get(inputvalues[3].trim().toLowerCase()).Name +' is not in Stock '+ OrderNumber;
                        Errors.Status = 'Error';
                        return Errors;
                    }
                    if(SaleordList.contains(OrderNumber))
                    {
                        responceWrapper Errors = new responceWrapper();
                        Errors.errorMessage = 'Error at line '+ i+', Sales Order is already created with sales number '+ OrderNumber;
                        Errors.Status = 'Error';
                        return Errors;
                    }
                    Sigma_Order__c SO= new Sigma_Order__c();
                    Product_Order_Price_Book__c SOLine = new Product_Order_Price_Book__c();
                    Product_Order_Price_Book__c BackSOLine = new Product_Order_Price_Book__c();
                    if(!SOMap.containsKey(OrderNumber))
                    {
                        Decimal Avlquant = 0;
                        Avlquant = ProdInvMap.get(inputvalues[3].trim().toLowerCase());
                        SOwrap = new salesOrderWrap();
                        SO.AccountId__c = Acc.Id;
                        SO.Order_Numbers__c = String.isNotBlank(inputvalues[0].trim()) ? inputvalues[0].trim() : '';
                        if(contactMap.containsKey(inputvalues[1].trim().toLowerCase()))
                        {
                            SO.BillingPersonNew__c = contactMap.get(inputvalues[1].trim().toLowerCase());
                        }
                        SO.Billing_Person__c = String.isNotBlank(inputvalues[1].trim()) ? inputvalues[1].trim() : '';
                        SO.Delivary_Date__c = Date.valueof(inputvalues[2].trim());
                        SO.Currency__c = Acc.Exchange_Currency__c;
                        if(Acc.Customer_Type__c == 'Credit Customer')
                            SO.Orders_Status__c = 'Order Confirmed';
                        else
                            SO.Orders_Status__c = 'Submitted';
                        SO.Order_Created_Via__c = 'Community';
                        SO.RecordTypeId = recordTypeIds;
                        SO.Order_Type__c = 'Online';
                        SO.Auto_Allocate__c = true;
                        SO.Customer_Email__c = Acc.Email__c;
                        SO.Shipping_Street__c = Acc.ShippingStreet;
                        SO.ShippingState__c = Acc.ShippingState;
                        SO.ShippingCountry__c = Acc.ShippingCountry;
                        SO.ShippingCity__c = Acc.ShippingCity;
                        SO.ShippingPostalCode__c = Acc.ShippingPostalCode;
                        SO.Customer_Type__c = Acc.Customer_Type__c;
                        OrderList.add(SO);
                        
                        if(String.isNotBlank(inputvalues[3].trim()) && productMap.containsKey(inputvalues[3].trim().toLowerCase()))
                        {
                            ProdNames.add(productMap.get(inputvalues[3].trim().toLowerCase()).Name);
                            OneordOneProd.put(OrderNumber,ProdNames);
                            if(Integer.valueof(inputvalues[4].trim()) <= Avlquant)
                                SOLine.Product__c = productMap.get(inputvalues[3].trim().toLowerCase()).Id;
                            else if(Integer.valueof(inputvalues[4].trim()) > Avlquant)
                            {
                                SOLine.Product__c = productMap.get(inputvalues[3].trim().toLowerCase()).Id;
                                BackSOLine.Product__c = productMap.get(inputvalues[3].trim().toLowerCase()).Id;
                            }
                        }
                        else
                        {
                            responceWrapper Errors = new responceWrapper();
                            Errors.errorMessage = 'Product is not Valid at line'+ i;
                            Errors.Status = 'Error';
                            return Errors;
                        }
                        if(String.isNotBlank(inputvalues[4].trim()) && ProdInvMap.containsKey(inputvalues[3].trim().toLowerCase()))
                        {
                            
                            if(Integer.valueof(inputvalues[4].trim()) <= Avlquant)
                            {
                                SOLine.Net_Quantity__c = String.isNotBlank(inputvalues[4].trim()) ? Decimal.valueof(String.valueof(inputvalues[4].trim())) : 0;
                                SOLine.Remaining_Qty_To_Package__c = String.isNotBlank(inputvalues[4].trim()) ? Decimal.valueof(String.valueof(inputvalues[4].trim())) : 0;
                                SOLine.Quantity__c = String.isNotBlank(inputvalues[4].trim()) ? Decimal.valueof(String.valueof(inputvalues[4].trim())) : 0;
                                //SOLine.Discounts__c = String.isNotBlank(inputvalues[6].trim()) ? Decimal.valueof(inputvalues[6].trim()) : 0.00;
                                SOLine.Delivary_Date__c = String.isNotBlank(inputvalues[5].trim()) ? Date.valueof(inputvalues[5].trim()) : null;
                                //SOLine.Order_Status__c = String.isNotBlank(inputvalues[8].trim()) ? inputvalues[8].trim() : '';
                                if(productMap.get(inputvalues[3].trim().toLowerCase()).Product_Price__c != null)
                                {
                                    SOLine.Total_Amount__c = productMap.get(inputvalues[3].trim().toLowerCase()).Product_Price__c;
                                }
                                else
                                {
                                    
                                    String ErrorData = 'Selling Price is not entered for '+ inputvalues[3].trim().toLowerCase()+' Product';
                                    
                                    createErrorLog.insertError('Community Upload',ErrorData,'While uploading File in Community',null,'','Please enter Selling Price for Product',UserInfo.getUserId());
                                    
                                    responceWrapper Errors = new responceWrapper();
                                    Errors.errorMessage = 'Error Occured while uploading the file, please contact your administrator';
                                    Errors.Status = 'Error';
                                    return Errors;
                                }
                                SOLine.Total_Price__c = Integer.valueof(inputvalues[4].trim()) * productMap.get(inputvalues[3].trim().toLowerCase()).Product_Price__c;
                                SOLine.Ordered_Amount__c = Integer.valueof(inputvalues[4].trim()) * productMap.get(inputvalues[3].trim().toLowerCase()).Product_Price__c;
                                SOLine.Inventory_Status__c = 'Reserve';
                                if(Acc.Customer_Type__c == 'Credit Customer')
                                {
                                    SOLine.Order_Status__c = 'Order Confirmed';
                                    SOLine.Is_Credit_Updated__c = true;
                                }
                                else
                                    SOLine.Order_Status__c = 'Pending';
                                OrderLineList.add(SOLine);
                            }
                            else if (Integer.valueof(inputvalues[4].trim()) > Avlquant)
                            {
                                SOLine.Net_Quantity__c = Avlquant;
                                SOLine.Remaining_Qty_To_Package__c = Avlquant;
                                if(Acc.Customer_Type__c == 'Credit Customer')
                                {
                                    SOLine.Order_Status__c = 'Order Confirmed';
                                    SOLine.Is_Credit_Updated__c = true;
                                }
                                else
                                    SOLine.Order_Status__c = 'Pending';
                                SOLine.Quantity__c = String.isNotBlank(inputvalues[4].trim()) ? Decimal.valueof(String.valueof(inputvalues[4].trim())) : 0;
                                //SOLine.Discounts__c = String.isNotBlank(inputvalues[6].trim()) ? Decimal.valueof(inputvalues[6].trim()) : 0.00;
                                SOLine.Delivary_Date__c = String.isNotBlank(inputvalues[5].trim()) ? Date.valueof(inputvalues[5].trim()) : null;
                                //SOLine.Order_Status__c = String.isNotBlank(inputvalues[8].trim()) ? inputvalues[8].trim() : '';
                                if(productMap.get(inputvalues[3].trim().toLowerCase()).Product_Price__c != null)
                                {
                                    SOLine.Total_Amount__c = productMap.get(inputvalues[3].trim().toLowerCase()).Product_Price__c;
                                }
                                else
                                {
                                    String ErrorData = 'Selling Price is not entered for '+ inputvalues[3].trim().toLowerCase()+' Product';
                                    createErrorLog.insertError('Community Upload',ErrorData,'While uploading File in Community',null,'','Please enter Selling Price for Product',UserInfo.getUserId());
                                    responceWrapper Errors = new responceWrapper();
                                    Errors.errorMessage = 'Error Occured while uploading the file, please contact your administrator';
                                    Errors.Status = 'Error';
                                    return Errors;
                                }
                                SOLine.Total_Price__c = Avlquant * productMap.get(inputvalues[3].trim().toLowerCase()).Product_Price__c;
                                SOLine.Ordered_Amount__c = Avlquant * productMap.get(inputvalues[3].trim().toLowerCase()).Product_Price__c;
                                SOLine.Inventory_Status__c = 'Reserve';
                                OrderLineList.add(SOLine);
                                
                                BackSOLine.Net_Quantity__c = Integer.valueof(inputvalues[4].trim()) - Avlquant;
                                BackSOLine.Remaining_Qty_To_Package__c = Integer.valueof(inputvalues[4].trim()) - Avlquant;
                                //BackSOLine.Discounts__c = String.isNotBlank(inputvalues[6].trim()) ? Decimal.valueof(inputvalues[6].trim()) : 0.00;
                                BackSOLine.Delivary_Date__c = String.isNotBlank(inputvalues[5].trim()) ? Date.valueof(inputvalues[5].trim()) : null;
                                //BackSOLine.Order_Status__c = String.isNotBlank(inputvalues[8].trim()) ? inputvalues[8].trim() : '';
                                BackSOLine.Total_Amount__c = productMap.get(inputvalues[3].trim().toLowerCase()).Product_Price__c;
                                BackSOLine.Total_Price__c = (Integer.valueof(inputvalues[4].trim()) - Avlquant) * productMap.get(inputvalues[3].trim().toLowerCase()).Product_Price__c;
                                BackSOLine.Ordered_Amount__c = (Integer.valueof(inputvalues[4].trim()) - Avlquant) * productMap.get(inputvalues[3].trim().toLowerCase()).Product_Price__c;
                                BackSOLine.Back_Order__c = true;
                                BackSOLine.Inventory_Status__c = 'Reserve';
                                if(Acc.Customer_Type__c == 'Credit Customer')
                                {
                                    BackSOLine.Order_Status__c = 'Order Confirmed';
                                    BackSOLine.Is_Credit_Updated__c = true;
                                }
                                else
                                    BackSOLine.Order_Status__c = 'Pending';
                                OrderLineList.add(BackSOLine);
                                
                            }
                        }
                        SOMap.put(OrderNumber,OrderLineList);
                    }
                    else if(SOMap.containsKey(OrderNumber))
                    {
                        if(!OneordOneProd.get(OrderNumber).contains(productMap.get(inputvalues[3].trim().toLowerCase()).Name))
                        {
                            Decimal Avlquant = 0;
                            Avlquant = ProdInvMap.get(inputvalues[3].trim().toLowerCase());
                            if(String.isNotBlank(inputvalues[3].trim()) && productMap.containsKey(inputvalues[3].trim().toLowerCase()))
                            {
                                if(Integer.valueof(inputvalues[4].trim()) <= Avlquant)
                                    SOLine.Product__c = productMap.get(inputvalues[3].trim().toLowerCase()).Id;
                                else if(Integer.valueof(inputvalues[4].trim()) > Avlquant)
                                {
                                    SOLine.Product__c = productMap.get(inputvalues[3].trim().toLowerCase()).Id;
                                    BackSOLine.Product__c = productMap.get(inputvalues[3].trim().toLowerCase()).Id;
                                }
                            }
                            else
                            {
                                responceWrapper Errors = new responceWrapper();
                                Errors.errorMessage = 'Product is not Valid';
                                Errors.Status = 'Error';
                                return Errors;
                            }
                            if(String.isNotBlank(inputvalues[4].trim()) && ProdInvMap.containsKey(inputvalues[3].trim().toLowerCase()))
                            {
                                
                                if(Integer.valueof(inputvalues[4].trim()) <= Avlquant)
                                {
                                    SOLine.Net_Quantity__c = String.isNotBlank(inputvalues[4].trim()) ? Decimal.valueof(String.valueof(inputvalues[4].trim())) : 0;
                                    SOLine.Remaining_Qty_To_Package__c = String.isNotBlank(inputvalues[4].trim()) ? Decimal.valueof(String.valueof(inputvalues[4].trim())) : 0;
                                    SOLine.Quantity__c = String.isNotBlank(inputvalues[4].trim()) ? Decimal.valueof(String.valueof(inputvalues[4].trim())) : 0;
                                    //SOLine.Discounts__c = String.isNotBlank(inputvalues[6].trim()) ? Decimal.valueof(inputvalues[6].trim()) : 0.00;
                                    SOLine.Delivary_Date__c = String.isNotBlank(inputvalues[5].trim()) ? Date.valueof(inputvalues[5].trim()) : null;
                                    //SOLine.Order_Status__c = String.isNotBlank(inputvalues[8].trim()) ? inputvalues[8].trim() : '';
                                    if(productMap.get(inputvalues[3].trim().toLowerCase()).Product_Price__c != null)
                                    {
                                        SOLine.Total_Amount__c = productMap.get(inputvalues[3].trim().toLowerCase()).Product_Price__c;
                                    }
                                    else
                                    {
                                        String ErrorData = 'Selling Price is not entered for '+ inputvalues[3].trim().toLowerCase()+' Product';
                                        createErrorLog.insertError('Community Upload',ErrorData,'While uploading File in Community',null,'','Please enter Selling Price for Product',UserInfo.getUserId());
                                        responceWrapper Errors = new responceWrapper();
                                        Errors.errorMessage = 'Error Occured while uploading the file, please contact your administrator';
                                        Errors.Status = 'Error';
                                        return Errors;
                                    }
                                    SOLine.Total_Price__c = Integer.valueof(inputvalues[4].trim()) * productMap.get(inputvalues[3].trim().toLowerCase()).Product_Price__c;
                                    SOLine.Ordered_Amount__c = Integer.valueof(inputvalues[4].trim()) * productMap.get(inputvalues[3].trim().toLowerCase()).Product_Price__c;
                                    SOLine.Inventory_Status__c = 'Reserve';
                                    
                                    if(Acc.Customer_Type__c == 'Credit Customer')
                                    {
                                        SOLine.Order_Status__c = 'Order Confirmed';
                                        SOLine.Is_Credit_Updated__c = true;
                                    }  
                                    else
                                        SOLine.Order_Status__c = 'Pending';
                                    OrderLineList.add(SOLine);
                                }
                                else if (Integer.valueof(inputvalues[4].trim()) > Avlquant)
                                {
                                    SOLine.Net_Quantity__c = Avlquant;
                                    SOLine.Remaining_Qty_To_Package__c = Avlquant;
                                    SOLine.Quantity__c = String.isNotBlank(inputvalues[4].trim()) ? Decimal.valueof(String.valueof(inputvalues[4].trim())) : 0;
                                    //SOLine.Discounts__c = String.isNotBlank(inputvalues[6].trim()) ? Decimal.valueof(inputvalues[6].trim()) : 0.00;
                                    SOLine.Delivary_Date__c = String.isNotBlank(inputvalues[5].trim()) ? Date.valueof(inputvalues[5].trim()) : null;
                                    //SOLine.Order_Status__c = String.isNotBlank(inputvalues[8].trim()) ? inputvalues[8].trim() : '';
                                    if(productMap.get(inputvalues[3].trim().toLowerCase()).Product_Price__c != null)
                                    {
                                        SOLine.Total_Amount__c = productMap.get(inputvalues[3].trim().toLowerCase()).Product_Price__c;
                                    }
                                    else
                                    {
                                        String ErrorData = 'Selling Price is not entered for '+ inputvalues[3].trim().toLowerCase()+' Product';
                                        createErrorLog.insertError('Community Upload',ErrorData,'While uploading File in Community',null,'','Please enter Selling Price for Product',UserInfo.getUserId());
                                        responceWrapper Errors = new responceWrapper();
                                        Errors.errorMessage = 'Error Occured while uploading the file, please contact your administrator';
                                        Errors.Status = 'Error';
                                        return Errors;
                                    }
                                    SOLine.Total_Price__c = Avlquant * productMap.get(inputvalues[3].trim().toLowerCase()).Product_Price__c;
                                    SOLine.Ordered_Amount__c = Avlquant * productMap.get(inputvalues[3].trim().toLowerCase()).Product_Price__c;
                                    SOLine.Inventory_Status__c = 'Reserve';
                                    
                                    if(Acc.Customer_Type__c == 'Credit Customer')
                                    {
                                        SOLine.Order_Status__c = 'Order Confirmed';
                                        SOLine.Is_Credit_Updated__c = true;
                                    }
                                    else
                                        SOLine.Order_Status__c = 'Pending';
                                    OrderLineList.add(SOLine);
                                    
                                    BackSOLine.Net_Quantity__c = Integer.valueof(inputvalues[4].trim()) - Avlquant;
                                    BackSOLine.Remaining_Qty_To_Package__c = Integer.valueof(inputvalues[4].trim()) - Avlquant;
                                    //BackSOLine.Discounts__c = String.isNotBlank(inputvalues[6].trim()) ? Decimal.valueof(inputvalues[6].trim()) : 0.00;
                                    BackSOLine.Delivary_Date__c = String.isNotBlank(inputvalues[5].trim()) ? Date.valueof(inputvalues[5].trim()) : null;
                                    //BackSOLine.Order_Status__c = String.isNotBlank(inputvalues[8].trim()) ? inputvalues[8].trim() : '';
                                    BackSOLine.Back_Order__c = true;
                                    BackSOLine.Total_Amount__c = productMap.get(inputvalues[3].trim().toLowerCase()).Product_Price__c;
                                    BackSOLine.Total_Price__c = (Integer.valueof(inputvalues[4].trim()) - Avlquant) * productMap.get(inputvalues[3].trim().toLowerCase()).Product_Price__c;
                                    BackSOLine.Ordered_Amount__c = (Integer.valueof(inputvalues[4].trim()) - Avlquant) * productMap.get(inputvalues[3].trim().toLowerCase()).Product_Price__c;
                                    BackSOLine.Inventory_Status__c = 'Reserve';
                                    if(Acc.Customer_Type__c == 'Credit Customer')
                                    {
                                        BackSOLine.Order_Status__c = 'Order Confirmed';
                                        BackSOLine.Is_Credit_Updated__c = true;
                                    }
                                    else
                                        BackSOLine.Order_Status__c = 'Pending';
                                    OrderLineList.add(BackSOLine);
                                    SOMap.get(OrderNumber).add(BackSOLine);
                                }
                            }
                            SOMap.get(OrderNumber).add(SOLine);
                        }
                    }
                }
                if(OrderList.size() > 0)
                    insert OrderList;
                Decimal TotalOrderAmount = 0.00;
                List<Dimension_Tag__c> Creditamount = new List<Dimension_Tag__c>();
                SET<Dimension_Tag__c> OrdAmtUpdateUnique = new SET<Dimension_Tag__c>();
                List<Dimension_Tag__c> OrdAmtUpdate = new List<Dimension_Tag__c>();
                Creditamount = [select Id,Account__c,Base_Credit_Limit__c,Due_Amount__c,Ordered_Amount__c,Paid_Amount__c,Remaining_Credit_Limit__c from Dimension_Tag__c where Account__c =: Acc.Id];
                
                if(OrderList.size() > 0)
                {
                    for(Sigma_Order__c SiggOrder : OrderList)
                    {
                        for(Product_Order_Price_Book__c SOlines : SOMap.get(SiggOrder.Order_Numbers__c))
                        {
                            SOlines.Sigma_Order__c = SiggOrder.id;
                            //SOMap.get(SiggOrder.Order_Numbers__c).add(SOlines);
                            OrderLineLists.add(SOlines);
                            OrderId.add(SiggOrder.id);
                            TotalOrderAmount += SOlines.Total_Price__c;
                        }
                    }
                }
                
                if(Creditamount.size() > 0 && Acc.Customer_Type__c == 'Credit Customer' && TotalOrderAmount > Creditamount[0].Remaining_Credit_Limit__c)
                {
                    delete  OrderList;
                    responceWrapper Errors = new responceWrapper();
                    Errors.errorMessage = 'Your Credit limit has been exceeded, please add credit to your Account to proceed the Orders';
                    Errors.Status = 'Error';
                    return Errors;
                }
                else
                {
                    Decimal OrderAmt = 0.00;
                    if(OrderLineLists.size() > 0)
                        insert OrderLineLists;
                    
                    utilityClass.DiscountDetails(OrderId,AccountID,OrderProdID);
                    PriceBookdetaie = [Select Id,Sigma_Order__r.No_Picking_Package_Shipment_Required__c,Sigma_Order__c,Sigma_Order__r.AccountId__r.Customer_Type__c,IsInventoryUpdated__c,Product__c,Back_Order__c,Net_Quantity__c,Order_Status__c,Total_Price__c from Product_Order_Price_Book__c where Sigma_Order__c IN : OrderList];
                    if(PriceBookdetaie.size() > 0)
                    {
                        for(Product_Order_Price_Book__c lineitems : PriceBookdetaie)
                        {
                            OrderAmt += lineitems.Total_Price__c;
                            if(lineitems.Back_Order__c != true)
                            {
                                if(lineitems.Sigma_Order__r.AccountId__r.Customer_Type__c == 'Credit Customer')
                                autostock.add(lineitems);
                            }
                        }
                    }
                    if(autostock.size() > 0)
                    {
                        autostockreservation.autostockreserve(autostock);
                    }
                    if(Acc.Customer_Type__c == 'Credit Customer')
                    {
                        Dimension_Tag__c UpdateoRdAmt = new Dimension_Tag__c();
                        UpdateoRdAmt.Id = Creditamount[0].Id;
                        if(Creditamount[0].Ordered_Amount__c == null)
                            UpdateoRdAmt.Ordered_Amount__c = 0.00 + OrderAmt;
                        else                        
                            UpdateoRdAmt.Ordered_Amount__c = Creditamount[0].Ordered_Amount__c + OrderAmt;
                        OrdAmtUpdateUnique.add(UpdateoRdAmt);
                        
                        OrdAmtUpdate.addAll(OrdAmtUpdateUnique);
                        update OrdAmtUpdate;
                    }
                    
                    ResWrap.Status = 'Success';
                    return ResWrap;
                }
                
            }
            catch(exception e)
            {
                System.debug('exception '+e);
                try
                {
                    createErrorLog.insertError('Community Upload',e.getMessage(),'While uploading SO File in Community',null,'',e.getStackTraceString(),UserInfo.getUserId());                          
                }
                catch(exception ex)
                {
                    
                }
                ResWrap.errorMessage ='Errors Occured while uploading the file please contact your administrator';
                ResWrap.Status = 'Error';
                return ResWrap;
            }
        }
        return ResWrap; 
    }
    public class salesOrderWrap
    {
        @AuraEnabled
        public String Customer_Name;
        @AuraEnabled
        public String Sales_OrderNo;
        @AuraEnabled
        public String Billing_person;
        @AuraEnabled
        public Date Order_Date;
        @AuraEnabled
        public String Products; 
        @AuraEnabled
        public Integer Ordered_Quantity;
        @AuraEnabled
        public Decimal Discount;
        @AuraEnabled
        public Date Order_Line_Due_Date;
        @AuraEnabled
        public String Order_Line_Status;
        @AuraEnabled
        public String Currencies;
    }
    public class responceWrapper
    {
        @AuraEnabled
        public String errorMessage;
        @AuraEnabled
        public String Status;
        @AuraEnabled
        public String colName;
        @AuraEnabled
        public Integer rowNumber;
        
    }
}