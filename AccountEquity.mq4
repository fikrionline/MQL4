//+------------------------------------------------------------------+
//|                                                           DD.mq4 |
//|                                     Pedro Pablo Severin Honorato |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Pedro Pablo Severin Honorato"
#property link "https://www.mql5.com"
#property version "1.00"
#property strict
#property indicator_chart_window

string balance = "balance";
string drawdown = "drawdown";
string patrimonio = "patrimonio";
string accprof = "profits";
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {
   //--- indicator buffers mapping

   //---
   return (INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   Comment("");
   ObjectDelete("=");
   ObjectDelete(balance);
   ObjectDelete(patrimonio);
   ObjectDelete(drawdown);
   ObjectDelete(accprof);
   for (int i = 0; i < 99; i++) {
      ObjectDelete(IntegerToString(i));
   }
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
   const int prev_calculated,
      const datetime & time[],
         const double & open[],
            const double & high[],
               const double & low[],
                  const double & close[],
                     const long & tick_volume[],
                        const long & volume[],
                           const int & spread[]) {
   //---


   string DepositCurrency = AccountInfoString(ACCOUNT_CURRENCY);

   double freeMargin = AccountInfoDouble(ACCOUNT_EQUITY);
   
   color col;

   string symbols[], symb;
   double profit[];
   bool existe = false;
   for (int i = OrdersTotal() - 1; i >= 0; i--) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         symb = OrderSymbol();

         for (int j = 0; j < ArraySize(symbols); j++) {
            existe = false;
            if (symb == symbols[j]) {
               existe = true;
               break;
            }
         }
         
         if (!existe) {
            ArrayResize(symbols, ArraySize(symbols) + 1);
            ArrayResize(profit, ArraySize(profit) + 1);
            symbols[ArraySize(symbols) - 1] = symb;

            for (int k = OrdersTotal() - 1; k >= 0; k--) {
               if (OrderSelect(k, SELECT_BY_POS, MODE_TRADES)) {
                  if (OrderSymbol() == symbols[ArraySize(symbols) - 1]) {
                     profit[ArraySize(profit) - 1] += NormalizeDouble(OrderProfit(), 2);
                  }
               }
            }
         }
      }
   }

   for (int i = 0; i < 99; i++) {
      ObjectDelete(IntegerToString(i));
   }

   for (int i = 0; i < ArraySize(symbols); i++) {
      ObjectCreate(IntegerToString(i), OBJ_LABEL, 0, 0, 0, 0);
      ObjectSet(IntegerToString(i), OBJPROP_CORNER, 1);
      ObjectSet(IntegerToString(i), OBJPROP_XDISTANCE, 10);
      ObjectSet(IntegerToString(i), OBJPROP_YDISTANCE, 10 + 20 * (i + 1));
      col = (profit[i] > 0) ? Lime : (profit[i] < 0) ? Red : White;

      ObjectSetText(IntegerToString(i), symbols[i] + ": " + DoubleToString(NormalizeDouble(profit[i], 2), 2) + " (" + DoubleToString(NormalizeDouble(MathFloor(MathAbs(NormalizeDouble(profit[i], 2) / freeMargin * 10000)) / 100, 2), 2) + "%)", 10, "Arial", col);

      if (NormalizeDouble(MathFloor(MathAbs(NormalizeDouble(profit[i], 2) / freeMargin * 10000)) / 100, 2) > 5) {
         Alert("Trades por mas del 5% en " + symbols[i]);
      }
   }
   
   ObjectDelete("=");
   ObjectDelete(balance);
   ObjectDelete(patrimonio);
   ObjectDelete(drawdown);
   ObjectDelete(accprof);

   ObjectCreate("=", OBJ_LABEL, 0, 0, 0, 0);
   ObjectSet("=", OBJPROP_CORNER, 1);
   ObjectSet("=", OBJPROP_XDISTANCE, 10);
   ObjectSet("=", OBJPROP_YDISTANCE, 10 + 20 * (ArraySize(symbols) + 1));
   ObjectSetText("=", "====================", 10, "Arial", White);

   ObjectCreate(balance, OBJ_LABEL, 0, 0, 0, 0);
   ObjectSet(balance, OBJPROP_CORNER, 1);
   ObjectSet(balance, OBJPROP_XDISTANCE, 10);
   ObjectSet(balance, OBJPROP_YDISTANCE, 10 + 20 * (ArraySize(symbols) + 2));
   ObjectSetText(balance, "Account Balance: " + DoubleToString(AccountBalance(), 2), 10, "Arial", White);

   ObjectCreate(patrimonio, OBJ_LABEL, 0, 0, 0, 0);
   ObjectSet(patrimonio, OBJPROP_CORNER, 1);
   ObjectSet(patrimonio, OBJPROP_XDISTANCE, 10);
   ObjectSet(patrimonio, OBJPROP_YDISTANCE, 10 + 20 * (ArraySize(symbols) + 3));
   col = (AccountEquity() > AccountBalance()) ? Lime : (AccountEquity() < AccountBalance()) ? Red : White;
   ObjectSetText(patrimonio, "Account Equity: " + DoubleToString(AccountEquity(), 2), 10, "Arial", col);

   ObjectCreate(accprof, OBJ_LABEL, 0, 0, 0, 0);
   ObjectSet(accprof, OBJPROP_CORNER, 1);
   ObjectSet(accprof, OBJPROP_XDISTANCE, 10);
   ObjectSet(accprof, OBJPROP_YDISTANCE, 10 + 20 * (ArraySize(symbols) + 4));
   col = (AccountProfit() > 0) ? Lime : (AccountProfit() < 0) ? Red : White;
   ObjectSetText(accprof, "Account Profits: " + DoubleToString(NormalizeDouble(AccountProfit(), 2), 2), 10, "Arial", col);

   ObjectCreate(drawdown, OBJ_LABEL, 0, 0, 0, 0);
   ObjectSet(drawdown, OBJPROP_CORNER, 1);
   ObjectSet(drawdown, OBJPROP_XDISTANCE, 10);
   ObjectSet(drawdown, OBJPROP_YDISTANCE, 10 + 20 * (ArraySize(symbols) + 5));
   ObjectSetText(drawdown, "Account Drawdown: " + DoubleToString(NormalizeDouble(AccountProfit() / AccountEquity() * 100, 2), 2) + "%", 10, "Arial", White);

   //--- return value of prev_calculated for next call
   return (rates_total);
}
//+------------------------------------------------------------------+