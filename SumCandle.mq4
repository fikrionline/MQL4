//+------------------------------------------------------------------+
//|                                                    SumCandle.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

enum EnumCandleMethod {
   OpenClose = 1,
   HighLow = 2,
};
extern EnumCandleMethod CandleMethod = 1;
extern int CandleCounter = 5;


double SumBullish, SumBearish, CandleOpen, CandleClose, CandleHigh, CandleLow;
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
         
         CandleHigh = iHigh(Symbol(), PERIOD_CURRENT, i);
         CandleLow = iLow(Symbol(), PERIOD_CURRENT, i);
         
         if(CandleClose > CandleOpen) {
            if(CandleMethod == 1) {
               SumBullish = SumBullish + (CandleClose - CandleOpen);
            } else if(CandleMethod == 2) {
               SumBullish = SumBullish + (CandleHigh - CandleLow);
            }
         } else if(CandleClose < CandleOpen){
            if(CandleMethod == 1) {
               SumBearish = SumBearish + (CandleOpen - CandleClose);
            } else if(CandleMethod == 2) {
               SumBearish = SumBearish + (CandleHigh - CandleLow);
            }
         }
         
      }
      
      SumBullish = SumBullish / Point();
      SumBearish = SumBearish / Point();
      
   }
   
   if(CandleMethod == 1) {
      ShowComment = ShowComment + "CandleMethod: Open/Close\n";
   } else if(CandleMethod == 2) {
      ShowComment = ShowComment + "CandleMethod: High/Low\n";
   }
   
   ShowComment = ShowComment + "SumBullish: " + DoubleToString(SumBullish, 0) + " Point\n";
   ShowComment = ShowComment + "SumBearish: " + DoubleToString(SumBearish, 0) + " Point\n";
   Comment(ShowComment);
   
   return (0);
      
}
