//+------------------------------------------------------------------+
//|                                                         ican.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.1"

int TicketOrder;
int PairDigit = 2;
int OpenPositionCounter;

extern string EAName = "ican";
extern int MagicNumber = 575899;
extern double EquityStopEA = 9700.0;
extern double Lots = 0.01;
extern double LotExponent = 1.2;
extern double MaxLots = 0.5;
extern double TakeProfit = 55.5;
extern double PipStep = 99.9;
extern double SlipPage = 5;
extern int MaxTrades = 5;
double G_price_280;
double Gd_unused_296;
double Gd_unused_304;
double G_price_312;
double G_bid_320;
double G_ask_328;
double Gd_336;
double Gd_344;
double Gd_352;
bool Gi_360;
int Gi_372 = 0;
int Gi_380 = 0;
double Gd_384;
int G_pos_392 = 0;
int Gi_396;
bool Gi_408 = FALSE;
bool Gi_412 = FALSE;
bool Gi_416 = FALSE;
bool Gi_424 = FALSE;
double Gd_428;
double Gd_436;
int G_timeframe_496 = PERIOD_H1;
double G_pips_508 = 500.0;
bool Gi_532 = FALSE;
double Gd_536 = 48.0;
double slip_15 = 3.0;
int G_magic_176_15 = 575899;
double G_price_564;
double Gd_572;
double Gd_unused_580;
double Gd_unused_588;
double G_price_596;
double G_bid_604;
double G_ask_612;
double Gd_620;
double Gd_628;
double Gd_636;
bool Gi_644;
int Gi_656 = 0;
int Gi_660;
int Gi_664 = 0;
double Gd_668;
int G_pos_676 = 0;
int Gi_680;
double Gd_684 = 0.0;
bool Gi_692 = FALSE;
bool Gi_696 = FALSE;
bool Gi_700 = FALSE;
int Gi_704;
bool Gi_708 = FALSE;
double Gd_712;
double Gd_720;
int G_datetime_728 = 1;
int G_timeframe_784 = PERIOD_M1;
double G_pips_792 = 500.0;
bool Gi_816 = FALSE;
double Gd_820 = 48.0;
double slip_16 = 3.0;
int G_magic_176_16 = 16794;
double G_price_848;
double Gd_856;
double Gd_unused_864;
double Gd_unused_872;
double G_price_880;
double G_bid_888;
double G_ask_896;
double Gd_904;
double Gd_912;
double Gd_920;
bool Gi_928;
int Gi_940 = 0;
int Gi_944;
int Gi_948 = 0;
double Gd_952;
int G_pos_960 = 0;
int Gi_964;
double Gd_968 = 0.0;
bool Gi_976 = FALSE;
bool Gi_980 = FALSE;
bool Gi_984 = FALSE;
int Gi_988;
bool Gi_992 = FALSE;
double Gd_996;
double Gd_1004;
int G_datetime_1012 = 1;
int G_timeframe_1024 = PERIOD_M1;
int G_timeframe_1028 = PERIOD_M5;
int G_timeframe_1032 = PERIOD_M15;
int G_timeframe_1036 = PERIOD_M30;
int G_timeframe_1040 = PERIOD_H1;
int G_timeframe_1044 = PERIOD_H4;
int G_timeframe_1048 = PERIOD_D1;
bool G_corner_1052 = TRUE;
int Gi_1056 = 0;
int Gi_1060 = 10;
int G_window_1064 = 0;
bool Gi_1068 = TRUE;
bool Gi_unused_1072 = TRUE;
bool Gi_1076 = FALSE;
int G_color_1080 = Green;
int G_color_1084 = Green;
int G_color_1088 = Maroon;
int G_color_1092 = Blue;
int Gi_unused_1096 = 36095;
int G_color_1100 = Lime;
int G_color_1104 = Yellow;
int Gi_1108 = 65280;
int Gi_1112 = 17919;
int G_color_1116 = Red;
int G_color_1120 = Blue;
int G_color_1124 = Yellow;
int G_period_1128 = 8;
int G_period_1132 = 17;
int G_period_1136 = 9;
int G_applied_price_1140 = PRICE_CLOSE;
int G_color_1144 = Lime;
int G_color_1148 = Maroon;
int G_color_1152 = LimeGreen;
int G_color_1156 = MediumBlue;
string Gs_unused_1160 = "<<<< STR Indicator Settings >>>>>>>>>>>>>";
string Gs_unused_1168 = "<<<< RSI Settings >>>>>>>>>>>>>";
int G_period_1176 = 9;
int G_applied_price_1180 = PRICE_CLOSE;
string Gs_unused_1184 = "<<<< CCI Settings >>>>>>>>>>>>>>";
int G_period_1192 = 13;
int G_applied_price_1196 = PRICE_CLOSE;
string Gs_unused_1200 = "<<<< STOCH Settings >>>>>>>>>>>";
int G_period_1208 = 8;
int G_period_1212 = 3;
int G_slowing_1216 = 3;
int G_ma_method_1220 = MODE_EMA;
string Gs_unused_1224 = "<<<< STR Colors >>>>>>>>>>>>>>>>";
int G_color_1232 = MediumBlue;
int G_color_1236 = Green;
int G_color_1240 = Yellow;
string Gs_unused_1244 = "<<<< MA Settings >>>>>>>>>>>>>>";
int G_period_1252 = 5;
int G_period_1256 = 9;
int G_ma_method_1260 = MODE_EMA;
int G_applied_price_1264 = PRICE_CLOSE;
string Gs_unused_1268 = "<<<< MA Colors >>>>>>>>>>>>>>";
int G_color_1276 = SteelBlue;
int G_color_1280 = DarkGreen;
string Gs_dummy_1292;
string G_text_1464;
string G_text_1472;
int G_str2int_1496;
int G_str2int_1500;
int G_str2int_1504;


int init() {
   return (0);
}


int deinit() {
   return(0);
}


