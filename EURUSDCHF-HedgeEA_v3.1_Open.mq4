//+------------------------------------------------------------------+
//|                                                 SpreadsHedge.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link "https://www.mql5.com"
#property version "1.3"
#property strict

//Choose Pair
extern string Pair1 = "EURCHF";
extern string Pair2 = "EURUSD";
extern string Pair3 = "USDCHF";
extern double BasicPricePair1 = 1.10523;
extern double BasicPricePair2 = 1.18838;
extern double BasicPricePair3 = 0.93004;
extern double BasicLot = 0.5;
extern double LevelOrder = 0.25;
extern int SlipPage = 5;
extern double MaxLayer = 10;
extern bool AutoOrder = TRUE;

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
//| Bismillahirrohmanirrohim                                         |
//+------------------------------------------------------------------+
void OnTick() {

   string CommentAutoOrder;
   if (AutoOrder == TRUE) {
      CommentAutoOrder = "Yes";
   } else {
      CommentAutoOrder = "No";
   }

   string ShowComment = "BasicPricePair1 " + DoubleToStr(BasicPricePair1, 5) + " :: BasicLot " + DoubleToStr(BasicLot, 2) + " :: LevelOrder " + DoubleToStr(LevelOrder, 3) + "% :: AutoOrder " + CommentAutoOrder;
   string Comments1, Comments2, Comments3;

   double BasicClose1 = BasicPricePair1;
   double BasicClose2 = BasicPricePair2;
   double BasicClose3 = BasicPricePair3;

   double PriceBid1 = MarketInfo(Pair1, MODE_BID);
   double PriceBid2 = MarketInfo(Pair2, MODE_BID);
   double PriceBid3 = MarketInfo(Pair3, MODE_BID);

   /*
   double Lot1 = BasicLot * (PriceBid2 * PriceBid3);
   double Lot2 = BasicLot * (PriceBid1 / PriceBid3);
   double Lot3 = BasicLot * (PriceBid1 / PriceBid2);
   */

   double Lot1 = BasicLot * (PriceBid2 * PriceBid3);
   double Lot2 = BasicLot * (PriceBid3 / PriceBid1);
   double Lot3 = BasicLot * (PriceBid2 / PriceBid1);

   double PriceAsk1 = MarketInfo(Pair1, MODE_ASK);
   double PriceAsk2 = MarketInfo(Pair2, MODE_ASK);
   double PriceAsk3 = MarketInfo(Pair3, MODE_ASK);

   double Change1, Change1Prosentase;
   string PlusMinus1;
   if (BasicClose1 < PriceBid1) {
      Change1 = PriceBid1 - BasicClose1;
      PlusMinus1 = "+";
   }
   if (BasicClose1 > PriceBid1) {
      Change1 = BasicClose1 - PriceBid1;
      PlusMinus1 = "-";
   }
   Change1Prosentase = (Change1 / BasicClose1) * 100;
   Comments1 = Pair1 + " " + DoubleToStr(BasicClose1, 5) + " --> " + DoubleToStr(PriceBid1, 5) + " = " + PlusMinus1 + DoubleToStr(Change1Prosentase, 3) + "% Lot " + DoubleToStr(Lot1, 2);

   double Change2, Change2Prosentase;
   string PlusMinus2;
   if (BasicClose2 < PriceBid2) {
      Change2 = PriceBid2 - BasicClose2;
      PlusMinus2 = "+";
   }
   if (BasicClose2 > PriceBid2) {
      Change2 = BasicClose2 - PriceBid2;
      PlusMinus2 = "-";
   }
   Change2Prosentase = (Change2 / BasicClose2) * 100;
   Comments2 = Pair2 + " " + DoubleToStr(BasicClose2, 5) + " --> " + DoubleToStr(PriceBid2, 5) + " = " + PlusMinus2 + DoubleToStr(Change2Prosentase, 3) + "% Lot " + DoubleToStr(Lot2, 2);

   double Change3, Change3Prosentase;
   string PlusMinus3;
   if (BasicClose3 < PriceBid3) {
      Change3 = PriceBid3 - BasicClose3;
      PlusMinus3 = "+";
   }
   if (BasicClose3 > PriceBid3) {
      Change3 = BasicClose3 - PriceBid3;
      PlusMinus3 = "-";
   }
   Change3Prosentase = (Change3 / BasicClose3) * 100;
   Comments3 = Pair3 + " " + DoubleToStr(BasicClose3, 5) + " --> " + DoubleToStr(PriceBid3, 5) + " = " + PlusMinus3 + DoubleToStr(Change3Prosentase, 3) + "% Lot " + DoubleToStr(Lot3, 2);

   ShowComment = ShowComment + "\n" + Comments1 + "\n" + Comments2 + "\n" + Comments3;
   Comment(ShowComment);

   //AutoOrder start from here
   if(AutoOrder == TRUE) {
   
      double LevelNow, LevelNext;
      string Magic2A, Magic2B, Magic2CDE, Magic2F, Magic3A, Magic3B, Magic3CDE, Magic3F;
      int MagicNumber2, MagicNumber3, TypeOrder, SendOrder;
   
      if (PlusMinus1 == "+") {
   
         for (int i = 1; i <= MaxLayer; i++) {
            LevelNow = i * LevelOrder;
            LevelNext = (i + 1) * LevelOrder;
            if (Change1Prosentase > LevelNow && Change1Prosentase < LevelNext) {
   
               //Pair2
               Magic2A = "1";
               Magic2B = "2";
               Magic2CDE = DoubleToStr(LevelNow * 100);
               Magic2F = "2";
               MagicNumber2 = StrToInteger(Magic2A + Magic2B + Magic2CDE + Magic2F);
   
               if (PosSelect(MagicNumber2, Pair2) == 0) {
                  TypeOrder = OP_SELL;
                  SendOrder = OrderSend(Pair2, TypeOrder, NormalizeDouble(Lot2, 2), PriceBid2, SlipPage, 0, 0, IntegerToString(MagicNumber2), MagicNumber2, 0, clrNONE);
               }
   
               //Pair3
               Magic3A = "1";
               Magic3B = "3";
               Magic3CDE = DoubleToStr(LevelNow * 100);
               Magic3F = "2";
               MagicNumber3 = StrToInteger(Magic3A + Magic3B + Magic3CDE + Magic3F);
   
               if (PosSelect(MagicNumber3, Pair3) == 0) {
                  TypeOrder = OP_SELL;
                  SendOrder = OrderSend(Pair3, TypeOrder, NormalizeDouble(Lot3, 2), PriceBid3, SlipPage, 0, 0, IntegerToString(MagicNumber3), MagicNumber3, 0, clrNONE);
               }
   
            }
         }
   
      } else if (PlusMinus1 == "-") {
   
         for (int i = 1; i <= MaxLayer; i++) {
            LevelNow = i * LevelOrder;
            LevelNext = (i + 1) * LevelOrder;
            if (Change1Prosentase > LevelNow && Change1Prosentase < LevelNext) {
   
               //Pair2
               Magic2A = "2";
               Magic2B = "2";
               Magic2CDE = DoubleToStr(LevelNow * 100);
               Magic2F = "1";
               MagicNumber2 = StrToInteger(Magic2A + Magic2B + Magic2CDE + Magic2F);
   
               if (PosSelect(MagicNumber2, Pair2) == 0) {
                  TypeOrder = OP_BUY;
                  SendOrder = OrderSend(Pair2, TypeOrder, NormalizeDouble(Lot2, 2), PriceBid2, SlipPage, 0, 0, IntegerToString(MagicNumber2), MagicNumber2, 0, clrNONE);
               }
   
               //Pair3
               Magic3A = "2";
               Magic3B = "3";
               Magic3CDE = DoubleToStr(LevelNow * 100);
               Magic3F = "1";
               MagicNumber3 = StrToInteger(Magic3A + Magic3B + Magic3CDE + Magic3F);
   
               if (PosSelect(MagicNumber3, Pair3) == 0) {
                  TypeOrder = OP_BUY;
                  SendOrder = OrderSend(Pair3, TypeOrder, NormalizeDouble(Lot3, 2), PriceBid3, SlipPage, 0, 0, IntegerToString(MagicNumber3), MagicNumber3, 0, clrNONE);
               }
   
            }
         }
   
      }
   
   }

}

//Check previous order
int PosSelect(int TheMagic, string ThePair) {
   int previous_position = 0;
   for (int k = OrdersTotal() - 1; k >= 0; k--) {
      if (!OrderSelect(k, SELECT_BY_POS)) {
         break;
      }

      if (OrderMagicNumber() != TheMagic) {
         continue;
      }

      if ((OrderCloseTime() == 0) && OrderMagicNumber() == TheMagic) {
         if (OrderType() == OP_BUY) {
            previous_position = 1; //Still have BUY position
         }
         if (OrderType() == OP_SELL) {
            previous_position = -1; //Still have SELL positon
         }
      }
   }

   return (previous_position);

}
