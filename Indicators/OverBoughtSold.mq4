//+---------------------------------------------------------------------+
//| KLASPROFSignal-bbbtakt.mq4|
//| For more EXPERTS, INDICATORS, TRAILING EAs and SUPPORT Please visit:|
//|                                      http://www.klasprof.net      |
//|           Our forum is at:   http://forex-forum.klasprof.net      |
//+---------------------------------------------------------------------+
#property copyright "Klasprof.net bbbtakt"
#property link "http://www.klasprof.net"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 LimeGreen
#property indicator_color2 Red

string _name = "OverBS";
string _ver = "v1.1";
bool _enableAlert = TRUE;
//---------------------------------------------
int g_timeframe_76 = 0;
extern string IndieNote = "KLASPROFSignal-bbbtakt";

extern bool Display_Market_Bias = TRUE;
extern bool Display_Build_Info = TRUE;
extern bool Overbought_Sold_On = TRUE;
extern string MAnote = "===Moving Average Crosses===";
extern bool Ind2MACross = FALSE;
extern bool Ind3MACross = FALSE;
extern int Ind3MA_Mode = 0;
extern int PeriodMA1 = 9;
extern int PeriodMA2 = 18;
extern int PeriodMA3 = 200;
extern int PriceTypeMA1 = 0;
extern int PriceTypeMA2 = 0;
extern int PriceTypeMA3 = 0;
extern int MATypeMA1 = 0;
extern int MATypeMA2 = 0;
extern int MATypeMA3 = 0;
extern int ShiftMA1 = 0;
extern int ShiftMA2 = 0;
extern int ShiftMA3 = 0;
extern string Bollinger = "===Bollinger Bands===";
extern bool IndBollinger = TRUE;
extern bool Tag_and_Reverse = TRUE;
extern int Period_Bollinger = 20;
extern int Deviation_Bollinger = 2;
int gi_188 = 0;
extern int PriceType_Bollinger = 0;
extern string PSAR = "===Parabolic SAR===";
extern bool IndParabolicSAR = FALSE;
extern double Step_PSAR = 0.02;
extern double Max_PSAR = 0.2;
extern string Heikin = "===Heikin Ashi===";
extern bool IndHeikin = false;
extern string HeikinS = "===Heikin Ashi Smoothed===";
extern bool IndHeikinSmoothed = false;
extern int Period1_Heikin = 2;
extern int Period2_Heikin = 1;
extern int MaType1_Heikin = 2;
extern int MaType2_Heikin = 2;
extern string RSI = "===Relative Strength Index===";
extern bool IndRSI = false;
extern int PeriodRSI = 5;
extern double UpLimitRSI = 30.0;
extern double DownLimitRSI = 70.0;
extern int PriceTypeRSI = 0;
extern string CCI = "===Commodity Channel Index===";
extern bool IndCCI = FALSE;
extern int PeriodCCI = 13;
extern double UpLimitCCI = 25.0;
extern double DownLimitCCI = -25.0;
extern int PriceTypeCCI = 0;
extern string Stoch = "===Stochastic Oscillator===";
extern bool IndStoch = FALSE;
extern int PeriodStochK = 5;
extern int PeriodStochD = 3;
extern int PeriodStochS = 3;
extern int UpLimitStoch = 50;
extern int DownLimitStoch = 50;
extern int PriceFieldStoch = 0;
extern int MATypeStoch = 0;
extern int ModeStoch = 1;
extern string MACD = "===MACD===";
extern bool IndMACD = false;
extern int PeriodMACDF = 15;
extern int PeriodMACDS = 29;
extern int PeriodMACDSignal = 12;
extern double MACDLinesMinDist = 0.00005;
extern double UpLimitMACD = 0.0;
extern double DownLimitMACD = 0.0;
extern int PriceTypeMACD = 0;
extern int ModeMACD = 0;
extern string OsMA = "===OsMA===";
extern bool IndOsMA = FALSE;
extern int PeriodOsMAF = 12;
extern int PeriodOsMAS = 26;
extern int PeriodOsMAMACD = 9;
extern double UpLimitOsMA = 0.0;
extern double DownLimitOsMA = 0.0;
extern int PriceTypeOsMA = 0;
extern string Momentum = "===Momentum===";
extern bool IndMomentum = FALSE;
extern int PeriodMomentum = 14;
extern double UpLimitMomentum = 100.0;
extern double DownLimitMomentum = 100.0;
extern int PriceTypeMomentum = 0;
extern string ADX = "===ADX===";
extern bool IndADX = false;
extern int PeriodADX = 14;
extern bool ADX_Strength = false;
extern int MinStrengthADX = 21;
extern int PriceTypeADX = 0;
extern string ATR = "===ATR:Volatility Filter===";
extern bool IndATR = FALSE;
extern int PeriodATR = 14;
extern double MinStrengthATR = 0.001;
extern string Force = "===Force Index===";
extern bool IndForce = FALSE;
extern int PeriodForce = 55;
extern double UpLimitForce = 0.01;
extern double DownLimitForce = -0.01;
extern int PriceTypeForce = 0;
extern int MATypeForce = 1;
extern string Alligator = "===Alligator===";
extern bool IndGator = FALSE;
extern string GatorOsc = "===Gator Oscillator===";
extern bool IndGatorOsc = FALSE;
extern int PeriodGatorJaw = 13;
extern int PeriodGatorTeeth = 8;
extern int PeriodGatorLips = 5;
extern int ShiftGatorJaw = 8;
extern int ShiftGatorTeeth = 5;
extern int ShiftGatorLips = 3;
extern double MinStrengthOscillator = 0.0;
extern int PriceTypeGator = 4;
extern int MATypeGator = 2;
extern string WPR = "===Williams\' %R===";
extern bool IndWPR = FALSE;
extern int PeriodWPR = 28;
extern int UpLimitWPR = -45;
extern int DownLimitWPR = -55;
extern string DeMarker = "===DeMarker===";
extern bool IndDM = FALSE;
extern int PeriodDM = 21;
extern double UpLimitDM = 0.55;
extern double DownLimitDM = 0.45;
extern bool Alert_On = TRUE;
extern bool Alert_PopUp_On = TRUE;
extern bool Send_Email = FALSE;
extern string SetEmail = "Set email in Tools>Opt.>Email";
extern int Arrow_Distance = 10;
extern int ArrowType = 0;
extern int ArrowSize = 2;
extern color BuyArrowColor = Aqua;
extern color SellArrowColor = Red;
extern int Buy_Sound = 1;
extern int Sell_Sound = 1;
extern int Dashboard_Corner = 1;
extern int CountBars = 3000;
extern string Price_Codes = "0 Close, 1 Open, 2 High, 3 Low";
extern string Price_Codes2 = "4 H+L/2, 5 H+L+C/3, 6 H+L+C+C/4";
extern string MA_Type_Codes = "0 Simple, 1 Exponential";
extern string MA_Type_Codes2 = "2 Smoothed, 3 Linear Weighted";
extern string Selecting_Arrows = "Arrow type options range 0-9";
extern string Selecting_Sound = "Sound options range 0-12";
extern string EndNote = "====Refer to manual for help====";
extern string Developer = "Developed by o ekz";
extern string Publisher = "(c) 2009-15 |o ekz Investment Research (formerly Build-a-Signal)";
extern string PublisherURL = "http://www.klasprof.net";
bool gi_unused_848 = TRUE;
double gd_852;
double gd_860;
double gd_868;
double gd_876;
double g_ibuf_884[];
double g_ibuf_888[];
int gi_892 = 0;
int g_bars_896 = 0;

