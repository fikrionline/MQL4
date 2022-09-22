//+------------------------------------------------------------------+
//|                                                 DrawLineTPSL.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link "https://www.mql5.com"
#property version "1.1"
#property strict

extern double PointOfTP = 888;
extern double PointOfSL = 444;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init() {
   //----

   //----
   return (0);
}

//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit() {
   //----

   Comment("");
   ObjectDelete("Line1");
   ObjectDelete("Line2");
   ObjectDelete("Line3");
   ObjectDelete("Line4");

   //----
   return (0);
}

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
void OnTick() {

   ObjectDelete("Line1");
   ObjectDelete("Line2");
   ObjectDelete("Line3");
   ObjectDelete("Line4");

   double Line1 = Bid + (PointOfTP * Point);
   ObjectCreate("Line1", OBJ_HLINE, 0, CurTime(), Line1);
   ObjectSet("Line1", OBJPROP_COLOR, clrBlue);
   ObjectSet("Line1", OBJPROP_STYLE, STYLE_SOLID);
   ObjectSet("Line1", OBJPROP_BACK, true);

   double Line2 = Ask - (PointOfSL * Point);
   ObjectCreate("Line2", OBJ_HLINE, 0, CurTime(), Line2);
   ObjectSet("Line2", OBJPROP_COLOR, clrBlue);
   ObjectSet("Line2", OBJPROP_STYLE, STYLE_DASH);
   ObjectSet("Line2", OBJPROP_BACK, true);

   double Line3 = Ask - (PointOfTP * Point);
   ObjectCreate("Line3", OBJ_HLINE, 0, CurTime(), Line3);
   ObjectSet("Line3", OBJPROP_COLOR, clrOrange);
   ObjectSet("Line3", OBJPROP_STYLE, STYLE_SOLID);
   ObjectSet("Line3", OBJPROP_BACK, true);

   double Line4 = Bid + (PointOfSL * Point);
   ObjectCreate("Line4", OBJ_HLINE, 0, CurTime(), Line4);
   ObjectSet("Line4", OBJPROP_COLOR, clrOrange);
   ObjectSet("Line4", OBJPROP_STYLE, STYLE_DASH);
   ObjectSet("Line4", OBJPROP_BACK, true);
   
   Comment("ADRs = ", DoubleToString(GetADRs(PERIOD_D1, 20, 1), 0));

}
//+------------------------------------------------------------------+

double GetADRs(int ATR_TimeFrame = PERIOD_D1, int ATR_Counter = 20, int ATR_Shift = 1) {

   double ATR_PipStep;
   ATR_PipStep = iATR(Symbol(), ATR_TimeFrame, ATR_Counter, ATR_Shift);
   ATR_PipStep = MathRound(ATR_PipStep / _Point);
   return ATR_PipStep;

}
