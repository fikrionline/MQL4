//+------------------------------------------------------------------+
//|                            Trade Outside the Box v7.X
//+------------------------------------------------------------------+

#property copyright "Copyright 10.04.2020, SwingMan"

//--- Source code:
//#property copyright "by Squalou and mer071898"
//   3 Tier London Breakout
//#property link      "http://www.forexfactory.com/showthread.php?t=247220"

#property strict
#property indicator_chart_window

#property indicator_buffers 9

#property indicator_color1 clrNONE
#property indicator_color2 clrNONE
#property indicator_color3 clrRed //Pivot
#property indicator_color4 clrDodgerBlue //Middle
#property indicator_color5 clrDodgerBlue //TRend UP
#property indicator_color6 clrRed //TRendDown

#property indicator_color7 clrGreen //Entry Long
#property indicator_color8 clrRed //Entry Short
#property indicator_color9 clrDodgerBlue //No Entry

string VERSION = WindowExpertName() + " ";

//===================================================================
#property description "https://www.forexfactory.com/showthread.php?t=985026 by Emma7788-FAN"
#property description " "
#property description "- During testing in the Strategy Tester,"
#property description "  TimeGMT() is always equal to TimeCurrent() simulated server time!"
#property description " "
#property description "  The parameter GMT_Server_OffsetHours must be put manually"
#property description " "
#property description "(Source code: 3 Tier London Breakout V.3.2b - by Squalou and mer071898)"
//===================================================================
/*
 * Version history SwingMan:

   10.04.2020  -  V 7.1 -  Alerts
   05.04.2020  -  V 7.0 -  Pips Offset for the Box
   30.03.2020  -  V 6.0-6.3 -  Trading Arrows (Entry, no Entry); Lots number
 * 22.03.2020  -  V 5.1-GMT
 * V 5.0-GMT: Buffers for Pivot and Middle shifted 1 bar; Trend Filter with Shift Bar
 * V 4.0-GMT: Buffers for the RangeBox
 * V...-GMT: Automatic calculation for GMT-Offset / SwingMan 10.03.2020
 */

enum ENUM_ACCOUNT_TRADE_RISC {
   Balance,
   Equity,
   Deposit
};

//====================================================================
string Info = VERSION; // version number information
extern string StartTime = "06:01"; // time for start of price establishment window
extern string EndTime = "09:59"; // time for end of price establishment window
extern string SessionEndTime = "09:59"; // end of daily session; tomorrow is another day!
//extern string Info          = VERSION; // version number information
//extern string StartTime     = "06:01";    // time for start of price establishment window
//extern string EndTime       = "09:59";    // time for end of price establishment window
//extern string SessionEndTime= "09:59";   // end of daily session; tomorrow is another day!
//extern string SessionEndTime= "16:59";   // end of daily session; tomorrow is another day!

extern bool AutoCalculate_GMT_Offset = false;
extern int GMT_Server_OffsetHours = 0;

extern color SessionColor = clrLinen; // show Session periods with a different background color
extern int NumDays = 200; // days back
int MinBoxSizeInPips = 10; // min tradable box size;
//when box is smaller than that, you should at least reduce your usual lot-size if you decide to trade it;
int MaxBoxSizeInPips = 500; // max tradable box size;
//don't trade when box is larger than that value

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
extern bool LimitBoxToMaxSize = true;
// when true, a box larger than MaxBoxSizeInPips will be limited to MaxBoxSizeInPips, and centered on the EMA(box_time_range) value.
extern bool StickBoxToLatestExtreme = false;
// (applies when "LimitBoxToMaxSize" is true) when true, the box will "stick" to the box high or low, whichever comes last; else it will be centered on the EMA(box_time_range) value;
extern bool StickBoxOusideSRlevels = false;
// when true, we'll use the latest highest/lowest PA as S/R level, and "stick" the box to outside of it;

extern double TP1Factor = 0.50;
extern double TP2Factor = 1.00;
extern double EntryLimit_Factor = 0.25;
// set to half-way between TP1Factor and TP3Factor;
//extern double TP3Factor    = 1.000;

//double TP4Factor; // set to half-way between TP3Factor and TP5Factor;
//extern double TP5Factor    = 0.000;// TP4 and TP5 targets are OPTIONAL: set TP5Factor=0 to allow only up to TP3 target;
//extern string TP2_help     = "TP2 is half-way between TP1 and TP3";
//extern string TP4_help     = "TP4 is half-way between TP3 and TP5";
extern int BoxOffset_Pips = 0;
double SLFactor = 2.000;
extern double LevelsResizeFactor = 1.0;

input string ___Money_Management = "--------------------------------------------";
input bool Enable_LotCalculation = true;
input double Fix_Lots = 0.10;
bool Show_LotsNumber = true;
extern double Risc_Percent = 1;
input ENUM_ACCOUNT_TRADE_RISC AccountRisc = Deposit;
input double Deposit_Amount = 5000;
input string ___Colors = "--------------------------------------------";
extern color Chart_Background = clrWhite;
extern color Chart_Foreground = clrBlack;
extern bool Chart_ShowOHLC = false;
extern color BoxColorOK = clrYellow;
extern color BoxColorNOK = clrRed;
extern color BoxColorMAX = clrOrange;
extern color LevelColor = clrBlack;
extern int FibLength = 14;
extern bool showProfitZone = true;
extern color ProfitColor = clrLightGreen;
extern bool MondayFix = True;

extern string objPrefix = "LB2-";
// all objects drawn by this indicator will be prefixed with this

input string ___Vertical_Lines = "--------------------------------------------";
input bool Draw_VerticalLines = true;
input color VerticalLine_Color = clrBlack;
input ENUM_LINE_STYLE VerticalLine_Style = STYLE_SOLID;
input bool VerticalLine_ShowTime = false;

input string ___Trend_Filter = "--------------------------------------------";
input bool Show_DailyPivot = false;
input bool Show_DailyMiddle = false;
input bool Show_DailyTrend = false;
input bool Show_EntryPoints = true;
input bool Show_TradingLevels_Text = true;
input string ___Comments = "--------------------------------------------";
input bool Show_Comments = true;
bool Show_MinMax_BoxSize = false;
input string ___Alerts = "--------------------------------------------";
input bool Send_Alerts = false;
input bool Play_SoundAlert = false;
input string Sound_File = "alert.wav";
input bool Send_eMails = false;
input bool Send_Notifications = false;
//--------------------------------------------------------

