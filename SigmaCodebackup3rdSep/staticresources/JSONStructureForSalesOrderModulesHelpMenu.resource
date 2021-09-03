{
    "Menu":[
        {
            "chapters":
            [
                {
                    "objectName":"SigmaOrder",
                        "steps":[
                            {
                                "stepNum":1,
                                    "title":"Customer Name",
                                        "content":"<p>Select Pre Approved Customer Account that company is accepting Sales Orders from [ Select from the list of available customer accounts ]</p>"
                                            },
                            {
                                "stepNum":2,
                                    "title":"Billing Person",
                                        "content":"<p>Responsible Staff for Billing [Select from the list of available Contacts]</p>"
                                            },
                            {
                                "stepNum":3,
                                    "title":"Status",
                                        "content":"<p>Status of the Order placed [Select relevant status between Pending or Order Confirmed]</p>"
                                            },
                            {
                                "stepNum":4,
                                    "title":"Exchange Currency",
                                        "content":"<p>Choose the currency if the trading currency with Vendor is other than Company default currency [ Select from list of available predefined exchange currency ]</p>"
                                            },
							{
                                "stepNum":5,
                                    "title":"No Picking, Package And Shipment ",
                                        "content":"<p>Make it true if order does not require Pick,Pack & Ship process [True/False]</p>"
                                            },	
                            {
                                "stepNum":6,
                                    "title":"Product",
                                        "content":"<p>Choose the Product [ Search & Select  from list of available pre approved products ]</p>"
                                            },
                            {
                                "stepNum":7,
                                    "title":"Quantity",
                                        "content":"<p>Enter Number of Quantity[how much Quantity needed]</p>"
                                            }  
                        ]
                },
                {		
                    "objectName":"Picking",
                        "steps":[
                            {
                                "stepNum":1,
                                    "title":"Sales Order Number",
                                        "content":"<p>Choose the Order   [ Select order from list of available  orders ]</p>"
                                            },
                            {
                                "stepNum":2,
                                    "title":"Allocate User",
                                        "content":"<p>Select the name of the staff who will be assigned for Picking the Products for the Order. [Select from list of available values.]</p>"
                                            },
                            {
                                "stepNum":3,
                                    "title":"Bin Barcode",
                                        "content":"<p>Scan the barcode of the Bin or Key In manually. [Accepts Barcode Scan/ Numerical values.]</p>"
                                            },
                            {
                                "stepNum":4,
                                    "title":"Picked Quantity",
                                        "content":"<p>Each right combination of Product & Bin scan increments Quantity or Enter Quantity manually after first successful scan. [Accepts values in Number format.] </p>" 
                                            },
                            {
                                "stepNum":5,
                                    "title":"Scan Product barcode",
                                        "content":"<p>Scan the barcode of the Product or Key In manually. [Accepts Barcode Scan/ Numerical values.]</p>"
                                            }                       
                        ]
                },
                {		
                    "objectName":"Package",
                        "steps":[
                            {
                                "stepNum":1,
                                    "title":"Package Customer",
                                        "content":"<p>Select Pre Approved Customer Account that has sales order to be packaged. [Select from the list of available Customer Accounts.]</p>"
                                            },
                            {
                                "stepNum":2,
                                    "title":"Package Status",
                                        "content":"<p>Select status of the Package. [Select from predefined status]</p>"
                                            },
                            {
                                "stepNum":3,
                                    "title":"Packaged Date",
                                        "content":"<p>Select the Date on which the packaging will be done. [Accepts value in Date format.]</p>"
                                            },
                            {
                                "stepNum":4,
                                    "title":"Select Order",
                                        "content":"<p>Search & Select from list of sales orders for selected Customer Account which are Picked.</p>"
                                            },
                            {
                                "stepNum":5,
                                    "title":"PRODUCT",
                                        "content":"<p>Choose the Product   [ Select Product from list of available  products ]</p>"
                                            },
                            {
                                "stepNum":6,
                                    "title":"ORDERED QUANTITY",
                                        "content":"<p>Enter Number of Quantity[how much Quantity needed]</p>"
                                            },             
                            {
                                "stepNum":7,
                                    "title":"PACKAGED QUANTITY",
                                        "content":"<p>Enter Number of Packaged Quantity[how much Packaged Quantity needed]</p>"
                                            },
                            {
                                "stepNum":8,
                                    "title":"Package Product Status",
                                        "content":"<p>Select Status [ Select one of the relevant status ]</p>"
                                            }
                            
                        ]
                },
                
                {
                    "objectName":"Shipment",
                        "steps":[
                            {
                                "stepNum":1,
                                    "title":"Logistics Name",
                                        "content":"<p>Select Shipment Carrier who is responsible  for Shipping the Order. [Select from predefined values.]</p>"
                                            },
                            {
                                "stepNum":2,
                                    "title":"Delivery Note",
                                        "content":"<p>Enter the Delivery Note Number if required. [Accepts values in Alphanumeric format.]</p>"
                                            },
                            {
                                "stepNum":3,
                                    "title":"Truck Number",
                                        "content":"<p>Enter Truck Number [Accepts values in Alphanumeric format.]</p>"
                                            },
                            {
                                "stepNum":4,
                                    "title":"WayBill/Ref",
                                        "content":"<p>Enter the WayBill/Ref Number if required. [Accepts values in Alphanumeric format.]</p>"
                                            },
                            {
                                "stepNum":5, 
                                    "title":"Delivery Person",
                                        "content":"<p>Enter the name of the Delivery Person. [Accepts values in text format.]</p>"
                                            },    
                            {
                                "stepNum":6,
                                    "title":"Shipment Date",
                                        "content":"<p>Select the Date on which the Order will be Shipped. [Accepts value in Date format.]</p>"
                                            },   
                            {
                                "stepNum":7,
                                    "title":"Shipment Status",
                                        "content":"<p>Select appropriate status of the Shipment. [Select from predefined values.]</p>"
                                            },   
                            {
                                "stepNum":8,
                                    "title":"Consignment Number",
                                        "content":"<p>Enter the Consignment Number if required. [Accepts values in Alphanumeric format.]</p>"
                                            }, 
                            {
                                "stepNum":9,
                                    "title":"Tracking URL",
                                        "content":"<p>Enter Tracking URL that company is dealing with</p>"
                                            }, 
                            {
                                "stepNum":10,
                                    "title":"PACKAGE NUMBER",
                                        "content":"<p>Search & Select from list of packages  which are Packed.</p>"
                                            }, 
                            {
                                "stepNum":11,
                                    "title":"CUSTOMER NAME",
                                        "content":"<p>Choose the Customer Account  [ Select customer  from list of available  customer accounts ]</p>"
                                            }, 
                            {
                                "stepNum":12,
                                    "title":"Shipment Product Status",
                                        "content":"<p>Select Status [ Select one of the relevant status ]</p>"
                                            } 
                            
                            
								
                        ]
                }
                
                
            ]
        }
    ]
}