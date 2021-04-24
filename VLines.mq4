//+------------------------------------------------------------------+
//|                                                       VLines.mq4 |
//|                                                         Zen_Leow |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Zen_Leow"
#property link ""
#property indicator_chart_window

extern bool ShowHour1 = true;
extern int Hour_Num1 = 06;
extern int Minute_Num1 = 55;
extern string Line_Color1 = "66,66,66";
extern bool ShowHour2 = true;
extern int Hour_Num2 = 07;
extern int Minute_Num2 = 55;
extern string Line_Color2 = "44,44,44";
extern bool ShowHour3 = false;
extern int Hour_Num3 = 15;
extern int Minute_Num3 = 0;
extern string Line_Color3 = "77,77,77";
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
      if (ShowHour1 == true) {
         if (TimeHour(Time[i]) == Hour_Num1 && TimeMinute(Time[i]) == Minute_Num1) {
            if (ObjectFind("Time_vLine-" + Time[i]) != 0) {
               ObjectCreate("Time_vLine-" + Time[i], OBJ_VLINE, 0, Time[i], 0);
               ObjectSet("Time_vLine-" + Time[i], OBJPROP_COLOR, StringToColor(Line_Color1));
               ObjectSet("Time_vLine-" + Time[i], OBJPROP_STYLE, Line_Style);
               ObjectSet("Time_vLine-" + Time[i], OBJPROP_BACK, true);
            }
         }
      }

      if (ShowHour2 == true) {
         if (TimeHour(Time[i]) == Hour_Num2 && TimeMinute(Time[i]) == Minute_Num2) {
            if (ObjectFind("Time_vLine-" + Time[i]) != 0) {
               ObjectCreate("Time_vLine-" + Time[i], OBJ_VLINE, 0, Time[i], 0);
               ObjectSet("Time_vLine-" + Time[i], OBJPROP_COLOR, StringToColor(Line_Color2));
               ObjectSet("Time_vLine-" + Time[i], OBJPROP_STYLE, Line_Style);
               ObjectSet("Time_vLine-" + Time[i], OBJPROP_BACK, true);
            }
         }
      }

      if (ShowHour3 == true) {
         if (TimeHour(Time[i]) == Hour_Num3 && TimeMinute(Time[i]) == Minute_Num3) {
            if (ObjectFind("Time_vLine-" + Time[i]) != 0) {
               ObjectCreate("Time_vLine-" + Time[i], OBJ_VLINE, 0, Time[i], 0);
               ObjectSet("Time_vLine-" + Time[i], OBJPROP_COLOR, StringToColor(Line_Color3));
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
