//+------------------------------------------------------------------+
//| Candle Closing Time Remaining-(CCTR).mq4                           |
//| Copyright 2013,Foad Tahmasebi                                    |
//| Version 2.0                                                      |
//| http://www.daskhat.ir                                            |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013,Foad Tahmasebi"
#property link "http://www.daskhat.ir"

#property indicator_chart_window
//--- input parameters

extern int location = 1;
extern int Left_Right = 5;
extern int Up_Down = 5;
extern int displayServerTime = 0;
extern int FontSize = 10;
extern color colour = Red;

//--- variables
double leftTime;
string sTime;
int days;
string sCurrentTime;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init() {
   //---- indicators
   if (location != 0) {
      ObjectCreate("BarTime", OBJ_LABEL, 0, 0, 0);
      ObjectSet("BarTime", OBJPROP_CORNER, location);
      ObjectSet("BarTime", OBJPROP_XDISTANCE, Left_Right);
      ObjectSet("BarTime", OBJPROP_YDISTANCE, Up_Down);
   }
   return (0);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit() {
   ObjectDelete("BarTime");
   Comment("");
   return (0);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start() {
   sCurrentTime = TimeToStr(TimeCurrent(), TIME_SECONDS);
   leftTime = (Period() * 60) - (TimeCurrent() - Time[0]);
   sTime = TimeToStr(leftTime, TIME_SECONDS);
   if (DayOfWeek() == 0 || DayOfWeek() == 6) {
      if (location == 0) {
         Comment("Candle closing time remaining at " + "Market Is Closed");
      } else {
         ObjectSetText("BarTime", "Market Is Closed", FontSize, "Arial Bold", colour);
      }
   } else {
      if (Period() == PERIOD_MN1 || Period() == PERIOD_W1) {
         days = ((leftTime / 60) / 60) / 24;
         if (location == 0) {
            if (displayServerTime == 0) {
               Comment("Candle closing time remaining at " + days + "D - " + sTime);
            } else {
               Comment("Candle closing time remaining at " + days + "D - " + sTime + " [" + sCurrentTime + "]");
            }
         } else {
            if (displayServerTime == 0) {
               ObjectSetText("BarTime", days + "D - " + sTime, FontSize, "Arial Bold", colour);
            } else {
               ObjectSetText("BarTime", days + "D - " + sTime + " [" + sCurrentTime + "]", FontSize, "Arial Bold", colour);
            }
         }
      } else {
         if (location == 0) {
            if (displayServerTime == 0) {
               Comment("Candle closing time remaining at " + sTime);
            } else {
               Comment("Candle closing time remaining at " + sTime + " [" + sCurrentTime + "]");
            }
         } else {
            if (displayServerTime == 0) {
               ObjectSetText("BarTime", sTime, FontSize, "Arial Bold", colour);
            } else {
               ObjectSetText("BarTime", sTime + " [" + sCurrentTime + "]", FontSize, "Arial Bold", colour);
            }
         }
      }
   }
   return (0);
}
//+------------------------------------------------------------------+
