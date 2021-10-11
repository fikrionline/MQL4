//+------------------------------------------------------------------+
//|                                                    EURGBPUSD.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link "https://www.mql5.com"
#property version "1.1"
#property strict

//Choose Pair
extern string Pair1 = "EURGBP";
extern string Pair2 = "EURUSD";
extern string Pair3 = "GBPUSD";
extern int BasicDay = 0;
extern double BasicLot = 1;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
   return (INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {

}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
   //---

   string ShowComment = "Basic Lot " + DoubleToStr(BasicLot, 2) + "\n";
   string Comments1, Comments2, Comments3;

   double TodayOpen1 = iOpen(Pair1, PERIOD_D1, BasicDay);
   double TodayOpen2 = iOpen(Pair2, PERIOD_D1, BasicDay);
   double TodayOpen3 = iOpen(Pair3, PERIOD_D1, BasicDay);

   double PriceBid1 = MarketInfo(Pair1, MODE_BID);
   double PriceBid2 = MarketInfo(Pair2, MODE_BID);
   double PriceBid3 = MarketInfo(Pair3, MODE_BID);
   
   double Lot1 = BasicLot * (PriceBid2 * PriceBid3);
   double Lot2 = BasicLot * (PriceBid3 / PriceBid1);
   double Lot3 = BasicLot * (PriceBid2 / PriceBid1);
   
   double PriceAsk1 = MarketInfo(Pair1, MODE_ASK);
   double PriceAsk2 = MarketInfo(Pair2, MODE_ASK);
   double PriceAsk3 = MarketInfo(Pair3, MODE_ASK);

   double Change1 = 0;
   double Change1Prosentase;
   string PlusMinus1;
   if (TodayOpen1 < PriceBid1) {
      Change1 = PriceBid1 - TodayOpen1;
      PlusMinus1 = "+";
   }
   
   if (TodayOpen1 > PriceBid1) {
      Change1 = TodayOpen1 - PriceBid1;
      PlusMinus1 = "-";
   }
   Change1Prosentase = (Change1 / TodayOpen1) * 100;
   Comments1 = Pair1 + " " + DoubleToStr(TodayOpen1, 5) + " --> " + DoubleToStr(PriceBid1, 5) + " : " + PlusMinus1 + DoubleToStr(Change1Prosentase, 4) + "% : " + PlusMinus1 + DoubleToStr((Change1 / Point()), 0) + " point : Lot " + DoubleToStr(Lot1, 2);

   double Change2 = 0;
   double Change2Prosentase;
   string PlusMinus2;
   if (TodayOpen2 < PriceBid2) {
      Change2 = PriceBid2 - TodayOpen2;
      PlusMinus2 = "+";
   }
   if (TodayOpen2 > PriceBid2) {
      Change2 = TodayOpen2 - PriceBid2;
      PlusMinus2 = "-";
   }
   Change2Prosentase = (Change2 / TodayOpen2) * 100;
   Comments2 = Pair2 + " " + DoubleToStr(TodayOpen2, 5) + " --> " + DoubleToStr(PriceBid2, 5) + " : " + PlusMinus2 + DoubleToStr(Change2Prosentase, 4) + "% : " + PlusMinus2 + DoubleToStr((Change2 / Point()), 0) + " point : Lot " + DoubleToStr(Lot2, 2);

   double Change3 = 0;
   double Change3Prosentase;
   string PlusMinus3;
   if (TodayOpen3 < PriceBid3) {
      Change3 = PriceBid3 - TodayOpen3;
      PlusMinus3 = "+";
   }
   if (TodayOpen3 > PriceBid3) {
      Change3 = TodayOpen3 - PriceBid3;
      PlusMinus3 = "-";
   }
   Change3Prosentase = (Change3 / TodayOpen3) * 100;
   Comments3 = Pair3 + " " + DoubleToStr(TodayOpen3, 5) + " --> " + DoubleToStr(PriceBid3, 5) + " : " + PlusMinus3 + DoubleToStr(Change3Prosentase, 4) + "% : " + PlusMinus3 + DoubleToStr((Change3 / Point()), 0) + " point : Lot " + DoubleToStr(Lot3, 2);

   ShowComment = ShowComment + "\n" + Comments1 + "\n" + Comments2 + "\n" + Comments3;
   Comment(ShowComment);

}
//+------------------------------------------------------------------+
