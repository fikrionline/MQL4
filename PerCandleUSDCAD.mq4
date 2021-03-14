//+------------------------------------------------------------------+
//|                                              PerCandleUSDCAD.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#define m 2147483647

extern int    MagicNumber = 5758;
extern int    Slippage    = 3;
extern double Lots        = 0.01;
extern double TakeProfit  = 107;
extern double StopLoss    = 93;

datetime next_candle;
int Ticket_open = 0;
int Ticket_close = 0;
int SelectOrder, typeOrder;
double priceOrder, sl, tp;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init() {
   //----
   next_candle = Time[0] + Period();
   //----
   return (0);
}

//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit() {
   //----

   //----
   return (0);
}

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start() {
   //----

   if (next_candle <= Time[0]) {
      next_candle = Time[0] + Period();
      // New candle. Your trading functions here
      
      if(CanTrade())
      {
         if(Signal() == 1) 
         {
         
            typeOrder = OP_BUY;
            priceOrder = Ask;
            sl = StopLoss > 0 ? NormalizeDouble(priceOrder - (double)StopLoss*_Point,_Digits) : 0.0;
            tp = TakeProfit > 0 ? NormalizeDouble(priceOrder + (double)TakeProfit*_Point,_Digits) : 0.0;
            Ticket_open = OrderSend( Symbol(), typeOrder, Lots, priceOrder, Slippage, sl, tp, "Timed Trade", MagicNumber, 0, CLR_NONE);
            
         } else
         if(Signal() == -1) 
         {
            typeOrder = OP_SELL;
            priceOrder = Bid;
            sl = StopLoss > 0 ? NormalizeDouble(priceOrder + (double)StopLoss*_Point,_Digits) : 0.0;
            tp = TakeProfit > 0 ? NormalizeDouble(priceOrder - (double)TakeProfit*_Point,_Digits) : 0.0;
            Ticket_open = OrderSend(_Symbol, typeOrder, Lots, priceOrder, Slippage, sl, tp, "Timed Trade", MagicNumber, 0, CLR_NONE);
         }
      }
      
   }
   //----
   return (0);
}
//+------------------------------------------------------------------+

//Check older order
bool CanTrade()
{
   datetime last_trade = 0;
   
   for(int i=OrdersTotal()-1; i>=0; i--)
      if(OrderSelect(i,SELECT_BY_POS)&&OrderSymbol()==_Symbol&&OrderMagicNumber()==MagicNumber)
         return false;
  
   return true;
}

//Signal
int Signal() {

   int signal = 0;

   double uparrow = iCustom(Symbol(), 0, "PelacakPolaCandle", 1, 1);
   if(uparrow != m) {
      signal = 1;
   }
   
   double downarrow = iCustom(Symbol(), 0, "Pelacak Pola Candle", 0, 1);
   if(downarrow != m) {
      signal = -1;
   }
   
   return signal;
   
}
