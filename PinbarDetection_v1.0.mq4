//+------------------------------------------------------------------+
//|                                             PinbarDetection_v1.0 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern int     TimeZoneGMT = 7;
extern bool    SendAlert = false;
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
      
      string IndicatorSymbol[29];
      IndicatorSymbol[0] = "AUDCAD";
      IndicatorSymbol[1] = "AUDCHF";
      IndicatorSymbol[2] = "AUDJPY";
      IndicatorSymbol[3] = "AUDNZD";
      IndicatorSymbol[4] = "AUDUSD";
      IndicatorSymbol[5] = "CADCHF";
      IndicatorSymbol[6] = "CADJPY";
      IndicatorSymbol[7] = "CHFJPY";
      IndicatorSymbol[8] = "EURAUD";
      IndicatorSymbol[9] = "EURCAD";
      IndicatorSymbol[10] = "EURCHF";
      IndicatorSymbol[11] = "EURGBP";
      IndicatorSymbol[12] = "EURJPY";
      IndicatorSymbol[13] = "EURNZD";
      IndicatorSymbol[14] = "EURUSD";
      IndicatorSymbol[15] = "GBPAUD";
      IndicatorSymbol[16] = "GBPCAD";
      IndicatorSymbol[17] = "GBPCHF";
      IndicatorSymbol[18] = "GBPJPY";
      IndicatorSymbol[19] = "GBPNZD";
      IndicatorSymbol[20] = "GBPUSD";
      IndicatorSymbol[21] = "NZDCAD";
      IndicatorSymbol[22] = "NZDCHF";
      IndicatorSymbol[23] = "NZDJPY";
      IndicatorSymbol[24] = "NZDUSD";
      IndicatorSymbol[25] = "USDCAD";
      IndicatorSymbol[26] = "USDCHF";
      IndicatorSymbol[27] = "USDJPY";
      IndicatorSymbol[28] = "XAUUSD";
      
      string alert_all = GetTimeFrame(Period());
      string alert_up = "PinbarUp";
      string alert_down = "PinbarDown";
      double a, b, c, d;
      int pinbarUp = 0;
      int pinbarDown = 0;
      
      for (int i=0; i<ArraySize(IndicatorSymbol); i++) {
      
         LastOpen = iOpen(IndicatorSymbol[i], Period(), 1);
         LastClose = iClose(IndicatorSymbol[i], Period(), 1);
         LastHigh = iHigh(IndicatorSymbol[i], Period(), 1);
         LastLow = iLow(IndicatorSymbol[i], Period(), 1);
         
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
         
         //if(d>c && d>b && (d/2)>c && (d/2)>b) {
         if(d>c && d>b && (d/2)>c) {
            pinbarUp = 1;
         }
         
         //if(b>c && b>d && (b/2)>c && (b/2)>d) {
         if(b>c && b>d && (b/c)>2) {
            pinbarDown = 1;
         }

         if(pinbarUp == 1) {
            alert_up = alert_up + "\n" + IndicatorSymbol[i];
         }
         
         if(pinbarDown == 1) {
            alert_down = alert_down + "\n" + IndicatorSymbol[i];
         }
         
         pinbarUp = 0;
         pinbarDown = 0;
         
      }
      
      alert_all = alert_all + "\n\n" + alert_up + "\n\n" + alert_down + "\n\n" + TimeToStr(TimeCurrent(), TIME_SECONDS) + " / " + TimeToStr((TimeCurrent() + TimeZoneGMT * 3600), TIME_SECONDS) + " WIB";
      
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
