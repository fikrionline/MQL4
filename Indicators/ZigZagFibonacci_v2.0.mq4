#property copyright "Copyright © 2012, LHDT"
#property link ""

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Gray

extern string parv = "-------- PARAMS --------";
extern bool enableFiboDraw = TRUE;
bool int88 = FALSE;
extern bool showBuyStopLevel = TRUE;
extern bool showSellStopLevel = TRUE;
extern string colv = "-------- COLORS --------";
extern color FibLongColor = DodgerBlue;
extern color FibMidColor = Fuchsia;
extern color FibShortColor = Red;
extern color FibHighColor = DimGray;
extern color BuyStopColor = DimGray;
extern color SellStopColor = DimGray;
extern string zzv = "-------- ZIG ZAG VALUES --------";
extern int ExtDepth = 13;
extern int ExtDeviation = 5;
extern int ExtBackstep = 5;
extern color lineColor = Black;
int g_color_156 = Blue;
int g_color_160 = Red;
int g_width_164 = 2;
bool intunused_168 = TRUE;
double buf_172[];
double buf_176[];
double buf_180[];
int int184 = 3;
bool int188 = FALSE;
double gda_192[];
double g_price_196;
double gda_204[];
double g_price_208;
int g_bars_216;
string gs_220;
double gd_228;
int int236;
double gd_240;
string gs_248;

// D260618711A08F58FB16134F9730E9FB
void f0_2(string a_text_0, string a_name_8, double a_color_16, double ad_24, double a_x_32) {
   int li_40 = 15;
   ObjectCreate(a_name_8, OBJ_LABEL, 0, 0, 0);
   ObjectSet(a_name_8, OBJPROP_COLOR, a_color_16);
   ObjectSet(a_name_8, OBJPROP_CORNER, 3);
   ObjectSet(a_name_8, OBJPROP_XDISTANCE, a_x_32);
   ObjectSet(a_name_8, OBJPROP_YDISTANCE, ad_24 * li_40);
   ObjectSetText(a_name_8, a_text_0, 10, "Terminal");
}

// E37F0136AA3FFAF149B351F6A4C948E9
int init() {
   IndicatorBuffers(3);
   SetIndexStyle(0, DRAW_SECTION);
   SetIndexBuffer(0, buf_172);
   SetIndexBuffer(1, buf_176);
   SetIndexBuffer(2, buf_180);
   SetIndexEmptyValue(0, 0.0);
   if (Digits == 4 || Digits == 5) gd_240 = 0.0001;
   else
   if (Digits == 2 || Digits == 3) gd_240 = 0.01;
   gs_220 = "LHDT_FIBO";
   IndicatorShortName(gs_220);
   return (0);
}

// 52D46093050F38C27267BCE42543EF60
int deinit() {
   f0_0(gs_220 + "_");
   return (0);
}

