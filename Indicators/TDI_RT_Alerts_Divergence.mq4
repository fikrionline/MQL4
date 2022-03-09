//+------------------------------------------------------------------+
//|                                    Traders Dynamic Index.mq4     |
//|                                    Copyright © 2006, Dean Malone |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//|                     Traders Dynamic Index                        |
//|                                                                  |
//|  This hybrid indicator is developed to assist traders in their   |
//|  ability to decipher and monitor market conditions related to    |
//|  trend direction, market strength, and market volatility.        |
//|                                                                  | 
//|  Even though comprehensive, the T.D.I. is easy to read and use.  |
//|                                                                  |
//|  Green line = RSI Price line                                     |
//|  Red line = Trade Signal line                                    |
//|  Blue lines = Volatility Band                                    | 
//|  Yellow line = Market Base Line                                  |  
//|                                                                  |
//|  Trend Direction - Immediate and Overall                         |
//|   Immediate = Green over Red...price action is moving up.        |
//|               Red over Green...price action is moving down.      |
//|                                                                  |   
//|   Overall = Yellow line trends up and down generally between the |
//|             lines 32 & 68. Watch for Yellow line to bounces off  |
//|             these lines for market reversal. Trade long when     |
//|             price is above the Yellow line, and trade short when |
//|             price is below.                                      |        
//|                                                                  |
//|  Market Strength & Volatility - Immediate and Overall            |
//|   Immediate = Green Line - Strong = Steep slope up or down.      | 
//|                            Weak = Moderate to Flat slope.        |
//|                                                                  |               
//|   Overall = Blue Lines - When expanding, market is strong and    |
//|             trending. When constricting, market is weak and      |
//|             in a range. When the Blue lines are extremely tight  |                                                       
//|             in a narrow range, expect an economic announcement   | 
//|             or other market condition to spike the market.       |
//|                                                                  |               
//|                                                                  |
//|  Entry conditions                                                |
//|   Scalping  - Long = Green over Red, Short = Red over Green      |
//|   Active - Long = Green over Red & Yellow lines                  |
//|            Short = Red over Green & Yellow lines                 |    
//|   Moderate - Long = Green over Red, Yellow, & 50 lines           |
//|              Short= Red over Green, Green below Yellow & 50 line |
//|                                                                  |
//|  Exit conditions*                                                |   
//|   Long = Green crosses below Red                                 |
//|   Short = Green crosses above Red                                |
//|   * If Green crosses either Blue lines, consider exiting when    |
//|     when the Green line crosses back over the Blue line.         |
//|                                                                  |
//|                                                                  |
//|  IMPORTANT: The default settings are well tested and proven.     |
//|             But, you can change the settings to fit your         |
//|             trading style.                                       |
//|                                                                  |
//|                                                                  |
//|  Price & Line Type settings:                           |                
//|   RSI Price settings                                             |               
//|   0 = Close price     [DEFAULT]                                  |               
//|   1 = Open price.                                                |               
//|   2 = High price.                                                |               
//|   3 = Low price.                                                 |               
//|   4 = Median price, (high+low)/2.                                |               
//|   5 = Typical price, (high+low+close)/3.                         |               
//|   6 = Weighted close price, (high+low+close+close)/4.            |               
//|                                                                  |               
//|   RSI Price Line & Signal Line Type settings                                   |               
//|   0 = Simple moving average       [DEFAULT]                      |               
//|   1 = Exponential moving average                                 |               
//|   2 = Smoothed moving average                                    |               
//|   3 = Linear weighted moving average                             |               
//|                                                                  |
//|   Good trading,                                                  |   
//|                                                                  |
//|   Dean                                                           |                              
//+------------------------------------------------------------------+


#property indicator_separate_window
#property indicator_buffers 9
#property indicator_color1  clrMediumBlue
#property indicator_color2  clrYellow
#property indicator_color3  clrMediumBlue
#property indicator_color4  clrGreen
#property indicator_color5  clrRed
#property indicator_color6  clrGreen
#property indicator_color7  clrRed
#property indicator_color8  clrBlue
#property indicator_color9  clrMagenta

