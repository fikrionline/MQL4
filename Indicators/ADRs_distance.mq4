//+------------------------------------------------------------------+
//|                                                          ADR.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property indicator_chart_window

extern int TimeZoneOfData = 0; // chart time zone (from GMT)
extern int TimeZoneOfSession = 0; // dest time zone (from GMT) 

int ADROpenHour = 0; // start time for range calculation (LEAVE AT 0. PROGRAM DOESN'T WORK PROPERLY OTHERWISE.)
int ADRCloseHour = 24; // end time for range calculation  (LEAVE AT 24. PROGRAM DOESN'T WORK PROPERLY OTHERWISE.)

int ATRTimeFrame = PERIOD_D1; // timeframe for ATR (LEAVE AT PERIOD_D1)
extern int ATRPeriod = 5; // period for ATR

extern bool TodayChange = true;

bool UseManualADR = false; // allows use of manual value for range
int ManualADRValuePips = 0; // manual value for range

extern int LineStyle = 2;
extern int LineThickness1 = 1; // normal thickness
extern color LineColor1 = Red; // normal color
extern int LineThickness2 = 2; // thickness for range reached state
extern color LineColor2 = Blue; // color for range reached state

extern bool DebugLogger = false;

// Andrew adding start

bool SendEmail = false;
static int prevTime = 0;

// Andrew adding end

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

string alertMsg = "";

int init() {
   Print("Period = ", Period());
   Print("Point = ", Point);

   return (0);
}

