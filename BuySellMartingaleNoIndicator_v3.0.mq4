#property copyright "MQL5"
#property link "https://www.mql5.com/en/code"
#property description "Martingale EA"

extern double EquityMinStopEA = 0.00;
extern double EquityMaxStopEA = 0.00;
extern int StartHour = 3;
extern int EndHour = 22;
extern double StartingLots = 0.01;
extern double LotsMultiplier = 1.1;
extern double PipStepDevideADR = 10;
extern double PipStepMultiplier = 1;
extern double TakeProfitDevideADR = 10;
extern double TakeProfitPlus = 17;
extern double SlipPage = 5.0;
extern int MaxTrades = 33;
extern double StopHighPrice = 0;
extern double StopLowPrice = 0;
extern int BEPHunterOnLayer = 33;
extern double BEPHunterProfit = 1;

int TicketOrderSend, TicketOrderSelect, TicketOrderModify, TicketOrderClose, TicketOrderDelete, TotalOrderBuy, TotalOrderSell, LastTicket, LastTicketTemp, NumOfTradesSell, NumOfTradesBuy, MagicNumberBuy, MagicNumberSell, cnt;
double PriceTargetBuy, PriceTargetSell, AveragePriceBuy, AveragePriceSell, LastBuyPrice, LastSellPrice, iLotsBuy, iLotsSell, MaxLotsBuy, MaxLotsSell, ADRs, PipStep, TakeProfit, FirstTPOrderBuy, FirstTPOrderSell, StartEquityBuySell, Count, LastPipStepMultiplierBuy, LastPipStepMultiplierSell, PNL, PNLMax, PNLMin, PNLBuy, PNLBuyMax, PNLBuyMin, PNLSell, PNLSellMax, PNLSellMin, EquityMin, EquityMax;
bool NewOrdersPlacedBuy = FALSE, NewOrdersPlacedSell = FALSE, FirstOrderBuy = FALSE, FirstOrderSell = FALSE;

int init() {
   return (0);
}

int deinit() {
   Comment("");
   return (0);
}

