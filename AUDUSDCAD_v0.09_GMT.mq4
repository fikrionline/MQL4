//+------------------------------------------------------------------+
//|                                           EURAUDCADCHF_v0.09.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link "https://www.mql5.com"
//#property version "0.09"
#property strict

//LotRatio
enum LotRatio {
   PriceFromOther,
   Futures
};

//Choose Pair
extern string Pair1 = "AUDCAD";
extern bool   Pair1Order = false;
extern string Pair2 = "AUDUSD";
extern bool   Pair2Order = true;
extern string Pair3 = "USDCAD";
extern bool   Pair3Order = true;
extern int GMTPlusXHours = 0;
extern double BasicLot = 0.5;
input LotRatio BasicLotRatio = Futures;
extern double LevelOrder = 0.09;
extern int SlipPage = 5;
extern double MaxLayer = 1;
extern bool AutoOrder = false;

//+------------------------------------------------------------------+
//| Bismillahirrohmanirrohim                                         |
//+------------------------------------------------------------------+
int deinit() {

   ObjectDelete("StartPrice");
   ObjectDelete("StartPriceLabel");
   ObjectDelete("StartPriceVerticalLine");

   for (int d = 1; d <= MaxLayer; d++) {
      ObjectDelete("+" + IntegerToString(d));
      ObjectDelete("-" + IntegerToString(d));
      ObjectDelete("+" + IntegerToString(d) + "Label");
      ObjectDelete("-" + IntegerToString(d) + "Label");
   }

   return (0);

}

