//------------------------------------------------------------------
#property copyright "copyleft malden"
#property link      "www.forex-station.com"
//------------------------------------------------------------------
#property indicator_chart_window
#property indicator_buffers 7
#property indicator_width3  2
#property indicator_width4  2
#property indicator_width5  2


#define _disBar 1
#define _disLin 2
#define _disZer 4
enum enDisplayType
{
   dis_01      = _disLin,                 // Display bb stops line
   dis_02      = _disBar,                 // Display bb stops bars
   dis_03      = _disZer,                 // Display bb stops "zero" line
   dis_04      = _disLin+_disBar,         // Display bb stops line and bars
   dis_05      = _disLin+_disZer,         // Display bb stops line and "zero" line
   dis_06      = _disBar+_disZer,         // Display bb stops bars and "zero" line
   Display_All = _disLin+_disBar+_disZer  // Display all
};


enum enPrices
{
   pr_close,      // Close
   pr_open,       // Open
   pr_high,       // High
   pr_low,        // Low
   pr_median,     // Median
   pr_typical,    // Typical
   pr_weighted,   // Weighted
   pr_average,    // Average (high+low+open+close)/4
   pr_medianb,    // Average median body (open+close)/2
   pr_tbiased,    // Trend biased price
   pr_tbiased2,   // Trend biased (extreme) price
   pr_haclose,    // Heiken ashi close
   pr_haopen ,    // Heiken ashi open
   pr_hahigh,     // Heiken ashi high
   pr_halow,      // Heiken ashi low
   pr_hamedian,   // Heiken ashi median
   pr_hatypical,  // Heiken ashi typical
   pr_haweighted, // Heiken ashi weighted
   pr_haaverage,  // Heiken ashi average
   pr_hamedianb,  // Heiken ashi median body
   pr_hatbiased,  // Heiken ashi trend biased price
   pr_hatbiased2, // Heiken ashi trend biased (extreme) price
   pr_habclose,   // Heiken ashi (better formula) close
   pr_habopen ,   // Heiken ashi (better formula) open
   pr_habhigh,    // Heiken ashi (better formula) high
   pr_hablow,     // Heiken ashi (better formula) low
   pr_habmedian,  // Heiken ashi (better formula) median
   pr_habtypical, // Heiken ashi (better formula) typical
   pr_habweighted,// Heiken ashi (better formula) weighted
   pr_habaverage, // Heiken ashi (better formula) average
   pr_habmedianb, // Heiken ashi (better formula) median body
   pr_habtbiased, // Heiken ashi (better formula) trend biased price
   pr_habtbiased2 // Heiken ashi (better formula) trend biased (extreme) price
};
enum enMaTypes
{
   ma_sma,     // Simple moving average
   ma_ema,     // Exponential moving average
   ma_smma,    // Smoothed MA
   ma_lwma,    // Linear weighted MA
   ma_slwma,   // Smoothed LWMA
   ma_dsema,   // Double Smoothed Exponential average
   ma_tema,    // Triple exponential moving average - TEMA
   ma_lsma     // Linear regression value (lsma)
};

//AHTF Timeframe template copy and paste start11
enum enTimeFrames
{
   tf_cu  = PERIOD_CURRENT, // Current time frame
   tf_m1  = PERIOD_M1,      // 1 minute
   tf_m5  = PERIOD_M5,      // 5 minutes
   tf_m15 = PERIOD_M15,     // 15 minutes
   tf_m30 = PERIOD_M30,     // 30 minutes
   tf_h1  = PERIOD_H1,      // 1 hour
   tf_h4  = PERIOD_H4,      // 4 hours
   tf_d1  = PERIOD_D1,      // Daily
   tf_w1  = PERIOD_W1,      // Weekly
   tf_mn1 = PERIOD_MN1,     // Monthly
   tf_n1  = -1,             // First higher time frame
   tf_n2  = -2,             // Second higher time frame
   tf_n3  = -3              // Third higher time frame
};
//AHTF Timeframe template copy and paste end11

