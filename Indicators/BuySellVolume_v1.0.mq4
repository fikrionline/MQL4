//------------------------------------------------------------------
#property copyright "copyright© mladen"
#property description "Buy sell volume"
#property description "made by mladen"
#property description "for more visit www.forex-tsd.com"
#property link "www.forex-tsd.com"
//------------------------------------------------------------------

#property indicator_separate_window
#property indicator_buffers 5
#property indicator_color1 clrLimeGreen
#property indicator_color2 clrOrange
#property indicator_color3 clrDimGray
#property indicator_color4 clrDimGray
#property indicator_color5 clrDimGray
#property indicator_style3 STYLE_DOT
#property indicator_style4 STYLE_DOT
#property indicator_style5 STYLE_DOT
#property indicator_width1 2
#property indicator_width2 2
#property strict

//
//
//
//
//

enum enPrices {
   pr_close, // Close
   pr_open, // Open
   pr_high, // High
   pr_low, // Low
   pr_median, // Median
   pr_typical, // Typical
   pr_weighted, // Weighted
   pr_average, // Average (high+low+open+close)/4
   pr_medianb, // Average median body (open+close)/2
   pr_tbiased, // Trend biased price
   pr_tbiased2, // Trend biased (extreme) price
   pr_haclose, // Heiken ashi close
   pr_haopen, // Heiken ashi open
   pr_hahigh, // Heiken ashi high
   pr_halow, // Heiken ashi low
   pr_hamedian, // Heiken ashi median
   pr_hatypical, // Heiken ashi typical
   pr_haweighted, // Heiken ashi weighted
   pr_haaverage, // Heiken ashi average
   pr_hamedianb, // Heiken ashi median body
   pr_hatbiased, // Heiken ashi trend biased price
   pr_hatbiased2 // Heiken ashi trend biased (extreme) price
};
enum enMaTypes {
   ma_sma, // Simple moving average
   ma_ema, // Exponential moving average
   ma_smma, // Smoothed MA
   ma_lwma // Linear weighted MA
};

extern int SmoothPeriod = 2; // Smoothing period 
extern enMaTypes SmoothMethod = ma_ema; // Smoothing method
extern bool alertsOn = true; // Turn alerts on?
extern bool alertsOnCurrent = true; // Alerts on current (still opened) bar?
extern bool alertsMessage = true; // Alerts should show pop-up message?
extern bool alertsSound = true; // Alerts should play alert sound?
extern bool alertsPushNotif = false; // Alerts should send push notification?
extern bool alertsEmail = false; // Alerts should send email?

//
//
//
//
//

double valuehu[], valuehd[], zero[], levelu[], leveld[], trend[];

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//

