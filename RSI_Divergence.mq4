//+------------------------------------------------------------------+
//|                                               RSI Divergence.mq4 |
//|                              "Copyright © 2012, The lazy trader" |
//|                                            "the-lazy-trader.com" |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2012, The lazy trader"
#property link "the-lazy-trader.com"
//----
#property indicator_separate_window
#property indicator_buffers 6
#property indicator_color1 Green
#property indicator_color2 Red
#property indicator_color3 Magenta
#property indicator_level1 30
#property indicator_level2 50
#property indicator_level3 70
#property indicator_minimum 0
#property indicator_maximum 100

//----
#define arrowsDisplacement 0.0003
//---- input parameters
extern string separator1 = "*** RSI Settings ***";
extern int period = 14;
input ENUM_APPLIED_PRICE Apply_To = PRICE_CLOSE;
extern string separator2 = "*** Indicator Settings ***";
extern int scan_width = 20;
extern bool drawIndicatorTrendLines = true;
extern bool drawPriceTrendLines = true;
extern bool displayAlert = true;
extern bool DisplayClassicalDivergences = true;
extern bool DisplayHiddenDivergences = false;
//---- buffers
double bullishDivergence[];
double bearishDivergence[];
double rsi[];
double divergencesType[];
double divergencesRSIDiff[];
double divergencesPriceDiff[];

