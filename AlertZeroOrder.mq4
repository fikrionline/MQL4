//+------------------------------------------------------------------+
//|                                                 AlertNoOrder.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

extern int     TimeZoneGMT = 7;
extern bool    SendAlert = 0;
extern bool    SendNotif = 1;

datetime next_candle;

int init(){
   next_candle = Time[0] + Period();
   return(0);
}

int deinit(){
   return(0);
}

int start(){
   
   if(next_candle <= Time[0]){
      next_candle = Time[0] + Period();
      
      if (OrdersTotal() == 0){
         string alert_text = AccountCompany() + ", " + Symbol() + ", ZeroOrder at " + TimeToStr(TimeCurrent(), TIME_SECONDS) + " or " + TimeToStr((TimeCurrent() + TimeZoneGMT * 3600), TIME_SECONDS) + " WIB";
         if(SendAlert == true) {
            Alert(alert_text);
         }
         if(SendNotif == true) {
            SendNotification(alert_text);
         }
      }
      
   }
   return(0);
}
