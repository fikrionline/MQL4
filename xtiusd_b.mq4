//+------------------------------------------------------------------+
//|                                                     xtiusd_b.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//---- input parameters
extern int KPeriod = 5;
extern int DPeriod = 3;
extern int Slowing = 3;

extern double Level1 = 10;
extern double Level2 = 20;
extern double Level3 = 80;
extern double Level4 = 90;

extern bool   SendNotification = 1;
extern bool   SendAlert  = 1;

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
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+

datetime date_time_now;

void start(){

   string signal_msg = "";
   
   if(date_time_now != Time[0]){
   
      if(Signal() == 1){
         signal_msg = Symbol()+" "+DoubleToString(Period(), 0)+"-minute"+" SO-"+DoubleToString(Level1, 0);
      }
      
      if(Signal() == 2){
         signal_msg = Symbol()+" "+DoubleToString(Period(), 0)+"-minute"+" SO-"+DoubleToString(Level2, 0);
      }
      
      if(Signal() == 3){
         signal_msg = Symbol()+" "+DoubleToString(Period(), 0)+"-minute"+" SO-"+DoubleToString(Level1, 0);
      }
      
      if(Signal() == 4){
         signal_msg = Symbol()+" "+DoubleToString(Period(), 0)+"-minute"+" SO-"+DoubleToString(Level4, 0);
      }
      
      if(Signal() != 0){
         Alert(signal_msg);
         SendNotification(signal_msg);
      }
      
      date_time_now = Time[0];
   }
}

int Signal() {

   int signal = 0;
   string signal_msg = "";

   double iStochastic_533_main_0 = iStochastic(Symbol(), PERIOD_CURRENT, 5, 3, 5, MODE_SMA, 0, MODE_MAIN, 0);
   double iStochastic_533_signal_0 = iStochastic(Symbol(), PERIOD_CURRENT, 5, 3, 5, MODE_SMA, 0, MODE_SIGNAL, 0);
   
   double iStochastic_533_main_1 = iStochastic(Symbol(), PERIOD_CURRENT, 5, 3, 5, MODE_SMA, 0, MODE_MAIN, 1);
   double iStochastic_533_signal_1 = iStochastic(Symbol(), PERIOD_CURRENT, 5, 3, 5, MODE_SMA, 0, MODE_SIGNAL, 1);
   
   if(iStochastic_533_signal_0 < Level1 && iStochastic_533_signal_1 > Level1){
      signal = 1;      
   }
   
   if(iStochastic_533_signal_0 < Level2 && iStochastic_533_signal_1 > Level2){
      signal = 2;      
   }
   
   if(iStochastic_533_signal_0 > Level3 && iStochastic_533_signal_1 < Level3){
      signal = 3;      
   }
   
   if(iStochastic_533_signal_0 > Level4 && iStochastic_533_signal_1 < Level4){
      signal = 4;
   }
   
   return (signal);
   
}