int deinit() {
   int obj_total = ObjectsTotal();

   for (int i = obj_total; i >= 0; i--) {
      string name = ObjectName(i);

      if (StringSubstr(name, 0, 5) == "[ADR]")
         ObjectDelete(name);
   }
   Comment("");
   return (0);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start() {
   static datetime timelastupdate = 0;
   static int lasttimeframe = 0,
      lastfirstbar = -1;

   int idxfirstbaroftoday = 0,
      idxfirstbarofyesterday = 0,
      idxlastbarofyesterday = 0;

   //---- exit if period is greater than daily charts
   if (Period() > 1440) {
      Alert("Error - Chart period is greater than 1 day.");
      return (-1); // then exit
   }

   if (DebugLogger) {
      Print("Local time current bar:", TimeToStr(Time[0]));
      Print("Dest  time current bar: ", TimeToStr(Time[0] - (TimeZoneOfData - TimeZoneOfSession) * 3600), ", tzdiff= ", TimeZoneOfData - TimeZoneOfSession);
   }

   // let's find out which hour bars make today and yesterday
   ComputeDayIndices(TimeZoneOfData, TimeZoneOfSession, idxfirstbaroftoday, idxfirstbarofyesterday, idxlastbarofyesterday);

   // no need to update these buggers too often (the code below is a bit tricky, usually just the 
   // timelastupdate would be sufficient, but when turning on MT after the night there is just
   // the newest bar while the rest of the day is missing and updated a bit later).  Don't mess
   // with this unless you are absolutely sure you know what you're doing.
   if (Time[0] == timelastupdate && Period() == lasttimeframe && lastfirstbar == idxfirstbaroftoday) {
      //    return (0);
   }

   lasttimeframe = Period();
   timelastupdate = Time[0];
   lastfirstbar = idxfirstbaroftoday;

   //
   // okay, now we know where the days start and end
   //

   int tzdiff = TimeZoneOfData + TimeZoneOfSession,
      tzdiffsec = tzdiff * 3600;

   datetime startofday = Time[idxfirstbaroftoday]; // datetime (x-value) for labes on horizontal bars

   double adr = iATR(NULL, ATRTimeFrame, ATRPeriod, 1);

   if (UseManualADR)
      adr = ManualADRValuePips * Point;

   // 
   // walk forward through today and collect high/lows within the same day
   //
   double today_high,
   today_low,
   today_open = 0,
      today_range,
      lasthigh, lastlow,
      to_long_adr = 0,
      to_short_adr = 0,
      adr_high = 0,
      adr_low = 0;
   bool adr_reached = false, lastreached;

   // new-start
   for (int j = idxfirstbaroftoday; j >= 0; j--) {

      datetime bartime = Time[j] - tzdiffsec;

      if (TimeHour(bartime) >= ADROpenHour && TimeHour(bartime) < ADRCloseHour) {

         if (today_open == 0) {
            today_open = Open[idxfirstbaroftoday]; // should be open of today start trading hour
            adr_high = today_open + adr;
            adr_low = today_open - adr;
            today_high = today_open;
            today_low = today_open;

         }

         for (int k = 0; k < 3; k++) {

            double price;

            switch (k) {
            case 0:
               price = Low[j];
               break;
            case 1:
               price = High[j];
               break;
            case 2:
               price = Close[j];
               break;
            }

            lasthigh = today_high;
            lastlow = today_low;
            lastreached = adr_reached;

            today_high = MathMax(today_high, price);
            today_low = MathMin(today_low, price);

            today_range = today_high - today_low;
            adr_reached = today_range >= adr - Point / 2; // "Point/2" to avoid rounding problems (double variables)

            //double adrx=adr;  // Andrew added this
            //if(adrx >= adr - Point/2)   // Andrew added this
            //SendMail(Symbol() + "fssdf", Symbol());   // Andrew added this

            // adr-high
            if (!lastreached && !adr_reached) {
               adr_high = today_low + adr;
            } else
            if (!lastreached && adr_reached && price >= lasthigh) {
               adr_high = today_low + adr;
            } else
            if (!lastreached && adr_reached && price < lasthigh) {
               adr_high = lasthigh;
            } else {
               adr_high = adr_high;
            }

            // adr-low
            if (!lastreached && !adr_reached) {
               if (DebugLogger) {
                  Print("#: ", j, " ", "adr_low= today_high-adr ", today_high, "-", adr, "= ", today_high - adr);
               }
               adr_low = today_high - adr;
            } else
            if (!lastreached && adr_reached && price >= lastlow) {
               if (DebugLogger) {
                  Print("#: ", j, " ", "adr_low= today_low", today_low);
               }
               adr_low = today_low;
            } else
            if (!lastreached && adr_reached && price < lastlow) {
               if (DebugLogger) {
                  Print("#: ", j, " ", "adr_low= lasthigh-adr ", lasthigh, "-", adr, "= ", lasthigh - adr);
               }
               adr_low = lasthigh - adr;
            } else {
               if (DebugLogger) {
                  Print("#: ", j, " ", "adr_low= adr_low ", adr_low);
               }
               adr_low = adr_low;
            }

            to_long_adr = adr_high - Close[j];
            to_short_adr = Close[j] - adr_low;

            if (DebugLogger) {
               Print("#:", j, " ", TimeToStr(bartime, TIME_MINUTES), " High-Low/adr-Reached ", today_high - today_low, "/", adr_reached);

               Print("#: ", j, " ", " Price= ", price, " (k= ", k, " [0=low, 1=high, 2=close]])");

               Print("#: ", j, " ", "ADR= ", adr, ", O= ", today_high, ", P= ", today_low,
                  ", Q= ", today_high - today_low, ", R= ", adr_reached,
                  ", S= ", adr_high, ", T= ", adr_low, ", U= ", to_long_adr, ", V= ", to_short_adr);
            }
         }
      }
   }
   // new-end

   if (DebugLogger)
      Print("Timezoned values: t-open= ", today_open, ", t-high =", today_high, ", t-low= ", today_low);

   // draw the vertical bars that marks the time span
   SetTimeLine("today start", "ADR Start", idxfirstbaroftoday, CadetBlue, Low[idxfirstbaroftoday] - 10 * Point);

   color col = LineColor1;
   int thickness = LineThickness1;

   if (adr_reached) {
      col = LineColor2;
      thickness = LineThickness2;
   }

   // Andrew tries again here

   if (prevTime != Time[0] && adr_reached) {
      if (SendEmail) SendMail(Symbol() + " | 5D ADR reached" + " | Currently at " + DoubleToStr(Bid, 4), " ");
      prevTime = Time[0];
   }

   // Andrew's trying ends here

   SetLevel("ADR High", adr_high, col, LineStyle, thickness, startofday);
   SetLevel("ADR Low", adr_low, col, LineStyle, thickness, startofday);

   string reached_str = "Yes";
   if (!adr_reached)
      reached_str = "No";

   string comment = DoubleToStr(MathRound(adr / Point) / 3 / 10, 0) + " / " + DoubleToStr(MathRound(adr / Point), 0) + " / " + DoubleToStr(MathRound((today_high - today_low) / Point), 0) + " --> " + DoubleToStr((MathRound((today_high - today_low) / Point) / MathRound(adr / Point)) * 100, 2) + "%";
   
   if(TodayChange == true) {

      double Change, ChangeProsentase;
      double BasicOpen = iOpen(Symbol(), PERIOD_D1, 0);
      double PriceNow = MarketInfo(Symbol(), MODE_BID);
      string PlusMinus;
   
      if (BasicOpen < PriceNow) {
         Change = PriceNow - BasicOpen;
         PlusMinus = "+";
      }
      if (BasicOpen > PriceNow) {
         Change = BasicOpen - PriceNow;
         PlusMinus = "-";
      }
   
      ChangeProsentase = (Change / BasicOpen) * 100;
   
      comment = comment + " / " + DoubleToString(BasicOpen, MarketInfo(Symbol(), MODE_DIGITS)) + " --> " + DoubleToString(PriceNow, MarketInfo(Symbol(), MODE_DIGITS)) + " " + PlusMinus + DoubleToString(ChangeProsentase, 3) + "%";
   
   }

   Comment(comment);

   return (0);
}

//+------------------------------------------------------------------+
//| Compute index of first/last bar of yesterday and today           |
//+------------------------------------------------------------------+
void ComputeDayIndices(int tzlocal, int tzdest, int & idxfirstbaroftoday, int & idxfirstbarofyesterday, int & idxlastbarofyesterday) {
   int tzdiff = tzlocal + tzdest,
      tzdiffsec = tzdiff * 3600,
      dayminutes = 24 * 60,
      barsperday = dayminutes / Period();

   int dayofweektoday = TimeDayOfWeek(Time[0] - tzdiffsec), // what day is today in the dest timezone?
      dayofweektofind = -1;

   //
   // due to gaps in the data, and shift of time around weekends (due 
   // to time zone) it is not as easy as to just look back for a bar 
   // with 00:00 time
   //

   idxfirstbaroftoday = 0;
   idxfirstbarofyesterday = 0;
   idxlastbarofyesterday = 0;

   switch (dayofweektoday) {
   case 6: // sat
   case 0: // sun
   case 1: // mon
      dayofweektofind = 5; // yesterday in terms of trading was previous friday
      break;

   default:
      dayofweektofind = dayofweektoday - 1;
      break;
   }

   if (DebugLogger) {
      Print("Dayofweektoday= ", dayofweektoday);
      Print("Dayofweekyesterday= ", dayofweektofind);
   }

   // search  backwards for the last occrrence (backwards) of the day today (today's first bar)
   for (int i = 0; i <= barsperday + 1; i++) {
      datetime timet = Time[i] - tzdiffsec;
      // Print(Symbol(), " DayofWeek[", i, ,"]= ", TimeDayOfWeek(timet), " (", dayofweektoday, ") ", TimeToStr(timet));
      if (TimeDayOfWeek(timet) != dayofweektoday) {
         idxfirstbaroftoday = i - 1;
         break;
      }
   }

   // Print(Symbol(), " idxfirstoftoday ", idxfirstbaroftoday);

   // search  backwards for the first occrrence (backwards) of the weekday we are looking for (yesterday's last bar)
   for (int j = 0; j <= 2 * barsperday + 1; j++) {
      datetime timey = Time[i + j] - tzdiffsec;
      if (TimeDayOfWeek(timey) == dayofweektofind) { // ignore saturdays (a Sa may happen due to TZ conversion)
         idxlastbarofyesterday = i + j;
         break;
      }
   }

   // search  backwards for the first occurrence of weekday before yesterday (to determine yesterday's first bar)
   for (j = 1; j <= barsperday; j++) {
      datetime timey2 = Time[idxlastbarofyesterday + j] - tzdiffsec;
      if (TimeDayOfWeek(timey2) != dayofweektofind) { // ignore saturdays (a Sa may happen due to TZ conversion)
         idxfirstbarofyesterday = idxlastbarofyesterday + j - 1;
         break;
      }

   }

   if (DebugLogger) {
      Print("Dest time zone\'s current day starts:", TimeToStr(Time[idxfirstbaroftoday]),
         " (local time), idxbar= ", idxfirstbaroftoday);

      Print("Dest time zone\'s previous day starts:", TimeToStr(Time[idxfirstbarofyesterday]),
         " (local time), idxbar= ", idxfirstbarofyesterday);
      Print("Dest time zone\'s previous day ends:", TimeToStr(Time[idxlastbarofyesterday]),
         " (local time), idxbar= ", idxlastbarofyesterday);
   }
}

//+------------------------------------------------------------------+
//| Helper                                                           |
//+------------------------------------------------------------------+
void SetLevel(string text, double level, color col1, int linestyle, int thickness, datetime startofday) {
   int digits = Digits;
   string labelname = "[ADR] " + text + " Label",
      linename = "[ADR] " + text + " Line";

   // create or move the horizontal line   
   if (ObjectFind(linename) != 0) {
      ObjectCreate(linename, OBJ_TREND, 0, startofday, level, Time[0], level);
   }

   ObjectSet(linename, OBJPROP_BACK, true);
   ObjectSet(linename, OBJPROP_STYLE, linestyle);
   ObjectSet(linename, OBJPROP_COLOR, col1);
   ObjectSet(linename, OBJPROP_WIDTH, thickness);
   ObjectMove(linename, 1, Time[0], level);
   ObjectMove(linename, 0, startofday, level);

}

//+------------------------------------------------------------------+
//| Helper                                                           |
//+------------------------------------------------------------------+
void SetTimeLine(string objname, string text, int idx, color col1, double vleveltext) {
   string name = "[ADR] " + objname;
   int x = Time[idx];

   if (ObjectFind(name) != 0)
      ObjectCreate(name, OBJ_TREND, 0, x, 0, x, 100);

   ObjectMove(name, 0, x, 0);
   ObjectMove(name, 1, x, 100);
   ObjectSet(name, OBJPROP_BACK, true);
   ObjectSet(name, OBJPROP_STYLE, STYLE_DOT);
   ObjectSet(name, OBJPROP_COLOR, DarkGray);

}
