//+------------------------------------------------------------------+
//|                                              OpenTradeAtTime.mq4 |
//|                                      Copyright 2017, nicholishen |
//|                         https://www.forexfactory.com/nicholishen |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, nicholishen"
#property link      "https://www.forexfactory.com/nicholishen"
#property version   "1.00"
#property strict
#include <stdlib.mqh>
#define MAGIC 575899

/*

Scalper pada jam 00 dihitung candle per hari dimulai dari jam 00

*/

enum TRADE_TYPE
{
   BUY,
   SELL,
   FollowTrend
};
//--- input parameters
input string   TimeToOpen = "01:00:01";
input TRADE_TYPE TradeType = FollowTrend;  
input double   Lots = 1;
//input int      StopLoss=308;
//input int      TakeProfit=92;

MqlDateTime time_to_open;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   TimeToStruct(StringToTime(TimeToOpen),time_to_open);
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
   MqlDateTime time;
   TimeCurrent(time);
   time.hour = time_to_open.hour;
   time.min = time_to_open.min;
   time.sec = time_to_open.sec;
   datetime time_current = TimeCurrent();
   datetime time_trade = StructToTime(time); 
   if(time_current >= time_trade && time_current < time_trade+(15*PeriodSeconds(PERIOD_M1)) && CanTrade())
      if(!OpenTrade())
         Print(__FUNCTION__," <!!!> ",ErrorDescription(GetLastError()));
  }
//+------------------------------------------------------------------+

bool CanTrade()
{
   datetime last_trade = 0;
   for(int i=OrdersHistoryTotal()-1;i>=0;i--)
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)&&OrderSymbol()==_Symbol&&OrderMagicNumber()==MAGIC)
         if(OrderOpenTime() > last_trade)
            last_trade=OrderOpenTime();

   if(TimeCurrent()-last_trade < 12*PeriodSeconds(PERIOD_H1))
      return false;
   
   for(int i=OrdersTotal()-1;i>=0;i--)
      if(OrderSelect(i,SELECT_BY_POS)&&OrderSymbol()==_Symbol&&OrderMagicNumber()==MAGIC)
         return false;
  
   return true;
}

bool OpenTrade()
{
   int type;
   double price;
   double sl;
   double tp;
   int ticket_open = 0;
   double tp_sl = MathAbs((iHigh(_Symbol, PERIOD_D1, 1) - iLow(_Symbol, PERIOD_D1, 1)));
   double StopLoss = tp_sl / 2; Print("SL " + DoubleToStr(StopLoss));
   double TakeProfit = tp_sl / 2;Print(" TP " + DoubleToStr(TakeProfit));
   
   double LastOrder = 0;
   int LastOrderSelect;
   int i = OrdersHistoryTotal()-1;
   
   
   LastOrderSelect = OrderSelect(i, SELECT_BY_POS,MODE_HISTORY);  //error was here
   
   if(OrderSymbol()==Symbol() && OrderMagicNumber()==MAGIC)
   
   {
   
       //for buy order
      
       if(OrderType()== OP_BUY && OrderClosePrice() > OrderOpenPrice()) { LastOrder = 1; }
      
       if(OrderType()== OP_BUY && OrderClosePrice() < OrderOpenPrice()) { LastOrder = -1; }
       
       if(OrderType()== OP_SELL && OrderClosePrice() < OrderOpenPrice()) { LastOrder = 1; }
      
       if(OrderType()== OP_SELL && OrderClosePrice() > OrderOpenPrice()) { LastOrder = -1; }
   
   }
   
   double LotsNow = 0;
   if(LastOrder == -1) {
      LotsNow = Lots * 2;
   } else {
      LotsNow = Lots;
   }
 
   if(TradeType == BUY)
   {
      type = OP_BUY;
      price = Ask;
      sl = StopLoss > 0 ? NormalizeDouble(price - (double)StopLoss*_Point,_Digits):0.0;
      tp = TakeProfit > 0 ? NormalizeDouble(price + (double)TakeProfit*_Point,_Digits):0.0;
   }
   else if(TradeType == SELL)
   {
      type = OP_SELL;
      price = Bid;
      sl = StopLoss > 0 ? NormalizeDouble(price + (double)StopLoss*_Point,_Digits):0.0;
      tp = TakeProfit > 0 ? NormalizeDouble(price - (double)TakeProfit*_Point,_Digits):0.0;
   } else {
      if(Signal() == 1){
         type = OP_BUY;
         price = Ask;
         sl = StopLoss > 0 ? NormalizeDouble(price - (double)StopLoss*_Point,_Digits):0.0;
         tp = TakeProfit > 0 ? NormalizeDouble(price + (double)TakeProfit*_Point,_Digits):0.0;
         ticket_open = OrderSend(_Symbol,type,LotsNow,price,3,sl,tp,"Timed Trade",MAGIC,0,clrLime)>=0;
      }
      if(Signal() == -1){
         type = OP_SELL;
         price = Bid;
         sl = StopLoss > 0 ? NormalizeDouble(price + (double)StopLoss*_Point,_Digits):0.0;
         tp = TakeProfit > 0 ? NormalizeDouble(price - (double)TakeProfit*_Point,_Digits):0.0;
         ticket_open = OrderSend(_Symbol,type,LotsNow,price,3,sl,tp,"Timed Trade",MAGIC,0,clrLime)>=0;
      }
   }
   return(true);
}

//Signal
int Signal()
{
   //Get signal from MA and StdDev
   int signal = 0;
   
   if(iClose(_Symbol, PERIOD_D1, 1) > iOpen(_Symbol, PERIOD_D1, 1)){
      signal = 1;
   }
   
   if(iClose(_Symbol, PERIOD_D1, 1) < iOpen(_Symbol, PERIOD_D1, 1)){
      signal = -1;
   }
   
   return(signal);
}