extern int            RSI_Period                   = 13;         //8-25
extern ENUM_APPLIED_PRICE RSI_Price                = PRICE_CLOSE;           //0-6
extern int            Volatility_Band              = 34;          //20-40
extern int            RSI_Price_Line               = 2;      
extern ENUM_MA_METHOD RSI_Price_Type               = MODE_SMA;           //0-3
extern int            Trade_Signal_Line            = 7;   
extern ENUM_MA_METHOD Trade_Signal_Type            = MODE_SMA;            //0-3
extern bool           alertsOn                     = true;
extern bool           alertsOnCurrent              = true;
extern bool           alertsMessage                = true;
extern bool           alertsSound                  = true;
extern bool           alertsNotify                 = false;
extern bool           alertsEmail                  = false;
extern string         soundFile                    = "tdi.wav";
extern bool           divergenceVisible            = false;             // Should the divergence be visible
extern bool           divergenceOnValuesVisible    = true;              // Divergence lines on RSI visible?
extern bool           divergenceOnChartVisible     = true;              // Divergence lines on main chart visible?
extern int            DivergearrowSize             = 1;                 // Divergence arrows size
extern double         DivergencearrowsUpperGap     = 4;                 // Upper Gap between divergence arrows and indicator line
extern double         DivergencearrowsLowerGap     = 4;                 // Lower Gap between divergence arrows and indicator line
extern bool           ShowClassicalDivergence      = true;              // Classical divergence visible
extern bool           ShowHiddenDivergence         = true;              // Hidden divergence visible
extern color          divergenceBullishColor       = clrLimeGreen;      // Bullish divergences color
extern color          divergenceBearishColor       = clrOrangeRed;      // Bearish divergences color
extern int            ClassicDivergenceUpArrowCode = 233;               // classical divergence up arrow code
extern int            ClassicDivergenceDnArrowCode = 234;               // classical divergence dn arrow code
extern int            HiddenDivergenceUpArrowCode  = 159;               // hidden divergence up arrow code
extern int            HiddenDivergenceDnArrowCode  = 159;               // hidden divergence dn arrow code
extern string         divergenceUniqueID           = "tdi divergence1"; // Unique ID for divergence lines


double RSIBuf[], UpZone[], MdZone[], DnZone[], MaBuf[], MbBuf[];
double cbulld[];
double hbulld[];
double cbeard[];
double hbeard[];
double trend[];
string shortName;

int init() {
   IndicatorBuffers(11);
   SetIndexBuffer(0, UpZone);
   SetIndexBuffer(1, MdZone);
   SetIndexBuffer(2, DnZone);
   SetIndexBuffer(3, MaBuf);
   SetIndexBuffer(4, MbBuf);
   SetIndexBuffer(5, cbulld);
   SetIndexStyle(5, DRAW_ARROW, 0, DivergearrowSize);
   SetIndexArrow(5, ClassicDivergenceUpArrowCode);
   SetIndexBuffer(6, cbeard);
   SetIndexStyle(6, DRAW_ARROW, 0, DivergearrowSize);
   SetIndexArrow(6, ClassicDivergenceDnArrowCode);
   SetIndexBuffer(7, hbulld);
   SetIndexStyle(7, DRAW_ARROW, 0, DivergearrowSize);
   SetIndexArrow(7, HiddenDivergenceUpArrowCode);
   SetIndexBuffer(8, hbeard);
   SetIndexStyle(8, DRAW_ARROW, 0, DivergearrowSize);
   SetIndexArrow(8, HiddenDivergenceDnArrowCode);
   SetIndexBuffer(9, RSIBuf);
   SetIndexBuffer(10, trend);
   SetIndexStyle(2, DRAW_LINE);
   SetIndexStyle(3, DRAW_LINE, 0, 2);
   SetIndexStyle(4, DRAW_LINE);
   SetIndexStyle(5, DRAW_LINE, 0, 2);
   SetIndexStyle(6, DRAW_LINE, 0, 2);

   SetIndexLabel(0, "VB High");
   SetIndexLabel(1, "Market Base Line");
   SetIndexLabel(2, "VB Low");
   SetIndexLabel(3, "RSI Price Line");
   SetIndexLabel(4, "Trade Signal Line");

   SetLevelValue(0, 50);
   SetLevelValue(1, 68);
   SetLevelValue(2, 32);
   SetLevelStyle(STYLE_DOT, 1, DimGray);
   shortName = divergenceUniqueID + ": Traders Dynamic Index";
   IndicatorShortName(shortName);

   return (0);
}

int deinit() {
   int lookForLength = StringLen(divergenceUniqueID);

   for (int i = ObjectsTotal() - 1; i >= 0; i--) {
      string name = ObjectName(i);
      if (StringSubstr(name, 0, lookForLength) == divergenceUniqueID) ObjectDelete(name);
   }
   return (0);
}

