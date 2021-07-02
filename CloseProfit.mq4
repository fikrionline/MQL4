//+------------------------------------------------------------------+
//|                                                  CloseProfit.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern bool    CloseWhileProfit = true;
extern double  ProfitAt = 100;
extern bool    CloseWhileLoss = true;
extern double  LossAt = 100;

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

   double FloatingPlus = 0;
   double FloatingMinus = 0;
   double FloatingOrder = AccountEquity() - AccountBalance();
   string TheComments = "";
   
   if(FloatingOrder > 0) {
      FloatingPlus = FloatingOrder;
   }
   
   if(FloatingOrder < 0) {
      FloatingMinus = MathAbs(FloatingOrder);
   }
  
   if(CloseWhileProfit == true) {
      if(FloatingPlus > ProfitAt) {
         CloseAllOrders();
      }
   }
   
   if(CloseWhileLoss == true) {
      if(FloatingMinus > LossAt) {
         CloseAllOrders();
      }
   }
   
   TheComments += "Floating: " + DoubleToString(FloatingOrder, 2) + " | CloseAt: +" + DoubleToString(ProfitAt, 2) + " | CutLossAt: -" + DoubleToString(LossAt, 2);
   
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
