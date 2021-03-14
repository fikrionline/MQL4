//+------------------------------------------------------------------+
//|                                              PerCandleUSDCAD.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

extern int    MagicNumber = 5758;
extern int    Slippage    = 3;
extern double Lots        = 0.01;
extern double TakeProfit  = 157;
extern double StopLoss    = 93;

int Ticket_open = 0;
int Ticket_close = 0;
int SelectOrder, typeOrder;
double priceOrder, sl, tp;
datetime next_candle;

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
//| expert start function                                            |
//+------------------------------------------------------------------+
int start() {
   //----

   if (next_candle <= Time[0]) {
      next_candle = Time[0] + Period();
      
      if(getSignal() == 1) 
      {
      
         typeOrder = OP_BUY;
         priceOrder = Ask;
         sl = StopLoss > 0 ? NormalizeDouble(priceOrder - (double)StopLoss*_Point,_Digits) : 0.0;
         tp = TakeProfit > 0 ? NormalizeDouble(priceOrder + (double)TakeProfit*_Point,_Digits) : 0.0;
         Ticket_open = OrderSend( Symbol(), typeOrder, Lots, priceOrder, Slippage, sl, tp, "Timed Trade", MagicNumber, 0, Blue);
         
      } else
      if(getSignal() == -1) 
      {
         typeOrder = OP_SELL;
         priceOrder = Bid;
         sl = StopLoss > 0 ? NormalizeDouble(priceOrder + (double)StopLoss*_Point,_Digits) : 0.0;
         tp = TakeProfit > 0 ? NormalizeDouble(priceOrder - (double)TakeProfit*_Point,_Digits) : 0.0;
         Ticket_open = OrderSend(_Symbol, typeOrder, Lots, priceOrder, Slippage, sl, tp, "Timed Trade", MagicNumber, 0, Red);
      }
      
   }
   
   return (0);

}
//+------------------------------------------------------------------+

//Get signal from custom indicator
int getSignal()
{
   int signal = 0;
   
   if(PosSelect() == 0)
   {
      
      double order_sell = iCustom(Symbol(), PERIOD_CURRENT, "PelacakPolaCandle", 0, 1);
      double order_buy = iCustom(Symbol(), PERIOD_CURRENT, "PelacakPolaCandle", 1, 1);
      
      if(order_sell != EMPTY_VALUE)
      {
         signal = -1;
      }
      
      if(order_buy != EMPTY_VALUE)
      {
         signal = 1;
      }
      
   }
   
   return signal;
   
}

//Check previous order
int PosSelect()
{
   int posi = 0;
   
   for(int k = OrdersTotal() - 1; k >= 0; k--)
   {
      if(!OrderSelect(k, SELECT_BY_POS))
      {
         break;
      }
      
      if((OrderSymbol() != Symbol()) && (OrderMagicNumber() != MagicNumber))
      {
         continue;
      }
      
      if((OrderCloseTime() == 0) && (OrderSymbol() == Symbol()) && (OrderMagicNumber() == MagicNumber))
      {
         if(OrderType() == OP_BUY)
         {
            posi = 1; //Long position
         }
         if(OrderType() == OP_SELL)
         {
            posi = -1; //Short positon
         }
      }
   }
   
   return(posi);
   
}

//iCustom(Symbol(), PERIOD_CURRENT, "PelacakPolaCandle", 0, 0);