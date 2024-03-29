//+------------------------------------------------------------------+
//|                                                ScalperSignal.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

//Setting Alert
extern bool   SendAlert = 1;
extern bool   SendNotification = 1;
extern bool   SendTelegram = 0;

//Indicator Stochastic
int KPeriod    = 5;
int DPeriod    = 3;
int Slowing    = 3;
int LevelDown  = 20;
int LevelUp    = 80;

//Run every open candle
datetime next_candle;

int init(){
   next_candle = Time[0] + Period();
   return(0);
}

int deinit(){
   return(0);
}


int start(){
   
   if(next_candle <= Time[0]){
   
      next_candle = Time[0] + Period(); //Now is new candle. Your code after here
      
      //Pair List
      string IndicatorSymbol[30];
      IndicatorSymbol[1] = "AUDCAD";
      IndicatorSymbol[2] = "AUDCHF";
      IndicatorSymbol[3] = "AUDJPY";
      IndicatorSymbol[4] = "AUDNZD";
      IndicatorSymbol[5] = "AUDUSD";
      IndicatorSymbol[6] = "CADCHF";
      IndicatorSymbol[7] = "CADJPY";
      IndicatorSymbol[8] = "CHFJPY";
      IndicatorSymbol[9] = "EURAUD";
      IndicatorSymbol[10] = "EURCAD";
      IndicatorSymbol[11] = "EURCHF";
      IndicatorSymbol[12] = "EURGBP";
      IndicatorSymbol[13] = "EURJPY";
      IndicatorSymbol[14] = "EURNZD";
      IndicatorSymbol[15] = "EURUSD";
      IndicatorSymbol[16] = "GBPAUD";
      IndicatorSymbol[17] = "GBPCAD";
      IndicatorSymbol[18] = "GBPCHF";
      IndicatorSymbol[19] = "GBPJPY";
      IndicatorSymbol[20] = "GBPNZD";
      IndicatorSymbol[21] = "GBPUSD";
      IndicatorSymbol[22] = "NZDCAD";
      IndicatorSymbol[23] = "NZDCHF";
      IndicatorSymbol[24] = "NZDJPY";
      IndicatorSymbol[25] = "NZDUSD";
      IndicatorSymbol[26] = "USDCAD";
      IndicatorSymbol[27] = "USDCHF";
      IndicatorSymbol[28] = "USDJPY";
      IndicatorSymbol[29] = "XAUUSD";
      
      //Setting of message
      string   msg_text = "";
      string   msg_upper_top = Period() + "M UPPER";
      string   msg_lower_top = Period() + "M LOWER";
      string   msg_upper = "";
      string   msg_lower = "";
      
      int candle_upper_checker = 0;
      int candle_lower_checker = 0;
      
      for(int n=1; n<30; n++){
      
         double iBands_1_main = iBands(IndicatorSymbol[n], _Period, 20, 2, 0, PRICE_CLOSE, MODE_MAIN, 1);
         double iBands_1_upper = iBands(IndicatorSymbol[n], _Period, 20, 2, 0, PRICE_CLOSE, MODE_UPPER, 1);
         double iBands_1_lower = iBands(IndicatorSymbol[n], _Period, 20, 2, 0, PRICE_CLOSE, MODE_LOWER, 1);
         
         double iBands_2_main = iBands(IndicatorSymbol[n], _Period, 20, 2, 0, PRICE_CLOSE, MODE_MAIN, 2);
         double iBands_2_upper = iBands(IndicatorSymbol[n], _Period, 20, 2, 0, PRICE_CLOSE, MODE_UPPER, 2);
         double iBands_2_lower = iBands(IndicatorSymbol[n], _Period, 20, 2, 0, PRICE_CLOSE, MODE_LOWER, 2);
         
         if(iClose(IndicatorSymbol[n], _Period, 1) > iBands_1_upper) {
            candle_upper_checker = 1;
            msg_upper = msg_upper + IndicatorSymbol[n] + "\n";
         }
         
         if(iClose(IndicatorSymbol[n], _Period, 1) > iBands_1_lower) {
            candle_lower_checker = 1;
            msg_lower = msg_lower + IndicatorSymbol[n] + "\n";
         }
         
      }
      
      if(candle_upper_checker == 1 || candle_lower_checker == 1){
         
         if(candle_upper_checker == 1){
            msg_text = msg_text + msg_upper_top + "\n" + msg_upper;
         }
         
         if(candle_lower_checker == 1){
            if(candle_upper_checker == 1) {
               msg_text = msg_text + "\n";
            }
            msg_text = msg_text + msg_lower_top + "\n" + msg_lower;
         }
         
         msg_text = msg_text + "\n" + TimeToStr(TimeCurrent(), TIME_SECONDS); //Server time
         msg_text = msg_text + "\n" + TimeToStr((TimeCurrent() + 4 * 3600), TIME_SECONDS) + "WIB"; //Convert server time to WIB
         
         if(SendAlert == true){
            Alert(msg_text);
         }
         
         if(SendNotification == true){
            SendNotification(msg_text);
         }
         
      }
   }

   return(0);
   
}

/*
if(Open[0]>=lowerBand)
        {  // Long trades
         if(Open[1]<=lowerBand || PreviousPriceStatus==CROSSED_BELOW_LOWER)
           {
            Print("PRICE closed below BBAND");
            if(DRAW_POSSIBLE_TRADES)
              {
               longLine="GOLONG"+DoubleToStr(Time[0]);
               ObjectCreate(longLine,OBJ_VLINE,0,Time[0],0);
               ObjectSetInteger(0,longLine,OBJPROP_COLOR,clrGreen);
              }
            MakeTrade(false,TradesOpen);
           }
        }

      if(Open[0]<=upperBand)
        {  // Short trades
         if(Open[1]>=upperBand || PreviousPriceStatus==CROSSED_ABOVE_HIGHER)
           {
            Print("Price closed above BBAND");
            if(DRAW_POSSIBLE_TRADES)
              {
               shortLine="GOLONG"+DoubleToStr(Time[0]);
               ObjectCreate(shortLine,OBJ_VLINE,0,Time[0],0);
               ObjectSetInteger(0,shortLine,OBJPROP_COLOR,clrRed);
              }
            MakeTrade(true,TradesOpen);
           }
        }
        */
        