//AHTF Timeframe template copy and paste start12
extern enTimeFrames    TimeFrame            = tf_cu;            // Time frame
//AHTF Timeframe template copy and paste end12

extern int             BandsPeriod          = 22;               // Bands period
extern double          BandsDeviation       = 1;                // Bands deviation
extern bool            BandsDeviationSample = false;            // Bands deviation with sample correction?
extern double          BandsRisk            = 1;                // Bands risk
extern enMaTypes       BandsMaType          = ma_sma;           // Bands average type
extern enPrices        Price                = pr_close;         // Price

//Forex-Station Zone template copy and paste start 1
extern bool            ShowZones            = false;             // Display the background zones
extern color           ZoneColorUp          = clrHoneydew;      // Uptrend Zone color
extern color           ZoneColorDown        = clrLavenderBlush; // Downtrend Zone color
extern string          UniqueZoneID         = "BBstopsZones1";  // Unique ID for the zones
//Forex-Station Zone template copy and paste end 1

extern bool            alertsOn             = false;            // Turn alerts on?
extern bool            alertsOnCurrent      = false;            // Alerts on still opened bar?
extern bool            alertsMessage        = false;             // Alerts should display message?
extern bool            alertsSound          = false;            // Alerts should play a sound?
extern bool            alertsNotify         = false;            // Alerts should send a notification?
extern bool            alertsEmail          = false;            // Alerts should send an email?
extern string          soundFile            = "alert.wav";     // Sound file
extern enDisplayType   DisplayWhat          = dis_01;      // Display type
extern color           ColorUp              = clrBlue;     // Color for up
extern color           ColorDn              = clrRed;     // Color for down
extern color           ColorNe              = clrNONE;      // Color for neutral and "zero" line
extern bool            Interpolate          = false;             // Interpolate in multi time frame mode?
//Forex-Station Zone template copy and paste start 2
double Dummy = -1;
//Forex-Station Zone template copy and paste end 2

double upb[], dnb[], upa[], dna[], histou[], histod[], zero[], amax[], amin[], bmin[], bmax[], trend[], count[];
string indicatorFileName;
#define _mtfCall(_buff, _y) iCustom(NULL, TimeFrame, indicatorFileName, PERIOD_CURRENT, BandsPeriod, BandsDeviation, BandsDeviationSample, BandsRisk, BandsMaType, Price, ShowZones, ZoneColorUp, ZoneColorDown, UniqueZoneID, alertsOn, alertsOnCurrent, alertsMessage, alertsSound, alertsNotify, alertsEmail, soundFile, _buff, _y)

