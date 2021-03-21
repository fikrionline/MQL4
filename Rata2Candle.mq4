//+------------------------------------------------------------------+
//|                                                  Rata2Candle.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property indicator_chart_window

extern int StartFrom = 1;
extern int CandleCount = 5;

double CandleOpen, CandleClose, ProsentaseBullish, ProsentaseBearish;
double CountBullish = 0;
double CountBearish = 0;
int JumlahBullish = 0;
int JumlahBearish = 0;

int init()
{
   for (int i=StartFrom; i<(StartFrom+CandleCount); i++)
   {
      CandleOpen = iOpen(Symbol(), PERIOD_CURRENT, i);
      CandleClose = iClose(Symbol(), PERIOD_CURRENT, i);
      
      if(CandleClose > CandleOpen)
      {
         CountBullish = CountBullish + (CandleClose - CandleOpen);
         JumlahBullish = JumlahBullish + 1;
      }
      
      if(CandleClose < CandleOpen)
      {
         CountBearish = CountBearish + (CandleOpen - CandleClose);
         JumlahBearish = JumlahBearish + 1;
      }
      
   }
   
   ProsentaseBullish = NormalizeDouble((CountBullish / (CountBullish + CountBearish)) * 100, 2);
   ProsentaseBearish = NormalizeDouble((CountBearish / (CountBullish + CountBearish)) * 100, 2);
   
   string comment = ("" + Symbol() + " | " + CandleCount + " candle | bullish " + JumlahBullish + " | bearish " + JumlahBearish + " | bullish " + ProsentaseBullish + "% | bearish " + ProsentaseBearish + "%");
   Comment(comment);
   
   return(0);
   
}


int deinit()
{   
   return(0);
}
  
int start()
{   
   return(0);   
}
