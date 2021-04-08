//+------------------------------------------------------------------+
//|                                                          ICC.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

extern int MagicNumber = 5758;
extern int SlipPage = 3;
extern double Lots = 2.5;
extern double TakeProfit = 507;
extern double StopLoss = 493;
extern int StartOrderHour = 1;
extern int StopOrderHour = 22;
extern bool AutoOrder = TRUE;

int Ticket_open = 0;
int Ticket_close = 0;

//Signal
int Signal() {

   int signal = 0;

   double chek_order = iCustom(Symbol(), PERIOD_CURRENT, "rsi-divergence-indicator", 0, 1); //Alert(DoubleToString(chek_order));

   if (chek_order < 23) {
      signal = 1;
   }

   if (chek_order > 77) {
      signal = -1;
   }

   return signal;

}

//Check previous order
int PosSelect() {

   int posi = 0;

   for (int k = OrdersTotal() - 1; k >= 0; k--) {
      if (!OrderSelect(k, SELECT_BY_POS)) {
         break;
      }

      if ((OrderSymbol() != Symbol()) && (OrderMagicNumber() != MagicNumber)) {
         continue;
      }

      if ((OrderCloseTime() == 0) && (OrderSymbol() == Symbol()) && (OrderMagicNumber() == MagicNumber)) {
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

//On Tick
void OnTick() {
   int type;
   int LastOP_BUY = 0;
   int LastOP_SELL = 0;
   double price, LevelChecker;
   double sl;
   double tp;

   //Don't order if Saturday or Sunday
   if (DayOfWeek() != 0 || DayOfWeek() != 6) {

      //AutoOrder start from here
      if (AutoOrder == TRUE) {

         if (PosSelect() == 0) {
         
            if(Hour() >= StartOrderHour && Hour() <= StopOrderHour) {
            
               if (Signal() == 1) //Buy signal and no current chart positions exists
               {
                  if(OrderSelect(OrdersHistoryTotal()-1, SELECT_BY_POS, MODE_HISTORY)) {
                     if(OrderMagicNumber() == MagicNumber && OrderType() == OP_BUY) {
                        LastOP_BUY = 1;
                     }
                  }
                  
                  if(LastOP_BUY == 0) {
                     type = OP_BUY;
                     price = Ask;
                     sl = StopLoss > 0 ? NormalizeDouble(price - (double) StopLoss * Point(), Digits()) : 0.0; //Alert(sl);
                     tp = TakeProfit > 0 ? NormalizeDouble(price + (double) TakeProfit * Point(), Digits()) : 0.0;
                     Ticket_open = OrderSend(Symbol(), type, Lots, price, SlipPage, 0, 0, IntegerToString(MagicNumber), MagicNumber, 0, CLR_NONE);
                  }
                  
               }
   
               if (Signal() == -1) //Sell signal and no current chart positions exists
               {
                  if(OrderSelect(OrdersHistoryTotal()-1, SELECT_BY_POS, MODE_HISTORY)) {
                     if(OrderMagicNumber() == MagicNumber && OrderType() == OP_SELL) {
                        LastOP_SELL = 1;
                     }
                  }
                  
                  if(LastOP_SELL == 0) {
                     type = OP_SELL;
                     price = Bid;
                     sl = StopLoss > 0 ? NormalizeDouble(price + (double) StopLoss * Point(), Digits()) : 0.0; //Alert(sl);
                     tp = TakeProfit > 0 ? NormalizeDouble(price - (double) TakeProfit * Point(), Digits()) : 0.0;
                     Ticket_open = OrderSend(Symbol(), type, Lots, price, SlipPage, 0, 0, IntegerToString(MagicNumber), MagicNumber, 0, CLR_NONE);
                  }
                  
               }
               
            }

         } else if (PosSelect() == 1) {

            LevelChecker = iCustom(Symbol(), PERIOD_CURRENT, "rsi-divergence-indicator", 0, 1);
            if (LevelChecker > 50) {
               Ticket_close = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 0, CLR_NONE);
            }

         } else if (PosSelect() == -1) {

            LevelChecker = iCustom(Symbol(), PERIOD_CURRENT, "rsi-divergence-indicator", 0, 1);
            if (LevelChecker < 50) {
               Ticket_close = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 0, CLR_NONE);
            }

         }

      }

   }

}
