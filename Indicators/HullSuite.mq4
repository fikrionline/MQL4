//+------------------------------------------------------------------+ 
//| HMA.mq4 
//| Copyright © 2006 WizardSerg <wizardserg@mail.ru>, published by ForexMagazine #104 
//+------------------------------------------------------------------+
#property copyright "MT4 release WizardSerg <wizardserg@mail.ru>, published by ForexMagazine #104"
#property link "wizardserg@mail.ru"
#property strict
#property description "Hull Moving Averages.\n"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 clrGreen
#property indicator_color2 clrOrange
#property indicator_width1 2
#property indicator_width2 2

//---- input parameters 
input int period = 22; // HMA period
input ENUM_MA_METHOD method = MODE_LWMA; // HMA averaging method
input ENUM_APPLIED_PRICE price = PRICE_WEIGHTED; // applied price

//---- buffers 
double Uptrend[];
double Dntrend[];
double ExtMapBuffer[];

//+------------------------------------------------------------------+ 
//| Custom indicator initialization function                         | 
//+------------------------------------------------------------------+ 
int init() {
   IndicatorBuffers(3);
   SetIndexBuffer(0, Uptrend);
   SetIndexLabel(0, "HullSuiteUp");
   SetIndexBuffer(1, Dntrend);
   SetIndexLabel(1, "HullSuiteDown");
   SetIndexBuffer(2, ExtMapBuffer);
   ArraySetAsSeries(ExtMapBuffer, true);

   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 2);
   SetIndexStyle(1, DRAW_LINE, STYLE_SOLID, 2);

   IndicatorShortName("HullSuite(" + IntegerToString(period) + ")");
   return (0);
}

//+------------------------------------------------------------------+ 
//| Moving Average                                                   | 
//+------------------------------------------------------------------+ 
double WMA(int x, int p) {
   return (iMA(NULL, 0, p, 0, method, price, x));
}

//+------------------------------------------------------------------+ 
//| Custom indicator iteration function                              | 
//+------------------------------------------------------------------+ 
int start() {
   int counted_bars = IndicatorCounted();

   if (counted_bars < 0)
      return (-1);

   int x = 0;
   int p = (int) MathSqrt(period);
   int e = Bars - counted_bars + period + 1;

   double vect[], trend[];

   if (e > Bars) e = Bars;

   ArrayResize(vect, e);
   ArraySetAsSeries(vect, true);
   ArrayResize(trend, e);
   ArraySetAsSeries(trend, true);

   for (x = 0; x < e; x++) {
      vect[x] = 2 * WMA(x, period / 2) - WMA(x, period);
      // Print("Bar date/time: ", TimeToStr(Time[x]), " close: ", Close[x], " vect[", x, "] = ", vect[x], " 2*WMA(p/2) = ", 2*WMA(x, period/2), " WMA(p) = ",  WMA(x, period)); 
   }

   for (x = 0; x < e - period; x++)

      ExtMapBuffer[x] = iMAOnArray(vect, 0, p, 0, method, x);

   for (x = e - period; x >= 0; x--) {
      trend[x] = trend[x + 1];
      if (ExtMapBuffer[x] > ExtMapBuffer[x + 1]) trend[x] = 1;
      if (ExtMapBuffer[x] < ExtMapBuffer[x + 1]) trend[x] = -1;

      if (trend[x] > 0) {
         Uptrend[x] = ExtMapBuffer[x];
         if (trend[x + 1] < 0) Uptrend[x + 1] = ExtMapBuffer[x + 1];
         Dntrend[x] = EMPTY_VALUE;
      } else
      if (trend[x] < 0) {
         Dntrend[x] = ExtMapBuffer[x];
         if (trend[x + 1] > 0) Dntrend[x + 1] = ExtMapBuffer[x + 1];
         Uptrend[x] = EMPTY_VALUE;
      }

   }
   return (0);
}

//+------------------------------------------------------------------+ 
//| Custor indicator deinitialization function                       | 
//+------------------------------------------------------------------+ 
int deinit() {
   return (0);
}
