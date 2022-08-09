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

extern double EquityMinStopEA = 4400.00;
extern double EquityMaxStopEA = 5404.44;
extern int MagicNumber = 575899;
input string TimeToOpen = "10:00:09";
input double Lots = 0.2;
input int StopLoss = 290;
input int TakeProfit = 460;
extern int RSI_Period = 3;

MqlDateTime time_to_open;

double EquityMin, EquityMax;
int TicketOrderSelect, TicketOrderClose, TicketOrderDelete;

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

   MinRemoveExpertNow(EquityMinStopEA);
   MaxRemoveExpertNow(EquityMaxStopEA);
   
   if(EquityMin == 0) {
      EquityMin = AccountEquity();
   }
   
   if(AccountEquity() < EquityMin) {
      EquityMin = AccountEquity();
   }
   
   if(EquityMax == 0) {
      EquityMax = AccountEquity();
   }
   
   if(AccountEquity() > EquityMax) {
      EquityMax = AccountEquity();
   }

   //---
   MqlDateTime time;
   TimeCurrent(time);
   time.hour = time_to_open.hour;
   time.min = time_to_open.min;
   time.sec = time_to_open.sec;
   datetime time_current = TimeCurrent();
   datetime time_trade = StructToTime(time);
   if (time_current >= time_trade && time_current < time_trade + (15 * PeriodSeconds(PERIOD_M1)) && CanTrade()) {
      if (!OpenTrade()) {
         Print(__FUNCTION__, " <!!!> ", ErrorDescription(GetLastError()));
      }
   }
   
   Info();
   
}
//+------------------------------------------------------------------+

bool CanTrade() {
   datetime last_trade = 0;
   for (int i = OrdersHistoryTotal() - 1; i >= 0; i--)
      if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) && OrderSymbol() == _Symbol && OrderMagicNumber() == MagicNumber)
         if (OrderOpenTime() > last_trade)
            last_trade = OrderOpenTime();

   if (TimeCurrent() - last_trade < 12 * PeriodSeconds(PERIOD_H1))
      return false;

   for (int i = OrdersTotal() - 1; i >= 0; i--)
      if (OrderSelect(i, SELECT_BY_POS) && OrderSymbol() == _Symbol && OrderMagicNumber() == MagicNumber)
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

   return OrderSend(_Symbol, type, Lots, price, 3, sl, tp, "Timed Trade", MagicNumber, 0, clrLime) >= 0;

}

int GetSignal() {

   int signal = 0;
   double ArrowUp, ArrowDown;

   ArrowUp   = iCustom(Symbol(), PERIOD_CURRENT, "ForexIndicatorPro", 0, 1);
   ArrowDown = iCustom(Symbol(), PERIOD_CURRENT, "ForexIndicatorPro", 1, 1);
   
   if(ArrowUp > 0 && ArrowDown < 0)
   {
      signal = 1;
   }
   
   if(ArrowDown > 0 && ArrowUp < 0)
   {
      signal = -1;
   }

   return signal;

}

void Info() {

   Comment("",
      "OrderTimePro EA",
      "\nLots = ", DoubleToString(Lots, 2),
      "\nEquity = ", DoubleToString(AccountEquity(), 2),
      "\nEquity Min = ", DoubleToString(EquityMin, 2),
      "\nEquity Max = ", DoubleToString(EquityMax, 2),
      "\nStopLoss = ", IntegerToString(StopLoss) + " point",
      "\nTakeProfit = ", IntegerToString(TakeProfit) + " point"
   );
   
}

int MinRemoveExpertNow(double MinimumEquity = 0) {
   
   if(MinimumEquity > 0 && AccountEquity() < MinimumEquity) {
      RemoveAllOrders();
      RemoveAllOrders();
      RemoveAllOrders();
      ExpertRemove();
   }
   return(0);
   
}

int MaxRemoveExpertNow(double MaximumEquity = 0) {
   
   if(MaximumEquity > 0 && AccountEquity() > MaximumEquity) {
      RemoveAllOrders();
      RemoveAllOrders();
      RemoveAllOrders();
      ExpertRemove();
   }
   return(0);
   
}

void RemoveAllOrders() {
   for(int i = OrdersTotal() - 1; i >= 0 ; i--)    {
      TicketOrderSelect = OrderSelect(i, SELECT_BY_POS);
      if(OrderType() == OP_BUY) {
         TicketOrderClose = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, clrNONE);
      } else if(OrderType() == OP_SELL) {
         TicketOrderClose = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, clrNONE);
      } else {
         TicketOrderDelete = OrderDelete(OrderTicket());
      }
      
      int MessageError = GetLastError();
      if(MessageError > 0) {
         Print("Unanticipated error " + IntegerToString(MessageError));
      }
      
      Sleep(100);      
      RefreshRates();
      
   }
}
