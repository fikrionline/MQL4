//+------------------------------------------------------------------+
//|                                        fukinagashi               |
//|                 Copyright © 2000-2007, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.ru  |
//+------------------------------------------------------------------+
//Modified, 2022/jan/06, by jeanlouie, www.forexfactory.com/jeanlouie
// - fib styling
// - fib ray off to x bars time width

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 clrOrange
//---- indicator parameters
extern int ExtDepth = 12;
extern int ExtDeviation = 1;
extern int ExtBackstep = 1;

input int Fib_handle_bar_width = 5;
input color Fib_handle_clr = clrRed;
input int Fib_handle_width = 1;
input ENUM_LINE_STYLE Fib_handle_style = STYLE_DOT;
input color Fib_level_clr = clrYellow;
input int Fib_level_width = 1;
input ENUM_LINE_STYLE Fib_level_style = STYLE_SOLID;
input bool Fib_ray = true;

//---- indicator buffers
double ExtMapBuffer[];
double ExtMapBuffer2[];
int OldLastZigZag, OldPreviousZigZag;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init() {
   IndicatorBuffers(2);
   //---- drawing settings
   SetIndexStyle(0, DRAW_SECTION);
   //---- indicator buffers mapping
   SetIndexBuffer(0, ExtMapBuffer);
   SetIndexBuffer(1, ExtMapBuffer2);
   SetIndexEmptyValue(0, 0.0);
   ArraySetAsSeries(ExtMapBuffer, true);
   ArraySetAsSeries(ExtMapBuffer2, true);
   //---- indicator short name
   IndicatorShortName("Fibodrawer");
   //---- initialization done
   return (0);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit() {
   ObjectDelete("Fibo");
   return 0;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start() {
   int shift, back, lasthighpos, lastlowpos;
   double val, res;
   double curlow, curhigh, lasthigh, lastlow;
   //----
   for (shift = Bars - ExtDepth; shift >= 0; shift--) {
      val = Low[Lowest(NULL, 0, MODE_LOW, ExtDepth, shift)];
      if (val == lastlow) val = 0.0;
      else {
         lastlow = val;
         if ((Low[shift] - val) > (ExtDeviation * Point)) val = 0.0;
         else {
            for (back = 1; back <= ExtBackstep; back++) {
               res = ExtMapBuffer[shift + back];
               if ((res != 0) && (res > val)) ExtMapBuffer[shift + back] = 0.0;
            }
         }
      }
      ExtMapBuffer[shift] = val;
      //--- high
      val = High[Highest(NULL, 0, MODE_HIGH, ExtDepth, shift)];
      if (val == lasthigh) val = 0.0;
      else {
         lasthigh = val;
         if ((val - High[shift]) > (ExtDeviation * Point)) val = 0.0;
         else {
            for (back = 1; back <= ExtBackstep; back++) {
               res = ExtMapBuffer2[shift + back];
               if ((res != 0) && (res < val)) ExtMapBuffer2[shift + back] = 0.0;
            }
         }
      }
      ExtMapBuffer2[shift] = val;
   }
   // final cutting 
   lasthigh = -1;
   lasthighpos = -1;
   lastlow = -1;
   lastlowpos = -1;
   //----
   for (shift = Bars - ExtDepth; shift >= 0; shift--) {
      curlow = ExtMapBuffer[shift];
      curhigh = ExtMapBuffer2[shift];
      if ((curlow == 0) && (curhigh == 0)) continue;
      //---
      if (curhigh != 0) {
         if (lasthigh > 0) {
            if (lasthigh < curhigh) ExtMapBuffer2[lasthighpos] = 0;
            else ExtMapBuffer2[shift] = 0;
         }
         //---
         if (lasthigh < curhigh || lasthigh < 0) {
            lasthigh = curhigh;
            lasthighpos = shift;
         }
         lastlow = -1;
      }
      //----
      if (curlow != 0) {
         if (lastlow > 0) {
            if (lastlow > curlow) ExtMapBuffer[lastlowpos] = 0;
            else ExtMapBuffer[shift] = 0;
         }
         //---
         if ((curlow < lastlow) || (lastlow < 0)) {
            lastlow = curlow;
            lastlowpos = shift;
         }
         lasthigh = -1;
      }
   }
   for (shift = Bars - 1; shift >= 0; shift--) {
      if (shift >= Bars - ExtDepth) ExtMapBuffer[shift] = 0.0;
      else {
         res = ExtMapBuffer2[shift];
         if (res != 0.0) ExtMapBuffer[shift] = res;
      }
   }
   int i = 0;
   int LastZigZag, PreviousZigZag;
   int h = 0;
   while (ExtMapBuffer[h] == 0 && ExtMapBuffer2[h] == 0) {
      h++;
   }
   LastZigZag = h;
   h++;
   while (ExtMapBuffer[h] == 0 && ExtMapBuffer2[h] == 0) {
      h++;
   }
   PreviousZigZag = h;
   if (OldLastZigZag != LastZigZag || OldPreviousZigZag != PreviousZigZag) {
      OldLastZigZag = LastZigZag;
      OldPreviousZigZag = PreviousZigZag;
      ObjectDelete("Fibo");
      ObjectCreate("Fibo", OBJ_FIBO, 0, Time[PreviousZigZag], ExtMapBuffer[LastZigZag], Time[PreviousZigZag] + Fib_handle_bar_width * PeriodSeconds(), ExtMapBuffer[PreviousZigZag]);
      ObjectSetInteger(0, "Fibo", OBJPROP_COLOR, Fib_handle_clr);
      ObjectSetInteger(0, "Fibo", OBJPROP_WIDTH, Fib_handle_width);
      ObjectSetInteger(0, "Fibo", OBJPROP_STYLE, Fib_handle_style);
      ObjectSetInteger(0, "Fibo", OBJPROP_RAY_RIGHT, Fib_ray);
      ObjectSetInteger(0, "Fibo", OBJPROP_RAY, Fib_ray);
      ObjectSetInteger(0, "Fibo", OBJPROP_BACK, true);
      int levels = (int) ObjectGetInteger(0, "Fibo", OBJPROP_LEVELS);
      for (int f = 0; f <= levels; f++) {
         ObjectSetInteger(0, "Fibo", OBJPROP_LEVELCOLOR, f, Fib_level_clr);
         ObjectSetInteger(0, "Fibo", OBJPROP_LEVELSTYLE, f, Fib_level_style);
         ObjectSetInteger(0, "Fibo", OBJPROP_LEVELWIDTH, f, Fib_level_width);
         ObjectSetFiboDescription("Fibo", f, "Hello");
      }
   }
   return 0;
}
//+------------------------------------------------------------------+
