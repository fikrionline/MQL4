//+------------------------------------------------------------------+
//|                                                     FTC_v1.1.mq4 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.1"

extern int MagicNumber = 575899;
extern int StartHour = 4;
extern int EndHour = 20;
extern double Lots = 0.5;
extern double TakeProfit = 600;
extern double StopLoss = 450;
extern int SlipPage = 5;
extern bool OrderReverse = false;
extern bool UseTrailStopPoint = false;
extern double TrailingStopPoint = 300;
extern double TrailingStopPointLock = 100;

datetime NextCandle;
int SelectOrder, type, TicketOpen = 0, TicketClose = 0, TotalOrderBuy, TotalOrderSell, MagicNumberBuy, MagicNumberSell, NewSignal;
double price, sl, tp, slCandle, tpCandle, StartEquityBuySell, EquityMin, EquityMax;

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

   NewSignal = GetSignal();
   
   if(NewSignal == 1) {
      CloseOrderSell(MagicNumber);
   } else if(NewSignal == -1) {
      CloseOrderBuy(MagicNumber);
   }

   if(UseTrailStopPoint == TRUE && TrailingStopPoint > 0 && TrailingStopPointLock > 0) {
      RunTrailStop(MagicNumber, TrailingStopPoint, TrailingStopPointLock);
   }
   
   TotalOrderBuy = GetTotalOrderBuy();
   TotalOrderSell = GetTotalOrderSell();
   
   if(TotalOrderBuy == 0 && TotalOrderSell == 0) {
      StartEquityBuySell = DoubleToString(AccountEquity(), 2);
   }
   
   if (EquityMin == 0) {
      EquityMin = AccountEquity();
   }
   
   if (AccountEquity() < EquityMin) {
      EquityMin = AccountEquity();
   }
   
   if (EquityMax == 0) {
      EquityMax = AccountEquity();
   }
   
   if (AccountEquity() > EquityMax) {
      EquityMax = AccountEquity();
   }

   if (NextCandle <= Time[0]) {
      NextCandle = Time[0] + Period();
      // New candle, your trading functions here
      
      if((Hour() >= StartHour && Hour() < EndHour)) {

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
   
   Info();

}

void Info() {

   Comment("",
      "FTC",
      "\nEquity = ", DoubleToString(AccountEquity(), 2),
      "\nEquity Min = ", DoubleToString(EquityMin, 2),
      "\nEquity Max = ", DoubleToString(EquityMax, 2)
   );
   
}

int GetTotalOrderBuy() {
   int countOrderBuy = 0, TicketOrderSelect, cnt;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      TicketOrderSelect = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumberBuy) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberBuy && OrderType() == OP_BUY) {         
         countOrderBuy++;         
      }
      
   }
   return (countOrderBuy);
}

int GetTotalOrderSell() {
   int countOrderSell = 0, TicketOrderSelect, cnt;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      TicketOrderSelect = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumberSell) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberSell && OrderType() == OP_SELL) {         
         countOrderSell++;         
      }
      
   }
   return (countOrderSell);
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

void RunTrailStop(int CheckMagicNumber, double TheTrailingStopPoint, double TheTrailingStopPointLock) {
   int TicketTrail;
   for (int i = 0; i < OrdersTotal(); i++) {
      TicketTrail = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != CheckMagicNumber) {
         continue;
      }
      if (OrderSymbol() == Symbol()) {
         if (OrderType() == OP_BUY && OrderMagicNumber() == CheckMagicNumber) {
            if (Bid - OrderOpenPrice() > TheTrailingStopPoint * MarketInfo(OrderSymbol(), MODE_POINT)) {
               if (OrderStopLoss() < Bid - TheTrailingStopPoint * MarketInfo(OrderSymbol(), MODE_POINT)) {
                  TicketTrail = OrderModify(OrderTicket(), OrderOpenPrice(), Bid - TheTrailingStopPoint * MarketInfo(OrderSymbol(), MODE_POINT), OrderTakeProfit(), Red);
               }
            }
         } else if (OrderType() == OP_SELL && OrderMagicNumber() == CheckMagicNumber) {
            if (OrderOpenPrice() - Ask > TheTrailingStopPoint * MarketInfo(OrderSymbol(), MODE_POINT)) {
               if ((OrderStopLoss() > Ask + TheTrailingStopPoint * MarketInfo(OrderSymbol(), MODE_POINT)) || (OrderStopLoss() == 0)) {
                  TicketTrail = OrderModify(OrderTicket(), OrderOpenPrice(), Ask + TheTrailingStopPoint * MarketInfo(OrderSymbol(), MODE_POINT), OrderTakeProfit(), Red);
               }
            }
         }
      }
   }
}

//GetSignal
int GetSignal() {

   int SignalResult = 0;
   if(iCustom(Symbol(), PERIOD_CURRENT, "FTC", 0, 1) != EMPTY_VALUE) {
      SignalResult = 1;
   }
   
   if(iCustom(Symbol(), PERIOD_CURRENT, "FTC", 1, 1) != EMPTY_VALUE) {
      SignalResult = -1;
   }
   
   return SignalResult;
   
}