//+------------------------------------------------------------------+
//| Bismillahirrohmanirrohim                                         |
//+------------------------------------------------------------------+
void OnTick() {

   string ShowComment;
   datetime HourGMT = TimeHour(TimeGMT());
   int StartHour = (int) (HourGMT + GMTPlusXHours);
   
   string CommentAutoOrder;
   if (AutoOrder == true) {
      CommentAutoOrder = "Yes";
   } else {
      CommentAutoOrder = "No";
   }

   ShowComment = ShowComment + "TimeLocal = " + IntegerToString(TimeHour(TimeLocal())) + " :: " + "TimeServer = " + IntegerToString(TimeHour(TimeCurrent())) + " :: " + "GMT = " + IntegerToString(TimeHour(TimeGMT()));
   ShowComment = ShowComment + "\n" + "DayOfYear " + IntegerToString(DayOfYear()) + " :: BasicLot " + DoubleToString(BasicLot, 2) + " :: LevelOrder " + DoubleToString(LevelOrder, 3) + "% :: AutoOrder " + CommentAutoOrder;
   
   string Comments1, Comments2, Comments3;
   
   double BasicOpen1 = iOpen(Pair1, PERIOD_H1, StartHour);
   double BasicOpen2 = iOpen(Pair2, PERIOD_H1, StartHour);
   double BasicOpen3 = iOpen(Pair3, PERIOD_H1, StartHour);

   double PriceBid1 = MarketInfo(Pair1, MODE_BID);
   double PriceBid2 = MarketInfo(Pair2, MODE_BID);
   double PriceBid3 = MarketInfo(Pair3, MODE_BID);

   double Lot1, Lot2, Lot3, FuturesPair1, FuturesPair2, FuturesPair3, BasicOfBasicLot;

   if (BasicLotRatio == PriceFromOther) {

      Lot1 = BasicLot * (PriceBid2 * PriceBid3);
      Lot2 = BasicLot * (PriceBid1 / PriceBid3);
      Lot3 = BasicLot * (PriceBid1 / PriceBid2);

   } else if (BasicLotRatio == Futures) {

      FuturesPair1 = PriceBid1 / (PriceBid1 * PriceBid1);
      FuturesPair2 = PriceBid2 / (PriceBid2 * PriceBid2);
      FuturesPair3 = PriceBid3 / (PriceBid3 * PriceBid3);

      BasicOfBasicLot = BasicLot / FuturesPair1; //Alert(BasicOfBasicLot);

      Lot1 = BasicOfBasicLot * FuturesPair1;
      Lot2 = BasicOfBasicLot * FuturesPair2;
      Lot3 = BasicOfBasicLot * FuturesPair3;

   }

   double PriceAsk1 = MarketInfo(Pair1, MODE_ASK);
   double PriceAsk2 = MarketInfo(Pair2, MODE_ASK);
   double PriceAsk3 = MarketInfo(Pair3, MODE_ASK);

   double Change1, Change1Prosentase;
   string PlusMinus1, CommentPair1Order;
   if (BasicOpen1 < PriceBid1) {
      Change1 = PriceBid1 - BasicOpen1;
      PlusMinus1 = "+";
   }
   if (BasicOpen1 > PriceBid1) {
      Change1 = BasicOpen1 - PriceBid1;
      PlusMinus1 = "-";
   }
   Change1Prosentase = (Change1 / BasicOpen1) * 100;
   if (Pair1Order == true) {
      CommentPair1Order = "Yes";
   } else {
      CommentPair1Order = "No";
   }
   Comments1 = Pair1 + " " + DoubleToString(BasicOpen1, (int) MarketInfo(Pair1, MODE_DIGITS)) + " --> " + DoubleToString(PriceBid1, (int) MarketInfo(Pair1, MODE_DIGITS)) + " = " + PlusMinus1 + DoubleToString(Change1Prosentase, 3) + "% Lot " + DoubleToString(Lot1, 2) + " :: Order " + CommentPair1Order;

   double Change2, Change2Prosentase;
   string PlusMinus2, CommentPair2Order;
   if (BasicOpen2 < PriceBid2) {
      Change2 = PriceBid2 - BasicOpen2;
      PlusMinus2 = "+";
   }
   if (BasicOpen2 > PriceBid2) {
      Change2 = BasicOpen2 - PriceBid2;
      PlusMinus2 = "-";
   }
   Change2Prosentase = (Change2 / BasicOpen2) * 100;
   if (Pair2Order == true) {
      CommentPair2Order = "Yes";
   } else {
      CommentPair2Order = "No";
   }
   Comments2 = Pair2 + " " + DoubleToString(BasicOpen2, (int) MarketInfo(Pair2, MODE_DIGITS)) + " --> " + DoubleToString(PriceBid2, (int) MarketInfo(Pair2, MODE_DIGITS)) + " = " + PlusMinus2 + DoubleToString(Change2Prosentase, 3) + "% Lot " + DoubleToString(Lot2, 2) + " :: Order " + CommentPair2Order;

   double Change3, Change3Prosentase;
   string PlusMinus3, CommentPair3Order;
   if (BasicOpen3 < PriceBid3) {
      Change3 = PriceBid3 - BasicOpen3;
      PlusMinus3 = "+";
   }
   if (BasicOpen3 > PriceBid3) {
      Change3 = BasicOpen3 - PriceBid3;
      PlusMinus3 = "-";
   }
   Change3Prosentase = (Change3 / BasicOpen3) * 100;
   if (Pair3Order == true) {
      CommentPair3Order = "Yes";
   } else {
      CommentPair3Order = "No";
   }
   Comments3 = Pair3 + " " + DoubleToString(BasicOpen3, (int) MarketInfo(Pair3, MODE_DIGITS)) + " --> " + DoubleToString(PriceBid3, (int) MarketInfo(Pair3, MODE_DIGITS)) + " = " + PlusMinus3 + DoubleToString(Change3Prosentase, 3) + "% Lot " + DoubleToString(Lot3, 2) + " :: Order " + CommentPair3Order;

   ShowComment = ShowComment + "\n" + Comments1 + "\n" + Comments2 + "\n" + Comments3;

   Comment(ShowComment);

   //Don't order if Saturday or Sunday
   if (DayOfWeek() != 0 && DayOfWeek() != 6) {

      //AutoOrder start from here
      if (AutoOrder == true) {

         double LevelNow, LevelNext;
         string Magic1A, Magic1B, Magic1CDE, Magic1F, Magic2A, Magic2B, Magic2CDE, Magic2F, Magic3A, Magic3B, Magic3CDE, Magic3F;
         int MagicNumber1, MagicNumber2, MagicNumber3, TypeOrder, SendOrder;

         if (PlusMinus1 == "+") {

            for (int i = 1; i <= MaxLayer; i++) {
               LevelNow = i * LevelOrder;
               LevelNext = (i + 1) * LevelOrder;
               if (Change1Prosentase > LevelNow && Change1Prosentase < LevelNext) {

                  if (Pair1Order == true) {

                     //Pair1
                     Magic1A = "1"; //PlusMinus
                     Magic1B = "1"; //Pair
                     Magic1CDE = DoubleToString(LevelNow * 1000, 0); //Level
                     Magic1F = IntegerToString(DayOfYear()); //DayOfYear
                     MagicNumber1 = StrToInteger(Magic1A + Magic1B + Magic1CDE + Magic1F); //Alert(MagicNumber1);

                     if (PosSelect(MagicNumber1, Pair1) == 0) {
                        TypeOrder = OP_BUY;
                        SendOrder = OrderSend(Pair1, TypeOrder, NormalizeDouble(Lot1, 2), PriceBid1, SlipPage, 0, 0, IntegerToString(MagicNumber1), MagicNumber1, 0, clrNONE);
                     }

                  }

                  if (Pair2Order == true) {

                     //Pair2
                     Magic2A = "1"; //PlusMinus
                     Magic2B = "2"; //Pair
                     Magic2CDE = DoubleToString(LevelNow * 1000, 0); //Level
                     Magic2F = IntegerToString(DayOfYear()); //DayOfYear
                     MagicNumber2 = StrToInteger(Magic2A + Magic2B + Magic2CDE + Magic2F); //Alert(MagicNumber2);

                     if (PosSelect(MagicNumber2, Pair2) == 0) {
                        TypeOrder = OP_BUY;
                        SendOrder = OrderSend(Pair2, TypeOrder, NormalizeDouble(Lot2, 2), PriceBid2, SlipPage, 0, 0, IntegerToString(MagicNumber2), MagicNumber2, 0, clrNONE);
                     }

                  }

                  if (Pair3Order == true) {

                     //Pair3
                     Magic3A = "1"; //PlusMinus
                     Magic3B = "3"; //Pair
                     Magic3CDE = DoubleToString(LevelNow * 1000, 0); //Level
                     Magic3F = IntegerToString(DayOfYear()); //DayOfYear
                     MagicNumber3 = StrToInteger(Magic3A + Magic3B + Magic3CDE + Magic3F); //Alert(MagicNumber3);

                     if (PosSelect(MagicNumber3, Pair3) == 0) {
                        TypeOrder = OP_BUY;
                        SendOrder = OrderSend(Pair3, TypeOrder, NormalizeDouble(Lot3, 2), PriceBid3, SlipPage, 0, 0, IntegerToString(MagicNumber3), MagicNumber3, 0, clrNONE);
                     }

                  }

               }
            }

         } else if (PlusMinus1 == "-") {

            for (int i = 1; i <= MaxLayer; i++) {
               LevelNow = i * LevelOrder;
               LevelNext = (i + 1) * LevelOrder;
               if (Change1Prosentase > LevelNow && Change1Prosentase < LevelNext) {

                  if (Pair1Order == true) {

                     //Pair1
                     Magic1A = "2"; //PlusMinus
                     Magic1B = "1"; //Pair
                     Magic1CDE = DoubleToString(LevelNow * 1000, 0); //Level
                     Magic1F = IntegerToString(DayOfYear()); //DayOfYear
                     MagicNumber1 = StrToInteger(Magic1A + Magic1B + Magic1CDE + Magic1F); //Alert(MagicNumber1);

                     if (PosSelect(MagicNumber1, Pair1) == 0) {
                        TypeOrder = OP_SELL;
                        SendOrder = OrderSend(Pair1, TypeOrder, NormalizeDouble(Lot1, 2), PriceBid1, SlipPage, 0, 0, IntegerToString(MagicNumber1), MagicNumber1, 0, clrNONE);
                     }

                  }

                  if (Pair2Order == true) {

                     //Pair2
                     Magic2A = "2"; //PlusMinus
                     Magic2B = "2"; //Pair
                     Magic2CDE = DoubleToString(LevelNow * 1000, 0); //Level
                     Magic2F = IntegerToString(DayOfYear()); //DayOfYear
                     MagicNumber2 = StrToInteger(Magic2A + Magic2B + Magic2CDE + Magic2F); //Alert(MagicNumber2);

                     if (PosSelect(MagicNumber2, Pair2) == 0) {
                        TypeOrder = OP_SELL;
                        SendOrder = OrderSend(Pair2, TypeOrder, NormalizeDouble(Lot2, 2), PriceBid2, SlipPage, 0, 0, IntegerToString(MagicNumber2), MagicNumber2, 0, clrNONE);
                     }

                  }

                  if (Pair3Order == true) {

                     //Pair3
                     Magic3A = "2"; //PlusMinus
                     Magic3B = "3"; //Pair
                     Magic3CDE = DoubleToString(LevelNow * 1000, 0); //Level
                     Magic3F = IntegerToString(DayOfYear()); //DayOfYear
                     MagicNumber3 = StrToInteger(Magic3A + Magic3B + Magic3CDE + Magic3F); //Alert(MagicNumber3);

                     if (PosSelect(MagicNumber3, Pair3) == 0) {
                        TypeOrder = OP_SELL;
                        SendOrder = OrderSend(Pair3, TypeOrder, NormalizeDouble(Lot3, 2), PriceBid3, SlipPage, 0, 0, IntegerToString(MagicNumber3), MagicNumber3, 0, clrNONE);
                     }

                  }

               }
            }

         }

      }

   }

   //Start to create LINE_OBJECT
   TimeToStr(CurTime());

   double StartPrice = iOpen(Symbol(), PERIOD_H1, StartHour);
   datetime StartPriceTime = iTime(Symbol(), PERIOD_H1, StartHour);

   double LastLevelPlus = StartPrice;
   double LastLevelMinus = StartPrice;

   double LastLevelStepPlus = 0;
   double LastLevelStepMinus = 0;

   double Step = NormalizeDouble((LevelOrder / 100) * StartPrice, 5);

   ObjectCreate("StartPrice", OBJ_HLINE, 0, CurTime(), StartPrice);
   ObjectSet("StartPrice", OBJPROP_COLOR, Blue);
   ObjectSet("StartPrice", OBJPROP_STYLE, STYLE_DASHDOT);

   ObjectCreate("StartPriceLabel", OBJ_TEXT, 0, CurTime(), StartPrice);
   ObjectSetText("StartPriceLabel", "Start", 8, "Arial", Blue);

   ObjectCreate("StartPriceVerticalLine", OBJ_VLINE, 0, StartPriceTime, 0);
   ObjectSet("StartPriceVerticalLine", OBJPROP_COLOR, Blue);
   ObjectSet("StartPriceVerticalLine", OBJPROP_STYLE, STYLE_DASHDOT);

   for (int i = 1; i <= MaxLayer; i++) {

      LastLevelPlus = LastLevelPlus + Step;
      LastLevelStepPlus = LastLevelStepPlus + LevelOrder;

      ObjectCreate("+" + IntegerToString(i), OBJ_HLINE, 0, CurTime(), NormalizeDouble(LastLevelPlus, 5));
      ObjectSet("+" + IntegerToString(i), OBJPROP_COLOR, Green);
      ObjectSet("+" + IntegerToString(i), OBJPROP_STYLE, STYLE_DASHDOT);

      ObjectCreate("+" + IntegerToString(i) + "Label", OBJ_TEXT, 0, CurTime(), NormalizeDouble(LastLevelPlus, 5));
      ObjectSetText("+" + IntegerToString(i) + "Label", DoubleToString(LastLevelStepPlus, 3) + "%", 8, "Arial", Green);

      LastLevelMinus = LastLevelMinus - Step;
      LastLevelStepMinus = LastLevelStepMinus - LevelOrder;

      ObjectCreate("-" + IntegerToString(i), OBJ_HLINE, 0, CurTime(), LastLevelMinus);
      ObjectSet("-" + IntegerToString(i), OBJPROP_COLOR, Orange);
      ObjectSet("-" + IntegerToString(i), OBJPROP_STYLE, STYLE_DASHDOT);

      ObjectCreate("-" + IntegerToString(i) + "Label", OBJ_TEXT, 0, CurTime(), NormalizeDouble(LastLevelMinus, 5));
      ObjectSetText("-" + IntegerToString(i) + "Label", DoubleToString(LastLevelStepMinus, 3) + "%", 8, "Arial", Orange);

   }
   //End of LINE_OBJECT

}

//Check previous order
int PosSelect(int TheMagic, string ThePair) {

   int previous_position = 0;

   for (int i = OrdersHistoryTotal() - 1; i >= 0; i--) {

      if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) && OrderMagicNumber() == TheMagic) {
         previous_position = -9;
      }

      if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) && OrderComment() == IntegerToString(TheMagic)) {
         previous_position = -9;
      }
   }

   if (previous_position == 0) {

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

   }

   return (previous_position);

}
