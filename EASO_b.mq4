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

extern int LevelDown = 20;
extern int LevelUp = 80;

extern bool   SendAlert = 1;
extern bool   SendNotification = 1;

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
      
      string   msg_text = "";
      int      msg_pair_20_send = 0;
      int      msg_pair_80_send = 0;
      string   msg_pair_20_text_top = Period() + "M SO<20";
      string   msg_pair_80_text_top = Period() + "M SO>80";
      string   msg_pair_20_text = "";
      string   msg_pair_80_text = "";
      
      
      for(int n=1; n<30; n++){
      
         double iStochastic_533_main_0 = iStochastic(IndicatorSymbol[n], Period(), KPeriod, DPeriod, Slowing, MODE_SMA, 0, MODE_MAIN, 0);
         double iStochastic_533_signal_0 = iStochastic(IndicatorSymbol[n], Period(), KPeriod, DPeriod, Slowing, MODE_SMA, 0, MODE_SIGNAL, 0);
         
         if(iStochastic_533_main_0 < LevelDown && iStochastic_533_signal_0 < LevelDown){
            msg_pair_20_send = 1;
            msg_pair_20_text = msg_pair_20_text + IndicatorSymbol[n] + "\n";
         }
         
         if(iStochastic_533_main_0 > LevelUp && iStochastic_533_signal_0 > LevelUp){
            msg_pair_80_send = 1;
            msg_pair_80_text = msg_pair_80_text + IndicatorSymbol[n] + "\n";
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
