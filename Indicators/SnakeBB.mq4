//+------------------------------------------------------------------+
//|                                                        Snake.mq4 |
//|                                      "ÈÍÄÈÊÀÒÎÐÛ ÄËß ÑÀÌÎÎÁÌÀÍÀ" |
//|                           Bookkeeper, 2006, yuzefovich@gmail.com |
//+------------------------------------------------------------------+
//Original Snake calculation and lookback settings left unchanged. 
//Snake calculation code modified to be modular, lookback simplified, and everything else created by Beerrun
#property strict
#property indicator_chart_window
#property indicator_buffers 10
extern int halfcycle = 5; //Snake Half Cycle
extern double stddevmulti = 1.5; //Standard Deviations
enum _size {
   none, //None
   one, //1
   two, //2
   three, //3
   four, //4
   five //5
};
extern _size arrow = 1; //Arrow Size
enum ny {
   No,
   Yes
};
extern ny cline = 1; //Show Cycle Line
extern color colourup = clrMediumTurquoise; //Colour Up
extern color colourdw = clrViolet; //Colour Down
enum _style {
   Solid,
   Dashed,
   Dotted,
   DD1, //Dashes+Dots(single)
   DD2 //Dashes+Dots(double)
};
extern _style style = 0; //Line Style
enum _width {
   One = 1, Two = 2, Three = 3, Four = 4, Five = 5
};
extern _width width = 1; //Line Width
enum alerts {
   off, //None
   alert, //Alerts
   alertnot, //Alerts and Notifications
   alertmail, //Alerts and Emails
   not, //Notifications
   notmail, //Notifications and Emails
   email, //Emails
   all //All
};
extern alerts ALERTS = 0; //Alerts/Notifications/Emails
extern string UPMSG = "UpTrend"; //Up Message
extern string DWMSG = "DownTrend"; //Down Message
int SnakeHalfCycle = 0;
bool initsw = true;
double Snake[], snakeup[], snakedw[], stddev[], stddevup1[],
   stddevup2[], stddevdw1[], stddevdw2[], arrowup[], arrowdw[];

int init() {
   IndicatorShortName("Snake " + Symbol());
   SetIndexBuffer(0, Snake);
   SetIndexStyle(0, DRAW_LINE, EMPTY, EMPTY, clrNONE);
   SetIndexLabel(0, "Snake " + Symbol());
   SetIndexBuffer(1, snakeup);
   SetIndexStyle(1, DRAW_LINE, style, width, colourup);
   SetIndexLabel(1, NULL);
   SetIndexBuffer(2, snakedw);
   SetIndexStyle(2, DRAW_LINE, style, width, colourdw);
   SetIndexLabel(2, NULL);
   SetIndexBuffer(3, stddevup1);
   SetIndexLabel(3, NULL);
   SetIndexBuffer(4, stddevup2);
   SetIndexLabel(4, NULL);
   SetIndexBuffer(5, stddevdw1);
   SetIndexLabel(5, NULL);
   SetIndexBuffer(6, stddevdw2);
   SetIndexLabel(6, NULL);
   SetIndexBuffer(7, arrowup);
   SetIndexLabel(7, "ArrowUp");
   SetIndexArrow(7, 233);
   SetIndexBuffer(8, arrowdw);
   SetIndexLabel(8, "ArrowDown");
   SetIndexArrow(8, 234);
   SetIndexBuffer(9, stddev);
   SetIndexLabel(9, NULL);
   if (stddevmulti > 0) {
      SetIndexStyle(3, 0, style, width, colourup);
      SetIndexStyle(4, 0, style, width, colourdw);
      SetIndexStyle(5, 0, style, width, colourup);
      SetIndexStyle(6, 0, style, width, colourdw);
   } else {
      SetIndexStyle(3, 0, EMPTY, EMPTY, clrNONE);
      SetIndexStyle(4, 0, EMPTY, EMPTY, clrNONE);
      SetIndexStyle(5, 0, EMPTY, EMPTY, clrNONE);
      SetIndexStyle(6, 0, EMPTY, EMPTY, clrNONE);
   }
   if (arrow > 0) {
      SetIndexStyle(7, 3, 0, arrow, colourup);
      SetIndexStyle(8, 3, 0, arrow, colourdw);
   } else {
      SetIndexStyle(7, 3, 0, arrow, clrNONE);
      SetIndexStyle(8, 3, 0, arrow, clrNONE);
   }
   SnakeHalfCycle = halfcycle;
   return (0);
}

