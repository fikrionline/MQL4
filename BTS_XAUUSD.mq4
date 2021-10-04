//+------------------------------------------------------------------+
//|                                                       BTS_EA.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             htTPs://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link "htTPs://www.mql5.com"
#property version "1.00"
#property strict

enum BuySell {
   BuyOnly = 1,
   SellOnly = -1,
   BuySell = 0
};

extern BuySell TradeType = 0;

extern int MagicNumber = 5758;
extern double Lots = 1;
extern int SlipPage = 3;

extern string StartEA = "00:00";
extern string EndEA = "24:00";

extern double FiboBuyTP1 = 2.170;
extern double FiboBuyTP2 = 3.340;
extern double FiboBuyTP3 = 4.510;
extern double FiboBuyTP4 = 5.680;
extern double FiboBuySL1 = -0.085;
extern double FiboBuySL2 = -0.170;
extern double FiboBuySL3 = -0.340;

extern double FiboSellTP1 = -1.170;
extern double FiboSellTP2 = -2.340;
extern double FiboSellTP3 = -3.510;
extern double FiboSellTP4 = -4.680;
extern double FiboSellSL1 = 1.085;
extern double FiboSellSL2 = 1.170;
extern double FiboSellSL3 = 1.340;

int TicketOpen = 0;
int TicketClose = 0;
int TicketOrder = 0;
int SelectOrder, TypeOrder, GetSignal, GetCandleStatus;
double PriceOrder, SL, TP, BuyLimitPrice, SellLimitPrice, LotOrder, GetPointSL, GetPointTP, SLL, TPP;
datetime NextCandle;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init() {

   NextCandle = Time[0] + Period();
   return (0);
   
}

//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit() {

   return (0);
   
}

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start() {

   if (NextCandle <= Time[0]) {
      NextCandle = Time[0] + Period();
      // New candle, your trading functions here
      
      if (TimeCurrent() >= StrToTime(StartEA) && TimeCurrent() <= StrToTime(EndEA)) {
      
         GetSignal = Signal();
   
         int total = OrdersTotal();
         for (int i = total - 1; i >= 0; i--) {
            SelectOrder = OrderSelect(i, SELECT_BY_POS);
            int type = OrderType();
   
            switch (type) {
            
               //Close opened long positions
               case OP_BUY:
                  //TicketClose = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), SlipPage, CLR_NONE);
               break;
   
               //Close opened short positions
               case OP_SELL:
                  //TicketClose = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), SlipPage, CLR_NONE);
               break;
               
            }
   
         }
         
         if(CheckProfitLastTrade(Symbol(), MagicNumber) == -1) {
            LotOrder = Lots * 1;
         } else {
            LotOrder = Lots;
         }
   
         if (GetSignal == 1) {
         
            if(TradeType == 0 || TradeType == 1) {
         
               DeletePendingOrderBuy(MagicNumber);
               DeletePendingOrderSell(MagicNumber);
               
               SL = iLow(Symbol(), PERIOD_CURRENT, 2) - ((iHigh(Symbol(), PERIOD_CURRENT, 2) - iLow(Symbol(), PERIOD_CURRENT, 2)) * MathAbs(FiboBuySL1));
               TP = iLow(Symbol(), PERIOD_CURRENT, 2) + ((iHigh(Symbol(), PERIOD_CURRENT, 2) - iLow(Symbol(), PERIOD_CURRENT, 2)) * MathAbs(FiboBuyTP1));
               
               GetPointSL = NormalizeDouble((Ask - SL) / Point(), 0);
               GetPointTP = NormalizeDouble((TP - Ask) / Point(), 0);
               
               if(GetPointSL > GetPointTP) {
                  GetPointTP = GetPointSL;
               } 
               
               if(GetPointTP > GetPointSL) {
                  GetPointSL = GetPointTP;
               }
               
               if(GetPointSL > 100 && GetPointSL < 1000) {
               
                  SLL = NormalizeDouble(Ask - (double) GetPointSL * Point(), Digits());
                  TPP = NormalizeDouble(Ask + (double) GetPointTP * Point(), Digits());
                  
                  TicketOpen = OrderSend(Symbol(), OP_BUY, LotOrder, Ask, SlipPage, SLL, TPP, IntegerToString(MagicNumber), MagicNumber, 0, CLR_NONE);
               
               }
                  
               //BuyLimitPrice = iHigh(Symbol(), PERIOD_CURRENT, 2);
               //TicketOpen = OrderSend(Symbol(), OP_BUYLIMIT, LotOrder, BuyLimitPrice, SlipPage, SL, TP, IntegerToString(MagicNumber), MagicNumber, 0, CLR_NONE);
               
            }
            
         } else if (GetSignal == -1) {
            
            if(TradeType == 0 || TradeType == -1) {
            
               DeletePendingOrderBuy(MagicNumber);
               DeletePendingOrderSell(MagicNumber);
               
               SL = iLow(Symbol(), PERIOD_CURRENT, 2) + ((iHigh(Symbol(), PERIOD_CURRENT, 2) - iLow(Symbol(), PERIOD_CURRENT, 2)) * MathAbs(FiboSellSL1));
               TP = iLow(Symbol(), PERIOD_CURRENT, 2) - ((iHigh(Symbol(), PERIOD_CURRENT, 2) - iLow(Symbol(), PERIOD_CURRENT, 2)) * MathAbs(FiboSellTP1));
               
               GetPointSL = NormalizeDouble((SL - Bid) / Point(), 0);
               GetPointTP = NormalizeDouble((Bid - TP) / Point(), 0);
               
               if(GetPointSL > GetPointTP) {
                  GetPointTP = GetPointSL;
               } 
               
               if(GetPointTP > GetPointSL) {
                  GetPointSL = GetPointTP;
               }
               
               if(GetPointSL > 100 && GetPointSL < 1000) {
               
                  SLL = NormalizeDouble(Bid + (double) GetPointSL * Point(), Digits());
                  TPP = NormalizeDouble(Bid - (double) GetPointTP * Point(), Digits());
                  
                  TicketOpen = OrderSend(Symbol(), OP_SELL, LotOrder, Bid, SlipPage, SLL, TPP, IntegerToString(MagicNumber), MagicNumber, 0, CLR_NONE);
                  
               }
               
               //SellLimitPrice = iLow(Symbol(), PERIOD_CURRENT, 2);
               //TicketOpen = OrderSend(Symbol(), OP_SELLLIMIT, LotOrder, SellLimitPrice, SlipPage, SL, TP, IntegerToString(MagicNumber), MagicNumber, 0, CLR_NONE);
               
            }
            
         }
         
      }

   }

   return (0);
   
}

