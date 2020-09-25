//+------------------------------------------------------------------+
//|                                                     xtiusd_a.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern int     MagicNumber = 575899;
extern int     Slippage    = 3;
extern double  Lots        = 1;
//extern double  TakeProfit  = 208;
//extern double  StopLoss    = 192;
extern string  TimeToOpen  = "10:00:00";

MqlDateTime time_to_open;

int OnInit(){
   TimeToStruct(StringToTime(TimeToOpen),time_to_open);
   return(INIT_SUCCEEDED);
}

void OnTick(){

   MqlDateTime time;
   TimeCurrent(time);
   time.hour = time_to_open.hour;
   time.min = time_to_open.min;
   time.sec = time_to_open.sec;
   datetime time_current = TimeCurrent();
   datetime time_trade = StructToTime(time); 
   
   if(time_current >= time_trade && time_current < time_trade+(15*PeriodSeconds(PERIOD_M1)) && CanTrade()){
      if(!OpenTrade()){
         Print(__FUNCTION__," Error <!!!> ");
      }
   }
}

bool CanTrade(){
   datetime last_trade = 0;
   for(int i=OrdersHistoryTotal()-1;i>=0;i--)
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)&&OrderSymbol()==_Symbol&&OrderMagicNumber()==MagicNumber)
         if(OrderOpenTime() > last_trade)
            last_trade=OrderOpenTime();

   if(TimeCurrent()-last_trade < 12*PeriodSeconds(PERIOD_H1))
      return false;
   
   for(int i=OrdersTotal()-1;i>=0;i--)
      if(OrderSelect(i,SELECT_BY_POS)&&OrderSymbol()==_Symbol&&OrderMagicNumber()==MagicNumber)
         return false;
  
   return true;
}

bool OpenTrade(){
   
   int type, ticket_open;
   double sl_tp, StopLoss, TakeProfit, price, sl, tp;
   
   if(PosSelect() == 0){
   
      int signal = 0;
      
      if(iClose(Symbol(), PERIOD_H1, 1) > iOpen(Symbol(), PERIOD_H1, 3)) {
         signal = -1;
      }
      
      if(iClose(Symbol(), PERIOD_H1, 1) < iOpen(Symbol(), PERIOD_H1, 3)) {
         signal = 1;
      }
      
      sl_tp = MathAbs(iClose(Symbol(), PERIOD_H1, 1) - iOpen(Symbol(), PERIOD_H1, 3));
      
      if(Digits<4){
         sl_tp=sl_tp*1000;
      } else {
         sl_tp=sl_tp*100000;
      }
      
      StopLoss = sl_tp;
      TakeProfit = sl_tp;
      
      StopLoss = 92;
      TakeProfit = 208;
      
      signal = 1;
      if(signal == 1){//Buy signal and no current chart positions exists
         type = OP_BUY;
         price = Ask;
         sl = StopLoss > 0 ? NormalizeDouble(price - (double)StopLoss*_Point,_Digits):0.0;
         tp = TakeProfit > 0 ? NormalizeDouble(price + (double)TakeProfit*_Point,_Digits):0.0;
         ticket_open = OrderSend(_Symbol, type, Lots, price, Slippage, sl, tp, "Timed Trade", MagicNumber, 0, CLR_NONE);
      }
      
      signal = -1;
      if(signal == -1){//Sell signal and no current chart positions exists
         type = OP_SELL;
         price = Bid;
         sl = StopLoss > 0 ? NormalizeDouble(price + (double)StopLoss*_Point,_Digits):0.0;
         tp = TakeProfit > 0 ? NormalizeDouble(price - (double)TakeProfit*_Point,_Digits):0.0;
         ticket_open = OrderSend(_Symbol, type, Lots, price, Slippage, sl, tp, "Timed Trade", MagicNumber + 1, 0, CLR_NONE);
      }
   }
   
   return true;

}

//Check previous order
int PosSelect(){
   int previous_position = 0;
   for(int k = OrdersTotal() - 1; k >= 0; k--){
      if(!OrderSelect(k, SELECT_BY_POS)){
         break;
      }
      
      if((OrderSymbol() != Symbol()) && (OrderMagicNumber() != MagicNumber)){
         continue;
      }
      
      if((OrderCloseTime() == 0) && (OrderSymbol() == Symbol()) && (OrderMagicNumber() == MagicNumber)){
         if(OrderType() == OP_BUY)
         {
            previous_position = 1; //Long position
         }
         if(OrderType() == OP_SELL)
         {
            previous_position = -1; //Short positon
         }
      }
   }
   
   return(previous_position);

}