//---- constants
bool bSetHiddenObjects = false;

//---- buffers
double BoxHigh[], BoxLow[];
double BarPivot[], BarMiddle[];
double TradeUP[], TradeDN[];
double EntryUP[], EntryDN[], EntryNO[];
double SignalSended[];
double iEntryBar[];

//---- GLOBAL variables
string CR = "\n";
int boxStartShift, boxEndShift;
double pip;
int digits;
int BarsBack;
//int iTestBar;
string sTitleComment;
double tickValue;
int limit;

//breakout levels
//Entry, stop and tp
double BuyEntry, BuyTP1, BuyTP2;
//BuyTP3,BuyTP4,BuyTP5,
double BuySL;
double SellEntry, SellTP1, SellTP2;
//SellTP3,SellTP4,SellTP5,
double SellSL;
int SL_pips, TP1_pips, TP2_pips;
//TP3_pips,TP4_pips,TP5_pips;
double TP1FactorInput, TP2FactorInput;
//TP3FactorInput,TP4FactorInput,TP5FactorInput,
double SLFactorInput;
//box and session
datetime tBoxStart, tBoxEnd, tSessionStart, tSessionEnd;
datetime tLastComputedSessionStart, tLastComputedSessionEnd;
double boxHigh, boxLow, boxExtent, boxMedianPrice;
datetime thisTime, oldTime;
bool newBar;

int StartShift;
int EndShift;
datetime alreadyDrawn;
bool bSignalSended;