int init() {
   int czer = ((DisplayWhat & _disZer) == 0) ? clrNONE : ColorNe;
   int chup = ((DisplayWhat & _disBar) == 0) ? clrNONE : ColorUp;
   int chdn = ((DisplayWhat & _disBar) == 0) ? clrNONE : ColorDn;
   int clup = ((DisplayWhat & _disLin) == 0) ? clrNONE : ColorUp;
   int cldn = ((DisplayWhat & _disLin) == 0) ? clrNONE : ColorDn;
   int arst = ((DisplayWhat & _disLin) == 0) ? DRAW_LINE : DRAW_ARROW;
   IndicatorBuffers(13);
   SetIndexBuffer(0, histou);
   SetIndexStyle(0, DRAW_HISTOGRAM, EMPTY, EMPTY, chup);
   SetIndexLabel(0, "CandlesUp");
   SetIndexBuffer(1, histod);
   SetIndexStyle(1, DRAW_HISTOGRAM, EMPTY, EMPTY, chdn);
   SetIndexLabel(1, "CandlesDown");
   SetIndexBuffer(2, zero);
   SetIndexStyle(2, EMPTY, STYLE_DOT, 0, czer);
   SetIndexLabel(2, "BandsPeriod(" + IntegerToString(BandsPeriod) + ")");
   SetIndexBuffer(3, upb);
   SetIndexStyle(3, EMPTY, EMPTY, EMPTY, clup);
   SetIndexLabel(3, "TrendUp");
   SetIndexBuffer(4, dnb);
   SetIndexStyle(4, EMPTY, EMPTY, EMPTY, cldn);
   SetIndexLabel(4, "TrendDown");
   SetIndexBuffer(5, upa);
   SetIndexStyle(5, arst, EMPTY, EMPTY, clup);
   SetIndexArrow(5, 233);
   SetIndexBuffer(6, dna);
   SetIndexStyle(6, arst, EMPTY, EMPTY, cldn);
   SetIndexArrow(6, 234);
   SetIndexBuffer(7, amax);
   SetIndexBuffer(8, amin);
   SetIndexBuffer(9, bmax);
   SetIndexBuffer(10, bmin);
   SetIndexBuffer(11, trend);
   SetIndexBuffer(12, count);

   //
   //
   //
   //
   //

   indicatorFileName = WindowExpertName();

   //AHTF Timeframe Timeframe template copy and paste start13
   TimeFrame = (enTimeFrames) timeFrameValue(TimeFrame);
   //AHTF Timeframe Timeframe template copy and paste end13
   IndicatorShortName(timeFrameToString(TimeFrame) + "/FollowLineIndicator");
   return (0);
}
//+------------------------------------------------------------------------------------------------------------------+
//AHTF Timeframe template copy and paste start14
int timeFrameValue(int _tf) {
   int add = (_tf >= 0) ? 0 : MathAbs(_tf);
   if (add != 0) _tf = _Period;
   int size = ArraySize(iTfTable);
   int i = 0;
   for (; i < size; i++)
      if (iTfTable[i] == _tf) break;
   if (i == size) return (_Period);
   return (iTfTable[(int) MathMin(i + add, size - 1)]);
}
//AHTF Timeframe template copy and paste end14
//+------------------------------------------------------------------------------------------------------------------+

//Forex-Station Zone template copy and paste start 3
int deinit() {
   string lookFor2 = UniqueZoneID + ":";
   int lookForLength2 = StringLen(lookFor2);
   for (int ForexStation = ObjectsTotal() - 1; ForexStation >= 0; ForexStation--) {
      string objectName2 = ObjectName(ForexStation);
      if (StringSubstr(objectName2, 0, lookForLength2) == lookFor2) ObjectDelete(objectName2);
   }
   GlobalVariableDel(ChartID() + ":" + UniqueZoneID);
   return (0);
}
//+------------------------------------------------------------------------------------------------------------------+
//Forex-Station Zone template copy and paste end 3

