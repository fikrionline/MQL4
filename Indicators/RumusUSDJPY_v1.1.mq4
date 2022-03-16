//+------------------------------------------------------------------+
//|                                                   Rumus_v1.1.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.1"
#property strict
#property indicator_chart_window

input double StartPrice = 101.177;
input bool ShowDeviasi = false;
input double RumusDeviasi = 1.00175623;
input int LevelSize = 33;

double ResultDeviasiBase;
int counter;

int deinit() {

   ObjectDelete("StartPrice");
   ObjectDelete("StartPriceLabel");
   ObjectDelete("StartPriceVerticalLine");
   
   for(int d=1; d<=LevelSize; d++) {
      ObjectDelete("+" + IntegerToString(d));
      ObjectDelete("-" + IntegerToString(d));
      ObjectDelete("+d+" + IntegerToString(d));
      ObjectDelete("+d-" + IntegerToString(d));
      ObjectDelete("-d+" + IntegerToString(d));
      ObjectDelete("-d-" + IntegerToString(d));
      ObjectDelete("+" + IntegerToString(d) + "Label");
      ObjectDelete("-" + IntegerToString(d) + "Label");
   }
   
   return (0);
   
}


int start() {

   ResultDeviasiBase = RumusDeviasi;
     
   double LastLevelPlus = StartPrice; //Print(LastLevelPlus);
   double LastLevelMinus = StartPrice;
   double LastLevelPlusDeviasiUpper, LastLevelPlusDeviasiLower;
   
   ObjectCreate("StartPrice", OBJ_HLINE, 0, TimeCurrent(), StartPrice);
   ObjectSet("StartPrice", OBJPROP_COLOR, clrBlue);
   ObjectSet("StartPrice", OBJPROP_STYLE, STYLE_DASHDOT);
   ObjectSet("StartPrice", OBJPROP_BACK, true);
   
   ObjectCreate("StartPriceLabel", OBJ_TEXT, 0, TimeCurrent(), StartPrice);
   ObjectSetText("StartPriceLabel", "Start", 8, "Arial", clrBlue);
   ObjectSet("StartPriceLabel", OBJPROP_BACK, true);
   
   //ObjectCreate("StartPriceVerticalLine", OBJ_VLINE, 0, StartPriceTime, 0);
   //ObjectSet("StartPriceVerticalLine", OBJPROP_COLOR, Blue);
   //ObjectSet("StartPriceVerticalLine", OBJPROP_STYLE, STYLE_DASHDOT);
   
   for (counter=1; counter<=LevelSize; counter++) {
   
      LastLevelPlus = LastLevelPlus * ((LastLevelPlus / (LastLevelPlus * LastLevelPlus))); Print(LastLevelPlus);
      
      ObjectCreate("+" + IntegerToString(counter), OBJ_HLINE, 0, TimeCurrent(), NormalizeDouble(LastLevelPlus, (int) MarketInfo(Symbol(), MODE_DIGITS)));
      ObjectSet("+" + IntegerToString(counter), OBJPROP_COLOR, clrAqua);
      ObjectSet("+" + IntegerToString(counter), OBJPROP_STYLE, STYLE_DASHDOT);
      ObjectSet("+" + IntegerToString(counter), OBJPROP_BACK, true);
      
      ObjectCreate("+" + IntegerToString(counter) + "Label", OBJ_TEXT, 0, TimeCurrent(), NormalizeDouble(LastLevelPlus, (int) MarketInfo(Symbol(), MODE_DIGITS)));
      ObjectSetText("+" + IntegerToString(counter) + "Label", DoubleToString(LastLevelPlus, (int) MarketInfo(Symbol(), MODE_DIGITS)), 8, "Arial", clrAqua);
      ObjectSet("+" + IntegerToString(counter) + "Label", OBJPROP_BACK, true);
      
      if(ShowDeviasi) {
      
         LastLevelPlusDeviasiUpper = LastLevelPlus * ResultDeviasiBase;
         
         ObjectCreate("+d+" + IntegerToString(counter), OBJ_HLINE, 0, TimeCurrent(), NormalizeDouble(LastLevelPlusDeviasiUpper, (int) MarketInfo(Symbol(), MODE_DIGITS)));
         ObjectSet("+d+" + IntegerToString(counter), OBJPROP_COLOR, StringToColor("66, 66, 66"));
         ObjectSet("+d+" + IntegerToString(counter), OBJPROP_STYLE, STYLE_DASHDOT);
         ObjectSet("+d+" + IntegerToString(counter), OBJPROP_BACK, true);
         
         LastLevelPlusDeviasiLower = LastLevelPlus / ResultDeviasiBase;
         
         ObjectCreate("+d-" + IntegerToString(counter), OBJ_HLINE, 0, TimeCurrent(), NormalizeDouble(LastLevelPlusDeviasiLower, (int) MarketInfo(Symbol(), MODE_DIGITS)));
         ObjectSet("+d-" + IntegerToString(counter), OBJPROP_COLOR, StringToColor("66, 66, 66"));
         ObjectSet("+d-" + IntegerToString(counter), OBJPROP_STYLE, STYLE_DASHDOT);
         ObjectSet("+d-" + IntegerToString(counter), OBJPROP_BACK, true);
         
      }
      
      //-----------------------------------------------------------------------------------------------------------------
      
      LastLevelMinus = LastLevelMinus / (1 + (LastLevelPlus / (LastLevelPlus * LastLevelPlus)));
      
      ObjectCreate("-" + IntegerToString(counter), OBJ_HLINE, 0, TimeCurrent(), LastLevelMinus);
      ObjectSet("-" + IntegerToString(counter), OBJPROP_COLOR, clrAqua);
      ObjectSet("-" + IntegerToString(counter), OBJPROP_STYLE, STYLE_DASHDOT);
      ObjectSet("-" + IntegerToString(counter), OBJPROP_BACK, true);
      
      ObjectCreate("-" + IntegerToString(counter) + "Label", OBJ_TEXT, 0, TimeCurrent(), NormalizeDouble(LastLevelMinus, (int) MarketInfo(Symbol(), MODE_DIGITS)));
      ObjectSetText("-" + IntegerToString(counter) + "Label", DoubleToString(LastLevelMinus, (int) MarketInfo(Symbol(), MODE_DIGITS)), 8, "Arial", clrAqua);
      ObjectSet("-" + IntegerToString(counter) + "Label", OBJPROP_BACK, true);
      
      if(ShowDeviasi) {
      
         LastLevelPlusDeviasiUpper = LastLevelMinus * ResultDeviasiBase;
         
         ObjectCreate("-d+" + IntegerToString(counter), OBJ_HLINE, 0, TimeCurrent(), NormalizeDouble(LastLevelPlusDeviasiUpper, (int) MarketInfo(Symbol(), MODE_DIGITS)));
         ObjectSet("-d+" + IntegerToString(counter), OBJPROP_COLOR, StringToColor("66, 66, 66"));
         ObjectSet("-d+" + IntegerToString(counter), OBJPROP_STYLE, STYLE_DASHDOT);
         ObjectSet("-d+" + IntegerToString(counter), OBJPROP_BACK, true);
         
         LastLevelPlusDeviasiLower = LastLevelMinus / ResultDeviasiBase;
         
         ObjectCreate("-d-" + IntegerToString(counter), OBJ_HLINE, 0, TimeCurrent(), NormalizeDouble(LastLevelPlusDeviasiLower, (int) MarketInfo(Symbol(), MODE_DIGITS)));
         ObjectSet("-d-" + IntegerToString(counter), OBJPROP_COLOR, StringToColor("66, 66, 66"));
         ObjectSet("-d-" + IntegerToString(counter), OBJPROP_STYLE, STYLE_DASHDOT);
         ObjectSet("-d+" + IntegerToString(counter), OBJPROP_BACK, true);
         
      }
      
   }
   
   return (0);
   
}