// EA2B2676C28C0DB26D39331A336C6B92
int start() {
   double lda_0[10];
   double lda_4[10];
   int index_12;
   int li_20;
   int li_24;
   int li_28;
   int li_40;
   int li_44;
   double ld_56;
   double ld_64;
   double ld_72;
   double ld_80;
   double ld_88;
   double ld_96;
   double price_104;
   double price_112;
   double price_136;
   double price_144;
   int li_152;
   int li_156;
   double price_168;
   double price_176;
   int li_184;
   int li_188;
   ObjectDelete("high");
   ObjectDelete("low");
   int ind_counted_16 = IndicatorCounted();
   if (ind_counted_16 == 0 && int188) {
      ArrayInitialize(buf_172, 0.0);
      ArrayInitialize(buf_176, 0.0);
      ArrayInitialize(buf_180, 0.0);
   }
   if (ind_counted_16 == 0) {
      li_20 = Bars - ExtDepth;
      int188 = TRUE;
   }
   if (ind_counted_16 > 0) {
      while (li_24 < int184 && index_12 < 100) {
         ld_64 = buf_172[index_12];
         if (ld_64 != 0.0) li_24++;
         index_12++;
      }
      index_12--;
      li_20 = index_12;
      if (buf_180[index_12] != 0.0) {
         ld_72 = buf_180[index_12];
         li_28 = 1;
      } else {
         ld_80 = buf_176[index_12];
         li_28 = -1;
      }
      for (index_12 = li_20 - 1; index_12 >= 0; index_12--) {
         buf_172[index_12] = 0.0;
         buf_180[index_12] = 0.0;
         buf_176[index_12] = 0.0;
      }
   }
   for (int li_32 = li_20; li_32 >= 0; li_32--) {
      ld_56 = Low[iLowest(NULL, 0, MODE_LOW, ExtDepth, li_32)];
      if (ld_56 == ld_96) ld_56 = 0.0;
      else {
         ld_96 = ld_56;
         if (Low[li_32] - ld_56 > ExtDeviation * Point) ld_56 = 0.0;
         else {
            for (int li_36 = 1; li_36 <= ExtBackstep; li_36++) {
               ld_64 = buf_180[li_32 + li_36];
               if (ld_64 != 0.0 && ld_64 > ld_56) buf_180[li_32 + li_36] = 0.0;
            }
         }
      }
      if (Low[li_32] == ld_56) buf_180[li_32] = ld_56;
      else buf_180[li_32] = 0.0;
      ld_56 = High[iHighest(NULL, 0, MODE_HIGH, ExtDepth, li_32)];
      if (ld_56 == ld_88) ld_56 = 0.0;
      else {
         ld_88 = ld_56;
         if (ld_56 - High[li_32] > ExtDeviation * Point) ld_56 = 0.0;
         else {
            for (li_36 = 1; li_36 <= ExtBackstep; li_36++) {
               ld_64 = buf_176[li_32 + li_36];
               if (ld_64 != 0.0 && ld_64 < ld_56) buf_176[li_32 + li_36] = 0.0;
            }
         }
      }
      if (High[li_32] == ld_56) buf_176[li_32] = ld_56;
      else buf_176[li_32] = 0.0;
   }
   if (li_28 == 0) {
      ld_96 = 0;
      ld_88 = 0;
   } else {
      ld_96 = ld_72;
      ld_88 = ld_80;
   }
   for (li_32 = li_20; li_32 >= 0; li_32--) {
      ld_64 = 0.0;
      switch (li_28) {
      case 0:
         if (!(ld_96 == 0.0 && ld_88 == 0.0)) break;
         if (buf_176[li_32] != 0.0) {
            ld_88 = High[li_32];
            li_40 = li_32;
            li_28 = -1;
            buf_172[li_32] = ld_88;
            ld_64 = 1;
            gda_192[index_12] = ld_88;
         }
         if (buf_180[li_32] == 0.0) break;
         ld_96 = Low[li_32];
         li_44 = li_32;
         li_28 = 1;
         buf_172[li_32] = ld_96;
         ld_64 = 1;
         gda_204[index_12] = ld_96;
         break;
      case 1:
         if (buf_180[li_32] != 0.0 && buf_180[li_32] < ld_96 && buf_176[li_32] == 0.0) {
            buf_172[li_44] = 0.0;
            li_44 = li_32;
            ld_96 = buf_180[li_32];
            buf_172[li_32] = ld_96;
            ld_64 = 1;
         }
         if (!(buf_176[li_32] != 0.0 && buf_180[li_32] == 0.0)) break;
         ld_88 = buf_176[li_32];
         li_40 = li_32;
         buf_172[li_32] = ld_88;
         li_28 = -1;
         ld_64 = 1;
         break;
      case -1:
         if (buf_176[li_32] != 0.0 && buf_176[li_32] > ld_88 && buf_180[li_32] == 0.0) {
            buf_172[li_40] = 0.0;
            li_40 = li_32;
            ld_88 = buf_176[li_32];
            buf_172[li_32] = ld_88;
         }
         if (!(buf_180[li_32] != 0.0 && buf_176[li_32] == 0.0)) break;
         ld_96 = buf_180[li_32];
         li_44 = li_32;
         buf_172[li_32] = ld_96;
         li_28 = 1;
         break;
      default:
         return /*(WARN)*/;
      }
   }
   int index_8 = 0;
   for (index_12 = 0; index_12 < Bars; index_12++) {
      if (buf_172[index_12] != 0.0) {
         lda_0[index_8] = buf_172[index_12];
         lda_4[index_8] = index_12;
         index_8++;
         if (index_8 == 10) break;
      }
   }
   f0_2("Last swing range : " + DoubleToStr(MathAbs((lda_0[1] - lda_0[2]) / 10.0) / Point, 1) + " pips", gs_220 + "_" + "range", Gray, 1, 50);
   if (lda_0[1] > lda_0[2]) {
      g_price_196 = lda_0[1];
      li_40 = lda_4[1];
      g_price_208 = lda_0[2];
      li_44 = lda_4[2];
      price_104 = g_price_196;
      price_112 = g_price_208;
   } else {
      g_price_196 = lda_0[2];
      li_40 = lda_4[2];
      g_price_208 = lda_0[1];
      li_44 = lda_4[1];
      price_104 = g_price_196;
      price_112 = g_price_208;
   }
   if (int88) {
      ObjectCreate(gs_220 + "_" + "high", OBJ_TREND, 0, Time[li_40], g_price_196, Time[0], g_price_196);
      ObjectSet(gs_220 + "_" + "high", OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(gs_220 + "_" + "high", OBJPROP_COLOR, g_color_156);
      ObjectSet(gs_220 + "_" + "high", OBJPROP_WIDTH, g_width_164);
      ObjectSet(gs_220 + "_" + "high", OBJPROP_RAY, TRUE);
      ObjectSet(gs_220 + "_" + "high", OBJPROP_BACK, TRUE);
      ObjectCreate(gs_220 + "_" + "low", OBJ_TREND, 0, Time[li_44], g_price_208, Time[0], g_price_208);
      ObjectSet(gs_220 + "_" + "low", OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(gs_220 + "_" + "low", OBJPROP_COLOR, g_color_160);
      ObjectSet(gs_220 + "_" + "low", OBJPROP_WIDTH, g_width_164);
      ObjectSet(gs_220 + "_" + "low", OBJPROP_RAY, TRUE);
      ObjectSet(gs_220 + "_" + "low", OBJPROP_BACK, TRUE);
   }
   int li_48 = lda_4[0];
   int li_52 = lda_4[1];
   if (High[li_48] > High[li_52]) {
      price_136 = High[li_48];
      price_144 = Low[li_52];
      li_152 = li_48;
      li_156 = li_52;
      gs_248 = "down";
   } else {
      price_136 = High[li_52];
      price_144 = Low[li_48];
      li_152 = li_52;
      li_156 = li_48;
      gs_248 = "up";
   }
   double ld_160 = price_136 - price_144;
   if (price_104 - price_112 > ld_160) {
      li_184 = li_40;
      price_168 = price_104;
      li_188 = li_44;
      price_176 = price_112;
      gs_248 = "down";
   } else {
      li_184 = li_152;
      price_168 = price_136;
      li_188 = li_156;
      price_176 = price_144;
      gs_248 = "up";
   }
   if (Time[li_188] < Time[li_184]) gs_248 = "up";
   else gs_248 = "down";
   if (g_bars_216 != Bars) {
      if (enableFiboDraw) {
         if (li_188 > li_184) int236 = Time[li_188];
         else int236 = Time[li_184];
         ObjectDelete(gs_220 + "_fibline");
         ObjectCreate(gs_220 + "_fibline", OBJ_TREND, 0, Time[li_188], price_176, Time[li_184], price_168);
         ObjectSet(gs_220 + "_fibline", OBJPROP_COLOR, Yellow);
         ObjectSet(gs_220 + "_fibline", OBJPROP_WIDTH, 1);
         ObjectSet(gs_220 + "_fibline", OBJPROP_RAY, FALSE);
         ObjectSet(gs_220 + "_fibline", OBJPROP_BACK, FALSE);
         ObjectSet(gs_220 + "_fibline", OBJPROP_STYLE, STYLE_SOLID);
         if (gs_248 == "up") {
            gd_228 = price_168 - 0.0 * (price_168 - price_176);
            f0_1(gd_228, "SWING HIGH TP1 0.00", int236, FibLongColor, 0, 1);
            gd_228 = price_168 - 0.236 * (price_168 - price_176);
            f0_1(gd_228, "23.6", int236, FibLongColor, 0, 1);
            gd_228 = price_168 - (price_168 - price_176) / 2.0;
            f0_1(gd_228, "BUY 38.2", int236, FibLongColor, 0, 1);
            gd_228 = price_168 - (price_168 - price_176) / 2.0;
            f0_1(gd_228, "50", int236, FibMidColor, 0, 1);
            gd_228 = price_168 - 0.618 * (price_168 - price_176);
            f0_1(gd_228, "SELL 61.8", int236, FibShortColor, 0, 1);
            gd_228 = price_168 - 0.764 * (price_168 - price_176);
            f0_1(gd_228, "76.4", int236, FibShortColor, 0, 1);
            gd_228 = price_168 - 1.0 * (price_168 - price_176);
            f0_1(gd_228, "SWING LOW TP1 100.00", int236, FibShortColor, 0, 1);
            gd_228 = price_168 - 1.236 * (price_168 - price_176);
            f0_1(gd_228, "TP2 123.6", int236, FibHighColor, 0, 1);
            gd_228 = price_168 - 1.382 * (price_168 - price_176);
            f0_1(gd_228, "TP3 138.2", int236, FibHighColor, 0, 1);
            gd_228 = price_168 - 1.618 * (price_168 - price_176);
            f0_1(gd_228, "TP4 161.8", int236, FibHighColor, 0, 1);
            gd_228 = price_168 - (-0.236 * (price_168 - price_176));
            f0_1(gd_228, "TP2 -0.236", int236, FibHighColor, 0, 1);
            gd_228 = price_168 - (-0.382 * (price_168 - price_176));
            f0_1(gd_228, "TP3 -0.382", int236, FibHighColor, 0, 1);
            gd_228 = price_168 - (-0.618 * (price_168 - price_176));
            f0_1(gd_228, "TP4 -0.618", int236, FibHighColor, 0, 1);
            if (showBuyStopLevel) {
               gd_228 = price_168 - (price_168 - price_176) / 2.0 + 1.0 * gd_240;
               f0_1(gd_228, "BUY STOP ", int236, BuyStopColor, 1, 0);
            }
            if (showSellStopLevel) {
               gd_228 = price_168 - 0.618 * (price_168 - price_176) - 1.0 * gd_240;
               f0_1(gd_228, "SELL STOP ", int236, SellStopColor, 1, 0);
            }
         } else {
            gd_228 = price_168 - 0.0 * (price_168 - price_176);
            f0_1(gd_228, "SWING HIGH TP1 100.00", int236, FibLongColor, 0, 1);
            gd_228 = price_168 - 0.236 * (price_168 - price_176);
            f0_1(gd_228, "76.4", int236, FibLongColor, 0, 1);
            gd_228 = price_168 - (price_168 - price_176) / 2.0;
            f0_1(gd_228, "BUY 61.8", int236, FibLongColor, 0, 1);
            gd_228 = price_168 - (price_168 - price_176) / 2.0;
            f0_1(gd_228, "50", int236, FibMidColor, 0, 1);
            gd_228 = price_168 - 0.618 * (price_168 - price_176);
            f0_1(gd_228, "SELL 32.8", int236, FibShortColor, 0, 1);
            gd_228 = price_168 - 0.764 * (price_168 - price_176);
            f0_1(gd_228, "23.6", int236, FibShortColor, 0, 1);
            gd_228 = price_168 - 1.0 * (price_168 - price_176);
            f0_1(gd_228, "SWING LOW TP1 0.00", int236, FibShortColor, 0, 1);
            gd_228 = price_168 - 1.236 * (price_168 - price_176);
            f0_1(gd_228, "TP2 -0.236", int236, FibHighColor, 0, 1);
            gd_228 = price_168 - 1.382 * (price_168 - price_176);
            f0_1(gd_228, "TP3 138.2", int236, FibHighColor, 0, 1);
            gd_228 = price_168 - 1.618 * (price_168 - price_176);
            f0_1(gd_228, "TP4 -0.618", int236, FibHighColor, 0, 1);
            gd_228 = price_168 - (-0.236 * (price_168 - price_176));
            f0_1(gd_228, "TP2 123.6", int236, FibHighColor, 0, 1);
            gd_228 = price_168 - (-0.382 * (price_168 - price_176));
            f0_1(gd_228, "TP3 -0.382", int236, FibHighColor, 0, 1);
            gd_228 = price_168 - (-0.618 * (price_168 - price_176));
            f0_1(gd_228, "TP4 161.8", int236, FibHighColor, 0, 1);
            if (showBuyStopLevel) {
               gd_228 = price_168 - (price_168 - price_176) / 2.0 + 1.0 * gd_240;
               f0_1(gd_228, "BUY STOP ", int236, BuyStopColor, 1, 0);
            }
            if (showSellStopLevel) {
               gd_228 = price_168 - 0.618 * (price_168 - price_176) - 1.0 * gd_240;
               f0_1(gd_228, "SELL STOP ", int236, SellStopColor, 1, 0);
            }
         }
      }
      g_bars_216 = Bars;
   }
   return (0);
}

// 9995995BA1A1432669AC0242DFA67D5D
void f0_1(double a_price_0, string as_8, double a_datetime_16, color a_color_24, int ai_28, int ai_32) {
   ObjectDelete(gs_220 + "_" + as_8);
   ObjectCreate(gs_220 + "_" + as_8, OBJ_TREND, 0, a_datetime_16, a_price_0, Time[0], a_price_0);
   if (ai_28 == 1) ObjectSet(gs_220 + "_" + as_8, OBJPROP_STYLE, STYLE_DOT);
   else ObjectSet(gs_220 + "_" + as_8, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSet(gs_220 + "_" + as_8, OBJPROP_COLOR, a_color_24);
   ObjectSet(gs_220 + "_" + as_8, OBJPROP_WIDTH, 1);
   ObjectSet(gs_220 + "_" + as_8, OBJPROP_RAY, TRUE);
   ObjectSet(gs_220 + "_" + as_8, OBJPROP_BACK, FALSE);
   if (ai_32 == 1) {
      ObjectDelete(gs_220 + "_" + as_8 + "_label");
      ObjectCreate(gs_220 + "_" + as_8 + "_label", OBJ_TEXT, 0, Time[0], a_price_0);
      ObjectSetText(gs_220 + "_" + as_8 + "_label", as_8 + "      " + DoubleToStr(a_price_0, Digits), 8, "Arial", a_color_24);
   }
}

// 3B6B0C1FF666CC49A2DCBDC950C224CE
void f0_0(string as_0) {
   string name_16;
   int str_len_8 = StringLen(as_0);
   int li_12 = 0;
   while (li_12 < ObjectsTotal()) {
      name_16 = ObjectName(li_12);
      if (StringSubstr(name_16, 0, str_len_8) != as_0) {
         li_12++;
         continue;
      }
      ObjectDelete(name_16);
   }
}
