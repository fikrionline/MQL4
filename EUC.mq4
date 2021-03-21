//+------------------------------------------------------------------+
//|                                                          EUC.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property indicator_chart_window

int init()
{
   return(0);
}


int deinit()
{
   
   return(0);
}
  
int start()
{
   double n_EURCHF = MarketInfo("EURCHF", MODE_BID);
   double n_EURUSD = MarketInfo("EURUSD", MODE_BID);
   double n_USDCHF = MarketInfo("USDCHF", MODE_BID);
   
   string comment = ("EURCHF " + DoubleToString(NormalizeDouble(n_EURUSD * n_USDCHF, 5), 5) + " / EURUSD " + DoubleToString(NormalizeDouble(n_EURCHF / n_USDCHF, 5), 5) + " / USDCHF " +  DoubleToString(NormalizeDouble(n_EURCHF / n_EURUSD, 5), 5));
   Comment(comment);
   return(0);
   
}