int start() {
   int i = 0;
   if (Bars <= 150) return (i);
   if (SnakeHalfCycle < 3) SnakeHalfCycle = 3;
   i = (IndicatorCounted() > 0) ? SnakeHalfCycle + 2 : Bars - SnakeHalfCycle - 2;
   if (i < SnakeHalfCycle + 2) i = SnakeHalfCycle + 2;
   Snake[i] = SnakeCalc(1, i);
   i--;
   for (; i >= 0; i--) {
      if (i >= SnakeHalfCycle) {
         Snake[i] = SnakeCalc(2, i);
         SnakeColour(i);
         continue;
      }
      Snake[i] = SnakeCalc(1, i);
      SnakeColour(i);
   }
   if (initsw) {
      Cycle(2);
      initsw = false;
   }
   ArrowColour(SnakeHalfCycle + 3, 0);
   return (i);
}

int deinit() {
   Cycle(0);
   return (0);
}

void SnakeColour(int i) {
   static bool dir = NULL;
   if (!initsw) {
      if (i <= SnakeHalfCycle + 2)
         for (int ii = i; ii >= 0; ii--) {
            snakeup[ii] = EMPTY_VALUE;
            snakedw[ii] = EMPTY_VALUE;
            stddevup1[ii] = EMPTY_VALUE;
            stddevdw1[ii] = EMPTY_VALUE;
            stddevup2[ii] = EMPTY_VALUE;
            stddevdw2[ii] = EMPTY_VALUE;
         }
   }

   if (Snake[i] > Snake[i + 1]) {
      snakeup[i + 1] = Snake[i + 1];
      snakeup[i] = Snake[i];
      dir = true;
      StdDev(i, dir);
      Cycle(1);
   }
   if (Snake[i] < Snake[i + 1]) {
      snakedw[i + 1] = Snake[i + 1];
      snakedw[i] = Snake[i];
      dir = false;
      StdDev(i, dir);
      Cycle(-1);
   }
   if (Snake[i] == Snake[i + 1]) {
      if (dir) {
         snakeup[i + 1] = Snake[i + 1];
         snakeup[i] = Snake[i];
         StdDev(i, true);
         Cycle(1);
      }
      if (!dir) {
         snakedw[i + 1] = Snake[i + 1];
         snakedw[i] = Snake[i];
         StdDev(i, false);
         Cycle(-1);
      }
   }
}

void StdDev(int i, bool dir) {
   double sum = 0;
   static int lastdir = 0;
   for (int ii = 0; ii < SnakeHalfCycle; ii++) {
      if (i - ii < 0) break;
      sum += pow(Close[i - ii] - Snake[i], 2);
   }
   stddev[i] = sqrt(sum / SnakeHalfCycle);
   if (dir) {
      stddevup1[i] = Snake[i] + stddevmulti * stddev[i];
      stddevdw1[i] = Snake[i] - stddevmulti * stddev[i];
      stddevup1[i + 1] = Snake[i + 1] + stddevmulti * stddev[i + 1];
      stddevdw1[i + 1] = Snake[i + 1] - stddevmulti * stddev[i + 1];
      if (i >= SnakeHalfCycle + 2)
         if (lastdir != dir) {
            ArrowColour(i, 1);
            lastdir = dir;
         }
      return;
   }
   if (!dir) {
      stddevdw2[i] = Snake[i] - stddevmulti * stddev[i];
      stddevup2[i] = Snake[i] + stddevmulti * stddev[i];
      stddevdw2[i + 1] = Snake[i + 1] - stddevmulti * stddev[i + 1];
      stddevup2[i + 1] = Snake[i + 1] + stddevmulti * stddev[i + 1];
      if (i >= SnakeHalfCycle + 2)
         if (lastdir != dir) {
            ArrowColour(i, -1);
            lastdir = dir;
         }
   }
   return;
}

void ArrowColour(int i, int dir) {
   double gap = iATR(NULL, 0, SnakeHalfCycle + 1 + i, i) * 0.75;
   if (dir == 1) {
      arrowup[i + 1] = Close[i + 1] - gap;
      return;
   }
   if (dir == -1) {
      arrowdw[i + 1] = Open[i + 1] + gap;
      return;
   }
   if (dir == 0) {
      for (int del = i; del >= 0; del--) {
         arrowup[del] = EMPTY_VALUE;
         arrowdw[del] = EMPTY_VALUE;
      }
      for (; i >= 0; i--) {
         if (snakeup[i] != EMPTY_VALUE && snakeup[i + 1] == EMPTY_VALUE) {
            ArrowColour(i - 1, 1);
            if (i == SnakeHalfCycle + 2) Alerts(true);
         }
         if (snakedw[i] != EMPTY_VALUE && snakedw[i + 1] == EMPTY_VALUE) {
            ArrowColour(i - 1, -1);
            if (i == SnakeHalfCycle + 2) Alerts(false);
         }
      }
   }
   return;
}