// E37F0136AA3FFAF149B351F6A4C948E9
int init() {
   if (IsDllsAllowed() == FALSE) {
      Alert("TradeBuilder Classic needs to import external functions to work properly.");
      Alert("TB Classic: You must check \"Allow DLL Imports\" under indicator\'s \"Common\" tab.");
   }
   SetIndexStyle(0, DRAW_ARROW, EMPTY, ArrowSize, BuyArrowColor);
   SetIndexArrow(0, 225);
   SetIndexBuffer(0, g_ibuf_884);
   SetIndexLabel(0, "OverSold");
   SetIndexStyle(1, DRAW_ARROW, EMPTY, ArrowSize, SellArrowColor);
   SetIndexArrow(1, 226);
   SetIndexBuffer(1, g_ibuf_888);
   SetIndexLabel(1, "OverBought");
   if (ArrowType == 0) {
      SetIndexArrow(0, 233);
      SetIndexArrow(1, 234);
   } else {
      if (ArrowType == 1) {
         SetIndexArrow(0, 225);
         SetIndexArrow(1, 226);
      } else {
         if (ArrowType == 2) {
            SetIndexArrow(0, SYMBOL_ARROWUP);
            SetIndexArrow(1, SYMBOL_ARROWDOWN);
         } else {
            if (ArrowType == 3) {
               SetIndexArrow(0, 221);
               SetIndexArrow(1, 222);
            } else {
               if (ArrowType == 4) {
                  SetIndexArrow(0, 217);
                  SetIndexArrow(1, 218);
               } else {
                  if (ArrowType == 5) {
                     SetIndexArrow(0, 228);
                     SetIndexArrow(1, 230);
                  } else {
                     if (ArrowType == 6) {
                        SetIndexArrow(0, 236);
                        SetIndexArrow(1, 238);
                     } else {
                        if (ArrowType == 7) {
                           SetIndexArrow(0, 246);
                           SetIndexArrow(1, 248);
                        } else {
                           if (ArrowType == 8) {
                              SetIndexArrow(0, SYMBOL_THUMBSUP);
                              SetIndexArrow(1, SYMBOL_THUMBSDOWN);
                           } else {
                              if (ArrowType == 9) {
                                 SetIndexArrow(0, 71);
                                 SetIndexArrow(1, 72);
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }
   gd_868 = 0;
   gd_876 = 0;
   IndicatorShortName(_name);
   return (0);
}

// EA2B2676C28C0DB26D39331A336C6B92
int start() {
   bool li_8;
   int str2time_12;
   double idemarker_16;
   double idemarker_24;
   double iosma_32;
   int li_40;
   int li_44;
   string ls_48;
   color color_56;
   string ls_60;
   color color_68;
   string ls_72;
   double ld_80;
   string ls_88;
   double ld_96;
   string ls_104;
   string ls_112;
   double ld_120;
   double ld_128;
   double ld_136;
   string ls_144;
   double ld_152;
   string ls_160;
   string ls_168;
   string ls_176;
   double ld_184;
   double ld_192;
   string ls_200;
   double ld_208;
   double ld_216;
   double ld_224;
   string ls_232;
   double ld_240;
   double ld_248;
   double ld_256;
   double ld_264;
   double ld_272;
   string ls_280;
   double ld_288;
   string ls_296;
   string ls_304;
   double ld_312;
   double ld_320;
   double ld_328;
   string ls_336;
   string ls_344;
   string ls_352;
   double ld_360;
   string ls_368;
   double ld_376;
   double ld_384;
   double ld_392;
   string ls_400;
   double icustom_408;
   double icustom_416;
   double ld_424;
   double ld_432;
   string ls_440;
   double ld_448;
   double ld_456;
   double ld_464;
   double ld_472;
   string ls_480;
   double ld_488;
   double ld_496;
   double ld_504;
   double ld_512;
   double ld_520;
   string ls_528;
   double ld_536;
   string ls_544;
   double ld_552;
   string ls_560;
   double ld_568;
   double ld_576;
   double ld_584;
   string ls_592;
   double ld_600;
   string text_608;
   int str2time_616;
   double ld_620;
   double ld_628;
   int str2time_636;
   double ld_640;
   double lda_648[128];
   double ld_652;
   double ld_660;
   int li_668;
   int li_672;
   int li_676;
   datetime lt_680 = D'01.01.2025 13:30';
   if (TimeCurrent() > lt_680) {
      ObjectCreate("ClassicTitle", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("ClassicTitle", "KLASPROFSignal-bbbtakt", 10, "Arial Bold", Black);
      ObjectSet("ClassicTitle", OBJPROP_CORNER, Dashboard_Corner);
      ObjectSet("ClassicTitle", OBJPROP_XDISTANCE, 5);
      ObjectSet("ClassicTitle", OBJPROP_YDISTANCE, 3);
      return (0);
   }
   ObjectCreate("CountBars_Limit_Classic", OBJ_VLINE, 0, Time[CountBars], 0);
   ObjectSet("CountBars_Limit_Classic", OBJPROP_STYLE, STYLE_SOLID);
   ObjectSet("CountBars_Limit_Classic", OBJPROP_COLOR, Black);
   ObjectSet("CountBars_Limit_Classic", OBJPROP_WIDTH, 2);
   ObjectCreate("counttxt_Classic", OBJ_TEXT, 0, Time[CountBars], Open[CountBars]);
   ObjectSetText("counttxt_Classic", StringConcatenate("KLASPROFSignal-bbbtakt history (CountBars) set to ", CountBars), 8, "Arial Bold", Black);
   ObjectCreate("countback_Classic", OBJ_TEXT, 0, Time[CountBars], Open[CountBars]);
   ObjectSetText("countback_Classic", "ggggggggggg", 20, "Webdings", Black);
   string ls_684 = "2025.";
   if (g_bars_896 == Bars) return (0);
   g_bars_896 = Bars;
   int li_unused_692 = 0;
   int ind_counted_696 = IndicatorCounted();
   string ls_700 = "06.02";
   int li_708 = Bars - ind_counted_696;
   if (ind_counted_696 > 0) li_708++;
   else
   if (li_708 > 100) li_708 = CountBars;
   SetIndexDrawBegin(0, Bars - CountBars);
   SetIndexDrawBegin(1, Bars - CountBars);
   for (int li_712 = CountBars; li_712 > 0; li_712--) {
      li_8 = FALSE;
      str2time_12 = StrToTime(ls_684 + ls_700);
      g_ibuf_884[li_712] = EMPTY_VALUE;
      g_ibuf_888[li_712] = EMPTY_VALUE;
      if (TimeCurrent() > str2time_12) return (0);
      if (TimeCurrent() < str2time_12) {
         if (Display_Market_Bias) {
            idemarker_16 = iDeMarker(NULL, 0, 5, li_712);
            idemarker_24 = iDeMarker(NULL, 0, 75, li_712);
            iosma_32 = iOsMA(NULL, 0, 75, 500, 125, PRICE_CLOSE, 0);
            li_40 = f0_4(idemarker_16, iosma_32);
            li_44 = f0_13(idemarker_24, iosma_32);
            if (li_40 == 0) {
               ls_48 = "BULLISH";
               color_56 = Black;
            } else {
               if (li_40 == 1) {
                  ls_48 = "BEARISH";
                  color_56 = Gold;
               } else {
                  if (li_40 == 2) {
                     ls_48 = "OVERBOUGHT";
                     color_56 = Black;
                  } else {
                     if (li_40 == 3) {
                        ls_48 = "";
                        color_56 = Black;
                     }
                  }
               }
            }
            if (li_44 == 0) {
               ls_60 = "";
               color_68 = Black;
            } else {
               if (li_44 == 1) {
                  ls_60 = "BEARISH";
                  color_68 = Gold;
               } else {
                  if (li_44 == 2) {
                     ls_60 = "OVERBOUGHT";
                     color_68 = Black;
                  } else {
                     if (li_44 == 3) {
                        ls_60 = "";
                        color_68 = Black;
                     }
                  }
               }
            }
            ObjectCreate("xBiasTitleClassic", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("xBiasTitleClassic", "", 9, "Arial", Black);
            ObjectSet("xBiasTitleClassic", OBJPROP_CORNER, Dashboard_Corner);
            ObjectSet("xBiasTitleClassic", OBJPROP_XDISTANCE, 5);
            ObjectSet("xBiasTitleClassic", OBJPROP_YDISTANCE, 77);
            ObjectCreate("xBiasTitle2Classic", OBJ_LABEL, 0, 0, 0);
            ObjectSetText("xBiasTitle2Classic", "_________________", 8, "Arial", Black);
            ObjectSet("xBiasTitle2Classic", OBJPROP_CORNER, Dashboard_Corner);
            ObjectSet("xBiasTitle2Classic", OBJPROP_XDISTANCE, 5);
            ObjectSet("xBiasTitle2Classic", OBJPROP_YDISTANCE, 82);
         }
         ls_72 = ".12";
         if (IndRSI) {
            ld_80 = iRSI(NULL, 0, PeriodRSI, PriceTypeRSI, li_712);
            ls_88 = "RSI  ";
         } else {
            ld_80 = li_8;
            UpLimitRSI = li_8;
            DownLimitRSI = li_8;
         }
         if (IndCCI) {
            ld_96 = iCCI(NULL, 0, PeriodCCI, PriceTypeCCI, li_712);
            ls_104 = "CCI  ";
         } else {
            ld_96 = li_8;
            UpLimitCCI = li_8;
            DownLimitCCI = li_8;
         }
         if (IndStoch) {
            ls_112 = "STOCH  ";
            ld_120 = iStochastic(NULL, 0, PeriodStochK, PeriodStochD, PeriodStochS, MATypeStoch, PriceFieldStoch, ModeStoch, li_712);
            ld_128 = iStochastic(NULL, 0, PeriodStochK, PeriodStochD, PeriodStochS, MATypeStoch, PriceFieldStoch, MODE_MAIN, li_712);
            ld_136 = iStochastic(NULL, 0, PeriodStochK, PeriodStochD, PeriodStochS, MATypeStoch, PriceFieldStoch, MODE_SIGNAL, li_712);
         } else {
            ld_120 = li_8;
            ld_128 = li_8;
            ld_136 = li_8;
            UpLimitStoch = li_8;
            DownLimitStoch = li_8;
         }
         if (IndForce) {
            ls_144 = "FORCE  ";
            ld_152 = iForce(NULL, 0, PeriodForce, MATypeForce, PriceTypeForce, li_712);
         } else {
            ld_152 = li_8;
            UpLimitForce = li_8;
            DownLimitForce = li_8;
         }
         ls_160 = ".12";
         ls_168 = "20";
         if (Ind2MACross) {
            ls_176 = "2MA  ";
            ld_184 = iMA(NULL, 0, PeriodMA1, ShiftMA1, MATypeMA1, PriceTypeMA1, li_712);
            ld_192 = iMA(NULL, 0, PeriodMA2, ShiftMA2, MATypeMA2, PriceTypeMA2, li_712);
         } else {
            ld_184 = li_8;
            ld_192 = li_8;
         }
         if (Ind3MACross) {
            ls_200 = "3MA  ";
            if (Ind3MA_Mode <= 0 || Ind3MA_Mode > 2) {
               ld_208 = iMA(NULL, 0, PeriodMA1, ShiftMA1, MATypeMA1, PriceTypeMA1, li_712);
               ld_216 = iMA(NULL, 0, PeriodMA2, ShiftMA2, MATypeMA2, PriceTypeMA2, li_712);
               ld_224 = iMA(NULL, 0, PeriodMA3, ShiftMA3, MATypeMA3, PriceTypeMA3, li_712);
            }
            if (Ind3MA_Mode == 1) {
               if (gd_852 == 1.0) {
                  ld_208 = iMA(NULL, 0, PeriodMA1, ShiftMA1, MATypeMA1, PriceTypeMA1, li_712);
                  ld_224 = iMA(NULL, 0, PeriodMA3, ShiftMA3, MATypeMA3, PriceTypeMA3, li_712);
                  ld_216 = iMA(NULL, 0, PeriodMA3, ShiftMA3, MATypeMA3, PriceTypeMA3, li_712);
               } else {
                  ld_208 = iMA(NULL, 0, PeriodMA1, ShiftMA1, MATypeMA1, PriceTypeMA1, li_712);
                  ld_216 = iMA(NULL, 0, PeriodMA2, ShiftMA2, MATypeMA2, PriceTypeMA2, li_712);
                  ld_224 = iMA(NULL, 0, PeriodMA3, ShiftMA3, MATypeMA3, PriceTypeMA3, li_712);
               }
            }
            if (Ind3MA_Mode == 2) {
               if (gd_860 == 1.0) {
                  ld_208 = iMA(NULL, 0, PeriodMA1, ShiftMA1, MATypeMA1, PriceTypeMA1, li_712);
                  ld_224 = iMA(NULL, 0, PeriodMA3, ShiftMA3, MATypeMA3, PriceTypeMA3, li_712);
                  ld_216 = iMA(NULL, 0, PeriodMA3, ShiftMA3, MATypeMA3, PriceTypeMA3, li_712);
               } else {
                  ld_208 = iMA(NULL, 0, PeriodMA1, ShiftMA1, MATypeMA1, PriceTypeMA1, li_712);
                  ld_216 = iMA(NULL, 0, PeriodMA2, ShiftMA2, MATypeMA2, PriceTypeMA2, li_712);
                  ld_224 = iMA(NULL, 0, PeriodMA3, ShiftMA3, MATypeMA3, PriceTypeMA3, li_712);
               }
            }
         } else {
            if (!Ind3MACross) {
               ld_208 = li_8;
               ld_216 = li_8;
               ld_224 = li_8;
            }
         }
         if (IndMACD) {
            ls_232 = "MACD  ";
            ld_240 = iMACD(NULL, 0, PeriodMACDF, PeriodMACDS, PeriodMACDSignal, PriceTypeMACD, ModeMACD, li_712);
            ld_248 = iMACD(NULL, 0, PeriodMACDF, PeriodMACDS, PeriodMACDSignal, PriceTypeMACD, MODE_MAIN, li_712);
            ld_256 = iMACD(NULL, 0, PeriodMACDF, PeriodMACDS, PeriodMACDSignal, PriceTypeMACD, MODE_SIGNAL, li_712);
            ld_264 = ld_248 - ld_256;
         } else {
            ld_240 = li_8;
            ld_248 = li_8;
            ld_256 = li_8;
            UpLimitMACD = li_8;
            DownLimitMACD = li_8;
            MACDLinesMinDist = li_8;
         }
         if (IndOsMA) {
            ld_272 = iOsMA(NULL, 0, PeriodOsMAF, PeriodOsMAS, PeriodOsMAMACD, PriceTypeOsMA, li_712);
            ls_280 = "OSMA  ";
         } else {
            ld_272 = li_8;
            UpLimitOsMA = li_8;
            DownLimitOsMA = li_8;
         }
         if (IndMomentum) {
            ld_288 = iMomentum(NULL, 0, PeriodMomentum, PriceTypeMomentum, li_712);
            ls_296 = "MOM  ";
         } else {
            ld_288 = li_8;
            UpLimitMomentum = li_8;
            DownLimitMomentum = li_8;
         }
         if (IndADX && (!ADX_Strength)) {
            ls_304 = "ADX  ";
            ld_312 = iADX(NULL, 0, PeriodADX, PriceTypeADX, MODE_MAIN, li_712);
            ld_320 = iADX(NULL, 0, PeriodADX, PriceTypeADX, MODE_PLUSDI, li_712);
            ld_328 = iADX(NULL, 0, PeriodADX, PriceTypeADX, MODE_MINUSDI, li_712);
         }
         if (IndADX && ADX_Strength) {
            ls_336 = "ADX-S  ";
            ld_312 = iADX(NULL, 0, PeriodADX, PriceTypeADX, MODE_MAIN, li_712);
            ld_320 = li_8;
            ld_328 = li_8;
         } else {
            ld_312 = li_8;
            MinStrengthADX = li_8;
         }
         ls_344 = "22";
         if (IndATR) {
            ls_352 = "ATR  ";
            ld_360 = iATR(NULL, 0, PeriodATR, li_712);
         } else {
            ld_360 = li_8;
            MinStrengthATR = li_8;
         }
         if (IndGator) {
            ls_368 = "ALLIG  ";
            ld_376 = iAlligator(NULL, 0, PeriodGatorJaw, ShiftGatorJaw, PeriodGatorTeeth, ShiftGatorTeeth, PeriodGatorLips, ShiftGatorLips, MATypeGator, PriceTypeGator, MODE_GATORJAW,
               li_712);
            ld_384 = iAlligator(NULL, 0, PeriodGatorJaw, ShiftGatorJaw, PeriodGatorTeeth, ShiftGatorTeeth, PeriodGatorLips, ShiftGatorLips, MATypeGator, PriceTypeGator, MODE_GATORTEETH,
               li_712);
            ld_392 = iAlligator(NULL, 0, PeriodGatorJaw, ShiftGatorJaw, PeriodGatorTeeth, ShiftGatorTeeth, PeriodGatorLips, ShiftGatorLips, MATypeGator, PriceTypeGator, MODE_GATORLIPS,
               li_712);
         } else {
            ld_376 = li_8;
            ld_384 = li_8;
            ld_392 = li_8;
         }
         if (IndGatorOsc) {
            ls_400 = "GATOR-OSC  ";
            icustom_408 = iCustom(NULL, 0, "Gator", PeriodGatorJaw, ShiftGatorJaw, PeriodGatorTeeth, ShiftGatorTeeth, PeriodGatorLips, ShiftGatorLips, MATypeGator, PriceTypeGator,
               5, li_712);
            icustom_416 = iCustom(NULL, 0, "Gator", PeriodGatorJaw, ShiftGatorJaw, PeriodGatorTeeth, ShiftGatorTeeth, PeriodGatorLips, ShiftGatorLips, MATypeGator, PriceTypeGator,
               2, li_712);
            ld_424 = iCustom(NULL, 0, "Gator", PeriodGatorJaw, ShiftGatorJaw, PeriodGatorTeeth, ShiftGatorTeeth, PeriodGatorLips, ShiftGatorLips, MATypeGator, PriceTypeGator,
               3, li_712);
            ld_432 = iCustom(NULL, 0, "Gator", PeriodGatorJaw, ShiftGatorJaw, PeriodGatorTeeth, ShiftGatorTeeth, PeriodGatorLips, ShiftGatorLips, MATypeGator, PriceTypeGator,
               0, li_712);
         } else {
            icustom_408 = 0.1;
            icustom_416 = 0.1;
            ld_432 = li_8;
            ld_424 = li_8;
            MinStrengthOscillator = li_8;
         }
         if (IndHeikin) {
            ls_440 = "HA ";
            ld_448 = iCustom(NULL, 0, "Heikin_Ashi_Smoothed", 0, 1, 3, 1, 0, li_712);
            ld_456 = iCustom(NULL, 0, "Heikin_Ashi_Smoothed", 0, 1, 3, 1, 1, li_712);
            ld_464 = iCustom(NULL, 0, "Heikin_Ashi_Smoothed", 0, 1, 3, 1, 2, li_712);
            ld_472 = iCustom(NULL, 0, "Heikin_Ashi_Smoothed", 0, 1, 3, 1, 3, li_712);
         } else {
            ld_448 = li_8;
            ld_456 = li_8;
            ld_464 = li_8;
            ld_472 = li_8;
         }
         if (IndHeikinSmoothed) {
            ls_480 = "HAS ";
            ld_488 = iCustom(NULL, 0, "Heikin_Ashi_Smoothed", MaType1_Heikin, Period1_Heikin, MaType2_Heikin, Period2_Heikin, 0, li_712);
            ld_496 = iCustom(NULL, 0, "Heikin_Ashi_Smoothed", MaType1_Heikin, Period1_Heikin, MaType2_Heikin, Period2_Heikin, 1, li_712);
            ld_504 = iCustom(NULL, 0, "Heikin_Ashi_Smoothed", MaType1_Heikin, Period1_Heikin, MaType2_Heikin, Period2_Heikin, 2, li_712);
            ld_512 = iCustom(NULL, 0, "Heikin_Ashi_Smoothed", MaType1_Heikin, Period1_Heikin, MaType2_Heikin, Period2_Heikin, 3, li_712);
         } else {
            ld_488 = li_8;
            ld_496 = li_8;
            ld_504 = li_8;
            ld_512 = li_8;
         }
         if (IndWPR) {
            ld_520 = iWPR(NULL, 0, PeriodWPR, li_712);
            ls_528 = "WPR ";
         } else {
            ld_520 = li_8;
            UpLimitWPR = li_8;
            DownLimitWPR = li_8;
         }
         if (IndDM) {
            ld_536 = iDeMarker(NULL, 0, PeriodDM, li_712);
            ls_544 = "DeM";
         } else {
            ld_536 = li_8;
            UpLimitDM = li_8;
            DownLimitDM = li_8;
         }
         if (IndParabolicSAR) {
            ld_552 = iSAR(NULL, 0, Step_PSAR, Max_PSAR, li_712);
            ls_560 = "PSAR ";
            ld_568 = iMA(NULL, 0, 1, 0, MODE_LWMA, PRICE_CLOSE, li_712);
         } else {
            ld_552 = li_8;
            ld_568 = li_8;
         }
         if (IndBollinger) {
            ld_576 = iBands(NULL, 0, Period_Bollinger, Deviation_Bollinger, gi_188, PriceType_Bollinger, MODE_LOWER, li_712);
            ld_584 = iBands(NULL, 0, Period_Bollinger, Deviation_Bollinger, gi_188, PriceType_Bollinger, MODE_UPPER, li_712);
            if (!Tag_and_Reverse) ls_592 = "BBand ";
            else
            if (Tag_and_Reverse) ls_592 = "BBand(tag)";
            ld_600 = iMA(NULL, 0, 1, 0, MODE_LWMA, PRICE_CLOSE, li_712);
         } else {
            ld_576 = li_8;
            ld_584 = li_8;
            ld_600 = li_8;
         }
      }
      text_608 = f0_11("");
      ObjectCreate("TitleTextClassic", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("TitleTextClassic", text_608, 10, "Arial Bold", Black);
      ObjectSet("TitleTextClassic", OBJPROP_CORNER, Dashboard_Corner);
      ObjectSet("TitleTextClassic", OBJPROP_XDISTANCE, 5);
      ObjectSet("TitleTextClassic", OBJPROP_YDISTANCE, 3);
      str2time_616 = StrToTime(ls_168 + ls_344 + ls_72 + ls_160);
      if (Display_Build_Info) {
         ObjectCreate("BuildTextMSP", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("BuildTextMSP", f0_5(""), 8, "Arial", Black);
         ObjectSet("BuildTextMSP", OBJPROP_CORNER, 2);
         ObjectSet("BuildTextMSP", OBJPROP_XDISTANCE, 5);
         ObjectSet("BuildTextMSP", OBJPROP_YDISTANCE, 15);
      } else
      if (!Display_Build_Info) ObjectDelete("BuildTextMSP");
      if ((!IndRSI) && !IndCCI && (!IndStoch) && (!IndMACD) && (!IndOsMA) && (!IndMomentum) && (!IndADX) && (!IndATR) && (!IndForce)) ld_620 = 2.0;
      else ld_620 = 1.0;
      if ((!Ind2MACross) && !Ind3MACross && (!IndBollinger) && (!IndParabolicSAR) && (!IndHeikin) && (!IndHeikinSmoothed) && (!IndGator) && (!IndGatorOsc) && (!IndWPR) &&
         (!IndDM)) ld_628 = 2.0;
      else ld_628 = 1.0;
      if (ld_620 == 2.0 && ld_628 == 2.0) ObjectSetText("LoadedIndClassic", ".", 8, "Arial Bold", Black);
      else {
         ObjectSetText("LoadedIndClassic", " " + ls_176 + ls_200 + ls_88 + ls_104 + ls_112 + ls_232 + ls_280 + ls_296 + ls_304 + ls_368 + ls_440 + ls_480 + ls_528 + ls_560 +
            ls_592 + ls_544, 8, "Arial", Black);
      }
      ObjectCreate("LoadedIndClassic", OBJ_LABEL, 0, 0, 0);
      ObjectSet("LoadedIndClassic", OBJPROP_CORNER, Dashboard_Corner);
      ObjectSet("LoadedIndClassic", OBJPROP_XDISTANCE, 5);
      ObjectSet("LoadedIndClassic", OBJPROP_YDISTANCE, 20);
      str2time_636 = StrToTime(ls_168 + ls_344 + ls_72 + ls_160);
      ObjectCreate("LoadedInd2Classic", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("LoadedInd2Classic", " " + ls_336 + ls_352 + ls_144 + ls_400, 8, "Arial", Salmon);
      ObjectSet("LoadedInd2Classic", OBJPROP_CORNER, Dashboard_Corner);
      ObjectSet("LoadedInd2Classic", OBJPROP_XDISTANCE, 5);
      ObjectSet("LoadedInd2Classic", OBJPROP_YDISTANCE, 32);
      ObjectCreate("xBiasClassic", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("xBiasClassic", " " + ls_48, 8, "Arial", color_56);
      ObjectSet("xBiasClassic", OBJPROP_CORNER, Dashboard_Corner);
      ObjectSet("xBiasClassic", OBJPROP_XDISTANCE, 22);
      ObjectSet("xBiasClassic", OBJPROP_YDISTANCE, 101);
      ObjectCreate("xBiasLClassic", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("xBiasLClassic", " " + ls_60, 8, "Arial", color_68);
      ObjectSet("xBiasLClassic", OBJPROP_CORNER, Dashboard_Corner);
      ObjectSet("xBiasLClassic", OBJPROP_XDISTANCE, 22);
      ObjectSet("xBiasLClassic", OBJPROP_YDISTANCE, 119);
      ObjectCreate("xBiasLightClassic", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("xBiasLightClassic", CharToStr(108), 15, "Wingdings", color_56);
      ObjectSet("xBiasLightClassic", OBJPROP_CORNER, Dashboard_Corner);
      ObjectSet("xBiasLightClassic", OBJPROP_XDISTANCE, 5);
      ObjectSet("xBiasLightClassic", OBJPROP_YDISTANCE, 97);
      ObjectCreate("xBiasLighttxtClassic", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("xBiasLighttxtClassic", "S", 8, "Arial Black", Black);
      ObjectSet("xBiasLighttxtClassic", OBJPROP_CORNER, Dashboard_Corner);
      ObjectSet("xBiasLighttxtClassic", OBJPROP_XDISTANCE, 9);
      ObjectSet("xBiasLighttxtClassic", OBJPROP_YDISTANCE, 101);
      ObjectCreate("xBiasLight2Classic", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("xBiasLight2Classic", CharToStr(108), 15, "Wingdings", color_68);
      ObjectSet("xBiasLight2Classic", OBJPROP_CORNER, Dashboard_Corner);
      ObjectSet("xBiasLight2Classic", OBJPROP_XDISTANCE, 5);
      ObjectSet("xBiasLight2Classic", OBJPROP_YDISTANCE, 115);
      ObjectCreate("xBiasLight2txtClassic", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("xBiasLight2txtClassic", "L", 8, "Arial Black", Black);
      ObjectSet("xBiasLight2txtClassic", OBJPROP_CORNER, Dashboard_Corner);
      ObjectSet("xBiasLight2txtClassic", OBJPROP_XDISTANCE, 9);
      ObjectSet("xBiasLight2txtClassic", OBJPROP_YDISTANCE, 119);
      if (TimeCurrent() > str2time_636) return (0);
      if (TimeCurrent() < str2time_636) {
         if (Tag_and_Reverse) ld_640 = 1.0;
         else ld_640 = 0.0;
         lda_648[0] = ld_80;
         lda_648[1] = UpLimitRSI;
         lda_648[2] = DownLimitRSI;
         lda_648[3] = ld_96;
         lda_648[4] = UpLimitCCI;
         lda_648[5] = DownLimitCCI;
         lda_648[6] = ld_152;
         lda_648[7] = UpLimitForce;
         lda_648[8] = DownLimitForce;
         lda_648[9] = ld_120;
         lda_648[10] = ld_128;
         lda_648[11] = ld_136;
         lda_648[12] = UpLimitStoch;
         lda_648[13] = DownLimitStoch;
         lda_648[14] = ld_240;
         lda_648[15] = ld_248;
         lda_648[16] = ld_256;
         lda_648[17] = UpLimitMACD;
         lda_648[18] = DownLimitMACD;
         lda_648[19] = MACDLinesMinDist;
         lda_648[20] = ld_264;
         lda_648[21] = ld_272;
         lda_648[22] = UpLimitOsMA;
         lda_648[23] = DownLimitOsMA;
         lda_648[24] = ld_288;
         lda_648[25] = UpLimitMomentum;
         lda_648[26] = DownLimitMomentum;
         lda_648[27] = ld_312;
         lda_648[28] = MinStrengthADX;
         lda_648[29] = ld_320;
         lda_648[30] = ld_328;
         lda_648[31] = ld_360;
         lda_648[32] = MinStrengthATR;
         lda_648[33] = ld_392;
         lda_648[34] = ld_384;
         lda_648[35] = ld_376;
         lda_648[36] = icustom_416;
         lda_648[37] = icustom_408;
         lda_648[38] = ld_432;
         lda_648[39] = ld_424;
         lda_648[40] = MinStrengthOscillator;
         lda_648[41] = ld_448;
         lda_648[42] = ld_456;
         lda_648[43] = ld_464;
         lda_648[44] = ld_472;
         lda_648[45] = ld_488;
         lda_648[46] = ld_496;
         lda_648[47] = ld_504;
         lda_648[48] = ld_512;
         lda_648[49] = ld_520;
         lda_648[50] = UpLimitWPR;
         lda_648[51] = DownLimitWPR;
         lda_648[52] = ld_552;
         lda_648[53] = ld_568;
         lda_648[54] = ld_576;
         lda_648[55] = ld_584;
         lda_648[56] = ld_600;
         lda_648[57] = ld_536;
         lda_648[58] = UpLimitDM;
         lda_648[59] = DownLimitDM;
         lda_648[60] = ld_184;
         lda_648[61] = ld_192;
         lda_648[62] = ld_208;
         lda_648[63] = ld_216;
         lda_648[64] = ld_224;
         lda_648[65] = ld_640;
         if (!Overbought_Sold_On) {
            ld_652 = f0_6(lda_648);
            if (ld_652 == 1.0) {
               gd_852 = 1;
               gd_860 = 0;
            } else {
               if (ld_652 == 0.0) {
                  gd_852 = 0;
                  gd_860 = 1;
               }
            }
         }
         if (Overbought_Sold_On) {
            ld_660 = f0_3(lda_648);
            if (ld_660 == 1.0) {
               gd_852 = 1;
               gd_860 = 0;
            } else {
               if (ld_660 == 0.0) {
                  gd_852 = 0;
                  gd_860 = 1;
               }
            }
         }
      }
      li_668 = f0_9(gd_868, gd_876, gd_852, gd_860);
      li_672 = f0_0(li_668);
      li_676 = f0_8(li_668);
      if (li_668 == 0) {
         g_ibuf_884[li_712] = Low[li_712] - Arrow_Distance * Point;
         gd_868 = li_672;
         gd_876 = li_676;
      }
      if (li_668 == 1) {
         g_ibuf_888[li_712] = High[li_712] + Arrow_Distance * Point;
         gd_876 = li_676;
         gd_868 = li_672;
      }
      if (li_668 == 2 || li_668 == 3) {
         gd_868 = li_672;
         gd_876 = li_676;
      }
   }
   if (Alert_On) f0_7();
   return (0);
}

// 945D754CB0DC06D04243FCBA25FC0802
void f0_7() {
   string dbl2str_0 = DoubleToStr(g_ibuf_884[1], 2);
   string dbl2str_8 = DoubleToStr(g_ibuf_888[1], 2);
   if (f0_12(dbl2str_0) && gi_892 != Time[0]) {
      if (Alert_PopUp_On) Alert(Symbol() + " M" + Period() + " ", TimeToStr(TimeLocal(), TIME_SECONDS), " BUY");
      PlaySound(f0_2(Buy_Sound));
      gi_892 = Time[0];
      if (Send_Email) {
         SendMail("KLASPROFSignal-bbbtakt!", Symbol() + " M(" + Period() + ") - BUY  signal issued at " + TimeToStr(TimeLocal(), TIME_SECONDS) + " on " + TimeToStr(TimeCurrent(),
            TIME_DATE) + "\r\n \r\n Delivered via KLASPROFSignal-bbbtakt");
      }
   }
   if (f0_1(dbl2str_8) && gi_892 != Time[0]) {
      if (Alert_PopUp_On) Alert(Symbol() + " M" + Period() + " ", TimeToStr(TimeLocal(), TIME_SECONDS), " SELL");
      PlaySound(f0_10(Sell_Sound));
      gi_892 = Time[0];
      if (Send_Email) {
         SendMail("KLASPROFSignal-bbbtakt !", Symbol() + " M(" + Period() + ") - SELL signal issued at " + TimeToStr(TimeLocal(), TIME_SECONDS) + " on " + TimeToStr(TimeCurrent(),
            TIME_DATE) + "\r\n \r\n Delivered via KLASPROFSignal-bbbtakt");
      }
   }
}

// 52D46093050F38C27267BCE42543EF60
void deinit() {
   ObjectDelete("ClassicTitle");
   ObjectDelete("TitleTextClassic");
   ObjectDelete("LoadedIndClassic");
   ObjectDelete("LoadedInd2Classic");
   ObjectDelete("LoadedInd3Classic");
   ObjectDelete("xBiasTitleClassic");
   ObjectDelete("xBiasTitle2Classic");
   ObjectDelete("xBiasLightClassic");
   ObjectDelete("xBiasLighttxtClassic");
   ObjectDelete("xBiasLight2Classic");
   ObjectDelete("xBiasLight2txtClassic");
   ObjectDelete("xBiasClassic");
   ObjectDelete("xBiasLClassic");
   ObjectDelete("CountBars_Limit_Classic");
   ObjectDelete("counttxt_Classic");
   ObjectDelete("countback_Classic");
   ObjectDelete("TitleText");
   ObjectDelete("LoadedInd");
   ObjectDelete("LoadedInd2");
   ObjectDelete("LoadedInd3");
   ObjectDelete("LoadedInd4");
   ObjectDelete("LoadedInd5");
   ObjectDelete("LoadedInd6");
   ObjectDelete("LoadedInd1");
   ObjectDelete("LoadedInd21");
   ObjectDelete("LoadedInd31");
   ObjectDelete("LoadedInd41");
   ObjectDelete("LoadedInd51");
   ObjectDelete("LoadedInd61");
   ObjectDelete("TitleText1");
   ObjectDelete("InvLic");
}

// B289B6F3CC743DEA0697E82B3B06170F
string f0_11(string as_unused_0) {
   return ("");
}

// 88BB6D5235E50DFC957F5A923A425594
string f0_5(string as_unused_0) {
   return (" ()");
}

// AC96E85E29431333294CDC2E48F3FDCE
int f0_9(int ai_0, int ai_4, int ai_8, int ai_12) {
   if (ai_0 || ai_8 != 1) {
      if (!(ai_4 || ai_12 != 1)) return (1);
      if (!(ai_0 != 1 || ai_8 == 1)) return (2);
      if (!(ai_4 != 1 || ai_12 == 1)) return (3);
      return (10);
      return (2);
   }
   return (0);
}

// 04A570AF760F555750B5992675F5CB0B
int f0_0(bool ai_0) {
   if (ai_0) return (0);
   return (1);
}

// 961CE1124F8BD1612875CD56AD05C9AD
int f0_8(bool ai_0) {
   if (ai_0) return (1);
   return (0);
}

// 48B8157867FE240A59CF372176FF94C7
string f0_2(int ai_0) {
   string ls_ret_4;
   switch (ai_0) {
   case 0:
      ls_ret_4 = "buy.wav";
      break;
   case 1:
      ls_ret_4 = "alert.wav";
      break;
   case 2:
      ls_ret_4 = "alert2.wav";
      break;
   case 3:
      ls_ret_4 = "connect.wav";
      break;
   case 4:
      ls_ret_4 = "disconnect.wav";
      break;
   case 5:
      ls_ret_4 = "email.wav";
      break;
   case 6:
      ls_ret_4 = "expert.wav";
      break;
   case 7:
      ls_ret_4 = "news.wav";
      break;
   case 8:
      ls_ret_4 = "ok.wav";
      break;
   case 9:
      ls_ret_4 = "stops.wav";
      break;
   case 10:
      ls_ret_4 = "tick.wav";
      break;
   case 11:
      ls_ret_4 = "timeout.wav";
      break;
   case 12:
      ls_ret_4 = "wait.wav";
      break;
   default:
      ls_ret_4 = "alert.wav";
   }
   return (ls_ret_4);
}

// B0BDCC32318A57C3B89468A1B659841B
string f0_10(int ai_0) {
   string ls_ret_4;
   switch (ai_0) {
   case 0:
      ls_ret_4 = "sell.wav";
      break;
   case 1:
      ls_ret_4 = "alert.wav";
      break;
   case 2:
      ls_ret_4 = "alert2.wav";
      break;
   case 3:
      ls_ret_4 = "connect.wav";
      break;
   case 4:
      ls_ret_4 = "disconnect.wav";
      break;
   case 5:
      ls_ret_4 = "email.wav";
      break;
   case 6:
      ls_ret_4 = "expert.wav";
      break;
   case 7:
      ls_ret_4 = "news.wav";
      break;
   case 8:
      ls_ret_4 = "ok.wav";
      break;
   case 9:
      ls_ret_4 = "stops.wav";
      break;
   case 10:
      ls_ret_4 = "tick.wav";
      break;
   case 11:
      ls_ret_4 = "timeout.wav";
      break;
   case 12:
      ls_ret_4 = "wait.wav";
      break;
   default:
      ls_ret_4 = "alert.wav";
   }
   return (ls_ret_4);
}

// C0D91B7A9C1A90DCB9AB1996F13B6FFD
int f0_12(string as_0) {
   if (StringLen(as_0) != StringLen("2147483647.00")) return (1);
   if (StringLen(as_0) == StringLen("2147483647.00")) return (0);
   return (0);
}

// 0BFB54FC2D2F7CEDFDE0446D9B7E60BD
int f0_1(string as_0) {
   if (StringLen(as_0) != StringLen("2147483647.00")) return (1);
   if (StringLen(as_0) == StringLen("2147483647.00")) return (0);
   return (0);
}

// 5F65777FA3E4F8D42D378804429C5076
int f0_4(double ad_0, double ad_8) {
   if (ad_8 > 0.0 && (ad_0 > 0.2 && ad_0 < 0.8)) return (0);
   if (ad_8 < 0.0 && (ad_0 > 0.2 && ad_0 < 0.8)) return (1);
   if (ad_0 >= 0.8) return (2);
   if (ad_0 <= 0.2) return (3);
   return (0);
}

// D994C3D6F5D685015F23A741A46BC096
int f0_13(double ad_0, double ad_8) {
   if (ad_8 > 0.0 && (ad_0 > 0.35 && ad_0 < 0.65)) return (0);
   if (ad_8 < 0.0 && (ad_0 > 0.35 && ad_0 < 0.65)) return (1);
   if (ad_0 >= 0.65) return (2);
   if (ad_0 <= 0.35) return (3);
   return (0);
}

// 9287587D5B28401CF75E9BD511D80741
double f0_6(double &ada_0[128]) {
   double ld_ret_12;
   double ld_ret_4 = 0.0;
   if (ada_0[1] <= ada_0[0] && ada_0[4] <= ada_0[3] && ada_0[11] <= ada_0[10] && ada_0[12] <= ada_0[9] && ada_0[7] <= ada_0[6] && ada_0[16] <= ada_0[15] && ada_0[17] <= ada_0[14] &&
      ada_0[19] <= ada_0[20] && ada_0[22] <= ada_0[21] && ada_0[25] <= ada_0[24] && ada_0[28] <= ada_0[27] && ada_0[30] <= ada_0[29] && ada_0[32] <= ada_0[31] && ada_0[34] <= ada_0[33] &&
      ada_0[35] <= ada_0[33] && ada_0[36] != 0.0 && ada_0[37] != 0.0 && ada_0[40] <= ada_0[38] && (-1.0 * ada_0[40]) >= ada_0[39] && ada_0[41] <= ada_0[42] && ada_0[43] <= ada_0[44] && ada_0[45] <= ada_0[46] && ada_0[47] <= ada_0[48] && ada_0[50] <= ada_0[49] && ada_0[53] >= ada_0[52] && ada_0[55] <= ada_0[56] && ada_0[58] <= ada_0[57] && ada_0[61] <= ada_0[60] && ada_0[63] <= ada_0[62] && ada_0[64] <= ada_0[63]) {
      ld_ret_12 = 1.0;
      if (ada_0[65] != 1.0) return (ld_ret_12);
      return (ld_ret_4);
   }
   if (ada_0[2] < ada_0[0] || ada_0[5] < ada_0[3] || ada_0[11] < ada_0[10] || ada_0[13] < ada_0[9] || ada_0[8] < ada_0[6] || ada_0[16] < ada_0[15] || ada_0[18] < ada_0[14] ||
      (-1.0 * ada_0[20]) < ada_0[19] || ada_0[23] < ada_0[21] || ada_0[26] < ada_0[24] || ada_0[28] > ada_0[27] || ada_0[30] < ada_0[29] || ada_0[32] > ada_0[31] || ada_0[34] < ada_0[33] ||
      ada_0[35] < ada_0[33] || ada_0[36] == 0.0 || ada_0[37] == 0.0 || (-1.0 * ada_0[40]) < ada_0[39] || ada_0[40] > ada_0[38] || ada_0[41] < ada_0[42] || ada_0[43] < ada_0[44] ||
      ada_0[45] < ada_0[46] || ada_0[47] < ada_0[48] || ada_0[51] < ada_0[49] || ada_0[53] > ada_0[52] || ada_0[54] < ada_0[56] || ada_0[59] < ada_0[57] || ada_0[61] < ada_0[60] ||
      ada_0[63] < ada_0[62] || ada_0[64] < ada_0[63]) return (3.0);
   ld_ret_12 = 1.0;
   if (ada_0[65] == 1.0) return (ld_ret_12);
   return (ld_ret_4);
}

// 56CA002AC0AAF12836AF60140DD721C7
double f0_3(double &ada_0[128]) {
   double ld_ret_4 = 0.0;
   if (ada_0[1] < ada_0[0] || ada_0[4] < ada_0[3] || ada_0[11] > ada_0[10] || ada_0[12] < ada_0[9] || ada_0[7] < ada_0[6] || ada_0[16] > ada_0[15] || ada_0[17] > ada_0[14] ||
      ada_0[19] > ada_0[20] || ada_0[22] > ada_0[21] || ada_0[25] > ada_0[24] || ada_0[28] > ada_0[27] || ada_0[30] > ada_0[29] || ada_0[32] > ada_0[31] || ada_0[34] > ada_0[33] ||
      ada_0[35] > ada_0[33] || ada_0[36] == 0.0 || ada_0[37] == 0.0 || ada_0[40] > ada_0[38] || (-1.0 * ada_0[40]) < ada_0[39] || ada_0[41] > ada_0[42] || ada_0[43] > ada_0[44] ||
      ada_0[45] > ada_0[46] || ada_0[47] > ada_0[48] || ada_0[50] < ada_0[49] || ada_0[53] < ada_0[52] || ada_0[54] < ada_0[56] || ada_0[58] < ada_0[57] || ada_0[61] > ada_0[60] ||
      ada_0[63] > ada_0[62] || ada_0[64] > ada_0[63]) {
      if (ada_0[2] > ada_0[0] || ada_0[5] > ada_0[3] || ada_0[11] < ada_0[10] || ada_0[13] > ada_0[9] || ada_0[8] > ada_0[6] || ada_0[16] < ada_0[15] || ada_0[18] < ada_0[14] ||
         (-1.0 * ada_0[20]) < ada_0[19] || ada_0[23] < ada_0[21] || ada_0[26] < ada_0[24] || ada_0[28] > ada_0[27] || ada_0[30] < ada_0[29] || ada_0[32] > ada_0[31] || ada_0[34] < ada_0[33] ||
         ada_0[35] < ada_0[33] || ada_0[36] == 0.0 || ada_0[37] == 0.0 || (-1.0 * ada_0[40]) < ada_0[39] || ada_0[40] > ada_0[38] || ada_0[41] < ada_0[42] || ada_0[43] < ada_0[44] ||
         ada_0[45] < ada_0[46] || ada_0[47] < ada_0[48] || ada_0[51] > ada_0[49] || ada_0[53] > ada_0[52] || ada_0[55] > ada_0[56] || ada_0[59] > ada_0[57] || ada_0[61] < ada_0[60] ||
         ada_0[63] < ada_0[62] || ada_0[64] < ada_0[63]) ld_ret_4 = 3.0;
   } else ld_ret_4 = 1.0;
   return (ld_ret_4);
}
