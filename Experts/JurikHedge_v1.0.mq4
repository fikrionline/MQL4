//+------------------------------------------------------------------+
//|                                              JurikHedge_v1.0.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.1"

extern int MagicNumber = 5758;
extern double Lots = 0.01;
extern double TakeProfit = 0;
extern double StopLoss = 0;
extern int SlipPage = 5;
extern bool UseTrail = TRUE;
extern double TrailingStop = 100;

datetime NextCandle;
int SelectOrder, type, TicketOpen = 0, TicketClose = 0, NewSignal, TicketOrderSend, TicketOrderSelect, TicketOrderClose, TicketOrderDelete, TicketOrderModify;
double price, sl, tp, StartEquityBuySell, EquityMin, EquityMax;

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

   if(UseTrail == TRUE) {
      RunTrailStop(MagicNumber);
   }

   if(PosSelect(MagicNumber) == 0) {
      StartEquityBuySell = DoubleToString(AccountEquity(), 2);
   }
   
   if(EquityMin == 0) {
      EquityMin = AccountEquity();
   }
   
   if(AccountEquity() < EquityMin) {
      EquityMin = AccountEquity();
   }
   
   if(EquityMax == 0) {
      EquityMax = AccountEquity();
   }
   
   if(AccountEquity() > EquityMax) {
      EquityMax = AccountEquity();
   }

   Info();

   //if (NextCandle <= Time[0]) {
      //NextCandle = Time[0] + Period();
      // New candle, your trading functions here

      //Order when there are no order
      
      NewSignal = GetSignal();

      if (NewSignal == 1) {
      
         //CloseOrderSell(MagicNumber);
         
         if(PosSelectBuy(MagicNumber) == 0) {

            type = OP_BUY;
            price = Ask;
            sl = StopLoss > 0 ? NormalizeDouble(price - (double) StopLoss * Point(), Digits()) : 0.0;
            tp = TakeProfit > 0 ? NormalizeDouble(price + (double) TakeProfit * Point(), Digits()) : 0.0;
            TicketOpen = OrderSend(Symbol(), type, Lots, price, SlipPage, sl, tp, IntegerToString(MagicNumber), MagicNumber, 0, Aqua);
         
         }

      } else if (NewSignal == -1) {
      
         //CloseOrderBuy(MagicNumber);

         if(PosSelectSell(MagicNumber) == 0) {
         
            type = OP_SELL;
            price = Bid;
            sl = StopLoss > 0 ? NormalizeDouble(price + (double) StopLoss * Point(), Digits()) : 0.0;
            tp = TakeProfit > 0 ? NormalizeDouble(price - (double) TakeProfit * Point(), Digits()) : 0.0;
            TicketClose = OrderSend(Symbol(), type, Lots, price, SlipPage, sl, tp, IntegerToString(MagicNumber), MagicNumber, 0, Aqua);
         
         }

      }

   //}

}

//Signal
int GetSignal() {

   int SignalResult = 0;
   
   if(iCustom(Symbol(), PERIOD_CURRENT, "JurikFilter", 3, 0) != EMPTY_VALUE) {
      //if(iCustom(Symbol(), PERIOD_M1, "JurikFilter", 3, 0) != EMPTY_VALUE) {
         SignalResult = 1;
      //}
   }
   
   if(iCustom(Symbol(), PERIOD_CURRENT, "JurikFilter", 4, 0) != EMPTY_VALUE) {
      //if(iCustom(Symbol(), PERIOD_M1, "JurikFilter", 4, 0) != EMPTY_VALUE) {
         SignalResult = -1;
      //}
   }
   
   return SignalResult;

}

//Check previous order
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

int PosSelectBuy(int CheckMagicNumberBuy) {

   int posi = 0;
   for (int k = OrdersTotal() - 1; k >= 0; k--) {
      if (!OrderSelect(k, SELECT_BY_POS)) {
         break;
      }

      if ((OrderSymbol() != Symbol()) && (OrderMagicNumber() != CheckMagicNumberBuy)) {
         continue;
      }

      if ((OrderCloseTime() == 0) && (OrderSymbol() == Symbol()) && (OrderMagicNumber() == CheckMagicNumberBuy)) {
         if (OrderType() == OP_BUY) {
            posi = 1; //Long position
         }
      }
   }

   return (posi);

}

int PosSelectSell(int CheckMagicNumberSell) {

   int posi = 0;
   for (int k = OrdersTotal() - 1; k >= 0; k--) {
      if (!OrderSelect(k, SELECT_BY_POS)) {
         break;
      }

      if ((OrderSymbol() != Symbol()) && (OrderMagicNumber() != CheckMagicNumberSell)) {
         continue;
      }

      if ((OrderCloseTime() == 0) && (OrderSymbol() == Symbol()) && (OrderMagicNumber() == CheckMagicNumberSell)) {
         if (OrderType() == OP_SELL) {
            posi = -1; //Short positon
         }
      }
   }

   return (posi);

}

