//+------------------------------------------------------------------+
//|                                             GUJ_LotSize_v1.0.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link "https://www.mql5.com"
#property version "1.1"
#property strict

//Choose Pair
extern string Pair1 = "GBPUSD";
extern string Pair2 = "USDJPY";
extern string Pair3 = "GBPJPY";
extern int BasicDay = 0;
extern double BasicLot = 0.5;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
   //---

   //---
   return (INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   //---

}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
   //---

   string ShowComment = "BasicDay " + IntegerToString(BasicDay) + " :: BasicLot " + DoubleToStr(BasicLot, 2);
   string Comments1, Comments2, Comments3;

   double BasicOpen1 = iOpen(Pair1, PERIOD_D1, BasicDay);
   double BasicOpen2 = iOpen(Pair2, PERIOD_D1, BasicDay);
   double BasicOpen3 = iOpen(Pair3, PERIOD_D1, BasicDay);

   double PriceBid1 = MarketInfo(Pair1, MODE_BID);
   double PriceBid2 = MarketInfo(Pair2, MODE_BID);
   double PriceBid3 = MarketInfo(Pair3, MODE_BID);
   
   double Lot1 = BasicLot * (PriceBid3 / PriceBid2);
   double Lot2 = BasicLot * (PriceBid3 / PriceBid1) / 100;
   double Lot3 = BasicLot * (PriceBid1 * PriceBid2) / 100;
   
   double PriceAsk1 = MarketInfo(Pair1, MODE_ASK);
   double PriceAsk2 = MarketInfo(Pair2, MODE_ASK);
   double PriceAsk3 = MarketInfo(Pair3, MODE_ASK);

   double Change1, Change1Prosentase;
   string PlusMinus1;
   if (BasicOpen1 < PriceBid1) {
      Change1 = PriceBid1 - BasicOpen1;
      PlusMinus1 = "+";
   }
   if (BasicOpen1 > PriceBid1) {
      Change1 = BasicOpen1 - PriceBid1;
      PlusMinus1 = "-";
   }
   Change1Prosentase = (Change1 / BasicOpen1) * 100;
   Comments1 = Pair1 + " " + DoubleToStr(BasicOpen1, 5) + " --> " + DoubleToStr(PriceBid1, 5) + " = " + PlusMinus1 + DoubleToStr(Change1Prosentase, 3) + "% Lot " + DoubleToStr(Lot1, 2);

   double Change2, Change2Prosentase;
   string PlusMinus2;
   if (BasicOpen2 < PriceBid2) {
      Change2 = PriceBid2 - BasicOpen2;
      PlusMinus2 = "+";
   }
   if (BasicOpen2 > PriceBid2) {
      Change2 = BasicOpen2 - PriceBid2;
      PlusMinus2 = "-";
   }
   Change2Prosentase = (Change2 / BasicOpen2) * 100;
   Comments2 = Pair2 + " " + DoubleToStr(BasicOpen2, 5) + " --> " + DoubleToStr(PriceBid2, 5) + " = " + PlusMinus2 + DoubleToStr(Change2Prosentase, 3) + "% Lot " + DoubleToStr(Lot2, 2);

   double Change3, Change3Prosentase;
   string PlusMinus3;
   if (BasicOpen3 < PriceBid3) {
      Change3 = PriceBid3 - BasicOpen3;
      PlusMinus3 = "+";
   }
   if (BasicOpen3 > PriceBid3) {
      Change3 = BasicOpen3 - PriceBid3;
      PlusMinus3 = "-";
   }
   Change3Prosentase = (Change3 / BasicOpen3) * 100;
   Comments3 = Pair3 + " " + DoubleToStr(BasicOpen3, 5) + " --> " + DoubleToStr(PriceBid3, 5) + " = " + PlusMinus3 + DoubleToStr(Change3Prosentase, 3) + "% Lot " + DoubleToStr(Lot3, 2);

   ShowComment = ShowComment + "\n" + Comments1 + "\n" + Comments2 + "\n" + Comments3;
   Comment(ShowComment);

}
//+------------------------------------------------------------------+