int OnCalculate(const int rates_total,
   const int prev_calculated,
      const datetime & btime[],
         const double & open[],
            const double & high[],
               const double & low[],
                  const double & close[],
                     const long & tick_volume[],
                        const long & volume[],
                           const int & spread[]) {

   int counted_bars = prev_calculated;
   if (counted_bars < 0) return (-1);
   if (counted_bars > 0) counted_bars--;
   int limit = MathMin(rates_total - counted_bars, rates_total - 1);
   count[0] = limit;

   //Forex-Station Zone template copy and paste start 4
   datetime tDummy = GlobalVariableGet(ChartID() + ":" + UniqueZoneID);
   if (tDummy == 0) tDummy = Time[0];
   //Forex-Station Zone template copy and paste end 4

   if (TimeFrame != _Period) {
      //Forex-Station Zone template copy and paste start 6
      GlobalVariableSet(ChartID() + ":" + UniqueZoneID, Time[0] + _Period * 60 - 1);
      //Forex-Station Zone template copy and paste end 6

      limit = (int) MathMax(limit, MathMin(rates_total - 1, _mtfCall(12, 0) * TimeFrame / _Period));
      for (int i = limit; i >= 0; i--) {
         int y = iBarShift(NULL, TimeFrame, btime[i]);
         zero[i] = _mtfCall(2, y);
         bmax[i] = _mtfCall(9, y);
         bmin[i] = _mtfCall(10, y);
         trend[i] = _mtfCall(11, y);
         if (!Interpolate || (i > 0 && y == iBarShift(NULL, TimeFrame, btime[i - 1]))) continue;

         //
         //
         //
         //
         //

         #define _interpolate(buff) buff[i + k] = buff[i] + (buff[i + n] - buff[i]) * k / n
         int n, k;
         datetime time = iTime(NULL, TimeFrame, y);
         for (n = 1;
            (i + n) < rates_total && btime[i + n] >= time; n++) continue;
         for (k = 1; k < n && (i + n) < rates_total && (i + k) < rates_total; k++) {
            _interpolate(zero);
            _interpolate(bmax);
            _interpolate(bmin);
         }
      }
      for (int i2 = limit; i2 >= 0; i2--) {
         upb[i2] = dnb[i2] = EMPTY_VALUE;
         if (trend[i2] == 1) {
            upb[i2] = bmin[i2];
            histou[i2] = high[i2];
            histod[i2] = low[i2];
         }
         if (trend[i2] == -1) {
            dnb[i2] = bmax[i2];
            histod[i2] = high[i2];
            histou[i2] = low[i2];
         }
         upa[i2] = (i2 < Bars - 1) ? (trend[i2] != trend[i2 + 1] && trend[i2] == 1) ? upb[i2] : EMPTY_VALUE : EMPTY_VALUE;
         dna[i2] = (i2 < Bars - 1) ? (trend[i2] != trend[i2 + 1] && trend[i2] == -1) ? dnb[i2] : EMPTY_VALUE : EMPTY_VALUE;
      }
      return (rates_total);
   }

   //
   //
   //
   //
   //

   for (i = limit; i >= 0; i--) {
      double price = getPrice(Price, open, close, high, low, i, Bars);
      double dev = iDeviation(price, BandsPeriod, BandsDeviationSample, i, Bars);
      zero[i] = iCustomMa(BandsMaType, price, BandsPeriod, i, Bars);
      amax[i] = zero[i] + dev * BandsDeviation;
      amin[i] = zero[i] - dev * BandsDeviation;
      bmax[i] = amax[i] + 0.5 * (BandsRisk - 1) * (amax[i] - amin[i]);
      bmin[i] = amin[i] - 0.5 * (BandsRisk - 1) * (amax[i] - amin[i]);
      trend[i] = (i < Bars - 1) ? (price > amax[i + 1]) ? 1 : (price < amin[i + 1]) ? -1 : trend[i + 1] : 0;
      if (i < Bars - 1) {
         if (trend[i] == -1 && amax[i] > amax[i + 1]) amax[i] = amax[i + 1];
         if (trend[i] == 1 && amin[i] < amin[i + 1]) amin[i] = amin[i + 1];
         if (trend[i] == -1 && bmax[i] > bmax[i + 1]) bmax[i] = bmax[i + 1];
         if (trend[i] == 1 && bmin[i] < bmin[i + 1]) bmin[i] = bmin[i + 1];
      }
      upb[i] = EMPTY_VALUE;
      dnb[i] = EMPTY_VALUE;
      if (trend[i] == 1) {
         upb[i] = bmin[i];
         histou[i] = high[i];
         histod[i] = low[i];
      }
      if (trend[i] == -1) {
         dnb[i] = bmax[i];
         histod[i] = high[i];
         histou[i] = low[i];
      }
      upa[i] = (i < Bars - 1) ? (trend[i] != trend[i + 1] && trend[i] == 1) ? upb[i] : EMPTY_VALUE : EMPTY_VALUE;
      dna[i] = (i < Bars - 1) ? (trend[i] != trend[i + 1] && trend[i] == -1) ? dnb[i] : EMPTY_VALUE : EMPTY_VALUE;

      //Forex-Station Zone template copy and paste start 5
      if (trend[i] == 0 || !ShowZones) continue;

      for (int index = i; index < Bars; index++)
         if (trend[index] != trend[index + 1]) break;
      string name = UniqueZoneID + ":" + Time[index + 1];
      ObjectDelete(name);
      ObjectDelete(UniqueZoneID + ":" + Time[1]);

      datetime lastTime = Time[i - 1];
      if (i == 0) {
         lastTime = tDummy;
         if (Time[index] == lastTime) lastTime = Time[0] + Period() * 60;
      }
      ObjectCreate(name, OBJ_RECTANGLE, 0, Time[index], 0, lastTime, WindowPriceMax() * 3.0);
      ObjectSet(name, OBJPROP_BACK, true);
      if (trend[i] == -1)
         ObjectSet(name, OBJPROP_COLOR, ZoneColorDown);
      else ObjectSet(name, OBJPROP_COLOR, ZoneColorUp);
      //Forex-Station Zone template copy and paste end 5
   }
   if (alertsOn) {
      int whichBar = 1;
      if (alertsOnCurrent) whichBar = 0;
      if (trend[whichBar] != trend[whichBar + 1]) {
         if (trend[whichBar] == 1) doAlert(" up");
         if (trend[whichBar] == -1) doAlert(" down");
      }
   }
   return (rates_total);
}