void OnTick() {

   MinRemoveExpertNow(EquityMinStopEA);
   MaxRemoveExpertNow(EquityMaxStopEA);
   
   if(StopHighPrice > 0 && Ask > StopHighPrice) {
      RemoveAllOrders();
      RemoveAllOrders();
      RemoveAllOrders();
      ExpertRemove();
   }
   
   if(StopLowPrice > 0 && Bid < StopLowPrice) {
      RemoveAllOrders();
      RemoveAllOrders();
      RemoveAllOrders();
      ExpertRemove();
   }
   
   PipStep = NormalizeDouble(GetADRs(PERIOD_D1, 20, 1) / PipStepDevideADR, 2);
   
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
   
   //------ Only for BUY -------------------------------------------------------------------------------------------
   MagicNumberBuy = GetMagicNumber("BUY");
   
   TakeProfit = NormalizeDouble((GetADRs(PERIOD_D1, 20, 1) / TakeProfitDevideADR) + TakeProfitPlus, 0); //Print("TakeProfit BUY = " + TakeProfit);
   
   TotalOrderBuy = GetTotalOrderBuy();
   
   if(TotalOrderBuy < 1) {
      NumOfTradesBuy = 0;
      iLotsBuy = NormalizeDouble(StartingLots * MathPow(LotsMultiplier, NumOfTradesBuy), 2);      
      if((Hour() >= StartHour || Hour() < EndHour)) {
         FirstTPOrderBuy = NormalizeDouble(Ask + (double) TakeProfit * Point, Digits);
         RefreshRates();
         TicketOrderSend = OrderSend(Symbol(), OP_BUY, iLotsBuy, Ask, SlipPage, 0, FirstTPOrderBuy, Symbol() + "-" + NumOfTradesBuy, MagicNumberBuy, 0, Lime); Print(Symbol() + "-" + NumOfTradesBuy + "_MN-" + MagicNumberBuy + "_FirstTP");
         if (TicketOrderSend < 0) {
            Print("Error: ", GetLastError());
         }
         //Sleep(999);
         //RefreshRates();
         NewOrdersPlacedBuy = TRUE;
         FirstOrderBuy = TRUE;
         TotalOrderBuy = 1;
         LastPipStepMultiplierBuy = 0;
      }
   }
   
   if(LastPipStepMultiplierBuy <= 0) {
      LastPipStepMultiplierBuy = PipStep;
   }
   
   if (TotalOrderBuy > 0 && TotalOrderBuy < MaxTrades) {
      LastBuyPrice = FindLastBuyPrice();
      if ((LastBuyPrice - Ask) >= (LastPipStepMultiplierBuy * Point)) {
         NumOfTradesBuy = TotalOrderBuy;
         iLotsBuy = NormalizeDouble(StartingLots * MathPow(LotsMultiplier, NumOfTradesBuy), 2);
         RefreshRates();
         TicketOrderSend = OrderSend(Symbol(), OP_BUY, iLotsBuy, Ask, SlipPage, 0, 0, Symbol() + "-" + NumOfTradesBuy, MagicNumberBuy, 0, Lime); Print(Symbol() + "-" + NumOfTradesBuy + "_MN-" + MagicNumberBuy);
         if (TicketOrderSend < 0) {
            Print("Error: ", GetLastError());
         }
         NewOrdersPlacedBuy = TRUE;
         LastPipStepMultiplierBuy = NormalizeDouble((LastPipStepMultiplierBuy * PipStepMultiplier), 2);
      }
   }
   
   if(iLotsBuy > MaxLotsBuy) {
      MaxLotsBuy = iLotsBuy;
   }
   
   if (TotalOrderBuy > 0) {
      AveragePriceBuy = 0;
      Count = 0;
      for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
         TicketOrderSelect = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumberBuy) continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberBuy && OrderType() == OP_BUY) {
            AveragePriceBuy += OrderOpenPrice() * OrderLots();
            Count += OrderLots();
         }
      }
      AveragePriceBuy = NormalizeDouble(AveragePriceBuy / Count, Digits);
   }
   
   if (NewOrdersPlacedBuy == TRUE) {
      for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
         TicketOrderSelect = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumberBuy) continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberBuy && OrderType() == OP_BUY) {
            if(FirstOrderBuy == TRUE) {
               PriceTargetBuy = NormalizeDouble(AveragePriceBuy + (TakeProfit * Point), Digits);
            } else {
               PriceTargetBuy = NormalizeDouble(AveragePriceBuy, Digits);
            }
         }
         TicketOrderModify = OrderModify(OrderTicket(), AveragePriceBuy, 0, PriceTargetBuy, 0, Yellow);
      }
      NewOrdersPlacedBuy = FALSE;
   }
   //----------------------------------------------------------------------------------------------------------------
   
   //------ Only for SELL -------------------------------------------------------------------------------------------
   MagicNumberSell = GetMagicNumber("SELL");
   
   TakeProfit = NormalizeDouble((GetADRs(PERIOD_D1, 20, 1) / TakeProfitDevideADR) + TakeProfitPlus, 0); //Print("TakeProfit SELL = " + TakeProfit);
   
   TotalOrderSell = GetTotalOrderSell();
   
   if(TotalOrderSell < 1) {
      NumOfTradesSell = 0;
      iLotsSell = NormalizeDouble(StartingLots * MathPow(LotsMultiplier, NumOfTradesSell), 2);      
      if((Hour() >= StartHour || Hour() <= EndHour)) {
         FirstTPOrderSell = NormalizeDouble(Bid - (double) TakeProfit * Point, Digits);
         RefreshRates();
         TicketOrderSend = OrderSend(Symbol(), OP_SELL, iLotsSell, Bid, SlipPage, 0, FirstTPOrderSell, Symbol() + "-" + NumOfTradesSell, MagicNumberSell, 0, Lime); Print(Symbol() + "-" + NumOfTradesSell + "_MN-" + MagicNumberSell + "_FirstTP");
         if (TicketOrderSend < 0) {
            Print("Error: ", GetLastError());
         }
         //Sleep(999);
         //RefreshRates();
         NewOrdersPlacedSell = TRUE;
         FirstOrderSell = TRUE;
         TotalOrderSell = 1;
         LastPipStepMultiplierSell = 0;
      }
   }
   
   if(LastPipStepMultiplierSell <= 0) {
      LastPipStepMultiplierSell = PipStep;
   }
   
   if (TotalOrderSell > 0 && TotalOrderSell < MaxTrades) {
      LastSellPrice = FindLastSellPrice();
      if ((Bid - LastSellPrice) >= (LastPipStepMultiplierSell * Point)) {
         NumOfTradesSell = TotalOrderSell;
         iLotsSell = NormalizeDouble(StartingLots * MathPow(LotsMultiplier, NumOfTradesSell), 2);
         RefreshRates();
         TicketOrderSend = OrderSend(Symbol(), OP_SELL, iLotsSell, Bid, SlipPage, 0, 0, Symbol() + "-" + NumOfTradesSell, MagicNumberSell, 0, Lime); Print(Symbol() + "-" + NumOfTradesSell + "_MN-" + MagicNumberSell);
         if (TicketOrderSend < 0) {
            Print("Error: ", GetLastError());
         }
         NewOrdersPlacedSell = TRUE;
         LastPipStepMultiplierSell = NormalizeDouble((LastPipStepMultiplierSell * PipStepMultiplier), 2);
      }
   }
   
   if(iLotsSell > MaxLotsSell) {
      MaxLotsSell = iLotsSell;
   }
   
   if (TotalOrderSell > 0) {
      AveragePriceSell = 0;
      Count = 0;
      for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
         TicketOrderSelect = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumberSell) continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberSell && OrderType() == OP_SELL) {
            AveragePriceSell += OrderOpenPrice() * OrderLots();
            Count += OrderLots();
         }
      }
      AveragePriceSell = NormalizeDouble(AveragePriceSell / Count, Digits);
   }
   
   if (NewOrdersPlacedSell == TRUE) {
      for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
         TicketOrderSelect = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumberSell) continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberSell && OrderType() == OP_SELL) {
            if(FirstOrderSell == TRUE) {
               PriceTargetSell = NormalizeDouble(AveragePriceSell - (TakeProfit * Point), Digits);
            } else {
               PriceTargetSell = NormalizeDouble(AveragePriceSell, Digits);
            }
         }
         TicketOrderModify = OrderModify(OrderTicket(), AveragePriceSell, 0, PriceTargetSell, 0, Yellow);
      }
      NewOrdersPlacedSell = FALSE;
   }   
   //----------------------------------------------------------------------------------------------------------------
   
   Info();
   
}

