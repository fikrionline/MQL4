#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link "https://www.mql5.com"
#property version "1.3"
#property strict

//Choose Pair
extern string Pair1 = "EURCHF";
extern string Pair2 = "EURUSD";
extern string Pair3 = "USDCHF";
extern int BasicWeek = 0;
extern double BasicLot = 0.5;
extern double LevelOrder = 0.25;
extern int SlipPage = 5;
extern int MaxLayer = 9;
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
   
   double BasicClose1 = iClose(Pair1, PERIOD_W1, BasicWeek + 1);
   double BasicClose2 = iClose(Pair2, PERIOD_W1, BasicWeek + 1);
   double BasicClose3 = iClose(Pair3, PERIOD_W1, BasicWeek + 1);

   string ShowComment = "BasicWeek " + IntegerToString(BasicWeek) + " :: BasicLot " + DoubleToStr(BasicLot, 2) + " :: LevelOrder " + DoubleToStr(LevelOrder, 3) + "% :: AutoOrder " + CommentAutoOrder;
   string Comments1, Comments2, Comments3;

   double PriceBid1 = MarketInfo(Pair1, MODE_BID);
   double PriceBid2 = MarketInfo(Pair2, MODE_BID);
   double PriceBid3 = MarketInfo(Pair3, MODE_BID);

   double Lot1 = BasicLot * (PriceBid2 * PriceBid3);
   double Lot2 = BasicLot * (PriceBid1 / PriceBid3);
   double Lot3 = BasicLot * (PriceBid1 / PriceBid2);

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
   
      double LevelNow, LevelNext, LevelPrev;
      string Magic2A, Magic2B, Magic2CDE, Magic2F, Magic3A, Magic3B, Magic3CDE, Magic3F;
      int MagicNumber2, MagicNumber3;
   
      if (PlusMinus1 == "+") {
      
         //Close all on negative prosentase
         CloseOrderPlusMinus(PlusMinus1);
   
         for (int i = MaxLayer; i >= 0; i--) {
            LevelNow = i * LevelOrder;
            LevelNext = (i + 1) * LevelOrder;
            LevelPrev = (i - 1) * LevelOrder;
            if (Change1Prosentase > LevelPrev && Change1Prosentase < LevelNow) {
   
               //Pair2
               Magic2A = "1"; //PlusMinus
               Magic2B = "2"; //Pair
               Magic2CDE = DoubleToString(LevelNow * 100, 0); //Level
               Magic2F = IntegerToString(DayOfYear()); //DayOfYear
               MagicNumber2 = StrToInteger(Magic2A + Magic2B + Magic2CDE + Magic2F); //Alert(MagicNumber2);
   
               CloseOrder(MagicNumber2);
   
               //Pair3
               Magic3A = "1"; //PlusMinus
               Magic3B = "3"; //Pair
               Magic3CDE = DoubleToString(LevelNow * 100, 0); //Level
               Magic3F = IntegerToString(DayOfYear()); //DayOfYear
               MagicNumber3 = StrToInteger(Magic3A + Magic3B + Magic3CDE + Magic3F); //Alert(MagicNumber3);
   
               CloseOrder(MagicNumber3);
   
            }
         }
   
      } else if (PlusMinus1 == "-") {
      
         //Close all on positive prosentase
         CloseOrderPlusMinus(PlusMinus1);
   
         for (int i = MaxLayer; i >= 0; i++) {
            LevelNow = i * LevelOrder;
            LevelNext = (i + 1) * LevelOrder;
            LevelPrev = (i - 1) * LevelOrder;
            if (Change1Prosentase > LevelPrev && Change1Prosentase < LevelNow) {
   
               //Pair2
               Magic2A = "2"; //PlusMinus
               Magic2B = "2"; //Pair
               Magic2CDE = DoubleToString(LevelNow * 100, 0); //Level
               Magic2F = IntegerToString(DayOfYear()); //DayOfYear
               MagicNumber2 = StrToInteger(Magic2A + Magic2B + Magic2CDE + Magic2F); //Alert(MagicNumber2);
   
               CloseOrder(MagicNumber2);
   
               //Pair3
               Magic3A = "2"; //PlusMinus
               Magic3B = "3"; //Pair
               Magic3CDE = DoubleToString(LevelNow * 100, 0); //Level
               Magic3F = IntegerToString(DayOfYear()); //DayOfYear
               MagicNumber3 = StrToInteger(Magic3A + Magic3B + Magic3CDE + Magic3F); //Alert(MagicNumber3);
   
               CloseOrder(MagicNumber3);
   
            }
         }
   
      }
   
   }

}

//Close order by magic number
int CloseOrder(int MagicNumber) {
   int total = OrdersTotal();
   int SelectOrder, CloseOrder;

   for (int cnt = total - 1; cnt >= 0; cnt--) {
      SelectOrder = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderMagicNumber() == MagicNumber) {
         if (OrderType() == OP_BUY) {
            CloseOrder = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 3);
         }

         if (OrderType() == OP_SELL) {
            CloseOrder = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 3);
         }
      }
   }

   return (0);

}

//Close order plus minus
int CloseOrderPlusMinus(string PlusMinus) {

   string MagicNumberCheck;
   if(PlusMinus == "+") {
      MagicNumberCheck = "2";
   } else if(PlusMinus == "-") {
      MagicNumberCheck = "1";
   }
   
   int total = OrdersTotal();
   int SelectOrder, CloseOrder;
   string MagicNumberToString;

   for (int cnt = total - 1; cnt >= 0; cnt--) {
      SelectOrder = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      MagicNumberToString = IntegerToString(OrderMagicNumber());
      if(StringSubstr(MagicNumberToString, 0, 1) == MagicNumberCheck) {
         if (OrderType() == OP_BUY) {
            CloseOrder = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 3);
         }
         if (OrderType() == OP_SELL) {
            CloseOrder = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 3);
         }
      }
   }

   return (0);

}
