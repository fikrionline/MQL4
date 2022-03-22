//+------------------------------------------------------------------+
//|                                                    totb_v3.2.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link "https://www.mql5.com"
#property version "1.00"
#property strict
#include <stdlib.mqh>

enum RiskPercentFrom {
   TheStartBalance,
   TheEquity
};
extern double StartBalance = 10000;
extern double EquityMinStopEA = 0;
extern double EquityMaxStopEA = 0;
extern string TimeToOpen = "12:00:07";
extern int TimeToStopAllOrders = 0;
extern int TimeToDeletePendingOrders = 22;
extern int MagicNumber = 5758;
extern bool MultiOrder = true;
extern double Lots = 0.01;
extern double MaxRiskPerTradePercent = 1;
extern RiskPercentFrom MaxRiskPercentFrom = TheStartBalance;
extern bool DoubleLotAfterProfit = true;
extern double StopLoss = 0;
extern double TakeProfit = 0;
extern double PlusMinusTPSL = 10;
extern int SlipPage = 5;
extern double MinBoxSize = 100;
extern double MaxBoxSize = 600;
extern int CounterShift = 5;

MqlDateTime time_to_open;
double EquityMin, EquityMax;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
   TimeToStruct(StringToTime(TimeToOpen), time_to_open);
   return (INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {

}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {

   Info();
   
   if(TimeToStopAllOrders > 0) {
      if(Hour() >= TimeToStopAllOrders) {
         RemoveAllOrders();
      }
   }
   
   if(TimeToDeletePendingOrders > 0) {
      if(Hour() >= TimeToDeletePendingOrders) {
         DeletePendingOrderSell(MagicNumber);
         DeletePendingOrderBuy(MagicNumber);
      }
   }

   MinRemoveExpertNow(EquityMinStopEA);
   MaxRemoveExpertNow(EquityMaxStopEA);

   if(PosSelect(MagicNumber) == 1) {
      DeletePendingOrderSell(MagicNumber);
   }
   
   if(PosSelect(MagicNumber) == -1) {
      DeletePendingOrderBuy(MagicNumber);
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
   
   MqlDateTime time;
   TimeCurrent(time);
   time.hour = time_to_open.hour;
   time.min = time_to_open.min;
   time.sec = time_to_open.sec;
   datetime time_current = TimeCurrent();
   datetime time_trade = StructToTime(time);
   if (time_current >= time_trade && time_current < time_trade + (15 * PeriodSeconds(PERIOD_M1)) && CanTrade()) {
      if (!OpenTrade()) {
         Print(ErrorDescription(GetLastError()));
      }
   }
}

bool CanTrade() {

   datetime last_trade = 0;
   for (int i = OrdersHistoryTotal() - 1; i >= 0; i--) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY) && OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
         if (OrderOpenTime() > last_trade) {
            last_trade = OrderOpenTime();
         }
      }
   }

   if (TimeCurrent() - last_trade < 12 * PeriodSeconds(PERIOD_H1)) {
      return false;
   }

   if(MultiOrder == false) {
      for (int i = OrdersTotal() - 1; i >= 0; i--) {
         if (OrderSelect(i, SELECT_BY_POS) && OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
            return false;
         }
      }
   }

   return true;
   
}

bool OpenTrade() {

   int counter, TicketBuy, TicketSell;
   double PeriodHighest, PeriodLowest, PriceBuy, PriceSell, SLBuy, SLSell, TPBuy, TPSell;

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
         if(MaxRiskPercentFrom == TheStartBalance) {
            Lots = CalculateLotSize((PeriodHighest - PeriodLowest) / Point, MaxRiskPerTradePercent, StartBalance);
         } else if(MaxRiskPercentFrom == TheEquity) {
            Lots = CalculateLotSize((PeriodHighest - PeriodLowest) / Point, MaxRiskPerTradePercent,  AccountEquity());
         }
      }
      
      if(DoubleLotAfterProfit == true) {
         if(MaxRiskPercentFrom == TheStartBalance) {
            if(AccountEquity() - ((TheStartBalance / 100) * MaxRiskPerTradePercent) > StartBalance) {
               if(CheckProfitLastTrade(Symbol(), MagicNumber) == 1) {
                  Lots = Lots * 2;
               }
            }
         } else if(MaxRiskPercentFrom == TheEquity) {
            if(AccountEquity() - ((AccountEquity() / 100) * MaxRiskPerTradePercent) > StartBalance) {
               if(CheckProfitLastTrade(Symbol(), MagicNumber) == 1) {
                  Lots = Lots * 2;
               }
            }
         }
      }
      
      TicketBuy = OrderSend(Symbol(), OP_BUYSTOP, Lots, PriceBuy, SlipPage, SLBuy, TPBuy, IntegerToString(MagicNumber), MagicNumber, 0, clrBlue);
      TicketSell = OrderSend(Symbol(), OP_SELLSTOP, Lots, PriceSell, SlipPage, SLSell, TPSell, IntegerToString(MagicNumber), MagicNumber, 0, clrRed);
   
   }
   
   return true;
   
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

