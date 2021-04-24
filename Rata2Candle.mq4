//+------------------------------------------------------------------+
//|                                                  Rata2Candle.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property indicator_chart_window

extern int StartFrom = 1;
extern int CandleCount = 5;

double CandleHigh, CandleLow;
double CountBullish = 0;
double CountBearish = 0;
int JumlahBullish = 0;
int JumlahBearish = 0;
string comment;

int deinit()
{   
   
   ObjectDelete("CandleStart");
   ObjectDelete("CandleFinish");
   ObjectDelete("CandleHighAverage");
   ObjectDelete("CandleLowAverage");
   ObjectDelete("CandleAverage");
   
   return (0);
   
}

int init()
{
   for (int i=0; i<CandleCount; i++)
   {
      
      CandleHigh = CandleHigh + iHigh(Symbol(), PERIOD_CURRENT, i + StartFrom);
      CandleLow = CandleLow + iLow(Symbol(), PERIOD_CURRENT, i + StartFrom);
          
   }
   
   double CandleHighAverage = CandleHigh / CandleCount;
   double CandleLowAverage = CandleLow / CandleCount;
   double CandleAverage = (CandleHighAverage + CandleLowAverage ) / 2;
   
   comment = comment + CandleHighAverage + " / " + CandleLowAverage + " / " + CandleAverage;
   
   Comment(comment);
   
   datetime CandleStartTime = iTime(Symbol(), PERIOD_CURRENT, StartFrom);
   ObjectCreate("CandleStart", OBJ_VLINE, 0, CandleStartTime, 0);
   ObjectSet("CandleStart", OBJPROP_COLOR, Orange);
   ObjectSet("CandleStart", OBJPROP_STYLE, STYLE_DASHDOT);
   ObjectSet("CandleStart", OBJPROP_BACK, true);
   
   datetime CandleFinishTime = iTime(Symbol(), PERIOD_CURRENT, (StartFrom + CandleCount - 1));
   ObjectCreate("CandleFinish", OBJ_VLINE, 0, CandleFinishTime, 0);
   ObjectSet("CandleFinish", OBJPROP_COLOR, Orange);
   ObjectSet("CandleFinish", OBJPROP_STYLE, STYLE_DASHDOT);
   ObjectSet("CandleFinish", OBJPROP_BACK, true);
   
   datetime CandleHighAverageTime = iTime(Symbol(), PERIOD_CURRENT, StartFrom);
   ObjectCreate("CandleHighAverage", OBJ_HLINE, 0, CurTime(), CandleHighAverage);
   ObjectSet("CandleHighAverage", OBJPROP_COLOR, Brown);
   ObjectSet("CandleHighAverage", OBJPROP_STYLE, STYLE_DASHDOT);
   ObjectSet("CandleHighAverage", OBJPROP_BACK, true);
   
   datetime CandleLowAverageTime = iTime(Symbol(), PERIOD_CURRENT, StartFrom);
   ObjectCreate("CandleLowAverage", OBJ_HLINE, 0, CurTime(), CandleLowAverage);
   ObjectSet("CandleLowAverage", OBJPROP_COLOR, Brown);
   ObjectSet("CandleLowAverage", OBJPROP_STYLE, STYLE_DASHDOT);
   ObjectSet("CandleLowAverage", OBJPROP_BACK, true);
   
   datetime CandleAverageTime = iTime(Symbol(), PERIOD_CURRENT, StartFrom);
   ObjectCreate("CandleAverage", OBJ_HLINE, 0, CurTime(), CandleAverage);
   ObjectSet("CandleAverage", OBJPROP_COLOR, Brown);
   ObjectSet("CandleAverage", OBJPROP_STYLE, STYLE_DASHDOT);
   ObjectSet("CandleAverage", OBJPROP_BACK, true);
   
   return(0);
   
}
  
int start()
{   
   return(0);   
}
