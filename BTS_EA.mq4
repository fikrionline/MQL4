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
extern int SlipPage = 3;
extern double Lots = 1;

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
double PriceOrder, SL, TP, BuyLimitPrice, SellLimitPrice;
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
      
      GetSignal = Signal();

      int total = OrdersTotal();
      for (int i = total - 1; i >= 0; i--) {
         SelectOrder = OrderSelect(i, SELECT_BY_POS);
         int type = OrderType();

         switch (type) {
         
            //Close opened long positions
            case OP_BUY:
               if(GetSignal == -1) {
                  //TicketClose = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), SlipPage, CLR_NONE);
               }
            break;

            //Close opened short positions
            case OP_SELL:
               if(GetSignal == 1) {
                  //TicketClose = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), SlipPage, CLR_NONE);
               }
            break;
            
         }

      }

      if (GetSignal == 1) {
      
         if(TradeType == 0 || TradeType == 1) {
      
            DeletePendingOrderBuy(MagicNumber);
            
            SL = iLow(Symbol(), PERIOD_CURRENT, 2) - ((iHigh(Symbol(), PERIOD_CURRENT, 2) - iLow(Symbol(), PERIOD_CURRENT, 2)) * MathAbs(FiboBuySL1));
            TP = iLow(Symbol(), PERIOD_CURRENT, 2) + ((iHigh(Symbol(), PERIOD_CURRENT, 2) - iLow(Symbol(), PERIOD_CURRENT, 2)) * MathAbs(FiboBuyTP1));
            
            if(Ask < TP) {
               TicketOpen = OrderSend(Symbol(), OP_BUY, Lots, Ask, SlipPage, SL, TP, IntegerToString(MagicNumber), MagicNumber, 0, CLR_NONE);
            }
            
            BuyLimitPrice = iHigh(Symbol(), PERIOD_CURRENT, 2);
            TicketOpen = OrderSend(Symbol(), OP_BUYLIMIT, Lots, BuyLimitPrice, SlipPage, SL, TP, IntegerToString(MagicNumber), MagicNumber, 0, CLR_NONE);
            
         }
         
      } else if (GetSignal == -1) {
         
         if(TradeType == 0 || TradeType == -1) {
         
            DeletePendingOrderSell(MagicNumber);
            
            SL = iLow(Symbol(), PERIOD_CURRENT, 2) + ((iHigh(Symbol(), PERIOD_CURRENT, 2) - iLow(Symbol(), PERIOD_CURRENT, 2)) * MathAbs(FiboSellSL1));
            TP = iLow(Symbol(), PERIOD_CURRENT, 2) - ((iHigh(Symbol(), PERIOD_CURRENT, 2) - iLow(Symbol(), PERIOD_CURRENT, 2)) * MathAbs(FiboSellTP1));
            
            if(Bid > TP) {
               TicketOpen = OrderSend(Symbol(), OP_SELL, Lots, Bid, SlipPage, SL, TP, IntegerToString(MagicNumber), MagicNumber, 0, CLR_NONE);
            }
            
            SellLimitPrice = iLow(Symbol(), PERIOD_CURRENT, 2);         
            TicketOpen = OrderSend(Symbol(), OP_SELLLIMIT, Lots, SellLimitPrice, SlipPage, SL, TP, IntegerToString(MagicNumber), MagicNumber, 0, CLR_NONE);
            
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
   
   if((Candle1Open < Candle1Close) && (Candle2Open > Candle2Close)) {
      if(Candle1Close > Candle2High) {
         signal = 1;
      }
   }
   
   if((Candle1Open > Candle1Close) && (Candle2Open < Candle2Close)) {
      if(Candle1Close < Candle2Low) {
         signal = -1;
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