//+------------------------------------------------------------------+
//|                                              SuperTrend_v1.0.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

extern double EquityMinStopEA = 9600.00;
extern double EquityMaxStopEA = 10880.00;
extern int StartHour = 0;
extern int EndHour = 25;
extern double StartingLots = 0.1;
extern double AdditionalLots = 0.1;
extern double TakeProfitDevideADR = 9;
extern double TakeProfitPlus = 0;
extern double SlipPage = 5.0;
extern double BEPHunterProfit = 1;

datetime NextCandle;
int TicketOrderSend, TicketOrderSelect, TicketOrderClose, TicketOrderDelete, TicketOrderModify, TotalOrderBuy, TotalOrderSell, MagicNumberBuy, MagicNumberSell,  NewSignal;
double LastPriceOrderBuy, LastPriceOrderSell, iLotsBuy, iLotsSell, LastLotsBuy, LastLotsSell, MaxLotsBuy, MaxLotsSell, ADRs, TakeProfit, TPBuy, TPSell, StartEquityBuySell, PNL, PNLMax, PNLMin, PNLBuy, PNLBuyMax, PNLBuyMin, PNLSell, PNLSellMax, PNLSellMin, EquityMin, EquityMax;
bool AlreadyRemoveTPBuySell = FALSE;

int init() {
   
   NextCandle = Time[0] + Period();
   return (0);
   
}

int deinit() {
   
   //Comment("");
   return (0);
   
}

