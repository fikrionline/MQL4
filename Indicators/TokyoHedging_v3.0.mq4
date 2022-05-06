//+------------------------------------------------------------------+
//|                                            TokyoHedging_v3.0.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, John Wustrack"
#property link "john_wustrack@hotmail.com"
#property indicator_chart_window

extern string FiboID = "TokyoHedging";

extern ENUM_TIMEFRAMES ChooseTimeFrame = PERIOD_H1;

enum TheDay {
   Today,
   Yesterday,
   TwoDaysAgo,
   ThreeDayAgo
};
extern TheDay ChooseDay = Today;

string ChooseDayCandleTime;
extern string CandleStartTime = "00:00";
extern string CandleEndTime = "01:00";
extern double MinSL = 134;
extern color FiboColor = clrYellow;
extern double StartBalance = 10000;
extern double MaxRiskPerTradePercent = 0.5;

int gi_FibLevels, gi_BarOffset, gi_BarOffsetStart;
double gd_FLvl[15], gd_High, gd_Low, Lots;
string gd_FLvl_Str[15], gs_Fibo, TheComment;
datetime gdt_LastBar, gdt_Times[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init() {
   //----

   //Pivot Level
   gd_FLvl[0] = 1;
   
   //Buy Level
   gd_FLvl[1] = 0.66;
   gd_FLvl[2] = -0.34;
   gd_FLvl[3] = 1.66;
   gd_FLvl[4] = 2.66;
   gd_FLvl[5] = 3.66;
   gd_FLvl[6] = 4.66;
   gd_FLvl[7] = 5.66;
   
   //Sell Level
   gd_FLvl[8] = 1.34;
   gd_FLvl[9] = 2.34;
   gd_FLvl[10] = 0.34;
   gd_FLvl[11] = -0.66;
   gd_FLvl[12] = -1.66;
   gd_FLvl[13] = -2.66;
   gd_FLvl[14] = -3.66;
   
   //Pivot String
   gd_FLvl_Str[0] = "Pivot / ";
   
   //Buy String
   gd_FLvl_Str[1] = "Buy Limit / ";
   gd_FLvl_Str[2] = "Buy SL / ";
   gd_FLvl_Str[3] = "Buy TP1 / ";
   gd_FLvl_Str[4] = "Buy TP2 / ";
   gd_FLvl_Str[5] = "Buy TP3 / ";
   gd_FLvl_Str[6] = "Buy TP4 / ";
   gd_FLvl_Str[7] = "Buy TP5 / ";
   
   //Sell String
   gd_FLvl_Str[8] = "Sell Limit / ";
   gd_FLvl_Str[9] = "Sell SL / ";
   gd_FLvl_Str[10] = "Sell TP1 / ";
   gd_FLvl_Str[11] = "Sell TP2 / ";
   gd_FLvl_Str[12] = "Sell TP3 / ";
   gd_FLvl_Str[13] = "Sell TP4 / ";
   gd_FLvl_Str[14] = "Sell TP5 / ";

   gi_FibLevels = 15;

   gs_Fibo = "Fibo-" + FiboID + "-" + ChooseTimeFrame;

   //----
   return (0);
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit() {
   //----
   ObjectDelete(gs_Fibo);
   Comment("");
   //----
   return (0);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start() {
   //----
   bool lb_Changed = false;
   
   if(ChooseDay == Today) {
      ChooseDayCandleTime = TimeToString(TimeCurrent(), TIME_DATE) + " ";
   } else if(ChooseDay == Yesterday) {
      ChooseDayCandleTime = TimeToString(TimeCurrent() - 60 * 60 * 24, TIME_DATE) + " ";
   } else if(ChooseDay == TwoDaysAgo) {
      ChooseDayCandleTime = TimeToString(TimeCurrent() - (60 * 60 * 24) * 2, TIME_DATE) + " ";
   } else if(ChooseDay == ThreeDayAgo) {
      ChooseDayCandleTime = TimeToString(TimeCurrent() - (60 * 60 * 24) * 3, TIME_DATE) + " ";
   }
   
   gi_BarOffset = iBarShift(Symbol(), ChooseTimeFrame, StringToTime(ChooseDayCandleTime + CandleEndTime)); //Alert(gi_BarOffset);
   gi_BarOffsetStart = iBarShift(Symbol(), ChooseTimeFrame, StringToTime(ChooseDayCandleTime + CandleStartTime)); //Alert(gi_BarOffsetStart);

   // Check if the bar has moved
   if (iTime(NULL, ChooseTimeFrame, gi_BarOffset) != gdt_LastBar) {
      gdt_LastBar = iTime(NULL, ChooseTimeFrame, gi_BarOffset);
      lb_Changed = true;
   }

   // If the move Hi/Lo is set then we need to check if there is a new hi/lo
   if (lb_Changed) {
      Calculate_Fibo();
   }
   //----
   
   TheComment = "\n" + "TokyoHedging" +
      "\n" + "StartBalance = " + DoubleToString(StartBalance, 2) +
      "\n" + "MaxRiskPerTradePercent = " + DoubleToString(MaxRiskPerTradePercent, 2) + "%" +
      "\n" + "LotSize = " + DoubleToString(Lots, 2) +
      "";   
   
   Comment(TheComment);
   
   return (0);
}

//+------------------------------------------------------------------+
//| calculate the fibonacci                                          |
//+------------------------------------------------------------------+
int Calculate_Fibo() {
   //----
   int li_Id1;

   ObjectDelete(gs_Fibo);
   
   if(ChooseDay == Today) {
      ChooseDayCandleTime = TimeToString(TimeCurrent(), TIME_DATE) + " ";
   } else if(ChooseDay == Yesterday) {
      ChooseDayCandleTime = TimeToString(TimeCurrent() - 60 * 60 * 24, TIME_DATE) + " ";
   } else if(ChooseDay == TwoDaysAgo) {
      ChooseDayCandleTime = TimeToString(TimeCurrent() - (60 * 60 * 24) * 2, TIME_DATE) + " ";
   } else if(ChooseDay == ThreeDayAgo) {
      ChooseDayCandleTime = TimeToString(TimeCurrent() - (60 * 60 * 24) * 3, TIME_DATE) + " ";
   }

   gd_High = iClose(NULL, ChooseTimeFrame, gi_BarOffset);
   gd_Low = iLow(NULL, ChooseTimeFrame, iLowest(NULL, ChooseTimeFrame, MODE_LOW, ((gi_BarOffsetStart - gi_BarOffset) + 1), gi_BarOffset)); //Alert(gd_Low);
   
   if(MinSL > ((gd_High - gd_Low) / Point())) {
      gd_Low = gd_High - (MinSL * Point());
   }
   
   Lots = CalculateLotSize((gd_High - gd_Low) / Point, MaxRiskPerTradePercent, StartBalance);

   ObjectCreate(gs_Fibo, OBJ_FIBO, 0, iTime(NULL, ChooseTimeFrame, gi_BarOffset), gd_High, iTime(NULL, ChooseTimeFrame, gi_BarOffset), gd_Low);
   ObjectSet(gs_Fibo, OBJPROP_BACK, true);
   WindowRedraw();
   ObjectSet(gs_Fibo, OBJPROP_FIBOLEVELS, gi_FibLevels);
   ObjectSet(gs_Fibo, OBJPROP_LEVELCOLOR, FiboColor);
   for (li_Id1 = 0; li_Id1 < gi_FibLevels; li_Id1++) {
      ObjectSet(gs_Fibo, OBJPROP_FIRSTLEVEL + li_Id1, gd_FLvl[li_Id1]);
      ObjectSetFiboDescription(gs_Fibo, li_Id1, gd_FLvl_Str[li_Id1] + "%$");
   }

   //----
   return (0);
}
//+------------------------------------------------------------------+

double CalculateLotSize(double SL, double MaxRiskPerTrade, double BalanceOrEquity){ // Calculate the position size.
   double LotSize = 0;
   // We get the value of a tick.
   double nTickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
   // If the digits are 3 or 5, we normalize multiplying by 10.
   if ((Digits == 3) || (Digits == 5)){
      //nTickValue = nTickValue * 10;
   }
   // We apply the formula to calculate the position size and assign the value to the variable.
   LotSize = ((BalanceOrEquity * MaxRiskPerTrade) / 100) / (SL * nTickValue);
   return LotSize;
}
