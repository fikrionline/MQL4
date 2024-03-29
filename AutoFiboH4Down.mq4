﻿//+------------------------------------------------------------------+
//|                                                  FibSemiAuto.mq4 |
//|                                  Copyright © 2010, John Wustrack |
//|                                        john_wustrack@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, John Wustrack"
#property link "john_wustrack@hotmail.com"

#property indicator_chart_window

extern string FiboID = "H4Down";

enum EnumTimeFrame {
   M1,
   M5,
   M15,
   M30,
   H1,
   H4,
   D1,
   W1,
   MN
};
extern EnumTimeFrame TimeFrame = H4;

extern int CandleBase = 1;
extern bool ShowPrice = true;
extern color FiboColor = Green;

enum FiboUpDown {
   Up,
   Down
};
extern FiboUpDown ChooseFiboUpDown = Down;

int gi_FibLevels;
double gd_FLvl[19];
double gd_High, gd_Low;

datetime gdt_LastBar;
datetime gdt_Times[];

int gi_BarOffset = CandleBase;
int xi_Period;
bool xb_ShowPrice = ShowPrice;
color xc_Color_Fib = FiboColor;

string gs_Fibo;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init() {
   //---- 
   
   switch(TimeFrame)
   {
   case M1:
      xi_Period = 1;
   case M5:
      xi_Period = 5;
      break;
   case M15:
      xi_Period = 15;
      break;
   case M30:
      xi_Period = 30;
      break;
   case H1:
      xi_Period = 60;
      break;
   case H4:
      xi_Period = 240;
      break;
   case D1:
      xi_Period = 1440;
      break;
   case W1:
      xi_Period = 10080;
      break;
   case MN:
      xi_Period = 43200;
      break;
   }

   gd_FLvl[0] = 0;
   gd_FLvl[1] = 0.17;
   gd_FLvl[2] = 0.34;
   gd_FLvl[3] = 0.50;
   gd_FLvl[4] = 0.66;
   gd_FLvl[5] = 0.83;
   gd_FLvl[6] = 1;
   
   if(ChooseFiboUpDown == Up) {
      gd_FLvl[7] = 1.17;
      gd_FLvl[8] = 1.34;
      gd_FLvl[9] = 1.50;
      gd_FLvl[10] = 1.66;
      gd_FLvl[11] = 1.83;
      gd_FLvl[12] = 2;
      gd_FLvl[13] = 2.17;
      gd_FLvl[14] = 2.34;
      gd_FLvl[15] = 2.50;
      gd_FLvl[16] = 2.66;
      gd_FLvl[17] = 2.83;
      gd_FLvl[18] = 3;
   } else if(ChooseFiboUpDown == Down) {
      gd_FLvl[7] = -0.17;
      gd_FLvl[8] = -0.34;
      gd_FLvl[9] = -0.50;
      gd_FLvl[10] = -0.66;
      gd_FLvl[11] = -0.83;
      gd_FLvl[12] = -1;
      gd_FLvl[13] = -1.17;
      gd_FLvl[14] = -1.34;
      gd_FLvl[15] = -1.50;
      gd_FLvl[16] = -1.66;
      gd_FLvl[17] = -1.83;
      gd_FLvl[18] = -2;
   }

   gi_FibLevels = 19;

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
         ObjectSetFiboDescription(gs_Fibo, li_Id1, DoubleToStr(gd_FLvl[li_Id1], 3) + " / %$");
      else
         ObjectSetFiboDescription(gs_Fibo, li_Id1, DoubleToStr(gd_FLvl[li_Id1], 3));
   }

   //----
   return (0);
}
//+------------------------------------------------------------------+