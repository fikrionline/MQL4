//+------------------------------------------------------------------+
//|                                                    totb_v2.0.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "2.0"

extern double EquityMinStopEA = 0;
extern double EquityMaxStopEA = 0;
extern int MagicNumber = 5758;
extern double MaxRiskPerTradePercent = 1;
extern double Lots = 0.3;
extern double StopLoss = 0;
extern double TakeProfit = 0;
extern double PlusMinusTPSL = 10;
extern int SlipPage = 5;
extern int CounterShift = 5;
extern int StartHour = 13;
extern double MinBoxSize = 200;
extern double MaxBoxSize = 600;

datetime NextCandle;
int counter, TicketBuy, TicketSell;
double PeriodHighest, PeriodLowest, PriceBuy, SLBuy, TPBuy, PriceSell, SLSell, TPSell;

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
int start() {

   MinRemoveExpertNow(EquityMinStopEA);
   MaxRemoveExpertNow(EquityMaxStopEA);

   if(PosSelect(MagicNumber) == 1) {
      DeletePendingOrderSell(MagicNumber);
   }
   
   if(PosSelect(MagicNumber) == -1) {
      DeletePendingOrderBuy(MagicNumber);
   }

   if (NextCandle <= Time[0]) {
      NextCandle = Time[0] + Period();
      // New candle, your trading functions here
      
      //if (PosSelect(MagicNumber) == 0) {

         if(Hour() >= StartHour && Hour() < (StartHour + 1)) {
         
            DeletePendingOrderBuy(MagicNumber);
            DeletePendingOrderSell(MagicNumber);
            
            for(counter = 1; counter <= CounterShift; counter ++) {
               PeriodHighest = iHigh(Symbol(), PERIOD_CURRENT, iHighest(Symbol(), PERIOD_CURRENT, MODE_HIGH, CounterShift, 1)); //Print(PeriodHighest);
               PeriodLowest = iLow(Symbol(), PERIOD_CURRENT, iLowest(Symbol(), PERIOD_CURRENT, MODE_HIGH, CounterShift, 1)); //Print(PeriodLowest);
            }
            
            if(((PeriodHighest - PeriodLowest) / Point) > MinBoxSize && ((PeriodHighest - PeriodLowest) / Point) < MaxBoxSize) {
            
               PriceBuy = PeriodHighest;
               PriceSell = PeriodLowest;
               
               if(StopLoss == 0) {
                  SLBuy = PeriodLowest + (PlusMinusTPSL * Point);
                  SLSell = PeriodHighest - (PlusMinusTPSL * Point);
               }
               
               if(TakeProfit == 0) {         
                  TPBuy = PeriodHighest + (PeriodHighest - PeriodLowest) + (PlusMinusTPSL * Point);
                  TPSell = PeriodLowest - (PeriodHighest - PeriodLowest) - (PlusMinusTPSL * Point);
               }
               
               if(MaxRiskPerTradePercent > 0) {
                  Lots = CalculateLotSize((PeriodHighest - PeriodLowest) / Point, MaxRiskPerTradePercent);
               }
               
               TicketBuy = OrderSend(Symbol(), OP_BUYSTOP, Lots, PriceBuy, SlipPage, SLBuy, TPBuy, IntegerToString(MagicNumber), MagicNumber, 0, clrBlue);
               TicketSell = OrderSend(Symbol(), OP_SELLSTOP, Lots, PriceSell, SlipPage, SLSell, TPSell, IntegerToString(MagicNumber), MagicNumber, 0, clrRed);
            
            }
         
         }
         
      //}

   }

   return (0);

}

//Signal
int GetSignal() {

   int SignalResult = 0;

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

void DeletePendingOrderBuy(int TheMagicNumberBuy) {
   
   int total = OrdersTotal(), TicketOrderSelect, TicketOrderDelete;

   for (int i = total - 1; i >= 0; i--) {
      TicketOrderSelect = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if (OrderMagicNumber() != TheMagicNumberBuy || OrderSymbol() != Symbol()) {
         continue;
      }
      if (OrderMagicNumber() == TheMagicNumberBuy && OrderSymbol() == Symbol() && OrderType() == OP_BUYLIMIT) {
         TicketOrderDelete = OrderDelete(OrderTicket());
      }
      if (OrderMagicNumber() == TheMagicNumberBuy && OrderSymbol() == Symbol() && OrderType() == OP_BUYSTOP) {
         TicketOrderDelete = OrderDelete(OrderTicket());
      }
   }
   
}

void DeletePendingOrderSell(int TheMagicNumberSell) {
   
   int total = OrdersTotal(), TicketOrderSelect, TicketOrderDelete;

   for (int i = total - 1; i >= 0; i--) {
      TicketOrderSelect = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if (OrderMagicNumber() != TheMagicNumberSell || OrderSymbol() != Symbol()) {
         continue;
      }
      if (OrderMagicNumber() == TheMagicNumberSell && OrderSymbol() == Symbol() && OrderType() == OP_SELLLIMIT) {
         TicketOrderDelete = OrderDelete(OrderTicket());
      }
      if (OrderMagicNumber() == TheMagicNumberSell && OrderSymbol() == Symbol() && OrderType() == OP_SELLSTOP) {
         TicketOrderDelete = OrderDelete(OrderTicket());
      }
   }
   
}

double CalculateLotSize(double SL, double MaxRiskPerTrade){ // Calculate the position size.
   double LotSize = 0;
   // We get the value of a tick.
   double nTickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
   // If the digits are 3 or 5, we normalize multiplying by 10.
   if ((Digits == 3) || (Digits == 5)){
      //nTickValue = nTickValue * 10;
   }
   // We apply the formula to calculate the position size and assign the value to the variable.
   LotSize = ((AccountBalance() * MaxRiskPerTrade) / 100) / (SL * nTickValue);
   return LotSize;
}

int MinRemoveExpertNow(double MinimumEquity = 0) {
   
   if(MinimumEquity > 0 && AccountEquity() < MinimumEquity) {
      RemoveAllOrders();
      ExpertRemove();
   }
   return(0);
   
}

int MaxRemoveExpertNow(double MaximumEquity = 0) {
   
   if(MaximumEquity > 0 && AccountEquity() > MaximumEquity) {
      RemoveAllOrders();
      ExpertRemove();
   }
   return(0);
   
}

void RemoveAllOrders() {
   int TicketOrderSelect, TicketOrderClose, TicketOrderDelete;
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
         Print("Unanticipated error " + IntegerToString(MessageError));
      }
      
      Sleep(100);      
      RefreshRates();
      
   }
}
