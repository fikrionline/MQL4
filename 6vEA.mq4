//+------------------------------------------------------------------+
//|                                                         6vEA.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#resource "\\Indicators\\Fikri\\6vI.ex4"
#include <stdlib.mqh>

extern int    MagicNumber = 575899;
extern int    Slippage    = 3;
extern double Lots        = 1;
extern double TakeProfit  = 18;
extern double StopLoss    = 18;

//Check Previous Order
int PosSelect(){

   int posi = 0;
   for(int k = OrdersTotal() - 1; k >= 0; k--){
   
      if(!OrderSelect(k, SELECT_BY_POS)){
         break;
      }
      
      if((OrderSymbol() != Symbol()) && (OrderMagicNumber() != MagicNumber)){
         continue;
      }
      
      if((OrderCloseTime() == 0) && (OrderSymbol() == Symbol()) && (OrderMagicNumber() == MagicNumber)){
         if(OrderType() == OP_BUY){
            posi = 1; //Long position
         }
         if(OrderType() == OP_SELL){
            posi = -1; //Short positon
         }
      }
   }
   return(posi);
}


//Get Signals
int signals(){

   int signal = 0;
   bool ticket_close;
   
   int close_order = 0;
   if(PosSelect() == 1) {
      close_order = -1;
   } else if(PosSelect() == -1){
      close_order = 1;
   }  
   
   if(iCustom(_Symbol, _Period, "::Indicators\\Fikri\\6vI", 6, 1)){
      signal = 1;
      if(close_order == 1){
         ticket_close = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 0, CLR_NONE);
      }
   }
   
   if(iCustom(_Symbol, _Period, "::Indicators\\Fikri\\6vI", 5, 1)){
      signal = -1;
      if(close_order == -1){
         ticket_close = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 0, CLR_NONE);
      }
   }
   
   return signal;
   
}

//Start Code
datetime new_bar;

int start(){

   if(new_bar == Time[0]){
      return(0);
   } else {
      new_bar = Time[0];

      int type;
      double price;
      double sl;
      double tp;
      bool ticket_open;
      
      if(PosSelect() == 0) {
         if(signals() == 1){
            type = OP_BUY;
            price = Ask;
            sl = StopLoss > 0 ? NormalizeDouble(price - (double)StopLoss*_Point,_Digits):0.0;
            tp = TakeProfit > 0 ? NormalizeDouble(price + (double)TakeProfit*_Point,_Digits):0.0;
            ticket_open = OrderSend(_Symbol, type, Lots, price, Slippage, sl, tp, "Timed Trade", MagicNumber, 0, CLR_NONE);
         } else if(signals() == -1){
            type = OP_SELL;
            price = Bid;
            sl = StopLoss > 0 ? NormalizeDouble(price + (double)StopLoss*_Point,_Digits):0.0;
            tp = TakeProfit > 0 ? NormalizeDouble(price - (double)TakeProfit*_Point,_Digits):0.0;
            ticket_open = OrderSend(_Symbol, type, Lots, price, Slippage, sl, tp, "Timed Trade", MagicNumber, 0, CLR_NONE);
         }
      }
      return(1);
   }   
}


