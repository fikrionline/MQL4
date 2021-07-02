//+------------------------------------------------------------------+
//|                                                  CloseEquity.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern bool    CloseMoreThan = true;
extern double  EquityMoreThan = 53382.99;
extern bool    CloseLessThan = false;
extern double  EquityLessThan = 48000;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

   double EquityNow = AccountEquity();
   string TheComments = "";
  
   if(CloseMoreThan == true) {
      if(EquityNow > EquityMoreThan) {
         CloseAllOrders();
      }
   }
   
   if(CloseLessThan == true) {
      if(EquityNow < EquityLessThan) {
         CloseAllOrders();
      }
   }
   
   TheComments += "EquityNow: " + DoubleToString(EquityNow, 2) + " | CloseMoreThanAt: " + DoubleToString(EquityMoreThan, 2) + " | CloseLessThanAt: " + DoubleToString(EquityLessThan, 2);
   
   Comment(TheComments);
  
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
// Add by Fikri

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

      // Allowed Slippage - the difference between current price and close price.
      int Slippage = 0;

      // Bid and Ask prices for the instrument of the order.
      double BidPrice = MarketInfo(OrderSymbol(), MODE_BID);
      double AskPrice = MarketInfo(OrderSymbol(), MODE_ASK);

      // Closing the order using the correct price depending on the type of order.
      if (OrderType() == OP_BUY) {
         res = OrderClose(OrderTicket(), OrderLots(), BidPrice, Slippage);
      } else if (OrderType() == OP_SELL) {
         res = OrderClose(OrderTicket(), OrderLots(), AskPrice, Slippage);
      } else if (OrderType() == OP_BUYSTOP || OP_BUYLIMIT || OP_SELLSTOP || OP_SELLLIMIT) {
         res = OrderDelete(OrderTicket());
      }

      // If there was an error, log it.
      if (res == false) Print("ERROR - Unable to close the order - ", OrderTicket(), " - ", GetLastError());
   }
}
