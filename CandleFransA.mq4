//+------------------------------------------------------------------+
//|                                                    SumCandle.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

extern int CandleCounter = 26;
extern int CandleBaseShift = 1;
extern ENUM_TIMEFRAMES ChooseTimeFrame = PERIOD_CURRENT;

int CandleBaseShiftStart, CandleBaseShiftFinish, CandleSumPivot, CandleSumUp, CandleSumDown;

double SumPointBullish, SumPointBearish, CandleOpen, CandleClose, SumCandleBullish, SumCandleBearish, AverageCandleBullish, AverageCandleBearish;
datetime NextCandle;
string ShowComment;

int init() {

   NextCandle = Time[0] + Period();
   return (0);

}

int deinit() {

   Comment("");
   ObjectDelete(ObjectName(CandleBaseShiftStart));
   ObjectDelete(ObjectName(CandleBaseShiftFinish));
   ObjectDelete(ObjectName(CandleSumPivot));
   ObjectDelete(ObjectName(CandleSumUp));
   ObjectDelete(ObjectName(CandleSumDown));
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
   
   for(int i=CandleBaseShift; i<=CandleCounter; i++) {
      
      CandleOpen = iOpen(Symbol(), PERIOD_CURRENT, i);
      CandleClose = iClose(Symbol(), PERIOD_CURRENT, i);
      
      if(CandleClose > CandleOpen) {
         SumPointBullish = SumPointBullish + (CandleClose - CandleOpen);
         SumCandleBullish = SumCandleBullish + 1;
      } else if(CandleClose < CandleOpen){
         SumPointBearish = SumPointBearish + (CandleOpen - CandleClose);
         SumCandleBearish = SumCandleBearish + 1;
      }
      
   }
   
   ObjectCreate(CandleBaseShiftStart, "CandleBaseShiftStart", OBJ_VLINE, 0, Time[CandleBaseShift], 0);
   ObjectSet("CandleBaseShiftStart", OBJPROP_COLOR, StringToColor("77,77,77"));
   ObjectSet("CandleBaseShiftStart", OBJPROP_STYLE, 2);
   ObjectSet("CandleBaseShiftStart", OBJPROP_BACK, true);
   
   ObjectCreate(CandleBaseShiftFinish, "CandleBaseShiftFinish", OBJ_VLINE, 0, Time[CandleBaseShift + (CandleCounter - 1)], 0);
   ObjectSet("CandleBaseShiftFinish", OBJPROP_COLOR, StringToColor("77,77,77"));
   ObjectSet("CandleBaseShiftFinish", OBJPROP_STYLE, 2);
   ObjectSet("CandleBaseShiftFinish", OBJPROP_BACK, true);
   
   SumPointBullish = SumPointBullish / Point();
   SumPointBearish = SumPointBearish / Point();
   
   ShowComment = ShowComment + "Bullish: " + DoubleToString(SumCandleBullish, 0) + " Candle\n";
   ShowComment = ShowComment + "Bearish: " + DoubleToString(SumCandleBearish, 0) + " Candle\n\n"; 
   
   ShowComment = ShowComment + "Bullish: " + DoubleToString(SumPointBullish, 0) + " Point\n";
   ShowComment = ShowComment + "Bearish: " + DoubleToString(SumPointBearish, 0) + " Point\n";
   ShowComment = ShowComment + "Bullish - Bearish: " + DoubleToString((SumPointBullish - SumPointBearish), 0) + " Point\n\n";
   
   AverageCandleBullish = SumPointBullish / SumCandleBullish;
   AverageCandleBearish = SumPointBearish / SumCandleBearish;
   
   ObjectCreate("CandleSumPivot", OBJ_HLINE, 0, CurTime(), iClose(Symbol(), PERIOD_CURRENT, CandleBaseShift));
   ObjectSet("CandleSumPivot", OBJPROP_COLOR, StringToColor("77,77,77"));
   ObjectSet("CandleSumPivot", OBJPROP_STYLE, 2);
   ObjectSet("CandleSumPivot", OBJPROP_BACK, true);
   
   ShowComment = ShowComment + "AverageBullish: " + DoubleToString(AverageCandleBullish, 0) + " Point from " + DoubleToString(SumCandleBullish, 0) + " Candle\n";
   ShowComment = ShowComment + "AverageBearish: " + DoubleToString(AverageCandleBearish, 0) + " Point from " + DoubleToString(SumCandleBearish, 0) + " Candle\n";
   ShowComment = ShowComment + "AverageBullish - AverageBearish: " + DoubleToString((AverageCandleBullish - AverageCandleBearish), 0) + " Point\n";
   
   Comment(ShowComment);
   
   return (0);
      
}