#define _maInstances 1
#define _maWorkBufferx1 1 * _maInstances
#define _maWorkBufferx2 2 * _maInstances
#define _maWorkBufferx3 3 * _maInstances

double iCustomMa(int mode, double price, double length, int r, int bars, int instanceNo = 0) {
   r = bars - r - 1;
   switch (mode) {
   case ma_sma:
      return (iSma(price, (int) length, r, bars, instanceNo));
   case ma_ema:
      return (iEma(price, length, r, bars, instanceNo));
   case ma_smma:
      return (iSmma(price, (int) length, r, bars, instanceNo));
   case ma_lwma:
      return (iLwma(price, (int) length, r, bars, instanceNo));
   case ma_slwma:
      return (iSlwma(price, (int) length, r, bars, instanceNo));
   case ma_dsema:
      return (iDsema(price, length, r, bars, instanceNo));
   case ma_tema:
      return (iTema(price, (int) length, r, bars, instanceNo));
   case ma_lsma:
      return (iLinr(price, (int) length, r, bars, instanceNo));
   default:
      return (price);
   }
}

//
//
//
//
//

double workSma[][_maWorkBufferx1];
double iSma(double price, int period, int r, int _bars, int instanceNo = 0) {
   if (ArrayRange(workSma, 0) != _bars) ArrayResize(workSma, _bars);

   workSma[r][instanceNo + 0] = price;
   double avg = price;
   int k = 1;
   for (; k < period && (r - k) >= 0; k++) avg += workSma[r - k][instanceNo + 0];
   return (avg / (double) k);
}

//
//
//
//
//

double workEma[][_maWorkBufferx1];
double iEma(double price, double period, int r, int _bars, int instanceNo = 0) {
   if (ArrayRange(workEma, 0) != _bars) ArrayResize(workEma, _bars);

   workEma[r][instanceNo] = price;
   if (r > 0 && period > 1)
      workEma[r][instanceNo] = workEma[r - 1][instanceNo] + (2.0 / (1.0 + period)) * (price - workEma[r - 1][instanceNo]);
   return (workEma[r][instanceNo]);
}

//
//
//
//
//

double workSmma[][_maWorkBufferx1];
double iSmma(double price, double period, int r, int _bars, int instanceNo = 0) {
   if (ArrayRange(workSmma, 0) != _bars) ArrayResize(workSmma, _bars);

   workSmma[r][instanceNo] = price;
   if (r > 1 && period > 1)
      workSmma[r][instanceNo] = workSmma[r - 1][instanceNo] + (price - workSmma[r - 1][instanceNo]) / period;
   return (workSmma[r][instanceNo]);
}