int start() {

   RemoveExpertNow(EquityStopEA);
   
   int Li_4;
   int Li_8;
   int Li_12;
   int Li_16;
   int Li_20;
   int Li_24;
   int Li_28;
   color color_32;
   color color_36;
   color color_40;
   color color_44;
   color color_48;
   color color_52;
   color color_56;
   string Ls_unused_60;
   color color_68;
   color color_72;
   color color_76;
   color color_80;
   color color_84;
   color color_88;
   color color_92;
   color color_96;
   string Ls_unused_100;
   color color_108;
   int Li_unused_112;
   double ihigh_1128;
   double ilow_1136;
   double iclose_1144;
   double iclose_1152;
   double Ld_1192;
   double Ld_1248;
   double Ld_1256;
   int Li_1264;
   int count_1268;
   double Ld_1316;
   double Ld_1324;
   int Li_1332;
   int count_1336;
   int ind_counted_0 = IndicatorCounted();

   if (Lots > MaxLots) Lots = MaxLots;
   Comment("" +
      "Bismillahirrohmanirrohim\n" +
      "Broker: " + AccountCompany() + "\n" +
      "Server Time: " + TimeToStr(TimeCurrent(), TIME_DATE | TIME_SECONDS) + "\n" +
      "Your Name: " + AccountName() + "\n" +
      "Account: " + AccountNumber() + "\n" +
      "Balance: " + DoubleToStr(AccountBalance(), 2) + "\n" +
      "Equity: " + DoubleToStr(AccountEquity(), 2) + "\n" +
      "Open Order: " + OpenPositionCounter + "\n" +
      "");
   int ind_counted_272 = IndicatorCounted();
   string text_276 = "";
   string text_284 = "";
   string text_292 = "";
   string text_300 = "";
   string text_308 = "";
   string text_316 = "";
   string text_324 = "";
   if (G_timeframe_1024 == PERIOD_M1) text_276 = "M1";
   if (G_timeframe_1024 == PERIOD_M5) text_276 = "M5";
   if (G_timeframe_1024 == PERIOD_M15) text_276 = "M15";
   if (G_timeframe_1024 == PERIOD_M30) text_276 = "M30";
   if (G_timeframe_1024 == PERIOD_H1) text_276 = "H1";
   if (G_timeframe_1024 == PERIOD_H4) text_276 = "H4";
   if (G_timeframe_1024 == PERIOD_D1) text_276 = "D1";
   if (G_timeframe_1024 == PERIOD_W1) text_276 = "W1";
   if (G_timeframe_1024 == PERIOD_MN1) text_276 = "MN";
   if (G_timeframe_1028 == PERIOD_M1) text_284 = "M1";
   if (G_timeframe_1028 == PERIOD_M5) text_284 = "M5";
   if (G_timeframe_1028 == PERIOD_M15) text_284 = "M15";
   if (G_timeframe_1028 == PERIOD_M30) text_284 = "M30";
   if (G_timeframe_1028 == PERIOD_H1) text_284 = "H1";
   if (G_timeframe_1028 == PERIOD_H4) text_284 = "H4";
   if (G_timeframe_1028 == PERIOD_D1) text_284 = "D1";
   if (G_timeframe_1028 == PERIOD_W1) text_284 = "W1";
   if (G_timeframe_1028 == PERIOD_MN1) text_284 = "MN";
   if (G_timeframe_1032 == PERIOD_M1) text_292 = "M1";
   if (G_timeframe_1032 == PERIOD_M5) text_292 = "M5";
   if (G_timeframe_1032 == PERIOD_M15) text_292 = "M15";
   if (G_timeframe_1032 == PERIOD_M30) text_292 = "M30";
   if (G_timeframe_1032 == PERIOD_H1) text_292 = "H1";
   if (G_timeframe_1032 == PERIOD_H4) text_292 = "H4";
   if (G_timeframe_1032 == PERIOD_D1) text_292 = "D1";
   if (G_timeframe_1032 == PERIOD_W1) text_292 = "W1";
   if (G_timeframe_1032 == PERIOD_MN1) text_292 = "MN";
   if (G_timeframe_1036 == PERIOD_M1) text_300 = "M1";
   if (G_timeframe_1036 == PERIOD_M5) text_300 = "M5";
   if (G_timeframe_1036 == PERIOD_M15) text_300 = "M15";
   if (G_timeframe_1036 == PERIOD_M30) text_300 = "M30";
   if (G_timeframe_1036 == PERIOD_H1) text_300 = "H1";
   if (G_timeframe_1036 == PERIOD_H4) text_300 = "H4";
   if (G_timeframe_1036 == PERIOD_D1) text_300 = "D1";
   if (G_timeframe_1036 == PERIOD_W1) text_300 = "W1";
   if (G_timeframe_1036 == PERIOD_MN1) text_300 = "MN";
   if (G_timeframe_1040 == PERIOD_M1) text_308 = "M1";
   if (G_timeframe_1040 == PERIOD_M5) text_308 = "M5";
   if (G_timeframe_1040 == PERIOD_M15) text_308 = "M15";
   if (G_timeframe_1040 == PERIOD_M30) text_308 = "M30";
   if (G_timeframe_1040 == PERIOD_H1) text_308 = "H1";
   if (G_timeframe_1040 == PERIOD_H4) text_308 = "H4";
   if (G_timeframe_1040 == PERIOD_D1) text_308 = "D1";
   if (G_timeframe_1040 == PERIOD_W1) text_308 = "W1";
   if (G_timeframe_1040 == PERIOD_MN1) text_308 = "MN";
   if (G_timeframe_1044 == PERIOD_M1) text_316 = "M1";
   if (G_timeframe_1044 == PERIOD_M5) text_316 = "M5";
   if (G_timeframe_1044 == PERIOD_M15) text_316 = "M15";
   if (G_timeframe_1044 == PERIOD_M30) text_316 = "M30";
   if (G_timeframe_1044 == PERIOD_H1) text_316 = "H1";
   if (G_timeframe_1044 == PERIOD_H4) text_316 = "H4";
   if (G_timeframe_1044 == PERIOD_D1) text_316 = "D1";
   if (G_timeframe_1044 == PERIOD_W1) text_316 = "W1";
   if (G_timeframe_1044 == PERIOD_MN1) text_316 = "MN";
   if (G_timeframe_1048 == PERIOD_M1) text_324 = "M1";
   if (G_timeframe_1048 == PERIOD_M5) text_324 = "M5";
   if (G_timeframe_1048 == PERIOD_M15) text_324 = "M15";
   if (G_timeframe_1048 == PERIOD_M30) text_324 = "M30";
   if (G_timeframe_1048 == PERIOD_H1) text_324 = "H1";
   if (G_timeframe_1048 == PERIOD_H4) text_324 = "H4";
   if (G_timeframe_1048 == PERIOD_D1) text_324 = "D1";
   if (G_timeframe_1048 == PERIOD_W1) text_324 = "W1";
   if (G_timeframe_1048 == PERIOD_MN1) text_324 = "MN";
   if (G_timeframe_1024 == PERIOD_M15) Li_4 = -2;
   if (G_timeframe_1024 == PERIOD_M30) Li_4 = -2;
   if (G_timeframe_1028 == PERIOD_M15) Li_8 = -2;
   if (G_timeframe_1028 == PERIOD_M30) Li_8 = -2;
   if (G_timeframe_1032 == PERIOD_M15) Li_12 = -2;
   if (G_timeframe_1032 == PERIOD_M30) Li_12 = -2;
   if (G_timeframe_1036 == PERIOD_M15) Li_16 = -2;
   if (G_timeframe_1036 == PERIOD_M30) Li_16 = -2;
   if (G_timeframe_1040 == PERIOD_M15) Li_20 = -2;
   if (G_timeframe_1040 == PERIOD_M30) Li_20 = -2;
   if (G_timeframe_1044 == PERIOD_M15) Li_24 = -2;
   if (G_timeframe_1044 == PERIOD_M30) Li_24 = -2;
   if (G_timeframe_1048 == PERIOD_M15) Li_28 = -2;
   if (G_timeframe_1044 == PERIOD_M30) Li_28 = -2;
   if (Gi_1056 < 0) return (0);

   string text_332 = "";
   string text_340 = "";
   string text_348 = "";
   string text_356 = "";
   string text_364 = "";
   string text_372 = "";
   string text_380 = "";
   string Ls_unused_388 = "";
   string Ls_unused_396 = "";
   double imacd_404 = iMACD(NULL, G_timeframe_1024, G_period_1128, G_period_1132, G_period_1136, G_applied_price_1140, MODE_MAIN, 0);
   double imacd_412 = iMACD(NULL, G_timeframe_1024, G_period_1128, G_period_1132, G_period_1136, G_applied_price_1140, MODE_SIGNAL, 0);
   double imacd_420 = iMACD(NULL, G_timeframe_1028, G_period_1128, G_period_1132, G_period_1136, G_applied_price_1140, MODE_MAIN, 0);
   double imacd_428 = iMACD(NULL, G_timeframe_1028, G_period_1128, G_period_1132, G_period_1136, G_applied_price_1140, MODE_SIGNAL, 0);
   double imacd_436 = iMACD(NULL, G_timeframe_1032, G_period_1128, G_period_1132, G_period_1136, G_applied_price_1140, MODE_MAIN, 0);
   double imacd_444 = iMACD(NULL, G_timeframe_1032, G_period_1128, G_period_1132, G_period_1136, G_applied_price_1140, MODE_SIGNAL, 0);
   double imacd_452 = iMACD(NULL, G_timeframe_1036, G_period_1128, G_period_1132, G_period_1136, G_applied_price_1140, MODE_MAIN, 0);
   double imacd_460 = iMACD(NULL, G_timeframe_1036, G_period_1128, G_period_1132, G_period_1136, G_applied_price_1140, MODE_SIGNAL, 0);
   double imacd_468 = iMACD(NULL, G_timeframe_1040, G_period_1128, G_period_1132, G_period_1136, G_applied_price_1140, MODE_MAIN, 0);
   double imacd_476 = iMACD(NULL, G_timeframe_1040, G_period_1128, G_period_1132, G_period_1136, G_applied_price_1140, MODE_SIGNAL, 0);
   double imacd_484 = iMACD(NULL, G_timeframe_1044, G_period_1128, G_period_1132, G_period_1136, G_applied_price_1140, MODE_MAIN, 0);
   double imacd_492 = iMACD(NULL, G_timeframe_1044, G_period_1128, G_period_1132, G_period_1136, G_applied_price_1140, MODE_SIGNAL, 0);
   double imacd_500 = iMACD(NULL, G_timeframe_1048, G_period_1128, G_period_1132, G_period_1136, G_applied_price_1140, MODE_MAIN, 0);
   double imacd_508 = iMACD(NULL, G_timeframe_1048, G_period_1128, G_period_1132, G_period_1136, G_applied_price_1140, MODE_SIGNAL, 0);
   if (imacd_404 > imacd_412) {
      text_356 = "-";
      color_44 = G_color_1152;
   }
   if (imacd_404 <= imacd_412) {
      text_356 = "-";
      color_44 = G_color_1148;
   }
   if (imacd_404 > imacd_412 && imacd_404 > 0.0) {
      text_356 = "-";
      color_44 = G_color_1144;
   }
   if (imacd_404 <= imacd_412 && imacd_404 < 0.0) {
      text_356 = "-";
      color_44 = G_color_1156;
   }
   if (imacd_420 > imacd_428) {
      text_364 = "-";
      color_48 = G_color_1152;
   }
   if (imacd_420 <= imacd_428) {
      text_364 = "-";
      color_48 = G_color_1148;
   }
   if (imacd_420 > imacd_428 && imacd_420 > 0.0) {
      text_364 = "-";
      color_48 = G_color_1144;
   }
   if (imacd_420 <= imacd_428 && imacd_420 < 0.0) {
      text_364 = "-";
      color_48 = G_color_1156;
   }
   if (imacd_436 > imacd_444) {
      text_372 = "-";
      color_52 = G_color_1152;
   }
   if (imacd_436 <= imacd_444) {
      text_372 = "-";
      color_52 = G_color_1148;
   }
   if (imacd_436 > imacd_444 && imacd_436 > 0.0) {
      text_372 = "-";
      color_52 = G_color_1144;
   }
   if (imacd_436 <= imacd_444 && imacd_436 < 0.0) {
      text_372 = "-";
      color_52 = G_color_1156;
   }
   if (imacd_452 > imacd_460) {
      text_380 = "-";
      color_56 = G_color_1152;
   }
   if (imacd_452 <= imacd_460) {
      text_380 = "-";
      color_56 = G_color_1148;
   }
   if (imacd_452 > imacd_460 && imacd_452 > 0.0) {
      text_380 = "-";
      color_56 = G_color_1144;
   }
   if (imacd_452 <= imacd_460 && imacd_452 < 0.0) {
      text_380 = "-";
      color_56 = G_color_1156;
   }
   if (imacd_468 > imacd_476) {
      text_340 = "-";
      color_36 = G_color_1152;
   }
   if (imacd_468 <= imacd_476) {
      text_340 = "-";
      color_36 = G_color_1148;
   }
   if (imacd_468 > imacd_476 && imacd_468 > 0.0) {
      text_340 = "-";
      color_36 = G_color_1144;
   }
   if (imacd_468 <= imacd_476 && imacd_468 < 0.0) {
      text_340 = "-";
      color_36 = G_color_1156;
   }
   if (imacd_484 > imacd_492) {
      text_348 = "-";
      color_40 = G_color_1152;
   }
   if (imacd_484 <= imacd_492) {
      text_348 = "-";
      color_40 = G_color_1148;
   }
   if (imacd_484 > imacd_492 && imacd_484 > 0.0) {
      text_348 = "-";
      color_40 = G_color_1144;
   }
   if (imacd_484 <= imacd_492 && imacd_484 < 0.0) {
      text_348 = "-";
      color_40 = G_color_1156;
   }
   if (imacd_500 > imacd_508) {
      text_332 = "-";
      color_32 = G_color_1152;
   }
   if (imacd_500 <= imacd_508) {
      text_332 = "-";
      color_32 = G_color_1148;
   }
   if (imacd_500 > imacd_508 && imacd_500 > 0.0) {
      text_332 = "-";
      color_32 = G_color_1144;
   }
   if (imacd_500 <= imacd_508 && imacd_500 < 0.0) {
      text_332 = "-";
      color_32 = G_color_1156;
   }

   double irsi_516 = iRSI(NULL, G_timeframe_1048, G_period_1176, G_applied_price_1180, 0);
   double irsi_524 = iRSI(NULL, G_timeframe_1044, G_period_1176, G_applied_price_1180, 0);
   double irsi_532 = iRSI(NULL, G_timeframe_1040, G_period_1176, G_applied_price_1180, 0);
   double irsi_540 = iRSI(NULL, G_timeframe_1036, G_period_1176, G_applied_price_1180, 0);
   double irsi_548 = iRSI(NULL, G_timeframe_1032, G_period_1176, G_applied_price_1180, 0);
   double irsi_556 = iRSI(NULL, G_timeframe_1028, G_period_1176, G_applied_price_1180, 0);
   double irsi_564 = iRSI(NULL, G_timeframe_1024, G_period_1176, G_applied_price_1180, 0);
   double istochastic_572 = iStochastic(NULL, G_timeframe_1048, G_period_1208, G_period_1212, G_slowing_1216, G_ma_method_1220, 0, MODE_MAIN, 0);
   double istochastic_580 = iStochastic(NULL, G_timeframe_1044, G_period_1208, G_period_1212, G_slowing_1216, G_ma_method_1220, 0, MODE_MAIN, 0);
   double istochastic_588 = iStochastic(NULL, G_timeframe_1040, G_period_1208, G_period_1212, G_slowing_1216, G_ma_method_1220, 0, MODE_MAIN, 0);
   double istochastic_596 = iStochastic(NULL, G_timeframe_1036, G_period_1208, G_period_1212, G_slowing_1216, G_ma_method_1220, 0, MODE_MAIN, 0);
   double istochastic_604 = iStochastic(NULL, G_timeframe_1032, G_period_1208, G_period_1212, G_slowing_1216, G_ma_method_1220, 0, MODE_MAIN, 0);
   double istochastic_612 = iStochastic(NULL, G_timeframe_1028, G_period_1208, G_period_1212, G_slowing_1216, G_ma_method_1220, 0, MODE_MAIN, 0);
   double istochastic_620 = iStochastic(NULL, G_timeframe_1024, G_period_1208, G_period_1212, G_slowing_1216, G_ma_method_1220, 0, MODE_MAIN, 0);
   double icci_628 = iCCI(NULL, G_timeframe_1048, G_period_1192, G_applied_price_1196, 0);
   double icci_636 = iCCI(NULL, G_timeframe_1044, G_period_1192, G_applied_price_1196, 0);
   double icci_644 = iCCI(NULL, G_timeframe_1040, G_period_1192, G_applied_price_1196, 0);
   double icci_652 = iCCI(NULL, G_timeframe_1036, G_period_1192, G_applied_price_1196, 0);
   double icci_660 = iCCI(NULL, G_timeframe_1032, G_period_1192, G_applied_price_1196, 0);
   double icci_668 = iCCI(NULL, G_timeframe_1028, G_period_1192, G_applied_price_1196, 0);
   double icci_676 = iCCI(NULL, G_timeframe_1024, G_period_1192, G_applied_price_1196, 0);
   string text_684 = "";
   string text_692 = "";
   string text_700 = "";
   string text_708 = "";
   string text_716 = "";
   string text_724 = "";
   string text_732 = "";
   string Ls_unused_740 = "";
   string Ls_unused_748 = "";
   text_732 = "-";
   color color_756 = G_color_1240;
   text_716 = "-";
   color color_760 = G_color_1240;
   text_684 = "-";
   color color_764 = G_color_1240;
   text_724 = "-";
   color color_768 = G_color_1240;
   text_692 = "-";
   color color_772 = G_color_1240;
   text_700 = "-";
   color color_776 = G_color_1240;
   text_708 = "-";
   color color_780 = G_color_1240;
   if (irsi_516 > 50.0 && istochastic_572 > 40.0 && icci_628 > 0.0) {
      text_732 = "-";
      color_756 = G_color_1232;
   }
   if (irsi_524 > 50.0 && istochastic_580 > 40.0 && icci_636 > 0.0) {
      text_716 = "-";
      color_760 = G_color_1232;
   }
   if (irsi_532 > 50.0 && istochastic_588 > 40.0 && icci_644 > 0.0) {
      text_684 = "-";
      color_764 = G_color_1232;
   }
   if (irsi_540 > 50.0 && istochastic_596 > 40.0 && icci_652 > 0.0) {
      text_724 = "-";
      color_768 = G_color_1232;
   }
   if (irsi_548 > 50.0 && istochastic_604 > 40.0 && icci_660 > 0.0) {
      text_692 = "-";
      color_772 = G_color_1232;
   }
   if (irsi_556 > 50.0 && istochastic_612 > 40.0 && icci_668 > 0.0) {
      text_700 = "-";
      color_776 = G_color_1232;
   }
   if (irsi_564 > 50.0 && istochastic_620 > 40.0 && icci_676 > 0.0) {
      text_708 = "-";
      color_780 = G_color_1232;
   }
   if (irsi_516 < 50.0 && istochastic_572 < 60.0 && icci_628 < 0.0) {
      text_732 = "-";
      color_756 = G_color_1236;
   }
   if (irsi_524 < 50.0 && istochastic_580 < 60.0 && icci_636 < 0.0) {
      text_716 = "-";
      color_760 = G_color_1236;
   }
   if (irsi_532 < 50.0 && istochastic_588 < 60.0 && icci_644 < 0.0) {
      text_684 = "-";
      color_764 = G_color_1236;
   }
   if (irsi_540 < 50.0 && istochastic_596 < 60.0 && icci_652 < 0.0) {
      text_724 = "-";
      color_768 = G_color_1236;
   }
   if (irsi_548 < 50.0 && istochastic_604 < 60.0 && icci_660 < 0.0) {
      text_692 = "-";
      color_772 = G_color_1236;
   }
   if (irsi_556 < 50.0 && istochastic_612 < 60.0 && icci_668 < 0.0) {
      text_700 = "-";
      color_776 = G_color_1236;
   }
   if (irsi_564 < 50.0 && istochastic_620 < 60.0 && icci_676 < 0.0) {
      text_708 = "-";
      color_780 = G_color_1236;
   }

   double ima_784 = iMA(Symbol(), G_timeframe_1024, G_period_1252, 0, G_ma_method_1260, G_applied_price_1264, 0);
   double ima_792 = iMA(Symbol(), G_timeframe_1024, G_period_1256, 0, G_ma_method_1260, G_applied_price_1264, 0);
   double ima_800 = iMA(Symbol(), G_timeframe_1028, G_period_1252, 0, G_ma_method_1260, G_applied_price_1264, 0);
   double ima_808 = iMA(Symbol(), G_timeframe_1028, G_period_1256, 0, G_ma_method_1260, G_applied_price_1264, 0);
   double ima_816 = iMA(Symbol(), G_timeframe_1032, G_period_1252, 0, G_ma_method_1260, G_applied_price_1264, 0);
   double ima_824 = iMA(Symbol(), G_timeframe_1032, G_period_1256, 0, G_ma_method_1260, G_applied_price_1264, 0);
   double ima_832 = iMA(Symbol(), G_timeframe_1036, G_period_1252, 0, G_ma_method_1260, G_applied_price_1264, 0);
   double ima_840 = iMA(Symbol(), G_timeframe_1036, G_period_1256, 0, G_ma_method_1260, G_applied_price_1264, 0);
   double ima_848 = iMA(Symbol(), G_timeframe_1040, G_period_1252, 0, G_ma_method_1260, G_applied_price_1264, 0);
   double ima_856 = iMA(Symbol(), G_timeframe_1040, G_period_1256, 0, G_ma_method_1260, G_applied_price_1264, 0);
   double ima_864 = iMA(Symbol(), G_timeframe_1044, G_period_1252, 0, G_ma_method_1260, G_applied_price_1264, 0);
   double ima_872 = iMA(Symbol(), G_timeframe_1044, G_period_1256, 0, G_ma_method_1260, G_applied_price_1264, 0);
   double ima_880 = iMA(Symbol(), G_timeframe_1048, G_period_1252, 0, G_ma_method_1260, G_applied_price_1264, 0);
   double ima_888 = iMA(Symbol(), G_timeframe_1048, G_period_1256, 0, G_ma_method_1260, G_applied_price_1264, 0);
   string text_896 = "";
   string text_904 = "";
   string text_912 = "";
   string text_920 = "";
   string text_928 = "";
   string text_936 = "";
   string text_944 = "";
   string Ls_unused_952 = "";
   string Ls_unused_960 = "";
   if (ima_784 > ima_792) {
      text_896 = "-";
      color_68 = G_color_1276;
   }
   if (ima_784 <= ima_792) {
      text_896 = "-";
      color_68 = G_color_1280;
   }
   if (ima_800 > ima_808) {
      text_904 = "-";
      color_72 = G_color_1276;
   }
   if (ima_800 <= ima_808) {
      text_904 = "-";
      color_72 = G_color_1280;
   }
   if (ima_816 > ima_824) {
      text_912 = "-";
      color_76 = G_color_1276;
   }
   if (ima_816 <= ima_824) {
      text_912 = "-";
      color_76 = G_color_1280;
   }
   if (ima_832 > ima_840) {
      text_920 = "-";
      color_80 = G_color_1276;
   }
   if (ima_832 <= ima_840) {
      text_920 = "-";
      color_80 = G_color_1280;
   }
   if (ima_848 > ima_856) {
      text_928 = "-";
      color_84 = G_color_1276;
   }
   if (ima_848 <= ima_856) {
      text_928 = "-";
      color_84 = G_color_1280;
   }
   if (ima_864 > ima_872) {
      text_936 = "-";
      color_88 = G_color_1276;
   }
   if (ima_864 <= ima_872) {
      text_936 = "-";
      color_88 = G_color_1280;
   }
   if (ima_880 > ima_888) {
      text_944 = "-";
      color_92 = G_color_1276;
   }
   if (ima_880 <= ima_888) {
      text_944 = "-";
      color_92 = G_color_1280;
   }

   double Ld_968 = NormalizeDouble(MarketInfo(Symbol(), MODE_BID), Digits);
   double ima_976 = iMA(Symbol(), PERIOD_M1, 1, 0, MODE_EMA, PRICE_CLOSE, 1);
   string Ls_unused_984 = "";
   if (ima_976 > Ld_968) {
      Ls_unused_984 = "";
      color_96 = G_color_1120;
   }
   if (ima_976 < Ld_968) {
      Ls_unused_984 = "";
      color_96 = G_color_1116;
   }
   if (ima_976 == Ld_968) {
      Ls_unused_984 = "";
      color_96 = G_color_1124;
   }

   if (Gi_1076 == FALSE) {
      if (Gi_1068 == TRUE) {

      }
   }
   if (Gi_1076 == TRUE) {
      if (Gi_1068 == TRUE) {

      }
   }
   int Li_992 = 0;
   int Li_996 = 0;
   int Li_1000 = 0;
   int Li_1004 = 0;
   int Li_1008 = 0;
   int Li_1012 = 0;
   Li_992 = (iHigh(NULL, PERIOD_D1, 1) - iLow(NULL, PERIOD_D1, 1)) / Point;
   for (Li_1012 = 1; Li_1012 <= 5; Li_1012++) Li_996 = Li_996 + (iHigh(NULL, PERIOD_D1, Li_1012) - iLow(NULL, PERIOD_D1, Li_1012)) / Point;
   for (Li_1012 = 1; Li_1012 <= 10; Li_1012++) Li_1000 = Li_1000 + (iHigh(NULL, PERIOD_D1, Li_1012) - iLow(NULL, PERIOD_D1, Li_1012)) / Point;
   for (Li_1012 = 1; Li_1012 <= 20; Li_1012++) Li_1004 = Li_1004 + (iHigh(NULL, PERIOD_D1, Li_1012) - iLow(NULL, PERIOD_D1, Li_1012)) / Point;
   Li_996 /= 5;
   Li_1000 /= 10;
   Li_1004 /= 20;
   Li_1008 = (Li_992 + Li_996 + Li_1000 + Li_1004) / 4;
   string Ls_unused_1016 = "";
   string Ls_unused_1024 = "";
   string dbl2str_1032 = "";
   string dbl2str_1040 = "";
   string dbl2str_1048 = "";
   string dbl2str_1056 = "";
   string Ls_unused_1064 = "";
   string Ls_unused_1072 = "";
   string Ls_1080 = "";
   double iopen_1088 = iOpen(NULL, PERIOD_D1, 0);
   double iclose_1096 = iClose(NULL, PERIOD_D1, 0);
   double Ld_1104 = (Ask - Bid) / Point;
   double ihigh_1112 = iHigh(NULL, PERIOD_D1, 0);
   double ilow_1120 = iLow(NULL, PERIOD_D1, 0);
   dbl2str_1040 = DoubleToStr((iclose_1096 - iopen_1088) / Point, 0);
   dbl2str_1032 = DoubleToStr(Ld_1104, Digits - 4);
   dbl2str_1048 = DoubleToStr(Li_1008, Digits - 4);
   Ls_1080 = (iHigh(NULL, PERIOD_D1, 1) - iLow(NULL, PERIOD_D1, 1)) / Point;
   dbl2str_1056 = DoubleToStr((ihigh_1112 - ilow_1120) / Point, 0);
   if (iclose_1096 >= iopen_1088) {
      Ls_unused_1064 = "-";
      color_108 = G_color_1100;
   }
   if (iclose_1096 < iopen_1088) {
      Ls_unused_1064 = "-";
      color_108 = G_color_1104;
   }
   if (dbl2str_1048 >= Ls_1080) {
      Ls_unused_1072 = "-";
      Li_unused_112 = Gi_1108;
   }
   if (dbl2str_1048 < Ls_1080) {
      Ls_unused_1072 = "-";
      Li_unused_112 = Gi_1112;
   }

   double Ld_1160 = LotExponent;
   int Li_1168 = PairDigit;
   Ld_1192 = Lots;
   if (Gi_372 == Time[0]) return (0);
   Gi_372 = Time[0];
   double Ld_1200 = f0_31();
   Gi_396 = f0_4();
   if (Gi_396 == 0) Gi_360 = FALSE;
   for (G_pos_392 = OrdersTotal() - 1; G_pos_392 >= 0; G_pos_392--) {
      TicketOrder = OrderSelect(G_pos_392, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
         if (OrderType() == OP_BUY) {
            Gi_412 = TRUE;
            Gi_416 = FALSE;
            break;
         }
      }
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
         if (OrderType() == OP_SELL) {
            Gi_412 = FALSE;
            Gi_416 = TRUE;
            break;
         }
      }
   }
   if (Gi_396 > 0 && Gi_396 <= MaxTrades) {
      RefreshRates();
      Gd_336 = f0_32();
      Gd_344 = f0_20();
      if (Gi_412 && Gd_336 - Ask >= PipStep * Point) Gi_408 = TRUE;
      if (Gi_416 && Bid - Gd_344 >= PipStep * Point) Gi_408 = TRUE;
   }
   if (Gi_396 < 1) {
      Gi_416 = FALSE;
      Gi_412 = FALSE;
      Gi_408 = TRUE;
   }
   if (Gi_408) {
      Gd_336 = f0_32();
      Gd_344 = f0_20();
      if (Gi_416) {
         Gi_380 = Gi_396;
         Gd_384 = NormalizeDouble(Ld_1192 * MathPow(Ld_1160, Gi_380), Li_1168);
         RefreshRates();
         Gd_344 = f0_20();
         Gi_408 = FALSE;
         Gi_424 = TRUE;
      } else {
         if (Gi_412) {
            Gi_380 = Gi_396;
            Gd_384 = NormalizeDouble(Ld_1192 * MathPow(Ld_1160, Gi_380), Li_1168);
            Gd_336 = f0_32();
            Gi_408 = FALSE;
            Gi_424 = TRUE;
         }
      }
   }
   if (Gi_408 && Gi_396 < 1) {
      ihigh_1128 = iHigh(Symbol(), 0, 1);
      ilow_1136 = iLow(Symbol(), 0, 2);
      G_bid_320 = Bid;
      G_ask_328 = Ask;
      if ((!Gi_416) && !Gi_412) {
         Gi_380 = Gi_396;
         Gd_384 = NormalizeDouble(Ld_1192 * MathPow(Ld_1160, Gi_380), Li_1168);
         if (ihigh_1128 > ilow_1136) {
            if (iRSI(NULL, PERIOD_H1, 14, PRICE_CLOSE, 1) > 30.0) {
               Gd_336 = f0_32();
               Gi_424 = TRUE;
            }
         } else {
            if (iRSI(NULL, PERIOD_H1, 14, PRICE_CLOSE, 1) < 70.0) {
               Gd_344 = f0_20();
               Gi_424 = TRUE;
            }
         }
         Gi_408 = FALSE;
      }
   }
   Gi_396 = f0_4();
   G_price_312 = 0;
   double Ld_1208 = 0;
   for (G_pos_392 = OrdersTotal() - 1; G_pos_392 >= 0; G_pos_392--) {
      TicketOrder = OrderSelect(G_pos_392, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
         if (OrderType() == OP_BUY || OrderType() == OP_SELL) {
            G_price_312 += OrderOpenPrice() * OrderLots();
            Ld_1208 += OrderLots();
         }
      }
   }
   if (Gi_396 > 0) G_price_312 = NormalizeDouble(G_price_312 / Ld_1208, Digits);
   if (Gi_424) {
      for (G_pos_392 = OrdersTotal() - 1; G_pos_392 >= 0; G_pos_392--) {
         TicketOrder = OrderSelect(G_pos_392, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
            if (OrderType() == OP_BUY) {
               G_price_280 = G_price_312 + TakeProfit * Point;
               Gd_unused_296 = G_price_280;
               Gi_360 = TRUE;
            }
         }
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
            if (OrderType() == OP_SELL) {
               G_price_280 = G_price_312 - TakeProfit * Point;
               Gd_unused_304 = G_price_280;
               Gi_360 = TRUE;
            }
         }
      }
   }
   if (Gi_424) {
      if (Gi_360 == TRUE) {
         for (G_pos_392 = OrdersTotal() - 1; G_pos_392 >= 0; G_pos_392--) {
            TicketOrder = OrderSelect(G_pos_392, SELECT_BY_POS, MODE_TRADES);
            if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) TicketOrder = OrderModify(OrderTicket(), G_price_312, OrderStopLoss(), G_price_280, 0, Yellow);
            Gi_424 = FALSE;
         }
      }
   }
   double Ld_1216 = LotExponent;
   int Li_1224 = PairDigit;
   Ld_1248 = Lots;
   if (Gi_532) {
      if (TimeCurrent() >= Gi_660) {
         f0_18();
         Print("Closed All due to TimeOut");
      }
   }
   if (Gi_656 != Time[0]) {
      Gi_656 = Time[0];
      Ld_1256 = f0_29();
      Gi_680 = f0_5();
      if (Gi_680 == 0) Gi_644 = FALSE;
      for (G_pos_676 = OrdersTotal() - 1; G_pos_676 >= 0; G_pos_676--) {
         TicketOrder = OrderSelect(G_pos_676, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != G_magic_176_15) continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == G_magic_176_15) {
            if (OrderType() == OP_BUY) {
               Gi_696 = TRUE;
               Gi_700 = FALSE;
               break;
            }
         }
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == G_magic_176_15) {
            if (OrderType() == OP_SELL) {
               Gi_696 = FALSE;
               Gi_700 = TRUE;
               break;
            }
         }
      }
      if (Gi_680 > 0 && Gi_680 <= MaxTrades) {
         RefreshRates();
         Gd_620 = f0_36();
         Gd_628 = f0_28();
         if (Gi_696 && Gd_620 - Ask >= PipStep * Point) Gi_692 = TRUE;
         if (Gi_700 && Bid - Gd_628 >= PipStep * Point) Gi_692 = TRUE;
      }
      if (Gi_680 < 1) {
         Gi_700 = FALSE;
         Gi_696 = FALSE;
         Gi_692 = TRUE;
         Gd_572 = AccountEquity();
      }
      if (Gi_692) {
         Gd_620 = f0_36();
         Gd_628 = f0_28();
         if (Gi_700) {
            Gi_664 = Gi_680;
            Gd_668 = NormalizeDouble(Ld_1248 * MathPow(Ld_1216, Gi_664), Li_1224);
            RefreshRates();
            Gi_704 = f0_2(1, Gd_668, Bid, slip_15, Ask, 0, 0, EAName + "-" + Symbol() + "-" + Gi_664, G_magic_176_15, 0, HotPink);
            if (Gi_704 < 0) {
               Print("Error: ", GetLastError());
               return (0);
            }
            Gd_628 = f0_28();
            Gi_692 = FALSE;
            Gi_708 = TRUE;
         } else {
            if (Gi_696) {
               Gi_664 = Gi_680;
               Gd_668 = NormalizeDouble(Ld_1248 * MathPow(Ld_1216, Gi_664), Li_1224);
               Gi_704 = f0_2(0, Gd_668, Ask, slip_15, Bid, 0, 0, EAName + "-" + Symbol() + "-" + Gi_664, G_magic_176_15, 0, Lime);
               if (Gi_704 < 0) {
                  Print("Error: ", GetLastError());
                  return (0);
               }
               Gd_620 = f0_36();
               Gi_692 = FALSE;
               Gi_708 = TRUE;
            }
         }
      }
   }
   if (G_datetime_728 != iTime(NULL, G_timeframe_496, 0)) {
      Li_1264 = OrdersTotal();
      count_1268 = 0;
      for (int Li_1272 = Li_1264; Li_1272 >= 1; Li_1272--) {
         TicketOrder = OrderSelect(Li_1272 - 1, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != G_magic_176_15) continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == G_magic_176_15) count_1268++;
      }
      if (Li_1264 == 0 || count_1268 < 1) {
         iclose_1144 = iClose(Symbol(), 0, 2);
         iclose_1152 = iClose(Symbol(), 0, 1);
         G_bid_604 = Bid;
         G_ask_612 = Ask;
         Gi_664 = Gi_680;
         Gd_668 = Ld_1248;
         if (iclose_1144 > iclose_1152) {
            Gi_704 = f0_2(1, Gd_668, G_bid_604, slip_15, G_bid_604, 0, 0, EAName + "-" + Symbol() + "-" + Gi_664, G_magic_176_15, 0, HotPink);
            if (Gi_704 < 0) {
               Print("Error: ", GetLastError());
               return (0);
            }
            Gd_620 = f0_36();
            Gi_708 = TRUE;
         } else {
            Gi_704 = f0_2(0, Gd_668, G_ask_612, slip_15, G_ask_612, 0, 0, EAName + "-" + Symbol() + "-" + Gi_664, G_magic_176_15, 0, Lime);
            if (Gi_704 < 0) {
               Print("Error: ", GetLastError());
               return (0);
            }
            Gd_628 = f0_28();
            Gi_708 = TRUE;
         }
         if (Gi_704 > 0) Gi_660 = TimeCurrent() + 60.0 * (60.0 * Gd_536);
         Gi_692 = FALSE;
      }
      G_datetime_728 = iTime(NULL, G_timeframe_496, 0);
   }
   Gi_680 = f0_5();
   G_price_596 = 0;
   double Ld_1276 = 0;
   for (G_pos_676 = OrdersTotal() - 1; G_pos_676 >= 0; G_pos_676--) {
      TicketOrder = OrderSelect(G_pos_676, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != G_magic_176_15) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == G_magic_176_15) {
         if (OrderType() == OP_BUY || OrderType() == OP_SELL) {
            G_price_596 += OrderOpenPrice() * OrderLots();
            Ld_1276 += OrderLots();
         }
      }
   }
   if (Gi_680 > 0) G_price_596 = NormalizeDouble(G_price_596 / Ld_1276, Digits);
   if (Gi_708) {
      for (G_pos_676 = OrdersTotal() - 1; G_pos_676 >= 0; G_pos_676--) {
         TicketOrder = OrderSelect(G_pos_676, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != G_magic_176_15) continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == G_magic_176_15) {
            if (OrderType() == OP_BUY) {
               G_price_564 = G_price_596 + TakeProfit * Point;
               Gd_unused_580 = G_price_564;
               Gd_684 = G_price_596 - G_pips_508 * Point;
               Gi_644 = TRUE;
            }
         }
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == G_magic_176_15) {
            if (OrderType() == OP_SELL) {
               G_price_564 = G_price_596 - TakeProfit * Point;
               Gd_unused_588 = G_price_564;
               Gd_684 = G_price_596 + G_pips_508 * Point;
               Gi_644 = TRUE;
            }
         }
      }
   }
   if (Gi_708) {
      if (Gi_644 == TRUE) {
         for (G_pos_676 = OrdersTotal() - 1; G_pos_676 >= 0; G_pos_676--) {
            TicketOrder = OrderSelect(G_pos_676, SELECT_BY_POS, MODE_TRADES);
            if (OrderSymbol() != Symbol() || OrderMagicNumber() != G_magic_176_15) continue;
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == G_magic_176_15) TicketOrder = OrderModify(OrderTicket(), G_price_596, OrderStopLoss(), G_price_564, 0, Yellow);
            Gi_708 = FALSE;
         }
      }
   }
   Ld_1316 = Lots;
   if (Gi_816) {
      if (TimeCurrent() >= Gi_944) {
         f0_0();
         Print("Closed All due to TimeOut");
      }
   }
   if (Gi_940 != Time[0]) {
      Gi_940 = Time[0];
      Ld_1324 = f0_8();
      Gi_964 = f0_12();
      if (Gi_964 == 0) Gi_928 = FALSE;
      for (G_pos_960 = OrdersTotal() - 1; G_pos_960 >= 0; G_pos_960--) {
         TicketOrder = OrderSelect(G_pos_960, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != G_magic_176_16) continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == G_magic_176_16) {
            if (OrderType() == OP_BUY) {
               Gi_980 = TRUE;
               Gi_984 = FALSE;
               break;
            }
         }
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == G_magic_176_16) {
            if (OrderType() == OP_SELL) {
               Gi_980 = FALSE;
               Gi_984 = TRUE;
               break;
            }
         }
      }
      if (Gi_964 > 0 && Gi_964 <= MaxTrades) {
         RefreshRates();
         Gd_904 = f0_17();
         Gd_912 = f0_27();
         if (Gi_980 && Gd_904 - Ask >= PipStep * Point) Gi_976 = TRUE;
         if (Gi_984 && Bid - Gd_912 >= PipStep * Point) Gi_976 = TRUE;
      }
      if (Gi_964 < 1) {
         Gi_984 = FALSE;
         Gi_980 = FALSE;
         Gd_856 = AccountEquity();
      }
      if (Gi_976) {
         Gd_904 = f0_17();
         Gd_912 = f0_27();
         if (Gi_984) {
            Gi_948 = Gi_964;
            Gd_952 = NormalizeDouble(Ld_1316 * MathPow(LotExponent, Gi_948), PairDigit);
            RefreshRates();
            Gd_912 = f0_27();
            Gi_976 = FALSE;
            Gi_992 = TRUE;
         } else {
            if (Gi_980) {
               Gi_948 = Gi_964;
               Gd_952 = NormalizeDouble(Ld_1316 * MathPow(LotExponent, Gi_948), PairDigit);
               Gd_904 = f0_17();
               Gi_976 = FALSE;
               Gi_992 = TRUE;
            }
         }
      }
   }
   if (G_datetime_1012 != iTime(NULL, G_timeframe_784, 0)) {
      Li_1332 = OrdersTotal();
      count_1336 = 0;
      for (int Li_1340 = Li_1332; Li_1340 >= 1; Li_1340--) {
         TicketOrder = OrderSelect(Li_1340 - 1, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != G_magic_176_16) continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == G_magic_176_16) count_1336++;
      }
      if (Li_1332 == 0 || count_1336 < 1) {
         iclose_1144 = iClose(Symbol(), 0, 2);
         iclose_1152 = iClose(Symbol(), 0, 1);
         G_bid_888 = Bid;
         G_ask_896 = Ask;
         Gi_948 = Gi_964;
         Gd_952 = Ld_1316;
         if (iclose_1144 > iclose_1152) {
            if (iRSI(NULL, PERIOD_H1, 14, PRICE_CLOSE, 1) > 30.0) {
               Gd_904 = f0_17();
               Gi_992 = TRUE;
            }
         } else {
            if (iRSI(NULL, PERIOD_H1, 14, PRICE_CLOSE, 1) < 70.0) {
               Gd_912 = f0_27();
               Gi_992 = TRUE;
            }
         }
         if (Gi_988 > 0) Gi_944 = TimeCurrent() + 60.0 * (60.0 * Gd_820);
         Gi_976 = FALSE;
      }
      G_datetime_1012 = iTime(NULL, G_timeframe_784, 0);
   }
   Gi_964 = f0_12();
   G_price_880 = 0;
   double Ld_1344 = 0;
   for (G_pos_960 = OrdersTotal() - 1; G_pos_960 >= 0; G_pos_960--) {
      TicketOrder = OrderSelect(G_pos_960, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != G_magic_176_16) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == G_magic_176_16) {
         if (OrderType() == OP_BUY || OrderType() == OP_SELL) {
            G_price_880 += OrderOpenPrice() * OrderLots();
            Ld_1344 += OrderLots();
         }
      }
   }
   if (Gi_964 > 0) G_price_880 = NormalizeDouble(G_price_880 / Ld_1344, Digits);
   if (Gi_992) {
      for (G_pos_960 = OrdersTotal() - 1; G_pos_960 >= 0; G_pos_960--) {
         TicketOrder = OrderSelect(G_pos_960, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != G_magic_176_16) continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == G_magic_176_16) {
            if (OrderType() == OP_BUY) {
               G_price_848 = G_price_880 + TakeProfit * Point;
               Gd_unused_864 = G_price_848;
               Gd_968 = G_price_880 - G_pips_792 * Point;
               Gi_928 = TRUE;
            }
         }
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == G_magic_176_16) {
            if (OrderType() == OP_SELL) {
               G_price_848 = G_price_880 - TakeProfit * Point;
               Gd_unused_872 = G_price_848;
               Gd_968 = G_price_880 + G_pips_792 * Point;
               Gi_928 = TRUE;
            }
         }
      }
   }
   if (Gi_992) {
      if (Gi_928 == TRUE) {
         for (G_pos_960 = OrdersTotal() - 1; G_pos_960 >= 0; G_pos_960--) {
            TicketOrder = TicketOrder = OrderSelect(G_pos_960, SELECT_BY_POS, MODE_TRADES);
            if (OrderSymbol() != Symbol() || OrderMagicNumber() != G_magic_176_16) continue;
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == G_magic_176_16) TicketOrder = OrderModify(OrderTicket(), G_price_880, OrderStopLoss(), G_price_848, 0, Yellow);
            Gi_992 = FALSE;
         }
      }
   }
   return (0);
}

