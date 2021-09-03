public with sharing class StockReceivingLinesWrap{

    public String transID;
    public List<TransLineItems> TransLineItems;

    public class TransLineItems {
        public String attributeType;    //BULK
        public String productName;  //Product-10
        public Decimal Receiving_Quantity_Original;
        public serialNo[] serialNo;
        public SRLineItemRec SRLineItemRec;
        public String BinId;
        public String BinName;
     //   public String BatchNo;
    }
    public class serialNo {
        public String Id;
        public String Serial_Number;
        public String Stock_Receiving_Product;
    }
    public class SRLineItemRec {
        public String Id;
        public String TransactionID;    //a1v1r000003IG9PAAW
        public String Purchase_Order;   //a1q1r0000020FPTAA2
        public String Product;  //01t1r000006Y8PMAA0
        public Decimal Ordered_Qty; //1000
        public Decimal Quantity_Received;   //0
        public Decimal Remaining_Quantity;  //1000
        public String Status;   //Verified
        public Date Expiry_Date;
        public String Putaway_location;
        public String Lot;
       // public Boolean IsInventoryUpdated=false;
    }

    public static List<StockReceivingLinesWrap> parse(String json){
        return (List<StockReceivingLinesWrap>) System.JSON.deserialize(json, List<StockReceivingLinesWrap>.class);
    }

}