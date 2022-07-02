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

input double StartPrice = 1.42481;

enum Rumus {
TheBaseSNRA = 1, //1.00175623
TheBaseSNRB = 2, //1.00701748471
TheBaseSNRC = 3, //1.01141748471
TheBaseSNRD = 4, //1.00901748471
};
input Rumus RumusBase = 2;

input bool ShowDeviasi = false;
enum Deviasi {
DeviasiSNRA = 1, //1.00175623
DeviasiSNRB = 2 //1.00351748471
};
input Deviasi DeviasiBase = 1;

input bool ShowMiddleLine = true;

input int LevelSize = 33;

double ResultRumusBase, ResultDeviasiBase;

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

   if (RumusBase == 1)
   {
     ResultRumusBase = 1.00175623;
   } else
   if (RumusBase == 2)
   {
     ResultRumusBase = 1.00701748471;
   } else
   if (RumusBase == 3)
   {
     ResultRumusBase = 1.01141748471;
   } else
   if (RumusBase == 4)
   {
     ResultRumusBase = 1.00901748471;
   }
   
   if (DeviasiBase == 1)
   {
     ResultDeviasiBase = 1.00175623;
   } else
   if (DeviasiBase == 2)
   {
     ResultDeviasiBase = 1.00351748471;
   }
   
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
         
         LastMiddleLine = (LastLevelPlus + LastLevelPlus * ResultRumusBase) / 2;
         
         ObjectCreate("MiddleLine+" + IntegerToString(i), OBJ_HLINE, 0, CurTime(), NormalizeDouble(LastMiddleLine, (int) MarketInfo(Symbol(), MODE_DIGITS)));
         ObjectSet("MiddleLine+" + IntegerToString(i), OBJPROP_COLOR, StringToColor("33, 33, 33"));
         ObjectSet("MiddleLine+" + IntegerToString(i), OBJPROP_STYLE, STYLE_DASHDOT);
         ObjectSet("MiddleLine+" + IntegerToString(i), OBJPROP_BACK, true);
         
      }
   
      LastLevelPlus = LastLevelPlus * ResultRumusBase;
      
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
         
         LastMiddleLine = (LastLevelMinus + LastLevelMinus / ResultRumusBase) / 2;
         
         ObjectCreate("MiddleLine-" + IntegerToString(i), OBJ_HLINE, 0, CurTime(), NormalizeDouble(LastMiddleLine, (int) MarketInfo(Symbol(), MODE_DIGITS)));
         ObjectSet("MiddleLine-" + IntegerToString(i), OBJPROP_COLOR, StringToColor("33, 33, 33"));
         ObjectSet("MiddleLine-" + IntegerToString(i), OBJPROP_STYLE, STYLE_DASHDOT);
         ObjectSet("MiddleLine-" + IntegerToString(i), OBJPROP_BACK, true);
         
      }
      
      LastLevelMinus = LastLevelMinus / ResultRumusBase;
      
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
