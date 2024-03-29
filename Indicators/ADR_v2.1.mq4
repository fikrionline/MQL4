//+------------------------------------------------------------------+
//|                                                ADR_SL-NoLine.mq4 |
//|                                       Copyright © Terry Nicholls |
//| Some code modified from TSR_Ranges.mq4 by Ogeima                 |
//| made for FXiGoR for the TSR Trend Slope Retracement method       |
//| modified to the DYNAMIC Daily Range Breakout System              |
//+------------------------------------------------------------------+

/* This will display at the top of your chart the Average Daily Range (pip movement)
   for Yesterday, Today, and 5, 10, and 20 day periods.
   Below that will display the number of pips for a Stop Loss based on 1/2 and 3/4
   of the ADR. */

#property copyright "Copyright © Terry Nicholls"

#property indicator_chart_window

extern double Risk_to_Reward_ratio = 3.0;

int nDigits;
double today_high = 0;
double today_low = 0;
double D = 0;
double nD = 0;
double nhR1 = 0;
double nqR1 = 0;
double nhR5 = 0;
double nqR5 = 0;
double nhR10 = 0;
double nqR10 = 0;
double nhR20 = 0;
double nqR20 = 0;
double nhR60 = 0;
double nqR60 = 0;
double rates_d1[2][6];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

int init() {
   IndicatorShortName("Avg_Dly_Rng");
   return (0);
}

//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+