int f0_4() {
   int count_0 = 0;
   for (int pos_4 = OrdersTotal() - 1; pos_4 >= 0; pos_4--) {
      TicketOrder = OrderSelect(pos_4, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         if (OrderType() == OP_SELL || OrderType() == OP_BUY) count_0++;
   }
   return (count_0);
}

void f0_24() {
   for (int pos_0 = OrdersTotal() - 1; pos_0 >= 0; pos_0--) {
      TicketOrder = OrderSelect(pos_0, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol()) {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
            if (OrderType() == OP_BUY) TicketOrder = OrderClose(OrderTicket(), OrderLots(), Bid, SlipPage, Blue);
            if (OrderType() == OP_SELL) TicketOrder = OrderClose(OrderTicket(), OrderLots(), Ask, SlipPage, Red);
         }
         Sleep(1000);
      }
   }
}

int f0_3(int Ai_0, double A_lots_4, double A_price_12, int A_slippage_20, double Ad_24, int Ai_32, int Ai_36, string A_comment_40, int A_magic_48, int A_datetime_52, color A_color_56) {
   int ticket_60 = 0;
   int error_64 = 0;
   int count_68 = 0;
   int Li_72 = 100;
   switch (Ai_0) {
   case 2:
      for (count_68 = 0; count_68 < Li_72; count_68++) {
         ticket_60 = OrderSend(Symbol(), OP_BUYLIMIT, A_lots_4, A_price_12, A_slippage_20, f0_22(Ad_24, Ai_32), f0_19(A_price_12, Ai_36), A_comment_40, A_magic_48, A_datetime_52,
            A_color_56);
         error_64 = GetLastError();
         if (error_64 == 0 /* NO_ERROR */ ) break;
         if (!((error_64 == 4 /* SERVER_BUSY */ || error_64 == 137 /* BROKER_BUSY */ || error_64 == 146 /* TRADE_CONTEXT_BUSY */ || error_64 == 136 /* OFF_QUOTES */ ))) break;
         Sleep(1000);
      }
      break;
   case 4:
      for (count_68 = 0; count_68 < Li_72; count_68++) {
         ticket_60 = OrderSend(Symbol(), OP_BUYSTOP, A_lots_4, A_price_12, A_slippage_20, f0_22(Ad_24, Ai_32), f0_19(A_price_12, Ai_36), A_comment_40, A_magic_48, A_datetime_52,
            A_color_56);
         error_64 = GetLastError();
         if (error_64 == 0 /* NO_ERROR */ ) break;
         if (!((error_64 == 4 /* SERVER_BUSY */ || error_64 == 137 /* BROKER_BUSY */ || error_64 == 146 /* TRADE_CONTEXT_BUSY */ || error_64 == 136 /* OFF_QUOTES */ ))) break;
         Sleep(5000);
      }
      break;
   case 0:
      for (count_68 = 0; count_68 < Li_72; count_68++) {
         RefreshRates();
         ticket_60 = OrderSend(Symbol(), OP_BUY, A_lots_4, Ask, A_slippage_20, f0_22(Bid, Ai_32), f0_19(Ask, Ai_36), A_comment_40, A_magic_48, A_datetime_52, A_color_56);
         //PlaySound("jaipong.wav");
         error_64 = GetLastError();
         if (error_64 == 0 /* NO_ERROR */ ) break;
         if (!((error_64 == 4 /* SERVER_BUSY */ || error_64 == 137 /* BROKER_BUSY */ || error_64 == 146 /* TRADE_CONTEXT_BUSY */ || error_64 == 136 /* OFF_QUOTES */ ))) break;
         Sleep(5000);
      }
      break;
   case 3:
      for (count_68 = 0; count_68 < Li_72; count_68++) {
         ticket_60 = OrderSend(Symbol(), OP_SELLLIMIT, A_lots_4, A_price_12, A_slippage_20, f0_11(Ad_24, Ai_32), f0_1(A_price_12, Ai_36), A_comment_40, A_magic_48, A_datetime_52,
            A_color_56);
         error_64 = GetLastError();
         if (error_64 == 0 /* NO_ERROR */ ) break;
         if (!((error_64 == 4 /* SERVER_BUSY */ || error_64 == 137 /* BROKER_BUSY */ || error_64 == 146 /* TRADE_CONTEXT_BUSY */ || error_64 == 136 /* OFF_QUOTES */ ))) break;
         Sleep(5000);
      }
      break;
   case 5:
      for (count_68 = 0; count_68 < Li_72; count_68++) {
         ticket_60 = OrderSend(Symbol(), OP_SELLSTOP, A_lots_4, A_price_12, A_slippage_20, f0_11(Ad_24, Ai_32), f0_1(A_price_12, Ai_36), A_comment_40, A_magic_48, A_datetime_52,
            A_color_56);
         error_64 = GetLastError();
         if (error_64 == 0 /* NO_ERROR */ ) break;
         if (!((error_64 == 4 /* SERVER_BUSY */ || error_64 == 137 /* BROKER_BUSY */ || error_64 == 146 /* TRADE_CONTEXT_BUSY */ || error_64 == 136 /* OFF_QUOTES */ ))) break;
         Sleep(5000);
      }
      break;
   case 1:
      for (count_68 = 0; count_68 < Li_72; count_68++) {
         ticket_60 = OrderSend(Symbol(), OP_SELL, A_lots_4, Bid, A_slippage_20, f0_11(Ask, Ai_32), f0_1(Bid, Ai_36), A_comment_40, A_magic_48, A_datetime_52, A_color_56);
         //PlaySound("jaipong.wav");
         error_64 = GetLastError();
         if (error_64 == 0 /* NO_ERROR */ ) break;
         if (!((error_64 == 4 /* SERVER_BUSY */ || error_64 == 137 /* BROKER_BUSY */ || error_64 == 146 /* TRADE_CONTEXT_BUSY */ || error_64 == 136 /* OFF_QUOTES */ ))) break;
         Sleep(5000);
      }
   }
   return (ticket_60);
}