void OnTick() {
   
   MinRemoveExpertNow(EquityMinStopEA);
   MaxRemoveExpertNow(EquityMaxStopEA);
   
   TakeProfit = NormalizeDouble((GetADRs(PERIOD_D1, 20, 1) / TakeProfitDevideADR) + TakeProfitPlus, 0);
   
   MagicNumberBuy = GetMagicNumber("BUY");
   
   MagicNumberSell = GetMagicNumber("SELL");

   if (NextCandle <= Time[0]) {
      NextCandle = Time[0] + Period();
      // New candle, your trading functions here
      
      NewSignal = GetSignal();
      
      TotalOrderBuy = GetTotalOrderBuy(MagicNumberBuy);
      
      if(TotalOrderBuy < 1) {
         AlreadyRemoveTPBuySell = FALSE;
         iLotsBuy = StartingLots;      
         if((Hour() >= StartHour || Hour() < EndHour)) {
            
            if(TotalOrderSell < 1) {
               TPBuy = NormalizeDouble(MarketInfo(Symbol(), MODE_ASK) + (double) TakeProfit * Point, Digits);
            } else {
               TPBuy = 0;
               iLotsBuy = NormalizeDouble((iLotsBuy + AdditionalLots), 2);
            }
            
            RefreshRates();
            if(NewSignal == 1) {
               TicketOrderSend = OrderSend(Symbol(), OP_BUY, iLotsBuy, MarketInfo(Symbol(), MODE_ASK), SlipPage, 0, TPBuy, Symbol(), MagicNumberBuy, 0, Lime); 
               if (TicketOrderSend < 0) {
                  Print("Error: ", GetLastError());
               }
               LastLotsBuy = iLotsBuy;
               LastPriceOrderBuy = MarketInfo(Symbol(), MODE_ASK);
            }
         }
      }
      
      if(iLotsBuy > MaxLotsBuy) {
         MaxLotsBuy = iLotsBuy;
      }
      
      TotalOrderSell = GetTotalOrderSell(MagicNumberSell);
      
      if(TotalOrderSell < 1) {
         AlreadyRemoveTPBuySell = FALSE;
         iLotsSell = StartingLots;
         if((Hour() >= StartHour || Hour() <= EndHour)) {
            
            if(TotalOrderBuy < 1) {
               TPSell = NormalizeDouble(Bid - (double) TakeProfit * Point, Digits);
            } else {
               TPSell = 0;
               iLotsSell = NormalizeDouble((iLotsSell + AdditionalLots), 2);               
            }
            
            RefreshRates();
            if(NewSignal == -1) {
               TicketOrderSend = OrderSend(Symbol(), OP_SELL, iLotsSell, MarketInfo(Symbol(), MODE_BID), SlipPage, 0, TPSell, Symbol(), MagicNumberSell, 0, Lime); 
               if (TicketOrderSend < 0) {
                  Print("Error: ", GetLastError());
               }
               LastLotsSell = iLotsSell;
               LastPriceOrderSell = MarketInfo(Symbol(), MODE_BID);
            }
         }
      }
      
      if(iLotsSell > MaxLotsSell) {
         MaxLotsSell = iLotsSell;
      }
      
   }
   
   TotalOrderBuy = GetTotalOrderBuy(MagicNumberBuy);
   
   TotalOrderSell = GetTotalOrderSell(MagicNumberSell);
   
   PNL = PNLBuy + PNLSell;
   
   if(PNL > 0) {
      if(PNL > PNLMax) {
         PNLMax = PNL;
      }
   }
   
   if(PNL < 0) {
      if(PNL < PNLMin) {
         PNLMin = PNL;
      }
   }
   
   if(TotalOrderBuy > 0 && TotalOrderSell > 0) {
   
      if(AlreadyRemoveTPBuySell == FALSE) {
         if(LastLotsSell > LastLotsBuy) {
            RemoveTPBuy(MagicNumberBuy);
         }
         if(LastLotsBuy > LastLotsSell) {
            RemoveTPSell(MagicNumberSell);
         }
         AlreadyRemoveTPBuySell = TRUE;
      }
      
      if(PNL > BEPHunterProfit) {
         
         CloseOrderBuy(MagicNumberBuy);
         TotalOrderBuy = 0;
         LastLotsBuy = 0;
         LastPriceOrderBuy = 0;
         
         CloseOrderSell(MagicNumberSell);
         TotalOrderSell = 0;
         LastLotsSell = 0;
         LastPriceOrderSell = 0;
         
      }
      
   }
   
   if(LastLotsSell > LastLotsBuy) {
      if(Bid > LastPriceOrderBuy) {
         NewSignal = GetSignal();
         if(NewSignal == 1) {
            iLotsBuy = LastLotsSell + AdditionalLots;
            TicketOrderSend = OrderSend(Symbol(), OP_BUY, iLotsBuy, MarketInfo(Symbol(), MODE_ASK), SlipPage, 0, 0, Symbol(), MagicNumberBuy, 0, Lime); 
            if (TicketOrderSend < 0) {
               Print("Error: ", GetLastError());
            }
            LastLotsBuy = iLotsBuy;
            LastPriceOrderBuy = MarketInfo(Symbol(), MODE_ASK); 
         }
      }
   }
   
   if(LastLotsBuy > LastLotsSell) {
      if(Ask < LastPriceOrderSell) {
         NewSignal = GetSignal();
         if(NewSignal == -1) {
            iLotsSell = LastLotsBuy + AdditionalLots;
            TicketOrderSend = OrderSend(Symbol(), OP_SELL, iLotsSell, MarketInfo(Symbol(), MODE_BID), SlipPage, 0, 0, Symbol(), MagicNumberSell, 0, Lime); 
            if (TicketOrderSend < 0) {
               Print("Error: ", GetLastError());
            }
            LastLotsSell = iLotsSell;
            LastPriceOrderSell = MarketInfo(Symbol(), MODE_BID);
         }
      }
   }
   
   if(TotalOrderBuy == 0 && TotalOrderSell == 0) {
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
   
}

int GetTotalOrderBuy(int CheckMagicNumberBuy) {
   int countOrderBuy = 0;
   double PNLBuyResult;
   for (int i = OrdersTotal() - 1; i >= 0; i--) {
      TicketOrderSelect = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != CheckMagicNumberBuy) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == CheckMagicNumberBuy && OrderType() == OP_BUY) {         
         countOrderBuy++;
         PNLBuyResult = PNLBuyResult + OrderProfit() + OrderCommission() + OrderSwap();
      }      
   }
   
   PNLBuy = PNLBuyResult;
   
   if(PNLBuy > 0) {
      if(PNLBuyMax < PNLBuy) {
         PNLBuyMax = PNLBuy;
      }
   }
   if(PNLBuy < 0) {
      if(PNLBuyMin > PNLBuy) {
         PNLBuyMin = PNLBuy;
      }
   }
   
   return (countOrderBuy);
}

