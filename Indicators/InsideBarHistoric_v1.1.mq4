//+------------------------------------------------------------------+
//|                                          Inside Bar historic.mq4 |
//|                                                                  |
//|                                                     EllisEdi     |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Public Domain"

#property indicator_chart_window
//#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 clrBlue
#property indicator_color2 clrRed
#property indicator_style1 STYLE_SOLID
#property indicator_style2 STYLE_SOLID
#property indicator_width1 1
#property indicator_width2 1

//---- input parameters
extern int SignalLength = 5;
extern bool ShowLabels = false;
extern int fontsize = 8;
extern bool ShowComments = true;
extern bool ShowTradingLabels = false;

//---- buffers
double IBHigh[];
double IBLow[];
string IBHighLabel = "High Price";
string IBLowLabel = "Low Price";

double LastHigh;
double LastLow;

//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit() {
   //---- TODO: add your code here

   ObjectDelete("IBHighLine");
   ObjectDelete("IBLowLine");
   if (ShowLabels) {
      ObjectDelete("IBHighLineLabel");
      ObjectDelete("IBLowLineLabel");
   }
   Comment("");

   //----
   return (0);
}
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init() {
   string short_name;

   //---- indicator line
   SetIndexStyle(0, DRAW_LINE, indicator_style1, indicator_width1, indicator_color1);
   SetIndexStyle(1, DRAW_LINE, indicator_style2, indicator_width2, indicator_color2);
   SetIndexBuffer(0, IBHigh);
   SetIndexBuffer(1, IBLow);

   //---- name for DataWindow and indicator subwindow label
   short_name = "Inbound Bar Historic";
   IndicatorShortName(short_name);
   SetIndexLabel(0, "IB_High");
   SetIndexLabel(1, "IB_Low");

   //----
   SetIndexDrawBegin(0, 1);
   //----

   //----
   return (0);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()

{
   int counted_bars = IndicatorCounted();
   int limit, i;
   //---- indicator calculation
   if (counted_bars == 0) {
      if (ShowLabels) { //for price add +DoubleToStr(PBuffer[0],4) to label text
         ObjectCreate("IBHighLineLabel", OBJ_TEXT, 0, 0, 0);
         ObjectSetText("IBHighLineLabel", "High ", fontsize, "Arial", Green);
         ObjectCreate("IBLowLineLabel", OBJ_TEXT, 0, 0, 0);
         ObjectSetText("IBLowLineLabel", "Low ", fontsize, "Arial", Red);
      }
   }
   if (counted_bars < 0) return (-1);
   //---- last counted bar will be recounted
   //   if(counted_bars>0) counted_bars--;
   limit = (Bars - counted_bars) - 1;

   for (i = limit; i >= 0; i--) {
      // Inside Bar has higher Low Price and lower High Price than previous bar and ib bar is not flat
      if ((Low[i] > Low[i + 1]) && (High[i] < High[i + 1]) && ((High[i] - Low[i]) > 0))

      /*&& IBHigh[i+SignalLength] > 10000 && IBLow[i+SignalLength] > 10000
        && IBHigh[i+SignalLength-1] > 10000 && IBLow[i+SignalLength-1] > 10000
        && IBHigh[i+SignalLength-2] > 10000 && IBLow[i+SignalLength-2] > 10000
        && IBHigh[i+SignalLength-3] > 10000 && IBLow[i+SignalLength-3] > 10000
        && IBHigh[i+SignalLength-4] > 10000 && IBLow[i+SignalLength-4] > 10000
        && IBHigh[i+SignalLength-5] > 10000 && IBLow[i+SignalLength-5] > 10000)*/
      {
         LastHigh = High[i];
         LastLow = Low[i];
         //draw line for SignalLength number of bars forward
         for (int j = 0; j <= SignalLength; j++) {
            // check to make sure there is room on the chart to draw the line forward
            if ((i - j) >= 0) {
               IBHigh[i - j] = LastHigh;
               IBLow[i - j] = LastLow;
            } // end make sure room for signal line to be drawn
         } // end draw signal line forward
      } // end if found Inside Bar
      //////////////////////////////////////////////////////////////////////////////
      if (IBHigh[i] != IBHigh[i + 1] && IBHigh[i + 1] < 10000) {
         IBHigh[i] = EMPTY_VALUE;
      }
      if (IBLow[i] != IBLow[i + 1] && IBLow[i + 1] < 10000) {
         IBLow[i] = EMPTY_VALUE;
      }
      if (ShowLabels) {
         ObjectMove("IBHighLineLabel", 0, Time[i], LastHigh);
         ObjectMove("IBLowLineLabel", 0, Time[i], LastLow);
      } // end if show labels
   } //end for loop drawing signals

   // Comment for High Low info
   if (ShowComments) {
      Comment("Last IB High = ", LastHigh, "\nLast IB Low = ", LastLow, "\nLast Inside Bar Size = ", (LastHigh - LastLow));
   } // end show comments

   //----
   return (0);
}
//+------------------------------------------------------------------+