double f0_22(double Ad_0, int Ai_8) {
   if (Ai_8 == 0) return (0);
   return (Ad_0 - Ai_8 * Point);
}

double f0_11(double Ad_0, int Ai_8) {
   if (Ai_8 == 0) return (0);
   return (Ad_0 + Ai_8 * Point);
}

double f0_19(double Ad_0, int Ai_8) {
   if (Ai_8 == 0) return (0);
   return (Ad_0 + Ai_8 * Point);
}

double f0_1(double Ad_0, int Ai_8) {
   if (Ai_8 == 0) return (0);
   return (Ad_0 - Ai_8 * Point);
}

double f0_31() {
   double Ld_ret_0 = 0;
   for (G_pos_392 = OrdersTotal() - 1; G_pos_392 >= 0; G_pos_392--) {
      TicketOrder = OrderSelect(G_pos_392, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         if (OrderType() == OP_BUY || OrderType() == OP_SELL) Ld_ret_0 += OrderProfit();
   }
   return (Ld_ret_0);
}

void f0_35(int Ai_0, int Ai_4, double A_price_8) {
   int Li_16;
   double order_stoploss_20;
   double price_28;
   if (Ai_4 != 0) {
      for (int pos_36 = OrdersTotal() - 1; pos_36 >= 0; pos_36--) {
         if (OrderSelect(pos_36, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
            if (OrderSymbol() == Symbol() || OrderMagicNumber() == MagicNumber) {
               if (OrderType() == OP_BUY) {
                  Li_16 = NormalizeDouble((Bid - A_price_8) / Point, 0);
                  if (Li_16 < Ai_0) continue;
                  order_stoploss_20 = OrderStopLoss();
                  price_28 = Bid - Ai_4 * Point;
                  if (order_stoploss_20 == 0.0 || (order_stoploss_20 != 0.0 && price_28 > order_stoploss_20)) TicketOrder = OrderModify(OrderTicket(), A_price_8, price_28, OrderTakeProfit(), 0, Aqua);
               }
               if (OrderType() == OP_SELL) {
                  Li_16 = NormalizeDouble((A_price_8 - Ask) / Point, 0);
                  if (Li_16 < Ai_0) continue;
                  order_stoploss_20 = OrderStopLoss();
                  price_28 = Ask + Ai_4 * Point;
                  if (order_stoploss_20 == 0.0 || (order_stoploss_20 != 0.0 && price_28 < order_stoploss_20)) TicketOrder = OrderModify(OrderTicket(), A_price_8, price_28, OrderTakeProfit(), 0, Red);
               }
            }
            Sleep(1000);
         }
      }
   }
}

double f0_7() {
   if (f0_4() == 0) Gd_428 = AccountEquity();
   if (Gd_428 < Gd_436) Gd_428 = Gd_436;
   else Gd_428 = AccountEquity();
   Gd_436 = AccountEquity();
   return (Gd_428);
}

double f0_32() {
   double order_open_price_0;
   int ticket_8;
   double Ld_unused_12 = 0;
   int ticket_20 = 0;
   for (int pos_24 = OrdersTotal() - 1; pos_24 >= 0; pos_24--) {
      TicketOrder = OrderSelect(pos_24, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber && OrderType() == OP_BUY) {
         ticket_8 = OrderTicket();
         if (ticket_8 > ticket_20) {
            order_open_price_0 = OrderOpenPrice();
            Ld_unused_12 = order_open_price_0;
            ticket_20 = ticket_8;
         }
      }
   }
   return (order_open_price_0);
}

double f0_20() {
   double order_open_price_0;
   int ticket_8;
   double Ld_unused_12 = 0;
   int ticket_20 = 0;
   for (int pos_24 = OrdersTotal() - 1; pos_24 >= 0; pos_24--) {
      TicketOrder = OrderSelect(pos_24, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber && OrderType() == OP_SELL) {
         ticket_8 = OrderTicket();
         if (ticket_8 > ticket_20) {
            order_open_price_0 = OrderOpenPrice();
            Ld_unused_12 = order_open_price_0;
            ticket_20 = ticket_8;
         }
      }
   }
   return (order_open_price_0);
}

int f0_5() {
   int count_0 = 0;
   for (int pos_4 = OrdersTotal() - 1; pos_4 >= 0; pos_4--) {
      TicketOrder = OrderSelect(pos_4, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != G_magic_176_15) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == G_magic_176_15)
         if (OrderType() == OP_SELL || OrderType() == OP_BUY) count_0++;
   }
   return (count_0);
}

void f0_18() {
   for (int pos_0 = OrdersTotal() - 1; pos_0 >= 0; pos_0--) {
      TicketOrder = OrderSelect(pos_0, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol()) {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == G_magic_176_15) {
            if (OrderType() == OP_BUY) TicketOrder = OrderClose(OrderTicket(), OrderLots(), Bid, slip_15, Blue);
            if (OrderType() == OP_SELL) TicketOrder = OrderClose(OrderTicket(), OrderLots(), Ask, slip_15, Red);
         }
         Sleep(1000);
      }
   }
}

