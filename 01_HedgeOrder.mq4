//+------------------------------------------------------------------+
//|                                                01_HedgeOrder.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern bool    OrderBuy = true;
extern int     MagicNumberBuy = 1;
extern bool    OrderSell = true;
extern int     MagicNumberSell = 3;
extern double  LotSize = 0.1;
extern int     SlipPage = 5;
extern double  Multiplier = 1.1;
extern int     MaxLayer = 33;
extern double  PipStep = 100;
extern double  CloseProfitAt = 1000;
extern double  CutLosstAt = 1000;

int TicketOpen = 0;
double PriceBuy, PriceBuyPending, PriceSell, PriceSellPending, LotSizeBuy, LotSizeSell;

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {

   if(OrderBuy == true) {
   
      if(PosSelect(MagicNumberBuy) == 0) {
      
         PriceBuy = MarketInfo(Symbol(), MODE_ASK);
         TicketOpen = OrderSend(Symbol(), OP_BUY, LotSize, PriceBuy, SlipPage, 0, 0, IntegerToString(MagicNumberBuy), MagicNumberBuy, 0, clrNONE);
         
         LotSizeBuy = LotSize;
         for(int i=1; i<MaxLayer; i++) {
            LotSizeBuy = LotSizeBuy * Multiplier;
            PriceBuyPending = PriceBuy + (PipStep * Point) * i;
            TicketOpen = OrderSend(Symbol(), OP_BUYSTOP, LotSizeBuy, PriceBuyPending, SlipPage, 0, 0, IntegerToString(MagicNumberBuy), MagicNumberBuy, 0, clrNONE);
         }
         
      }
      
   }
   
   if(OrderSell == true) {
   
      if(PosSelect(MagicNumberSell) == 0) {
      
         PriceSell = MarketInfo(Symbol(), MODE_BID);
         TicketOpen = OrderSend(Symbol(), OP_SELL, LotSize, PriceSell, SlipPage, 0, 0, IntegerToString(MagicNumberSell), MagicNumberSell, 0, clrNONE);
         
         LotSizeSell = LotSize;
         for(int i=1; i<MaxLayer; i++) {
            LotSizeSell = LotSizeSell * Multiplier;
            PriceSellPending = PriceSell - (PipStep * Point) * i;
            TicketOpen = OrderSend(Symbol(), OP_SELLSTOP, LotSizeSell, PriceSellPending, SlipPage, 0, 0, IntegerToString(MagicNumberSell), MagicNumberSell, 0, clrNONE);
         }
         
      }
      
   }
   
}
//+------------------------------------------------------------------+

//Check previous order
int PosSelect(int CheckMagicNumber) {

   int posi = 0;
   for (int k = OrdersTotal() - 1; k >= 0; k--) {
      if (!OrderSelect(k, SELECT_BY_POS)) {
         break;
      }

      if ((OrderSymbol() != Symbol()) && (OrderMagicNumber() != CheckMagicNumber)) {
         continue;
      }

      if ((OrderCloseTime() == 0) && (OrderSymbol() == Symbol()) && (OrderMagicNumber() == CheckMagicNumber)) {
         if (OrderType() == OP_BUY) {
            posi = 1; //Long position
         }
         if (OrderType() == OP_SELL) {
            posi = -1; //Short positon
         }
      }
   }

   return (posi);

}

//Close All Order
void CloseAllOrders() {

   // Update the exchange rates before closing the orders.
   RefreshRates();
   
   // Log in the terminal the total of orders, current and past.
   Print(OrdersTotal());

   // Start a loop to scan all the orders.
   // The loop starts from the last order, proceeding backwards; Otherwise it would skip some orders.
   for (int i = (OrdersTotal() - 1); i >= 0; i--) {
      // If the order cannot be selected, throw and log an error.
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == false) {
         Print("ERROR - Unable to select the order - ", GetLastError());
         break;
      }

      // Create the required variables.
      // Result variable - to check if the operation is successful or not.
      bool res = false;

      // Bid and Ask prices for the instrument of the order.
      double BidPrice = MarketInfo(OrderSymbol(), MODE_BID);
      double AskPrice = MarketInfo(OrderSymbol(), MODE_ASK);

      // Closing the order using the correct price depending on the type of order.
      if (OrderType() == OP_BUY) {
         res = OrderClose(OrderTicket(), OrderLots(), BidPrice, SlipPage);
      } else if (OrderType() == OP_SELL) {
         res = OrderClose(OrderTicket(), OrderLots(), AskPrice, SlipPage);
      }

      // If there was an error, log it.
      if (res == false) {
         Print("ERROR - Unable to close the order - ", OrderTicket(), " - ", GetLastError());
      }
      
   }
   
}
