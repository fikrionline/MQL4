#property copyright "dd"
#property link "dd"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 clrRed

extern int nb_swing = 5;

//---- indicator parameters
int ExtDepth = 15;
int ExtDeviation = 5;
int ExtBackstep = 3;
//---- indicator buffers
double ZigzagBuffer[];
double HighMapBuffer[];
double LowMapBuffer[];
int level = 3;
bool downloadhistory = true;
double Pip;
bool Started = False;
color couleur = clrAqua;
double tableau_swing_haut[500];
double tableau_swing_bas[500];
double tableau_swing_haut_temps[500];
double tableau_swing_bas_temps[500];
double sum_haut, sum_bas, sum_haut_temps, sum_bas_temps;
int cpt_haut, cpt_bas;
int nb_h5, nb_h10, nb_h15, nb_h20, nb_h25, nb_h30, nb_h35, nb_hsup35;
int nb_b5, nb_b10, nb_b15, nb_b20, nb_b25, nb_b30, nb_b35, nb_bsup35;
double plus_grand_swing_bull, plus_petit_swing_bull, plus_grand_swing_bear, plus_petit_swing_bear;
int swing_haut = 0, swing_bas = 0;

int cpt_swing;
double tempo_valeur;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init() {
   IndicatorBuffers(3);
   SetIndexStyle(0, DRAW_SECTION, EMPTY, 1, couleur);
   SetIndexBuffer(0, ZigzagBuffer);
   SetIndexBuffer(1, HighMapBuffer);
   SetIndexBuffer(2, LowMapBuffer);
   SetIndexEmptyValue(0, 0.0);

   IndicatorShortName("ZigZag(" + ExtDepth + "," + ExtDeviation + "," + ExtBackstep + ")");
   if (Digits == 3 || Digits == 5)
      Pip = 10 * Point;
   else
      Pip = Point;
   return (0);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit() {
   DelObj();
   ObjectsDeleteAll();
   return (0);
}

void DelObj() {
   string ObjName;
   for (int i = ObjectsTotal() - 1; i >= 0; i--) {
      ObjName = ObjectName(i);
      if (StringFind(ObjName, "ZZLabel", 0) >= 0)
         ObjectDelete(ObjName);
   }
   ObjectDelete("tableau_swing");
   return;
}

int start() {
   int i, counted_bars = IndicatorCounted();

   int limit, counterZ, whatlookfor;
   int shift, back, lasthighpos, lastlowpos;
   double val, res;
   double curlow, curhigh, lasthigh, lastlow;

   if (counted_bars == 0 && downloadhistory) // history was downloaded
   {
      ArrayInitialize(ZigzagBuffer, 0.0);
      ArrayInitialize(HighMapBuffer, 0.0);
      ArrayInitialize(LowMapBuffer, 0.0);
   }
   if (counted_bars == 0) {
      limit = Bars - ExtDepth;
      downloadhistory = true;
   }
   if (counted_bars > 0) {
      while (counterZ < level && i < 100) {
         res = ZigzagBuffer[i];
         if (res != 0)
            counterZ++;
         i++;
      }
      i--;
      limit = i;
      if (LowMapBuffer[i] != 0) {
         curlow = LowMapBuffer[i];
         whatlookfor = 1;
      } else {
         curhigh = HighMapBuffer[i];
         whatlookfor = -1;
      }
      for (i = limit - 1; i >= 0; i--) {
         ZigzagBuffer[i] = 0.0;
         LowMapBuffer[i] = 0.0;
         HighMapBuffer[i] = 0.0;
      }
   }

   for (shift = limit; shift >= 0; shift--) {
      val = Low[iLowest(NULL, 0, MODE_LOW, ExtDepth, shift)];
      if (val == lastlow)
         val = 0.0;
      else {
         lastlow = val;
         if ((Low[shift] - val) > (ExtDeviation * Point))
            val = 0.0;
         else {
            for (back = 1; back <= ExtBackstep; back++) {
               res = LowMapBuffer[shift + back];
               if ((res != 0) && (res > val))
                  LowMapBuffer[shift + back] = 0.0;
            }
         }
      }
      if (Low[shift] == val)
         LowMapBuffer[shift] = val;
      else
         LowMapBuffer[shift] = 0.0;
      //--- high
      val = High[iHighest(NULL, 0, MODE_HIGH, ExtDepth, shift)];
      if (val == lasthigh)
         val = 0.0;
      else {
         lasthigh = val;
         if ((val - High[shift]) > (ExtDeviation * Point))
            val = 0.0;
         else {
            for (back = 1; back <= ExtBackstep; back++) {
               res = HighMapBuffer[shift + back];
               if ((res != 0) && (res < val))
                  HighMapBuffer[shift + back] = 0.0;
            }
         }
      }
      if (High[shift] == val)
         HighMapBuffer[shift] = val;
      else
         HighMapBuffer[shift] = 0.0;
   }

   if (whatlookfor == 0) {
      lastlow = 0;
      lasthigh = 0;
   } else {
      lastlow = curlow;
      lasthigh = curhigh;
   }
   for (shift = limit; shift >= 0; shift--) {
      res = 0.0;
      bool OutOfForLoop = False;
      switch (whatlookfor) {
      case 0:
         if (lastlow == 0 && lasthigh == 0) {
            if (HighMapBuffer[shift] != 0) {
               lasthigh = High[shift];
               lasthighpos = shift;
               whatlookfor = -1;
               ZigzagBuffer[shift] = lasthigh;
               res = 1;
            }
            if (LowMapBuffer[shift] != 0) {
               lastlow = Low[shift];
               lastlowpos = shift;
               whatlookfor = 1;
               ZigzagBuffer[shift] = lastlow;
               res = 1;
            }
         }
         break;
      case 1:
         if (LowMapBuffer[shift] != 0.0 && LowMapBuffer[shift] < lastlow && HighMapBuffer[shift] == 0.0) {
            ZigzagBuffer[lastlowpos] = 0.0;
            lastlowpos = shift;
            lastlow = LowMapBuffer[shift];
            ZigzagBuffer[shift] = lastlow;
            res = 1;
         }
         if (HighMapBuffer[shift] != 0.0 && LowMapBuffer[shift] == 0.0) {
            lasthigh = HighMapBuffer[shift];
            lasthighpos = shift;
            ZigzagBuffer[shift] = lasthigh;
            whatlookfor = -1;
            res = 1;
         }
         break;
      case -1:
         if (HighMapBuffer[shift] != 0.0 && HighMapBuffer[shift] > lasthigh && LowMapBuffer[shift] == 0.0) {
            ZigzagBuffer[lasthighpos] = 0.0;
            lasthighpos = shift;
            lasthigh = HighMapBuffer[shift];
            ZigzagBuffer[shift] = lasthigh;
         }
         if (LowMapBuffer[shift] != 0.0 && HighMapBuffer[shift] == 0.0) {
            lastlow = LowMapBuffer[shift];
            lastlowpos = shift;
            ZigzagBuffer[shift] = lastlow;
            whatlookfor = 1;
         }
         break;
      default:
         OutOfForLoop = True;
      }
      if (OutOfForLoop)
         break;
   }
   //////////////////
   if (counted_bars < 1) {
      DelObj();
      limit = 10000;
   } else
      limit = 0;
   for (i = limit; i >= 0; i--) {
      int k = i;
      double zz;
      double d1 = 0, d2 = 0, d3 = 0;
      datetime t1 = 0, t2 = 0, t3 = 0;
      while (k < Bars - 2) {
         zz = ZigzagBuffer[k];

         if (zz != 0) {
            d1 = d2;
            d2 = d3;
            d3 = zz;
            t1 = t2;
            t2 = t3;
            t3 = Time[k];
         }
         if (d1 > 0)
            break;
         k++;
      }
      if (d1 == 0)
         continue;
      double LabelPos;
      int ib = iBarShift(NULL, 0, t1);
      int ib2 = iBarShift(NULL, 0, t2);
      if (d1 > d2)
         LabelPos = NormalizeDouble(High[ib] + 0.5 * iATR(NULL, 0, 10, ib), Digits);
      else
         LabelPos = Low[ib];
      string ObjName = "ZZLabel_Leg1";
      if (ObjectFind(ObjName) < 0)
         ObjectCreate(ObjName, OBJ_TEXT, 0, t1, LabelPos);
      else

         ObjectMove(ObjName, 0, t1, LabelPos);
      ObjectSetText(ObjName, DoubleToStr(MathAbs(d2 - d1) / Pip, 1) + "/" + DoubleToStr(MathAbs(ib - ib2), 0), 10, "Arial", Yellow);

      //////////////////////
      if (i == 0) {
         LabelPos = Close[0];
         ObjName = "ZZLabel_Bid";
         int rOffset = 5 * Period() * 60;
         if (ObjectFind(ObjName) < 0)
            ObjectCreate(ObjName, OBJ_TEXT, 0, Time[0] + rOffset, LabelPos);
         else
            ObjectMove(ObjName, 0, Time[0] + rOffset, LabelPos);
         ObjectSetText(ObjName, DoubleToStr(MathAbs(Close[0] - d1) / Pip, 1), 10, "Arial", Yellow);
      }
      //////////////////////
      ib = iBarShift(NULL, 0, t2);
      ib2 = iBarShift(NULL, 0, t3);
      if (d2 > d3)
         LabelPos = NormalizeDouble(High[ib] + 0.5 * iATR(NULL, 0, 10, ib), Digits);
      else
         LabelPos = Low[ib];
      ObjName = "ZZLabel" + t1;
      if (ObjectFind(ObjName) < 0) {
         ObjectCreate(ObjName, OBJ_TEXT, 0, t2, LabelPos);
         ObjectSetText(ObjName, DoubleToStr(MathAbs(d3 - d2) / Pip, 1) + "/" + DoubleToStr(MathAbs(ib - ib2), 0), 10, "Arial", Yellow);
         //  Print("  DoubleToStr(MathAbs(d3-d2)/Pip,1)  ", DoubleToStr(MathAbs(d3-d2)/Pip,1));

         if (d2 > d3 && swing_haut - swing_bas < 1)

         {
            tableau_swing_haut[swing_haut] = MathAbs(d3 - d2) / Pip;
            tableau_swing_haut_temps[swing_haut] = MathAbs(ib - ib2);

            swing_haut++;
         }

         if (d3 > d2 && swing_bas - swing_haut < 1)

         {
            tableau_swing_bas[swing_bas] = MathAbs(d3 - d2) / Pip;
            tableau_swing_bas_temps[swing_bas] = MathAbs(ib - ib2);

            swing_bas++;
         }
      }
   }

   int a = 0;
   int b = 0;

   RefreshRates();

   sum_haut = 0;
   sum_haut_temps = 0;
   cpt_haut = swing_haut;
   nb_h5 = 0;
   nb_h10 = 0;
   nb_h15 = 0;
   nb_h20 = 0;
   nb_h25 = 0;
   nb_h30 = 0;
   nb_h35 = 0;
   nb_hsup35 = 0;
   plus_grand_swing_bull = 0;
   plus_petit_swing_bull = 99990;

   for (int par = a; par < nb_swing; par++) {
      if (tableau_swing_haut[swing_haut - par] > plus_grand_swing_bull)
         plus_grand_swing_bull = tableau_swing_haut[swing_haut - par];
      if (tableau_swing_haut[swing_haut - par] < plus_petit_swing_bull && tableau_swing_haut[swing_haut - par] > 0)
         plus_petit_swing_bull = tableau_swing_haut[swing_haut - par];

      if (tableau_swing_haut[swing_haut - par] < 5)
         nb_h5++;
      if (tableau_swing_haut[swing_haut - par] >= 5 && tableau_swing_haut[swing_haut - par] < 10)
         nb_h10++;
      if (tableau_swing_haut[swing_haut - par] >= 10 && tableau_swing_haut[swing_haut - par] < 15)
         nb_h15++;
      if (tableau_swing_haut[swing_haut - par] >= 15 && tableau_swing_haut[swing_haut - par] < 20)
         nb_h20++;
      if (tableau_swing_haut[swing_haut - par] >= 20 && tableau_swing_haut[swing_haut - par] < 25)
         nb_h25++;
      if (tableau_swing_haut[swing_haut - par] >= 25 && tableau_swing_haut[swing_haut - par] < 30)
         nb_h30++;
      if (tableau_swing_haut[swing_haut - par] >= 30 && tableau_swing_haut[swing_haut - par] < 35)
         nb_h35++;
      if (tableau_swing_haut[swing_haut - par] >= 35)
         nb_hsup35++;

      sum_haut += tableau_swing_haut[swing_haut - par];
      sum_haut_temps += tableau_swing_haut_temps[swing_haut - par];
   }

   RefreshRates();
   sum_bas = 0;
   sum_bas_temps = 0;
   cpt_bas = swing_bas;
   nb_b5 = 0;
   nb_b10 = 0;
   nb_b15 = 0;
   nb_b20 = 0;
   nb_b25 = 0;
   nb_b30 = 0;
   nb_b35 = 0;
   nb_bsup35 = 0;
   plus_grand_swing_bear = 0;
   plus_petit_swing_bear = 99990;

   for (int par1 = b; par1 < nb_swing; par1++) {
      if (tableau_swing_bas[swing_bas - par1] > plus_grand_swing_bear)
         plus_grand_swing_bear = tableau_swing_bas[swing_bas - par1];
      if (tableau_swing_bas[swing_bas - par1] < plus_petit_swing_bear && tableau_swing_bas[swing_bas - par1] > 0)
         plus_petit_swing_bear = tableau_swing_bas[swing_bas - par1];

      if (tableau_swing_bas[swing_bas - par1] < 5)
         nb_b5++;
      if (tableau_swing_bas[swing_bas - par1] >= 5 && tableau_swing_bas[swing_bas - par1] < 10)
         nb_b10++;
      if (tableau_swing_bas[swing_bas - par1] >= 10 && tableau_swing_bas[swing_bas - par1] < 15)
         nb_b15++;
      if (tableau_swing_bas[swing_bas - par1] >= 15 && tableau_swing_bas[swing_bas - par1] < 20)
         nb_b20++;
      if (tableau_swing_bas[swing_bas - par1] >= 20 && tableau_swing_bas[swing_bas - par1] < 25)
         nb_b25++;

      if (tableau_swing_bas[swing_bas - par1] >= 25 && tableau_swing_bas[swing_bas - par1] < 30)
         nb_b30++;
      if (tableau_swing_bas[swing_bas - par1] >= 30 && tableau_swing_bas[swing_bas - par1] < 35)
         nb_b35++;
      if (tableau_swing_bas[swing_bas - par1] >= 35)
         nb_bsup35++;

      sum_bas += tableau_swing_bas[swing_bas - par1];
      sum_bas_temps += tableau_swing_bas_temps[swing_bas - par1];
   }
   //***********************************************************************************************

   if (swing_bas > 25 && swing_haut > 25 && par1 > 0 && par > 0) {
      double tempo_temps = 100 / (sum_bas_temps + sum_haut_temps);
      double tempo_h = 100 / (sum_bas + sum_haut);
      double tempo_percent_swing = 100 / ((nb_swing));

      affiche("info_menu", "Stat " + nb_swing + " Derniers swings", 15, "Arial Black", Red, 0, 280, 90);
      //affiche("info_menu1", "Stat " + nb_swing + " Derniers swings", 15, "Arial Black", Silver, 0, 281, 93);

      affiche("info_a", "SUM", 11, "Arial Black", CadetBlue, 0, 250, 120);
      affiche("info_b", "MOY", 11, "Arial Black", CadetBlue, 0, 310, 120);
      affiche("info_c", "PCT", 11, "Arial Black", CadetBlue, 0, 370, 120);

      affiche("info_d", "TPS", 11, "Arial Black", CadetBlue, 0, 430, 120);
      affiche("info_e", "MOY", 11, "Arial Black", CadetBlue, 0, 490, 120);
      affiche("info_f", "PCT", 11, "Arial Black", CadetBlue, 0, 550, 120);

      affiche("info_g", DoubleToStr(sum_haut, 0), 10, "Arial Black", symcolor1(sum_haut, sum_bas), 0, 250, 140);
      affiche("info_h", DoubleToStr(sum_haut / par1, 1), 10, "Arial Black", symcolor1(sum_haut / par1, sum_bas / par), 0, 310, 140);
      affiche("info_i", DoubleToStr(tempo_h * sum_haut, 1), 10, "Arial Black", symcolor(tempo_h * sum_haut), 0, 370, 140);

      affiche("info_j", DoubleToStr(sum_haut_temps, 0), 10, "Arial Black", symcolor1(sum_haut_temps, sum_bas_temps), 0, 430, 140);
      affiche("info_k", DoubleToStr(sum_haut_temps / par1, 1), 10, "Arial Black", symcolor1(sum_haut_temps / par1, sum_bas_temps / par), 0, 490, 140);
      affiche("info_l", DoubleToStr(tempo_temps * sum_haut_temps, 1), 10, "Arial Black", symcolor(tempo_temps * sum_haut_temps), 0, 550, 140);

      affiche("info_m", DoubleToStr(sum_bas, 0), 10, "Arial Black", symcolor1(sum_bas, sum_haut), 0, 250, 160);
      affiche("info_n", DoubleToStr(sum_bas / par, 1), 10, "Arial Black", symcolor1(sum_bas / par, sum_haut / par1), 0, 310, 160);
      affiche("info_o", DoubleToStr(tempo_h * sum_bas, 1), 10, "Arial Black", symcolor(tempo_h * sum_bas), 0, 370, 160);

      affiche("info_p", DoubleToStr(sum_bas_temps, 0), 10, "Arial Black", symcolor1(sum_bas_temps, sum_haut_temps), 0, 430, 160);
      affiche("info_q", DoubleToStr(sum_bas_temps / par, 1), 10, "Arial Black", symcolor1(sum_bas_temps / par, sum_haut_temps / par1), 0, 490, 160);
      affiche("info_r", DoubleToStr(tempo_temps * sum_bas_temps, 1), 10, "Arial Black", symcolor(tempo_temps * sum_bas_temps), 0, 550, 160);

      affiche("info1", "SW H", 11, "Arial Black", Yellow, 0, 175, 140);

      affiche("info2", "SW B", 11, "Arial Black", Yellow, 0, 175, 160);

      affiche("line", "-------------------------------------", 20, "Arial Black", Red, 0, 250, 165);

      affiche("info3", "SW H %", 11, "Arial Black", Yellow, 0, 175, 220);

      affiche("info4", "SW B %", 11, "Arial Black", Yellow, 0, 175, 240);
      affiche("info4a", "PIPS", 11, "Arial Black", White, 0, 175, 200);

      affiche("info_5", "5", 11, "Arial Black", CadetBlue, 0, 250, 200);
      affiche("info_6", "10", 11, "Arial Black", CadetBlue, 0, 290, 200);
      affiche("info_7", "15", 11, "Arial Black", CadetBlue, 0, 330, 200);
      affiche("info_8", "20", 11, "Arial Black", CadetBlue, 0, 370, 200);
      affiche("info_9", "25", 11, "Arial Black", CadetBlue, 0, 410, 200);
      affiche("info_10", "30", 11, "Arial Black", CadetBlue, 0, 450, 200);
      affiche("info_11", "35", 11, "Arial Black", CadetBlue, 0, 490, 200);
      affiche("info_12", ">35", 11, "Arial Black", CadetBlue, 0, 550, 200);

      //**********************************************************

      if (nb_h5 * tempo_percent_swing > 0)
         affiche("info_13", DoubleToStr(nb_h5 * tempo_percent_swing, 0), 11, "Arial Black", symcolor(nb_h5 * tempo_percent_swing), 0, 250, 220);
      if (nb_h10 * tempo_percent_swing > 0)
         affiche("info_14", DoubleToStr(nb_h10 * tempo_percent_swing, 0), 11, "Arial Black", symcolor(nb_h10 * tempo_percent_swing), 0, 290, 220);
      if (nb_h15 * tempo_percent_swing > 0)
         affiche("info_15", DoubleToStr(nb_h15 * tempo_percent_swing, 0), 11, "Arial Black", symcolor(nb_h15 * tempo_percent_swing), 0, 330, 220);
      if (nb_h20 * tempo_percent_swing > 0)
         affiche("info_16", DoubleToStr(nb_h20 * tempo_percent_swing, 0), 11, "Arial Black", symcolor(nb_h20 * tempo_percent_swing), 0, 370, 220);
      if (nb_h25 * tempo_percent_swing > 0)
         affiche("info_17", DoubleToStr(nb_h25 * tempo_percent_swing, 0), 11, "Arial Black", symcolor(nb_h25 * tempo_percent_swing), 0, 410, 220);
      if (nb_h30 * tempo_percent_swing > 0)
         affiche("info_18", DoubleToStr(nb_h30 * tempo_percent_swing, 0), 11, "Arial Black", symcolor(nb_h30 * tempo_percent_swing), 0, 450, 220);
      if (nb_h35 * tempo_percent_swing > 0)
         affiche("info_19", DoubleToStr(nb_h35 * tempo_percent_swing, 0), 11, "Arial Black", symcolor(nb_h35 * tempo_percent_swing), 0, 490, 220);
      if (nb_hsup35 * tempo_percent_swing > 0)
         affiche("info_20", DoubleToStr(nb_hsup35 * tempo_percent_swing, 0), 11, "Arial Black", symcolor(nb_hsup35 * tempo_percent_swing), 0, 550, 220);

      //***************************************************************************************************

      if (nb_b5 * tempo_percent_swing > 0)
         affiche("info_21", DoubleToStr(nb_b5 * tempo_percent_swing, 0), 11, "Arial Black", symcolor(nb_b5 * tempo_percent_swing), 0, 250, 240);
      if (nb_b10 * tempo_percent_swing > 0)
         affiche("info_22", DoubleToStr(nb_b10 * tempo_percent_swing, 0), 11, "Arial Black", symcolor(nb_b10 * tempo_percent_swing), 0, 290, 240);
      if (nb_b15 * tempo_percent_swing > 0)
         affiche("info_23", DoubleToStr(nb_b15 * tempo_percent_swing, 0), 11, "Arial Black", symcolor(nb_b15 * tempo_percent_swing), 0, 330, 240);
      if (nb_b20 * tempo_percent_swing > 0)
         affiche("info_24", DoubleToStr(nb_b20 * tempo_percent_swing, 0), 11, "Arial Black", symcolor(nb_b20 * tempo_percent_swing), 0, 370, 240);
      if (nb_b25 * tempo_percent_swing > 0)
         affiche("info_25", DoubleToStr(nb_b25 * tempo_percent_swing, 0), 11, "Arial Black", symcolor(nb_b25 * tempo_percent_swing), 0, 410, 240);
      if (nb_b30 * tempo_percent_swing > 0)
         affiche("info_26", DoubleToStr(nb_b30 * tempo_percent_swing, 0), 11, "Arial Black", symcolor(nb_b30 * tempo_percent_swing), 0, 450, 240);
      if (nb_b35 * tempo_percent_swing > 0)
         affiche("info_27", DoubleToStr(nb_b35 * tempo_percent_swing, 0), 11, "Arial Black", symcolor(nb_b35 * tempo_percent_swing), 0, 490, 240);
      if (nb_bsup35 * tempo_percent_swing > 0)
         affiche("info_28", DoubleToStr(nb_bsup35 * tempo_percent_swing, 0), 11, "Arial Black", symcolor(nb_bsup35 * tempo_percent_swing), 0, 550, 240);

      affiche("plu_hauswing", "PG H = " + " " + DoubleToStr(plus_grand_swing_bull, 1) + "   ", 10, "Arial Black", symcolor1(plus_grand_swing_bull, plus_grand_swing_bear), 0, 250, 260);
      affiche("plu_hauswin1", "PG B = " + " " + DoubleToStr(plus_grand_swing_bear, 1) + "   ", 10, "Arial Black", symcolor1(plus_grand_swing_bear, plus_grand_swing_bull), 0, 380, 260);

      affiche("plu_basswing", "PP H = " + " " + DoubleToStr(plus_petit_swing_bull, 1) + "   ", 10, "Arial Black", symcolor1(plus_petit_swing_bull, plus_petit_swing_bear), 0, 250, 280);
      affiche("plu_basswin1", "PP B = " + " " + DoubleToStr(plus_petit_swing_bear, 1) + "   ", 10, "Arial Black", symcolor1(plus_petit_swing_bear, plus_petit_swing_bull), 0, 380, 280);

      affiche("spread", "SPREAD " + DoubleToStr(MarketInfo(Symbol(), MODE_SPREAD) / 10, 1), 15, "Arial Black", Lime, 0, 500, 30);

      if (tempo_h * sum_haut > 53) {
         affiche("trend_hausse", "TREND UP ", 20, "Arial Black", Lime, 0, 500, 50);
         affiche("trend_hausse_1", CharToStr(227), 20, "Wingdings 3", Yellow, 0, 700, 50);
      }
      if (tempo_h * sum_bas > 53) {
         affiche("trend_baisse", "TREND DN ", 20, "Arial Black", OrangeRed, 0, 500, 50);
         affiche("trend_baisse_1", CharToStr(228), 20, "Wingdings 3", Orange, 0, 700, 60);
      }
   }

   return (0);
}
//+------------------------------------------------------------------+

void affiche(string name, string text, int text_size, string police_caractere, color couleur_text, int fenetre_windows, int horizontal, int vertical) {
   ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
   ObjectSetText(name, text, text_size, police_caractere, couleur_text);
   ObjectSet(name, OBJPROP_CORNER, fenetre_windows);
   ObjectSet(name, OBJPROP_XDISTANCE, horizontal);
   ObjectSet(name, OBJPROP_YDISTANCE, vertical);
}

int symcolor(double ad_0) {
   if (ad_0 >= 0 && ad_0 < 20)
      return (Red);
   if (ad_0 >= 20 && ad_0 < 40)
      return (OrangeRed);
   if (ad_0 >= 40 && ad_0 < 50)
      return (Yellow);
   if (ad_0 >= 50 && ad_0 < 70)
      return (Chartreuse);
   if (ad_0 >= 70)
      return (Lime);
   return (0);
}

int symcolor1(double ad_0, double ad_1) {
   if (ad_0 > ad_1)
      return (Lime);
   if (ad_0 < ad_1)
      return (Magenta);

   return (Khaki);
}