int f0_2(int Ai_0, double A_lots_4, double A_price_12, int A_slippage_20, double Ad_24, int Ai_32, int Ai_36, string A_comment_40, int A_magic_48, int A_datetime_52, color A_color_56) {
   int ticket_60 = 0;
   int error_64 = 0;
   int count_68 = 0;
   int Li_72 = 100;
   switch (Ai_0) {
   case 2:
      for (count_68 = 0; count_68 < Li_72; count_68++) {
         ticket_60 = OrderSend(Symbol(), OP_BUYLIMIT, A_lots_4, A_price_12, A_slippage_20, f0_13(Ad_24, Ai_32), f0_25(A_price_12, Ai_36), A_comment_40, A_magic_48, A_datetime_52,
            A_color_56);
         error_64 = GetLastError();
         if (error_64 == 0 /* NO_ERROR */ ) break;
         if (!((error_64 == 4 /* SERVER_BUSY */ || error_64 == 137 /* BROKER_BUSY */ || error_64 == 146 /* TRADE_CONTEXT_BUSY */ || error_64 == 136 /* OFF_QUOTES */ ))) break;
         Sleep(1000);
      }
      break;
   case 4:
      for (count_68 = 0; count_68 < Li_72; count_68++) {
         ticket_60 = OrderSend(Symbol(), OP_BUYSTOP, A_lots_4, A_price_12, A_slippage_20, f0_13(Ad_24, Ai_32), f0_25(A_price_12, Ai_36), A_comment_40, A_magic_48, A_datetime_52,
            A_color_56);
         error_64 = GetLastError();
         if (error_64 == 0 /* NO_ERROR */ ) break;
         if (!((error_64 == 4 /* SERVER_BUSY */ || error_64 == 137 /* BROKER_BUSY */ || error_64 == 146 /* TRADE_CONTEXT_BUSY */ || error_64 == 136 /* OFF_QUOTES */ ))) break;
         Sleep(5000);
      }
      break;
   case 0:
      for (count_68 = 0; count_68 < Li_72; count_68++) {
         RefreshRates();
         ticket_60 = OrderSend(Symbol(), OP_BUY, A_lots_4, Ask, A_slippage_20, f0_13(Bid, Ai_32), f0_25(Ask, Ai_36), A_comment_40, A_magic_48, A_datetime_52, A_color_56);
         //PlaySound("keroncong.wav");
         error_64 = GetLastError();
         if (error_64 == 0 /* NO_ERROR */ ) break;
         if (!((error_64 == 4 /* SERVER_BUSY */ || error_64 == 137 /* BROKER_BUSY */ || error_64 == 146 /* TRADE_CONTEXT_BUSY */ || error_64 == 136 /* OFF_QUOTES */ ))) break;
         Sleep(5000);
      }
      break;
   case 3:
      for (count_68 = 0; count_68 < Li_72; count_68++) {
         ticket_60 = OrderSend(Symbol(), OP_SELLLIMIT, A_lots_4, A_price_12, A_slippage_20, f0_33(Ad_24, Ai_32), f0_26(A_price_12, Ai_36), A_comment_40, A_magic_48, A_datetime_52,
            A_color_56);
         error_64 = GetLastError();
         if (error_64 == 0 /* NO_ERROR */ ) break;
         if (!((error_64 == 4 /* SERVER_BUSY */ || error_64 == 137 /* BROKER_BUSY */ || error_64 == 146 /* TRADE_CONTEXT_BUSY */ || error_64 == 136 /* OFF_QUOTES */ ))) break;
         Sleep(5000);
      }
      break;
   case 5:
      for (count_68 = 0; count_68 < Li_72; count_68++) {
         ticket_60 = OrderSend(Symbol(), OP_SELLSTOP, A_lots_4, A_price_12, A_slippage_20, f0_33(Ad_24, Ai_32), f0_26(A_price_12, Ai_36), A_comment_40, A_magic_48, A_datetime_52,
            A_color_56);
         error_64 = GetLastError();
         if (error_64 == 0 /* NO_ERROR */ ) break;
         if (!((error_64 == 4 /* SERVER_BUSY */ || error_64 == 137 /* BROKER_BUSY */ || error_64 == 146 /* TRADE_CONTEXT_BUSY */ || error_64 == 136 /* OFF_QUOTES */ ))) break;
         Sleep(5000);
      }
      break;
   case 1:
      for (count_68 = 0; count_68 < Li_72; count_68++) {
         ticket_60 = OrderSend(Symbol(), OP_SELL, A_lots_4, Bid, A_slippage_20, f0_33(Ask, Ai_32), f0_26(Bid, Ai_36), A_comment_40, A_magic_48, A_datetime_52, A_color_56);
         //PlaySound("keroncong.wav");
         error_64 = GetLastError();
         if (error_64 == 0 /* NO_ERROR */ ) break;
         if (!((error_64 == 4 /* SERVER_BUSY */ || error_64 == 137 /* BROKER_BUSY */ || error_64 == 146 /* TRADE_CONTEXT_BUSY */ || error_64 == 136 /* OFF_QUOTES */ ))) break;
         Sleep(5000);
      }
   }
   return (ticket_60);
}

