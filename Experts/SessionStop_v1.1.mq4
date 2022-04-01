//+------------------------------------------------------------------+
//|                                             SessionStop_v1.1.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <stdlib.mqh>

enum RiskPercentFrom {
   TheStartBalance,
   TheEquity
};
enum TheRiskReward {
   RRZeroPointFive, //1:0.5
   RROne, //1:1
   RRTwo, //1:2
   RRThree //1:3
};
extern int OpenHour = 10;
extern int OpenMinute = 1;
extern ENUM_TIMEFRAMES ChooseTF = PERIOD_H1;
extern int CounterShift = 7;
extern int TimeToDeletePendingOrders = 18;
extern double MinBoxSize = 100;
extern double MaxBoxSize = 600;
extern int TimeToStopAllOrders = 0;
extern int MagicNumber = 5758;
extern bool MultiOrder = true;
extern double Lots = 0;
extern double MinLots = 0.01;
extern double MaxLots = 3;
extern double StartBalance = 10000;
extern double MaxRiskPerTradePercent = 1;
extern RiskPercentFrom MaxRiskPercentFrom = TheStartBalance;
extern bool DoubleLotAfterProfit = false;
extern bool RiskAllProfitAfterProfit = false;
extern double RiskAllProfitAfterProfitFromStartBalance = 400;
extern double PlusMinusTPSL = 10;
extern int SlipPage = 5;
extern TheRiskReward RiskReward = RROne;
extern double EquityMinStopEA = 0;
extern double EquityMaxStopEA = 0;

double EquityMin, EquityMax, BalanceToRisk;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {

}

