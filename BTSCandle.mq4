//+------------------------------------------------------------------+
//|                                                    BTSCandle.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

extern int MagicNumber = 5758;
extern int SlipPage = 5;
extern double Lots = 1;

datetime next_candle;
int SelectOrder, typeOrder, GetSignal, GetCandleStatus;
int TicketOpen = 0;
int TicketClose = 0;
double price, sl, tp;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init() {

   next_candle = Time[0] + Period();
   return (0);
   
}

//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit() {

   return (0);
   
}

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start() {

   if (next_candle <= Time[0]) {
      next_candle = Time[0] + Period();
      // New candle, your trading functions here
      
      GetSignal = Signal();
      GetCandleStatus = CandleBearishBullish();

      int total = OrdersTotal();
      for (int i = total - 1; i >= 0; i--) {
         SelectOrder = OrderSelect(i, SELECT_BY_POS);
         int type = OrderType();

         switch (type) {
         
            //Close opened long positions
            case OP_BUY:
               if(GetSignal == -1 || GetCandleStatus == -1) {
                  //TicketClose = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), SlipPage, CLR_NONE);
               }
            break;

            //Close opened short positions
            case OP_SELL:
               if(GetSignal == 1 || GetCandleStatus == 1) {
                  //TicketClose = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), SlipPage, CLR_NONE);
               }
            break;
            
         }

      }
      
      double sl_tp = iHigh(Symbol(), PERIOD_CURRENT, 2) - iLow(Symbol(), PERIOD_CURRENT, 2);

      if (GetSignal == 1) {

         typeOrder = OP_BUY;
         price = Ask;
         sl = price - sl_tp;
         tp = price + sl_tp;
         TicketOpen = OrderSend(Symbol(), typeOrder, Lots, price, SlipPage, sl, tp, IntegerToString(MagicNumber), MagicNumber, 0, CLR_NONE);

      } else if (GetSignal == -1) {
         
         typeOrder = OP_SELL;
         price = Bid;
         sl = price + sl_tp;
         tp = price - sl_tp;
         TicketOpen = OrderSend(_Symbol, typeOrder, Lots, price, SlipPage, sl, tp, IntegerToString(MagicNumber), MagicNumber, 0, CLR_NONE);
         
      }

   }

   return (0);
   
}

//+------------------------------------------------------------------+
//Signal
int Signal() {

   int signal = 0;

   double Candle1Open = iOpen(Symbol(), PERIOD_CURRENT, 1);
   double Candle1Close = iClose(Symbol(), PERIOD_CURRENT, 1);
   
   double Candle2Open = iOpen(Symbol(), PERIOD_CURRENT, 2);
   double Candle2Close = iClose(Symbol(), PERIOD_CURRENT, 2);
   
   double Candle2High = iHigh(Symbol(), PERIOD_CURRENT, 2);
   double Candle2Low = iLow(Symbol(), PERIOD_CURRENT, 2);
   
   if((Candle1Open < Candle1Close) && (Candle2Open > Candle2Close)) {
      if(Candle1Close > Candle2High) {
         signal = 1;
      }
   }
   
   if((Candle1Open > Candle1Close) && (Candle2Open < Candle2Close)) {
      if(Candle1Close < Candle2Low) {
         signal = -1;
      }
   }

   return signal;

}

//+------------------------------------------------------------------+
//Bearish or Bullish
int CandleBearishBullish() {

   int CandleCheck = 0;
   
   double Candle1Open = iOpen(Symbol(), PERIOD_CURRENT, 1);
   double Candle1Close = iClose(Symbol(), PERIOD_CURRENT, 1);
   
   double Candle2Open = iOpen(Symbol(), PERIOD_CURRENT, 2);
   double Candle2Close = iClose(Symbol(), PERIOD_CURRENT, 2);
   
   if(Candle1Open < Candle1Close) {
      CandleCheck = 1;
   }
   
   if(Candle1Open > Candle1Close) {
      CandleCheck = -1;
   }
   
   return CandleCheck;

}