int start() {
   double MA, RSI[];
   ArrayResize(RSI, Volatility_Band);
   int counted_bars = IndicatorCounted();
   int limit = Bars - counted_bars - 1;
   for (int i = limit; i >= 0; i--) {
      RSIBuf[i] = (iRSI(NULL, 0, RSI_Period, RSI_Price, i));
      MA = 0;
      for (int x = i; x < i + Volatility_Band; x++) {
         RSI[x - i] = RSIBuf[x];
         MA += RSIBuf[x] / Volatility_Band;
      }
      UpZone[i] = (MA + (1.6185 * StDev(RSI, Volatility_Band)));
      DnZone[i] = (MA - (1.6185 * StDev(RSI, Volatility_Band)));
      MdZone[i] = ((UpZone[i] + DnZone[i]) / 2);
   }
   for (i = limit; i >= 0; i--) {
      MaBuf[i] = (iMAOnArray(RSIBuf, 0, RSI_Price_Line, 0, RSI_Price_Type, i));
      MbBuf[i] = (iMAOnArray(RSIBuf, 0, Trade_Signal_Line, 0, Trade_Signal_Type, i));
      trend[i] = trend[i + 1];
      if (MbBuf[i] > MdZone[i]) trend[i] = 1;
      if (MbBuf[i] < MdZone[i]) trend[i] = -1;
      if (divergenceVisible) {
         CatchBullishDivergence(MaBuf, i);
         CatchBearishDivergence(MaBuf, i);
      }
   }

   if (alertsOn) {
      if (alertsOnCurrent) {
         int whichBar = 0;
      } else {
         whichBar = 1;
      }
      if (trend[whichBar] != trend[whichBar + 1]) {
         if (trend[whichBar] == 1) doAlert(whichBar, "crossing up");
         if (trend[whichBar] == -1) doAlert(whichBar, "crossing down");
      }
   }
   return (0);
}

double StDev(double & Data[], int Per) {
   return (MathSqrt(Variance(Data, Per)));
}
double Variance(double & Data[], int Per) {
   double sum, ssum;
   for (int i = 0; i < Per; i++) {
      sum += Data[i];
      ssum += MathPow(Data[i], 2);
   }
   return ((ssum * Per - sum * sum) / (Per * (Per - 1)));
}

void doAlert(int forBar, string doWhat) {
   static string previousAlert = "nothing";
   static datetime previousTime;
   string message;

   if (previousAlert != doWhat || previousTime != Time[forBar]) {
      previousAlert = doWhat;
      previousTime = Time[forBar];

      message = StringConcatenate(Symbol(), Period(), TimeToStr(TimeLocal(), TIME_SECONDS), " TDI_RT ", doWhat);
      if (alertsMessage) Alert(message);
      if (alertsNotify) SendNotification(message);
      if (alertsEmail) SendMail(StringConcatenate(Symbol(), " TDI_RT "), message);
      if (alertsSound) PlaySound(soundFile);
   }
}

void CatchBullishDivergence(double & values[], int i) {
   i++;
   cbulld[(int) MathMin(i, Bars - 1)] = EMPTY_VALUE;
   hbulld[(int) MathMin(i, Bars - 1)] = EMPTY_VALUE;
   ObjectDelete(divergenceUniqueID + "l" + DoubleToStr(Time[(int) MathMin(i, Bars - 1)], 0));
   ObjectDelete(divergenceUniqueID + "l" + "os" + DoubleToStr(Time[(int) MathMin(i, Bars - 1)], 0));
   if (!IsIndicatorLow(values, (int) MathMin(i, Bars - 1))) return;

   int currentLow = i;
   int lastLow = GetIndicatorLastLow(values, i + 1);
   if (currentLow >= 0 && currentLow < Bars && lastLow >= 0)
      if (values[currentLow] > values[lastLow] && Low[currentLow] < Low[lastLow]) {
         if (ShowClassicalDivergence) {
            cbulld[currentLow] = values[currentLow] - DivergencearrowsLowerGap;
            if (divergenceOnChartVisible) DrawPriceTrendLine("l", Time[currentLow], Time[lastLow], Low[currentLow], Low[lastLow], divergenceBullishColor, STYLE_SOLID);
            if (divergenceOnValuesVisible) DrawIndicatorTrendLine("l", Time[currentLow], Time[lastLow], values[currentLow], values[lastLow], divergenceBullishColor, STYLE_SOLID);
         }
      }

   if (currentLow >= 0 && currentLow < Bars && lastLow >= 0)
      if (values[currentLow] < values[lastLow] && Low[currentLow] > Low[lastLow]) {
         if (ShowHiddenDivergence) {
            hbulld[currentLow] = values[currentLow] - DivergencearrowsLowerGap;
            if (divergenceOnChartVisible) DrawPriceTrendLine("l", Time[currentLow], Time[lastLow], Low[currentLow], Low[lastLow], divergenceBullishColor, STYLE_DOT);
            if (divergenceOnValuesVisible) DrawIndicatorTrendLine("l", Time[currentLow], Time[lastLow], values[currentLow], values[lastLow], divergenceBullishColor, STYLE_DOT);
         }
      }
}

