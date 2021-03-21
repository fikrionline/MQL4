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
extern int BasicDay = 0;
extern double BasicLot = 0.1;
extern double LevelOrder = 0.5;
extern int MagicNumberPair2 = 57582;
extern int MagicNumberPair3 = 57583;
extern bool AutoOrder = FALSE;
extern int SlipPage = 5;

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

   string ShowComment = "BasicDay " + IntegerToString(BasicDay) + " :: BasicLot " + DoubleToStr(BasicLot, 2) + " :: LevelOrder " + DoubleToStr(LevelOrder, 3) + "% :: MagicNumber " + IntegerToString(MagicNumberPair2) + " " + IntegerToString(MagicNumberPair3) + " :: AutoOrder " + CommentAutoOrder;
   string Comments1, Comments2, Comments3;

   double YesterdayClose1 = iClose(Pair1, PERIOD_D1, BasicDay + 1);
   double YesterdayClose2 = iClose(Pair2, PERIOD_D1, BasicDay + 1);
   double YesterdayClose3 = iClose(Pair3, PERIOD_D1, BasicDay + 1);

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
   if (YesterdayClose1 < PriceBid1) {
      Change1 = PriceBid1 - YesterdayClose1;
      PlusMinus1 = "+";
   }
   if (YesterdayClose1 > PriceBid1) {
      Change1 = YesterdayClose1 - PriceBid1;
      PlusMinus1 = "-";
   }
   Change1Prosentase = (Change1 / YesterdayClose1) * 100;
   Comments1 = Pair1 + " " + DoubleToStr(YesterdayClose1, 5) + " --> " + DoubleToStr(PriceBid1, 5) + " = " + PlusMinus1 + DoubleToStr(Change1Prosentase, 3) + "% Lot " + DoubleToStr(Lot1, 2);

   double Change2, Change2Prosentase;
   string PlusMinus2;
   if (YesterdayClose2 < PriceBid2) {
      Change2 = PriceBid2 - YesterdayClose2;
      PlusMinus2 = "+";
   }
   if (YesterdayClose2 > PriceBid2) {
      Change2 = YesterdayClose2 - PriceBid2;
      PlusMinus2 = "-";
   }
   Change2Prosentase = (Change2 / YesterdayClose2) * 100;
   Comments2 = Pair2 + " " + DoubleToStr(YesterdayClose2, 5) + " --> " + DoubleToStr(PriceBid2, 5) + " = " + PlusMinus2 + DoubleToStr(Change2Prosentase, 3) + "% Lot " + DoubleToStr(Lot2, 2);

   double Change3, Change3Prosentase;
   string PlusMinus3;
   if (YesterdayClose3 < PriceBid3) {
      Change3 = PriceBid3 - YesterdayClose3;
      PlusMinus3 = "+";
   }
   if (YesterdayClose3 > PriceBid3) {
      Change3 = YesterdayClose3 - PriceBid3;
      PlusMinus3 = "-";
   }
   Change3Prosentase = (Change3 / YesterdayClose3) * 100;
   Comments3 = Pair3 + " " + DoubleToStr(YesterdayClose3, 5) + " --> " + DoubleToStr(PriceBid3, 5) + " = " + PlusMinus3 + DoubleToStr(Change3Prosentase, 3) + "% Lot " + DoubleToStr(Lot3, 2);

   ShowComment = ShowComment + "\n" + Comments1 + "\n" + Comments2 + "\n" + Comments3;
   Comment(ShowComment);

   //AutoOrder start from here
   if (AutoOrder == TRUE) {
      int TypeOrder, SendOrder;
      if (Change1Prosentase > LevelOrder) {

         //Order Pair2
         if (PosSelectPair2() == 0) {

            if (PlusMinus1 == "+") {

               TypeOrder = OP_SELL;
               SendOrder = OrderSend(Pair2, TypeOrder, NormalizeDouble(Lot2, 2), PriceBid2, SlipPage, 0, 0, IntegerToString(MagicNumberPair2), MagicNumberPair2, 0, clrNONE);

            } else if (PlusMinus1 == "-") {

               TypeOrder = OP_BUY;
               SendOrder = OrderSend(Pair2, TypeOrder, NormalizeDouble(Lot2, 2), PriceAsk2, SlipPage, 0, 0, IntegerToString(MagicNumberPair2), MagicNumberPair2, 0, clrNONE);

            }

         }

         //Order Pair3
         if (PosSelectPair3() == 0) {

            if (PlusMinus1 == "+") {

               TypeOrder = OP_SELL;
               SendOrder = OrderSend(Pair3, TypeOrder, NormalizeDouble(Lot3, 2), PriceBid3, SlipPage, 0, 0, IntegerToString(MagicNumberPair3), MagicNumberPair3, 0, clrNONE);

            } else if (PlusMinus1 == "-") {

               TypeOrder = OP_BUY;
               SendOrder = OrderSend(Pair3, TypeOrder, NormalizeDouble(Lot3, 2), PriceAsk3, SlipPage, 0, 0, IntegerToString(MagicNumberPair3), MagicNumberPair3, 0, clrNONE);

            }

         }

      }
   }

}

//Check previous order
int PosSelectPair2() {
   int previous_position = 0;
   for (int k = OrdersTotal() - 1; k >= 0; k--) {
      if (!OrderSelect(k, SELECT_BY_POS)) {
         break;
      }

      if ((OrderSymbol() != Pair2) && (OrderMagicNumber() != MagicNumberPair2)) {
         continue;
      }

      if ((OrderCloseTime() == 0) && (OrderSymbol() == Pair2) && (OrderMagicNumber() == MagicNumberPair2)) {
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

int PosSelectPair3() {

   int previous_position = 0;
   for (int k = OrdersTotal() - 1; k >= 0; k--) {
      if (!OrderSelect(k, SELECT_BY_POS)) {
         break;
      }

      if ((OrderSymbol() != Pair3) && (OrderMagicNumber() != MagicNumberPair3)) {
         continue;
      }

      if ((OrderCloseTime() == 0) && (OrderSymbol() == Pair3) && (OrderMagicNumber() == MagicNumberPair3)) {
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
