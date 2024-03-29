//+------------------------------------------------------------------+
//|                                                  Pair_Level_v1.1 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.1"
#property strict
#property indicator_chart_window

extern int GMTPlusXHours = 0;
extern double LevelStep = 0.09;
extern int LevelSize = 5;

int init() {
    return (0);
}


int deinit() {

   ObjectDelete("StartPrice");
   ObjectDelete("StartPriceLabel");
   ObjectDelete("StartPriceVerticalLine");
   
   for(int d=1; d<=LevelSize; d++) {
      ObjectDelete("+" + IntegerToString(d));
      ObjectDelete("-" + IntegerToString(d));
      ObjectDelete("+" + IntegerToString(d) + "Label");
      ObjectDelete("-" + IntegerToString(d) + "Label");
   }
   
   return (0);
   
}


int start() {

   //TimeToStr(CurTime());
   
   datetime HourGMT = TimeHour(TimeGMT());
   int StartHour = (int) (HourGMT + GMTPlusXHours);
   
   double StartPrice = iOpen(Symbol(), PERIOD_H1, StartHour);
   datetime StartPriceTime = iTime(Symbol(), PERIOD_H1, StartHour);
   
   double LastLevelPlus = StartPrice;
   double LastLevelMinus = StartPrice;
   
   double LastLevelStepPlus = 0;
   double LastLevelStepMinus = 0;
   
   double Step = NormalizeDouble((LevelStep / 100) * StartPrice, 5);
   
   ObjectCreate("StartPrice", OBJ_HLINE, 0, CurTime(), StartPrice);
   ObjectSet("StartPrice", OBJPROP_COLOR, Blue);
   ObjectSet("StartPrice", OBJPROP_STYLE, STYLE_DASHDOT);
   ObjectSet("StartPrice", OBJPROP_BACK, true);
   
   ObjectCreate("StartPriceLabel", OBJ_TEXT, 0, CurTime(), StartPrice);
   ObjectSetText("StartPriceLabel", "Start", 8, "Arial", Blue);
   
   ObjectCreate("StartPriceVerticalLine", OBJ_VLINE, 0, StartPriceTime, 0);
   ObjectSet("StartPriceVerticalLine", OBJPROP_COLOR, Blue);
   ObjectSet("StartPriceVerticalLine", OBJPROP_STYLE, STYLE_DASHDOT);
   ObjectSet("StartPriceVerticalLine", OBJPROP_BACK, true);
   
   for (int i=1; i<=LevelSize; i++) {
   
      LastLevelPlus = LastLevelPlus + Step;
      LastLevelStepPlus = LastLevelStepPlus + LevelStep;
      
      ObjectCreate("+" + IntegerToString(i), OBJ_HLINE, 0, CurTime(), NormalizeDouble(LastLevelPlus, 5));
      ObjectSet("+" + IntegerToString(i), OBJPROP_COLOR, Green);
      ObjectSet("+" + IntegerToString(i), OBJPROP_STYLE, STYLE_DASHDOT);
      ObjectSet("+" + IntegerToString(i), OBJPROP_BACK, true);
      
      ObjectCreate("+" + IntegerToString(i) + "Label", OBJ_TEXT, 0, CurTime(), NormalizeDouble(LastLevelPlus, 5));
      ObjectSetText("+" + IntegerToString(i) + "Label", DoubleToString(LastLevelStepPlus, 2) + "%", 8, "Arial", Green);
      
      LastLevelMinus = LastLevelMinus - Step;
      LastLevelStepMinus = LastLevelStepMinus - LevelStep;
      
      ObjectCreate("-" + IntegerToString(i), OBJ_HLINE, 0, CurTime(), LastLevelMinus);
      ObjectSet("-" + IntegerToString(i), OBJPROP_COLOR, Orange);
      ObjectSet("-" + IntegerToString(i), OBJPROP_STYLE, STYLE_DASHDOT);
      ObjectSet("-" + IntegerToString(i), OBJPROP_BACK, true);
      
      ObjectCreate("-" + IntegerToString(i) + "Label", OBJ_TEXT, 0, CurTime(), NormalizeDouble(LastLevelMinus, 5));
      ObjectSetText("-" + IntegerToString(i) + "Label", DoubleToString(LastLevelStepMinus, 2) + "%", 8, "Arial", Orange);
      
   }
   
   return (0);
   
}