//CloseLastBuy -------------------------------------------------------------------------------
int CloseLast(int CheckMagicNumber) {
   int i_ticket = OrdersTotal() - 1;

   if (i_ticket > -1 && OrderSelect(i_ticket, SELECT_BY_POS)) {

      if (OrderSymbol() == Symbol() && OrderMagicNumber() == CheckMagicNumber) {

         if (OrderType() == OP_BUY) {
            if (OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(MarketInfo(Symbol(), MODE_BID), (int) MarketInfo(Symbol(), MODE_DIGITS)), SlipPage, Yellow)) {
               return (1); //close ok
            }
         }

         if (OrderType() == OP_SELL) {
            if (OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(MarketInfo(Symbol(), MODE_ASK), (int) MarketInfo(Symbol(), MODE_DIGITS)), SlipPage, Yellow)) {
               return (1); //close ok
            }
         }

      }

   }

   return (-1); //error while closing

}

int CloseOrderBuy(int CheckMagicNumberBuy) {
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
   for (int i = OrdersTotal() - 1; i >= 0; i--) {
      TicketOrderSelect = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != CheckMagicNumberSell) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == CheckMagicNumberSell && OrderType() == OP_SELL) {         
         TicketOrderClose = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), SlipPage, clrNONE);
      }      
   }   
   return (0);
}

void Info() {

   Comment("",
      "Jurik Hedge",
      "\nStartEquityBuySell = ", StartEquityBuySell,
      "\nEquity = ", DoubleToString(AccountEquity(), 2),
      "\nEquity Min = ", DoubleToString(EquityMin, 2) + " (" + DoubleToString((EquityMin - StartEquityBuySell), 2) + ")",
      "\nEquity Max = ", DoubleToString(EquityMax, 2) + " (+" + DoubleToString((EquityMax - StartEquityBuySell), 2) + ")",
      //"\nPnL = ", DoubleToString(PNL, 2),
      //"\nPnL Min = ", DoubleToString(PNLMin, 2),
      //"\nPnL Max = ", DoubleToString(PNLMax, 2),
      //"\nPnL Buy = ", DoubleToString(PNLBuy, 2),
      //"\nPnL Buy Min = ", DoubleToString(PNLBuyMin, 2),
      //"\nPnL Buy Max = ", DoubleToString(PNLBuyMax, 2),
      //"\nPnL Sell = ", DoubleToString(PNLSell, 2),
      //"\nPnL Sell Min = ", DoubleToString(PNLSellMin, 2),
      //"\nPnL Sell Max = ", DoubleToString(PNLSellMax, 2),
      //"\nStarting Lot = ", StartingLots,
      //"\nLast Lot Buy = ", LastLotsBuy,
      //"\nLast Lot Sell = ", LastLotsSell,
      //"\nMax Lot Buy = ", MaxLotsBuy,
      //"\nMax Lot Sell = ", MaxLotsSell,
      //"\nLast Price Order Buy = ", DoubleToString(LastPriceOrderBuy, Digits),
      //"\nLast Price Order Sell = ", DoubleToString(LastPriceOrderSell, Digits),
      //"\nAverage Daily Range = ", GetADRs(PERIOD_D1, 20, 1),
      "\nTakeProfit = ", TakeProfit
   );
   
}

void RunTrailStop(int CheckMagicNumber) {
   int TicketTrail;
   for (int i = 0; i < OrdersTotal(); i++) {
      TicketTrail = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != CheckMagicNumber) {
         continue;
      }
      if (OrderSymbol() == Symbol()) {
         if (OrderType() == OP_BUY && OrderMagicNumber() == CheckMagicNumber) {
            if (Bid - OrderOpenPrice() > TrailingStop * MarketInfo(OrderSymbol(), MODE_POINT)) {
               if (OrderStopLoss() < Bid - TrailingStop * MarketInfo(OrderSymbol(), MODE_POINT)) {
                  TicketTrail = OrderModify(OrderTicket(), OrderOpenPrice(), Bid - TrailingStop * MarketInfo(OrderSymbol(), MODE_POINT), OrderTakeProfit(), Red);
               }
            }
         } else if (OrderType() == OP_SELL && OrderMagicNumber() == CheckMagicNumber) {
            if (OrderOpenPrice() - Ask > TrailingStop * MarketInfo(OrderSymbol(), MODE_POINT)) {
               if ((OrderStopLoss() > Ask + TrailingStop * MarketInfo(OrderSymbol(), MODE_POINT)) || (OrderStopLoss() == 0)) {
                  TicketTrail = OrderModify(OrderTicket(), OrderOpenPrice(), Ask + TrailingStop * MarketInfo(OrderSymbol(), MODE_POINT), OrderTakeProfit(), Red);
               }
            }
         }
      }
   }
}