//+------------------------------------------------------------------+
//| Expert                                                     |
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
   
   if(Minute() > OpenMinute) {

      if(PosSelect(MagicNumber) == 1) {
         DeletePendingOrderSell(MagicNumber);
      }
      
      if(PosSelect(MagicNumber) == -1) {
         DeletePendingOrderBuy(MagicNumber);
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
   
   BalanceToRisk = 0;
   
   if(CanTradeNow(MagicNumber)) {

      if(Hour() == OpenHour && Minute() == OpenMinute) {
      
         int counter, TicketBuy, TicketSell, OrderBuySell = 0;
         double PeriodHighest, PeriodLowest, PriceBuyStop, PriceSellStop, SLBuy, SLSell, TPBuy, TPSell, OCbullish = 0, OCbearish = 0, OCtotal = 0, HLbullish = 0, HLbearish = 0, HLtotal = 0;
         
         for(counter = 1; counter <= CounterShift; counter ++) {
            
            if(iOpen(Symbol(), ChooseTF, counter) < iClose(Symbol(), ChooseTF, counter)) {
               OCbullish = OCbullish + (iClose(Symbol(), ChooseTF, counter) - iOpen(Symbol(), ChooseTF, counter));
               HLbullish = HLbullish + (iHigh(Symbol(), ChooseTF, counter) - iLow(Symbol(), ChooseTF, counter));
            } else if(iOpen(Symbol(), ChooseTF, counter) > iClose(Symbol(), ChooseTF, counter)) {
               OCbearish = OCbearish + (iOpen(Symbol(), ChooseTF, counter) - iClose(Symbol(), ChooseTF, counter));
               HLbearish = HLbearish + (iHigh(Symbol(), ChooseTF, counter) - iLow(Symbol(), ChooseTF, counter));
            }
            
         }
         
         OCtotal = (OCbullish - OCbearish) / Point;
         HLtotal = (HLbullish - HLbearish) / Point;
         
         if(OCtotal > 0 && HLtotal > 0) {
            OrderBuySell = -1;
         } else if(OCtotal < 0 && HLtotal < 0) {
            OrderBuySell = 1;
         } else {
            OrderBuySell = 0;
         }
         
         PeriodHighest = iHigh(Symbol(), ChooseTF, iHighest(Symbol(), ChooseTF, MODE_HIGH, CounterShift, 1)); //Print(PeriodHighest);
         PeriodLowest = iLow(Symbol(), ChooseTF, iLowest(Symbol(), ChooseTF, MODE_HIGH, CounterShift, 1)); //Print(PeriodLowest);
         
         if(((PeriodHighest - PeriodLowest) / Point) > MinBoxSize && ((PeriodHighest - PeriodLowest) / Point) < MaxBoxSize) {
                  
            PriceBuyStop = PeriodHighest;
            PriceSellStop = PeriodLowest;
            
            SLBuy = PeriodLowest + (PlusMinusTPSL * Point);
            SLSell = PeriodHighest - (PlusMinusTPSL * Point);
            
            if(RiskReward == RRZeroPointFive) {
               TPBuy = PeriodHighest + ((PeriodHighest - PeriodLowest) / 2) + (PlusMinusTPSL * Point);
               TPSell = PeriodLowest - ((PeriodHighest - PeriodLowest) / 2) - (PlusMinusTPSL * Point);
            } else if(RiskReward == RROne) {
               TPBuy = PeriodHighest + (PeriodHighest - PeriodLowest) + (PlusMinusTPSL * Point);
               TPSell = PeriodLowest - (PeriodHighest - PeriodLowest) - (PlusMinusTPSL * Point);
            } else if(RiskReward == RRTwo) {
               TPBuy = PeriodHighest + ((PeriodHighest - PeriodLowest) * 2) + (PlusMinusTPSL * Point);
               TPSell = PeriodLowest - ((PeriodHighest - PeriodLowest) * 2) - (PlusMinusTPSL * Point);
            } else if(RiskReward == RRThree) {
               TPBuy = PeriodHighest + ((PeriodHighest - PeriodLowest) * 3) + (PlusMinusTPSL * Point);
               TPSell = PeriodLowest - ((PeriodHighest - PeriodLowest) * 3) - (PlusMinusTPSL * Point);
            } else { //Other is 1:1
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
               
               if(RiskAllProfitAfterProfit == true) {
                  
                  BalanceToRisk = AccountBalance() - StartBalance;
                  if(BalanceToRisk < ((MaxRiskPerTradePercent / 100) * StartBalance)) {
                     Lots = Lots;
                  } else if(BalanceToRisk > ((MaxRiskPerTradePercent / 100) * StartBalance)) {
                     Lots = CalculateLotSize((PeriodHighest - PeriodLowest) / Point, (BalanceToRisk / AccountBalance()) * 100,  AccountBalance());
                  }
                  
                  if(RiskAllProfitAfterProfitFromStartBalance > 0) {
                     if(BalanceToRisk > RiskAllProfitAfterProfitFromStartBalance) {
                        Lots = CalculateLotSize((PeriodHighest - PeriodLowest) / Point, (RiskAllProfitAfterProfitFromStartBalance / StartBalance) * 100,  StartBalance);
                     }
                  }
                  
               }
               
            }
            
            if(Lots < MinLots) {
               Lots = MinLots;
            }
            
            if(Lots > MaxLots) {
               Lots = MaxLots;
            }
            
            if(PosSelectBuyStop(MagicNumber) == 0) {
               TicketBuy = OrderSend(Symbol(), OP_BUYSTOP, Lots, PriceBuyStop, SlipPage, SLBuy, TPBuy, "Bismillahirrohmanirrohim_BUY", MagicNumber, 0, clrBlue);
            }
            
            if(PosSelectSellStop(MagicNumber) == 0) {
               TicketSell = OrderSend(Symbol(), OP_SELLSTOP, Lots, PriceSellStop, SlipPage, SLSell, TPSell, "Bismillahirrohmanirrohim_SELL", MagicNumber, 0, clrRed);
            }
         
         }
      
      }
      
   }

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

bool CanTradeNow(int CheckMagicNumber) {
   
   if(MultiOrder == true) {
      return true;
   }
   
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
   if(MultiOrder == false && posi != 0) {
      return false;
   }
   
   return true;
   
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

int PosSelectBuyStop(int CheckMagicNumber) {
   
   int posi = 0, total = OrdersTotal(), TicketOrderSelect;

   for (int i = total - 1; i >= 0; i--) {
      TicketOrderSelect = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if (OrderMagicNumber() != CheckMagicNumber || OrderSymbol() != Symbol() || OrderType() != OP_BUYSTOP) {
         continue;
      }
      if (OrderMagicNumber() == CheckMagicNumber && OrderSymbol() == Symbol() && OrderType() == OP_BUYSTOP) {
         posi = 1;
      }
   }
   
   return posi;
   
}

int PosSelectSellStop(int CheckMagicNumber) {
   
   int posi = 0, total = OrdersTotal(), TicketOrderSelect;

   for (int i = total - 1; i >= 0; i--) {
      TicketOrderSelect = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if (OrderMagicNumber() != CheckMagicNumber || OrderSymbol() != Symbol() || OrderType() != OP_SELLSTOP) {
         continue;
      }
      if (OrderMagicNumber() == CheckMagicNumber && OrderSymbol() == Symbol() && OrderType() == OP_SELLSTOP) {
         posi = -1;
      }
   }
   
   return posi;
   
}

int PosSelectBuyLimit(int CheckMagicNumber) {
   
   int posi = 0, total = OrdersTotal(), TicketOrderSelect;

   for (int i = total - 1; i >= 0; i--) {
      TicketOrderSelect = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if (OrderMagicNumber() != CheckMagicNumber || OrderSymbol() != Symbol() || OrderType() != OP_BUYLIMIT) {
         continue;
      }
      if (OrderMagicNumber() == CheckMagicNumber && OrderSymbol() == Symbol() && OrderType() == OP_BUYLIMIT) {
         posi = 1;
      }
   }
   
   return posi;
   
}

int PosSelectSellLimit(int CheckMagicNumber) {
   
   int posi = 0, total = OrdersTotal(), TicketOrderSelect;

   for (int i = total - 1; i >= 0; i--) {
      TicketOrderSelect = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if (OrderMagicNumber() != CheckMagicNumber || OrderSymbol() != Symbol() || OrderType() != OP_SELLLIMIT) {
         continue;
      }
      if (OrderMagicNumber() == CheckMagicNumber && OrderSymbol() == Symbol() && OrderType() == OP_SELLLIMIT) {
         posi = -1;
      }
   }
   
   return posi;
   
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
      "\nBalance = ", DoubleToString(AccountBalance(), 2),
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
