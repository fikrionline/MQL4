//+------------------------------------------------------------------+
//|                                                  Time_vLines.mq4 |
//|                                                         Zen_Leow |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Zen_Leow"
#property link ""

#property indicator_chart_window

extern int Hour_Num = 0;
extern int Minute_Num = 0;
extern color Line_Color = C'78,78,78';
extern int Line_Style = 2; // 1=SOLID, 2=DASH, 3=DOT, 4=DASHDOT, 5=DASHDOTDOT
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init() {
   //---- indicators
   //----
   return (0);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit() {
   //----
   int ObjectCount = ObjectsTotal();
   for (int i = ObjectCount - 1; i >= 0; i--) {
      if (StringFind(ObjectName(i), "Time_vLine-") != -1) {
         ObjectDelete(ObjectName(i));
      }
   }
   //----
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
      if (TimeHour(Time[i]) == Hour_Num && TimeMinute(Time[i]) == Minute_Num) {
         if (ObjectFind("Time_vLine-" + Time[i]) != 0) {
            ObjectCreate("Time_vLine-" + Time[i], OBJ_VLINE, 0, Time[i], 0);
            ObjectSet("Time_vLine-" + Time[i], OBJPROP_COLOR, Line_Color);
            ObjectSet("Time_vLine-" + Time[i], OBJPROP_STYLE, Line_Style);

         }
      }

      /*if(TimeHour(Time[i]) == 2 && TimeMinute(Time[i]) == Minute_Num)
      {
         if (ObjectFind("Time_vLine-"+Time[i]) != 0)
         {
            ObjectCreate( "Time_vLine-"+Time[i], OBJ_VLINE, 0, Time[i], 0 );
            ObjectSet( "Time_vLine-"+Time[i], OBJPROP_COLOR, Lime);
            ObjectSet( "Time_vLine-"+Time[i], OBJPROP_STYLE, Line_Style);

         }
      }
      
      if(TimeHour(Time[i]) == 15 && TimeMinute(Time[i]) == Minute_Num)
      {
         if (ObjectFind("Time_vLine-"+Time[i]) != 0)
         {
            ObjectCreate( "Time_vLine-"+Time[i], OBJ_VLINE, 0, Time[i], 0 );
            ObjectSet( "Time_vLine-"+Time[i], OBJPROP_COLOR,  Red);
            ObjectSet( "Time_vLine-"+Time[i], OBJPROP_STYLE, Line_Style);

         }
      }*/

      i--;
   }
   //----
   return (0);
}
//+------------------------------------------------------------------+