double CalculateLotSize(double SL, double MaxRiskPerTrade, double BalanceOrEquity){ // Calculate the position size.
   double LotSize = 0;
   // We get the value of a tick.
   double nTickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
   // If the digits are 3 or 5, we normalize multiplying by 10.
   if ((Digits == 3) || (Digits == 5)){
      //nTickValue = nTickValue * 10;
   }
   // We apply the formula to calculate the position size and assign the value to the variable.
   LotSize = ((BalanceOrEquity * MaxRiskPerTrade) / 100) / (SL * nTickValue);
   return LotSize;
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

void Info() {

   Comment("",
      "----------------------------------------------------------------",
      "\nBismillahirrohmanirrohim",
      //"\nStartEquityBuySell = ", StartEquityBuySell,
      "\nEquity = ", DoubleToString(AccountEquity(), 2),
      "\nEquity Min = ", DoubleToString(EquityMin, 2) + "",
      "\nEquity Max = ", DoubleToString(EquityMax, 2) + "",
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
      //"\nLot Multiplier = ", LotsMultiplier,
      //"\nMax Lot Buy = ", MaxLotsBuy,
      //"\nMax Lot Sell = ", MaxLotsSell,
      //"\nAverage Daily Range = ", GetADRs(PERIOD_D1, 20, 1),
      //"\nPipStepBuy = ", LastPipStepMultiplierBuy,
      //"\nPipStepSell = ", LastPipStepMultiplierSell,
      //"\nTakeProfit = ", TakeProfit,
      "\n----------------------------------------------------------------"
   );
   
}

int GetTotalOrderBuy(int CheckMagicNumberBuy) {
   int countOrderBuy = 0, TicketOrderSelect;
   double PNLBuyResult;
   for (int i = OrdersTotal() - 1; i >= 0; i--) {
      TicketOrderSelect = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != CheckMagicNumberBuy) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == CheckMagicNumberBuy && OrderType() == OP_BUY) {         
         countOrderBuy++;
         PNLBuyResult = PNLBuyResult + OrderProfit() + OrderCommission() + OrderSwap();
      }      
   }
   
   return (countOrderBuy);
}

int GetTotalOrderSell(int CheckMagicNumberSell) {
   int countOrderSell = 0, TicketOrderSelect;
   double PNLSellResult;
   for (int i = OrdersTotal() - 1; i >= 0; i--) {
      TicketOrderSelect = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != CheckMagicNumberSell) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == CheckMagicNumberSell && OrderType() == OP_SELL) {         
         countOrderSell++;
         PNLSellResult = PNLSellResult + OrderProfit() + OrderCommission() + OrderSwap();
      }      
   }
   
   return (countOrderSell);
}

//Check Profit Last Trade
int CheckProfitLastTrade(string CheckPair, int CheckMagicNumber) {

   int ProfitLoss = 0, TicketOrderSelect;

   for (int i = OrdersHistoryTotal() - 1; i >= 0; i--) {
   
      TicketOrderSelect = OrderSelect(i, SELECT_BY_POS, MODE_HISTORY);

      if (OrderSymbol() != CheckPair && OrderMagicNumber() != CheckMagicNumber) {
         continue;
      }
      
      if (OrderSymbol() == CheckPair && OrderMagicNumber() == CheckMagicNumber) {
         
         //for Pending Order
         if(OrderProfit() == 0) {
            continue;
         }
         
         //for Buy
         if(OrderProfit() > 0) {
            ProfitLoss = 1;
         }
         if(OrderProfit() < 0) {
            ProfitLoss = -1;
         }         
         break;
         
      }

   }

   return (ProfitLoss);

}
