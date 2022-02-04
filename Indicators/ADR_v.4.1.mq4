//+------------------------------------------------------------------+
//|                                         Average Daily Range - V3.9-8.mq4 |
//+------------------------------------------------------------------+

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red

extern bool Print_Historical_HL_lines=true;
extern int Historical_HL_line_Bars=5;
extern color ADR_color_above=clrGreen;
extern color ADR_color_below=clrRed;
extern int TimeZoneOfData= 0;
int             NumOfDays_D             = 1;

extern bool ADR_Alert_Sound=false;
extern bool ADR_Line=true;
extern ENUM_LINE_STYLE ADR_linestyle=STYLE_DOT;
extern int ADR_Linethickness=3;
extern color ADR_Line_Colour = clrYellow;
extern bool Daily_Open_Line=true;
extern ENUM_LINE_STYLE Daily_Open_linestyle=STYLE_DOT;
extern int Daily_Open_Linethickness=1;
extern color Daily_Open_Line_Colour = clrRed;

extern bool display_ADR = true;
extern bool     Y_enabled = true;
extern bool     M_enabled = true;
extern int      NumOfDays_M             = 30;
extern bool     M6_enabled = true;
extern bool M6_Trading_weighting = false;
extern int Recent_Days_Weighting = 5;
extern bool Weighting_to_ADR_percentage = true;
extern int      NumOfDays_6M            = 180;
extern string   FontName              = "Courier New";
extern int      FontSize              = 12;
extern color    FontColor             = Yellow;
extern int      Window                = 0;
extern int      Corner                = 1;
extern int      HorizPos              = 150;
extern int      VertPos               = 20;
extern color    FontColor2            = Lime;
extern int      Font2Size             = 12;

int      DistanceL, DistanceHv, DistanceH, Distance6Mv, Distance6M, DistanceMv, DistanceM, DistanceYv, DistanceY, DistanceADRv, DistanceADR, Distance6Mv_new, Distance6M_new;

double pnt;
int    dig;
string objname = "DRPE";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CSumDays
{
public:
   double            m_sum;
   int               m_days;
                     CSumDays(double sum, int days)
   {
      m_sum = sum;
      m_days = days;
   }
};
 double TodayOpenBuffer[];
