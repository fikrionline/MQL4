//+------------------------------------------------------------------+
//|                                              once_per_candle.mq4 |
//|                                  Copyright © 2009, Qwikisoft.com |
//|                                         http://www.qwikisoft.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, Qwikisoft.com"
#property link      "http://www.qwikisoft.com"

//---- input parameters
extern int KPeriod = 5;
extern int DPeriod = 3;
extern int Slowing = 3;

extern double LevelDown = 20;
extern double LevelUp = 80;

extern bool   SendNotification = 1;
extern bool   SendAlert  = 1;

extern int DayPeriod = 7;

datetime next_candle;

int init(){
   next_candle=Time[0]+Period();
   return(0);
}

int deinit(){
   return(0);
}

int start(){
   
   if(next_candle <= Time[0]){
   
      next_candle = Time[0] + Period(); //New candle. Your trading functions after here
      
      //String IndicatorSymbol[29];
      string IndicatorSymbol[5];
      IndicatorSymbol[1] = "SpotCrude";
      IndicatorSymbol[2] = "XTIUSD";
      IndicatorSymbol[3] = "XBRUSD";
      IndicatorSymbol[4] = "XNGUSD";
      
      string   msg_text = "";
      int      msg_pair_20_send = 0;
      int      msg_pair_80_send = 0;
      string   msg_pair_20_text_top = Period() + "M SO<20";
      string   msg_pair_80_text_top = Period() + "M SO>80";
      string   msg_pair_20_text = "";
      string   msg_pair_80_text = "";
      
      for(int n=1; n<5; n++){
      
         //Today Range
         double today_range = iHigh(Symbol(), PERIOD_D1, 0) - iLow(IndicatorSymbol[n], PERIOD_D1, 0);
         double range_day_period = 0;
         for(int r=1; r<=DayPeriod; r++){
            range_day_period = range_day_period + (iHigh(IndicatorSymbol[n], PERIOD_D1, r) - iLow(Symbol(), PERIOD_D1, r));
         }
         range_day_period = range_day_period / DayPeriod;
      
         double iStochastic_533_main_0 = iStochastic(IndicatorSymbol[n], Period(), KPeriod, DPeriod, Slowing, MODE_SMA, 0, MODE_MAIN, 0);
         double iStochastic_533_signal_0 = iStochastic(IndicatorSymbol[n], Period(), KPeriod, DPeriod, Slowing, MODE_SMA, 0, MODE_SIGNAL, 0);
         
         if(iStochastic_533_main_0 < LevelDown && iStochastic_533_signal_0 < LevelDown){
            msg_pair_20_send = 1;
            msg_pair_20_text = msg_pair_20_text + IndicatorSymbol[n] + " " + DoubleToStr(MathAbs(today_range/Point), 0) + "/" + DoubleToStr(MathAbs(range_day_period/Point), 0) + "\n";
         }
         
         if(iStochastic_533_main_0 > LevelUp && iStochastic_533_signal_0 > LevelUp){
            msg_pair_80_send = 1;
            msg_pair_80_text = msg_pair_80_text + IndicatorSymbol[n] + " " + DoubleToStr(MathAbs(today_range/Point), 0) + "/" + DoubleToStr(MathAbs(range_day_period/Point), 0) + "\n";
         }
         
      }
      
      if(msg_pair_20_send == 1 || msg_pair_80_send == 1){
         
         if(msg_pair_80_send == 1){
            msg_text = msg_text + msg_pair_80_text_top + "\n" + msg_pair_80_text;
         }
         
         if(msg_pair_20_send == 1){
            if(msg_pair_80_send == 1){
               msg_text = msg_text + "\n";
            }
            msg_text = msg_text + msg_pair_20_text_top + "\n" + msg_pair_20_text;
         }
         
         msg_text = msg_text + "\n" + TimeToStr(TimeCurrent(), TIME_SECONDS) + "\n" + TimeToStr((TimeCurrent() + 4 * 3600), TIME_SECONDS) + "WIB";
         Alert(msg_text);
         SendNotification(msg_text);
         
      }
   }

   return(0);
   
}

double AvgDayRange(int nth_day)
{
   double   R1,R5,R10,R20;
   int   i;  

   R1 =  (iHigh(NULL,PERIOD_D1,nth_day)-iLow(NULL,PERIOD_D1,nth_day));
   for(i=0;i<5;i++)  R5    =  R5  +  (iHigh(NULL,PERIOD_D1,nth_day+i)-iLow(NULL,PERIOD_D1,nth_day+i));
   for(i=0;i<10;i++) R10   =  R10 +  (iHigh(NULL,PERIOD_D1,nth_day+i)-iLow(NULL,PERIOD_D1,nth_day+i));
   for(i=0;i<20;i++) R20   =  R20 +  (iHigh(NULL,PERIOD_D1,nth_day+i)-iLow(NULL,PERIOD_D1,nth_day+i));

   R5          = R5/5;
   R10         = R10/10;
   R20         = R20/20;

   return((R1+R5+R10+R20)/4);
}