//
//
//
//
//

double workLwma[][_maWorkBufferx1];
double iLwma(double price, double period, int r, int _bars, int instanceNo = 0) {
   if (ArrayRange(workLwma, 0) != _bars) ArrayResize(workLwma, _bars);

   workLwma[r][instanceNo] = price;
   if (period <= 1) return (price);
   double sumw = period;
   double sum = period * price;

   for (int k = 1; k < period && (r - k) >= 0; k++) {
      double weight = period - k;
      sumw += weight;
      sum += weight * workLwma[r - k][instanceNo];
   }
   return (sum / sumw);
}

//
//
//
//
//

double workSlwma[][_maWorkBufferx2];
double iSlwma(double price, double period, int r, int _bars, int instanceNo = 0) {
   if (ArrayRange(workSlwma, 0) != _bars) ArrayResize(workSlwma, _bars);

   //
   //
   //
   //
   //

   int SqrtPeriod = (int) MathFloor(MathSqrt(period));
   instanceNo *= 2;
   workSlwma[r][instanceNo] = price;

   //
   //
   //
   //
   //

   double sumw = period;
   double sum = period * price;

   for (int k = 1; k < period && (r - k) >= 0; k++) {
      double weight = period - k;
      sumw += weight;
      sum += weight * workSlwma[r - k][instanceNo];
   }
   workSlwma[r][instanceNo + 1] = (sum / sumw);

   //
   //
   //
   //
   //

   sumw = SqrtPeriod;
   sum = SqrtPeriod * workSlwma[r][instanceNo + 1];
   for (int k2 = 1; k < SqrtPeriod && (r - k2) >= 0; k2++) {
      double weight2 = SqrtPeriod - k2;
      sumw += weight2;
      sum += weight2 * workSlwma[r - k2][instanceNo + 1];
   }
   return (sum / sumw);
}

//
//
//
//
//

double workDsema[][_maWorkBufferx2];
#define _ema1 0
#define _ema2 1

double iDsema(double price, double period, int r, int _bars, int instanceNo = 0) {
   if (ArrayRange(workDsema, 0) != _bars) ArrayResize(workDsema, _bars);
   instanceNo *= 2;

   //
   //
   //
   //
   //

   workDsema[r][_ema1 + instanceNo] = price;
   workDsema[r][_ema2 + instanceNo] = price;
   if (r > 0 && period > 1) {
      double alpha = 2.0 / (1.0 + MathSqrt(period));
      workDsema[r][_ema1 + instanceNo] = workDsema[r - 1][_ema1 + instanceNo] + alpha * (price - workDsema[r - 1][_ema1 + instanceNo]);
      workDsema[r][_ema2 + instanceNo] = workDsema[r - 1][_ema2 + instanceNo] + alpha * (workDsema[r][_ema1 + instanceNo] - workDsema[r - 1][_ema2 + instanceNo]);
   }
   return (workDsema[r][_ema2 + instanceNo]);
}

//
//
//
//
//

double workTema[][_maWorkBufferx3];
#define _tema1 0
#define _tema2 1
#define _tema3 2

double iTema(double price, double period, int r, int bars, int instanceNo = 0) {
   if (ArrayRange(workTema, 0) != bars) ArrayResize(workTema, bars);
   instanceNo *= 3;

   //
   //
   //
   //
   //

   workTema[r][_tema1 + instanceNo] = price;
   workTema[r][_tema2 + instanceNo] = price;
   workTema[r][_tema3 + instanceNo] = price;
   if (r > 0 && period > 1) {
      double alpha = 2.0 / (1.0 + period);
      workTema[r][_tema1 + instanceNo] = workTema[r - 1][_tema1 + instanceNo] + alpha * (price - workTema[r - 1][_tema1 + instanceNo]);
      workTema[r][_tema2 + instanceNo] = workTema[r - 1][_tema2 + instanceNo] + alpha * (workTema[r][_tema1 + instanceNo] - workTema[r - 1][_tema2 + instanceNo]);
      workTema[r][_tema3 + instanceNo] = workTema[r - 1][_tema3 + instanceNo] + alpha * (workTema[r][_tema2 + instanceNo] - workTema[r - 1][_tema3 + instanceNo]);
   }
   return (workTema[r][_tema3 + instanceNo] + 3.0 * (workTema[r][_tema1 + instanceNo] - workTema[r][_tema2 + instanceNo]));
}

