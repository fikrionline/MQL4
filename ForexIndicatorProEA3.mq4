//+------------------------------------------------------------------+
//|                                         ForexIndicatorProEA1.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link "https://www.mql5.com"
#property version "1.1"
#property strict

extern int MagicNumber = 5758;
extern double Lots = 1;
extern double TakeProfit = 0;
extern double StopLoss = 0;
extern int SlipPage = 5;

datetime NextCandle;
int SelectOrder, type;
int TicketOpen = 0;
int TicketClose = 0;
double price, sl, tp;

//Init
int init() {

   NextCandle = Time[0] + Period();
   return (0);

}

//Deinit
int deinit() {

   return (0);

}

//Start
int start() {

   if (NextCandle <= Time[0]) {
      NextCandle = Time[0] + Period();
      // New candle, your trading functions here

      int CheckPosSelect = PosSelect(MagicNumber);

      if (CheckPosSelect == 1) {

         if (SignalClose() == -1) {
            TicketClose = CloseLast(MagicNumber);
         }

      } else if (CheckPosSelect == -1) {

         if (SignalClose() == 1) {
            TicketClose = CloseLast(MagicNumber);
         }

      }

      //Order when there are no order
      if (PosSelect(MagicNumber) == 0) {

         if (Signal() == 1) {

            type = OP_BUY;
            price = Ask;
            sl = StopLoss > 0 ? NormalizeDouble(price - (double) StopLoss * Point(), Digits()) : 0.0;
            tp = TakeProfit > 0 ? NormalizeDouble(price + (double) TakeProfit * Point(), Digits()) : 0.0;
            TicketOpen = OrderSend(Symbol(), type, Lots, price, SlipPage, sl, tp, IntegerToString(MagicNumber), MagicNumber, 0, Aqua);

         } else if (Signal() == -1) {

            type = OP_SELL;
            price = Bid;
            sl = StopLoss > 0 ? NormalizeDouble(price + (double) StopLoss * Point(), Digits()) : 0.0;
            tp = TakeProfit > 0 ? NormalizeDouble(price - (double) TakeProfit * Point(), Digits()) : 0.0;
            TicketClose = OrderSend(Symbol(), type, Lots, price, SlipPage, sl, tp, IntegerToString(MagicNumber), MagicNumber, 0, Aqua);

         }

      }

   }

   return (0);

}

//Signal
int Signal() {

   int signal = 0;
   double ArrowUpM1, ArrowDownM1, ArrowUpM5, ArrowDownM5;
   
   ArrowUpM1 = iCustom(Symbol(), PERIOD_M5, "ForexIndicatorPro", 0, 1);
   ArrowDownM1 = iCustom(Symbol(), PERIOD_M5, "ForexIndicatorPro", 1, 1);

   ArrowUpM5 = iCustom(Symbol(), PERIOD_M15, "ForexIndicatorPro", 0, 1);
   ArrowDownM5 = iCustom(Symbol(), PERIOD_M15, "ForexIndicatorPro", 1, 1);

   if (ArrowUpM1 > 0 && ArrowDownM1 < 0 && ArrowUpM5 > 0 && ArrowDownM5 < 0) {
      signal = 1;
   }

   if (ArrowDownM1 > 0 && ArrowUpM1 < 0 && ArrowDownM5 > 0 && ArrowUpM5 < 0) {
      signal = -1;
   }

   return signal;

}

//Signal
int SignalClose() {

   int signal = 0;
   double ArrowUp, ArrowDown;

   ArrowUp = iCustom(Symbol(), PERIOD_M5, "ForexIndicatorPro", 0, 1);
   ArrowDown = iCustom(Symbol(), PERIOD_M5, "ForexIndicatorPro", 1, 1);

   if (ArrowUp > 0 && ArrowDown < 0) {
      signal = 1;
   }

   if (ArrowDown > 0 && ArrowUp < 0) {
      signal = -1;
   }

   return signal;

}

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

//CloseLastBuy -------------------------------------------------------------------------------
int CloseLast(int CheckMagicNumber) {
   int i_ticket = OrdersTotal() - 1;

   if (i_ticket > -1 && OrderSelect(i_ticket, SELECT_BY_POS)) {

      if (OrderSymbol() == Symbol() && OrderMagicNumber() == CheckMagicNumber) {

         if (OrderType() == OP_BUY) {
            if (OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(MarketInfo(Symbol(), MODE_BID), (int) MarketInfo(Symbol(), MODE_DIGITS)), SlipPage, Yellow)) {
               return (1); //close ok
            }
         }

         if (OrderType() == OP_SELL) {
            if (OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(MarketInfo(Symbol(), MODE_ASK), (int) MarketInfo(Symbol(), MODE_DIGITS)), SlipPage, Yellow)) {
               return (1); //close ok
            }
         }

      }

   }

   return (-1); //error while closing

}