int GetTotalOrderSell(int CheckMagicNumberSell) {
   int countOrderSell = 0;
   double PNLSellResult;
   for (int i = OrdersTotal() - 1; i >= 0; i--) {
      TicketOrderSelect = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != CheckMagicNumberSell) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == CheckMagicNumberSell && OrderType() == OP_SELL) {         
         countOrderSell++;
         PNLSellResult = PNLSellResult + OrderProfit() + OrderCommission() + OrderSwap();
      }      
   }
   
   PNLSell = PNLSellResult;
   
   if(PNLSell > 0) {
      if(PNLSellMax < PNLSell) {
         PNLSellMax = PNLSell;
      }
   }
   if(PNLBuy < 0) {
      if(PNLSellMin > PNLSell) {
         PNLSellMin = PNLSell;
      }
   }
   
   return (countOrderSell);
}

int CloseOrderBuy(int CheckMagicNumberBuy) {
   for (int i = OrdersTotal() - 1; i >= 0; i--) {
      TicketOrderSelect = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != CheckMagicNumberBuy) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == CheckMagicNumberBuy && OrderType() == OP_BUY) {
         TicketOrderClose = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, clrNONE);        
      }      
   }   
   return (0);
}

int CloseOrderSell(int CheckMagicNumberSell) {
   for (int i = OrdersTotal() - 1; i >= 0; i--) {
      TicketOrderSelect = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != CheckMagicNumberSell) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == CheckMagicNumberSell && OrderType() == OP_SELL) {         
         TicketOrderClose = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, clrNONE);
      }      
   }   
   return (0);
}

int RemoveTPBuy(int CheckMagicNumberBuy) {
   for (int i = OrdersTotal() - 1; i >= 0; i--) {
      TicketOrderSelect = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != CheckMagicNumberBuy) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == CheckMagicNumberBuy && OrderType() == OP_BUY) {
         TicketOrderModify = OrderModify(OrderTicket(), OrderOpenPrice(), 0, 0, 0, Yellow);
      }      
   }   
   return (0);
}

int RemoveTPSell(int CheckMagicNumberSell) {
   for (int i = OrdersTotal() - 1; i >= 0; i--) {
      TicketOrderSelect = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != CheckMagicNumberSell) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == CheckMagicNumberSell && OrderType() == OP_SELL) {         
         TicketOrderModify = OrderModify(OrderTicket(), OrderOpenPrice(), 0, 0, 0, Yellow);
      }      
   }   
   return (0);
}

