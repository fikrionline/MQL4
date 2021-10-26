//+------------------------------------------------------------------+
//|                                             PinbarDetection_v1.0 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern int     TimeZoneGMT = 4;
extern bool    SendAlert = true;
extern bool    SendNotif = true;

datetime next_candle;
double LastOpen, LastClose, LastHigh, LastLow;

//init Function
int init() {
   next_candle = Time[0] + Period();
   return (0);
}

//start Function
int start() {
   if (next_candle <= Time[0]) {
      next_candle = Time[0] + Period();
      
      string alert_all = Symbol() + " " + GetTimeFrame(Period());
      double a, b, c, d;
      
      LastOpen = iOpen(Symbol(), Period(), 1);
      LastClose = iClose(Symbol(), Period(), 1);
      LastHigh = iHigh(Symbol(), Period(), 1);
      LastLow = iLow(Symbol(), Period(), 1);
      
      a = MathAbs(LastHigh - LastLow);
      if(LastClose > LastOpen) {
         b = MathAbs(LastHigh - LastClose);
         c = MathAbs(LastClose - LastOpen);
         d = MathAbs(LastOpen - LastLow);
      } else if(LastClose < LastHigh) {
         b = MathAbs(LastHigh - LastOpen);
         c = MathAbs(LastOpen - LastClose);
         d = MathAbs(LastClose - LastLow);
      }
      
      if(d>c && d>b && (d/2)>c && (d/2)>b) {
      //if(d>c && d>b && (d/2)>c) {
         alert_all = alert_all + " Up";
      }
      
      if(b>c && b>d && (b/2)>c && (b/2)>d) {
      //if(b>c && b>d && (b/c)>2) {
         alert_all = alert_all + " Down";
      }
      
      alert_all = alert_all + "\n\n" + TimeToStr(TimeCurrent(), TIME_SECONDS) + " / " + TimeToStr((TimeCurrent() + TimeZoneGMT * 3600), TIME_SECONDS) + " WIB";
      
      if(SendAlert == true) {
         Alert(alert_all);
      }
      if(SendNotif == true) {
         SendNotification(alert_all);
      }

   }
   return(0);
}

//GetTimeFrame
string GetTimeFrame(int GetPeriod)
{
   switch(GetPeriod)
   {
      case 1: return("M1");
      case 5: return("M5");
      case 15: return("M15"); 
      case 30: return("M30");
      case 60: return("H1");
      case 240: return("H4");
      case 1440: return("D1");
      case 10080: return("W1"); 
      case 43200: return("MN1"); 
   }
   
   return IntegerToString(GetPeriod);

}
