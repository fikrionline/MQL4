//SpikeBars_v3  Copyright © 2009, Arshed Qureshi arshedfx@gmail.com
#property copyright "Copyright © 2009, Arshed Qureshi. ArshadFX"
#property indicator_chart_window

extern int MinRange = 1;
extern int LookBack = 720;
extern bool ShowRange = 1; // 0=Show Nothing, 1=Show Pips/Range
extern bool ShowOpnClo = 1; // 0=Show Nothing, 1=Show Open to close
extern int PaintBarWidth = 1; // How fat paint bar will be ?       
extern bool Popup = 0; // Enable to show Popup Window
extern bool ShowLine = 0;
extern color BULL = Blue; // Colour for UP bar
extern color BEAR = Red; // Colour for DOWN bar
extern int UpBarShift = 50; // Interval upside bar
extern int DnBarShift = 50; // Interval behind bar
datetime RangeT;
// --- Init & Deinit ----------------------------------------------------------
int init() {
   RangeT = Time[1];
   return (0);
}
int deinit() {
   for (int i = LookBack; i >= 0; i--) {
      ObjectDelete("" + i);
      ObjectDelete("L" + i);
      ObjectDelete("H" + i);
   }
   return (0);
}
// --- Main Function call -----------------------------------------------------
int start() {
   double GetRange, GetOC, Range, GetUp, GetDown;
   bool BarUP, Flag;
   for (int x = 1; x < LookBack; x++) {
      GetRange = (High[x] - Low[x]);
      if (Digits < 4) GetRange = GetRange * 1000;
      else GetRange = GetRange * 100000;
      GetOC = (Close[x] - Open[x]);
      if (Digits < 4) GetOC = GetOC * 1000;
      else GetOC = GetOC * 100000;
      if (Open[x] < Close[x]) BarUP = 1;
      else BarUP = 0;

      if (BarUP == 1) {
         GetUp = High[x] - Close[x];
         GetDown = Open[x] - Low[x];
      }
      if (BarUP == 0) {
         GetUp = High[x] - Open[x];
         GetDown = Close[x] - Low[x];
      }
      if (Digits < 4) {
         GetUp = GetUp * 1000;
         GetDown = GetDown * 1000;
      } else {
         GetUp = GetUp * 100000;
         GetDown = GetDown * 100000;
      }

      //Alert("GetRange : ",GetRange,"  MinRange : ",MinRange,"  x : ",x);
      if (GetRange > MinRange) {
         // Draw Line on bar / Repaint Bar
         if (ShowLine == 1) {
            if (BarUP == 0) {
               ObjectDelete("L" + x);
               ObjectCreate("L" + x, OBJ_TREND, 0, Time[x], High[x], Time[x], Low[x]);
               ObjectSet("L" + x, 10, 0);
               ObjectSet("L" + x, 8, PaintBarWidth);
               ObjectSet("L" + x, 6, BEAR);
            }
            if (BarUP == 1) {
               ObjectDelete("H" + x);
               ObjectCreate("H" + x, OBJ_TREND, 0, Time[x], High[x], Time[x], Low[x]);
               ObjectSet("H" + x, 10, 0);
               ObjectSet("H" + x, 8, PaintBarWidth);
               ObjectSet("H" + x, 6, BULL);
            }
         }
         if (ShowRange && !ShowOpnClo) // Draw Range on bars
         {
            if (BarUP == 0) {
               ObjectDelete("" + x);
               ObjectCreate("" + x, OBJ_TEXT, 0, Time[x], Low[x] - DnBarShift * Point);
               ObjectSetText("" + x, "" + DoubleToStr(GetRange, 0), 8, "Arial", BEAR);
            }
            if (BarUP == 1) {
               ObjectDelete("" + x);
               ObjectCreate("" + x, OBJ_TEXT, 0, Time[x], High[x] + UpBarShift * Point);
               ObjectSetText("" + x, "" + DoubleToStr(GetRange, 0), 8, "Arial", BULL);
            }
         }
         if (ShowOpnClo && !ShowRange) // Draw OpenClose on bars
         {
            if (BarUP == 0) {
               ObjectDelete("" + x);
               ObjectCreate("" + x, OBJ_TEXT, 0, Time[x], Low[x] - DnBarShift * Point);
               ObjectSetText("" + x, "" + DoubleToStr(MathAbs(GetOC), 0), 8, "Arial", BEAR);
            }
            if (BarUP == 1) {
               ObjectDelete("" + x);
               ObjectCreate("" + x, OBJ_TEXT, 0, Time[x], High[x] + UpBarShift * Point);
               ObjectSetText("" + x, "" + DoubleToStr(GetOC, 0), 8, "Arial", BULL);
            }
         }
         if (ShowOpnClo && ShowRange) // Draw OpenClose & Range
         {
            if (BarUP == 0) {
               ObjectDelete("" + x);
               ObjectCreate("" + x, OBJ_TEXT, 0, Time[x], Low[x] - DnBarShift * Point);
               ObjectSetText("" + x, "" + DoubleToStr(GetRange, 0) + "," + GetUp + "," + DoubleToStr(MathAbs(GetOC), 0) + "," + GetDown, 8, "Arial", BEAR);
            }
            if (BarUP == 1) {
               ObjectDelete("" + x);
               ObjectCreate("" + x, OBJ_TEXT, 0, Time[x], High[x] + UpBarShift * Point);
               ObjectSetText("" + x, "" + DoubleToStr(GetRange, 0) + "," + GetUp + "," + DoubleToStr(GetOC, 0) + "," + GetDown, 8, "Arial", BULL);
            }
         }
      }
   }
   Range = (High[1] - Low[1]);
   if (Digits < 4) Range = Range * 100;
   else Range = Range * 10000;
   if (RangeT == Time[1]) {
      RangeT = Time[0];
      Flag = 1;
   }
   if (Range > MinRange && Flag == 1 && Popup == 1) {
      if (Open[1] < Close[1]) {
         Alert(Symbol(), "  BULL bar formed Range is ", Range, " Pips");
         Flag = 0;
      }
      if (Open[1] > Close[1]) {
         Alert(Symbol(), "  BEAR bar formed Range is ", Range, " Pips");
         Flag = 0;
      }
   }
   //   Comment("Range : ",Range,"  RangeT : ",RangeT,"  Time[1] : ",Time[1],"  Flag : ",Flag);
   return (0);
}

// --- End of Main Function ---------------------------------------------------
