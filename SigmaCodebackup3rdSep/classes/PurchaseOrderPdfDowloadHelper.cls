public with sharing class PurchaseOrderPdfDowloadHelper 
{

   
    public List<PaginationHelper.POWrapper> polist{get;set;}
    public String purchaseOrderList;

    public PurchaseOrderPdfDowloadHelper() 
    {   
        String purchaseOrderList2=ApexPages.currentPage().getParameters().get('purchaseOrderList');
       
            if(purchaseOrderList2!=null && purchaseOrderList2!='' )
            {
            
                purchaseOrderList=purchaseOrderList2;
                if(purchaseOrderList!=null && purchaseOrderList!='')
                    this.polist=(List<PaginationHelper.POWrapper>)System.JSON.deserialize(purchaseOrderList, List<PaginationHelper.POWrapper>.class);  
                      
            }
        
        
    }
    
    
    public Pagereference  getPurchaseOrderDetails()
    {
       
        return null;
    
    }
    
    }