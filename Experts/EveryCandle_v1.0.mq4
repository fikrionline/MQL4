//+------------------------------------------------------------------+
//|                                                  EveryCandle.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.1"

extern int StartHour = 7;
extern int EndHour = 21;
extern int MagicNumber = 5758;
extern double Lots = 0.01;
extern double StopLoss = 144;
extern double TakeProfit = 168;
extern int SlipPage = 5;

datetime NextCandle;
int SelectOrder, type;
int TicketOpen = 0;
int TicketClose = 0;
double price, sl, tp, HighLowCandle;

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

   ShowInfo();

   if (NextCandle <= Time[0]) {
      NextCandle = Time[0] + Period();
      // New candle, your trading functions here
      
      if((Hour() >= StartHour && Hour() < EndHour)) {

         //Order when there are no order
         if (PosSelect(MagicNumber) == 0) {
         
            HighLowCandle = (iHigh(Symbol(), PERIOD_CURRENT, 1) - iLow(Symbol(), PERIOD_CURRENT, 1)) / Point(); //Print(HighLowCandle);
            StopLoss = HighLowCandle - MarketInfo(Symbol(), MODE_SPREAD);
            TakeProfit = (HighLowCandle + MarketInfo(Symbol(), MODE_SPREAD)) * 2;
   
            if (GetSignal() == 1) {
   
               type = OP_BUY;
               price = Ask;
               sl = StopLoss > 0 ? NormalizeDouble(price - (double) StopLoss * Point(), Digits()) : 0.0;
               tp = TakeProfit > 0 ? NormalizeDouble(price + (double) TakeProfit * Point(), Digits()) : 0.0;
               TicketOpen = OrderSend(Symbol(), type, Lots, price, SlipPage, sl, tp, IntegerToString(MagicNumber), MagicNumber, 0, Aqua);
   
            } else if (GetSignal() == -1) {
   
               type = OP_SELL;
               price = Bid;
               sl = StopLoss > 0 ? NormalizeDouble(price + (double) StopLoss * Point(), Digits()) : 0.0;
               tp = TakeProfit > 0 ? NormalizeDouble(price - (double) TakeProfit * Point(), Digits()) : 0.0;
               TicketClose = OrderSend(Symbol(), type, Lots, price, SlipPage, sl, tp, IntegerToString(MagicNumber), MagicNumber, 0, Aqua);
   
            }
   
         }
         
      }

   }

   return (0);

}

//Signal
int GetSignal() {

   int SignalResult = 0;
   
   if(iCustom(Symbol(), PERIOD_H1, "JurikFilter", 3, 1) != EMPTY_VALUE) {
      SignalResult = 1;
   }
   
   if(iCustom(Symbol(), PERIOD_H1, "JurikFilter", 4, 1) != EMPTY_VALUE) {
      SignalResult = -1;
   }
   
   return SignalResult;

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


void ShowInfo() {

   Comment("",
      "Timed Execution",
      "\nEquity = ", DoubleToString(AccountEquity(), 2)
   );
   
}