//+------------------------------------------------------------------+
int init()
//+------------------------------------------------------------------+
{
   //Send_SignalAlerts("short");
   //bSignalSended=true;

   ChartSetInteger(0, CHART_SHOW_GRID, false);
   IndicatorDigits(Digits);

   //---TEST
   ChartSetInteger(0, CHART_COLOR_BACKGROUND, Chart_Background);
   ChartSetInteger(0, CHART_COLOR_FOREGROUND, Chart_Foreground);
   ChartSetInteger(0, CHART_SHOW_OHLC, Chart_ShowOHLC);

   //tickValue=MarketInfo(Symbol(),MODE_TICKVALUE);
   //Print("tickValue= ",tickValue);

   //-- buffers
   SetIndexBuffer(0, BoxHigh);
   SetIndexLabel(0, "Box-High");
   //SetIndexStyle(0, DRAW_ARROW, EMPTY, 2);  SetIndexArrow(0,iArrowUP);

   SetIndexBuffer(1, BoxLow);
   SetIndexLabel(1, "Box-Low");
   //SetIndexStyle(1, DRAW_ARROW, EMPTY, 2); SetIndexArrow(1,iArrowDN);

   SetIndexBuffer(2, BarPivot);
   SetIndexLabel(2, "Pivot");
   SetIndexStyle(2, DRAW_ARROW, EMPTY, 2);
   SetIndexArrow(2, 159);
   if (Show_DailyPivot == false)
      SetIndexStyle(2, DRAW_NONE);

   SetIndexBuffer(3, BarMiddle);
   SetIndexLabel(3, "Middle");
   SetIndexStyle(3, DRAW_ARROW, EMPTY, 2);
   SetIndexArrow(3, 159);
   if (Show_DailyMiddle == false)
      SetIndexStyle(3, DRAW_NONE);

   SetIndexBuffer(4, TradeUP);
   SetIndexLabel(4, "Filter UP");
   SetIndexStyle(4, DRAW_ARROW, EMPTY, 2);
   SetIndexArrow(4, 233);
   if (Show_DailyTrend == false)
      SetIndexStyle(4, DRAW_NONE);

   SetIndexBuffer(5, TradeDN);
   SetIndexLabel(5, "Filter DOWN");
   SetIndexStyle(5, DRAW_ARROW, EMPTY, 2);
   SetIndexArrow(5, 234);
   if (Show_DailyTrend == false)
      SetIndexStyle(5, DRAW_NONE);

   //-- Entry points
   SetIndexBuffer(6, EntryUP);
   SetIndexLabel(6, NULL);
   SetIndexStyle(6, DRAW_ARROW, EMPTY, 2);
   SetIndexArrow(6, 162);
   if (Show_EntryPoints == false)
      SetIndexStyle(6, DRAW_NONE);

   SetIndexBuffer(7, EntryDN);
   SetIndexLabel(7, NULL);
   SetIndexStyle(7, DRAW_ARROW, EMPTY, 2);
   SetIndexArrow(7, 162);
   if (Show_EntryPoints == false)
      SetIndexStyle(7, DRAW_NONE);

   SetIndexBuffer(8, EntryNO);
   SetIndexLabel(8, NULL);
   SetIndexStyle(8, DRAW_ARROW, EMPTY, 3);
   SetIndexArrow(8, 78);
   if (Show_EntryPoints == false)
      SetIndexStyle(8, DRAW_NONE);

   //--- more buffers
   IndicatorBuffers(11);

   SetIndexBuffer(9, SignalSended);
   SetIndexEmptyValue(9, 0);

   SetIndexBuffer(10, iEntryBar);
   SetIndexEmptyValue(10, -1);

   //-- GMT offset calculation -------------------------------
   //-- During testing in the Strategy Tester, TimeGMT() is always equal to TimeCurrent() simulated server time!
   datetime GMT_Time = TimeGMT();
   datetime Server_Time = TimeCurrent();
   datetime LocalTime = TimeLocal();

   string sGMT_Time = TimeToString(GMT_Time, TIME_DATE | TIME_MINUTES);
   string sServer_Time = TimeToString(Server_Time, TIME_DATE | TIME_MINUTES);

   GMT_Time = StringToTime(sGMT_Time);
   Server_Time = StringToTime(sServer_Time);

   //--- weekend
   int thisDayOfWeek = TimeDayOfWeek(Server_Time);
   //int thisDayOfWeek=TimeDayOfWeek(TimeLocal());
   if (AutoCalculate_GMT_Offset == true && (thisDayOfWeek == SATURDAY || thisDayOfWeek == SUNDAY)) {
      if (GMT_Server_OffsetHours == 0)
         GMT_Server_OffsetHours = 0;
   } else
      //--- get GMT offset
      if (AutoCalculate_GMT_Offset == true) {
         if (GMT_Server_OffsetHours == 0)
            GMT_Server_OffsetHours = int(Server_Time - GMT_Time) / 3600;
      }

   //RemoveObjects(objPrefix);

   //--- COMMENT Title
   //=========================================================
   //---- set Comment Panel
   if (Show_Comments == true) {
      long cBackground;
      ChartGetInteger(0, CHART_COLOR_BACKGROUND, 0, cBackground);

      //cBackground=clrRed;

      int InfoPanel_X = 0; //2;
      int InfoPanel_Y = 13; //20;
      int InfoPanel_Width = 190;
      int InfoPanel_Height = 55; //375;
      color InfoPanel_Color = (color) cBackground;
      color border_clr = (color) cBackground;
      int border_width = 1; //1;
      int borderType = BORDER_RAISED;
      string sInfoPanel = objPrefix + "InfoPanel";
      //if(Show_MinMax_BoxSize==false)
      //   InfoPanel_Height  = 30;

      Draw_CommentPanel(sInfoPanel, 0, InfoPanel_X, InfoPanel_Y, InfoPanel_Width, InfoPanel_Height, InfoPanel_Color, border_clr, border_width, borderType);
   }
   //---- show Comment
   if (Show_Comments == true) {
      sTitleComment = Info + "(GMT= " + (string) GMT_Server_OffsetHours + ") " + CR +
         "[" + StartTime + "-" + EndTime + "] end " + SessionEndTime;
      if (BoxOffset_Pips > 0)
         sTitleComment = sTitleComment + "; BoxOffset " + (string) BoxOffset_Pips + " p";
      if (Show_MinMax_BoxSize == true)
         sTitleComment = sTitleComment + CR +
         "min " + DoubleToStr(MinBoxSizeInPips, 0) + "p," + " max " + DoubleToStr(MaxBoxSizeInPips, 0) + "p; " +
         DoubleToStr(TP1Factor, 1) + "/" + DoubleToStr(TP2Factor, 1);
      Comment(sTitleComment);
   }

   //=========================================================
   //.......
   getpip();
   //.......

   BarsBack = NumDays * (PERIOD_D1 / Period());
   alreadyDrawn = 0;

   //---save input Factors;
   TP1FactorInput = TP1Factor;
   SLFactorInput = SLFactor;

   //--- StickBoxOusideSRlevels mode requires LimitBoxToMaxSize and StickBoxToLatestExtreme options true
   if (StickBoxOusideSRlevels == true) {
      LimitBoxToMaxSize = true;
      StickBoxToLatestExtreme = true;
   }

   return (0);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit() {
   RemoveObjects(objPrefix);
   if (Show_Comments == true)
      Comment("");
   return (0);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
   const int prev_calculated,
      const datetime & time[],
         const double & open[],
            const double & high[],
               const double & low[],
                  const double & close[],
                     const long & tick_volume[],
                        const long & volume[],
                           const int & spread[]) {
   int i, counted_bars = IndicatorCounted();

   limit = MathMin(BarsBack, Bars - counted_bars - 2);

   //Comment("limit= ",limit);
   if (limit <= 0)
      limit = 1;
   //limit=0;

   for (i = limit; i >= 0; i--) {
      new_tick(i);
   }
   //--- done
   return (rates_total);
}

//+------------------------------------------------------------------+
void new_tick(int i) // i = bar number: 0=current(last) bar
//+------------------------------------------------------------------+
{
   datetime now = Time[i];

   //--- new bar
   thisTime = now;
   //if(thisTime>oldTime)
   if (thisTime != oldTime) {
      oldTime = thisTime;
      newBar = true;
      //Print( "  TIME newBar= ",Time[i]);
   } else
      newBar = false;

   if (now >= D'2020.04.16 08:15')
      int zz = 9;

   //--- compute LEVELS values:
   //.......................
   compute_LB_Indi_LEVELS(now);
   //.......................

   //Comment("  i= ",i,"   pip= ",pip,"   boxExtent= ",boxExtent,"  tickValue= ",tickValue);

   if (newBar == true) {
      //--- bar between Start / End
      if (now >= tBoxStart && now <= tBoxEnd)
      //if(newBar==true && now>=tBoxStart && now<=tBoxEnd)
      {
         BoxHigh[i] = 0;
         BoxLow[i] = 0;

         iEntryBar[i] = -1;
         SignalSended[i] = 0;
         bSignalSended = false;
         return;
      } else
      //--- bar after End
      //if(now>tBoxEnd)
      {
         BoxHigh[i] = boxHigh;
         BoxLow[i] = boxLow;

         //--- 1. Pivots and Middle Points -----------------------------
         int boxTimeD1 = iBarShift(Symbol(), PERIOD_D1, Time[boxStartShift], false);

         BarPivot[boxStartShift] = iMA(Symbol(), PERIOD_D1, 1, 0, MODE_SMA, PRICE_TYPICAL, boxTimeD1 + 1);
         BarMiddle[boxStartShift] = iMA(Symbol(), PERIOD_D1, 1, 0, MODE_SMA, PRICE_MEDIAN, boxTimeD1 + 1);

         //--- Trade direction
         double minPivot = MathMin(BarPivot[boxStartShift], BarMiddle[boxStartShift]);
         double maxPivot = MathMax(BarPivot[boxStartShift], BarMiddle[boxStartShift]);

         double dClose1 = iClose(Symbol(), PERIOD_D1, boxTimeD1 + 1);

         if (dClose1 > maxPivot) {
            if (dClose1 > iHigh(Symbol(), PERIOD_D1, boxTimeD1 + 2))
               TradeUP[boxStartShift] = boxHigh;
         } else
         if (dClose1 < minPivot) {
            if (dClose1 < iLow(Symbol(), PERIOD_D1, boxTimeD1 + 2))
               TradeDN[boxStartShift] = boxLow;
         }

         show_boxes(now);
      }
   } else
      return;

   //if(now>=D'2020.04.09 16:00')
   if (now >= D'2020.04.16 05:45')
      //if(now>=D'2020.04.16 18:00')
      int pp = 3;

   //--- 2. Entry Points -----------------------------------------
   //if(bSignalSended==true)
   if ((newBar == true && bSignalSended == true) || newBar == false)
      //if(newBar==true && bSignalSended==true)
      return;

   //if((newBar==true && now>tBoxEnd) && bSignalSended==false)
   //if((newBar==true && now>tBoxEnd && bSignalSended==false) || (newBar==true && now<tBoxStart && bSignalSended==false))
   //if((newBar==true && now>tBoxEnd) || (newBar==true && now<tBoxStart))
   //if(newBar==true && now>tBoxEnd)
   if (now > tBoxEnd) {
      double dCloseBar1 = iClose(Symbol(), Period(), i + 1);
      if (iEntryBar[i + 1] <= 0) {
         //--- Entry long ---------------------------------
         if (bSignalSended == false && dCloseBar1 > boxHigh) {
            if (dCloseBar1 < boxHigh + boxExtent * EntryLimit_Factor) {
               EntryUP[i] = iOpen(Symbol(), Period(), i);
               iEntryBar[i] = i;
               if (SignalSended[i] == 0) {
                  SignalSended[i] = 1;
                  bSignalSended = true;
                  Send_SignalAlerts(i, "long");
               }
            } else {
               if (iEntryBar[i + 1] > 0) {
                  iEntryBar[i] = iEntryBar[i + 1];
               } else {
                  EntryNO[i] = iOpen(Symbol(), Period(), i);
                  iEntryBar[i] = i;
                  bSignalSended = true;
                  //Print("   long ",Time[i]);
               }
            }
         } else
            //--- Entry short -----------------------------
            if (bSignalSended == false && dCloseBar1 < boxLow) {
               if (dCloseBar1 > boxLow - boxExtent * EntryLimit_Factor) {
                  EntryDN[i] = iOpen(Symbol(), Period(), i);
                  iEntryBar[i] = i;
                  if (SignalSended[i] == 0) {
                     SignalSended[i] = -1;
                     bSignalSended = true;
                     Send_SignalAlerts(i, "short");
                  }
               } else {
                  if (iEntryBar[i + 1] > 0) {
                     iEntryBar[i] = iEntryBar[i + 1];
                  } else {
                     EntryNO[i] = iOpen(Symbol(), Period(), i);
                     iEntryBar[i] = i;
                     //Print("   short ",Time[i],"  limit= ",limit,"  bSignalSended=",bSignalSended,"  newBar= ",newBar,"  Time= ",TimeCurrent()," now=",now,"  oldTime= ",oldTime,"  i=",i);
                     bSignalSended = true;
                  }
               }
            }
      } else {
         SignalSended[i] = 0;
         iEntryBar[i] = iEntryBar[i + 1];
         EntryUP[i] = EMPTY_VALUE;
         EntryDN[i] = EMPTY_VALUE;
         EntryNO[i] = EMPTY_VALUE;
         bSignalSended = false;
      }
   } else {
      SignalSended[i] = 0;
      iEntryBar[i] = iEntryBar[i + 1];
      //iEntryBar[i]   =i;
      EntryUP[i] = EMPTY_VALUE;
      EntryDN[i] = EMPTY_VALUE;
      EntryNO[i] = EMPTY_VALUE;
      //bSignalSended=false;
   }
} //new_tick()

//********************************************************************
//+------------------------------------------------------------------+
void compute_LB_Indi_LEVELS(datetime now)
//+------------------------------------------------------------------+
{
   if (now >= tSessionStart && now <= tSessionEnd)
      return; //--- box already up-to-date, no need to recompute

   //-- determine box and session times
   tBoxStart = StrToTime(TimeToStr(now, TIME_DATE) + " " + StartTime) + GMT_Server_OffsetHours * 3600;
   tBoxEnd = StrToTime(TimeToStr(now, TIME_DATE) + " " + EndTime) + GMT_Server_OffsetHours * 3600;

   if (tBoxStart > tBoxEnd)
      tBoxStart -= 86400; //--- midnight wrap fix

   if (now < tBoxStart) //--- consider the last PAST box
   //if(now < tBoxEnd)      //--- consider the last PAST box
   {
      tBoxStart -= 86400;
      tBoxEnd -= 86400;
      while ((TimeDayOfWeek(tBoxStart) == 0 || TimeDayOfWeek(tBoxStart) == 6) &&
         (TimeDayOfWeek(tBoxEnd) == 0 || TimeDayOfWeek(tBoxEnd) == 6)) {
         //--- box on saturday or sunday: move back 24hours again
         tBoxStart -= 86400;
         tBoxEnd -= 86400;
      }
   }

   tSessionStart = tBoxEnd;
   tSessionEnd = StrToTime(TimeToStr(tSessionStart, TIME_DATE) + " " + SessionEndTime) + GMT_Server_OffsetHours * 3600;;
   if (tSessionStart > tSessionEnd)
      tSessionEnd = tSessionEnd + 86400; //--- midnight wrap fix
   //---if session ends on saturday or sunday, then extend it to monday so it includes the monday morning candles

   //---DodgeV83 - fixed the Monday no box issue
   if (MondayFix == False) {
      if (TimeDayOfWeek(tSessionEnd) == 6 /*saturday*/ )
         tSessionEnd += 2 * 86400;
      if (TimeDayOfWeek(tSessionEnd) == 0 /*sunday*/ )
         tSessionEnd += 86400;
   }

   //--- save the computed session start&end times to avoid recomputing them for each handled trade;
   tLastComputedSessionStart = tSessionStart;
   tLastComputedSessionEnd = tSessionEnd;

   //---determine hi/lo
   boxStartShift = iBarShift(NULL, 0, tBoxStart);
   boxEndShift = iBarShift(NULL, 0, tBoxEnd);
   boxHigh = High[iHighest(NULL, 0, MODE_HIGH, (boxStartShift - boxEndShift + 1), boxEndShift)];
   boxLow = Low[iLowest(NULL, 0, MODE_LOW, (boxStartShift - boxEndShift + 1), boxEndShift)];
   boxMedianPrice = (boxHigh + boxLow) / 2;
   boxExtent = boxHigh - boxLow;

   if (boxExtent >= MaxBoxSizeInPips * pip && LimitBoxToMaxSize == true) // box too large, but we allow to trade it at its max acceptable value
   {
      if (StickBoxToLatestExtreme == true) {
         //--- adjust box parameters to "stick" it to the box high or box low, whichever comes last;
         //--- use M1 bars to maximize price precision
         int boxStartShiftM1 = iBarShift(NULL, PERIOD_M1, tBoxStart);
         int boxEndShiftM1 = iBarShift(NULL, PERIOD_M1, tBoxEnd);
         int boxHighShift = iHighest(NULL, PERIOD_M1, MODE_HIGH, (boxStartShiftM1 - boxEndShiftM1 + 1), boxEndShiftM1);
         int boxLowShift = iLowest(NULL, PERIOD_M1, MODE_LOW, (boxStartShiftM1 - boxEndShiftM1 + 1), boxEndShiftM1);
         boxExtent = MaxBoxSizeInPips * pip;
         if (boxHighShift <= boxLowShift) {
            //--- box high is more recent than box low: stick box to highest price
            if (StickBoxOusideSRlevels == true) {
               boxMedianPrice = boxHigh + boxExtent / 2;
            } else {
               boxMedianPrice = boxHigh - boxExtent / 2;
            }
         } else {
            //--- box low is more recent than box high: stick box to lowest price
            if (StickBoxOusideSRlevels == true) {
               boxMedianPrice = boxLow - boxExtent / 2;
            } else {
               boxMedianPrice = boxLow + boxExtent / 2;
            }
         }
      } else {
         //--- adjust box parameters to recenter it on the EMA(box_time_range) value
         boxExtent = MaxBoxSizeInPips * pip;
         boxMedianPrice = iMA(NULL, 0, boxStartShift - boxEndShift, 0, MODE_EMA, PRICE_MEDIAN, boxEndShift);
      }
   }

   ////---apply LevelsResizeFactor to the box extent
   //   boxExtent *= LevelsResizeFactor;
   ////---recompute box hi/lo prices based on adjusted median price and extent
   //   boxHigh = NormalizeDouble(boxMedianPrice + boxExtent/2,Digits);
   //   boxLow  = NormalizeDouble(boxMedianPrice - boxExtent/2,Digits);

   boxExtent = boxExtent + 2 * BoxOffset_Pips * 10 * Point;
   boxHigh = NormalizeDouble(boxMedianPrice + boxExtent / 2, Digits);
   boxLow = NormalizeDouble(boxMedianPrice - boxExtent / 2, Digits);

   //---restore input Factors;
   TP1Factor = TP1FactorInput;
   SLFactor = SLFactorInput;

   //---compute breakout levels
   BuyEntry = boxHigh;
   SellEntry = boxLow;

   //--- when a Factor is >=10, it is considered as FIXED PIPs rather than a Factor of the box size;
   if (TP1Factor < 10)
      TP1_pips = (int)(boxExtent * TP1Factor / pip);
   else {
      TP1_pips = (int) TP1Factor;
      TP1Factor = TP1_pips * pip / boxExtent;
   }
   BuyTP1 = NormalizeDouble(BuyEntry + TP1_pips * pip, Digits);
   SellTP1 = NormalizeDouble(SellEntry - TP1_pips * pip, Digits);

   if (TP2Factor < 10)
      TP2_pips = (int)(boxExtent * TP2Factor / pip);
   else {
      TP2_pips = (int) TP2Factor;
      TP2Factor = TP2_pips * pip / boxExtent;
   }
   BuyTP2 = NormalizeDouble(BuyEntry + TP2_pips * pip, Digits);
   SellTP2 = NormalizeDouble(SellEntry - TP2_pips * pip, Digits);

   if (SLFactor < 10)
      SL_pips = (int)(boxExtent * SLFactor / pip);
   else {
      SL_pips = (int) SLFactor;
      SLFactor = SL_pips * pip / boxExtent;
   }
   BuySL = NormalizeDouble(BuyEntry - SL_pips * pip, Digits);
   SellSL = NormalizeDouble(SellEntry + SL_pips * pip, Digits);
}

//+------------------------------------------------------------------+
void show_boxes(datetime now)
//+------------------------------------------------------------------+
{
   //--- show session period with a different "background" color
   drawBoxOnce(objPrefix + "Session-" + TimeToStr(tSessionStart, TIME_DATE | TIME_SECONDS), tSessionStart, 0, tSessionEnd, BuyEntry * 2, SessionColor, 1, STYLE_SOLID, true);

   //--- draw pre-breakout box blue/red once per Session:
   if (alreadyDrawn != tBoxEnd) {
      alreadyDrawn = tBoxEnd; // won't redraw until next box

      int tBoxStart2 = (int) tBoxStart + (int)((tBoxEnd - tBoxStart) / 2);

      if (Draw_VerticalLines == true)
         Draw_FirstAndLastVerticalLines();

      //--- draw pre-breakout box blue/red:
      string boxName = objPrefix + "Box-" + TimeToStr(now, TIME_DATE) + "-" + StartTime + "-" + EndTime;
      if (boxExtent >= MaxBoxSizeInPips * pip) //--- box too large: DON'T TRADE !
      {
         if (LimitBoxToMaxSize == false) //--- box too large, but we allow to trade it at its max acceptable value
         {
            drawBox(boxName, tBoxStart, boxLow, tBoxEnd, boxHigh, BoxColorNOK, 1, STYLE_SOLID, true);
            DrawLbl(objPrefix + "Lbl-" + TimeToStr(now, TIME_DATE) + "-" + StartTime + "-" + EndTime, "NO TRADE! (" + DoubleToStr(boxExtent / pip, 0) + "p)", tBoxStart2, boxLow, 12, "Arial Black", LevelColor, 3);
         } else {
            drawBox(boxName, tBoxStart, boxLow, tBoxEnd, boxHigh, BoxColorMAX, 1, STYLE_SOLID, true);
            DrawLbl(objPrefix + "Lbl-" + TimeToStr(now, TIME_DATE) + "-" + StartTime + "-" + EndTime, "MAX LIMIT! (" + DoubleToStr(boxExtent / pip, 0) + "p)", tBoxStart2, boxLow, 12, "Arial Black", LevelColor, 3);
         }
      } else
      if (boxExtent >= MinBoxSizeInPips * pip) //--- box OK
      {
         drawBox(boxName, tBoxStart, boxLow, tBoxEnd, boxHigh, BoxColorOK, 1, STYLE_SOLID, true);
         DrawLbl(objPrefix + "Lbl-" + TimeToStr(now, TIME_DATE) + "-" + StartTime + "-" + EndTime, DoubleToStr(boxExtent / pip, 0) + "p", tBoxStart2, boxLow, 12, "Arial Black", LevelColor, 3);
      } else //--- "Caution!" box
      {
         drawBox(boxName, tBoxStart, boxLow, tBoxEnd, boxHigh, BoxColorNOK, 1, STYLE_SOLID, true);
         DrawLbl(objPrefix + "Lbl-" + TimeToStr(now, TIME_DATE) + "-" + StartTime + "-" + EndTime, "Caution! (" + DoubleToStr(boxExtent / pip, 0) + "p)", tBoxStart2, boxLow, 12, "Arial Black", BoxColorNOK, 3);
      }
      DrawLbl(objPrefix + "Lbl2-" + TimeToStr(now, TIME_DATE) + "-" + StartTime + "-" + EndTime, "", tBoxStart2, boxLow - 6 * pip, 12, "Arial Black", LevelColor, 2);

      //--- draw profit/loss boxes for the session
      if (showProfitZone) {
         double UpperTP, LowerTP;
         UpperTP = BuyTP2;
         LowerTP = SellTP2;

         drawBox(objPrefix + "BuyProfitZone-" + TimeToStr(tSessionStart, TIME_DATE), tSessionStart, BuyTP1, tSessionEnd, UpperTP, ProfitColor, 1, STYLE_SOLID, true);
         drawBox(objPrefix + "SellProfitZone-" + TimeToStr(tSessionStart, TIME_DATE), tSessionStart, SellTP1, tSessionEnd, LowerTP, ProfitColor, 1, STYLE_SOLID, true);
      }

      //--- draw "fib" lines for entry+stop+TP levels: --------------
      string objname = objPrefix + "Fibo-" + TimeToString(tBoxEnd);
      ObjectCreate(objname, OBJ_FIBO, 0, tBoxStart, SellEntry, tBoxStart + FibLength * 60 * 10, BuyEntry);
      ObjectSet(objname, OBJPROP_RAY, false);
      ObjectSet(objname, OBJPROP_LEVELCOLOR, LevelColor);
      ObjectSet(objname, OBJPROP_FIBOLEVELS, 12);
      ObjectSet(objname, OBJPROP_LEVELSTYLE, STYLE_SOLID);

      _SetFibLevel(objname, 0, 0.0, "Buy= %$", true);
      _SetFibLevel(objname, 1, 1.0, "Sell= %$", true);
      _SetFibLevel(objname, 2, -TP1Factor, "Buy TP1%= %$  (+" + DoubleToStr(TP1_pips, 0) + "p)", false);
      _SetFibLevel(objname, 3, 1 + TP1Factor, "Sell TP1%= %$  (+" + DoubleToStr(TP1_pips, 0) + "p)", false);
      _SetFibLevel(objname, 6, -TP2Factor, "Buy TP= %$  (+" + DoubleToStr(TP2_pips, 0) + "p)", false);
      _SetFibLevel(objname, 7, 1 + TP2Factor, "Sell TP= %$  (+" + DoubleToStr(TP2_pips, 0) + "p)", false);

      ObjectSet(objname, OBJPROP_HIDDEN, bSetHiddenObjects);

      //if(now==D'2020.03.25 13:00')
      //int rr=4;
      //datetime cc=now+Period();

      //=============================================================
      //--- Money Management, Trading Capital -----------------------
      if (now >= tBoxEnd && Show_LotsNumber == true) {
         double Capital = 0;
         string sCapital;
         if (AccountRisc == Balance) {
            Capital = AccountBalance();
            sCapital = CR + "Related to: " + "Balance= " + DoubleToString(AccountBalance(), 2) + " " + AccountCurrency();
         } else
         if (AccountRisc == Equity) {
            Capital = AccountEquity();
            sCapital = CR + "Related to: " + "Equity= " + DoubleToString(AccountEquity(), 2) + " " + AccountCurrency();
         } else
         if (AccountRisc == Deposit) {
            Capital = Deposit_Amount;
            sCapital = CR + "Related to: " + "Deposit= " + DoubleToString(Deposit_Amount, 2) + " " + AccountCurrency();
         }

         //--- Money Management, Lots Number ---------------------------
         double amountRisc, numberLots = 0;
         RefreshRates();
         ChartRedraw();

         tickValue = MarketInfo(Symbol(), MODE_TICKVALUE);

         //double spreadValue  =MarketInfo(Symbol(),MODE_SPREAD);
         //double tickSizeValue=MarketInfo(Symbol(),MODE_TICKSIZE);
         //double tickDoubleValue=SymbolInfoDouble(Symbol(),SYMBOL_TRADE_TICK_VALUE_PROFIT);
         //double tickDoubleValue2=SymbolInfoDouble(Symbol(),SYMBOL_TRADE_TICK_VALUE);

         //if(tickValue==0)
         //   while(tickValue==0)
         //      tickValue=MarketInfo(Symbol(),MODE_TICKVALUE);

         if (boxExtent > 0 && tickValue > 0 && pip > 0) {
            if (Enable_LotCalculation == true) {
               amountRisc = Capital * Risc_Percent / 100.0;
               //numberLots=amountRisc/(boxExtent*tickValue/pip);
               numberLots = amountRisc / (boxExtent * tickValue / Point);
               numberLots = NormalizeDouble(numberLots, 2);

               //--- min,max lots
               if (numberLots < MarketInfo(Symbol(), MODE_MINLOT))
                  numberLots = MarketInfo(Symbol(), MODE_MINLOT);
               else
               if (numberLots > MarketInfo(Symbol(), MODE_MAXLOT))
                  numberLots = MarketInfo(Symbol(), MODE_MAXLOT);
            } else {
               numberLots = Fix_Lots;
               //amountRisc=numberLots*(boxExtent*tickValue/pip);
               amountRisc = numberLots * (boxExtent * tickValue / Point);
               Risc_Percent = amountRisc * 100 / Capital;
            }
         }

         //Comment(
         //   "now= ",now,CR,
         //   "boxExtent= ",boxExtent,CR,
         //   "tickValue= ",tickValue,CR,
         //   "spreadValue= ",spreadValue,CR,
         //   "tickSizeValue= ",tickSizeValue,CR,
         //   "tickDoubleValue= ",tickDoubleValue,CR,
         //   "tickDoubleValue2= ",tickDoubleValue2,CR,
         //   "pip= ",pip
         //);

         string sLotsComment = CR + "Lots= " + DoubleToString(numberLots, 2) +
            "; Risc= " + DoubleToString(Risc_Percent, 2) + "%" +
            "; Box= " + DoubleToString(boxExtent / pip, 0) + " p";

         if (numberLots > 0)
            Comment(sTitleComment + sLotsComment + sCapital);
      }
   }
}

//+------------------------------------------------------------------+
void _SetFibLevel(string objname, int level, double value, string descriptionX, bool bShowLevel)
//+------------------------------------------------------------------+
{
   ObjectSet(objname, OBJPROP_FIRSTLEVEL + level, value);
   if ((Show_TradingLevels_Text == true) || (Show_TradingLevels_Text == false && bShowLevel == true))
      ObjectSetFiboDescription(objname, level, descriptionX);

   ObjectSet(objname, OBJPROP_BACK, !VerticalLine_ShowTime);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void getpip() {
   if (Digits == 2 || Digits == 4)
      pip = Point;
   else
   if (Digits == 3 || Digits == 5)
      pip = 10 * Point;
   else
   if (Digits == 6)
      pip = 100 * Point;

   if (Digits == 3 || Digits == 2)
      digits = 2;
   else
      digits = 4;

   //--- indexes
   if (Digits == 1) {
      pip = 10 * Point;
      digits = 1;
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RemoveObjects(string Pref) {
   int i;
   string objname = "";

   for (i = ObjectsTotal(); i >= 0; i--) {
      objname = ObjectName(i);
      if (StringFind(objname, Pref, 0) > -1)
         ObjectDelete(objname);
   }
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void drawBox(
   string objname,
   datetime tStart, double vStart,
   datetime tEnd, double vEnd,
   color c, int width, int style, bool bg
) {
   if (ObjectFind(objname) == -1) {
      ObjectCreate(objname, OBJ_RECTANGLE, 0, tStart, vStart, tEnd, vEnd);
   } else {
      ObjectSet(objname, OBJPROP_TIME1, tStart);
      ObjectSet(objname, OBJPROP_TIME2, tEnd);
      ObjectSet(objname, OBJPROP_PRICE1, vStart);
      ObjectSet(objname, OBJPROP_PRICE2, vEnd);
   }

   ObjectSet(objname, OBJPROP_COLOR, c);
   ObjectSet(objname, OBJPROP_BACK, bg);
   ObjectSet(objname, OBJPROP_WIDTH, width);
   ObjectSet(objname, OBJPROP_STYLE, style);

   ObjectSet(objname, OBJPROP_HIDDEN, bSetHiddenObjects);
}
//+------------------------------------------------------------------+
// drawBoxOnce: draw a Box only once; if it already exists, do nothing
//+------------------------------------------------------------------+
void drawBoxOnce(
   string objname,
   datetime tStart, double vStart,
   datetime tEnd, double vEnd,
   color c, int width, int style, bool bg
) {
   if (ObjectFind(objname) != -1)
      return;

   ObjectCreate(objname, OBJ_RECTANGLE, 0, tStart, vStart, tEnd, vEnd);
   ObjectSet(objname, OBJPROP_COLOR, c);
   ObjectSet(objname, OBJPROP_BACK, bg);
   ObjectSet(objname, OBJPROP_WIDTH, width);
   ObjectSet(objname, OBJPROP_STYLE, style);

   ObjectSet(objname, OBJPROP_HIDDEN, bSetHiddenObjects);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawLbl(string objname, string s, int LTime, double LPrice, int FSize, string Font, color c, int width) {
   if (ObjectFind(objname) < 0) {
      ObjectCreate(objname, OBJ_TEXT, 0, LTime, LPrice);
   } else {
      if (ObjectType(objname) == OBJ_TEXT) {
         ObjectSet(objname, OBJPROP_TIME1, LTime);
         ObjectSet(objname, OBJPROP_PRICE1, LPrice);
      }
   }

   ObjectSet(objname, OBJPROP_FONTSIZE, FSize);
   ObjectSetText(objname, s, FSize, Font, c);

   ObjectSet(objname, OBJPROP_BACK, !VerticalLine_ShowTime);
   ObjectSet(objname, OBJPROP_HIDDEN, bSetHiddenObjects);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Draw_FirstAndLastVerticalLines() {
   color dColor = VerticalLine_Color;
   int iStyle = VerticalLine_Style;
   int iWidth = 1;
   string objName;

   if (Draw_VerticalLines) {
      objName = objPrefix + "VertLine_First" + "_" + TimeToString(tBoxStart);
      Draw_VerticalLine(objName, tBoxStart, dColor, iStyle, iWidth);
   }

   if (Draw_VerticalLines) {
      objName = objPrefix + "VertLine_Last" + "_" + TimeToString(tBoxEnd);
      Draw_VerticalLine(objName, tBoxEnd, dColor, iStyle, iWidth);
   }
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Draw_VerticalLine(string objX, datetime dTime1, color dColor, int iStyle, int iWidth) {
   if (ObjectFind(objX) != -1)
      return;
   ObjectDelete(objX);

   ObjectCreate(objX, OBJ_VLINE, 0, dTime1, 0);
   ObjectSet(objX, OBJPROP_COLOR, dColor);
   ObjectSet(objX, OBJPROP_STYLE, iStyle);
   ObjectSet(objX, OBJPROP_WIDTH, iWidth);

   //ObjectSet(objX,OBJPROP_RAY,true);
   ObjectSet(objX, OBJPROP_RAY, false);
   //ObjectSet(objX,OBJPROP_BACK,true);
   ObjectSet(objX, OBJPROP_BACK, !VerticalLine_ShowTime);

   ObjectSet(objX, OBJPROP_SELECTABLE, true);
   ObjectSet(objX, OBJPROP_SELECTED, false);

   //ObjectSet(objX,OBJPROP_HIDDEN,false);
   ObjectSet(objX, OBJPROP_HIDDEN, bSetHiddenObjects);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Draw_CommentPanel(string objNameX, int sub_window, int x, int y, int width, int height, color bg_color, color border_clrX, int border_widthX, int borderTypeX) {
   string objName = objNameX;
   //string objName = objPfx + objNameX;

   if (ObjectCreate(0, objName, OBJ_RECTANGLE_LABEL, sub_window, 0, 0)) {
      ObjectSetInteger(0, objName, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, objName, OBJPROP_YDISTANCE, y);
      //--- adjust width and height
      //width = width - 1;
      //height = height - 1;
      ObjectSetInteger(0, objName, OBJPROP_XSIZE, width);
      ObjectSetInteger(0, objName, OBJPROP_YSIZE, height);

      ObjectSetInteger(0, objName, OBJPROP_COLOR, border_clrX);
      ObjectSetInteger(0, objName, OBJPROP_BORDER_TYPE, borderTypeX);
      ObjectSetInteger(0, objName, OBJPROP_WIDTH, border_widthX);
      ObjectSetInteger(0, objName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, objName, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSetInteger(0, objName, OBJPROP_BACK, false);
      ObjectSetInteger(0, objName, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, objName, OBJPROP_SELECTED, 0);
      ObjectSetInteger(0, objName, OBJPROP_HIDDEN, false);
      //ObjectSetInteger(0,objName,OBJPROP_HIDDEN,bSetHiddenObjects);
      ObjectSetInteger(0, objName, OBJPROP_ZORDER, 0);
   }

   ObjectSetInteger(0, objName, OBJPROP_BGCOLOR, bg_color);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Send_SignalAlerts(int iBar, string direction) {
   //--- last bar
   if (TimeDayOfYear(Time[iBar]) != TimeDayOfYear(Time[0]))
      return;

   string subject, text;
   string sOrder;
   string sTime;
   double dPrice;

   if (direction == "long") {
      dPrice = iOpen(Symbol(), Period(), iBar) + MarketInfo(Symbol(), MODE_SPREAD) * Point;
      sOrder = "  BUY  signal  Ask= " + DoubleToString(dPrice, Digits);
      //sOrder="  BUY  signal  Ask= "+DoubleToString(MarketInfo(Symbol(),MODE_ASK),Digits);
   } else
   if (direction == "short") {
      dPrice = iOpen(Symbol(), Period(), iBar);
      sOrder = "  SELL signal   Bid= " + DoubleToString(dPrice, Digits);
      //sOrder="  SELL signal   Bid= "+DoubleToString(MarketInfo(Symbol(),MODE_BID),Digits);
   }

   //                            *****************************
   //                            **       ALERTS            **
   //                            *****************************
   string indicator = " (TOTB)";
   //string indicator=" (TOTB)"+"  bSignalSended="+bSignalSended+"  newBar= "+newBar;
   subject = Symbol() + sOrder;
   sTime = TimeToString(iTime(Symbol(), Period(), iBar), TIME_DATE | TIME_MINUTES);
   //sTime=TimeToString(TimeCurrent(),TIME_DATE|TIME_MINUTES);
   //sTime=TimeToString(TimeCurrent(),TIME_MINUTES);
   text = "  " + sTime + indicator;

   if (Send_Alerts == true) {
      Alert(subject, text);
      if (Play_SoundAlert == true)
         PlaySound(Sound_File);
   }

   if (Send_eMails == true)
      SendMail(subject, text);

   if (Send_Notifications == true) {
      string Message2 = StringConcatenate(subject, text);
      SendNotification(Message2);
   }
}

/*--------------------------------------------------------------------
--- Source code:
//   3 Tier London Breakout
* V 3.3b: Fixed the Monday no candles issue on IBFX
*     - added "MondayFix" input.  Set to True to fix IBFX Monday candle issues.
*
* V.3.2b:
*     - added "StickBoxOusideSRlevels" input; inspired by JohnnyBSmart posts; for experimentation+improvement purpose only;
*       when true, the latest extreme (reversal) within the box is used as a S/R level;
*       the box is sticking BEYOND that extreme level;
*       If the reversal point was a "major" reversal, then price will fly away from the box towards the TP zone.
*       We yet have to determine if the reversal will persist (hitting more TP levels),
*       or if it was only a minor retracement (and will come back to us)...
*
* V.3.2a:
*     - fixed "StickBoxToLatestExtreme" option... box was always sticking to the highest price;
*
* V.3.2: Added "StickBoxToLatestExtreme" input (false);
*        when true, the box will "stick" to the box high or low, whichever comes last;
*        when false(default), the box will be centered on the EMA(box_time_range) value, as in previous versions;
*        This extension is targeted at exploring and optimizing the box POSITION in PRICE, as suggested by JohnnyBSmart;
*        Applies only with "LimitBoxToMaxSize" and "StickBoxToLatestExtreme" are true;
*
* V.3.1: setting TP5Factor to 0 will disable TP4 and TP5 levels,
*        giving an equivalent of the V.2 indicator.
*
* V.3: added TP5Factor input: displays 5 TP levels instead of the 3 levels of V.2
*
* V.2: original version by Squalou, posted on forexfactory.com
*       (thread: http://www.forexfactory.com/showthread.php?t=247220)
*     - "3 Tier London Breakout.mq4" indicator can be used for visual help;
-------------------------------------------------------------------*/

//+------------------------------------------------------------------+
