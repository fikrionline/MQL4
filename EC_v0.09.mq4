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
extern string Pair01 = "EURCHF";
extern bool   Pair01Order = true;
extern string Pair02 = "EURAUD";
extern bool   Pair02Order = true;
extern string Pair03 = "AUDCHF";
extern bool   Pair03Order = true;
extern string Pair04 = "EURCAD";
extern bool   Pair04Order = true;
extern string Pair05 = "CADCHF";
extern bool   Pair05Order = true;
extern string Pair06 = "EURGBP";
extern bool   Pair06Order = true;
extern string Pair07 = "GBPCHF";
extern bool   Pair07Order = true;
extern string Pair08 = "EURNZD";
extern bool   Pair08Order = true;
extern string Pair09 = "NZDCHF";
extern bool   Pair09Order = true;
extern string Pair10 = "EURUSD";
extern bool   Pair10Order = true;
extern string Pair11 = "USDCHF";
extern bool   Pair11Order = true;
extern string Pair12 = "EURJPY";
extern bool   Pair12Order = true;
extern string Pair13 = "CHFJPY";
extern bool   Pair13Order = true;
extern int BasicDay = 0;
extern double BasicLot = 1;
input  LotRatio BasicLotRatio = Futures;
extern double LevelOrder = 0.09;
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
   
   double BasicOpen01 = iOpen(Pair01, PERIOD_D1, BasicDay);
   double BasicOpen02 = iOpen(Pair02, PERIOD_D1, BasicDay);
   double BasicOpen03 = iOpen(Pair03, PERIOD_D1, BasicDay);
   double BasicOpen04 = iOpen(Pair04, PERIOD_D1, BasicDay);
   double BasicOpen05 = iOpen(Pair05, PERIOD_D1, BasicDay);

   string ShowComment = "DayOfWeek " + IntegerToString(DayOfWeek()) + " :: BasicDay " + IntegerToString(BasicDay) + " :: BasicLot " + DoubleToStr(BasicLot, 2) + " :: LevelOrder " + DoubleToStr(LevelOrder, 3) + "% :: AutoOrder " + CommentAutoOrder;
   string Comments01, Comments02, Comments03, Comments04, Comments05, Comments06, Comments07, Comments08, Comments09, Comments10, Comments11, Comments12, Comments13;

   double PriceBid01 = MarketInfo(Pair01, MODE_BID);
   double PriceBid02 = MarketInfo(Pair02, MODE_BID);
   double PriceBid03 = MarketInfo(Pair03, MODE_BID);
   double PriceBid04 = MarketInfo(Pair04, MODE_BID);
   double PriceBid05 = MarketInfo(Pair05, MODE_BID);
   
   double Lot01, Lot02, Lot03, Lot04, Lot05, Lot06, Lot07, Lot08, Lot09, Lot10, Lot11, Lot12, Lot13, FuturesPair01, FuturesPair02, FuturesPair03, FuturesPair04, FuturesPair05, FuturesPair06, FuturesPair07, FuturesPair08, FuturesPair09, FuturesPair10, FuturesPair11, FuturesPair12, FuturesPair13, BasicOfBasicLot;
   
   if(BasicLotRatio == PriceFromOther) {

      Lot01 = BasicLot * (PriceBid02 * PriceBid03);
      Lot02 = BasicLot * (PriceBid01 / PriceBid03);
      Lot03 = BasicLot * (PriceBid01 / PriceBid02);
      Lot04 = BasicLot * (PriceBid01 / PriceBid05);
      Lot05 = BasicLot * (PriceBid01 / PriceBid04);
      
   } else if(BasicLotRatio == Futures) {
   
      FuturesPair01 = PriceBid01 / (PriceBid01 * PriceBid01);
      FuturesPair02 = PriceBid02 / (PriceBid02 * PriceBid02);
      FuturesPair03 = PriceBid03 / (PriceBid03 * PriceBid03);
      FuturesPair04 = PriceBid04 / (PriceBid04 * PriceBid04);
      FuturesPair05 = PriceBid05 / (PriceBid05 * PriceBid05);
      
      BasicOfBasicLot = BasicLot / FuturesPair01;
   
      Lot01 = BasicOfBasicLot * FuturesPair01;
      Lot02 = BasicOfBasicLot * FuturesPair02;
      Lot03 = BasicOfBasicLot * FuturesPair03;
      Lot04 = BasicOfBasicLot * FuturesPair04;
      Lot05 = BasicOfBasicLot * FuturesPair05;
   
   }

   double PriceAsk1 = MarketInfo(Pair01, MODE_ASK);
   double PriceAsk2 = MarketInfo(Pair02, MODE_ASK);
   double PriceAsk3 = MarketInfo(Pair03, MODE_ASK);
   double PriceAsk4 = MarketInfo(Pair04, MODE_ASK);
   double PriceAsk5 = MarketInfo(Pair05, MODE_ASK);

   double Change01, Change01Prosentase;
   string PlusMinus1;
   if (BasicOpen01 < PriceBid01) {
      Change01 = PriceBid01 - BasicOpen01;
      PlusMinus1 = "+";
   }
   if (BasicOpen01 > PriceBid01) {
      Change01 = BasicOpen01 - PriceBid01;
      PlusMinus1 = "-";
   }
   Change01Prosentase = (Change01 / BasicOpen01) * 100;
   Comments01 = Pair01 + " " + DoubleToStr(BasicOpen01, 5) + " --> " + DoubleToStr(PriceBid01, 5) + " = " + PlusMinus1 + DoubleToStr(Change01Prosentase, 3) + "% Lot " + DoubleToStr(Lot01, 2);

   double Change02, Change02Prosentase;
   string PlusMinus2;
   if (BasicOpen02 < PriceBid02) {
      Change02 = PriceBid02 - BasicOpen02;
      PlusMinus2 = "+";
   }
   if (BasicOpen02 > PriceBid02) {
      Change02 = BasicOpen02 - PriceBid02;
      PlusMinus2 = "-";
   }
   Change02Prosentase = (Change02 / BasicOpen02) * 100;
   Comments02 = Pair02 + " " + DoubleToStr(BasicOpen02, 5) + " --> " + DoubleToStr(PriceBid02, 5) + " = " + PlusMinus2 + DoubleToStr(Change02Prosentase, 3) + "% Lot " + DoubleToStr(Lot02, 2);

   double Change03, Change03Prosentase;
   string PlusMinus3;
   if (BasicOpen03 < PriceBid03) {
      Change03 = PriceBid03 - BasicOpen03;
      PlusMinus3 = "+";
   }
   if (BasicOpen03 > PriceBid03) {
      Change03 = BasicOpen03 - PriceBid03;
      PlusMinus3 = "-";
   }
   Change03Prosentase = (Change03 / BasicOpen03) * 100;
   Comments03 = Pair03 + " " + DoubleToStr(BasicOpen03, 5) + " --> " + DoubleToStr(PriceBid03, 5) + " = " + PlusMinus3 + DoubleToStr(Change03Prosentase, 3) + "% Lot " + DoubleToStr(Lot03, 2);
   
   double Change04, Change04Prosentase;
   string PlusMinus4;
   if (BasicOpen04 < PriceBid04) {
      Change04 = PriceBid04 - BasicOpen04;
      PlusMinus4 = "+";
   }
   if (BasicOpen04 > PriceBid04) {
      Change04 = BasicOpen04 - PriceBid04;
      PlusMinus4 = "-";
   }
   Change04Prosentase = (Change04 / BasicOpen04) * 100;
   Comments04 = Pair04 + " " + DoubleToStr(BasicOpen04, 5) + " --> " + DoubleToStr(PriceBid04, 5) + " = " + PlusMinus4 + DoubleToStr(Change04Prosentase, 3) + "% Lot " + DoubleToStr(Lot04, 2);
   
   double Change05, Change05Prosentase;
   string PlusMinus5;
   if (BasicOpen05 < PriceBid05) {
      Change05 = PriceBid05 - BasicOpen05;
      PlusMinus5 = "+";
   }
   if (BasicOpen05 > PriceBid05) {
      Change05 = BasicOpen05 - PriceBid05;
      PlusMinus5 = "-";
   }
   Change05Prosentase = (Change05 / BasicOpen05) * 100;
   Comments05 = Pair05 + " " + DoubleToStr(BasicOpen05, 5) + " --> " + DoubleToStr(PriceBid05, 5) + " = " + PlusMinus5 + DoubleToStr(Change05Prosentase, 3) + "% Lot " + DoubleToStr(Lot05, 2);

   ShowComment = ShowComment + "\n" + Comments01 + "\n" + Comments02 + "\n" + Comments03 + "\n" + Comments04 + "\n" + Comments05;
   Comment(ShowComment);
   
   //Don't order if Saturday or Sunday
   if(DayOfWeek() != 0 && DayOfWeek() != 6) {

      //AutoOrder start from here
      if(AutoOrder == TRUE) {
      
         double LevelNow, LevelNext;
         string Magic1A, Magic1B, Magic1CDE, Magic1F, Magic2A, Magic2B, Magic2CDE, Magic2F, Magic3A, Magic3B, Magic3CDE, Magic3F, Magic4A, Magic4B, Magic4CDE, Magic4F, Magic5A, Magic5B, Magic5CDE, Magic5F;
         int MagicNumber1, MagicNumber2, MagicNumber3, MagicNumber4, MagicNumber5, TypeOrder, SendOrder;
      
         if (PlusMinus1 == "+") {
      
            for (int i = 1; i <= MaxLayer; i++) {
               LevelNow = i * LevelOrder;
               LevelNext = (i + 1) * LevelOrder;
               if (Change01Prosentase > LevelNow && Change01Prosentase < LevelNext) {
      
                  //Pair01
                  Magic1A = "1"; //PlusMinus
                  Magic1B = "1"; //Pair0
                  Magic1CDE = DoubleToString(LevelNow * 100, 0); //Level
                  Magic1F = IntegerToString(DayOfYear()); //DayOfYear
                  MagicNumber1 = StrToInteger(Magic1A + Magic1B + Magic1CDE + Magic1F); //Alert(MagicNumber1);
      
                  if (PosSelect(MagicNumber1, Pair01) == 0) {
                     TypeOrder = OP_BUY;
                     SendOrder = OrderSend(Pair01, TypeOrder, NormalizeDouble(Lot01, 2), PriceBid01, SlipPage, 0, 0, IntegerToString(MagicNumber1), MagicNumber1, 0, clrNONE);
                  }
                  
                  //Pair02
                  Magic2A = "1"; //PlusMinus
                  Magic2B = "2"; //Pair0
                  Magic2CDE = DoubleToString(LevelNow * 100, 0); //Level
                  Magic2F = IntegerToString(DayOfYear()); //DayOfYear
                  MagicNumber2 = StrToInteger(Magic2A + Magic2B + Magic2CDE + Magic2F); //Alert(MagicNumber2);
      
                  if (PosSelect(MagicNumber2, Pair02) == 0) {
                     TypeOrder = OP_BUY;
                     SendOrder = OrderSend(Pair02, TypeOrder, NormalizeDouble(Lot02, 2), PriceBid02, SlipPage, 0, 0, IntegerToString(MagicNumber2), MagicNumber2, 0, clrNONE);
                  }
      
                  //Pair03
                  Magic3A = "1"; //PlusMinus
                  Magic3B = "3"; //Pair0
                  Magic3CDE = DoubleToString(LevelNow * 100, 0); //Level
                  Magic3F = IntegerToString(DayOfYear()); //DayOfYear
                  MagicNumber3 = StrToInteger(Magic3A + Magic3B + Magic3CDE + Magic3F); //Alert(MagicNumber3);
      
                  if (PosSelect(MagicNumber3, Pair03) == 0) {
                     TypeOrder = OP_BUY;
                     SendOrder = OrderSend(Pair03, TypeOrder, NormalizeDouble(Lot03, 2), PriceBid03, SlipPage, 0, 0, IntegerToString(MagicNumber3), MagicNumber3, 0, clrNONE);
                  }
                  
                  //Pair04
                  Magic4A = "1"; //PlusMinus
                  Magic4B = "4"; //Pair0
                  Magic4CDE = DoubleToString(LevelNow * 100, 0); //Level
                  Magic4F = IntegerToString(DayOfYear()); //DayOfYear
                  MagicNumber4 = StrToInteger(Magic4A + Magic4B + Magic4CDE + Magic4F); //Alert(MagicNumber4);
      
                  if (PosSelect(MagicNumber4, Pair04) == 0) {
                     TypeOrder = OP_BUY;
                     SendOrder = OrderSend(Pair04, TypeOrder, NormalizeDouble(Lot04, 2), PriceBid04, SlipPage, 0, 0, IntegerToString(MagicNumber4), MagicNumber4, 0, clrNONE);
                  }
                  
                  //Pair05
                  Magic5A = "1"; //PlusMinus
                  Magic5B = "5"; //Pair0
                  Magic5CDE = DoubleToString(LevelNow * 100, 0); //Level
                  Magic5F = IntegerToString(DayOfYear()); //DayOfYear
                  MagicNumber5 = StrToInteger(Magic5A + Magic5B + Magic5CDE + Magic5F); //Alert(MagicNumber5);
      
                  if (PosSelect(MagicNumber5, Pair05) == 0) {
                     TypeOrder = OP_BUY;
                     SendOrder = OrderSend(Pair05, TypeOrder, NormalizeDouble(Lot05, 2), PriceBid05, SlipPage, 0, 0, IntegerToString(MagicNumber5), MagicNumber5, 0, clrNONE);
                  }
      
               }
            }
      
         } else if (PlusMinus1 == "-") {
      
            for (int i = 1; i <= MaxLayer; i++) {
               LevelNow = i * LevelOrder;
               LevelNext = (i + 1) * LevelOrder;
               if (Change01Prosentase > LevelNow && Change01Prosentase < LevelNext) {
      
                  //Pair01
                  Magic1A = "2"; //PlusMinus
                  Magic1B = "1"; //Pair0
                  Magic1CDE = DoubleToString(LevelNow * 100, 0); //Level
                  Magic1F = IntegerToString(DayOfYear()); //DayOfYear
                  MagicNumber1 = StrToInteger(Magic1A + Magic1B + Magic1CDE + Magic1F); //Alert(MagicNumber1);
      
                  if (PosSelect(MagicNumber1, Pair01) == 0) {
                     TypeOrder = OP_SELL;
                     SendOrder = OrderSend(Pair01, TypeOrder, NormalizeDouble(Lot01, 2), PriceBid01, SlipPage, 0, 0, IntegerToString(MagicNumber1), MagicNumber1, 0, clrNONE);
                  }
                  
                  //Pair02
                  Magic2A = "2"; //PlusMinus
                  Magic2B = "2"; //Pair0
                  Magic2CDE = DoubleToString(LevelNow * 100, 0); //Level
                  Magic2F = IntegerToString(DayOfYear()); //DayOfYear
                  MagicNumber2 = StrToInteger(Magic2A + Magic2B + Magic2CDE + Magic2F); //Alert(MagicNumber2);
      
                  if (PosSelect(MagicNumber2, Pair02) == 0) {
                     TypeOrder = OP_SELL;
                     SendOrder = OrderSend(Pair02, TypeOrder, NormalizeDouble(Lot02, 2), PriceBid02, SlipPage, 0, 0, IntegerToString(MagicNumber2), MagicNumber2, 0, clrNONE);
                  }
      
                  //Pair03
                  Magic3A = "2"; //PlusMinus
                  Magic3B = "3"; //Pair0
                  Magic3CDE = DoubleToString(LevelNow * 100, 0); //Level
                  Magic3F = IntegerToString(DayOfYear()); //DayOfYear
                  MagicNumber3 = StrToInteger(Magic3A + Magic3B + Magic3CDE + Magic3F); //Alert(MagicNumber3);
      
                  if (PosSelect(MagicNumber3, Pair03) == 0) {
                     TypeOrder = OP_SELL;
                     SendOrder = OrderSend(Pair03, TypeOrder, NormalizeDouble(Lot03, 2), PriceBid03, SlipPage, 0, 0, IntegerToString(MagicNumber3), MagicNumber3, 0, clrNONE);
                  }
                  
                  //Pair04
                  Magic4A = "2"; //PlusMinus
                  Magic4B = "4"; //Pair0
                  Magic4CDE = DoubleToString(LevelNow * 100, 0); //Level
                  Magic4F = IntegerToString(DayOfYear()); //DayOfYear
                  MagicNumber4 = StrToInteger(Magic4A + Magic4B + Magic4CDE + Magic4F); //Alert(MagicNumber4);
      
                  if (PosSelect(MagicNumber4, Pair04) == 0) {
                     TypeOrder = OP_SELL;
                     SendOrder = OrderSend(Pair04, TypeOrder, NormalizeDouble(Lot04, 2), PriceBid04, SlipPage, 0, 0, IntegerToString(MagicNumber4), MagicNumber4, 0, clrNONE);
                  }
                  
                  //Pair05
                  Magic5A = "2"; //PlusMinus
                  Magic5B = "5"; //Pair0
                  Magic5CDE = DoubleToString(LevelNow * 100, 0); //Level
                  Magic5F = IntegerToString(DayOfYear()); //DayOfYear
                  MagicNumber5 = StrToInteger(Magic5A + Magic5B + Magic5CDE + Magic5F); //Alert(MagicNumber5);
      
                  if (PosSelect(MagicNumber5, Pair05) == 0) {
                     TypeOrder = OP_SELL;
                     SendOrder = OrderSend(Pair05, TypeOrder, NormalizeDouble(Lot05, 2), PriceBid05, SlipPage, 0, 0, IntegerToString(MagicNumber5), MagicNumber5, 0, clrNONE);
                  }
      
               }
            }
      
         }
      
      }
      
   }
   
   //Start to create LINE_OBJECT
   TimeToStr(CurTime());
   
   double StartPrice = iOpen(Symbol(), PERIOD_D1, BasicDay);
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
