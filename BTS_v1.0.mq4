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
extern color   LineColor = Blue;
extern bool    AutoSignal = false;

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
      if(iClose(Symbol(), PERIOD_CURRENT, CandleBase - 1) > iOpen(Symbol(), PERIOD_CURRENT, CandleBase - 1)) {
         if(iClose(Symbol(), PERIOD_CURRENT, CandleBase) < iOpen(Symbol(), PERIOD_CURRENT, CandleBase)){
            if(iClose(Symbol(), PERIOD_CURRENT, CandleBase - 1) > iHigh(Symbol(), PERIOD_CURRENT, CandleBase)) {
               GetAutoSignal = 1;
            }
         }
      } else if(iClose(Symbol(), PERIOD_CURRENT, CandleBase - 1) < iOpen(Symbol(), PERIOD_CURRENT, CandleBase - 1)) {
         if(iClose(Symbol(), PERIOD_CURRENT, CandleBase) > iOpen(Symbol(), PERIOD_CURRENT, CandleBase)) {
            if(iClose(Symbol(), PERIOD_CURRENT, CandleBase - 1) < iLow(Symbol(), PERIOD_CURRENT, CandleBase)) {
               GetAutoSignal = 1;
            }
         }
      }
   }
   
   if(GetAutoSignal == 1) {
   
      double PriceCandleOpen = iOpen(Symbol(), PERIOD_CURRENT, CandleBase);
      
      if (ObjectFind("CandleOpen") != 0) {
         ObjectCreate("CandleOpen", OBJ_HLINE, 0, CurTime(), PriceCandleOpen);
         ObjectSet("CandleOpen", OBJPROP_COLOR, LineColor);
         ObjectSet("CandleOpen", OBJPROP_STYLE, STYLE_DASHDOT);
         ObjectSet("CandleOpen", OBJPROP_BACK, true);
      }
      
      if (ObjectFind("CandleOpenLabel") != 0) {
         ObjectCreate("CandleOpenLabel", OBJ_TEXT, 0, Time[20], PriceCandleOpen);
         ObjectSetText("CandleOpenLabel", DoubleToString(PriceCandleOpen, Digits), 8, "Arial", LineColor);
      }
      
      double PriceCandleClose = iClose(Symbol(), PERIOD_CURRENT, CandleBase);
      
      if (ObjectFind("CandleClose") != 0) {
         ObjectCreate("CandleClose", OBJ_HLINE, 0, CurTime(), PriceCandleClose);
         ObjectSet("CandleClose", OBJPROP_COLOR, LineColor);
         ObjectSet("CandleClose", OBJPROP_STYLE, STYLE_DASHDOT);
         ObjectSet("CandleClose", OBJPROP_BACK, true);
      }
      
      if (ObjectFind("CandleCloseLabel") != 0) {
         ObjectCreate("CandleCloseLabel", OBJ_TEXT, 0, Time[20], PriceCandleClose);
         ObjectSetText("CandleCloseLabel", DoubleToString(PriceCandleClose, Digits), 8, "Arial", LineColor);
      }
      
      double PriceCandleHigh = iHigh(Symbol(), PERIOD_CURRENT, CandleBase);
      
      if (ObjectFind("CandleHigh") != 0) {
         ObjectCreate("CandleHigh", OBJ_HLINE, 0, CurTime(), PriceCandleHigh);
         ObjectSet("CandleHigh", OBJPROP_COLOR, LineColor);
         ObjectSet("CandleHigh", OBJPROP_STYLE, STYLE_DASHDOT);
         ObjectSet("CandleHigh", OBJPROP_BACK, true);
      }
      
      if (ObjectFind("CandleHighLabel") != 0) {
         ObjectCreate("CandleHighLabel", OBJ_TEXT, 0, Time[20], PriceCandleHigh);
         ObjectSetText("CandleHighLabel", DoubleToString(PriceCandleHigh, Digits), 8, "Arial", LineColor);
      }
      
      double PriceCandleLow = iLow(Symbol(), PERIOD_CURRENT, CandleBase);
      
      if (ObjectFind("CandleLow") != 0) {
         ObjectCreate("CandleLow", OBJ_HLINE, 0, CurTime(), PriceCandleLow);
         ObjectSet("CandleLow", OBJPROP_COLOR, LineColor);
         ObjectSet("CandleLow", OBJPROP_STYLE, STYLE_DASHDOT);
         ObjectSet("CandleLow", OBJPROP_BACK, true);
      }
      
      if (ObjectFind("CandleLowLabel") != 0) {
         ObjectCreate("CandleLowLabel", OBJ_TEXT, 0, Time[20], PriceCandleLow);
         ObjectSetText("CandleLowLabel", DoubleToString(PriceCandleLow, Digits), 8, "Arial", LineColor);
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