int deinit() {
   ObjectDelete("Avg_Dly_Rng1");
   ObjectDelete("Avg_Dly_Rng2");
   ObjectDelete("Avg_Dly_Rng3");
   ObjectDelete("Avg_Dly_Rng4");
   ObjectDelete("Avg_Dly_Rng5");
   ObjectDelete("Avg_Dly_Rng6");
   ObjectDelete("Avg_Dly_Rng7");
   ObjectDelete("Avg_Dly_Rng8");
   ObjectDelete("Avg_Dly_Rng9");
   ObjectDelete("Avg_Dly_Rng10");
   ObjectDelete("Avg_Dly_Rng11");
   ObjectDelete("Avg_Dly_Rng12");
   ObjectDelete("Avg_Dly_Rng13");
   ObjectDelete("Avg_Dly_Rng14");
   ObjectDelete("Avg_Dly_Rng15");
   ObjectDelete("Avg_Dly_Rng16");
   ObjectDelete("Avg_Dly_Rng17");
   ObjectDelete("Avg_Dly_Rng18");
   ObjectDelete("Avg_Dly_Rng19");
   ObjectDelete("Avg_Dly_Rng20");
   ObjectDelete("Avg_Dly_Rng21");
   ObjectDelete("Avg_Dly_Rng22");
   ObjectDelete("Avg_Dly_Rng23");
   ObjectDelete("Avg_Dly_Rng24");
   ObjectDelete("Avg_Dly_Rng25");
   ObjectDelete("Avg_Dly_Rng26");
   ObjectDelete("Avg_Dly_Rng27");
   return (0);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+

int start() {
   ArrayCopyRates(rates_d1, Symbol(), PERIOD_D1); //---- Get new daily prices

   int R1 = 0, R5 = 0, R10 = 0, R20 = 0, R60 = 0, RAvg = 0;
   int RoomUp = 0, RoomDown = 0, StopLoss_Long = 0, StopLoss_Short = 0;
   double SL_Long = 0, SL_Short = 0;
   double low0 = 0, high0 = 0;
   string Text = "";
   int i = 0;
   double mul = 1;
   if (Digits == 3 || Digits == 5) mul = 10;

   today_high = rates_d1[0][3];
   today_low = rates_d1[0][2];

   D = (today_high - today_low) / (Point * mul);

   R1 = (iHigh(NULL, PERIOD_D1, 1) - iLow(NULL, PERIOD_D1, 1)) / (Point * mul);
   for (i = 1; i <= 5; i++)
      R5 = R5 + (iHigh(NULL, PERIOD_D1, i) - iLow(NULL, PERIOD_D1, i)) / (Point * mul);
   for (i = 1; i <= 10; i++)
      R10 = R10 + (iHigh(NULL, PERIOD_D1, i) - iLow(NULL, PERIOD_D1, i)) / (Point * mul);
   for (i = 1; i <= 20; i++)
      R20 = R20 + (iHigh(NULL, PERIOD_D1, i) - iLow(NULL, PERIOD_D1, i)) / (Point * mul);
   for (i = 1; i <= 60; i++)
      R60 = R60 + (iHigh(NULL, PERIOD_D1, i) - iLow(NULL, PERIOD_D1, i)) / (Point * mul);

   R5 = R5 / 5;
   R10 = R10 / 10;
   R20 = R20 / 20;
   R60 = R60 / 60;
   RAvg = (R1 + R5 + R10 + R20 + R60) / 5;

   low0 = iLow(NULL, PERIOD_D1, 0);
   high0 = iHigh(NULL, PERIOD_D1, 0);
   RoomUp = RAvg - (Bid - low0) / (Point * mul);
   RoomDown = RAvg - (high0 - Bid) / (Point * mul);
   StopLoss_Long = RoomUp / Risk_to_Reward_ratio;
   SL_Long = Bid - nhR1 * Point * mul;
   StopLoss_Short = RoomDown / Risk_to_Reward_ratio;
   SL_Short = Bid + nhR1 * Point * mul;

   if (D > 1) {
      nD = D;
   } else {
      nD = D;
   }

   if (R1 > 1) {
      nhR1 = R1 / 2;
   } else {
      nhR1 = 0;
   }

   if (R1 > 1) {
      nqR1 = R1 * 0.75;
   } else {
      nqR1 = 0;
   }

   if (R5 > 1) {
      nhR5 = R5 / 2;
   } else {
      nhR5 = 0;
   }

   if (R5 > 1) {
      nqR5 = R5 * 0.75;
   } else {
      nqR5 = 0;
   }

   if (R10 > 1) {
      nhR10 = R10 / 2;
   } else {
      nhR10 = 0;
   }

   if (R10 > 1) {
      nqR10 = R10 * 0.75;
   } else {
      nqR20 = 0;
   }

   if (R20 > 1) {
      nhR20 = R20 / 2;
   } else {
      nhR20 = 0;
   }

   if (R20 > 1) {
      nqR20 = R20 * 0.75;
   } else {
      nqR20 = 0;
   }

   // Displays Average Daily Range for Today, Yesterday, 5 Days, 10 Days, and 20 Days

   ObjectCreate("Avg_Dly_Rng1", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Avg_Dly_Rng1", "Today: ", 10, "Courier New", RoyalBlue);
   ObjectSet("Avg_Dly_Rng1", OBJPROP_CORNER, 0);
   ObjectSet("Avg_Dly_Rng1", OBJPROP_XDISTANCE, 225);
   ObjectSet("Avg_Dly_Rng1", OBJPROP_YDISTANCE, 2);

   ObjectCreate("Avg_Dly_Rng2", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Avg_Dly_Rng2", DoubleToStr(nD, 0), 10, "Courier New", Tomato);
   ObjectSet("Avg_Dly_Rng2", OBJPROP_CORNER, 0);
   ObjectSet("Avg_Dly_Rng2", OBJPROP_XDISTANCE, 285);
   ObjectSet("Avg_Dly_Rng2", OBJPROP_YDISTANCE, 2);

   ObjectCreate("Avg_Dly_Rng3", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Avg_Dly_Rng3", "1 Day: ", 10, "Courier New", RoyalBlue);
   ObjectSet("Avg_Dly_Rng3", OBJPROP_CORNER, 0);
   ObjectSet("Avg_Dly_Rng3", OBJPROP_XDISTANCE, 325);
   ObjectSet("Avg_Dly_Rng3", OBJPROP_YDISTANCE, 2);

   ObjectCreate("Avg_Dly_Rng4", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Avg_Dly_Rng4", DoubleToStr(R1, 0), 10, "Courier New", Tomato);
   ObjectSet("Avg_Dly_Rng4", OBJPROP_CORNER, 0);
   ObjectSet("Avg_Dly_Rng4", OBJPROP_XDISTANCE, 380);
   ObjectSet("Avg_Dly_Rng4", OBJPROP_YDISTANCE, 2);

   ObjectCreate("Avg_Dly_Rng5", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Avg_Dly_Rng5", "5 Day: ", 10, "Courier New", RoyalBlue);
   ObjectSet("Avg_Dly_Rng5", OBJPROP_CORNER, 0);
   ObjectSet("Avg_Dly_Rng5", OBJPROP_XDISTANCE, 420);
   ObjectSet("Avg_Dly_Rng5", OBJPROP_YDISTANCE, 2);

   ObjectCreate("Avg_Dly_Rng6", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Avg_Dly_Rng6", DoubleToStr(R5, 0), 10, "Courier New", Tomato);
   ObjectSet("Avg_Dly_Rng6", OBJPROP_CORNER, 0);
   ObjectSet("Avg_Dly_Rng6", OBJPROP_XDISTANCE, 475);
   ObjectSet("Avg_Dly_Rng6", OBJPROP_YDISTANCE, 2);

   ObjectCreate("Avg_Dly_Rng7", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Avg_Dly_Rng7", "10 Day: ", 10, "Courier New", RoyalBlue);
   ObjectSet("Avg_Dly_Rng7", OBJPROP_CORNER, 0);
   ObjectSet("Avg_Dly_Rng7", OBJPROP_XDISTANCE, 515);
   ObjectSet("Avg_Dly_Rng7", OBJPROP_YDISTANCE, 2);

   ObjectCreate("Avg_Dly_Rng8", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Avg_Dly_Rng8", DoubleToStr(R10, 0), 10, "Courier New", Tomato);
   ObjectSet("Avg_Dly_Rng8", OBJPROP_CORNER, 0);
   ObjectSet("Avg_Dly_Rng8", OBJPROP_XDISTANCE, 579);
   ObjectSet("Avg_Dly_Rng8", OBJPROP_YDISTANCE, 2);

   ObjectCreate("Avg_Dly_Rng9", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Avg_Dly_Rng9", "20 Day: ", 10, "Courier New", RoyalBlue);
   ObjectSet("Avg_Dly_Rng9", OBJPROP_CORNER, 0);
   ObjectSet("Avg_Dly_Rng9", OBJPROP_XDISTANCE, 619);
   ObjectSet("Avg_Dly_Rng9", OBJPROP_YDISTANCE, 2);

   ObjectCreate("Avg_Dly_Rng10", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Avg_Dly_Rng10", DoubleToStr(R20, 0), 10, "Courier New", Tomato);
   ObjectSet("Avg_Dly_Rng10", OBJPROP_CORNER, 0);
   ObjectSet("Avg_Dly_Rng10", OBJPROP_XDISTANCE, 683);
   ObjectSet("Avg_Dly_Rng10", OBJPROP_YDISTANCE, 2);

   ObjectCreate("Avg_Dly_Rng11", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Avg_Dly_Rng11", "60 Day: ", 10, "Courier New", RoyalBlue);
   ObjectSet("Avg_Dly_Rng11", OBJPROP_CORNER, 0);
   ObjectSet("Avg_Dly_Rng11", OBJPROP_XDISTANCE, 723);
   ObjectSet("Avg_Dly_Rng11", OBJPROP_YDISTANCE, 2);

   ObjectCreate("Avg_Dly_Rng12", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Avg_Dly_Rng12", DoubleToStr(R60, 0), 10, "Courier New", Tomato);
   ObjectSet("Avg_Dly_Rng12", OBJPROP_CORNER, 0);
   ObjectSet("Avg_Dly_Rng12", OBJPROP_XDISTANCE, 785);
   ObjectSet("Avg_Dly_Rng12", OBJPROP_YDISTANCE, 2);

   return (0);
}

//+------------------------------------------------------------------+
