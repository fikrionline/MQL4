//+------------------------------------------------------------------+
//|                                                    OrderTime.mq4 |
//|                                                   BarokahManfaat |
//|                                           https://www.google.com |
//+------------------------------------------------------------------+
#property copyright "BarokahManfaat"
#property link "https://www.google.com"
#property version "1.00"
#property strict
#include <stdlib.mqh>

#define MAGIC 575899

//--- input parameters
input string TimeToOpen = "10:00:09";
input double Lots = 0.4;
input int StopLoss = 93;
input int TakeProfit = 457;

extern int RSI_Period = 2;

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
   for (int i = OrdersHistoryTotal() - 1; i >= 0; i--)
      if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) && OrderSymbol() == _Symbol && OrderMagicNumber() == MAGIC)
         if (OrderOpenTime() > last_trade)
            last_trade = OrderOpenTime();

   if (TimeCurrent() - last_trade < 12 * PeriodSeconds(PERIOD_H1))
      return false;

   for (int i = OrdersTotal() - 1; i >= 0; i--)
      if (OrderSelect(i, SELECT_BY_POS) && OrderSymbol() == _Symbol && OrderMagicNumber() == MAGIC)
         return false;

   return true;
}

bool OpenTrade() {
   int type;
   double price;
   double sl;
   double tp;

   if (GetSignal() == 1) {

      type = OP_BUY;
      price = Ask;
      sl = StopLoss > 0 ? NormalizeDouble(price - (double) StopLoss * _Point, _Digits) : 0.0;
      tp = TakeProfit > 0 ? NormalizeDouble(price + (double) TakeProfit * _Point, _Digits) : 0.0;

   } else if (GetSignal() == -1) {

      type = OP_SELL;
      price = Bid;
      sl = StopLoss > 0 ? NormalizeDouble(price + (double) StopLoss * _Point, _Digits) : 0.0;
      tp = TakeProfit > 0 ? NormalizeDouble(price - (double) TakeProfit * _Point, _Digits) : 0.0;

   }

   return OrderSend(_Symbol, type, Lots, price, 3, sl, tp, "Timed Trade", MAGIC, 0, clrLime) >= 0;

}

int GetSignal() {

   int signal = 0;

   double iRSI_0 = iRSI(Symbol(), PERIOD_CURRENT, RSI_Period, PRICE_OPEN, 0);
   double iRSI_1 = iRSI(Symbol(), PERIOD_CURRENT, RSI_Period, PRICE_OPEN, 1);

   if (iRSI_0 > 85) {
      signal = -1;
   } else if (iRSI_0 < 15) {
      signal = 1;
   } else {

      if (iRSI_0 > iRSI_1) {
         signal = -1;
      } else if (iRSI_0 < iRSI_1) {
         signal = 1;
      }

   }

   return (signal);

}
