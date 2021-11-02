//+------------------------------------------------------------------+
//|                                                     BTSALert.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

extern bool ShowAlert = true;
extern bool ShowSound = true;
extern bool ShowNotification = true;

string Comments;
datetime NextCandle;
int GetSignal;

int init() {
   NextCandle = Time[0] + Period();
   return (0);
}


int start() {

   if (NextCandle <= Time[0]) {
      NextCandle = Time[0] + Period();
      
      GetSignal = Signal();
      
      if(GetSignal == 1) {
      
         if(ShowAlert == true) {
            Alert(Symbol() + " " + TimeFrameToString(Period()) + " BTS Buy");
         }
         
         if(ShowSound == true) {
            PlaySound("alertBTS.wav");
         }
         
         if(ShowNotification == true) {
            SendNotification(Symbol() + " " + TimeFrameToString(Period()) + " BTS Buy");
         }
         
      } else if(GetSignal == -1) {
         
         if(ShowAlert == true) {
            Alert(Symbol() + " " + TimeFrameToString(Period()) + " BTS Sell");
         }
         
         if(ShowSound == true) {
            PlaySound("alertBTS.wav");
         }
         
         if(ShowNotification == true) {
            SendNotification(Symbol() + " " + TimeFrameToString(Period()) + " BTS Sell");
         }
         
      }      
      
   }
   
   return (0);
   
}


int Signal() {

   int signal = 0;

   double Candle1Open = iOpen(Symbol(), PERIOD_CURRENT, 1);
   double Candle1Close = iClose(Symbol(), PERIOD_CURRENT, 1);
   
   double Candle2Open = iOpen(Symbol(), PERIOD_CURRENT, 2);
   double Candle2Close = iClose(Symbol(), PERIOD_CURRENT, 2);
   
   double Candle2High = iHigh(Symbol(), PERIOD_CURRENT, 2);
   double Candle2Low = iLow(Symbol(), PERIOD_CURRENT, 2);
   
   if((Candle1Open < Candle1Close) && (Candle2Open > Candle2Close)) {
      if(Candle1Close > Candle2High) {
         signal = 1;
      }
   }
   
   if((Candle1Open > Candle1Close) && (Candle2Open < Candle2Close)) {
      if(Candle1Close < Candle2Low) {
         signal = -1;
      }
   }

   return signal;

}


string TimeFrameToString(int tf) // code by TRO
{
   string tfs;

   switch (tf) {
   case PERIOD_M1:
      tfs = "M1";
      break;
   case PERIOD_M5:
      tfs = "M5";
      break;
   case PERIOD_M15:
      tfs = "M15";
      break;
   case PERIOD_M30:
      tfs = "M30";
      break;
   case PERIOD_H1:
      tfs = "H1";
      break;
   case PERIOD_H4:
      tfs = "H4";
      break;
   case PERIOD_D1:
      tfs = "D1";
      break;
   case PERIOD_W1:
      tfs = "W1";
      break;
   case PERIOD_MN1:
      tfs = "MN";
   }

   return (tfs);
}
