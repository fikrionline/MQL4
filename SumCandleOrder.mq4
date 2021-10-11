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
extern double OrderLot = 0.01;
extern double MaxSlipPage = 3;
extern int MagicNumber = 5758;

double SumBullish, SumBearish, CandleOpen, CandleClose;
datetime NextCandle;
string ShowComment;
int TicketOrder;

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
      
      if(SumBullish > SumBearish) {
         //TicketOrder = OrderSend(Symbol(), OP_BUY, OrderLot, Ask, MaxSlipPage, 0, 0, IntegerToString(MagicNumber), MagicNumber, 0, clrNONE);
         TicketOrder = OrderSend(Symbol(), OP_SELL, OrderLot, Bid, MaxSlipPage, 0, 0, IntegerToString(MagicNumber), MagicNumber, 0, clrNONE);
      } else if (SumBearish > SumBullish) {
         //TicketOrder = OrderSend(Symbol(), OP_SELL, OrderLot, Bid, MaxSlipPage, 0, 0, IntegerToString(MagicNumber), MagicNumber, 0, clrNONE);
         TicketOrder = OrderSend(Symbol(), OP_BUY, OrderLot, Ask, MaxSlipPage, 0, 0, IntegerToString(MagicNumber), MagicNumber, 0, clrNONE);
      }
      
   }
   
   ShowComment = ShowComment + "SumBullish: " + DoubleToString(SumBullish, 0) + " Point\n";
   ShowComment = ShowComment + "SumBearish: " + DoubleToString(SumBearish, 0) + " Point\n";
   ShowComment = ShowComment + "Equity: " + DoubleToString(AccountEquity(), 2);
   Comment(ShowComment);
   
   return (0);
      
}
