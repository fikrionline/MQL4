//+------------------------------------------------------------------+
//|                                                   AutoFiboD1.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, John Wustrack"
#property link "john_wustrack@hotmail.com"

#property indicator_chart_window

extern string FiboID = "FiboBuyBSS_T";

extern ENUM_TIMEFRAMES ChooseTimeFrame = PERIOD_M5;

enum TheDay {
   Today,
   Yesterday,
   TwoDaysAgo,
   ThreeDayAgo
};

extern TheDay ChooseDay = Today;

string ChooseDayCandleTime;
extern string CandleTime = "00:00";
extern bool ShowPrice = true;
extern color FiboColor = Aqua;

int gi_FibLevels;
double gd_FLvl[17];
string gd_FLvl_Str[17];
double gd_High, gd_Low;

datetime gdt_LastBar;
datetime gdt_Times[];

int gi_BarOffset;
int xi_Period = ChooseTimeFrame;
bool xb_ShowPrice = ShowPrice;
color xc_Color_Fib = FiboColor;

string gs_Fibo;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init() {
   //----

   gd_FLvl[0] = 0;
   gd_FLvl[1] = 0.17;
   gd_FLvl[2] = 0.34;
   gd_FLvl[3] = 0.50;
   gd_FLvl[4] = 0.66;
   gd_FLvl[5] = 0.83;
   gd_FLvl[6] = 1;
   gd_FLvl[7] = 1.34;
   gd_FLvl[8] = 1.50;
   gd_FLvl[9] = 1.66;
   gd_FLvl[10] = 2.17;
   gd_FLvl[11] = 3.34;
   gd_FLvl[12] = 4.51;
   gd_FLvl[13] = 5.68;
   gd_FLvl[14] = -0.085;
   gd_FLvl[15] = -0.17;
   gd_FLvl[16] = -0.34;
   
   gd_FLvl_Str[0] = "";
   gd_FLvl_Str[1] = "";
   gd_FLvl_Str[2] = "";
   gd_FLvl_Str[3] = "PV / ";
   gd_FLvl_Str[4] = "";
   gd_FLvl_Str[5] = "";
   gd_FLvl_Str[6] = "Buy Entry / ";
   gd_FLvl_Str[7] = "";
   gd_FLvl_Str[8] = "";
   gd_FLvl_Str[9] = "";
   gd_FLvl_Str[10] = "TP1 / ";
   gd_FLvl_Str[11] = "TP2 / ";
   gd_FLvl_Str[12] = "TP3 / ";
   gd_FLvl_Str[13] = "TP4 / ";
   gd_FLvl_Str[14] = "SL / ";
   gd_FLvl_Str[15] = "SL / ";
   gd_FLvl_Str[16] = "SL / ";

   gi_FibLevels = 17;

   gs_Fibo = "Fibo-" + FiboID + "-" + xi_Period;

   //----
   return (0);
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit() {
   //----
   ObjectDelete(gs_Fibo);
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
   
   gi_BarOffset = iBarShift(Symbol(), ChooseTimeFrame, StringToTime(ChooseDayCandleTime + CandleTime)); //Alert(ChooseDayCandleTime + CandleTime);

   // Check if the bar has moved
   if (iTime(NULL, xi_Period, gi_BarOffset) != gdt_LastBar) {
      gdt_LastBar = iTime(NULL, xi_Period, gi_BarOffset);
      lb_Changed = true;
   }

   // If the move Hi/Lo is set then we need to check if there is a new hi/lo

   if (lb_Changed)
      Calculate_Fibo();

   //----
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
   
   gi_BarOffset = iBarShift(Symbol(), ChooseTimeFrame, StringToTime(ChooseDayCandleTime + CandleTime)); //Alert(ChooseDayCandleTime + CandleTime);

   gd_High = iHigh(NULL, xi_Period, gi_BarOffset);
   gd_Low = iLow(NULL, xi_Period, gi_BarOffset);

   ObjectCreate(gs_Fibo, OBJ_FIBO, 0, iTime(NULL, xi_Period, gi_BarOffset), gd_High, iTime(NULL, xi_Period, gi_BarOffset), gd_Low);
   ObjectSet(gs_Fibo, OBJPROP_BACK, true);
   WindowRedraw();
   ObjectSet(gs_Fibo, OBJPROP_FIBOLEVELS, gi_FibLevels);
   ObjectSet(gs_Fibo, OBJPROP_LEVELCOLOR, xc_Color_Fib);
   for (li_Id1 = 0; li_Id1 < gi_FibLevels; li_Id1++) {
      ObjectSet(gs_Fibo, OBJPROP_FIRSTLEVEL + li_Id1, gd_FLvl[li_Id1]);
      if (xb_ShowPrice)
         ObjectSetFiboDescription(gs_Fibo, li_Id1, gd_FLvl_Str[li_Id1] + DoubleToStr(gd_FLvl[li_Id1], 3) + " / %$");
      else
         ObjectSetFiboDescription(gs_Fibo, li_Id1, DoubleToStr(gd_FLvl[li_Id1], 3));
   }

   //----
   return (0);
}
//+------------------------------------------------------------------+