//----
static datetime lastAlertTime;
static string indicatorName;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init() {
   //---- indicators
   SetIndexStyle(0, DRAW_ARROW);
   SetIndexStyle(1, DRAW_ARROW);
   SetIndexStyle(2, DRAW_LINE);
   //SetIndexStyle(3, DRAW_LINE);

   //----   
   SetIndexBuffer(0, bullishDivergence);
   SetIndexBuffer(1, bearishDivergence);
   SetIndexBuffer(2, rsi);
   SetIndexBuffer(3, divergencesType);
   SetIndexBuffer(4, divergencesRSIDiff);
   SetIndexBuffer(5, divergencesPriceDiff);
   //----   
   SetIndexArrow(0, 233);
   SetIndexArrow(1, 234);
   //----
   indicatorName = "RSI_Divergence_(" + period + ")";
   SetIndexDrawBegin(3, period);
   IndicatorDigits(Digits + 2);
   IndicatorShortName(indicatorName);

   return (0);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit() {
   for (int i = ObjectsTotal() - 1; i >= 0; i--) {
      string label = ObjectName(i);
      if (StringSubstr(label, 0, 18) != "RSI_DivergenceLine")
         continue;
      ObjectDelete(label);
   }

   return (0);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start() {
   int countedBars = IndicatorCounted();
   if (countedBars < 0)
      countedBars = 0;
   CalculateIndicator(countedBars);
   return (0);
}

void CalculateIndicator(int countedBars) {
   for (int i = Bars - countedBars; i >= 0; i--) {
      CalculateRSI(i);
      CatchBullishDivergence(i + 2);
      CatchBearishDivergence(i + 2);
   }
}

void CalculateRSI(int i) {
   rsi[i] = iRSI(NULL, 0, period, Apply_To, i);
}

void CatchBullishDivergence(int shift) {
   if (IsIndicatorTrough(shift) == false)
      return;

   int currentTrough = shift;
   int lastTrough = GetIndicatorLastTrough(shift);

   //--CLASSIC DIVERGENCE--//
   if (DisplayClassicalDivergences == true) {
      if (rsi[currentTrough] > rsi[lastTrough] && Low[currentTrough] < Low[lastTrough]) {
         bullishDivergence[currentTrough] = rsi[currentTrough] - arrowsDisplacement;

         divergencesType[currentTrough] = 1; //"Classic Bullish";
         divergencesRSIDiff[currentTrough] = MathAbs(rsi[currentTrough] - rsi[lastTrough]);
         divergencesPriceDiff[currentTrough] = MathAbs(Low[currentTrough] - Low[lastTrough]);

         if (drawPriceTrendLines == true)
            DrawPriceTrendLine(Time[currentTrough], Time[lastTrough],
               Low[currentTrough],
               Low[lastTrough], Green, STYLE_SOLID);

         if (drawIndicatorTrendLines == true)
            DrawIndicatorTrendLine(Time[currentTrough],
               Time[lastTrough],
               rsi[currentTrough],
               rsi[lastTrough],
               Green, STYLE_SOLID);

         if (displayAlert == true)
            DisplayAlert("Classical RSI bullish divergence on: ", currentTrough);
      }
   }

   //-----HIDDEN DIVERGENCE--//
   if (DisplayHiddenDivergences == true) {
      if (rsi[currentTrough] < rsi[lastTrough] && Low[currentTrough] > Low[lastTrough]) {
         bullishDivergence[currentTrough] = rsi[currentTrough] - arrowsDisplacement;

         divergencesType[currentTrough] = 2; //"Hidden Bullish";
         divergencesRSIDiff[currentTrough] = MathAbs(rsi[currentTrough] - rsi[lastTrough]);
         divergencesPriceDiff[currentTrough] = MathAbs(Low[currentTrough] - Low[lastTrough]);

         if (drawPriceTrendLines == true)
            DrawPriceTrendLine(Time[currentTrough], Time[lastTrough],
               Low[currentTrough],
               Low[lastTrough], Green, STYLE_DOT);

         if (drawIndicatorTrendLines == true)
            DrawIndicatorTrendLine(Time[currentTrough],
               Time[lastTrough],
               rsi[currentTrough],
               rsi[lastTrough],
               Green, STYLE_DOT);

         if (displayAlert == true)
            DisplayAlert("Hidden RSI bullish divergence on: ", currentTrough);
      }
   }

}

void CatchBearishDivergence(int shift) {
   if (IsIndicatorPeak(shift) == false)
      return;
   int currentPeak = shift;
   int lastPeak = GetIndicatorLastPeak(shift);

   //-- CLASSIC DIVERGENCE --//
   if (DisplayClassicalDivergences == true) {
      if (rsi[currentPeak] < rsi[lastPeak] && High[currentPeak] > High[lastPeak]) {
         bearishDivergence[currentPeak] = rsi[currentPeak] + arrowsDisplacement;

         divergencesType[currentPeak] = 3; //"Classic Bearish";
         divergencesRSIDiff[currentPeak] = MathAbs(rsi[currentPeak] - rsi[lastPeak]);
         divergencesPriceDiff[currentPeak] = MathAbs(Low[currentPeak] - Low[lastPeak]);

         if (drawPriceTrendLines == true)
            DrawPriceTrendLine(Time[currentPeak], Time[lastPeak],
               High[currentPeak],
               High[lastPeak], Red, STYLE_SOLID);

         if (drawIndicatorTrendLines == true)
            DrawIndicatorTrendLine(Time[currentPeak], Time[lastPeak],
               rsi[currentPeak],
               rsi[lastPeak], Red, STYLE_SOLID);

         if (displayAlert == true)
            DisplayAlert("Classical RSI bearish divergence on: ", currentPeak);
      }
   }

   //----HIDDEN DIVERGENCE----//
   if (DisplayHiddenDivergences == true) {
      if (rsi[currentPeak] > rsi[lastPeak] && High[currentPeak] < High[lastPeak]) {
         bearishDivergence[currentPeak] = rsi[currentPeak] + arrowsDisplacement;

         divergencesType[currentPeak] = 4; //"Hidden Bearish";
         divergencesRSIDiff[currentPeak] = MathAbs(rsi[currentPeak] - rsi[lastPeak]);
         divergencesPriceDiff[currentPeak] = MathAbs(Low[currentPeak] - Low[lastPeak]);

         if (drawPriceTrendLines == true)
            DrawPriceTrendLine(Time[currentPeak], Time[lastPeak],
               High[currentPeak],
               High[lastPeak], Red, STYLE_DOT);

         if (drawIndicatorTrendLines == true)
            DrawIndicatorTrendLine(Time[currentPeak], Time[lastPeak],
               rsi[currentPeak],
               rsi[lastPeak], Red, STYLE_DOT);

         if (displayAlert == true)
            DisplayAlert("Hidden RSI bearish divergence on: ", currentPeak);
      }
   }
   
}

bool IsIndicatorPeak(int shift) {
   if (rsi[shift] >= rsi[shift + 1] && rsi[shift] > rsi[shift + 2] && rsi[shift] > rsi[shift - 1])
      return (true);
   else
      return (false);
}

bool IsIndicatorTrough(int shift) {
   if (rsi[shift] <= rsi[shift + 1] && rsi[shift] < rsi[shift + 2] && rsi[shift] < rsi[shift - 1])
      return (true);
   else
      return (false);
}

int GetIndicatorLastPeak(int shift) {
   for (int j = shift + scan_width; j < Bars; j++) {
      if (rsi[j] >= rsi[j + 1] && rsi[j] > rsi[j + 2] &&
         rsi[j] >= rsi[j - 1] && rsi[j] > rsi[j - 2])
         return (j);
   }
   return (-1);
}

int GetIndicatorLastTrough(int shift) {
   for (int j = shift + scan_width; j < Bars; j++) {
      if (rsi[j] <= rsi[j + 1] && rsi[j] < rsi[j + 2] &&
         rsi[j] <= rsi[j - 1] && rsi[j] < rsi[j - 2])
         return (j);
   }
   return (-1);
}

void DisplayAlert(string message, int shift) {
   if (shift <= 2 && Time[shift] != lastAlertTime) {
      lastAlertTime = Time[shift];
      Alert(message, Symbol(), " , ", Period(), " minutes chart");
   }
}

void DrawPriceTrendLine(datetime x1, datetime x2, double y1, double y2, color lineColor, double style) {
   string label = "RSI_DivergenceLine_v1# " + DoubleToStr(x1, 0);
   ObjectDelete(label);
   ObjectCreate(label, OBJ_TREND, 0, x1, y1, x2, y2, 0, 0);
   ObjectSet(label, OBJPROP_RAY, 0);
   ObjectSet(label, OBJPROP_COLOR, lineColor);
   ObjectSet(label, OBJPROP_STYLE, style);
}

void DrawIndicatorTrendLine(datetime x1, datetime x2, double y1, double y2, color lineColor, double style) {
   int indicatorWindow = WindowFind(indicatorName);
   if (indicatorWindow < 0)
      return;
   string label = "RSI_DivergenceLine_v1$# " + DoubleToStr(x1, 0);
   ObjectDelete(label);
   ObjectCreate(label, OBJ_TREND, indicatorWindow, x1, y1, x2, y2, 0, 0);
   ObjectSet(label, OBJPROP_RAY, 0);
   ObjectSet(label, OBJPROP_COLOR, lineColor);
   ObjectSet(label, OBJPROP_STYLE, style);
}