double f0_13(double Ad_0, int Ai_8) {
   if (Ai_8 == 0) return (0);
   return (Ad_0 - Ai_8 * Point);
}

double f0_33(double Ad_0, int Ai_8) {
   if (Ai_8 == 0) return (0);
   return (Ad_0 + Ai_8 * Point);
}

double f0_25(double Ad_0, int Ai_8) {
   if (Ai_8 == 0) return (0);
   return (Ad_0 + Ai_8 * Point);
}

double f0_26(double Ad_0, int Ai_8) {
   if (Ai_8 == 0) return (0);
   return (Ad_0 - Ai_8 * Point);
}

double f0_29() {
   double Ld_ret_0 = 0;
   for (G_pos_676 = OrdersTotal() - 1; G_pos_676 >= 0; G_pos_676--) {
      TicketOrder = OrderSelect(G_pos_676, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != G_magic_176_15) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == G_magic_176_15)
         if (OrderType() == OP_BUY || OrderType() == OP_SELL) Ld_ret_0 += OrderProfit();
   }
   return (Ld_ret_0);
}

double f0_16() {
   if (f0_5() == 0) Gd_712 = AccountEquity();
   if (Gd_712 < Gd_720) Gd_712 = Gd_720;
   else Gd_712 = AccountEquity();
   Gd_720 = AccountEquity();
   return (Gd_712);
}

