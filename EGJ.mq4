//+------------------------------------------------------------------+
//|                                                          EGJ.mq4 |
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
   double n_EURGBP = MarketInfo("EURGBP", MODE_BID);
   double n_EURJPY = MarketInfo("EURJPY", MODE_BID);
   double n_GBPJPY = MarketInfo("GBPJPY", MODE_BID);
   
   string comment = ("EURGBP " + DoubleToString(NormalizeDouble(n_EURJPY / n_GBPJPY, 5), 5) + " / EURJPY " + DoubleToString(NormalizeDouble(n_EURGBP * n_GBPJPY, 3), 3) + " / GBPJPY " +  DoubleToString(NormalizeDouble(n_EURJPY / n_EURGBP, 3), 3));
   Comment(comment);
   return(0);
   
}
