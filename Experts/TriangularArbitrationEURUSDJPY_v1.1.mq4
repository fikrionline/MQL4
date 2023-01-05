#property copyright "Copyright © 2021, Khlistov Vladimir"
#property link      "http://cmillion.ru"
#property version   "1.1"
#property strict
#property description "Original link in description = https://cmillion.ru/sovetnik-cm_ea_hedge/"
#property description "First download EA from = https://www.forexfactory.com/thread/975409-triangular-arbitrage-ea"

//+------------------------------------------------------------------+
extern double  BasicLot       = 0.1;
extern string  SYMBOL1        = "EURUSD";
extern string  SYMBOL2        = "USDJPY";
extern string  SYMBOL3        = "EURJPY";
extern int     TYPE1          = OP_BUY;
extern int     TYPE2          = OP_BUY;
extern int     TYPE3          = OP_SELL;
extern int     MagicNumber    = 777888;
extern double  ProfitTarget   = 1.0;

//+------------------------------------------------------------------+
string AC;
int OnInit() {
   EventSetTimer(1);
   AC = AccountCurrency();
   return (INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
void OnTick() {
   OnTimer();
}

//+------------------------------------------------------------------+
void OnTimer() {
   if (IsTesting()) {
      Print("This EA cannot used in backtest!!");
      ExpertRemove();
   }
   
   double PriceBid1 = MarketInfo(SYMBOL1, MODE_BID);
   double PriceBid2 = MarketInfo(SYMBOL2, MODE_BID);
   double PriceBid3 = MarketInfo(SYMBOL3, MODE_BID);
   
   double Lot1 = BasicLot * (PriceBid2 / PriceBid3);
   double Lot2 = (BasicLot * (PriceBid1 * PriceBid3)) / 100;
   double Lot3 = (BasicLot * (PriceBid2 / PriceBid1)) / 100;
   
   string Sym;
   int i;
   double profit = 0;
   double profit1 = 0;
   double profit2 = 0;
   double profit3 = 0;
   bool open1 = false;
   bool open2 = false;
   bool open3 = false;
   for (i = 0; i < OrdersTotal(); i++) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         if (MagicNumber != OrderMagicNumber()) continue;
         Sym = OrderSymbol();
         if (Sym != SYMBOL1 && Sym != SYMBOL2 && Sym != SYMBOL3) continue;
         profit = OrderProfit() + OrderSwap() + OrderCommission();
         if (Sym == SYMBOL1) {
            open1 = true;
            profit1 += profit;
         }
         if (Sym == SYMBOL2) {
            open2 = true;
            profit2 += profit;
         }
         if (Sym == SYMBOL3) {
            open3 = true;
            profit3 += profit;
         }
      }
   }

   profit = profit1 + profit2 + profit3;

   if (profit >= ProfitTarget) {
      for (i = OrdersTotal() - 1; i >= 0; i--) {
         if (OrderSelect(i, SELECT_BY_POS)) {
            if (MagicNumber != OrderMagicNumber()) continue;
            Sym = OrderSymbol();
            if (Sym != SYMBOL1 && Sym != SYMBOL2 && Sym != SYMBOL3) continue;
            if (!OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(MarketInfo(Sym, OrderType() == OP_BUY ? MODE_BID : MODE_ASK), (int) MarketInfo(Sym, MODE_DIGITS)), 1000, clrNONE))
               Print("Error close ", Sym);
         }
      }
   }

   Comment(
      "\n", TimeCurrent(),
      "\n" + SYMBOL1 + " = " + DoubleToString(PriceBid1, 5) + " / Lot = " + DoubleToString(Lot1, 2) + " / Profit = " + DoubleToString(profit1, 2) + " " + AC +
      "\n" + SYMBOL2 + " = " + DoubleToString(PriceBid2, 3) + " / Lot = " + DoubleToString(Lot2, 2) + " / Profit = " + DoubleToString(profit2, 2) + " " + AC +
      "\n" + SYMBOL3 + " = " + DoubleToString(PriceBid3, 3) + " / Lot = " + DoubleToString(Lot3, 2) + " / Profit = " + DoubleToString(profit3, 2) + " " + AC +
      "\nProfit Target = " + DoubleToString(ProfitTarget, 2) + " " + AC +
      "\nProfit Total = " + DoubleToString(profit, 2) + " " + AC);

   if (!open1) {
      if (OrderSend(SYMBOL1, TYPE1, Lot1, NormalizeDouble(MarketInfo(SYMBOL1, TYPE1 == OP_BUY ? MODE_BID : MODE_ASK),
            (int) MarketInfo(SYMBOL1, MODE_DIGITS)), 1000, 0, 0, "Hedge 3", MagicNumber, 0, clrNONE) == -1)
         Print("Error open ", Lot1, " ", SYMBOL1);
   }
   if (!open2) {
      if (OrderSend(SYMBOL2, TYPE2, Lot2, NormalizeDouble(MarketInfo(SYMBOL2, TYPE2 == OP_BUY ? MODE_BID : MODE_ASK),
            (int) MarketInfo(SYMBOL2, MODE_DIGITS)), 1000, 0, 0, "Hedge 3", MagicNumber, 0, clrNONE) == -1)
         Print("Error open ", Lot2, " ", SYMBOL2);
   }
   if (!open3) {
      if (OrderSend(SYMBOL3, TYPE3, Lot3, NormalizeDouble(MarketInfo(SYMBOL3, TYPE3 == OP_BUY ? MODE_BID : MODE_ASK),
            (int) MarketInfo(SYMBOL3, MODE_DIGITS)), 1000, 0, 0, "Hedge 3", MagicNumber, 0, clrNONE) == -1)
         Print("Error open ", Lot3, " ", SYMBOL3);
   }
   
}
//--------------------------------------------------------------------
