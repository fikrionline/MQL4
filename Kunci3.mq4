//+------------------------------------------------------------------+
//|                                                       Kunci3.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern int MagicNumber = 5758;
extern double LotOrder = 0.5;
extern int MaxSlipPage = 5;
extern double MultiplierTP = 1;

datetime NextCandle;
int GoSignal, TicketOpen;
double SL, TP;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init() {

   NextCandle = Time[0] + Period();
   return (0);
   
}

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start() {

   if (NextCandle <= Time[0]) {
      NextCandle = Time[0] + Period();
      // New candle, your trading functions here
      
      GoSignal = GetSignal();
      
      if (GoSignal == 1) {
         
         SL = Ask - (iHigh(Symbol(), PERIOD_CURRENT, 1) - iLow(Symbol(), PERIOD_CURRENT, 1));
         TP = Ask + ((iHigh(Symbol(), PERIOD_CURRENT, 1) - iLow(Symbol(), PERIOD_CURRENT, 1)) * MultiplierTP);
         
         TicketOpen = OrderSend(Symbol(), OP_BUY, LotOrder, Ask, MaxSlipPage, SL, TP, IntegerToString(MagicNumber), MagicNumber, 0, CLR_NONE);
      
      } else if (GoSignal == -1) {
         
         SL = Bid + (iHigh(Symbol(), PERIOD_CURRENT, 1) - iLow(Symbol(), PERIOD_CURRENT, 1));
         TP = Bid - ((iHigh(Symbol(), PERIOD_CURRENT, 1) - iLow(Symbol(), PERIOD_CURRENT, 1)) * MultiplierTP);
         
         TicketOpen = OrderSend(Symbol(), OP_SELL, LotOrder, Bid, MaxSlipPage, SL, TP, IntegerToString(MagicNumber), MagicNumber, 0, CLR_NONE);
      
      }
      
   }
   
   return (0);
   
}

//Is candle bullish or bearish
int IsBullishOrBearish(int CandleShift) {

   int BullishOrBearish = 0;
   
   if(iOpen(Symbol(), PERIOD_CURRENT, CandleShift) < iClose(Symbol(), PERIOD_CURRENT, CandleShift)) {
      BullishOrBearish = 1;
   } else if(iOpen(Symbol(), PERIOD_CURRENT, CandleShift) > iClose(Symbol(), PERIOD_CURRENT, CandleShift)) {
      BullishOrBearish = -1;
   }
   
   return BullishOrBearish;

}

//GetSignal
int GetSignal() {

   int SignalOrder = 0;
   
   if(
      IsBullishOrBearish(1) == 1 &&
      IsBullishOrBearish(2) == -1 &&
      IsBullishOrBearish(3) == -1 &&
      iLow(Symbol(), PERIOD_CURRENT, 1) < iLow(Symbol(), PERIOD_CURRENT, 2) &&
      iLow(Symbol(), PERIOD_CURRENT, 2) < iLow(Symbol(), PERIOD_CURRENT, 3) &&
      iClose(Symbol(), PERIOD_CURRENT, 2) < iClose(Symbol(), PERIOD_CURRENT, 3) &&
      iClose(Symbol(), PERIOD_CURRENT, 1) > iLow(Symbol(), PERIOD_CURRENT, 3)
      ) {
      
      SignalOrder = 1;
   
   } else if(IsBullishOrBearish(1) == -1 &&
      IsBullishOrBearish(2) == 1 &&
      IsBullishOrBearish(3) == 1 &&
      iHigh(Symbol(), PERIOD_CURRENT, 1) > iHigh(Symbol(), PERIOD_CURRENT, 2) &&
      iHigh(Symbol(), PERIOD_CURRENT, 2) > iHigh(Symbol(), PERIOD_CURRENT, 3) &&
      iClose(Symbol(), PERIOD_CURRENT, 2) > iClose(Symbol(), PERIOD_CURRENT, 3) &&
      iClose(Symbol(), PERIOD_CURRENT, 1) < iHigh(Symbol(), PERIOD_CURRENT, 3)
      ) {
      
      SignalOrder = -1;
      
   }
   
   return SignalOrder;

}