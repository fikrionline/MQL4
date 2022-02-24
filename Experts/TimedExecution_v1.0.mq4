//+------------------------------------------------------------------+
//|                                            TimedExecution_v1.mq4 |
//|                                            Copyright 2021, Pipa1 |
//|                               https://www.forexfactory.com/pipa1 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021,Pipa1"
#property link "https://www.forexfactory.com/pipa1"
#property strict

enum orderType {
   LIMIT_ORDER,
   STOP_ORDER
};

enum entryType {
   LONG_ENTRY,
   SHORT_ENTRY,
   LONG_SHORT_ENTRY
};

extern string Info1 = "Single execution every day based on setings";
extern int EntryHour = 10;
extern int EntryMinute = 00;
extern orderType OrderTypeToExecute = LIMIT_ORDER;
extern entryType OrderEntryToExecute = LONG_SHORT_ENTRY;
extern double EntryDistance = 30;
extern double EntryTolerance = 5;
extern double StopLoss = 25;
extern double TakeProfit = 75;
extern double TrailingStop = 35;
extern bool TrailingStopActivate = false;
extern double Lots = 0.1;
bool timerActivated = false;
double POC = 0, sellPOC = 0, buyPOC = 0;
int buyMagic = 9989, sellMagic = 8989;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isBuyOrderActivated() {
   for (int i = OrdersTotal() - 1; i >= 0; i--) {
      if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
         break;
      if (OrderSymbol() == Symbol())
         if (OrderMagicNumber() == buyMagic)
            switch (OrderType()) {
            case OP_BUY:
               return true;
            }

   }
   return false;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isSellOrderActivated() {
   for (int i = OrdersTotal() - 1; i >= 0; i--) {
      if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
         break;
      if (OrderSymbol() == Symbol())
         if (OrderMagicNumber() == sellMagic)
            switch (OrderType()) {
            case OP_SELL:
               return true;
            }

   }
   return false;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OrderTrailingStop() {
   bool result = false;
   for (int i = OrdersTotal() - 1; i >= 0; i--) {
      if (!OrderSelect(i, SELECT_BY_POS))
         break;
      if (OrderSymbol() == Symbol())
         if (OrderMagicNumber() == buyMagic || OrderMagicNumber() == sellMagic)
            switch (OrderType()) {
            case OP_BUY:
               if (Bid - TrailingStop > OrderStopLoss())
                  if (OrderModify(OrderTicket(), Ask, Bid - TrailingStop, OrderOpenPrice() + TakeProfit, 0, Green))
                     result = true;
            case OP_SELL:
               if (Bid + TrailingStop < OrderStopLoss())
                  if (OrderModify(OrderTicket(), Bid, Bid + TrailingStop, OrderOpenPrice() - TakeProfit, 0, Red))
                     result = true;
            }

   }
   return result;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int BuyOrder() {
   int ticket = OrderSend(Symbol(), OP_BUY, Lots, Ask, 3, Ask - StopLoss, Ask + TakeProfit, NULL, buyMagic, 0, clrGreen);
   string msg = (ticket != -1) ? "Buy order placed corectly!" : "Failed to place buy order!";
   Alert(msg);
   return ticket;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int SellOrder() {
   int ticket = OrderSend(Symbol(), OP_SELL, Lots, Bid, 3, Bid + StopLoss, Bid - TakeProfit, NULL, sellMagic, 0, clrRed);
   string msg = (ticket != -1) ? "Sell order placed corectly!" : "Failed to place sell order!";
   Alert(msg);
   return ticket;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit() {
   //---
   if (TrailingStop < StopLoss)
      TrailingStop = StopLoss;
   if (Digits == 3 || Digits == 5) {
      TrailingStop *= (Point * 10);
      EntryDistance *= (Point * 10);
      StopLoss *= (Point * 10);
      TakeProfit *= (Point * 10);
      EntryTolerance *= (Point * 10);
   } else {
      TrailingStop *= Point;
      EntryDistance *= Point;
      StopLoss *= Point;
      TakeProfit *= Point;
      EntryTolerance *= Point;
   }
   // adjust values to Stoplevel
   double StopLevel = MathMin(MarketInfo(Symbol(), MODE_STOPLEVEL), MarketInfo(Symbol(), MODE_FREEZELEVEL));
   if (TrailingStop < StopLevel)
      TrailingStop = StopLevel;
   if (StopLoss < StopLevel)
      StopLoss = StopLevel;
   if (TakeProfit < StopLevel)
      TakeProfit = StopLevel;

   //---
   return (INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawLine(string name, double position, color col) {
   ObjectDelete(name);
   ObjectCreate(0, name, OBJ_HLINE, 0, Time[0], position);
   ObjectSet(name, OBJPROP_STYLE, 2);
   ObjectSet(name, OBJPROP_COLOR, col);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   //---

}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {

   ShowInfo();
   
   //---
   // set timer activated to execute only once at start of the minute
   if (!timerActivated) {
      // Reset POC if didn't executed any entry for 24 hours
      if (Hour() == EntryHour && Minute() == EntryMinute && !isBuyOrderActivated())
         buyPOC = POC;
      if (Hour() == EntryHour && Minute() == EntryMinute && !isSellOrderActivated())
         sellPOC = POC;

      // Record the Bid at given EntryTime
      if (Hour() == EntryHour && Minute() == EntryMinute && buyPOC == POC)
         POC = Bid;
      if (Hour() == EntryHour && Minute() == EntryMinute && sellPOC == POC)
         POC = Bid;

      // set timer activated
      timerActivated = true;
   }

   // Reset timer activated
   if (Minute() != EntryMinute){
      timerActivated = false;
   }

   // Draw the POC and simulated Limit/Stop orders on screen
   if (POC != 0) {
      DrawLine("Poc", POC, DodgerBlue);
      if (OrderTypeToExecute == LIMIT_ORDER) {
         DrawLine("bPoc", POC - EntryDistance, LimeGreen);
         DrawLine("bPocTol", POC - EntryDistance - EntryTolerance, Green);
         DrawLine("sPoc", POC + EntryDistance, Red);
         DrawLine("sPocTol", POC + EntryDistance + EntryTolerance, FireBrick);
      } else
      if (OrderTypeToExecute == STOP_ORDER) {
         DrawLine("bPoc", POC + EntryDistance, LimeGreen);
         DrawLine("bPocTol", POC + EntryDistance + EntryTolerance, Green);
         DrawLine("sPoc", POC - EntryDistance, Red);
         DrawLine("sPocTol", POC - EntryDistance - EntryTolerance, FireBrick);
      }
   }

   // Execute entry if price go above/ below BuyPOC/SellPOC the amount of EntryDistance pips
   // Buy Entries
   if (!isBuyOrderActivated() && POC != 0 && buyPOC != POC) {
      if (OrderEntryToExecute == LONG_ENTRY || OrderEntryToExecute == LONG_SHORT_ENTRY) {
         // Limit orders
         if (OrderTypeToExecute == LIMIT_ORDER) {
            if (Bid <= POC - EntryDistance && Bid >= POC - EntryDistance - EntryTolerance) {
               BuyOrder();
               buyPOC = POC;
            }
         }
         // Stop orders
         else
         if (OrderTypeToExecute == STOP_ORDER) {
            if (Bid >= POC + EntryDistance && Bid <= POC + EntryDistance + EntryTolerance) {
               BuyOrder();
               buyPOC = POC;
            }
         }
      }
   }

   // Sell entries
   if (!isSellOrderActivated() && POC != 0 && sellPOC != POC) {
      if (OrderEntryToExecute == SHORT_ENTRY || OrderEntryToExecute == LONG_SHORT_ENTRY) {
         // Limit orders
         if (OrderTypeToExecute == LIMIT_ORDER) {
            if (Bid >= POC + EntryDistance && Bid <= POC + EntryDistance + EntryTolerance) {
               SellOrder();
               sellPOC = POC;
            }
         }
         // Stop orders
         else
         if (OrderTypeToExecute == STOP_ORDER) {
            if (Bid <= POC - EntryDistance && Bid >= POC - EntryDistance - EntryTolerance) {
               SellOrder();
               sellPOC = POC;
            }
         }
      }
   }

   // Trailing Stop if activated
   if (TrailingStopActivate)
      OrderTrailingStop();

}
//+------------------------------------------------------------------+

void ShowInfo() {

   Comment("",
      "Timed Execution",
      "\nEquity = ", DoubleToString(AccountEquity(), 2)
   );
   
}
