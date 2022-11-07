//+------------------------------------------------------------------+
//|                                                   TPSL_Price.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link "https://www.mql5.com"
#property version "1.00"
#property strict
//---- input parameters
extern double TakeProfitPrice = 0;
extern double StopLossPrice = 0;
int Faktor, Digt, cnt, SelectOrder, ModifyOrder;
double TPp, SLp;
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start() {
   if (Close[0] > 10) {
      Faktor = 1000;
      Digt = 3;
   } else if (Close[0] < 10) {
      Faktor = 100000;
      Digt = 5;
   }
   if (OrdersTotal() != 0) {
      for (cnt = 0; cnt < OrdersTotal(); cnt++) {
         SelectOrder = OrderSelect(cnt, SELECT_BY_POS);
         //--------------Take Profit--------------------------------
         if (OrderTakeProfit() == 0 && TakeProfitPrice != 0) {
            if (OrderType() == OP_BUY && OrderSymbol() == Symbol()) {
               TPp = TakeProfitPrice;
            }
            if (OrderType() == OP_SELL && OrderSymbol() == Symbol()) {
               TPp = TakeProfitPrice;
            }
         } else
            TPp = OrderTakeProfit();
         //--------------Stop Loss--------------------------------
         if (OrderStopLoss() == 0 && StopLossPrice != 0) {
            if (OrderType() == OP_BUY && OrderSymbol() == Symbol()) {
               SLp = StopLossPrice;
            }
            if (OrderType() == OP_SELL && OrderSymbol() == Symbol()) {
               SLp = StopLossPrice;
            }
         } else
            SLp = OrderStopLoss();
         //---------------Modify Order--------------------------
         if (OrderType() == OP_BUY || OrderType() == OP_SELL)
            ModifyOrder = OrderModify(OrderTicket(), OrderOpenPrice(), SLp, TPp, 0);
         //-----------------------------------------------------
      } // for cnt
   } // if OrdersTotal
   return (0);
} // Start()
//+------------------------------------------------------------------+