int GetTotalOrderBuy() {
   int countOrderBuy = 0;
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
   int countOrderSell = 0;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      TicketOrderSelect = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumberSell) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberSell && OrderType() == OP_SELL) {         
         countOrderSell++;         
      }
      
   }
   return (countOrderSell);
}

double FindLastBuyPrice() {
   int LastOrderTicketBuy;
   int TemporaryLastOrderTicketBuy;
   double LastOrderOpenPriceBuy;
   PNLBuy = 0;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      TicketOrderSelect = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumberBuy) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberBuy && OrderType() == OP_BUY) { 
         TemporaryLastOrderTicketBuy = OrderTicket();
         if(TemporaryLastOrderTicketBuy > LastOrderTicketBuy) {
            LastOrderTicketBuy = TemporaryLastOrderTicketBuy;
            LastOrderOpenPriceBuy = OrderOpenPrice();
         }
         PNLBuy = PNLBuy + OrderProfit() + OrderCommission() + OrderSwap();
      }      
   }
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
   return (LastOrderOpenPriceBuy);
}

double FindLastSellPrice() {
   int LastOrderTicketSell;
   int TemporaryLastOrderTicketSell;
   double LastOrderOpenPriceSell;
   PNLSell = 0;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      TicketOrderSelect = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumberSell) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberSell && OrderType() == OP_SELL) { 
         TemporaryLastOrderTicketSell = OrderTicket();
         if(TemporaryLastOrderTicketSell > LastOrderTicketSell) {
            LastOrderTicketSell = TemporaryLastOrderTicketSell;
            LastOrderOpenPriceSell = OrderOpenPrice();
         }
         PNLSell = PNLSell + OrderProfit() + OrderCommission() + OrderSwap();
      }      
   }
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
   return (LastOrderOpenPriceSell);
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
      "\nLot Multiplier = ", LotsMultiplier,
      "\nMax Lot Buy = ", MaxLotsBuy,
      "\nMax Lot Sell = ", MaxLotsSell,
      "\nAverage Daily Range = ", GetADRs(PERIOD_D1, 20, 1),
      "\nPipStepBuy = ", LastPipStepMultiplierBuy,
      "\nPipStepSell = ", LastPipStepMultiplierSell,
      "\nTakeProfit = ", TakeProfit
   );
   
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
   
   if(iCustom(Symbol(), PERIOD_M15, "JurikFilter", 3, 1) != EMPTY_VALUE) {
      if(iCustom(Symbol(), PERIOD_M1, "JurikFilter", 3, 1) != EMPTY_VALUE) {
         SignalResult = 1;
      }
   }
   
   if(iCustom(Symbol(), PERIOD_M15, "JurikFilter", 4, 1) != EMPTY_VALUE) {
      if(iCustom(Symbol(), PERIOD_M1, "JurikFilter", 4, 1) != EMPTY_VALUE) {
         SignalResult = -1;
      }
   }
   
   return SignalResult;
   
}