int init() {
   IndicatorBuffers(6);
   SetIndexBuffer(0, valuehu);
   SetIndexStyle(0, DRAW_HISTOGRAM);
   SetIndexBuffer(1, valuehd);
   SetIndexStyle(1, DRAW_HISTOGRAM);
   SetIndexLabel(1, NULL);
   SetIndexBuffer(2, levelu);
   SetIndexLabel(2, "Up");
   SetIndexBuffer(3, zero);
   SetIndexLabel(3, NULL);
   SetIndexBuffer(4, leveld);
   SetIndexLabel(4, "Down");
   SetIndexBuffer(5, trend);

   //
   //
   //
   //
   //

   IndicatorShortName("BuySellVolume " + timeFrameToString(Period()) + " " + averageName(SmoothMethod) + "(" + (string) SmoothPeriod + ")");
   return (0);
}
int deinit() {
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

int start() {
   int counted_bars = IndicatorCounted();
   if (counted_bars < 0) return (-1);
   if (counted_bars > 0) counted_bars--;
   int limit = MathMin(Bars - counted_bars, Bars - 1);

   //
   //
   //
   //
   //

   double alpha = 2.0 / (1.0 + SmoothPeriod);
   for (int i = limit; i >= 0; i--) {
      double ma = iCustomMa(SmoothMethod, Close[i], SmoothPeriod, i);
      double volume = (Close[i] > ma) ? (double) Volume[i] : (Close[i] < ma) ? (double) - Volume[i] : 0;
      zero[i] = 0;
      levelu[i] = (i < Bars - 1) ? (volume > 0) ? levelu[i + 1] + alpha * (volume - levelu[i + 1]) : levelu[i + 1] : 0;
      leveld[i] = (i < Bars - 1) ? (volume < 0) ? leveld[i + 1] + alpha * (volume - leveld[i + 1]) : leveld[i + 1] : 0;
      trend[i] = (volume > 0) ? 1 : (volume < 0) ? -1 : 0;
      valuehu[i] = (trend[i] == 1) ? levelu[i] : EMPTY_VALUE;
      valuehd[i] = (trend[i] == -1) ? leveld[i] : EMPTY_VALUE;
   }
   manageAlerts();
   return (0);
}

//-------------------------------------------------------------------
//                                                                  
//-------------------------------------------------------------------
//
//
//
//
//

void manageAlerts() {
   if (alertsOn) {
      int whichBar = 1;
      if (alertsOnCurrent) whichBar = 0;
      if (trend[whichBar] != trend[whichBar + 1]) {
         if (trend[whichBar] == 1) doAlert(whichBar, "UP", "volumechangedup.wav");
         if (trend[whichBar] == -1) doAlert(whichBar, "DOWN", "volumechangeddown.wav");
      }
   }
}

//
//
//
//
//

void doAlert(int forBar, string doWhat, string fileSound = "volumechanged.wav") {
   static string previousAlert = "nothing";
   static datetime previousTime;
   string message;

   if (previousAlert != doWhat || previousTime != Time[forBar]) {
      previousAlert = doWhat;
      previousTime = Time[forBar];

      //
      //
      //
      //
      //

      message = _Symbol + " " + timeFrameToString(Period()) + " " + TimeToStr(TimeLocal(), TIME_SECONDS) + " --> " + doWhat;
      if (alertsMessage) Alert(message);
      if (alertsEmail) SendMail(_Symbol + " CCI", message);
      if (alertsPushNotif) SendNotification(message);
      if (alertsSound) PlaySound(fileSound);
   }
}

//------------------------------------------------------------------
//                                                                  
//------------------------------------------------------------------
//
//
//
//
//

#define _maInstances 1
#define _maWorkBufferx1 1 * _maInstances
#define _maWorkBufferx2 2 * _maInstances

string averageName(int mode) {
   switch (mode) {
   case ma_sma:
      return ("SMA");
   case ma_ema:
      return ("EMA");
   case ma_smma:
      return ("SMMA");
   case ma_lwma:
      return ("LWMA");
   }
   return ("");
}
double iCustomMa(int mode, double price, double length, int r, int instanceNo = 0) {
   r = Bars - r - 1;
   switch (mode) {
   case ma_sma:
      return (iSma(price, (int) length, r, instanceNo));
   case ma_ema:
      return (iEma(price, length, r, instanceNo));
   case ma_smma:
      return (iSmma(price, length, r, instanceNo));
   case ma_lwma:
      return (iLwma(price, (int) length, r, instanceNo));
   default:
      return (price);
   }
}

//
//
//
//
//

double workSma[][_maWorkBufferx2];
double iSma(double price, int period, int r, int instanceNo = 0) {
   if (period <= 1) return (price);
   if (ArrayRange(workSma, 0) != Bars) ArrayResize(workSma, Bars);
   instanceNo *= 2;
   int k;

   //
   //
   //
   //
   //

   workSma[r][instanceNo + 0] = price;
   workSma[r][instanceNo + 1] = price;
   for (k = 1; k < period && (r - k) >= 0; k++) workSma[r][instanceNo + 1] += workSma[r - k][instanceNo + 0];
   workSma[r][instanceNo + 1] /= 1.0 * k;
   return (workSma[r][instanceNo + 1]);
}

//
//
//
//
//

double workEma[][_maWorkBufferx1];
double iEma(double price, double period, int r, int instanceNo = 0) {
   if (period <= 1) return (price);
   if (ArrayRange(workEma, 0) != Bars) ArrayResize(workEma, Bars);

   //
   //
   //
   //
   //

   workEma[r][instanceNo] = price;
   double alpha = 2.0 / (1.0 + period);
   if (r > 0)
      workEma[r][instanceNo] = workEma[r - 1][instanceNo] + alpha * (price - workEma[r - 1][instanceNo]);
   return (workEma[r][instanceNo]);
}

//
//
//
//
//

double workSmma[][_maWorkBufferx1];
double iSmma(double price, double period, int r, int instanceNo = 0) {
   if (period <= 1) return (price);
   if (ArrayRange(workSmma, 0) != Bars) ArrayResize(workSmma, Bars);

   //
   //
   //
   //
   //

   if (r < period)
      workSmma[r][instanceNo] = price;
   else workSmma[r][instanceNo] = workSmma[r - 1][instanceNo] + (price - workSmma[r - 1][instanceNo]) / period;
   return (workSmma[r][instanceNo]);
}

//
//
//
//
//

double workLwma[][_maWorkBufferx1];
double iLwma(double price, double period, int r, int instanceNo = 0) {
   if (period <= 1) return (price);
   if (ArrayRange(workLwma, 0) != Bars) ArrayResize(workLwma, Bars);

   //
   //
   //
   //
   //

   workLwma[r][instanceNo] = price;
   double sumw = period;
   double sum = period * price;

   for (int k = 1; k < period && (r - k) >= 0; k++) {
      double weight = period - k;
      sumw += weight;
      sum += weight * workLwma[r - k][instanceNo];
   }
   return (sum / sumw);
}

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//
//

#define priceInstances 1
double workHa[][priceInstances * 4];
double getPrice(int tprice,
   const double & open[],
      const double & close[],
         const double & high[],
            const double & low[], int i, int instanceNo = 0) {
   if (tprice >= pr_haclose) {
      if (ArrayRange(workHa, 0) != Bars) ArrayResize(workHa, Bars);
      instanceNo *= 4;
      int r = Bars - i - 1;

      //
      //
      //
      //
      //

      double haOpen;
      if (r > 0)
         haOpen = (workHa[r - 1][instanceNo + 2] + workHa[r - 1][instanceNo + 3]) / 2.0;
      else haOpen = (open[i] + close[i]) / 2;
      double haClose = (open[i] + high[i] + low[i] + close[i]) / 4.0;
      double haHigh = MathMax(high[i], MathMax(haOpen, haClose));
      double haLow = MathMin(low[i], MathMin(haOpen, haClose));

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
         return (haClose);
      case pr_haopen:
         return (haOpen);
      case pr_hahigh:
         return (haHigh);
      case pr_halow:
         return (haLow);
      case pr_hamedian:
         return ((haHigh + haLow) / 2.0);
      case pr_hamedianb:
         return ((haOpen + haClose) / 2.0);
      case pr_hatypical:
         return ((haHigh + haLow + haClose) / 3.0);
      case pr_haweighted:
         return ((haHigh + haLow + haClose + haClose) / 4.0);
      case pr_haaverage:
         return ((haHigh + haLow + haClose + haOpen) / 4.0);
      case pr_hatbiased:
         if (haClose > haOpen)
            return ((haHigh + haClose) / 2.0);
         else return ((haLow + haClose) / 2.0);
      case pr_hatbiased2:
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