void CatchBearishDivergence(double & values[], int i) {
   i++;
   cbeard[(int) MathMin(i, Bars - 1)] = EMPTY_VALUE;
   hbeard[(int) MathMin(i, Bars - 1)] = EMPTY_VALUE;
   ObjectDelete(divergenceUniqueID + "h" + DoubleToStr(Time[(int) MathMin(i, Bars - 1)], 0));
   ObjectDelete(divergenceUniqueID + "h" + "os" + DoubleToStr(Time[(int) MathMin(i, Bars - 1)], 0));
   if (IsIndicatorPeak(values, (int) MathMin(i, Bars - 1)) == false) return;

   int currentPeak = i;
   int lastPeak = GetIndicatorLastPeak(values, i + 1);
   if (currentPeak >= 0 && currentPeak < Bars && lastPeak >= 0)
      if (values[currentPeak] < values[lastPeak] && High[currentPeak] > High[lastPeak]) {
         if (ShowClassicalDivergence) {
            cbeard[currentPeak] = values[currentPeak] + DivergencearrowsUpperGap;
            if (divergenceOnChartVisible) DrawPriceTrendLine("h", Time[currentPeak], Time[lastPeak], High[currentPeak], High[lastPeak], divergenceBearishColor, STYLE_SOLID);
            if (divergenceOnValuesVisible) DrawIndicatorTrendLine("h", Time[currentPeak], Time[lastPeak], values[currentPeak], values[lastPeak], divergenceBearishColor, STYLE_SOLID);
         }
      }
   if (currentPeak >= 0 && currentPeak < Bars && lastPeak >= 0)
      if (values[currentPeak] > values[lastPeak] && High[currentPeak] < High[lastPeak]) {
         if (ShowHiddenDivergence) {
            hbeard[currentPeak] = values[currentPeak] + DivergencearrowsUpperGap;
            if (divergenceOnChartVisible) DrawPriceTrendLine("h", Time[currentPeak], Time[lastPeak], High[currentPeak], High[lastPeak], divergenceBearishColor, STYLE_DOT);
            if (divergenceOnValuesVisible) DrawIndicatorTrendLine("h", Time[currentPeak], Time[lastPeak], values[currentPeak], values[lastPeak], divergenceBearishColor, STYLE_DOT);
         }
      }
}

bool IsIndicatorPeak(double & values[], int i) {
   return (values[i] >= values[(int) MathMin(i + 1, Bars - 1)] && values[i] > values[(int) MathMin(i + 2, Bars - 1)] && values[i] > values[(int) MathMax(i - 1, 0)]);
}
bool IsIndicatorLow(double & values[], int i) {
   return (values[i] <= values[(int) MathMin(i + 1, Bars - 1)] && values[i] < values[(int) MathMin(i + 2, Bars - 1)] && values[i] < values[(int) MathMax(i - 1, 0)]);
}

int GetIndicatorLastPeak(double & values[], int shift) {
   for (int i = shift + 5; i < Bars && (i + 2) < (Bars - 1) && (i - 2) >= 0; i++)
      if (values[i] >= values[i + 1] && values[i] > values[i + 2] && values[i] >= values[i - 1] && values[i] > values[i - 2]) return (i);
   return (-1);
}
int GetIndicatorLastLow(double & values[], int shift) {
   for (int i = shift + 5; i < Bars && (i + 2) < (Bars - 1) && (i - 2) >= 0; i++)
      if (values[i] <= values[i + 1] && values[i] < values[i + 2] && values[i] <= values[i - 1] && values[i] < values[i - 2]) return (i);
   return (-1);
}

void DrawPriceTrendLine(string first, datetime t1, datetime t2, double p1, double p2, color lineColor, double style) {
   string label = divergenceUniqueID + first + "os" + DoubleToStr(t1, 0);
   ObjectDelete(label);
   ObjectCreate(label, OBJ_TREND, 0, t1 + Period() * 60 - 1, p1, t2, p2, 0, 0);
   ObjectSet(label, OBJPROP_RAY, false);
   ObjectSet(label, OBJPROP_COLOR, lineColor);
   ObjectSet(label, OBJPROP_STYLE, style);
}
void DrawIndicatorTrendLine(string first, datetime t1, datetime t2, double p1, double p2, color lineColor, double style) {
   int indicatorWindow = WindowFind(shortName);
   if (indicatorWindow < 0) return;
   string label = divergenceUniqueID + first + DoubleToStr(t1, 0);
   ObjectDelete(label);
   ObjectCreate(label, OBJ_TREND, indicatorWindow, t1 + Period() * 60 - 1, p1, t2, p2, 0, 0);
   ObjectSet(label, OBJPROP_RAY, false);
   ObjectSet(label, OBJPROP_COLOR, lineColor);
   ObjectSet(label, OBJPROP_STYLE, style);
}
