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
   double n_gbpusd = MarketInfo("GBPUSD", MODE_BID);
   double n_usdjpy = MarketInfo("USDJPY", MODE_BID);
   
   string comment = ("GBPJPY from GBPUSD and USDJPY = " + n_gbpusd * n_usdjpy);
   Comment(comment);
   return(0);
   
}

