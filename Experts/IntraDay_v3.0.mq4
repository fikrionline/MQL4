//+------------------------------------------------------------------+
//|                                                IntraDay_v3.0.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "3.00"
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
extern bool ReverseOrder = false;
extern int StartHour = 3;
extern int EndHour = 17;
extern int MagicNumber = 5758;
extern double Lots = 0;
extern double MinLots = 0.01;
extern double MaxLots = 3;
extern double StartBalance = 10000;
extern double MaxRiskPerTradePercent = 0.5;
extern RiskPercentFrom MaxRiskPercentFrom = TheStartBalance;
extern double SLPlusMinus = 0;
extern double TPPlusMinus = 0;
extern bool DoubleLotAfterProfit = false;
extern bool RiskAllProfitAfterProfit = false;
extern double RiskAllProfitAfterProfitFromStartBalance = 400;
extern int SlipPage = 5;
extern TheRiskReward RiskReward = RRTwo;
extern int TimeToStopAllOrders = 0;
extern bool UseTrailStopPoint = false;
extern double TrailingStopPoint = 2000;
extern double TrailingStopPointLock = 1000;
extern double EquityMinStopEA = 0;
extern double EquityMaxStopEA = 0;

datetime NextCandle;
double EquityMin, EquityMax, BalanceToRisk;
int NewSignal;

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

   int TicketBuy, TicketSell, TheLastClosedOrder;
   double StopLoss, TakeProfit, ZoneHighest, ZoneLowest, ZoneOCTotal, ZoneHLTotal, ZoneBarStart, ZoneBarEnd;

   Info();
   
   if(UseTrailStopPoint == true) {
      RunTrailStop(MagicNumber, TrailingStopPoint, TrailingStopPointLock);
   }
   
   if(TimeToStopAllOrders > 0) {
      if(Hour() >= TimeToStopAllOrders) {
         RemoveAllOrders();
      }
   }
   
   MinRemoveExpertNow(EquityMinStopEA);
   MaxRemoveExpertNow(EquityMaxStopEA);
   
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
   
   if (NextCandle <= Time[0]) {
      NextCandle = Time[0] + Period();
      // New candle, your trading functions here
      
      if(Hour() >= StartHour && Hour() < EndHour) {
      
         ZoneHighest = iCustom(Symbol(), PERIOD_CURRENT, "SidewaysDetector", 1, 0);
         ZoneLowest = iCustom(Symbol(), PERIOD_CURRENT, "SidewaysDetector", 2, 0);
         ZoneOCTotal = iCustom(Symbol(), PERIOD_CURRENT, "SidewaysDetector", 3, 0);
         ZoneHLTotal = iCustom(Symbol(), PERIOD_CURRENT, "SidewaysDetector", 4, 0);
         ZoneBarStart = iCustom(Symbol(), PERIOD_CURRENT, "SidewaysDetector", 5, 0);
         ZoneBarEnd = iCustom(Symbol(), PERIOD_CURRENT, "SidewaysDetector", 6, 0);
         
         NewSignal = 0;
         
         if(ReverseOrder == false) {
            if(ZoneOCTotal > 0) {
               NewSignal = 1;
            } else if(ZoneOCTotal < 0) {
               NewSignal = -1;
            }
         }
         
         if(ReverseOrder == true) {
            if(ZoneOCTotal > 0) {
               NewSignal = -1;
            } else if(ZoneOCTotal < 0) {
               NewSignal = 1;
            }
         }

         //Order when there are no order
         if (ZoneBarEnd == 0 && (ZoneBarStart - ZoneBarEnd) >= 4) {
         
            if(NewSignal == 1 && PosSelect(MagicNumber) == 0) {
               
               StopLoss = ZoneLowest + (SLPlusMinus * Point);
               
               if(RiskReward == RRZeroPointFive) {
                  TakeProfit = ZoneHighest + ((ZoneHighest - ZoneLowest) / 2) + (TPPlusMinus * Point);
               } else if(RiskReward == RROne) {
                  TakeProfit = ZoneHighest + (ZoneHighest - ZoneLowest) + (TPPlusMinus * Point);
               } else if(RiskReward == RRTwo) {
                  TakeProfit = ZoneHighest + ((ZoneHighest - ZoneLowest) * 2) + (TPPlusMinus * Point);
               } else if(RiskReward == RRThree) {
                  TakeProfit = ZoneHighest + ((ZoneHighest - ZoneLowest) * 3) + (TPPlusMinus * Point);
               } else { //Other is 1:1
                  TakeProfit = ZoneHighest + (ZoneHighest - ZoneLowest) + (TPPlusMinus * Point);
               }
               
               if(MaxRiskPerTradePercent > 0) {
                  if(MaxRiskPercentFrom == TheStartBalance) {
                     Lots = CalculateLotSize((Ask - StopLoss) / Point, MaxRiskPerTradePercent, StartBalance);
                  } else if(MaxRiskPercentFrom == TheEquity) {
                     Lots = CalculateLotSize((Ask - StopLoss) / Point, MaxRiskPerTradePercent,  AccountEquity());
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
                        Lots = CalculateLotSize((Ask - StopLoss) / Point, (BalanceToRisk / AccountBalance()) * 100,  AccountBalance());
                     }
                     
                     if(RiskAllProfitAfterProfitFromStartBalance > 0) {
                        if(BalanceToRisk > RiskAllProfitAfterProfitFromStartBalance) {
                           Lots = CalculateLotSize((Ask - StopLoss) / Point, (RiskAllProfitAfterProfitFromStartBalance / StartBalance) * 100,  StartBalance);
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
               
               TheLastClosedOrder = LastClosedOrder(MagicNumber);
               if(TheLastClosedOrder == 0 || TheLastClosedOrder == -1) {
                  TicketBuy = OrderSend(Symbol(), OP_BUY, Lots, Ask, SlipPage, StopLoss, TakeProfit, "Alhamdulillah", MagicNumber, 0, clrBlue);
               }
               
            } else if(NewSignal == -1 && PosSelect(MagicNumber) == 0) {
            
               StopLoss = ZoneHighest - (SLPlusMinus * Point);
               
               if(RiskReward == RRZeroPointFive) {
                  TakeProfit = ZoneLowest - ((ZoneHighest - ZoneLowest) / 2) - (TPPlusMinus * Point);
               } else if(RiskReward == RROne) {
                  TakeProfit = ZoneLowest - (ZoneHighest - ZoneLowest) - (TPPlusMinus * Point);
               } else if(RiskReward == RRTwo) {
                  TakeProfit = ZoneLowest - ((ZoneHighest - ZoneLowest) * 2) - (TPPlusMinus * Point);
               } else if(RiskReward == RRThree) {
                  TakeProfit = ZoneLowest - ((ZoneHighest - ZoneLowest) * 3) - (TPPlusMinus * Point);
               } else { //Other is 1:1
                  TakeProfit = ZoneLowest - (ZoneHighest - ZoneLowest) - (TPPlusMinus * Point);
               }
               
               if(MaxRiskPerTradePercent > 0) {
                  if(MaxRiskPercentFrom == TheStartBalance) {
                     Lots = CalculateLotSize((StopLoss - Bid) / Point, MaxRiskPerTradePercent, StartBalance);
                  } else if(MaxRiskPercentFrom == TheEquity) {
                     Lots = CalculateLotSize((StopLoss - Bid) / Point, MaxRiskPerTradePercent,  AccountEquity());
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
                        Lots = CalculateLotSize((StopLoss - Bid) / Point, (BalanceToRisk / AccountBalance()) * 100,  AccountBalance());
                     }
                     
                     if(RiskAllProfitAfterProfitFromStartBalance > 0) {
                        if(BalanceToRisk > RiskAllProfitAfterProfitFromStartBalance) {
                           Lots = CalculateLotSize((StopLoss - Bid) / Point, (RiskAllProfitAfterProfitFromStartBalance / StartBalance) * 100,  StartBalance);
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
               
               TheLastClosedOrder = LastClosedOrder(MagicNumber);
               if(TheLastClosedOrder == 0 || TheLastClosedOrder == 1) {
                  TicketSell = OrderSend(Symbol(), OP_SELL, Lots, Bid, SlipPage, StopLoss, TakeProfit, "Alhamdulillah", MagicNumber, 0, clrRed);
               }
            
            }
   
         }
         
      }

   }

}

//Signal
int GetSignal() {

   int SignalResult = 0, SignalFollowLineStart = 0;  

   return SignalResult;

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

int CloseOrderBuy(int CheckMagicNumber) {
   int cnt, TicketOrderSelect, TicketOrderClose;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      TicketOrderSelect = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != CheckMagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == CheckMagicNumber && OrderType() == OP_BUY) {
         TicketOrderClose = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), SlipPage, clrNONE);        
      }      
   }   
   return (0);
}

int CloseOrderSell(int CheckMagicNumber) {
   int cnt, TicketOrderSelect, TicketOrderClose;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      TicketOrderSelect = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != CheckMagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == CheckMagicNumber && OrderType() == OP_SELL) {         
         TicketOrderClose = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), SlipPage, clrNONE);
      }      
   }   
   return (0);
}

