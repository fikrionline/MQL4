//+------------------------------------------------------------------+
//|                                         Candle_Range_in_pips.mq4 |
//|                                                         Zen_Leow |
//|                                                                  |  
//| 5.12.14 mod poruchik - (draw HISTOGRAM)                          |     
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Zen_Leow"
#property link ""

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Blue
#property indicator_width1 2

double Range_Buffer[];

int PipFactor = 1;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init() {
   //---- indicators
   //---- drawing settings
   SetIndexStyle(0, DRAW_HISTOGRAM);
   SetIndexBuffer(0, Range_Buffer);
   SetIndexLabel(0, "Size");

   //---- name for DataWindow and indicator subwindow label
   IndicatorShortName("CandleSize");
   IndicatorDigits(1);
   // Cater for fractional pips
   if (Digits == 3 || Digits == 5) {
      PipFactor = 10;
   }
   //---- initialization done
   return (0);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit() {
   //----

   //----
   return (0);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start() {
   int limit;
   int counted_bars = IndicatorCounted();
   //---- last counted bar will be recounted
   if (counted_bars > 0) counted_bars--;
   limit = Bars - counted_bars;

   for (int i = 0; i < limit; i++)
      Range_Buffer[i] = ((High[i] - Low[i]) / Point) / PipFactor;
   //---- done
   return (0);
}
//+------------------------------------------------------------------+
