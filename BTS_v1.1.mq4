//+------------------------------------------------------------------+
//|                                                         BTS_v1.0 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

extern int     CandleBase = 2;
extern bool    AutoSignal = false;
extern ENUM_TIMEFRAMES ChooseTimeFrame = PERIOD_H4;

int GetAutoSignal = 0;
string comments;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init() {
   return (0);
}


//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit() {

   ObjectDelete("CandleOpen");
   ObjectDelete("CandleClose");
   ObjectDelete("CandleHigh");
   ObjectDelete("CandleLow");
   
   ObjectDelete("CandleOpenLabel");
   ObjectDelete("CandleCloseLabel");
   ObjectDelete("CandleHighLabel");
   ObjectDelete("CandleLowLabel");
   
   ObjectDelete("VerticalLineBTS");
   
   return (0);
   
}


//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start() {
   
   TimeToStr(CurTime());
   
   comments = "";
   
   if(AutoSignal == false) {
      GetAutoSignal = 1;
   } else {
      if(iClose(Symbol(), ChooseTimeFrame, CandleBase - 1) > iOpen(Symbol(), ChooseTimeFrame, CandleBase - 1)) {
         if(iClose(Symbol(), ChooseTimeFrame, CandleBase) < iOpen(Symbol(), ChooseTimeFrame, CandleBase)){
            if(iClose(Symbol(), ChooseTimeFrame, CandleBase - 1) > iHigh(Symbol(), ChooseTimeFrame, CandleBase)) {
               GetAutoSignal = 1;
            }
         }
      } else if(iClose(Symbol(), ChooseTimeFrame, CandleBase - 1) < iOpen(Symbol(), ChooseTimeFrame, CandleBase - 1)) {
         if(iClose(Symbol(), ChooseTimeFrame, CandleBase) > iOpen(Symbol(), ChooseTimeFrame, CandleBase)) {
            if(iClose(Symbol(), ChooseTimeFrame, CandleBase - 1) < iLow(Symbol(), ChooseTimeFrame, CandleBase)) {
               GetAutoSignal = 1;
            }
         }
      }
   }
   
   if(GetAutoSignal == 1) {
   
      double PriceCandleOpen = iOpen(Symbol(), ChooseTimeFrame, CandleBase);
      
      if (ObjectFind("CandleOpen") != 0) {
         ObjectCreate("CandleOpen", OBJ_HLINE, 0, CurTime(), PriceCandleOpen);
         ObjectSet("CandleOpen", OBJPROP_COLOR, Green);
         ObjectSet("CandleOpen", OBJPROP_STYLE, STYLE_DASHDOT);
         ObjectSet("CandleOpen", OBJPROP_BACK, true);
      }
      
      if (ObjectFind("CandleOpenLabel") != 0) {
         ObjectCreate("CandleOpenLabel", OBJ_TEXT, 0, Time[19], PriceCandleOpen);
         ObjectSetText("CandleOpenLabel", DoubleToString(PriceCandleOpen, Digits), 8, "Arial", Green);
      }
      
      double PriceCandleClose = iClose(Symbol(), ChooseTimeFrame, CandleBase);
      
      if (ObjectFind("CandleClose") != 0) {
         ObjectCreate("CandleClose", OBJ_HLINE, 0, CurTime(), PriceCandleClose);
         ObjectSet("CandleClose", OBJPROP_COLOR, Green);
         ObjectSet("CandleClose", OBJPROP_STYLE, STYLE_DASHDOT);
         ObjectSet("CandleClose", OBJPROP_BACK, true);
      }
      
      if (ObjectFind("CandleCloseLabel") != 0) {
         ObjectCreate("CandleCloseLabel", OBJ_TEXT, 0, Time[19], PriceCandleClose);
         ObjectSetText("CandleCloseLabel", DoubleToString(PriceCandleClose, Digits), 8, "Arial", Green);
      }
      
      double PriceCandleHigh = iHigh(Symbol(), ChooseTimeFrame, CandleBase);
      
      if (ObjectFind("CandleHigh") != 0) {
         ObjectCreate("CandleHigh", OBJ_HLINE, 0, CurTime(), PriceCandleHigh);
         ObjectSet("CandleHigh", OBJPROP_COLOR, Orange);
         ObjectSet("CandleHigh", OBJPROP_STYLE, STYLE_DASHDOT);
         ObjectSet("CandleHigh", OBJPROP_BACK, true);
      }
      
      if (ObjectFind("CandleHighLabel") != 0) {
         ObjectCreate("CandleHighLabel", OBJ_TEXT, 0, Time[19], PriceCandleHigh);
         ObjectSetText("CandleHighLabel", DoubleToString(PriceCandleHigh, Digits), 8, "Arial", Orange);
      }
      
      double PriceCandleLow = iLow(Symbol(), ChooseTimeFrame, CandleBase);
      
      if (ObjectFind("CandleLow") != 0) {
         ObjectCreate("CandleLow", OBJ_HLINE, 0, CurTime(), PriceCandleLow);
         ObjectSet("CandleLow", OBJPROP_COLOR, Orange);
         ObjectSet("CandleLow", OBJPROP_STYLE, STYLE_DASHDOT);
         ObjectSet("CandleLow", OBJPROP_BACK, true);
      }
      
      if (ObjectFind("CandleLowLabel") != 0) {
         ObjectCreate("CandleLowLabel", OBJ_TEXT, 0, Time[19], PriceCandleLow);
         ObjectSetText("CandleLowLabel", DoubleToString(PriceCandleLow, Digits), 8, "Arial", Orange);
      }
      
      if (ObjectFind("VerticalLineBTS") != 0) {
         ObjectCreate("VerticalLineBTS", OBJ_VLINE, 0, iTime(Symbol(), ChooseTimeFrame, CandleBase), PriceCandleLow);
         ObjectSet("VerticalLineBTS", OBJPROP_COLOR, DarkGoldenrod);
         ObjectSet("VerticalLineBTS", OBJPROP_STYLE, STYLE_DASHDOT);
         ObjectSet("VerticalLineBTS", OBJPROP_BACK, true);
      }
      
      comments = comments + "Low: " + DoubleToString(PriceCandleLow, Digits) + "\n";
      comments = comments + "High: " + DoubleToString(PriceCandleHigh, Digits) + "\n";
      comments = comments + "Open: " + DoubleToString(PriceCandleOpen, Digits) + "\n";
      comments = comments + "Close: " + DoubleToString(PriceCandleClose, Digits) + "\n";
      
   }
   
   Comment(comments);

   return (0);

}
//+------------------------------------------------------------------+