//+------------------------------------------------------------------+
int init()
{
   
   SetIndexStyle(0,DRAW_LINE,Daily_Open_linestyle,Daily_Open_Linethickness, Daily_Open_Line_Colour);
	SetIndexBuffer(0,TodayOpenBuffer);
	SetIndexLabel(0,"Daily Open");
	SetIndexEmptyValue(0,0.0);
//+------------------------------------------------------------------+
   pnt = MarketInfo(Symbol(), MODE_POINT);
   dig = MarketInfo(Symbol(), MODE_DIGITS);
   if(dig == 3 || dig == 5)
   {
      pnt *= 10;
   }
   ObjectCreate(objname + "ADR", OBJ_LABEL, Window, 0, 0);
   ObjectCreate(objname + "%", OBJ_LABEL, Window, 0, 0);
   if (Y_enabled)
   {
      ObjectCreate(objname + "Y", OBJ_LABEL, Window, 0, 0);
      ObjectCreate(objname + "Y-value", OBJ_LABEL, Window, 0, 0);
   }
   if (M_enabled)
   {
      ObjectCreate(objname + "M", OBJ_LABEL, Window, 0, 0);
      ObjectCreate(objname + "M-value", OBJ_LABEL, Window, 0, 0);
   }
   if (M6_enabled)
   {
      ObjectCreate(objname + "6M", OBJ_LABEL, Window, 0, 0);
      ObjectCreate(objname + "6M-value", OBJ_LABEL, Window, 0, 0);
   }
   ObjectCreate(objname + "H", OBJ_LABEL, Window, 0, 0);
   ObjectCreate(objname + "H-value", OBJ_LABEL, Window, 0, 0);
   ObjectCreate(objname + "L", OBJ_LABEL, Window, 0, 0);
   ObjectCreate(objname + "L-value", OBJ_LABEL, Window, 0, 0);
   return(0);
}
//+------------------------------------------------------------------+
int deinit()
{
//+------------------------------------------------------------------+
   ObjectsDeleteAll(0, objname);
   return(0);
}
//+------------------------------------------------------------------+
int start()
{
   int lastbar;
   int counted_bars= IndicatorCounted();
   if (counted_bars>0) counted_bars--;
   lastbar = Bars-counted_bars;	
   
   DailyOpen(0,lastbar);
   
//+------------------------------------------------------------------+
   CSumDays sum_day(0, 0);
   CSumDays sum_m(0, 0);
   CSumDays sum_6m(0, 0);
   CSumDays sum_6m_add(0, 0);
   range(NumOfDays_D, sum_day);
   range(NumOfDays_M, sum_m);
   range(NumOfDays_6M, sum_6m);
   range(Recent_Days_Weighting, sum_6m_add);
   double hi = iHigh(NULL, PERIOD_D1, 0);
   double lo = iLow(NULL, PERIOD_D1, 0);
   if(pnt > 0)
   {
      string Y, M, M6, H, L, ADR;
      double m, m6, h, l;
      if (Y_enabled) Y = DoubleToStr(sum_day.m_sum / sum_day.m_days / pnt, 0);
      m = sum_m.m_sum / sum_m.m_days / pnt;
      M = DoubleToStr(sum_m.m_sum / sum_m.m_days / pnt, 0);
      m6 = sum_6m.m_sum / sum_6m.m_days;
      h = (hi - Bid) / pnt;
      H = DoubleToStr((hi - Bid) / pnt, 0);
      l = (Bid - lo) / pnt;
      L = DoubleToStr((Bid - lo) / pnt, 0);
      if(m6 == 0) return 0;
      double ADR_val;
      if(Weighting_to_ADR_percentage)
      {
         double WADR = ((iHigh(NULL, PERIOD_D1, 0) - iLow(NULL, PERIOD_D1, 0)) + (iHigh(NULL, PERIOD_D1, 1) - iLow(NULL, PERIOD_D1, 1)) + (iHigh(NULL, PERIOD_D1, 2) - iLow(NULL, PERIOD_D1, 2)) +
                        (iHigh(NULL, PERIOD_D1, 3) - iLow(NULL, PERIOD_D1, 3)) + (iHigh(NULL, PERIOD_D1, 4) - iLow(NULL, PERIOD_D1, 4))) / 5;
         double val = (m6 + WADR) / 2 / pnt;
         ADR_val=(h + l) / val * 100;
         ADR = DoubleToStr(ADR_val, 0);
      }
      else
      {
          ADR_val=(h + l) / (m6 / pnt) * 100;
         ADR = DoubleToStr(ADR_val, 0);
      }
      if(M6_Trading_weighting)
      {
         m6 = (m6 + sum_6m_add.m_sum / sum_6m_add.m_days) / 2;
      }
      
      if(ADR_Line)
      {
         for(int k=0;k<Historical_HL_line_Bars;k++)
         {
            range(NumOfDays_M, sum_m,k+1);
            range(NumOfDays_6M, sum_6m,k+1);
            hi = iHigh(NULL, PERIOD_D1, k);
            lo = iLow(NULL, PERIOD_D1, k);
            double m6x=sum_6m.m_sum / sum_6m.m_days;
            if(M6_Trading_weighting)
            {
               m6x = (m6x + sum_6m_add.m_sum / sum_6m_add.m_days) / 2;
            }
            datetime t1=iTime(_Symbol,PERIOD_D1,k)+86400+TimeZoneOfData*3600;
            if(k>0) t1 = iTime(_Symbol, PERIOD_D1, k-1)+TimeZoneOfData*3600;
            ObjectCreate(0,objname+"ADR low line"+(string)k,OBJ_TREND,0,0,hi-m6x);
            ObjectSetInteger(0,objname+"ADR low line"+(string)k,OBJPROP_TIME1,iTime(_Symbol,PERIOD_D1,k)+TimeZoneOfData*3600);
            ObjectSetInteger(0,objname+"ADR low line"+(string)k,OBJPROP_TIME2,t1);
            ObjectSetDouble(0,objname+"ADR low line"+(string)k,OBJPROP_PRICE1,hi-m6x);
            ObjectSetDouble(0,objname+"ADR low line"+(string)k,OBJPROP_PRICE2,hi-m6x);
            ObjectSetInteger(0,objname+"ADR low line"+(string)k,OBJPROP_COLOR,ADR_Line_Colour);
            ObjectSetInteger(0,objname+"ADR low line"+(string)k,OBJPROP_STYLE,ADR_linestyle);
            ObjectSetInteger(0,objname+"ADR low line"+(string)k,OBJPROP_WIDTH,ADR_Linethickness);
            ObjectSetInteger(0,objname+"ADR low line"+(string)k,OBJPROP_RAY,false);
            
            ObjectCreate(0,objname+"ADR high line"+(string)k,OBJ_TREND,0,0,lo+m6x);
            ObjectSetInteger(0,objname+"ADR high line"+(string)k,OBJPROP_TIME1,iTime(_Symbol,PERIOD_D1,k)+TimeZoneOfData*3600);
            ObjectSetInteger(0,objname+"ADR high line"+(string)k,OBJPROP_TIME2,t1);
            ObjectSetDouble(0,objname+"ADR high line"+(string)k,OBJPROP_PRICE1,lo+m6x);
            ObjectSetDouble(0,objname+"ADR high line"+(string)k,OBJPROP_PRICE2,lo+m6x);
            ObjectSetInteger(0,objname+"ADR high line"+(string)k,OBJPROP_COLOR,ADR_Line_Colour);
            ObjectSetInteger(0,objname+"ADR high line"+(string)k,OBJPROP_STYLE,ADR_linestyle);
            ObjectSetInteger(0,objname+"ADR high line"+(string)k,OBJPROP_WIDTH,ADR_Linethickness);
            ObjectSetInteger(0,objname+"ADR high line"+(string)k,OBJPROP_RAY,false);
            
            ObjectSetString(0,objname+"ADR low line"+(string)k,OBJPROP_TOOLTIP,"ADR Low Line "+DoubleToString(hi-m6x,_Digits));
            ObjectSetString(0,objname+"ADR high line"+(string)k,OBJPROP_TOOLTIP,"ADR High Line "+DoubleToString(lo+m6x,_Digits));
            if(!Print_Historical_HL_lines) break;
         }
      }
      m6 = m6 / pnt;
      M6 = DoubleToStr(m6, 0);
      DistanceL = StringLen(L) * 10 + 5;
      DistanceHv = 30;
      DistanceH = StringLen(H) * 10 + 5;
      Distance6Mv = 30;
      Distance6M = StringLen(M6) * 10 + 5;
      DistanceMv = 30;
      DistanceM = StringLen(M) * 10 + 5;
      DistanceYv = 30;
      DistanceY = StringLen(Y) * 10 + 5;
      DistanceADRv = 30;
      DistanceADR = StringLen(ADR) * 10 + 20;
      if(display_ADR)
      {
         ObjectSet(objname + "ADR", OBJPROP_CORNER, Corner);
         ObjectSet(objname + "ADR", OBJPROP_XDISTANCE, HorizPos + DistanceL + DistanceHv + DistanceH + M6_enabled * (Distance6Mv + Distance6M + 10) + M_enabled * (DistanceMv + DistanceM) + Y_enabled * (DistanceYv + DistanceY) + DistanceADRv + DistanceADR);
         ObjectSet(objname + "ADR", OBJPROP_YDISTANCE, VertPos);
         ObjectSetText(objname + "ADR", "ADR", FontSize, FontName, FontColor);
         ObjectSet(objname + "%", OBJPROP_CORNER, Corner);
         ObjectSet(objname + "%", OBJPROP_XDISTANCE, HorizPos + DistanceL + DistanceHv + DistanceH + M6_enabled * (Distance6Mv + Distance6M + 10) + M_enabled * (DistanceMv + DistanceM) + Y_enabled * (DistanceYv + DistanceY) + DistanceADRv);
         ObjectSet(objname + "%", OBJPROP_YDISTANCE, VertPos);
         
         static bool oneTime=true;
         if(ADR_val < 100)
         {
            ObjectSetText(objname + "%", ADR + "%", Font2Size, FontName, ADR_color_below);
            oneTime=true;
         }
         else
         {
            if(ADR_Alert_Sound && oneTime)
            {
               Alert(_Symbol+" ADX >= 100%");
               oneTime=false;
            }
            ObjectSetText(objname + "%", ADR + "%", Font2Size, FontName, ADR_color_above);
         }
      }
      if (Y_enabled)
      {
         ObjectSet(objname + "Y", OBJPROP_CORNER, Corner);
         ObjectSet(objname + "Y", OBJPROP_XDISTANCE, HorizPos + DistanceL + DistanceHv + DistanceH + M6_enabled * (Distance6Mv + Distance6M + 10) + M_enabled * (DistanceMv + DistanceM) + DistanceYv + DistanceY);
         ObjectSet(objname + "Y", OBJPROP_YDISTANCE, VertPos);
         ObjectSetText(objname + "Y", "Y:", Font2Size, FontName, FontColor);
         ObjectSet(objname + "Y-value", OBJPROP_CORNER, Corner);
         ObjectSet(objname + "Y-value", OBJPROP_XDISTANCE, HorizPos + DistanceL + DistanceHv + DistanceH + M6_enabled * (Distance6Mv + Distance6M + 10) + M_enabled * (DistanceMv + DistanceM) + DistanceYv);
         ObjectSet(objname + "Y-value", OBJPROP_YDISTANCE, VertPos);
         ObjectSetText(objname + "Y-value", Y, Font2Size, FontName, FontColor2);
      }
      if (M_enabled)
      {
         ObjectSet(objname + "M", OBJPROP_CORNER, Corner);
         ObjectSet(objname + "M", OBJPROP_XDISTANCE, HorizPos + DistanceL + DistanceHv + DistanceH + M6_enabled * (Distance6Mv + Distance6M + 10) + DistanceMv + DistanceM);
         ObjectSet(objname + "M", OBJPROP_YDISTANCE, VertPos);
         ObjectSetText(objname + "M", "M:", Font2Size, FontName, FontColor);
         ObjectSet(objname + "M-value", OBJPROP_CORNER, Corner);
         ObjectSet(objname + "M-value", OBJPROP_XDISTANCE, HorizPos + DistanceL + DistanceHv + DistanceH + M6_enabled * (Distance6Mv + Distance6M + 10) + DistanceMv);
         ObjectSet(objname + "M-value", OBJPROP_YDISTANCE, VertPos);
         ObjectSetText(objname + "M-value", M, Font2Size, FontName, FontColor2);
      }
      if (M6_enabled)
      {
         ObjectSet(objname + "6M", OBJPROP_CORNER, Corner);
         ObjectSet(objname + "6M", OBJPROP_XDISTANCE, HorizPos + DistanceL + DistanceHv + DistanceH + Distance6Mv + Distance6M);
         ObjectSet(objname + "6M", OBJPROP_YDISTANCE, VertPos);
         ObjectSetText(objname + "6M", "6M:", Font2Size, FontName, FontColor);
         ObjectSet(objname + "6M-value", OBJPROP_CORNER, Corner);
         ObjectSet(objname + "6M-value", OBJPROP_XDISTANCE, HorizPos + DistanceL + DistanceHv + DistanceH + Distance6Mv);
         ObjectSet(objname + "6M-value", OBJPROP_YDISTANCE, VertPos);
         ObjectSetText(objname + "6M-value", M6, Font2Size, FontName, FontColor2);
      }
      ObjectSet(objname + "H", OBJPROP_CORNER, Corner);
      ObjectSet(objname + "H", OBJPROP_XDISTANCE, HorizPos + DistanceL + DistanceHv + DistanceH);
      ObjectSet(objname + "H", OBJPROP_YDISTANCE, VertPos);
      ObjectSetText(objname + "H", "H:", Font2Size, FontName, FontColor);
      ObjectSet(objname + "H-value", OBJPROP_CORNER, Corner);
      ObjectSet(objname + "H-value", OBJPROP_XDISTANCE, HorizPos + DistanceL + DistanceHv);
      ObjectSet(objname + "H-value", OBJPROP_YDISTANCE, VertPos);
      ObjectSetText(objname + "H-value", H, Font2Size, FontName, FontColor2);
      ObjectSet(objname + "L", OBJPROP_CORNER, Corner);
      ObjectSet(objname + "L", OBJPROP_XDISTANCE, HorizPos + DistanceL);
      ObjectSet(objname + "L", OBJPROP_YDISTANCE, VertPos);
      ObjectSetText(objname + "L", "L:", Font2Size, FontName, FontColor);
      ObjectSet(objname + "L-value", OBJPROP_CORNER, Corner);
      ObjectSet(objname + "L-value", OBJPROP_XDISTANCE, HorizPos);
      ObjectSet(objname + "L-value", OBJPROP_YDISTANCE, VertPos);
      ObjectSetText(objname + "L-value", L, Font2Size, FontName, FontColor2);
   }
   return(0);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void range(int days, CSumDays &sumdays, int k=1)
{
   sumdays.m_days = 0;
   sumdays.m_sum = 0;
   for(int i = k; i < Bars - 1; i++)
   {
      double hi = iHigh(NULL, PERIOD_D1, i);
      double lo = iLow(NULL, PERIOD_D1, i);
      datetime dt = iTime(NULL, PERIOD_D1, i);
      if(TimeDayOfWeek(dt) > 0 && TimeDayOfWeek(dt) < 6)
      {
         sumdays.m_sum += hi - lo;
         sumdays.m_days = sumdays.m_days + 1;
         if(sumdays.m_days >= days) break;
      }
   }
}

//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
int DailyOpen(int offset, int lastbar)
{
   int shift;
   int tzdiffsec= TimeZoneOfData * 3600;
   double barsper30= 1.0*PERIOD_M30/Period();
   bool ShowDailyOpenLevel= True;
   // lastbar+= barsperday+2;  // make sure we catch the daily open		 
   lastbar= MathMin(Bars-20*barsper30-1, lastbar);

	for(shift=lastbar;shift>=offset;shift--)
	{
	  if(Daily_Open_Line)
	  {
	  TodayOpenBuffer[shift]= 0;
     if (ShowDailyOpenLevel){
       if(TimeDayOfWeek(Time[shift]-tzdiffsec) != TimeDayOfWeek(Time[shift+1]-tzdiffsec)){      // day change
         TodayOpenBuffer[shift]= Open[shift];         
         TodayOpenBuffer[shift+1]= 0;                                                           // avoid stairs in the line
       }
       else{
         TodayOpenBuffer[shift]= TodayOpenBuffer[shift+1];
       }
	  }
	  }
	  else
	  {
	   TodayOpenBuffer[shift]=0.0;
	  }
   }
   return(0);
}