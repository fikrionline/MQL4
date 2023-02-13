//+------------------------------------------------------------------+
//|                          PropFirmsDailyDrawdownCloseAllOrder.mq4 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright berasal dari dzat yg memberikan kehidupan pada kita semua"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property description "Bismillahirrohmanirrohim"
#property description "EA ini dibuat untuk close semua order saat menyentuh batas tertentu"
#property description "Dibuat pertama kali pada 10 Januari 2023 di group https://t.me/propfirmstrade"
#property description "----------------------------------------------------"
#property description "Contoh setting:"
#property description "EquityMinStop = 9600; semua oder akan ditutup jika equity di bawah 9600"
#property description "EquityMaxStop = 10808; semua order akan ditutup jika equity di atas 10808 (target tercapai)"

extern double EquityMinStop = 9600.00;
extern double EquityMaxStop = 10808.00;
extern int SlipPage         = 5;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
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
   MinRemoveExpertNow(EquityMinStop);
   MaxRemoveExpertNow(EquityMaxStop);
  }
//+------------------------------------------------------------------+



int MinRemoveExpertNow(double MinimumEquity = 0) {

   if (MinimumEquity > 0 && AccountEquity() < MinimumEquity) {
      RemoveAllOrders();
      RemoveAllOrders();
      RemoveAllOrders();
      ExpertRemove();
   }
   return (0);

}

int MaxRemoveExpertNow(double MaximumEquity = 0) {

   if (MaximumEquity > 0 && AccountEquity() > MaximumEquity) {
      RemoveAllOrders();
      RemoveAllOrders();
      RemoveAllOrders();
      ExpertRemove();
   }
   return (0);

}

void RemoveAllOrders() {
   int TicketOrderSelect, TicketOrderClose, TicketOrderDelete;
   for (int i = OrdersTotal() - 1; i >= 0; i--) {
      TicketOrderSelect = OrderSelect(i, SELECT_BY_POS);
      if (OrderType() == OP_BUY) {
         TicketOrderClose = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), SlipPage, clrNONE);
      } else if (OrderType() == OP_SELL) {
         TicketOrderClose = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), SlipPage, clrNONE);
      } else {
         TicketOrderDelete = OrderDelete(OrderTicket());
      }

      int MessageError = GetLastError();
      if (MessageError > 0) {
         //Print("Unanticipated error " + IntegerToString(MessageError));
      }

      Sleep(99);
      RefreshRates();

   }
}