//
//
//
//
//

double workLinr[][_maWorkBufferx1];
double iLinr(double price, int period, int r, int bars, int instanceNo = 0) {
   if (ArrayRange(workLinr, 0) != bars) ArrayResize(workLinr, bars);

   //
   //
   //
   //
   //

   period = MathMax(period, 1);
   workLinr[r][instanceNo] = price;
   if (r < period) return (price);
   double lwmw = period;
   double lwma = lwmw * price;
   double sma = price;
   for (int k = 1; k < period && (r - k) >= 0; k++) {
      double weight = period - k;
      lwmw += weight;
      lwma += weight * workLinr[r - k][instanceNo];
      sma += workLinr[r - k][instanceNo];
   }

   return (3.0 * lwma / lwmw - 2.0 * sma / period);
}

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//

#define _prHABF(_prtype) (_prtype >= pr_habclose && _prtype <= pr_habtbiased2)
#define _priceInstances 1
#define _priceInstancesSize 4
double workHa[][_priceInstances * _priceInstancesSize];
double getPrice(int tprice,
   const double & open[],
      const double & close[],
         const double & high[],
            const double & low[], int i, int bars, int instanceNo = 0) {
   if (tprice >= pr_haclose) {
      if (ArrayRange(workHa, 0) != bars) ArrayResize(workHa, bars);
      instanceNo *= _priceInstancesSize;
      int r = bars - i - 1;

      //
      //
      //
      //
      //

      double haOpen = (r > 0) ? (workHa[r - 1][instanceNo + 2] + workHa[r - 1][instanceNo + 3]) / 2.0 : (open[i] + close[i]) / 2;;
      double haClose = (open[i] + high[i] + low[i] + close[i]) / 4.0;
      if (_prHABF(tprice))
         if (high[i] != low[i])
            haClose = (open[i] + close[i]) / 2.0 + (((close[i] - open[i]) / (high[i] - low[i])) * MathAbs((close[i] - open[i]) / 2.0));
         else haClose = (open[i] + close[i]) / 2.0;
      double haHigh = fmax(high[i], fmax(haOpen, haClose));
      double haLow = fmin(low[i], fmin(haOpen, haClose));

      //
      //
      //
      //
      //

      if (haOpen < haClose) {
         workHa[r][instanceNo + 0] = haLow;
         workHa[r][instanceNo + 1] = haHigh;
      } else {
         workHa[r][instanceNo + 0] = haHigh;
         workHa[r][instanceNo + 1] = haLow;
      }
      workHa[r][instanceNo + 2] = haOpen;
      workHa[r][instanceNo + 3] = haClose;
      //
      //
      //
      //
      //

      switch (tprice) {
      case pr_haclose:
      case pr_habclose:
         return (haClose);
      case pr_haopen:
      case pr_habopen:
         return (haOpen);
      case pr_hahigh:
      case pr_habhigh:
         return (haHigh);
      case pr_halow:
      case pr_hablow:
         return (haLow);
      case pr_hamedian:
      case pr_habmedian:
         return ((haHigh + haLow) / 2.0);
      case pr_hamedianb:
      case pr_habmedianb:
         return ((haOpen + haClose) / 2.0);
      case pr_hatypical:
      case pr_habtypical:
         return ((haHigh + haLow + haClose) / 3.0);
      case pr_haweighted:
      case pr_habweighted:
         return ((haHigh + haLow + haClose + haClose) / 4.0);
      case pr_haaverage:
      case pr_habaverage:
         return ((haHigh + haLow + haClose + haOpen) / 4.0);
      case pr_hatbiased:
      case pr_habtbiased:
         if (haClose > haOpen)
            return ((haHigh + haClose) / 2.0);
         else return ((haLow + haClose) / 2.0);
      case pr_hatbiased2:
      case pr_habtbiased2:
         if (haClose > haOpen) return (haHigh);
         if (haClose < haOpen) return (haLow);
         return (haClose);
      }
   }

   //
   //
   //
   //
   //

   switch (tprice) {
   case pr_close:
      return (close[i]);
   case pr_open:
      return (open[i]);
   case pr_high:
      return (high[i]);
   case pr_low:
      return (low[i]);
   case pr_median:
      return ((high[i] + low[i]) / 2.0);
   case pr_medianb:
      return ((open[i] + close[i]) / 2.0);
   case pr_typical:
      return ((high[i] + low[i] + close[i]) / 3.0);
   case pr_weighted:
      return ((high[i] + low[i] + close[i] + close[i]) / 4.0);
   case pr_average:
      return ((high[i] + low[i] + close[i] + open[i]) / 4.0);
   case pr_tbiased:
      if (close[i] > open[i])
         return ((high[i] + close[i]) / 2.0);
      else return ((low[i] + close[i]) / 2.0);
   case pr_tbiased2:
      if (close[i] > open[i]) return (high[i]);
      if (close[i] < open[i]) return (low[i]);
      return (close[i]);
   }
   return (0);
}