void Alerts(bool dir) {
   static datetime newbar = Time[0];
   if (initsw || ALERTS == 0 || IndicatorCounted() == 0) return;
   if (newbar >= Time[0]) return;
   newbar = Time[0];
   enum _tf {
      Current,
      M1,
      M5 = 5,
      M15 = 15,
      M30 = 30,
      H1 = 60,
      H4 = 240,
      D1 = 1440,
      W1 = 10080,
      MN = 43200
   };
   _tf tf = (_tf) Period();
   string header = _Symbol + " " + EnumToString(tf) + " ";
   string msg = (dir) ? UPMSG : DWMSG;
   if (ALERTS == 1 || ALERTS == 2 || ALERTS == 3 || ALERTS == 7) Alert(header + msg);
   if (ALERTS == 2 || ALERTS == 4 || ALERTS == 5 || ALERTS == 7) SendNotification(header + msg);
   if (ALERTS == 3 || ALERTS == 5 || ALERTS == 6 || ALERTS == 7) SendMail(header, msg);
   return;
}

void Cycle(int dir) {
   if (!cline) return;
   string cycle = "Cycle Line";
   ObjectDelete(0, cycle);
   if (dir == 0) return;
   if (stddevmulti > 0) ObjectCreate(0, cycle, OBJ_TREND, 0, Time[SnakeHalfCycle + 1], Snake[SnakeHalfCycle + 1] + (stddevmulti * stddev[SnakeHalfCycle + 1]),
      Time[SnakeHalfCycle + 1], Snake[SnakeHalfCycle + 1] - (stddevmulti * stddev[SnakeHalfCycle + 1]));
   else ObjectCreate(0, cycle, OBJ_TREND, 0, Time[SnakeHalfCycle + 1], Snake[SnakeHalfCycle + 1] + stddev[SnakeHalfCycle + 1],
      Time[SnakeHalfCycle + 1], Snake[SnakeHalfCycle + 1] - stddev[SnakeHalfCycle + 1]);
   ObjectSet(cycle, OBJPROP_RAY_RIGHT, false);
   ObjectSet(cycle, OBJPROP_WIDTH, 2);
   if (dir) ObjectSet(cycle, OBJPROP_COLOR, colourup);
   if (dir == -1) ObjectSet(cycle, OBJPROP_COLOR, colourdw);
   if (dir == 2) ObjectSet(cycle, OBJPROP_COLOR, clrGray);
}

double SnakeCalc(int id, int Shift) {
   static double Snake_Sum, Snake_Weight, Snake_Sum_Minus, Snake_Sum_Plus;

   if (id == 0) return ((Open[Shift] + Close[Shift] + High[Shift] + Low[Shift]) / 4);

   if (id == 1) {
      int i = 0, j = 0, w = 0;
      Snake_Weight = Snake_Sum = 0.0;
      if (Shift < SnakeHalfCycle) {
         w = Shift + SnakeHalfCycle;
         while (w >= Shift) {
            i++;
            Snake_Sum = Snake_Sum + i * SnakeCalc(0, w);
            Snake_Weight = Snake_Weight + i;
            w--;
         }
         while (w >= 0) {
            i--;
            Snake_Sum = Snake_Sum + i * SnakeCalc(0, w);
            Snake_Weight = Snake_Weight + i;
            w--;
         }
      } else {
         Snake_Sum_Plus = Snake_Sum_Minus = 0.0;
         for (j = Shift - SnakeHalfCycle, i = Shift + SnakeHalfCycle, w = 1; w <= SnakeHalfCycle; j++, i--, w++) {
            Snake_Sum = Snake_Sum + w * (SnakeCalc(0, i) + SnakeCalc(0, j));
            Snake_Weight = Snake_Weight + 2 * w;
            Snake_Sum_Minus = Snake_Sum_Minus + SnakeCalc(0, i);
            Snake_Sum_Plus = Snake_Sum_Plus + SnakeCalc(0, j);
         }
         Snake_Sum = Snake_Sum + (SnakeHalfCycle + 1) * SnakeCalc(0, Shift);
         Snake_Weight = Snake_Weight + SnakeHalfCycle + 1;
         Snake_Sum_Minus = Snake_Sum_Minus + SnakeCalc(0, Shift);
      }
      return (Snake_Sum / Snake_Weight);
   }

   if (id == 2) {
      Snake_Sum_Plus = Snake_Sum_Plus + SnakeCalc(0, Shift - SnakeHalfCycle);
      Snake_Sum = Snake_Sum - Snake_Sum_Minus + Snake_Sum_Plus;
      Snake_Sum_Minus = Snake_Sum_Minus - SnakeCalc(0, Shift + SnakeHalfCycle + 1) + SnakeCalc(0, Shift);
      Snake_Sum_Plus = Snake_Sum_Plus - SnakeCalc(0, Shift);
      return (Snake_Sum / Snake_Weight);
   }

   return (-1);
}
