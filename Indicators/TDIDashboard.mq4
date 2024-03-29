//+------------------------------------------------------------------+
//|                                        #Signal_Bars_v3_Daily.mq4 |
//|                      Copyright © 2006,MetaQuotes Software Corp.  |
//|                                        http://www.metaquotes.net |
//|                                                                  |
//|  Modified by ztrader for "Traders Dynamic Index"                 |
//| Line 135 mod by Mos to "TDI"                                     | 
//+------------------------------------------------------------------+
//   http://worldwide-invest.org/mql-programming/42386-tdi-dashboard-help.html   

#property copyright "Copyright © 2006,MetaQuotes Software Corp."
#property link "http://www.metaquotes.net"
#property link " cja "
#property indicator_chart_window

extern int Corner = 1;
extern int Pos_X = 10;
extern int Pos_Y = 5;
extern color Text_Color = Lavender; // LightGray;
extern color ColorUp = Lime;
extern color ColorDown = OrangeRed;

extern string note3 = "TDI";

extern int RSI_Period = 13;
extern int RSI_Price = 0;
extern int RSI_Price_Line = 2;
extern int RSI_Price_Type = 0;
extern int Trade_Signal_Line = 7;
extern int Trade_Signal_Type = 0;
extern int Volatility_Band = 34;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init() {
   //---- indicators
   //----
   return (0);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit() {
   //----
   ObjectsDeleteAll(0, OBJ_LABEL);
   //----
   return (0);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start() {
   ObjectCreate("Numbers", OBJ_LABEL, 0, 0, 0);
   if ((Corner % 2) == 1)
      ObjectSetText("Numbers", " M1    M5    M15   M30   H1    H4    D1", 8, "Tahoma Narrow", Text_Color);
   else
      ObjectSetText("Numbers", " D1    H4    H1    M30   M15   M5    M1", 8, "Tahoma Narrow", Text_Color);
   ObjectSet("Numbers", OBJPROP_CORNER, Corner);
   ObjectSet("Numbers", OBJPROP_XDISTANCE, 10 + Pos_X);
   ObjectSet("Numbers", OBJPROP_YDISTANCE, 35 + Pos_Y);

   string TDI1_h1 = "";
   string TDI1_m15 = "";
   string TDI1_m5 = "";
   string TDI1_m1 = "";
   string TDI1_h4 = "";
   string TDI1_m30 = "";
   string TDI1_d1 = "";

   color colorTDI1_m1 = LightGray;
   color colorTDI1_m5 = LightGray;
   color colorTDI1_m15 = LightGray;
   color colorTDI1_m30 = LightGray;
   color colorTDI1_m60 = LightGray;
   color colorTDI1_m240 = LightGray;
   color colorTDI1_m1440 = LightGray;

   double MaBufD1 = iCustom(NULL, PERIOD_D1, "TradersDynamicIndex", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 4, 0);
   double MbBufD1 = iCustom(NULL, PERIOD_D1, "TradersDynamicIndex", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 5, 0);
   double MdZoneD1 = iCustom(NULL, PERIOD_D1, "TradersDynamicIndex", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 2, 0);

   double MaBufH4 = iCustom(NULL, PERIOD_H4, "TradersDynamicIndex", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 4, 0);
   double MbBufH4 = iCustom(NULL, PERIOD_H4, "TradersDynamicIndex", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 5, 0);
   double MdZoneH4 = iCustom(NULL, PERIOD_H4, "TradersDynamicIndex", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 2, 0);

   double MaBufH1 = iCustom(NULL, PERIOD_H1, "TradersDynamicIndex", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 4, 0);
   double MbBufH1 = iCustom(NULL, PERIOD_H1, "TradersDynamicIndex", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 5, 0);
   double MdZoneH1 = iCustom(NULL, PERIOD_H1, "TradersDynamicIndex", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 2, 0);

   double MaBufM30 = iCustom(NULL, PERIOD_M30, "TradersDynamicIndex", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 4, 0);
   double MbBufM30 = iCustom(NULL, PERIOD_M30, "TradersDynamicIndex", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 5, 0);
   double MdZoneM30 = iCustom(NULL, PERIOD_M30, "TradersDynamicIndex", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 2, 0);

   double MaBufM15 = iCustom(NULL, PERIOD_M15, "TradersDynamicIndex", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 4, 0);
   double MbBufM15 = iCustom(NULL, PERIOD_M15, "TradersDynamicIndex", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 5, 0);
   double MdZoneM15 = iCustom(NULL, PERIOD_M15, "TradersDynamicIndex", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 2, 0);

   double MaBufM5 = iCustom(NULL, PERIOD_M5, "TradersDynamicIndex", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 4, 0);
   double MbBufM5 = iCustom(NULL, PERIOD_M5, "TradersDynamicIndex", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 5, 0);
   double MdZoneM5 = iCustom(NULL, PERIOD_M5, "TradersDynamicIndex", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 2, 0);

   double MaBufM1 = iCustom(NULL, PERIOD_M1, "TradersDynamicIndex", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 4, 0);
   double MbBufM1 = iCustom(NULL, PERIOD_M1, "TradersDynamicIndex", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 5, 0);
   double MdZoneM1 = iCustom(NULL, PERIOD_M1, "TradersDynamicIndex", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 2, 0);

   TDI1_d1 = "-";
   TDI1_h4 = "-";
   TDI1_h1 = "-";
   TDI1_m30 = "-";
   TDI1_m15 = "-";
   TDI1_m5 = "-";
   TDI1_m1 = "-";

   if ((MaBufD1 > MbBufD1) && (MbBufD1 > MdZoneD1)) {
      colorTDI1_m1440 = ColorUp;
   }
   if ((MaBufH4 > MbBufH4) && (MbBufH4 > MdZoneH4)) {
      colorTDI1_m240 = ColorUp;
   }
   if ((MaBufH1 > MbBufH1) && (MbBufH1 > MdZoneH1)) {
      colorTDI1_m60 = ColorUp;
   }
   if ((MaBufM30 > MbBufM30) && (MbBufM30 > MdZoneM30)) {
      colorTDI1_m30 = ColorUp;
   }
   if ((MaBufM15 > MbBufM15) && (MbBufM15 > MdZoneM15)) {
      colorTDI1_m15 = ColorUp;
   }
   if ((MaBufM5 > MbBufM5) && (MbBufM5 > MdZoneM5)) {
      colorTDI1_m5 = ColorUp;
   }
   if ((MaBufM1 > MbBufM1) && (MbBufM1 > MdZoneM1)) {
      colorTDI1_m1 = ColorUp;
   }

   if ((MaBufD1 < MbBufD1) && (MbBufD1 < MdZoneD1)) {
      colorTDI1_m1440 = ColorDown;
   }
   if ((MaBufH4 < MbBufH4) && (MbBufH4 < MdZoneH4)) {
      colorTDI1_m240 = ColorDown;
   }
   if ((MaBufH1 < MbBufH1) && (MbBufH1 < MdZoneH1)) {
      colorTDI1_m60 = ColorDown;
   }
   if ((MaBufM30 < MbBufM30) && (MbBufM30 < MdZoneM30)) {
      colorTDI1_m30 = ColorDown;
   }
   if ((MaBufM15 < MbBufM15) && (MbBufM15 < MdZoneM15)) {
      colorTDI1_m15 = ColorDown;
   }
   if ((MaBufM5 < MbBufM5) && (MbBufM5 < MdZoneM5)) {
      colorTDI1_m5 = ColorDown;
   }
   if ((MaBufM1 < MbBufM1) && (MbBufM1 < MdZoneM1)) {
      colorTDI1_m1 = ColorDown;
   }

   ObjectCreate("SignalTDI1", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("SignalTDI1", "TDI  ", 8, "Tahoma Narrow", Text_Color);
   //ObjectSetText("SignalTDI1","Traders Dynamic Index",8,"Tahoma Narrow",Text_Color);
   ObjectSet("SignalTDI1", OBJPROP_CORNER, Corner);
   ObjectSet("SignalTDI1", OBJPROP_XDISTANCE, 195 + Pos_X);
   ObjectSet("SignalTDI1", OBJPROP_YDISTANCE, 61 + Pos_Y);

   ObjectCreate("SignalTDI1m1", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("SignalTDI1m1", TDI1_m1, 60, "Tahoma Narrow", colorTDI1_m1);
   ObjectSet("SignalTDI1m1", OBJPROP_CORNER, Corner);
   ObjectSet("SignalTDI1m1", OBJPROP_XDISTANCE, 166 + Pos_X);
   ObjectSet("SignalTDI1m1", OBJPROP_YDISTANCE, 20 + Pos_Y);

   ObjectCreate("SignalTDI1m5", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("SignalTDI1m5", TDI1_m5, 60, "Tahoma Narrow", colorTDI1_m5);
   ObjectSet("SignalTDI1m5", OBJPROP_CORNER, Corner);
   ObjectSet("SignalTDI1m5", OBJPROP_XDISTANCE, 140 + Pos_X);
   ObjectSet("SignalTDI1m5", OBJPROP_YDISTANCE, 20 + Pos_Y);

   ObjectCreate("SignalTDI1m15", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("SignalTDI1m15", TDI1_m15, 60, "Tahoma Narrow", colorTDI1_m15);
   ObjectSet("SignalTDI1m15", OBJPROP_CORNER, Corner);
   ObjectSet("SignalTDI1m15", OBJPROP_XDISTANCE, 114 + Pos_X);
   ObjectSet("SignalTDI1m15", OBJPROP_YDISTANCE, 20 + Pos_Y);

   ObjectCreate("SignalTDI1m30", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("SignalTDI1m30", TDI1_m30, 60, "Tahoma Narrow", colorTDI1_m30);
   ObjectSet("SignalTDI1m30", OBJPROP_CORNER, Corner);
   ObjectSet("SignalTDI1m30", OBJPROP_XDISTANCE, 88 + Pos_X);
   ObjectSet("SignalTDI1m30", OBJPROP_YDISTANCE, 20 + Pos_Y);

   ObjectCreate("SignalTDI1h1", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("SignalTDI1h1", TDI1_h1, 60, "Tahoma Narrow", colorTDI1_m60);
   ObjectSet("SignalTDI1h1", OBJPROP_CORNER, Corner);
   ObjectSet("SignalTDI1h1", OBJPROP_XDISTANCE, 62 + Pos_X);
   ObjectSet("SignalTDI1h1", OBJPROP_YDISTANCE, 20 + Pos_Y);

   ObjectCreate("SignalTDI1h4", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("SignalTDI1h4", TDI1_h4, 60, "Tahoma Narrow", colorTDI1_m240);
   ObjectSet("SignalTDI1h4", OBJPROP_CORNER, Corner);
   ObjectSet("SignalTDI1h4", OBJPROP_XDISTANCE, 36 + Pos_X);
   ObjectSet("SignalTDI1h4", OBJPROP_YDISTANCE, 20 + Pos_Y);

   ObjectCreate("SignalTDI1d1", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("SignalTDI1d1", TDI1_d1, 60, "Tahoma Narrow", colorTDI1_m1440);
   ObjectSet("SignalTDI1d1", OBJPROP_CORNER, Corner);
   ObjectSet("SignalTDI1d1", OBJPROP_XDISTANCE, 10 + Pos_X);
   ObjectSet("SignalTDI1d1", OBJPROP_YDISTANCE, 20 + Pos_Y);
   return (0);
}
