//+------------------------------------------------------------------+
//|                                               CandleBodySize.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link "https://www.mql5.com"
#property version "1.1"
#property strict
#property indicator_chart_window

extern int font_size = 10;
extern color ColorBull = DodgerBlue;
extern color ColorBeer = Red;
extern string font_name = "Arial";
//+------------------------------------------------------------------+
int start() {
   double k = (WindowPriceMax() - WindowPriceMin()) / 20;
   for (int i = WindowFirstVisibleBar(); i >= 0; i--) {
      double rs = (NormalizeDouble(Open[i], Digits) - NormalizeDouble(Close[i], Digits)) / Point;
      if (rs < 0) drawtext(i, High[i] + k, DoubleToStr(rs * (-1), 0), ColorBull);
      if (rs > 0) drawtext(i, Low[i] - Point, DoubleToStr(rs, 0), ColorBeer);
   }
   return (0);
}
//+------------------------------------------------------------------+
int deinit() {
   ObjectsDeleteAll(0, OBJ_TEXT);
   return (0);
}
//+------------------------------------------------------------------+
int drawtext(int n, double Y1, string l, color c) {
   string Name = TimeToStr(Time[n], TIME_DATE | TIME_MINUTES);
   ObjectDelete(Name);
   ObjectCreate(Name, OBJ_TEXT, 0, Time[n], Y1, 0, 0, 0, 0);
   ObjectSetText(Name, l, font_size, font_name);
   ObjectSet(Name, OBJPROP_COLOR, c);
   return (0);
}
//+------------------------------------------------------------------+
