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

input double StartPrice = 129.638;
input bool ShowDeviasi = false;
input double RumusDeviasi = 1.00175623;
input bool ShowMiddleLine = false;
input int LevelSize = 99;

double ResultDeviasiBase;

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
      ObjectDelete("MiddleLine+" + IntegerToString(d));
      ObjectDelete("MiddleLine-" + IntegerToString(d));
   }
   
   return (0);
   
}


int start() {

   ResultDeviasiBase = RumusDeviasi;
     
   double LastLevelPlus = StartPrice;
   double LastLevelMinus = StartPrice;
   double LastLevelPlusDeviasiUpper, LastLevelPlusDeviasiLower, LastLevelMinusDeviasiUpper, LastLevelMinusDeviasiLower;
   double LastMiddleLine;
   
   ObjectCreate("StartPrice", OBJ_HLINE, 0, CurTime(), StartPrice);
   ObjectSet("StartPrice", OBJPROP_COLOR, Blue);
   ObjectSet("StartPrice", OBJPROP_STYLE, STYLE_DASHDOT);
   ObjectSet("StartPrice", OBJPROP_BACK, true);
   
   ObjectCreate("StartPriceLabel", OBJ_TEXT, 0, CurTime(), StartPrice);
   ObjectSetText("StartPriceLabel", "Start", 8, "Arial", Blue);
   ObjectSet("StartPriceLabel", OBJPROP_BACK, true);
   
   //ObjectCreate("StartPriceVerticalLine", OBJ_VLINE, 0, StartPriceTime, 0);
   //ObjectSet("StartPriceVerticalLine", OBJPROP_COLOR, Blue);
   //ObjectSet("StartPriceVerticalLine", OBJPROP_STYLE, STYLE_DASHDOT);
   
   for (int i=1; i<=LevelSize; i++) {
   
      if(ShowMiddleLine) {
         
         LastMiddleLine = (LastLevelPlus + LastLevelPlus * (1 + (LastLevelPlus / (LastLevelPlus * LastLevelPlus)))) / 2;
         
         ObjectCreate("MiddleLine+" + IntegerToString(i), OBJ_HLINE, 0, CurTime(), NormalizeDouble(LastMiddleLine, (int) MarketInfo(Symbol(), MODE_DIGITS)));
         ObjectSet("MiddleLine+" + IntegerToString(i), OBJPROP_COLOR, StringToColor("33, 33, 33"));
         ObjectSet("MiddleLine+" + IntegerToString(i), OBJPROP_STYLE, STYLE_DASHDOT);
         ObjectSet("MiddleLine+" + IntegerToString(i), OBJPROP_BACK, true);
         
      }
   
      LastLevelPlus = LastLevelPlus * (1 + (LastLevelPlus / (LastLevelPlus * LastLevelPlus)));
      
      ObjectCreate("+" + IntegerToString(i), OBJ_HLINE, 0, CurTime(), NormalizeDouble(LastLevelPlus, (int) MarketInfo(Symbol(), MODE_DIGITS)));
      ObjectSet("+" + IntegerToString(i), OBJPROP_COLOR, Aqua);
      ObjectSet("+" + IntegerToString(i), OBJPROP_STYLE, STYLE_DASHDOT);
      ObjectSet("+" + IntegerToString(i), OBJPROP_BACK, true);
      
      ObjectCreate("+" + IntegerToString(i) + "Label", OBJ_TEXT, 0, CurTime(), NormalizeDouble(LastLevelPlus, (int) MarketInfo(Symbol(), MODE_DIGITS)));
      ObjectSetText("+" + IntegerToString(i) + "Label", DoubleToString(LastLevelPlus, (int) MarketInfo(Symbol(), MODE_DIGITS)), 8, "Arial", Aqua);
      ObjectSet("+" + IntegerToString(i) + "Label", OBJPROP_BACK, true);
      
      if(ShowDeviasi) {
      
         LastLevelPlusDeviasiUpper = LastLevelPlus * ResultDeviasiBase;
         
         ObjectCreate("+d+" + IntegerToString(i), OBJ_HLINE, 0, CurTime(), NormalizeDouble(LastLevelPlusDeviasiUpper, (int) MarketInfo(Symbol(), MODE_DIGITS)));
         ObjectSet("+d+" + IntegerToString(i), OBJPROP_COLOR, StringToColor("66, 66, 66"));
         ObjectSet("+d+" + IntegerToString(i), OBJPROP_STYLE, STYLE_DASHDOT);
         ObjectSet("+d+" + IntegerToString(i), OBJPROP_BACK, true);
         
         LastLevelPlusDeviasiLower = LastLevelPlus / ResultDeviasiBase;
         
         ObjectCreate("+d-" + IntegerToString(i), OBJ_HLINE, 0, CurTime(), NormalizeDouble(LastLevelPlusDeviasiLower, (int) MarketInfo(Symbol(), MODE_DIGITS)));
         ObjectSet("+d-" + IntegerToString(i), OBJPROP_COLOR, StringToColor("66, 66, 66"));
         ObjectSet("+d-" + IntegerToString(i), OBJPROP_STYLE, STYLE_DASHDOT);
         ObjectSet("+d-" + IntegerToString(i), OBJPROP_BACK, true);
         
      }
      
      //-----------------------------------------------------------------------------------------------------------------
      
      if(ShowMiddleLine) {
         
         LastMiddleLine = (LastLevelMinus + LastLevelMinus / (1 + (LastLevelMinus / (LastLevelMinus * LastLevelMinus)))) / 2;
         
         ObjectCreate("MiddleLine-" + IntegerToString(i), OBJ_HLINE, 0, CurTime(), NormalizeDouble(LastMiddleLine, (int) MarketInfo(Symbol(), MODE_DIGITS)));
         ObjectSet("MiddleLine-" + IntegerToString(i), OBJPROP_COLOR, StringToColor("33, 33, 33"));
         ObjectSet("MiddleLine-" + IntegerToString(i), OBJPROP_STYLE, STYLE_DASHDOT);
         ObjectSet("MiddleLine-" + IntegerToString(i), OBJPROP_BACK, true);
         
      }
      
      LastLevelMinus = LastLevelMinus / (1 + (LastLevelMinus / (LastLevelMinus * LastLevelMinus)));
      
      ObjectCreate("-" + IntegerToString(i), OBJ_HLINE, 0, CurTime(), LastLevelMinus);
      ObjectSet("-" + IntegerToString(i), OBJPROP_COLOR, Aqua);
      ObjectSet("-" + IntegerToString(i), OBJPROP_STYLE, STYLE_DASHDOT);
      ObjectSet("-" + IntegerToString(i), OBJPROP_BACK, true);
      
      ObjectCreate("-" + IntegerToString(i) + "Label", OBJ_TEXT, 0, CurTime(), NormalizeDouble(LastLevelMinus, (int) MarketInfo(Symbol(), MODE_DIGITS)));
      ObjectSetText("-" + IntegerToString(i) + "Label", DoubleToString(LastLevelMinus, (int) MarketInfo(Symbol(), MODE_DIGITS)), 8, "Arial", Aqua);
      ObjectSet("-" + IntegerToString(i) + "Label", OBJPROP_BACK, true);
      
      if(ShowDeviasi) {
      
         LastLevelMinusDeviasiUpper = LastLevelMinus * ResultDeviasiBase;
         
         ObjectCreate("-d+" + IntegerToString(i), OBJ_HLINE, 0, CurTime(), NormalizeDouble(LastLevelMinusDeviasiUpper, (int) MarketInfo(Symbol(), MODE_DIGITS)));
         ObjectSet("-d+" + IntegerToString(i), OBJPROP_COLOR, StringToColor("66, 66, 66"));
         ObjectSet("-d+" + IntegerToString(i), OBJPROP_STYLE, STYLE_DASHDOT);
         ObjectSet("-d+" + IntegerToString(i), OBJPROP_BACK, true);
         
         LastLevelMinusDeviasiLower = LastLevelMinus / ResultDeviasiBase;
         
         ObjectCreate("-d-" + IntegerToString(i), OBJ_HLINE, 0, CurTime(), NormalizeDouble(LastLevelMinusDeviasiLower, (int) MarketInfo(Symbol(), MODE_DIGITS)));
         ObjectSet("-d-" + IntegerToString(i), OBJPROP_COLOR, StringToColor("66, 66, 66"));
         ObjectSet("-d-" + IntegerToString(i), OBJPROP_STYLE, STYLE_DASHDOT);
         ObjectSet("-d+" + IntegerToString(i), OBJPROP_BACK, true);
         
      }
      
   }
   
   return (0);
   
}