//+------------------------------------------------------------------+
//Signal
int Signal() {

   int signal = 0;

   double Candle1Open = iOpen(Symbol(), PERIOD_CURRENT, 1);
   double Candle1Close = iClose(Symbol(), PERIOD_CURRENT, 1);
   
   double Candle2Open = iOpen(Symbol(), PERIOD_CURRENT, 2);
   double Candle2Close = iClose(Symbol(), PERIOD_CURRENT, 2);
   
   double Candle2High = iHigh(Symbol(), PERIOD_CURRENT, 2);
   double Candle2Low = iLow(Symbol(), PERIOD_CURRENT, 2);
   
   //double iRSICandle = iRSI(Symbol(), PERIOD_CURRENT, 3, PRICE_CLOSE, 2);
   
   if((Candle1Open < Candle1Close) && (Candle2Open > Candle2Close)) {
      if(Candle1Close > Candle2High) {
         //if(iRSICandle < 30) {
            signal = 1;
         //}
      }
   }
   
   if((Candle1Open > Candle1Close) && (Candle2Open < Candle2Close)) {
      if(Candle1Close < Candle2Low) {
         //if(iRSICandle > 70) {
            signal = -1;
         //}
      }
   }

   return signal;

}

//+------------------------------------------------------------------+
//Delete Pending Order
int DeletePendingOrderBuy(int CheckMagic) {
   int total = OrdersTotal();

   for (int cnt = total - 1; cnt >= 0; cnt--) {
      TicketOrder = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderMagicNumber() == CheckMagic && OrderSymbol() == Symbol() && OrderType() == OP_BUYLIMIT) {
         TicketOrder = OrderDelete(OrderTicket());
      }
   }
   return (0);
}

int DeletePendingOrderSell(int CheckMagic) {
   int total = OrdersTotal();

   for (int cnt = total - 1; cnt >= 0; cnt--) {
      TicketOrder = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderMagicNumber() == CheckMagic && OrderSymbol() == Symbol() && OrderType() == OP_SELLLIMIT) {
         TicketOrder = OrderDelete(OrderTicket());
      }
   }
   return (0);
}


//+------------------------------------------------------------------+
//Check Profit Last Trade
int CheckProfitLastTrade(string ThePair, int TheMagic) {

   int ProfitLoss = 0;

   for (int i = OrdersHistoryTotal() - 1; i >= 0; i--) {

      if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) && OrderSymbol() == ThePair && OrderMagicNumber() == TheMagic) {
         
         //for Buy
         if(OrderType() == OP_BUY && OrderProfit() > 0) {
            ProfitLoss = 1;
         }
         if(OrderType() == OP_BUY && OrderProfit() < 0) {
            ProfitLoss = -1;
         }         
         break;
         
         //for Sell
         if(OrderType() == OP_SELL && OrderProfit() > 0) {
            ProfitLoss = 1;
         }
         if(OrderType() == OP_SELL && OrderProfit() < 0) {
            ProfitLoss = -1;
         }         
         break;
         
      }

   }

   return (ProfitLoss);

}

//+------------------------------------------------------------------+
//Filter
int FilterOrder() {

   int iMATrend = 0;
   
   double iMAFirst = iMA(Symbol(), PERIOD_CURRENT, 10, 0, MODE_EMA, PRICE_CLOSE, 1);
   double iMASecond = iMA(Symbol(), PERIOD_CURRENT, 20, 0, MODE_EMA, PRICE_CLOSE, 1);
   double iMAThird = iMA(Symbol(), PERIOD_CURRENT, 40, 0, MODE_EMA, PRICE_CLOSE, 1);
   
   if(iMAFirst > iMASecond && iMASecond > iMAThird) {
      iMATrend = 1;
   }
   
   if(iMAFirst < iMASecond && iMASecond < iMAThird) {
      iMATrend = -1;
   }
   
   return iMATrend;
   
}
