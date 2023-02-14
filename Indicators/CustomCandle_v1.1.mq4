﻿#property link      "mankurt@freemail.ru"
#property copyright "© 2006, mankurt"
#property indicator_chart_window
//+------------------------------------------------------------------------------------------------+
extern int   HistoryCandle = 10;
extern int   SetTF         = 1440;
extern int   CandleShift   = 40;
extern color UpCandle      = clrDarkGreen;
extern color DnCandle      = clrDarkOrchid;
extern color DojiColor     = clrDarkOrange;
extern int   Width         = 1;
extern bool  BGCandle      = true;
extern bool  ShowOHLC      = false;
//+------------------------------------------------------------------------------------------------+
int Nbar, OpenBar, timer, i, timerTF, name, MidBar;
double HighPrevBar, LowPrevBar, ClosePrevBar;
double OpenNewBar, HighNewBar, LowNewBar, CloseNewBar;
double HighCurBar, LowCurBar, CloseCurBar;
double priceNewSH, priceNewSL, pricePrevSH, pricePrevSL, priceCurSH, priceCurSL;
string nameNewCandle, namePrevCandle;
string nameNewShadowH, nameNewShadowL, namePrevShadowH, namePrevShadowL;
string NameBar, NameHigh, NameLow;
datetime TimeOpenNewBar, TimeCloseNewBar, TimeClosePrevBar;
datetime timeNewShadow, timePrevShadow;
bool NewBar;
//+------------------------------------------------------------------------------------------------+
int init() {
   IndicatorShortName("M" + SetTF + " íà M" + Period());
   Nbar = SetTF / Period();
   timer = Period() * 60;
   timerTF = SetTF * 60;
   name = 0;
   TimeOpenNewBar = Time[Bars - 1];
   OpenNewBar = Open[Bars - 1];
   NewBar = false;
   NameBar = "Bar M" + SetTF + "-";
   NameHigh = "High M" + SetTF + "-";
   NameLow = "Low M" + SetTF + "-";
   return (0);
}
//+------------------------------------------------------------------------------------------------+
int deinit() {
   for (int DelOBJ = 1; DelOBJ <= name; DelOBJ++) {
      ObjectDelete(NameBar + DelOBJ);
      ObjectDelete(NameHigh + DelOBJ);
      ObjectDelete(NameLow + DelOBJ);
   }
   Comment("");
   return (0);
}
//+------------------------------------------------------------------------------------------------+
int start() {
   if (SetTF > 1440) {
      Comment("\n", " TimeFrame more than D1 is not supporting!!!");
      return (0);
   }
   if (Period() > 240) {
      Comment("\n", " Period more than H4 is not supporting!!!");
      return (0);
   }
   if (SetTF <= Period() || MathMod(SetTF, Period()) != 0) {
      Comment("\n", " TimeFrame should be more or divisible by M", Period());
      return (0);
   }
   i = Bars - IndicatorCounted();
   while (i > 0) {
      i--;
      while (i >= 0)
         if (Time[i] == TimeOpenNewBar || BarNew(i, SetTF) == false) i--;
         else {
            NewBar = true;
            name++;
            break;
         }
      if (i < 0) i = 0;
      if (NewBar == true) {
         //+-----------------------------------------Previos Bar--------------------------------------------+
         OpenBar = iBarShift(0, 0, TimeOpenNewBar, false);
         TimeClosePrevBar = Time[i + 1];
         ClosePrevBar = Close[i + 1];
         HighPrevBar = High[Highest(0, 0, MODE_HIGH, OpenBar - i, i + 1)];
         LowPrevBar = Low[Lowest(0, 0, MODE_LOW, OpenBar - i, i + 1)];
         namePrevCandle = NameBar + (name - 1);
         MidBar = OpenBar - MathRound((OpenBar - i) / 2);
         timePrevShadow = Time[MidBar];
         pricePrevSH = PriceShadow(OpenNewBar, ClosePrevBar, 0);
         pricePrevSL = PriceShadow(OpenNewBar, ClosePrevBar, 1);
         namePrevShadowH = NameHigh + (name - 1);
         namePrevShadowL = NameLow + (name - 1);
         //+----------------------------------Modifi Previos Bar & Shadow-----------------------------------+
         if (ObjectFind(namePrevCandle) == 0) {
            ObjectMove(namePrevCandle, 1, TimeClosePrevBar, ClosePrevBar);
            PropBar(OpenNewBar, ClosePrevBar, namePrevCandle);
            if (OpenBar == i + 1) ObjectSet(namePrevCandle, OBJPROP_WIDTH, Width * 3);
         }
         if (ObjectFind(namePrevShadowH) == 0) {
            if (pricePrevSH == HighPrevBar) ObjectDelete(namePrevShadowH);
            else {
               ObjectMove(namePrevShadowH, 0, timePrevShadow, pricePrevSH);
               ObjectMove(namePrevShadowH, 1, timePrevShadow, HighPrevBar);
               ColorShadow(OpenNewBar, ClosePrevBar, namePrevShadowH);
               ObjectSetText(namePrevShadowH, "High=" + DoubleToStr(HighPrevBar, Digits), 7, "Tahoma");
            }
         }
         if (ObjectFind(namePrevShadowL) == 0) {
            if (pricePrevSL == LowPrevBar) ObjectDelete(namePrevShadowL);
            else {
               ObjectMove(namePrevShadowL, 0, timePrevShadow, pricePrevSL);
               ObjectMove(namePrevShadowL, 1, timePrevShadow, LowPrevBar);
               ColorShadow(OpenNewBar, ClosePrevBar, namePrevShadowL);
               ObjectSetText(namePrevShadowL, "Low=" + DoubleToStr(LowPrevBar, Digits), 7, "Tahoma");
            }
         }
         //+-------------------------------------------New Bar----------------------------------------------+
         OpenNewBar = Open[i];
         TimeOpenNewBar = Time[i];
         HighNewBar = High[i];
         LowNewBar = Low[i];
         CloseNewBar = Close[i];
         TimeCloseNewBar = Time[i] + timerTF - timer;
         nameNewCandle = NameBar + name;
         timeNewShadow = Time[i] + MathRound(Nbar / 2) * timer;
         priceNewSH = PriceShadow(OpenNewBar, CloseNewBar, 0);
         priceNewSL = PriceShadow(OpenNewBar, CloseNewBar, 1);
         nameNewShadowH = NameHigh + name;
         nameNewShadowL = NameLow + name;
         NewBar = false;
      } else {
         //+------------------------------------------Current Bar-------------------------------------------+
         OpenBar = iBarShift(0, 0, TimeOpenNewBar, false);
         CloseCurBar = Close[i];
         HighCurBar = High[Highest(0, 0, MODE_HIGH, OpenBar + 1, i)];
         LowCurBar = Low[Lowest(0, 0, MODE_LOW, OpenBar + 1, i)];
         priceCurSH = PriceShadow(OpenNewBar, CloseCurBar, 0);
         priceCurSL = PriceShadow(OpenNewBar, CloseCurBar, 1);
      }
      //+------------------------------Create New Object & Modifi Current--------------------------------+
      if (ObjectFind(nameNewCandle) != 0) {
         ObjectCreate(nameNewCandle, OBJ_RECTANGLE, 0, TimeOpenNewBar, OpenNewBar, TimeCloseNewBar, CloseNewBar);
         ObjectSet(nameNewCandle, OBJPROP_STYLE, STYLE_SOLID);
         PropBar(OpenNewBar, CloseNewBar, nameNewCandle);
      } else {
         ObjectMove(nameNewCandle, 1, TimeCloseNewBar, CloseCurBar);
         PropBar(OpenNewBar, CloseCurBar, nameNewCandle);
      }
      if (ObjectFind(nameNewShadowH) != 0) {
         ObjectCreate(nameNewShadowH, OBJ_TREND, 0, timeNewShadow, priceNewSH, timeNewShadow, HighNewBar);
         ObjectSet(nameNewShadowH, OBJPROP_STYLE, STYLE_SOLID);
         ObjectSet(nameNewShadowH, OBJPROP_WIDTH, Width);
         ObjectSet(nameNewShadowH, OBJPROP_RAY, false);
         ObjectSet(nameNewShadowH, OBJPROP_BACK, true);
         ColorShadow(OpenNewBar, CloseNewBar, nameNewShadowH);
      } else {
         ObjectMove(nameNewShadowH, 0, timeNewShadow, priceCurSH);
         ObjectMove(nameNewShadowH, 1, timeNewShadow, HighCurBar);
         ColorShadow(OpenNewBar, CloseCurBar, nameNewShadowH);
      }
      if (ObjectFind(nameNewShadowL) != 0) {
         ObjectCreate(nameNewShadowL, OBJ_TREND, 0, timeNewShadow, priceNewSL, timeNewShadow, LowNewBar);
         ObjectSet(nameNewShadowL, OBJPROP_STYLE, STYLE_SOLID);
         ObjectSet(nameNewShadowL, OBJPROP_WIDTH, Width);
         ObjectSet(nameNewShadowL, OBJPROP_RAY, false);
         ObjectSet(nameNewShadowL, OBJPROP_BACK, true);
         ColorShadow(OpenNewBar, CloseNewBar, nameNewShadowL);
      } else {
         ObjectMove(nameNewShadowL, 0, timeNewShadow, priceCurSL);
         ObjectMove(nameNewShadowL, 1, timeNewShadow, LowCurBar);
         ColorShadow(OpenNewBar, CloseCurBar, nameNewShadowL);
      }
      
      if (i > (int)(SetTF / _Period * HistoryCandle) && HistoryCandle > 0) {
         DELETE(NameBar);
         DELETE(NameHigh);
         DELETE(NameLow);
      }
      
      ChartRedraw(0);
      
   }
   //+-------------------------------------Comment OHLC-----------------------------------------------+
   if (ShowOHLC) {
      Comment
         (
            "\n" +
            _Symbol, " M", SetTF +
            "\n" +
            "\n" +
            "Open:  " + (string) OpenNewBar +
            "\n" +
            "High:   " + (string) HighCurBar +
            "\n" +
            "Low:    " + (string) LowCurBar +
            "\n" +
            "Close:  " + (string) CloseCurBar
         );
   }
   return (0);
}
//+---------------------Main Function "New Bar or Old Bar"-----------------------------------------+
bool BarNew(int j, int tmf) {
   int t0 = 1440 * (TimeDayOfWeek(Time[j + CandleShift]) - 1) + 60 * TimeHour(Time[j + CandleShift]) + TimeMinute(Time[j + CandleShift]),
      t1 = 1440 * (TimeDayOfWeek(Time[j + 1 + CandleShift]) - 1) + 60 * TimeHour(Time[j + 1 + CandleShift]) + TimeMinute(Time[j + 1 + CandleShift]);
   if (MathMod(t0, tmf) - MathMod(t1, tmf) == t0 - t1) return (false);
   else return (true);
}
//+---------------------Function "Price Shadow"----------------------------------------------------+
double PriceShadow(double OpnB, double ClsB, int swt) {
   double prH, prL;
   if (OpnB < ClsB) {
      prH = ClsB;
      prL = OpnB;
   }
   if (OpnB > ClsB) {
      prH = OpnB;
      prL = ClsB;
   }
   if (OpnB == ClsB) {
      prH = ClsB;
      prL = ClsB;
   }
   switch (swt) {
   case 0:
      return (prH);
      break;
   case 1:
      return (prL);
      break;
   }
   return (0);
}
//+---------------------Function "Properti Bars"---------------------------------------------------+
void PropBar(double OpPr, double ClPr, string NmOBJ) {
   string Cl = " Close=" + DoubleToStr(ClPr, Digits);
   string Op = " Open=" + DoubleToStr(OpPr, Digits);
   if (OpPr == ClPr) {
      ObjectSet(NmOBJ, OBJPROP_BACK, false);
      ObjectSet(NmOBJ, OBJPROP_COLOR, DojiColor);
      ObjectSetText(NmOBJ, "Doji " + Op + Cl, 7, "Tahoma");
   }
   if (OpPr < ClPr) {
      ObjectSet(NmOBJ, OBJPROP_COLOR, UpCandle);
      ObjectSet(NmOBJ, OBJPROP_BACK, BGCandle);
      ObjectSetText(NmOBJ, "UpBar " + Op + Cl, 7, "Tahoma");
   }
   if (OpPr > ClPr) {
      ObjectSet(NmOBJ, OBJPROP_COLOR, DnCandle);
      ObjectSet(NmOBJ, OBJPROP_BACK, BGCandle);
      ObjectSetText(NmOBJ, "DnBar " + Op + Cl, 7, "Tahoma");
   }
   ObjectSet(NmOBJ, OBJPROP_WIDTH, Width);
}
//+----------------------Function "Color Shadow"---------------------------------------------------+
void ColorShadow(double OP, double CP, string NOBJ) {
   if (OP == CP) ObjectSet(NOBJ, OBJPROP_COLOR, DojiColor);
   if (OP < CP) ObjectSet(NOBJ, OBJPROP_COLOR, UpCandle);
   if (OP > CP) ObjectSet(NOBJ, OBJPROP_COLOR, DnCandle);
}
//+----------------------------------------------END-----------------------------------------------+

//+------------------------------------------------------------------------------------------------+
void DELETE(string PREF) {
   string Name;
   for (int s = ObjectsTotal() - 1; s >= 0; s--) {
      Name = ObjectName(s);
      if (StringSubstr(Name, 0, StringLen(PREF)) == PREF) ObjectDelete(Name);
   }
}
