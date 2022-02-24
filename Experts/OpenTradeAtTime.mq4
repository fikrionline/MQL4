//+------------------------------------------------------------------+
//|                                              OpenTradeAtTime.mq4 |
//|                                      Copyright 2017, nicholishen |
//|                         https://www.forexfactory.com/nicholishen |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, nicholishen"
#property link "https://www.forexfactory.com/nicholishen"
#property version "1.00"
#property strict
#include <stdlib.mqh>

//--- input parameters
input int MagicNumber = 575899;
input string TimeToOpen = "10:00:00";
input double Lots = 0.01;
input int StopLoss = 168;
input int TakeProfit = 268;
input int SlipPage = 5;

MqlDateTime time_to_open;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
   //---
   TimeToStruct(StringToTime(TimeToOpen), time_to_open);
   //---
   return (INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   //---

}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {

   ShowInfo();
   
   //---
   MqlDateTime time;
   TimeCurrent(time);
   time.hour = time_to_open.hour;
   time.min = time_to_open.min;
   time.sec = time_to_open.sec;
   datetime time_current = TimeCurrent();
   datetime time_trade = StructToTime(time);
   if (time_current >= time_trade && time_current < time_trade + (15 * PeriodSeconds(PERIOD_M1)) && CanTrade())
      if (!OpenTrade())
         Print(__FUNCTION__, " <!!!> ", ErrorDescription(GetLastError()));
}
//+------------------------------------------------------------------+

bool CanTrade() {
   datetime last_trade = 0;
   for (int i = OrdersHistoryTotal() - 1; i >= 0; i--) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) && OrderSymbol() == _Symbol && OrderMagicNumber() == MagicNumber) {
         if (OrderOpenTime() > last_trade) {
            last_trade = OrderOpenTime();
         }
      }
   }

   if (TimeCurrent() - last_trade < 12 * PeriodSeconds(PERIOD_H1)) {
      return false;
   }

   for (int i = OrdersTotal() - 1; i >= 0; i--) {
      if (OrderSelect(i, SELECT_BY_POS) && OrderSymbol() == _Symbol && OrderMagicNumber() == MagicNumber) {
         return false;
      }
   }

   return true;
   
}

int OpenTrade() {
   int type, TicketOrder = 0;
   double price, sl, tp;
   
   if (GetSignal() == 1) {
   
      type = OP_BUY;
      price = Ask;
      sl = StopLoss > 0 ? NormalizeDouble(price - (double) StopLoss * _Point, _Digits) : 0.0;
      tp = TakeProfit > 0 ? NormalizeDouble(price + (double) TakeProfit * _Point, _Digits) : 0.0;
      TicketOrder = OrderSend(_Symbol, type, Lots, price, SlipPage, sl, tp, IntegerToString(MagicNumber), MagicNumber, 0, clrLime);
      
   } else if(GetSignal() == -1) {
   
      type = OP_SELL;
      price = Bid;
      sl = StopLoss > 0 ? NormalizeDouble(price + (double) StopLoss * _Point, _Digits) : 0.0;
      tp = TakeProfit > 0 ? NormalizeDouble(price - (double) TakeProfit * _Point, _Digits) : 0.0;
      TicketOrder = OrderSend(_Symbol, type, Lots, price, SlipPage, sl, tp, IntegerToString(MagicNumber), MagicNumber, 0, clrLime);
      
   }
   
   return TicketOrder;
   
}

//GetSignal
int GetSignal() {
   
   int SignalResult = 0;
   
   if(iCustom(Symbol(), PERIOD_H1, "JurikFilter", 3, 1) != EMPTY_VALUE) {
      if(iCustom(Symbol(), PERIOD_H1, "JurikFilter", 3, 1) != EMPTY_VALUE) {
         SignalResult = 1;
      }
   }
   
   if(iCustom(Symbol(), PERIOD_H1, "JurikFilter", 4, 1) != EMPTY_VALUE) {
      if(iCustom(Symbol(), PERIOD_H1, "JurikFilter", 4, 1) != EMPTY_VALUE) {
         SignalResult = -1;
      }
   }
   
   return SignalResult;
   
}


void ShowInfo() {

   Comment("",
      "OpenTradeAtTime",
      "\nEquity = ", DoubleToString(AccountEquity(), 2)
   );
   
}