//------------------------------------------------------------------
//                                                                  
//------------------------------------------------------------------
// 
//
//
//
//

#define _devInstances 1
double workDev[][_devInstances];
double iDeviation(double value, int length, bool isSample, int i, int bars, int instanceNo = 0) {
   if (ArrayRange(workDev, 0) != bars) ArrayResize(workDev, bars);
   i = bars - i - 1;
   workDev[i][instanceNo] = value;

   //
   //
   //
   //
   //

   double oldMean = value;
   double newMean = value;
   double squares = 0;
   int k;
   for (k = 1; k < length && (i - k) >= 0; k++) {
      newMean = (workDev[i - k][instanceNo] - oldMean) / (k + 1) + oldMean;
      squares += (workDev[i - k][instanceNo] - oldMean) * (workDev[i - k][instanceNo] - newMean);
      oldMean = newMean;
   }
   return (MathSqrt(squares / fmax(k - isSample, 1)));
}

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//

void doAlert(string doWhat) {
   static string previousAlert = "nothing";
   static datetime previousTime;
   string message;

   if (previousAlert != doWhat || previousTime != Time[0]) {
      previousAlert = doWhat;
      previousTime = Time[0];

      //
      //
      //
      //
      //

      message = timeFrameToString(_Period) + " " + _Symbol + " at " + TimeToStr(TimeLocal(), TIME_SECONDS) + " BB stops state changed to " + doWhat;
      if (alertsMessage) Alert(message);
      if (alertsNotify) SendNotification(message);
      if (alertsEmail) SendMail(_Symbol + " BB stops ", message);
      if (alertsSound) PlaySound(soundFile);
   }
}

//
//
//
//
//

string sTfTable[] = {
   "M1",
   "M5",
   "M15",
   "M30",
   "H1",
   "H4",
   "D1",
   "W1",
   "MN"
};
int iTfTable[] = {
   1,
   5,
   15,
   30,
   60,
   240,
   1440,
   10080,
   43200
};

string timeFrameToString(int tf) {
   for (int i = ArraySize(iTfTable) - 1; i >= 0; i--)
      if (tf == iTfTable[i]) return (sTfTable[i]);
   return ("");
}