double f0_36() {
   double order_open_price_0;
   int ticket_8;
   double Ld_unused_12 = 0;
   int ticket_20 = 0;
   for (int pos_24 = OrdersTotal() - 1; pos_24 >= 0; pos_24--) {
      TicketOrder = OrderSelect(pos_24, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != G_magic_176_15) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == G_magic_176_15 && OrderType() == OP_BUY) {
         ticket_8 = OrderTicket();
         if (ticket_8 > ticket_20) {
            order_open_price_0 = OrderOpenPrice();
            Ld_unused_12 = order_open_price_0;
            ticket_20 = ticket_8;
         }
      }
   }
   return (order_open_price_0);
}

double f0_28() {
   double order_open_price_0;
   int ticket_8;
   double Ld_unused_12 = 0;
   int ticket_20 = 0;
   for (int pos_24 = OrdersTotal() - 1; pos_24 >= 0; pos_24--) {
      TicketOrder = OrderSelect(pos_24, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != G_magic_176_15) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == G_magic_176_15 && OrderType() == OP_SELL) {
         ticket_8 = OrderTicket();
         if (ticket_8 > ticket_20) {
            order_open_price_0 = OrderOpenPrice();
            Ld_unused_12 = order_open_price_0;
            ticket_20 = ticket_8;
         }
      }
   }
   return (order_open_price_0);
}

