//+------------------------------------------------------------------+
//|                                           EURGBPUSDCHF_v0.20.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link "https://www.mql5.com"
//#property version "0.20"
#property strict

//Choose Pair
extern string Pair1 = "EURCHF";
extern string Pair2 = "EURAUD";
extern string Pair3 = "AUDCHF";
extern string Pair4 = "EURCAD";
extern string Pair5 = "CADCHF";
extern int BasicDay = 0;
extern double BasicLot = 1;
extern double LevelOrder = 0.20;
extern int SlipPage = 5;
extern double MaxLayer = 1;
extern bool AutoOrder = TRUE;

//+------------------------------------------------------------------+
//| Bismillahirrohmanirrohim                                         |
//+------------------------------------------------------------------+
int deinit() {

   ObjectDelete("StartPrice");
   ObjectDelete("StartPriceLabel");
   ObjectDelete("StartPriceVerticalLine");
   
   for(int d=1; d<=MaxLayer; d++) {
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

   string CommentAutoOrder;
   if (AutoOrder == TRUE) {
      CommentAutoOrder = "Yes";
   } else {
      CommentAutoOrder = "No";
   }
   
   double BasicOpen1 = iOpen(Pair1, PERIOD_D1, BasicDay);
   double BasicOpen2 = iOpen(Pair2, PERIOD_D1, BasicDay);
   double BasicOpen3 = iOpen(Pair3, PERIOD_D1, BasicDay);
   double BasicOpen4 = iOpen(Pair4, PERIOD_D1, BasicDay);
   double BasicOpen5 = iOpen(Pair5, PERIOD_D1, BasicDay);

   string ShowComment = "BasicDay " + IntegerToString(BasicDay) + " :: BasicLot " + DoubleToStr(BasicLot, 2) + " :: LevelOrder " + DoubleToStr(LevelOrder, 3) + "% :: AutoOrder " + CommentAutoOrder;
   string Comments1, Comments2, Comments3, Comments4, Comments5;

   double PriceBid1 = MarketInfo(Pair1, MODE_BID);
   double PriceBid2 = MarketInfo(Pair2, MODE_BID);
   double PriceBid3 = MarketInfo(Pair3, MODE_BID);
   double PriceBid4 = MarketInfo(Pair4, MODE_BID);
   double PriceBid5 = MarketInfo(Pair5, MODE_BID);

   double FuturesPair1 = PriceBid1 / (PriceBid1 * PriceBid1);
   double FuturesPair2 = PriceBid2 / (PriceBid2 * PriceBid2);
   double FuturesPair3 = PriceBid3 / (PriceBid3 * PriceBid3);
   double FuturesPair4 = PriceBid4 / (PriceBid4 * PriceBid4);
   double FuturesPair5 = PriceBid5 / (PriceBid5 * PriceBid5);
   
   double BasicOfBasicLot = BasicLot / FuturesPair1;

   double Lot1 = BasicOfBasicLot * FuturesPair1;
   double Lot2 = BasicOfBasicLot * FuturesPair2;
   double Lot3 = BasicOfBasicLot * FuturesPair3;
   double Lot4 = BasicOfBasicLot * FuturesPair4;
   double Lot5 = BasicOfBasicLot * FuturesPair5;

   double PriceAsk1 = MarketInfo(Pair1, MODE_ASK);
   double PriceAsk2 = MarketInfo(Pair2, MODE_ASK);
   double PriceAsk3 = MarketInfo(Pair3, MODE_ASK);
   double PriceAsk4 = MarketInfo(Pair4, MODE_ASK);
   double PriceAsk5 = MarketInfo(Pair5, MODE_ASK);

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
   
   double Change4, Change4Prosentase;
   string PlusMinus4;
   if (BasicOpen4 < PriceBid4) {
      Change4 = PriceBid4 - BasicOpen4;
      PlusMinus4 = "+";
   }
   if (BasicOpen4 > PriceBid4) {
      Change4 = BasicOpen4 - PriceBid4;
      PlusMinus4 = "-";
   }
   Change4Prosentase = (Change4 / BasicOpen4) * 100;
   Comments4 = Pair4 + " " + DoubleToStr(BasicOpen4, 5) + " --> " + DoubleToStr(PriceBid4, 5) + " = " + PlusMinus4 + DoubleToStr(Change4Prosentase, 3) + "% Lot " + DoubleToStr(Lot4, 2);
   
   double Change5, Change5Prosentase;
   string PlusMinus5;
   if (BasicOpen5 < PriceBid5) {
      Change5 = PriceBid5 - BasicOpen5;
      PlusMinus5 = "+";
   }
   if (BasicOpen5 > PriceBid5) {
      Change5 = BasicOpen5 - PriceBid5;
      PlusMinus5 = "-";
   }
   Change5Prosentase = (Change5 / BasicOpen5) * 100;
   Comments5 = Pair5 + " " + DoubleToStr(BasicOpen5, 5) + " --> " + DoubleToStr(PriceBid5, 5) + " = " + PlusMinus5 + DoubleToStr(Change5Prosentase, 3) + "% Lot " + DoubleToStr(Lot5, 2);

   ShowComment = ShowComment + "\n" + Comments1 + "\n" + Comments2 + "\n" + Comments3 + "\n" + Comments4 + "\n" + Comments5;
   Comment(ShowComment);
   
   //Don't order if Saturday or Sunday
   if(DayOfWeek() != 0 || DayOfWeek() != 6) {

      //AutoOrder start from here
      if(AutoOrder == TRUE) {
      
         double LevelNow, LevelNext;
         string Magic1A, Magic1B, Magic1CDE, Magic1F, Magic2A, Magic2B, Magic2CDE, Magic2F, Magic3A, Magic3B, Magic3CDE, Magic3F, Magic4A, Magic4B, Magic4CDE, Magic4F, Magic5A, Magic5B, Magic5CDE, Magic5F;
         int MagicNumber1, MagicNumber2, MagicNumber3, MagicNumber4, MagicNumber5, TypeOrder, SendOrder;
      
         if (PlusMinus1 == "-") {
      
            for (int i = 1; i <= MaxLayer; i++) {
               LevelNow = i * LevelOrder;
               LevelNext = (i + 1) * LevelOrder;
               if (Change1Prosentase > LevelNow && Change1Prosentase < LevelNext) {
      
                  //Pair1
                  Magic1A = "3"; //PlusMinus
                  Magic1B = "1"; //Pair
                  Magic1CDE = DoubleToString(LevelNow * 100, 0); //Level
                  Magic1F = IntegerToString(DayOfYear()); //DayOfYear
                  MagicNumber1 = StrToInteger(Magic1A + Magic1B + Magic1CDE + Magic1F); //Alert(MagicNumber1);
      
                  if (PosSelect(MagicNumber1, Pair1) == 0) {
                     TypeOrder = OP_BUY;
                     //SendOrder = OrderSend(Pair1, TypeOrder, NormalizeDouble(Lot1, 2), PriceBid1, SlipPage, 0, 0, IntegerToString(MagicNumber1), MagicNumber1, 0, clrNONE);
                  }
                  
                  //Pair2
                  Magic2A = "3"; //PlusMinus
                  Magic2B = "2"; //Pair
                  Magic2CDE = DoubleToString(LevelNow * 100, 0); //Level
                  Magic2F = IntegerToString(DayOfYear()); //DayOfYear
                  MagicNumber2 = StrToInteger(Magic2A + Magic2B + Magic2CDE + Magic2F); //Alert(MagicNumber2);
      
                  if (PosSelect(MagicNumber2, Pair2) == 0) {
                     TypeOrder = OP_BUY;
                     SendOrder = OrderSend(Pair2, TypeOrder, NormalizeDouble(Lot2, 2), PriceBid2, SlipPage, 0, 0, IntegerToString(MagicNumber2), MagicNumber2, 0, clrNONE);
                  }
      
                  //Pair3
                  Magic3A = "3"; //PlusMinus
                  Magic3B = "3"; //Pair
                  Magic3CDE = DoubleToString(LevelNow * 100, 0); //Level
                  Magic3F = IntegerToString(DayOfYear()); //DayOfYear
                  MagicNumber3 = StrToInteger(Magic3A + Magic3B + Magic3CDE + Magic3F); //Alert(MagicNumber3);
      
                  if (PosSelect(MagicNumber3, Pair3) == 0) {
                     TypeOrder = OP_BUY;
                     SendOrder = OrderSend(Pair3, TypeOrder, NormalizeDouble(Lot3, 2), PriceBid3, SlipPage, 0, 0, IntegerToString(MagicNumber3), MagicNumber3, 0, clrNONE);
                  }
                  
                  //Pair4
                  Magic4A = "3"; //PlusMinus
                  Magic4B = "4"; //Pair
                  Magic4CDE = DoubleToString(LevelNow * 100, 0); //Level
                  Magic4F = IntegerToString(DayOfYear()); //DayOfYear
                  MagicNumber4 = StrToInteger(Magic4A + Magic4B + Magic4CDE + Magic4F); //Alert(MagicNumber4);
      
                  if (PosSelect(MagicNumber4, Pair4) == 0) {
                     TypeOrder = OP_BUY;
                     SendOrder = OrderSend(Pair4, TypeOrder, NormalizeDouble(Lot4, 2), PriceBid4, SlipPage, 0, 0, IntegerToString(MagicNumber4), MagicNumber4, 0, clrNONE);
                  }
                  
                  //Pair5
                  Magic5A = "3"; //PlusMinus
                  Magic5B = "5"; //Pair
                  Magic5CDE = DoubleToString(LevelNow * 100, 0); //Level
                  Magic5F = IntegerToString(DayOfYear()); //DayOfYear
                  MagicNumber5 = StrToInteger(Magic5A + Magic5B + Magic5CDE + Magic5F); //Alert(MagicNumber5);
      
                  if (PosSelect(MagicNumber5, Pair5) == 0) {
                     TypeOrder = OP_BUY;
                     SendOrder = OrderSend(Pair5, TypeOrder, NormalizeDouble(Lot5, 2), PriceBid5, SlipPage, 0, 0, IntegerToString(MagicNumber5), MagicNumber5, 0, clrNONE);
                  }
      
               }
            }
      
         } else if (PlusMinus1 == "+") {
      
            for (int i = 1; i <= MaxLayer; i++) {
               LevelNow = i * LevelOrder;
               LevelNext = (i + 1) * LevelOrder;
               if (Change1Prosentase > LevelNow && Change1Prosentase < LevelNext) {
      
                  //Pair1
                  Magic1A = "4"; //PlusMinus
                  Magic1B = "1"; //Pair
                  Magic1CDE = DoubleToString(LevelNow * 100, 0); //Level
                  Magic1F = IntegerToString(DayOfYear()); //DayOfYear
                  MagicNumber1 = StrToInteger(Magic1A + Magic1B + Magic1CDE + Magic1F); //Alert(MagicNumber1);
      
                  if (PosSelect(MagicNumber1, Pair1) == 0) {
                     TypeOrder = OP_SELL;
                     //SendOrder = OrderSend(Pair1, TypeOrder, NormalizeDouble(Lot1, 2), PriceBid1, SlipPage, 0, 0, IntegerToString(MagicNumber1), MagicNumber1, 0, clrNONE);
                  }
                  
                  //Pair2
                  Magic2A = "4"; //PlusMinus
                  Magic2B = "2"; //Pair
                  Magic2CDE = DoubleToString(LevelNow * 100, 0); //Level
                  Magic2F = IntegerToString(DayOfYear()); //DayOfYear
                  MagicNumber2 = StrToInteger(Magic2A + Magic2B + Magic2CDE + Magic2F); //Alert(MagicNumber2);
      
                  if (PosSelect(MagicNumber2, Pair2) == 0) {
                     TypeOrder = OP_SELL;
                     SendOrder = OrderSend(Pair2, TypeOrder, NormalizeDouble(Lot2, 2), PriceBid2, SlipPage, 0, 0, IntegerToString(MagicNumber2), MagicNumber2, 0, clrNONE);
                  }
      
                  //Pair3
                  Magic3A = "4"; //PlusMinus
                  Magic3B = "3"; //Pair
                  Magic3CDE = DoubleToString(LevelNow * 100, 0); //Level
                  Magic3F = IntegerToString(DayOfYear()); //DayOfYear
                  MagicNumber3 = StrToInteger(Magic3A + Magic3B + Magic3CDE + Magic3F); //Alert(MagicNumber3);
      
                  if (PosSelect(MagicNumber3, Pair3) == 0) {
                     TypeOrder = OP_SELL;
                     SendOrder = OrderSend(Pair3, TypeOrder, NormalizeDouble(Lot3, 2), PriceBid3, SlipPage, 0, 0, IntegerToString(MagicNumber3), MagicNumber3, 0, clrNONE);
                  }
                  
                  //Pair4
                  Magic4A = "4"; //PlusMinus
                  Magic4B = "4"; //Pair
                  Magic4CDE = DoubleToString(LevelNow * 100, 0); //Level
                  Magic4F = IntegerToString(DayOfYear()); //DayOfYear
                  MagicNumber4 = StrToInteger(Magic4A + Magic4B + Magic4CDE + Magic4F); //Alert(MagicNumber4);
      
                  if (PosSelect(MagicNumber4, Pair4) == 0) {
                     TypeOrder = OP_SELL;
                     SendOrder = OrderSend(Pair4, TypeOrder, NormalizeDouble(Lot4, 2), PriceBid4, SlipPage, 0, 0, IntegerToString(MagicNumber4), MagicNumber4, 0, clrNONE);
                  }
                  
                  //Pair5
                  Magic5A = "4"; //PlusMinus
                  Magic5B = "5"; //Pair
                  Magic5CDE = DoubleToString(LevelNow * 100, 0); //Level
                  Magic5F = IntegerToString(DayOfYear()); //DayOfYear
                  MagicNumber5 = StrToInteger(Magic5A + Magic5B + Magic5CDE + Magic5F); //Alert(MagicNumber5);
      
                  if (PosSelect(MagicNumber5, Pair5) == 0) {
                     TypeOrder = OP_SELL;
                     SendOrder = OrderSend(Pair5, TypeOrder, NormalizeDouble(Lot5, 2), PriceBid5, SlipPage, 0, 0, IntegerToString(MagicNumber5), MagicNumber5, 0, clrNONE);
                  }
      
               }
            }
      
         }
      
      }
      
   }
   
   //Start to create LINE_OBJECT
   TimeToStr(CurTime());
   
   double StartPrice = iClose(Symbol(), PERIOD_D1, BasicDay + 1);
   datetime StartPriceTime = iTime(Symbol(), PERIOD_D1, BasicDay);
   
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
   
   for (int i=1; i<=MaxLayer; i++) {
   
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
   
   for(int i=OrdersHistoryTotal()-1; i>=0; i--) {
   
      if(OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) && OrderMagicNumber() == TheMagic) {
         previous_position = -9;
      }
      
      if(OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) && OrderComment() == IntegerToString(TheMagic)) {
         previous_position = -9;
      }
   }
   
   if(previous_position == 0) {

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
