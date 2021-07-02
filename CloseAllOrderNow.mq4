//+------------------------------------------------------------------+
//|                                                     CloseAll.mq4 |
//|                                                        Shinigami |
//|                                              Shini1984@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Shinigami"
#property link "Shini1984@gmail.com"
extern bool CloseAll = true;

int TicketAll = 0;

int start() {
   int i = 0;
   if (CloseAll == true) {
      for (i = 0; i < OrdersTotal(); i++) {
         TicketAll = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
         if (OrderType() == OP_BUY) {
            TicketAll = OrderClose(OrderTicket(), OrderLots(), Bid, 3, clrNONE);
            continue;
         }
         if (OrderType() == OP_SELL) {
            TicketAll = OrderClose(OrderTicket(), OrderLots(), Ask, 3, clrNONE);
            continue;
         }
         if (OrderType() == OP_BUYSTOP || OP_BUYLIMIT || OP_SELLSTOP || OP_SELLLIMIT) {
            TicketAll = OrderDelete(OrderTicket());
            continue;
         }
      }
   }
   return (0);
}
//+------------------------------------------------------------------+
