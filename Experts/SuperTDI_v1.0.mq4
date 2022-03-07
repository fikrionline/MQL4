//+------------------------------------------------------------------+
//|                                                SuperTDI_v1.0.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.1"

extern int MagicNumber = 5758;
extern double Lots = 0.01;
extern double TakeProfit = 134;
extern double StopLoss = 134;
extern int SlipPage = 5;
extern bool OrderReverse = FALSE;

datetime NextCandle;
int SelectOrder, type;
int TicketOpen = 0;
int TicketClose = 0;
double price, sl, tp;

//Init
int init() {

   NextCandle = Time[0] + Period();
   return (0);

}

//Deinit
int deinit() {

   return (0);

}

//Start
void OnTick() {

   if (NextCandle <= Time[0]) {
      NextCandle = Time[0] + Period();
      // New candle, your trading functions here

      //Order when there are no order
      if (PosSelect(MagicNumber) == 0) {

         if (GetSignal() == 1) {

            type = OP_BUY;
            price = Ask;
            sl = StopLoss > 0 ? NormalizeDouble(price - (double) StopLoss * Point(), Digits()) : 0.0;
            tp = TakeProfit > 0 ? NormalizeDouble(price + (double) TakeProfit * Point(), Digits()) : 0.0;
            TicketOpen = OrderSend(Symbol(), type, Lots, price, SlipPage, sl, tp, IntegerToString(MagicNumber), MagicNumber, 0, Aqua);

         } else if (GetSignal() == -1) {

            type = OP_SELL;
            price = Bid;
            sl = StopLoss > 0 ? NormalizeDouble(price + (double) StopLoss * Point(), Digits()) : 0.0;
            tp = TakeProfit > 0 ? NormalizeDouble(price - (double) TakeProfit * Point(), Digits()) : 0.0;
            TicketClose = OrderSend(Symbol(), type, Lots, price, SlipPage, sl, tp, IntegerToString(MagicNumber), MagicNumber, 0, Aqua);

         }

      }

   }

}

int PosSelect(int CheckMagicNumber) {

   int posi = 0;
   for (int k = OrdersTotal() - 1; k >= 0; k--) {
      if (!OrderSelect(k, SELECT_BY_POS)) {
         break;
      }

      if ((OrderSymbol() != Symbol()) && (OrderMagicNumber() != CheckMagicNumber)) {
         continue;
      }

      if ((OrderCloseTime() == 0) && (OrderSymbol() == Symbol()) && (OrderMagicNumber() == CheckMagicNumber)) {
         if (OrderType() == OP_BUY) {
            posi = 1; //Long position
         }
         if (OrderType() == OP_SELL) {
            posi = -1; //Short positon
         }
      }
   }

   return (posi);

}

int CloseOrderBuy(int CheckMagicNumberBuy) {
   int TicketOrderSelect, TicketOrderClose;
   for (int i = OrdersTotal() - 1; i >= 0; i--) {
      TicketOrderSelect = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != CheckMagicNumberBuy) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == CheckMagicNumberBuy && OrderType() == OP_BUY) {
         TicketOrderClose = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), SlipPage, clrNONE);        
      }      
   }   
   return (0);
}

int CloseOrderSell(int CheckMagicNumberSell) {
   int TicketOrderSelect, TicketOrderClose;
   for (int i = OrdersTotal() - 1; i >= 0; i--) {
      TicketOrderSelect = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != CheckMagicNumberSell) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == CheckMagicNumberSell && OrderType() == OP_SELL) {         
         TicketOrderClose = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), SlipPage, clrNONE);
      }      
   }   
   return (0);
}

//GetSignal
int GetSignal() {

   int SignalResult = 0;
   
   if(iCustom(Symbol(), PERIOD_CURRENT, "JurikFilter", 3, 1) != EMPTY_VALUE) {
      //if(iCustom(Symbol(), PERIOD_M15, "JurikFilter", 3, 0) != EMPTY_VALUE) {
         if(OrderReverse == FALSE) {
            SignalResult = 1;
         } else if(OrderReverse == TRUE) {
            SignalResult = -1;
         }
      //}
   }
   
   if(iCustom(Symbol(), PERIOD_CURRENT, "JurikFilter", 4, 1) != EMPTY_VALUE) {
      //if(iCustom(Symbol(), PERIOD_M15, "JurikFilter", 4, 0) != EMPTY_VALUE) {
         if(OrderReverse == FALSE) {
            SignalResult = -1;
         } else if(OrderReverse == TRUE) {
            SignalResult = 1;
         }
      //}
   }
   
   return SignalResult;

}
