//+------------------------------------------------------------------+
//|                                                ZIG_ZAG_EXPANSION |
//|                Copyright 2018, https://www.forexfactory.com/crow |
//|                                https://www.forexfactory.com/crow |
//+------------------------------------------------------------------+
#property copyright "https://www.forexfactory.com/crow"
#property link      "https://www.forexfactory.com/crow"
#property description " ZigZag + Revert Fibo "
//+------------------------------------------------------------------+
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red
//---- input parameters----------------------------------------------+
extern int     BR    = 555;
extern int     LG    = 6;
extern int     LG2   = 15;
extern int     LT    = 2;
extern int     ARS   = 2;
extern int     LARS  = 2;
extern color   SCLR  = Magenta;
extern color   BCLR  = Green;
extern color   LCLR  = Blue;
//+------------------------------------------------------------------+
// Расширения Фибоначчи
extern string ______________1_____________ = "Parameters for fibo Expansion";
extern int    ExtFiboExpansion      = 0;
extern color  ExtFiboExpansionColor = Aqua;
extern int    ExtExpansionStyle     = 2;
extern int    ExtExpansionWidth     = 0;
extern bool   FiboExp               = true;
extern bool   ShowArrow             = true;
extern bool   ShowHLine             = true;
//--------------------------------------
//+------------------------------------------------------------------+
extern string _DONATE_ETH_WALLET          = "0x1b31a9a4ef160E52Ea57cAc63A60214CC5CF511d";
extern string _DONATE_POLYGON_WALLET      = "0x1b31a9a4ef160E52Ea57cAc63A60214CC5CF511d";
extern string _DONATE_BSC_WALLET          = "0x7cf9cac2db5a587cfbbe45f149e19de30a711f78";
extern string _EMAIL                      = "koare@hotmail.co.uk";
//+------------------------------------------------------------------+
double         EMB[];
int            shift;
//+------------------------------------------------------------------+
int init() {
   //+------------------------------------------------------------------+
   SetIndexEmptyValue(0, 0.0);
   SetIndexStyle(0, 1, DRAW_SECTION, LT, LCLR);
   SetIndexBuffer(0, EMB);
   //+------------------------------------------------------------------+
   return (0);
}
//+------------------------------------------------------------------+
int deinit() {
   ObjectDelete("Buy");
   ObjectDelete("Sell");
   ObjectDelete("Buy Line");
   ObjectDelete("Sell Line");
   ObjectDelete("Fibo1");
   ObjectDelete("Fibo2");
   Comment("");
   return (0);
}
//+------------------------------------------------------------------+
int start() {
   if (Period() == 1)
      LG = LG2;
   int WF, SW, ND, i, ZZU, ZZD, PP, T1, T2, T3;
   double LL, HH, BH, BL;
   double UNIT[10000][3];
   SW = 0;
   WF = 0;
   ND = 0;
   //+------------------------------------------------------------------+
   BH = High[BR];
   BL = Low[BR];
   ZZU = BR;
   ZZD = BR;
   //+------------------------------------------------------------------+
   for (shift = BR; shift >= 0; shift--) {
      LL = 100000;
      HH = -100000;
      //+------------------------------------------------------------------+
      for (i = shift + LG; i >= shift + 1; i--) {
         if (Low[i] < LL) {
            LL = Low[i];
         };
         if (High[i] > HH) {
            HH = High[i];
         };
      };
      //+------------------------------------------------------------------+
      if (Low[shift] < LL && High[shift] > HH) {
         WF = 2;
         if (SW == 1) {
            ZZU = shift + 1;
         };
         if (SW == -1) {
            ZZD = shift + 1;
         };
      } else {
         if (Low[shift] < LL) {
            WF = -1;
         };
         if (High[shift] > HH) {
            WF = 1;
         };
      };
      //+------------------------------------------------------------------+
      if (WF != SW && SW != 0) {
         //+------------------------------------------------------------------+
         if (WF == 2) {
            WF = -SW;
            BH = High[shift];
            BL = Low[shift];
         };
         ND = ND + 1;
         //+------------------------------------------------------------------+
         if (WF == 1) {
            UNIT[ND][1] = ZZD;
            UNIT[ND][2] = BL;
         };
         //+------------------------------------------------------------------+
         if (WF == -1) {
            UNIT[ND][1] = ZZU;
            UNIT[ND][2] = BH;
         };
         //+------------------------------------------------------------------+
         BH = High[shift];
         BL = Low[shift];
      };
      //+------------------------------------------------------------------+
      if (WF == 1) {
         if (High[shift] >= BH) {
            BH = High[shift];
            ZZU = shift;
         };
      };
      //+------------------------------------------------------------------+
      if (WF == -1) {
         if (Low[shift] <= BL) {
            BL = Low[shift];
            ZZD = shift;
         };
      };
      SW = WF;
   };
   //+------------------------------------------------------------------+
   for (i = 1; i <= ND; i++) {
      PP = StrToInteger(DoubleToStr(UNIT[i][1], 0));
      T1 = StrToInteger(DoubleToStr(UNIT[i][1], 0));
      T2 = StrToInteger(DoubleToStr(UNIT[i - 1][1], 0));
      T3 = StrToInteger(DoubleToStr(UNIT[i - 2][1], 0));
      EMB[PP] = UNIT[i][2];
      double s1 = UNIT[i][2];
      double s2 = UNIT[i - 1][2];
      double s3 = UNIT[i - 2][2];
      //Comment(
      //   " PP = ", PP, " \n"
      //   " T1 = ", T1, " \n"
      //   " T2 = ", T2, " \n"
      //   " T3 = ", T3, " \n"
      //   " s1 = ", s1, " \n"
      //   " s2 = ", s2, " \n"
      //   " s3 = ", s3, " \n"
      // );
   };
   if (s1 < s2) {
      if (ShowArrow) SetArrow(225, BCLR, "Buy", Time[T1], BL, ARS);
      if (ShowHLine) SetHLine(BCLR, "Buy Line", BL, 0, LARS);
      ObjectDelete("Sell Line");
      ObjectDelete("Sell");
      if (FiboExp) {
         ObjectDelete("Fibo2");
         ObjectCreate(0, "Fibo1", OBJ_EXPANSION, 0, T3, s3, T2, s2, T1, s1);
         ObjectSet("Fibo1", OBJPROP_LEVELCOLOR, ExtFiboExpansionColor);
         ObjectSet("Fibo1", OBJPROP_LEVELSTYLE, ExtExpansionStyle);
         //+------------------------------------------------------------------+
         ObjectSet("Fibo1", OBJPROP_FIBOLEVELS, 16); //Устанавливаем число уровней объекта
         ObjectSet("Fibo1", OBJPROP_FIRSTLEVEL + 0, 0.000); //Устанавливаем значения каждого  уровня объекта
         //+------------------------------------------------------------------+0
         ObjectSetDouble(0, "Fibo1", OBJPROP_LEVELVALUE, 0, 0.000);
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELCOLOR, 0, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELSTYLE, 0, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELWIDTH, 0, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo1", 0, "0.000");
         //+------------------------------------------------------------------+0.146
         ObjectSet("Fibo1", OBJPROP_FIRSTLEVEL + 1, 0.146);
         ObjectSetDouble(0, "Fibo1", OBJPROP_LEVELVALUE, 1, 0.146);
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELCOLOR, 1, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELSTYLE, 1, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELWIDTH, 1, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo1", 1, "0.146");
         //+------------------------------------------------------------------+0.236
         ObjectSet("Fibo1", OBJPROP_FIRSTLEVEL + 2, 0.236);
         ObjectSetDouble(0, "Fibo1", OBJPROP_LEVELVALUE, 2, 0.236);
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELCOLOR, 2, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELSTYLE, 2, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELWIDTH, 2, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo1", 2, "0.236");
         //+------------------------------------------------------------------+0.382
         ObjectSet("Fibo1", OBJPROP_FIRSTLEVEL + 3, 0.382);
         ObjectSetDouble(0, "Fibo1", OBJPROP_LEVELVALUE, 3, 0.382);
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELCOLOR, 3, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELSTYLE, 3, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELWIDTH, 3, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo1", 3, "0.382");
         //+------------------------------------------------------------------+0.5
         ObjectSet("Fibo1", OBJPROP_FIRSTLEVEL + 4, 0.5);
         ObjectSetDouble(0, "Fibo1", OBJPROP_LEVELVALUE, 4, 0.5);
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELCOLOR, 4, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELSTYLE, 4, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELWIDTH, 4, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo1", 4, "0.5");
         //+------------------------------------------------------------------+0.618
         ObjectSet("Fibo1", OBJPROP_FIRSTLEVEL + 5, 0.618);
         ObjectSetDouble(0, "Fibo1", OBJPROP_LEVELVALUE, 5, 0.618);
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELCOLOR, 5, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELSTYLE, 5, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELWIDTH, 5, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo1", 5, "0.618");
         //+------------------------------------------------------------------+0.764
         ObjectSet("Fibo1", OBJPROP_FIRSTLEVEL + 6, 0.764);
         ObjectSetDouble(0, "Fibo1", OBJPROP_LEVELVALUE, 6, 0.764);
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELCOLOR, 6, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELSTYLE, 6, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELWIDTH, 6, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo1", 6, "0.764");
         //+------------------------------------------------------------------+1
         ObjectSet("Fibo1", OBJPROP_FIRSTLEVEL + 7, 1);
         ObjectSetDouble(0, "Fibo1", OBJPROP_LEVELVALUE, 7, 1);
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELCOLOR, 7, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELSTYLE, 7, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELWIDTH, 7, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo1", 7, "1");
         //+------------------------------------------------------------------+1.236
         ObjectSet("Fibo1", OBJPROP_FIRSTLEVEL + 8, 1.236);
         ObjectSetDouble(0, "Fibo1", OBJPROP_LEVELVALUE, 8, 1.236);
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELCOLOR, 8, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELSTYLE, 8, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELWIDTH, 8, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo1", 8, "1.236");
         //+------------------------------------------------------------------+1.618
         ObjectSet("Fibo1", OBJPROP_FIRSTLEVEL + 9, 1.618);
         ObjectSetDouble(0, "Fibo1", OBJPROP_LEVELVALUE, 9, 1.618);
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELCOLOR, 9, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELSTYLE, 9, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELWIDTH, 9, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo1", 9, "1.618");
         //+------------------------------------------------------------------+2.618
         ObjectSet("Fibo1", OBJPROP_FIRSTLEVEL + 10, 2.618);
         ObjectSetDouble(0, "Fibo1", OBJPROP_LEVELVALUE, 10, 2.618);
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELCOLOR, 10, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELSTYLE, 10, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELWIDTH, 10, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo1", 10, "2.618");
         //+------------------------------------------------------------------+4.236
         ObjectSet("Fibo1", OBJPROP_FIRSTLEVEL + 11, 4.236);
         ObjectSetDouble(0, "Fibo1", OBJPROP_LEVELVALUE, 11, 4.236);
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELCOLOR, 11, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELSTYLE, 11, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELWIDTH, 11, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo1", 11, "4.236");
         //+------------------------------------------------------------------+6.854
         ObjectSet("Fibo1", OBJPROP_FIRSTLEVEL + 12, 6.854);
         ObjectSetDouble(0, "Fibo1", OBJPROP_LEVELVALUE, 12, 6.854);
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELCOLOR, 12, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELSTYLE, 12, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELWIDTH, 12, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo1", 12, "6.854");
         //+------------------------------------------------------------------+11.09
         ObjectSet("Fibo1", OBJPROP_FIRSTLEVEL + 13, 11.09);
         ObjectSetDouble(0, "Fibo1", OBJPROP_LEVELVALUE, 13, 11.09);
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELCOLOR, 13, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELSTYLE, 13, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELWIDTH, 13, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo1", 13, "11.09");
         //+------------------------------------------------------------------+11.34
         ObjectSet("Fibo1", OBJPROP_FIRSTLEVEL + 14, 12.34);
         ObjectSetDouble(0, "Fibo1", OBJPROP_LEVELVALUE, 14, 12.34);
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELCOLOR, 14, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELSTYLE, 14, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELWIDTH, 14, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo1", 14, "12.34");
         //+------------------------------------------------------------------+13.28
         ObjectSet("Fibo1", OBJPROP_FIRSTLEVEL + 15, 14.6);
         ObjectSetDouble(0, "Fibo1", OBJPROP_LEVELVALUE, 15, 14.6);
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELCOLOR, 15, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELSTYLE, 15, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo1", OBJPROP_LEVELWIDTH, 15, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo1", 15, "14.6");
         //+------------------------------------------------------------------+
      };
   };
   if (s1 > s2) {
      if (ShowArrow) SetArrow(226, SCLR, "Sell", Time[T1], BH, ARS);
      if (ShowHLine) SetHLine(SCLR, "Sell Line", BH, 0, LARS);
      if (FiboExp) {
         ObjectDelete("Fibo1");
         ObjectCreate(0, "Fibo2", OBJ_EXPANSION, 0, T3, s3, T2, s2, T1, s1);
         ObjectSet("Fibo2", OBJPROP_LEVELCOLOR, ExtFiboExpansionColor);
         ObjectSet("Fibo2", OBJPROP_LEVELSTYLE, ExtExpansionStyle);
         //+------------------------------------------------------------------+
         ObjectSet("Fibo2", OBJPROP_FIBOLEVELS, 16); //Устанавливаем число уровней объекта
         ObjectSet("Fibo2", OBJPROP_FIRSTLEVEL + 0, 0.000); //Устанавливаем значения каждого  уровня объекта
         //+------------------------------------------------------------------+0
         ObjectSetDouble(0, "Fibo2", OBJPROP_LEVELVALUE, 0, 0.000);
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELCOLOR, 0, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELSTYLE, 0, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELWIDTH, 0, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo2", 0, "0.000");
         //+------------------------------------------------------------------+0.146
         ObjectSet("Fibo2", OBJPROP_FIRSTLEVEL + 1, 0.146);
         ObjectSetDouble(0, "Fibo2", OBJPROP_LEVELVALUE, 1, 0.146);
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELCOLOR, 1, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELSTYLE, 1, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELWIDTH, 1, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo2", 1, "0.146");
         //+------------------------------------------------------------------+0.236
         ObjectSet("Fibo2", OBJPROP_FIRSTLEVEL + 2, 0.236);
         ObjectSetDouble(0, "Fibo2", OBJPROP_LEVELVALUE, 2, 0.236);
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELCOLOR, 2, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELSTYLE, 2, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELWIDTH, 2, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo2", 2, "0.236");
         //+------------------------------------------------------------------+0.382
         ObjectSet("Fibo2", OBJPROP_FIRSTLEVEL + 3, 0.382);
         ObjectSetDouble(0, "Fibo2", OBJPROP_LEVELVALUE, 3, 0.382);
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELCOLOR, 3, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELSTYLE, 3, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELWIDTH, 3, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo2", 3, "0.382");
         //+------------------------------------------------------------------+0.5
         ObjectSet("Fibo2", OBJPROP_FIRSTLEVEL + 4, 0.5);
         ObjectSetDouble(0, "Fibo2", OBJPROP_LEVELVALUE, 4, 0.5);
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELCOLOR, 4, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELSTYLE, 4, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELWIDTH, 4, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo2", 4, "0.5");
         //+------------------------------------------------------------------+0.618
         ObjectSet("Fibo2", OBJPROP_FIRSTLEVEL + 5, 0.618);
         ObjectSetDouble(0, "Fibo2", OBJPROP_LEVELVALUE, 5, 0.618);
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELCOLOR, 5, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELSTYLE, 5, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELWIDTH, 5, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo2", 5, "0.618");
         //+------------------------------------------------------------------+0.764
         ObjectSet("Fibo2", OBJPROP_FIRSTLEVEL + 6, 0.764);
         ObjectSetDouble(0, "Fibo2", OBJPROP_LEVELVALUE, 6, 0.764);
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELCOLOR, 6, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELSTYLE, 6, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELWIDTH, 6, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo2", 6, "0.764");
         //+------------------------------------------------------------------+1
         ObjectSet("Fibo2", OBJPROP_FIRSTLEVEL + 7, 1);
         ObjectSetDouble(0, "Fibo2", OBJPROP_LEVELVALUE, 7, 1);
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELCOLOR, 7, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELSTYLE, 7, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELWIDTH, 7, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo2", 7, "1");
         //+------------------------------------------------------------------+1.236
         ObjectSet("Fibo2", OBJPROP_FIRSTLEVEL + 8, 1.236);
         ObjectSetDouble(0, "Fibo2", OBJPROP_LEVELVALUE, 8, 1.236);
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELCOLOR, 8, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELSTYLE, 8, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELWIDTH, 8, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo2", 8, "1.236");
         //+------------------------------------------------------------------+1.618
         ObjectSet("Fibo2", OBJPROP_FIRSTLEVEL + 9, 1.618);
         ObjectSetDouble(0, "Fibo2", OBJPROP_LEVELVALUE, 9, 1.618);
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELCOLOR, 9, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELSTYLE, 9, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELWIDTH, 9, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo2", 9, "1.618");
         //+------------------------------------------------------------------+2.618
         ObjectSet("Fibo2", OBJPROP_FIRSTLEVEL + 10, 2.618);
         ObjectSetDouble(0, "Fibo2", OBJPROP_LEVELVALUE, 10, 2.618);
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELCOLOR, 10, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELSTYLE, 10, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELWIDTH, 10, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo2", 10, "2.618");
         //+------------------------------------------------------------------+4.236
         ObjectSet("Fibo2", OBJPROP_FIRSTLEVEL + 11, 4.236);
         ObjectSetDouble(0, "Fibo2", OBJPROP_LEVELVALUE, 11, 4.236);
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELCOLOR, 11, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELSTYLE, 11, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELWIDTH, 11, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo2", 11, "4.236");
         //+------------------------------------------------------------------+6.854
         ObjectSet("Fibo2", OBJPROP_FIRSTLEVEL + 12, 6.854);
         ObjectSetDouble(0, "Fibo2", OBJPROP_LEVELVALUE, 12, 6.854);
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELCOLOR, 12, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELSTYLE, 12, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELWIDTH, 12, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo2", 12, "6.854");
         //+------------------------------------------------------------------+11.09
         ObjectSet("Fibo2", OBJPROP_FIRSTLEVEL + 13, 11.09);
         ObjectSetDouble(0, "Fibo2", OBJPROP_LEVELVALUE, 13, 11.09);
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELCOLOR, 13, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELSTYLE, 13, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELWIDTH, 13, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo2", 13, "11.09");
         //+------------------------------------------------------------------+11.34
         ObjectSet("Fibo2", OBJPROP_FIRSTLEVEL + 14, 12.34);
         ObjectSetDouble(0, "Fibo2", OBJPROP_LEVELVALUE, 14, 12.34);
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELCOLOR, 14, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELSTYLE, 14, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELWIDTH, 14, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo2", 14, "12.34");
         //+------------------------------------------------------------------+13.28
         ObjectSet("Fibo2", OBJPROP_FIRSTLEVEL + 15, 14.6);
         ObjectSetDouble(0, "Fibo2", OBJPROP_LEVELVALUE, 15, 14.6);
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELCOLOR, 15, ExtFiboExpansionColor); // цвет уровня
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELSTYLE, 15, ExtExpansionStyle); //Сплошная линия
         ObjectSetInteger(0, "Fibo2", OBJPROP_LEVELWIDTH, 15, ExtExpansionWidth); //--- толщина уровня
         ObjectSetFiboDescription("Fibo2", 15, "14.6");
         //+------------------------------------------------------------------+
      };
      ObjectDelete("Buy Line");
      ObjectDelete("Buy");
   };
   return (0);
}
//+------------------------------------------------------------------+
void SetHLine(color cl, string nm = "", double p1 = 0, int st = 0, int wd = 1) {
   if (nm == "")
      nm = DoubleToStr(Time[0], 0);
   if (p1 <= 0)
      p1 = Bid;
   if (ObjectFind(nm) < 0)
      ObjectCreate(nm, OBJ_HLINE, 0, 0, 0);
   ObjectSet(nm, OBJPROP_PRICE1, p1);
   ObjectSet(nm, OBJPROP_COLOR, cl);
   ObjectSet(nm, OBJPROP_STYLE, st);
   ObjectSet(nm, OBJPROP_WIDTH, wd);
}
//+------------------------------------------------------------------+
void SetArrow(int cd, color cl, string nm = "", datetime t1 = 0, double p1 = 0, int sz = 0) {
   if (nm == "")
      nm = DoubleToStr(Time[0], 0);
   if (t1 <= 0)
      t1 = Time[0];
   if (p1 <= 0)
      p1 = Bid;
   if (ObjectFind(nm) < 0)
      ObjectCreate(nm, OBJ_ARROW, 0, 0, 0);
   ObjectSet(nm, OBJPROP_TIME1, t1);
   ObjectSet(nm, OBJPROP_PRICE1, p1);
   ObjectSet(nm, OBJPROP_ARROWCODE, cd);
   ObjectSet(nm, OBJPROP_COLOR, cl);
   ObjectSet(nm, OBJPROP_WIDTH, sz);
}
//+------------------------------------------------------------------+
