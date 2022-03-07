//+------------------------------------------------------------------+
//|                                              JurikHedge_v1.0.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.0"

extern double EquityMinStopEA = 9600.00;
extern double EquityMaxStopEA = 10880.00;
extern int MagicNumber = 5758;
extern int StartHour = 5;
extern int EndHour = 20;
extern double Lots = 0.1;
extern double TakeProfit = 0;
extern double StopLoss = 0;
extern int SlipPage = 5;
extern bool OrderReverse = FALSE;
extern bool UseTrailStopPoint = FALSE;
extern double TrailingStopPoint = 100;
extern double TrailingStopPointLock = 50;
extern bool UseTrailingStopUSD = TRUE;
extern double TrailingStopUSD = 100;
extern double TrailingStopUSDLock = 50;
extern double StopOrderProfit = 0;

datetime NextCandle;
int SelectOrder, type, TicketOpen = 0, TicketClose = 0, NewSignal, TicketOrderSend, TicketOrderSelect, TicketOrderClose, TicketOrderDelete, TicketOrderModify;
double price, sl, tp, StartEquityBuySell, EquityMin, EquityMax, PNL, TemporaryProfitToLock = 0;

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

   MinRemoveExpertNow(EquityMinStopEA);
   MaxRemoveExpertNow(EquityMaxStopEA);
   
   NewSignal = GetSignal();
   
   if (NewSignal == 1) {
      CloseOrderSell(MagicNumber);
   } else if (NewSignal == -1) {
      CloseOrderBuy(MagicNumber);
   }         
      
   if((Hour() >= StartHour && Hour() < EndHour)) {

      if (NewSignal == 1) {

         if(PosSelect(MagicNumber) == 0) {
         
            StartEquityBuySell = AccountEquity();
         
            type = OP_BUY;
            price = Ask;
            sl = StopLoss > 0 ? NormalizeDouble(price - (double) StopLoss * Point(), Digits()) : 0.0;
            tp = TakeProfit > 0 ? NormalizeDouble(price + (double) TakeProfit * Point(), Digits()) : 0.0;
            TicketOpen = OrderSend(Symbol(), type, Lots, price, SlipPage, sl, tp, IntegerToString(MagicNumber), MagicNumber, 0, Aqua);
            
         }

      } else if (NewSignal == -1) {
         
         if(PosSelect(MagicNumber) == 0) {
         
            StartEquityBuySell = AccountEquity();
         
            type = OP_SELL;
            price = Bid;
            sl = StopLoss > 0 ? NormalizeDouble(price + (double) StopLoss * Point(), Digits()) : 0.0;
            tp = TakeProfit > 0 ? NormalizeDouble(price - (double) TakeProfit * Point(), Digits()) : 0.0;
            TicketClose = OrderSend(Symbol(), type, Lots, price, SlipPage, sl, tp, IntegerToString(MagicNumber), MagicNumber, 0, Aqua);
            
         }

      }
      
   }
   
   PNL = AccountEquity() - StartEquityBuySell;
   
   if(StopOrderProfit > 0 && PNL > StopOrderProfit) {
      CloseOrderBuy(MagicNumber);
      CloseOrderSell(MagicNumber);
      StartEquityBuySell = AccountEquity();
   }

   if(UseTrailStopPoint == TRUE) {
      RunTrailStop(MagicNumber, TrailingStopPoint, TrailingStopPointLock);
   }
   
   if(UseTrailingStopUSD == TRUE) {
      if(TemporaryProfitToLock == 0 && PNL > TrailingStopUSD) {
         TemporaryProfitToLock = TrailingStopUSDLock;
      }
      if(TemporaryProfitToLock > 0) {
         if((PNL - TrailingStopUSDLock) > TemporaryProfitToLock) {
            TemporaryProfitToLock = PNL - TrailingStopUSDLock;
         }
      }
      if(TemporaryProfitToLock > 0 && PNL < TemporaryProfitToLock) {
         TemporaryProfitToLock = 0;
         CloseOrderBuy(MagicNumber);
         CloseOrderSell(MagicNumber);
         StartEquityBuySell = AccountEquity();
      }
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
      "\nStartEquityBuySell = ", DoubleToString(StartEquityBuySell, 2),
      "\nEquity = ", DoubleToString(AccountEquity(), 2),
      "\nEquity Min = ", DoubleToString(EquityMin, 2) + " (" + DoubleToString((EquityMin - StartEquityBuySell), 2) + ")",
      "\nEquity Max = ", DoubleToString(EquityMax, 2) + " (+" + DoubleToString((EquityMax - StartEquityBuySell), 2) + ")",
      "\nPnL = ", DoubleToString(PNL, 2),
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
      "\nProfitToLock = ", DoubleToString(TemporaryProfitToLock, 2)
   );
   
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

int MinRemoveExpertNow(double MinimumEquity = 0) {
   
   if(MinimumEquity > 0 && AccountEquity() < MinimumEquity) {
      RemoveAllOrders();
      RemoveAllOrders();
      RemoveAllOrders();
      ExpertRemove();
   }
   return(0);
   
}

int MaxRemoveExpertNow(double MaximumEquity = 0) {
   
   if(MaximumEquity > 0 && AccountEquity() > MaximumEquity) {
      RemoveAllOrders();
      RemoveAllOrders();
      RemoveAllOrders();
      ExpertRemove();
   }
   return(0);
   
}

void RemoveAllOrders() {
   for(int i = OrdersTotal() - 1; i >= 0 ; i--)    {
      TicketOrderSelect = OrderSelect(i, SELECT_BY_POS);
      if(OrderType() == OP_BUY) {
         TicketOrderClose = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, clrNONE);
      } else if(OrderType() == OP_SELL) {
         TicketOrderClose = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, clrNONE);
      } else {
         TicketOrderDelete = OrderDelete(OrderTicket());
      }
      
      int MessageError = GetLastError();
      if(MessageError > 0) {
         //Print("Unanticipated error " + IntegerToString(MessageError));
      }
      
      Sleep(100);      
      RefreshRates();
      
   }
}

//Signal
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
