//+------------------------------------------------------------------+
//|                                             AverageOneCandle.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window


extern string IndicatorID = "AverageOneCandle";
extern ENUM_TIMEFRAMES ChooseTimeFrame = PERIOD_D1;
enum TheDay {
   Today,
   Yesterday,
   TwoDaysAgo,
   ThreeDayAgo
};
extern TheDay ChooseDay = Yesterday;
string ChooseDayCandleTime;
extern string CandleTime = "00:00";
extern color AverageOneCandleColor = Aqua;

int CandleShift;
string ShowComment;
double AveragePriceCandle;


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
   
   ObjectDelete("VerticalLineCandle");
   
   ObjectDelete("AveragePriceCandle");
   ObjectDelete("AveragePriceCandlePriceText");
   
   Comment("");
   
   return (0);
   
}


//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start() {

   ShowComment = "";
   ShowComment = "\n";
   
   if(ChooseDay == Today) {
      ChooseDayCandleTime = TimeToString(TimeCurrent(), TIME_DATE) + " ";
   } else if(ChooseDay == Yesterday) {
      ChooseDayCandleTime = TimeToString(TimeCurrent() - 60 * 60 * 24, TIME_DATE) + " ";
   } else if(ChooseDay == TwoDaysAgo) {
      ChooseDayCandleTime = TimeToString(TimeCurrent() - (60 * 60 * 24) * 2, TIME_DATE) + " ";
   } else if(ChooseDay == ThreeDayAgo) {
      ChooseDayCandleTime = TimeToString(TimeCurrent() - (60 * 60 * 24) * 3, TIME_DATE) + " ";
   }
   
   ShowComment = ShowComment + "Time of Candle: " + ChooseDayCandleTime + CandleTime + "\n";
   
   CandleShift = iBarShift(Symbol(), ChooseTimeFrame, StringToTime(ChooseDayCandleTime + CandleTime)); //Alert(ChooseDayCandleTime + CandleTime);
   ShowComment = ShowComment + "Open Price: " + DoubleToString(iOpen(Symbol(), PERIOD_CURRENT, CandleShift), _Digits) + "\n";
   ShowComment = ShowComment + "Close Price: " + DoubleToString(iClose(Symbol(), PERIOD_CURRENT, CandleShift), _Digits) + "\n";
   ShowComment = ShowComment + "High Price: " + DoubleToString(iHigh(Symbol(), PERIOD_CURRENT, CandleShift), _Digits) + "\n";
   ShowComment = ShowComment + "Low Price: " + DoubleToString(iLow(Symbol(), PERIOD_CURRENT, CandleShift), _Digits) + "\n";
   
   AveragePriceCandle = (iOpen(Symbol(), PERIOD_CURRENT, CandleShift) + iClose(Symbol(), PERIOD_CURRENT, CandleShift) + iHigh(Symbol(), PERIOD_CURRENT, CandleShift) + iLow(Symbol(), PERIOD_CURRENT, CandleShift)) / 4;
   
   ShowComment = ShowComment + "Average Price: " + DoubleToString(AveragePriceCandle, _Digits) + "\n";
   
   if (ObjectFind("AveragePriceCandle") != 0) {
      ObjectCreate("AveragePriceCandle", OBJ_HLINE, 0, CurTime(), AveragePriceCandle);
      ObjectSet("AveragePriceCandle", OBJPROP_COLOR, AverageOneCandleColor);
      ObjectSet("AveragePriceCandle", OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet("AveragePriceCandle", OBJPROP_BACK, true);
      
      ObjectCreate("AveragePriceCandlePriceText", OBJ_TEXT, 0, CurTime(), NormalizeDouble(AveragePriceCandle, (int) MarketInfo(Symbol(), MODE_DIGITS)));
      ObjectSetText("AveragePriceCandlePriceText", DoubleToString(AveragePriceCandle, (int) MarketInfo(Symbol(), MODE_DIGITS)), 8, "Arial", Aqua);
      ObjectSet("AveragePriceCandlePriceText", OBJPROP_BACK, true);
   }
   
   Comment(ShowComment);
   
   return (0);
   
}
