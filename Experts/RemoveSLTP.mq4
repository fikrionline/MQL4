//+------------------------------------------------------------------+
//|                                                   RemoveSLTP.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link "https://www.mql5.com"
#property version "1.1"
#property strict

//---- input parameters
int SelectOrder, ModifyOrder, cnt;

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start() {
   
   if (OrdersTotal() != 0) {
      for (cnt = 0; cnt < OrdersTotal(); cnt++) {
         SelectOrder = OrderSelect(cnt, SELECT_BY_POS);
         //---------------Modify Order--------------------------
         if (OrderType() == OP_BUY || OrderType() == OP_SELL)
            ModifyOrder = OrderModify(OrderTicket(), OrderOpenPrice(), 0, 0, 0);
         //-----------------------------------------------------
      } // for cnt
   } // if OrdersTotal
   return (0);
} // Start()
//+------------------------------------------------------------------+
