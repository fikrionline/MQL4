//+------------------------------------------------------------------+
//|                                                  TPSL-Insert.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//---- input parameters
extern double TakeProfitPips = 3000;
extern double StopLossPips = 1000;
int Faktor, Digt, cnt;
double TPp, SLp;

//Start
int start() {

   int SelectOrder, ModifyOrder;

   if (Close[0] > 10) {
      Faktor = 1000;
      Digt = 3;
   } else
   if (Close[0] < 10) {
      Faktor = 100000;
      Digt = 5;
   }

   if (OrdersTotal() != 0) {
      for (cnt = 0; cnt < OrdersTotal(); cnt++) {
         SelectOrder = OrderSelect(cnt, SELECT_BY_POS);

         //--------------Take Profit--------------------------------

         if (OrderTakeProfit() == 0 && TakeProfitPips != 0) {
            if (OrderType() == OP_BUY && OrderSymbol() == Symbol()) {
               TPp = OrderOpenPrice() + TakeProfitPips / Faktor;
            }
            if (OrderType() == OP_SELL && OrderSymbol() == Symbol()) {
               TPp = OrderOpenPrice() - TakeProfitPips / Faktor;
            }
         } else TPp = OrderTakeProfit();

         //--------------Stop Loss--------------------------------

         if (OrderStopLoss() == 0 && StopLossPips != 0) {
            if (OrderType() == OP_BUY && OrderSymbol() == Symbol()) {
               SLp = OrderOpenPrice() - StopLossPips / Faktor;
            }
            if (OrderType() == OP_SELL && OrderSymbol() == Symbol()) {
               SLp = OrderOpenPrice() + StopLossPips / Faktor;
            }
         } else SLp = OrderStopLoss();

         //---------------Modify Order--------------------------
         if (OrderType() == OP_BUY || OrderType() == OP_SELL)
            ModifyOrder = OrderModify(OrderTicket(), OrderOpenPrice(), SLp, TPp, 0);
         //-----------------------------------------------------

      } // for cnt
   } //if OrdersTotal
   
   return (0);
}