int f0_12() {
   int count_0 = 0;
   for (int pos_4 = OrdersTotal() - 1; pos_4 >= 0; pos_4--) {
      TicketOrder = OrderSelect(pos_4, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != G_magic_176_16) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == G_magic_176_16)
         if (OrderType() == OP_SELL || OrderType() == OP_BUY) count_0++;
   }
   return (count_0);
}

void f0_0() {
   for (int pos_0 = OrdersTotal() - 1; pos_0 >= 0; pos_0--) {
      TicketOrder = OrderSelect(pos_0, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol()) {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == G_magic_176_16) {
            if (OrderType() == OP_BUY) TicketOrder = OrderClose(OrderTicket(), OrderLots(), Bid, slip_16, Blue);
            if (OrderType() == OP_SELL) TicketOrder = OrderClose(OrderTicket(), OrderLots(), Ask, slip_16, Red);
         }
         Sleep(1000);
      }
   }
}

int f0_6(int Ai_0, double A_lots_4, double A_price_12, int A_slippage_20, double Ad_24, int Ai_32, int Ai_36, string A_comment_40, int A_magic_48, int A_datetime_52, color A_color_56) {
   int ticket_60 = 0;
   int error_64 = 0;
   int count_68 = 0;
   int Li_72 = 100;
   switch (Ai_0) {
   case 2:
      for (count_68 = 0; count_68 < Li_72; count_68++) {
         ticket_60 = OrderSend(Symbol(), OP_BUYLIMIT, A_lots_4, A_price_12, A_slippage_20, f0_14(Ad_24, Ai_32), f0_9(A_price_12, Ai_36), A_comment_40, A_magic_48, A_datetime_52,
            A_color_56);
         error_64 = GetLastError();
         if (error_64 == 0 /* NO_ERROR */ ) break;
         if (!((error_64 == 4 /* SERVER_BUSY */ || error_64 == 137 /* BROKER_BUSY */ || error_64 == 146 /* TRADE_CONTEXT_BUSY */ || error_64 == 136 /* OFF_QUOTES */ ))) break;
         Sleep(1000);
      }
      break;
   case 4:
      for (count_68 = 0; count_68 < Li_72; count_68++) {
         ticket_60 = OrderSend(Symbol(), OP_BUYSTOP, A_lots_4, A_price_12, A_slippage_20, f0_14(Ad_24, Ai_32), f0_9(A_price_12, Ai_36), A_comment_40, A_magic_48, A_datetime_52,
            A_color_56);
         error_64 = GetLastError();
         if (error_64 == 0 /* NO_ERROR */ ) break;
         if (!((error_64 == 4 /* SERVER_BUSY */ || error_64 == 137 /* BROKER_BUSY */ || error_64 == 146 /* TRADE_CONTEXT_BUSY */ || error_64 == 136 /* OFF_QUOTES */ ))) break;
         Sleep(5000);
      }
      break;
   case 0:
      for (count_68 = 0; count_68 < Li_72; count_68++) {
         RefreshRates();
         ticket_60 = OrderSend(Symbol(), OP_BUY, A_lots_4, Ask, A_slippage_20, f0_14(Bid, Ai_32), f0_9(Ask, Ai_36), A_comment_40, A_magic_48, A_datetime_52, A_color_56);
         //PlaySound("tortor.wav");
         error_64 = GetLastError();
         if (error_64 == 0 /* NO_ERROR */ ) break;
         if (!((error_64 == 4 /* SERVER_BUSY */ || error_64 == 137 /* BROKER_BUSY */ || error_64 == 146 /* TRADE_CONTEXT_BUSY */ || error_64 == 136 /* OFF_QUOTES */ ))) break;
         Sleep(5000);
      }
      break;
   case 3:
      for (count_68 = 0; count_68 < Li_72; count_68++) {
         ticket_60 = OrderSend(Symbol(), OP_SELLLIMIT, A_lots_4, A_price_12, A_slippage_20, f0_23(Ad_24, Ai_32), f0_10(A_price_12, Ai_36), A_comment_40, A_magic_48, A_datetime_52,
            A_color_56);
         error_64 = GetLastError();
         if (error_64 == 0 /* NO_ERROR */ ) break;
         if (!((error_64 == 4 /* SERVER_BUSY */ || error_64 == 137 /* BROKER_BUSY */ || error_64 == 146 /* TRADE_CONTEXT_BUSY */ || error_64 == 136 /* OFF_QUOTES */ ))) break;
         Sleep(5000);
      }
      break;
   case 5:
      for (count_68 = 0; count_68 < Li_72; count_68++) {
         ticket_60 = OrderSend(Symbol(), OP_SELLSTOP, A_lots_4, A_price_12, A_slippage_20, f0_23(Ad_24, Ai_32), f0_10(A_price_12, Ai_36), A_comment_40, A_magic_48, A_datetime_52,
            A_color_56);
         error_64 = GetLastError();
         if (error_64 == 0 /* NO_ERROR */ ) break;
         if (!((error_64 == 4 /* SERVER_BUSY */ || error_64 == 137 /* BROKER_BUSY */ || error_64 == 146 /* TRADE_CONTEXT_BUSY */ || error_64 == 136 /* OFF_QUOTES */ ))) break;
         Sleep(5000);
      }
      break;
   case 1:
      for (count_68 = 0; count_68 < Li_72; count_68++) {
         ticket_60 = OrderSend(Symbol(), OP_SELL, A_lots_4, Bid, A_slippage_20, f0_23(Ask, Ai_32), f0_10(Bid, Ai_36), A_comment_40, A_magic_48, A_datetime_52, A_color_56);
         //PlaySound("tortor.wav");
         error_64 = GetLastError();
         if (error_64 == 0 /* NO_ERROR */ ) break;
         if (!((error_64 == 4 /* SERVER_BUSY */ || error_64 == 137 /* BROKER_BUSY */ || error_64 == 146 /* TRADE_CONTEXT_BUSY */ || error_64 == 136 /* OFF_QUOTES */ ))) break;
         Sleep(5000);
      }
   }
   return (ticket_60);
}

double f0_14(double Ad_0, int Ai_8) {
   if (Ai_8 == 0) return (0);
   return (Ad_0 - Ai_8 * Point);
}

double f0_23(double Ad_0, int Ai_8) {
   if (Ai_8 == 0) return (0);
   return (Ad_0 + Ai_8 * Point);
}

double f0_9(double Ad_0, int Ai_8) {
   if (Ai_8 == 0) return (0);
   return (Ad_0 + Ai_8 * Point);
}

double f0_10(double Ad_0, int Ai_8) {
   if (Ai_8 == 0) return (0);
   return (Ad_0 - Ai_8 * Point);
}

double f0_8() {
   double Ld_ret_0 = 0;
   for (G_pos_960 = OrdersTotal() - 1; G_pos_960 >= 0; G_pos_960--) {
      TicketOrder = OrderSelect(G_pos_960, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != G_magic_176_16) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == G_magic_176_16)
         if (OrderType() == OP_BUY || OrderType() == OP_SELL) Ld_ret_0 += OrderProfit();
   }
   return (Ld_ret_0);
}

double f0_17() {
   double order_open_price_0;
   int ticket_8;
   double Ld_unused_12 = 0;
   int ticket_20 = 0;
   for (int pos_24 = OrdersTotal() - 1; pos_24 >= 0; pos_24--) {
      TicketOrder = OrderSelect(pos_24, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != G_magic_176_16) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == G_magic_176_16 && OrderType() == OP_BUY) {
         ticket_8 = OrderTicket();
         if (ticket_8 > ticket_20) {
            order_open_price_0 = OrderOpenPrice();
            Ld_unused_12 = order_open_price_0;
            ticket_20 = ticket_8;
         }
      }
   }
   return (order_open_price_0);
}

double f0_27() {
   double order_open_price_0;
   int ticket_8;
   double Ld_unused_12 = 0;
   int ticket_20 = 0;
   for (int pos_24 = OrdersTotal() - 1; pos_24 >= 0; pos_24--) {
      TicketOrder = OrderSelect(pos_24, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != G_magic_176_16) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == G_magic_176_16 && OrderType() == OP_SELL) {
         ticket_8 = OrderTicket();
         if (ticket_8 > ticket_20) {
            order_open_price_0 = OrderOpenPrice();
            Ld_unused_12 = order_open_price_0;
            ticket_20 = ticket_8;
         }
      }
   }
   return (order_open_price_0);
}

int RemoveExpertNow(double MinimumEquity = 0) {
   
   if(MinimumEquity > 0 && AccountEquity() < MinimumEquity) {
      RemoveAllOrders();
      RemoveAllOrders();
      RemoveAllOrders();
      ExpertRemove();
   }
   return(0);
   
}

void RemoveAllOrders() {
   for(int i = OrdersTotal() - 1; i >= 0 ; i--)    {
      TicketOrder = OrderSelect(i, SELECT_BY_POS);
      if(OrderType() == OP_BUY) {
         TicketOrder = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, clrNONE);
      } else if(OrderType() == OP_SELL) {
         TicketOrder = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, clrNONE);
      } else {
         TicketOrder = OrderDelete(OrderTicket());
      }
      
      int MessageError = GetLastError();
      if(MessageError > 0) {
         Print("Unanticipated error " + IntegerToString(MessageError));
      }
      
      Sleep(100);      
      RefreshRates();
      
   }
}