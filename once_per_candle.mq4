//+------------------------------------------------------------------+
//|                                              once_per_candle.mq4 |
//|                                  Copyright © 2009, Qwikisoft.com |
//|                                         http://www.qwikisoft.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, Qwikisoft.com"
#property link      "http://www.qwikisoft.com"


datetime next_candle;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   next_candle=Time[0]+Period();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
   
   if(next_candle<=Time[0])
      {
         next_candle=Time[0]+Period();
         // New candle. Your trading functions here
      }
//----
   return(0);
  }
//+------------------------------------------------------------------+