//+------------------------------------------------------------------+
//|                                                    SumCandle.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern int CandleCounter = 6;

double SumBullish, SumBearish, CandleOpen, CandleClose;
datetime NextCandle;
string ShowComment;

int init() {

   NextCandle = Time[0] + Period();
   return (0);

}


int start() {

   ShowComment = "";
   ShowComment = ShowComment + "CandleCounter: " + IntegerToString(CandleCounter) + "\n";
   
   if (NextCandle <= Time[0]) {
      NextCandle = Time[0] + Period();
      
      SumBullish = 0;
      SumBearish = 0;
      
      for(int i=1; i<=CandleCounter; i++) {
         
         CandleOpen = iOpen(Symbol(), PERIOD_CURRENT, i);
         CandleClose = iClose(Symbol(), PERIOD_CURRENT, i);
         
         if(CandleClose > CandleOpen) {
            SumBullish = SumBullish + (CandleClose - CandleOpen);
         } else if(CandleClose < CandleOpen){
            SumBearish = SumBearish + (CandleOpen - CandleClose);
         }
         
      }
      
      SumBullish = SumBullish / Point();
      SumBearish = SumBearish / Point();
      
   }
   
   ShowComment = ShowComment + "SumBullish: " + DoubleToString(SumBullish, 0) + " Point\n";
   ShowComment = ShowComment + "SumBearish: " + DoubleToString(SumBearish, 0) + " Point\n";
   Comment(ShowComment);
   
   return (0);
      
}