int LastClosedOrder(int CheckMagicNumber) {
   int LastOrderType = 0, SelectOrder;
   for (int i = OrdersHistoryTotal() - 1; i >= 0; i--) {
      SelectOrder = OrderSelect(i, SELECT_BY_POS, MODE_HISTORY); //error was here
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == CheckMagicNumber) {
         if (OrderType() == OP_BUY) {
            LastOrderType = 1;
            return LastOrderType;
         } else if (OrderType() == OP_SELL) {
            LastOrderType = -1;
            return LastOrderType;
         }
      }
   }
   return LastOrderType;
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
                  TicketTrail = OrderModify(OrderTicket(), OrderOpenPrice(), Bid - TheTrailingStopPoint * MarketInfo(OrderSymbol(), MODE_POINT), OrderTakeProfit(), clrBlue);
               }
            }
         } else if (OrderType() == OP_SELL && OrderMagicNumber() == CheckMagicNumber) {
            if (OrderOpenPrice() - Ask > TheTrailingStopPoint * MarketInfo(OrderSymbol(), MODE_POINT)) {
               if ((OrderStopLoss() > Ask + TheTrailingStopPoint * MarketInfo(OrderSymbol(), MODE_POINT)) || (OrderStopLoss() == 0)) {
                  TicketTrail = OrderModify(OrderTicket(), OrderOpenPrice(), Ask + TheTrailingStopPoint * MarketInfo(OrderSymbol(), MODE_POINT), OrderTakeProfit(), clrRed);
               }
            }
         }
      }
   }
}

int BalanceEquitySLTP(int CheckMagicNumber, double TheBalance, double TheSL, double TheTP) {
   int cnt, TicketOrderSelect, TicketOrderClose;
   double TheAccountEquity;
   TheAccountEquity = AccountEquity();
   if(TheAccountEquity < (TheBalance - TheSL) || TheAccountEquity > (TheBalance + TheTP)) {
      for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
         TicketOrderSelect = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != CheckMagicNumber) continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == CheckMagicNumber && OrderType() == OP_BUY) {
            TicketOrderClose = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), SlipPage, clrNONE);        
         }
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == CheckMagicNumber && OrderType() == OP_SELL) {         
            TicketOrderClose = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), SlipPage, clrNONE);
         }
      }
   }
   return true;
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
