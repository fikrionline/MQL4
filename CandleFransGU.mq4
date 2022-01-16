//+------------------------------------------------------------------+
//|                                                CandleFransGU.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

extern int CandleCounter = 5;
extern int CandleBaseShift = 1;
extern ENUM_TIMEFRAMES ChooseTimeFrame = PERIOD_D1;

double SumPointBullish, SumPointBearish, CandleOpen, CandleClose, SumCandleBullish, SumCandleBearish, AverageCandleBullish, AverageCandleBearish, CandleSumUpPrice, CandleSumDownPrice;
datetime NextCandle;
string ShowComment, ForecastStart;

int init() {

   NextCandle = Time[0] + Period();
   return (0);

}

int deinit() {

   Comment("");
   ObjectDelete("CandleBaseShiftStart");
   ObjectDelete("CandleBaseShiftFinish");
   ObjectDelete("CandleSumPivot");
   ObjectDelete("CandleSumPivotLabel");
   ObjectDelete("CandleSumUp");
   ObjectDelete("CandleSumDown");
   ObjectDelete("CandleSumUpLabel");
   ObjectDelete("CandleSumDownLabel");
   return (0);

}


int start() {

   ShowComment = "";
   ShowComment = ShowComment + "CandleCounter: " + IntegerToString(CandleCounter) + "\n";
   ShowComment = ShowComment + "CandleBaseShift: " + IntegerToString(CandleBaseShift) + "\n\n";
      
   SumPointBullish = 0;
   SumPointBearish = 0;
   
   SumCandleBullish = 0;
   SumCandleBearish = 0;
   
   AverageCandleBullish = 0;
   AverageCandleBearish = 0;
   
   for(int i=CandleBaseShift; i<(CandleBaseShift + CandleCounter); i++) {
      
      CandleOpen = iOpen(Symbol(), ChooseTimeFrame, i);
      CandleClose = iClose(Symbol(), ChooseTimeFrame, i);
      
      if(CandleClose > CandleOpen) {
         SumPointBullish = SumPointBullish + (CandleClose - CandleOpen);
         SumCandleBullish = SumCandleBullish + 1;
      } else if(CandleClose < CandleOpen){
         SumPointBearish = SumPointBearish + (CandleOpen - CandleClose);
         SumCandleBearish = SumCandleBearish + 1;
      }
      
   }
   
   ObjectCreate("CandleBaseShiftStart", OBJ_VLINE, 0, iTime(Symbol(), ChooseTimeFrame, CandleBaseShift), 0);
   ObjectSet("CandleBaseShiftStart", OBJPROP_COLOR, StringToColor("77,77,77"));
   ObjectSet("CandleBaseShiftStart", OBJPROP_STYLE, 2);
   ObjectSet("CandleBaseShiftStart", OBJPROP_BACK, true);
   
   ObjectCreate("CandleBaseShiftFinish", OBJ_VLINE, 0, iTime(Symbol(), ChooseTimeFrame, CandleBaseShift + (CandleCounter - 1)), 0);
   ObjectSet("CandleBaseShiftFinish", OBJPROP_COLOR, StringToColor("77,77,77"));
   ObjectSet("CandleBaseShiftFinish", OBJPROP_STYLE, 2);
   ObjectSet("CandleBaseShiftFinish", OBJPROP_BACK, true);
   
   SumPointBullish = SumPointBullish / Point();
   SumPointBearish = SumPointBearish / Point();
   
   if((SumPointBullish - SumPointBearish) > 0) {
      ForecastStart = " Bearish";
   } else if((SumPointBullish - SumPointBearish) < 0) {
      ForecastStart = " Bullish";
   }
   
   ShowComment = ShowComment + "Bullish: " + DoubleToString(SumCandleBullish, 0) + " Candle\n";
   ShowComment = ShowComment + "Bearish: " + DoubleToString(SumCandleBearish, 0) + " Candle\n\n"; 
   
   ShowComment = ShowComment + "Bullish: " + DoubleToString(SumPointBullish, 0) + " Point\n";
   ShowComment = ShowComment + "Bearish: " + DoubleToString(SumPointBearish, 0) + " Point\n";
   ShowComment = ShowComment + "Bullish - Bearish: " + DoubleToString((SumPointBullish - SumPointBearish), 0) + " Point\n\n";
   
   AverageCandleBullish = SumPointBullish / SumCandleBullish;
   AverageCandleBearish = SumPointBearish / SumCandleBearish;
   
   ShowComment = ShowComment + "AverageBullish: " + DoubleToString(AverageCandleBullish, 0) + " Point from " + DoubleToString(SumCandleBullish, 0) + " Candle\n";
   ShowComment = ShowComment + "AverageBearish: " + DoubleToString(AverageCandleBearish, 0) + " Point from " + DoubleToString(SumCandleBearish, 0) + " Candle\n";
   ShowComment = ShowComment + "AverageBullish - AverageBearish: " + DoubleToString((AverageCandleBullish - AverageCandleBearish), 0) + " Point\n";
   
   ObjectCreate("CandleSumPivot", OBJ_HLINE, 0, CurTime(), iClose(Symbol(), ChooseTimeFrame, CandleBaseShift));
   ObjectSet("CandleSumPivot", OBJPROP_COLOR, StringToColor("77,77,77"));
   ObjectSet("CandleSumPivot", OBJPROP_STYLE, 2);
   ObjectSet("CandleSumPivot", OBJPROP_BACK, true);
   
   ObjectCreate("CandleSumPivotLabel", OBJ_TEXT, 0, CurTime(), iClose(Symbol(), ChooseTimeFrame, CandleBaseShift));
   ObjectSetText("CandleSumPivotLabel", ForecastStart, 8, "Arial", StringToColor("77,77,77"));
   ObjectSet("CandleSumPivotLabel", OBJPROP_BACK, true);
   
   CandleSumUpPrice = NormalizeDouble((iClose(Symbol(), ChooseTimeFrame, CandleBaseShift)) + ((double) MathAbs(SumPointBullish - SumPointBearish) * Point()), Digits());
   
   ObjectCreate("CandleSumUp", OBJ_HLINE, 0, CurTime(), CandleSumUpPrice);
   ObjectSet("CandleSumUp", OBJPROP_COLOR, StringToColor("77,77,77"));
   ObjectSet("CandleSumUp", OBJPROP_STYLE, 2);
   ObjectSet("CandleSumUp", OBJPROP_BACK, true);
   
   ObjectCreate("CandleSumUpLabel", OBJ_TEXT, 0, CurTime(), CandleSumUpPrice);
   ObjectSetText("CandleSumUpLabel", DoubleToString(CandleSumUpPrice, (int) MarketInfo(Symbol(), MODE_DIGITS)), 8, "Arial", StringToColor("77,77,77"));
   ObjectSet("CandleSumUpLabel", OBJPROP_BACK, true);
   
   CandleSumDownPrice = NormalizeDouble((iClose(Symbol(), ChooseTimeFrame, CandleBaseShift)) - ((double) MathAbs(SumPointBullish - SumPointBearish) * Point()), Digits());
   
   ObjectCreate("CandleSumDown", OBJ_HLINE, 0, CurTime(), CandleSumDownPrice);
   ObjectSet("CandleSumDown", OBJPROP_COLOR, StringToColor("77,77,77"));
   ObjectSet("CandleSumDown", OBJPROP_STYLE, 2);
   ObjectSet("CandleSumDown", OBJPROP_BACK, true);
   
   ObjectCreate("CandleSumDownLabel", OBJ_TEXT, 0, CurTime(), CandleSumDownPrice);
   ObjectSetText("CandleSumDownLabel", DoubleToString(CandleSumDownPrice, (int) MarketInfo(Symbol(), MODE_DIGITS)), 8, "Arial", StringToColor("77,77,77"));
   ObjectSet("CandleSumDownLabel", OBJPROP_BACK, true);
   
   Comment(ShowComment);
   
   return (0);
      
}