void Info() {

   Comment("",
      "Martingale EA",
      "\nStartEquityBuySell = ", StartEquityBuySell,
      "\nEquity = ", DoubleToString(AccountEquity(), 2),
      "\nEquity Min = ", DoubleToString(EquityMin, 2) + " (" + DoubleToString((EquityMin - StartEquityBuySell), 2) + ")",
      "\nEquity Max = ", DoubleToString(EquityMax, 2) + " (+" + DoubleToString((EquityMax - StartEquityBuySell), 2) + ")",
      "\nPnL = ", DoubleToString(PNL, 2),
      "\nPnL Min = ", DoubleToString(PNLMin, 2),
      "\nPnL Max = ", DoubleToString(PNLMax, 2),
      "\nPnL Buy = ", DoubleToString(PNLBuy, 2),
      "\nPnL Buy Min = ", DoubleToString(PNLBuyMin, 2),
      "\nPnL Buy Max = ", DoubleToString(PNLBuyMax, 2),
      "\nPnL Sell = ", DoubleToString(PNLSell, 2),
      "\nPnL Sell Min = ", DoubleToString(PNLSellMin, 2),
      "\nPnL Sell Max = ", DoubleToString(PNLSellMax, 2),
      "\nStarting Lot = ", StartingLots,
      "\nLast Lot Buy = ", LastLotsBuy,
      "\nLast Lot Sell = ", LastLotsSell,
      "\nMax Lot Buy = ", MaxLotsBuy,
      "\nMax Lot Sell = ", MaxLotsSell,
      "\nLast Price Order Buy = ", DoubleToString(LastPriceOrderBuy, Digits),
      "\nLast Price Order Sell = ", DoubleToString(LastPriceOrderSell, Digits),
      "\nAverage Daily Range = ", GetADRs(PERIOD_D1, 20, 1),
      "\nTakeProfit = ", TakeProfit
   );
   
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

double GetADRs(int ATR_TimeFrame = PERIOD_D1, int ATR_Counter = 20, int ATR_Shift = 1) {

   double ATR_PipStep;
   ATR_PipStep = iATR(Symbol(), ATR_TimeFrame, ATR_Counter, ATR_Shift);
   ATR_PipStep = MathRound(ATR_PipStep / _Point);
   return ATR_PipStep;
   
}

int GetMagicNumber(string TheOrderType = "BUYSELL") {
   
   int MagicNumberResult = 987654321;
   string MagicNumberString;
   string StringSymbol[29];
   StringSymbol[0] = "AUDCAD";
   StringSymbol[1] = "AUDCHF";
   StringSymbol[2] = "AUDJPY";
   StringSymbol[3] = "AUDNZD";
   StringSymbol[4] = "AUDUSD";
   StringSymbol[5] = "CADCHF";
   StringSymbol[6] = "CADJPY";
   StringSymbol[7] = "CHFJPY";
   StringSymbol[8] = "EURAUD";
   StringSymbol[9] = "EURCAD";
   StringSymbol[10] = "EURCHF";
   StringSymbol[11] = "EURGBP";
   StringSymbol[12] = "EURJPY";
   StringSymbol[13] = "EURNZD";
   StringSymbol[14] = "EURUSD";
   StringSymbol[15] = "GBPAUD";
   StringSymbol[16] = "GBPCAD";
   StringSymbol[17] = "GBPCHF";
   StringSymbol[18] = "GBPJPY";
   StringSymbol[19] = "GBPNZD";
   StringSymbol[20] = "GBPUSD";
   StringSymbol[21] = "NZDCAD";
   StringSymbol[22] = "NZDCHF";
   StringSymbol[23] = "NZDJPY";
   StringSymbol[24] = "NZDUSD";
   StringSymbol[25] = "USDCAD";
   StringSymbol[26] = "USDCHF";
   StringSymbol[27] = "USDJPY";
   StringSymbol[28] = "XAUUSD";
   
   for(int i=0; i<29; i++) {
      if(StringSymbol[i] == Symbol()) {
         MagicNumberString = MagicNumberString + IntegerToString(i + 1);
      }
   }
   
   if(TheOrderType == "BUY") {
      MagicNumberString = MagicNumberString + "1";
      MagicNumberResult = StringToInteger(MagicNumberString);
   } else if(TheOrderType == "SELL") {
      MagicNumberString = MagicNumberString + "2";
      MagicNumberResult = StringToInteger(MagicNumberString);
   } else if(TheOrderType == "BUYSELL") {
      MagicNumberString = MagicNumberString + "3";
      MagicNumberResult = StringToInteger(MagicNumberString);
   } else {
      MagicNumberResult = MagicNumberResult;
   }
   
   return MagicNumberResult;
   
}

int GetSignal() {

   int SignalResult = 0;
   
   if(iCustom(Symbol(), PERIOD_CURRENT, "SuperTrend2", 10, 3.3, 0, 1) != EMPTY_VALUE) {
      //if(iCustom(Symbol(), PERIOD_M1, "SuperTrend2", 10, 3.3, 0, 1) != EMPTY_VALUE) {
         SignalResult = 1;
      //}
   }
   
   if(iCustom(Symbol(), PERIOD_CURRENT, "SuperTrend2", 10, 3.3, 1, 1) != EMPTY_VALUE) {
      //if(iCustom(Symbol(), PERIOD_M1, "SuperTrend2", 10, 3.3, 1, 1) != EMPTY_VALUE) {
         SignalResult = -1;
      //}
   }
   
   return SignalResult;

}
