//+------------------------------------------------------------------+
//|                                           NYSE_trading_hours.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

extern bool StartNYSE = true;
extern int StartHour = 16;
extern int StartMinute = 30;
extern color Line_Color1 = Green;
extern bool EndNYSE = true;
extern int EndHour = 23;
extern int EndMinute = 00;
extern color Line_Color2 = DarkOliveGreen;
extern int Line_Style = 2; // 1=SOLID, 2=DASH, 3=DOT, 4=DASHDOT, 5=DASHDOTDOT

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

   int ObjectCount = ObjectsTotal();
   for (int i = ObjectCount - 1; i >= 0; i--) {
      if (StringFind(ObjectName(i), "Time_vLine-") != -1) {
         ObjectDelete(ObjectName(i));
      }
   }

   return (0);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start() {
   int Counted_bars = IndicatorCounted(); // Number of counted bars
   int i = Bars - Counted_bars - 1; // Index of the first uncounted

   while (i >= 0) // Loop for uncounted bars
   {
      if (StartNYSE == true) {
         if (TimeHour(Time[i]) == StartHour && TimeMinute(Time[i]) == StartMinute) {
            if (ObjectFind("Time_vLine-" + Time[i]) != 0) {
               ObjectCreate("Time_vLine-" + Time[i], OBJ_VLINE, 0, Time[i], 0);
               ObjectSet("Time_vLine-" + Time[i], OBJPROP_COLOR, Line_Color1);
               ObjectSet("Time_vLine-" + Time[i], OBJPROP_STYLE, Line_Style);
               ObjectSet("Time_vLine-" + Time[i], OBJPROP_BACK, true);
            }
         }
      }

      if (EndNYSE == true) {
         if (TimeHour(Time[i]) == EndHour && TimeMinute(Time[i]) == EndMinute) {
            if (ObjectFind("Time_vLine-" + Time[i]) != 0) {
               ObjectCreate("Time_vLine-" + Time[i], OBJ_VLINE, 0, Time[i], 0);
               ObjectSet("Time_vLine-" + Time[i], OBJPROP_COLOR, Line_Color2);
               ObjectSet("Time_vLine-" + Time[i], OBJPROP_STYLE, Line_Style);
               ObjectSet("Time_vLine-" + Time[i], OBJPROP_BACK, true);
            }
         }
      }

      i--;

   }

   return (0);

}
//+------------------------------------------------------------------+