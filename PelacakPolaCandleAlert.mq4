//+------------------------------------------------------------------+
//|                                       PelacakPolaCandleAlert.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern int     TimeZoneGMT = 4;
extern bool    SendAlert = 0;
extern bool    SendNotif = 1;

datetime next_candle;

//init
int init(){
   next_candle=Time[0]+Period();
   return(0);
}

int deinit(){
   return(0);
}

//Start EA
int start() {

   if (next_candle <= Time[0]) {
      next_candle = Time[0] + Period();
      
      string IndicatorSymbol[29];
      IndicatorSymbol[0] = "AUDCAD";
      IndicatorSymbol[1] = "AUDCHF";
      IndicatorSymbol[2] = "AUDJPY";
      IndicatorSymbol[3] = "AUDNZD";
      IndicatorSymbol[4] = "AUDUSD";
      IndicatorSymbol[5] = "CADCHF";
      IndicatorSymbol[6] = "CADJPY";
      IndicatorSymbol[7] = "CHFJPY";
      IndicatorSymbol[8] = "EURAUD";
      IndicatorSymbol[9] = "EURCAD";
      IndicatorSymbol[10] = "EURCHF";
      IndicatorSymbol[11] = "EURGBP";
      IndicatorSymbol[12] = "EURJPY";
      IndicatorSymbol[13] = "EURNZD";
      IndicatorSymbol[14] = "EURUSD";
      IndicatorSymbol[15] = "GBPAUD";
      IndicatorSymbol[16] = "GBPCAD";
      IndicatorSymbol[17] = "GBPCHF";
      IndicatorSymbol[18] = "GBPJPY";
      IndicatorSymbol[19] = "GBPNZD";
      IndicatorSymbol[20] = "GBPUSD";
      IndicatorSymbol[21] = "NZDCAD";
      IndicatorSymbol[22] = "NZDCHF";
      IndicatorSymbol[23] = "NZDJPY";
      IndicatorSymbol[24] = "NZDUSD";
      IndicatorSymbol[25] = "USDCAD";
      IndicatorSymbol[26] = "USDCHF";
      IndicatorSymbol[27] = "USDJPY";
      IndicatorSymbol[28] = "XAUUSD";
      
      double ArrowUp, ArrowDown;
      string alert_text = GetTimeFrame(Period());
      string alert_text_up = "*BULLISH*";
      string alert_text_down = "*BEARISH*";
      
      for (int i=0; i<ArraySize(IndicatorSymbol); i++)
      {
         ArrowUp   = iCustom(IndicatorSymbol[i], PERIOD_CURRENT, "PelacakPolaCandle", 1, 1);
         ArrowDown = iCustom(IndicatorSymbol[i], PERIOD_CURRENT, "PelacakPolaCandle", 0, 1);
         
         if(ArrowUp != 2147483647)
         {
            alert_text_up = alert_text_up + "\n" + IndicatorSymbol[i];
         }
         
         if(ArrowDown != 2147483647)
         {
            alert_text_down = alert_text_down + "\n" + IndicatorSymbol[i];
         }
         
      }
      
      alert_text = alert_text + "\n\n" + alert_text_up + "\n\n" + alert_text_down + "\n\n" + TimeToStr(TimeCurrent(), TIME_SECONDS) + " / " + TimeToStr((TimeCurrent() + TimeZoneGMT * 3600), TIME_SECONDS) + " WIB";
      
      if(SendAlert == true) {
         Alert(alert_text);
      }
      if(SendNotif == true) {
         SendNotification(alert_text);
      }
         
  }
  
  return (0);

}

//Get TimeFrame
string GetTimeFrame(int GetPeriod)
{
   switch(GetPeriod)
   {
      case 1: return("M1");
      case 5: return("M5");
      case 15: return("M15"); 
      case 30: return("M30");
      case 60: return("H1");
      case 240: return("H4");
      case 1440: return("D1");
      case 10080: return("W1"); 
      case 43200: return("MN1"); 
   }
   
   return IntegerToString(GetPeriod);

}
