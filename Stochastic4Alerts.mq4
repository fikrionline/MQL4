//+------------------------------------------------------------------+
//|                                            Stochastic4Alerts.mq4 |
//|                                   Copyright © 2009 Nakagava Ltd. |
//|                                       http://www.nakagava.com/   |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, Nakagava Ltd."
#property link      "http://www.nakagava.com/"

#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 100
#property indicator_buffers 2
#property indicator_color1 FireBrick
#property indicator_color2 White
//---- input parameters
extern int KPeriod=8;
extern int DPeriod=3;
extern int Slowing=3;

extern double Level1= 10;
extern double Level2= 90;
extern double Level3= 0;
extern double Level4= 0;
extern string AlertFile1= "alert.wav";
extern string AlertFile2= "alert.wav";
extern string AlertFile3= "";
extern string AlertFile4= "";

//---- buffers
double MainBuffer[];
double SignalBuffer[];
double HighesBuffer[];
double LowesBuffer[];
//----
int draw_begin1=0;
int draw_begin2=0;

double lastBid;
datetime alert[4];
bool bFirstTick;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- 2 additional buffers are used for counting.
   IndicatorBuffers(4);
   SetIndexBuffer(2, HighesBuffer);
   SetIndexBuffer(3, LowesBuffer);
//---- indicator lines
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0, MainBuffer);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1, SignalBuffer);
//---- name for DataWindow and indicator subwindow label
   short_name="Sto("+KPeriod+","+DPeriod+","+Slowing+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
   SetIndexLabel(1,"Signal");
//----
   draw_begin1=KPeriod+Slowing;
   draw_begin2=draw_begin1+DPeriod;
   SetIndexDrawBegin(0,draw_begin1);
   SetIndexDrawBegin(1,draw_begin2);
   bFirstTick= false;
   alert[0]= 0;
   alert[1]= 0;
   alert[2]= 0;
   alert[3]= 0;
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Stochastic oscillator                                            |
//+------------------------------------------------------------------+
int start()
  {
   int    i,k;
   int    counted_bars=IndicatorCounted();
   double price;
//----
   if(Bars<=draw_begin2) return(0);
//---- initial zero
   if(counted_bars<1)
     {
      for(i=1;i<=draw_begin1;i++) MainBuffer[Bars-i]=0;
      for(i=1;i<=draw_begin2;i++) SignalBuffer[Bars-i]=0;
     }
//---- minimums counting
   i=Bars-KPeriod;
   if(counted_bars>KPeriod) i=Bars-counted_bars-1;
   while(i>=0)
     {
      double min=1000000;
      k=i+KPeriod-1;
      while(k>=i)
        {
         price=Low[k];
         if(min>price) min=price;
         k--;
        }
      LowesBuffer[i]=min;
      i--;
     }
//---- maximums counting
   i=Bars-KPeriod;
   if(counted_bars>KPeriod) i=Bars-counted_bars-1;
   while(i>=0)
     {
      double max=-1000000;
      k=i+KPeriod-1;
      while(k>=i)
        {
         price=High[k];
         if(max<price) max=price;
         k--;
        }
      HighesBuffer[i]=max;
      i--;
     }
//---- %K line
   i=Bars-draw_begin1;
   if(counted_bars>draw_begin1) i=Bars-counted_bars-1;
   while(i>=0)
     {
      double sumlow=0.0;
      double sumhigh=0.0;
      for(k=(i+Slowing-1);k>=i;k--)
        {
         sumlow+=Close[k]-LowesBuffer[k];
         sumhigh+=HighesBuffer[k]-LowesBuffer[k];
        }
      if(sumhigh==0.0) MainBuffer[i]=100.0;
      else MainBuffer[i]=sumlow/sumhigh*100;
      i--;
     }
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
//---- signal line is simple movimg average
   for(i=0; i<limit; i++)
      SignalBuffer[i]=iMAOnArray(MainBuffer,Bars,DPeriod,0,MODE_SMA,i);
//----
if(bFirstTick)
{
   if(IsCross(lastBid, MainBuffer[0], Level1) && AlertFile1!="" && alert[0]!=Time[0])
   {
      PlaySound(AlertFile1);
      Alert("STOCHASTIC "+Symbol()+" Level1");
      alert[0]= Time[0];
   }
   if(IsCross(lastBid, MainBuffer[0], Level2) && AlertFile2!="" && alert[1]!=Time[0])
   {
      PlaySound(AlertFile2);
      Alert("STOCHASTIC "+Symbol()+" Level2");
      alert[1]= Time[0];
   }
   if(IsCross(lastBid, MainBuffer[0], Level3) && AlertFile3!="" && alert[2]!=Time[0])
   {
      PlaySound(AlertFile3);
      Alert("STOCHASTIC "+Symbol()+" Level3");
      alert[2]= Time[0];
   }
   if(IsCross(lastBid, MainBuffer[0], Level4) && AlertFile4!="" && alert[3]!=Time[0])
   {
      PlaySound(AlertFile4);
      Alert("STOCHASTIC "+Symbol()+" Level4");
      alert[3]= Time[0];
   }         
}
   bFirstTick= true;
   lastBid= MainBuffer[0];
   return(0);
  }
//+------------------------------------------------------------------+

bool IsCross(double price1, double price2, double level)
{
   bool rc= false;
   if((price1>=level && price2<level)||
      (price1<=level && price2>level))
      rc= true;
   return(rc);
}