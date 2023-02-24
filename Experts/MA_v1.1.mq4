//+------------------------------------------------------------------+
//|                                                      MA_v1.1.mq4 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.1"

enum BuySellChoose {
   BuySell,
   BuyOnly,
   SellOnly
};
extern BuySellChoose BuyOrSell = BuySell;

enum MagicNumberPartList {
   One,
   Two,
   Three,
   Four,
   Five,
   Six,
   Seven,
   Eight,
   Nine
};
extern MagicNumberPartList MagicNumberPart = One;

//extern double EquityMinStopEA = 8800;
//extern double EquityMaxStopEA = 10808;
extern double StartBalance = 10000;
//extern double MaxDailyDrawDown = 400;
extern int StartHour = 10;
extern int EndHour = 22;
extern double StartingLot = 0.1;
extern double AdditionalLot = 0.01;
extern int DayADR = 5;
extern double TPDevideADR = 25;
extern double PipStepDevideADR = 25;
extern double SLMultiplierFromTP = 13;
extern int SlipPage = 5.0;

static datetime LastTradeBarTime;
int TicketOrderSelect, TicketOrderClose, TicketOrderDelete, TicketOrderSend, MagicNumberBuy, MagicNumberSell, TotalOrderBuy, TotalOrderSell, NumOfTradesBuy, NumOfTradesSell;
double PipStep, EquityMin, EquityMax, TakeProfitPoint, StopLossPoint, TakeProfitBuy, TakeProfitSell, StopLossBuy, StopLossSell, LastBuyPrice, LastSellPrice, LastBuyPriceSL, LastSellPriceSL;

int init() {
   LastTradeBarTime = Time[1];
   return (0);
}

int deinit() {
   return (0);
}

int start() {

   if (LastTradeBarTime == Time[0]) {

      return (0);

   } else {
   
      LastTradeBarTime = Time[0];
      
      //MinRemoveExpertNow(EquityMinStopEA);
      //MaxRemoveExpertNow(EquityMaxStopEA);
      //EquityRemoveExpertNow(StartBalance, MaxDailyDrawDown);
      
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
      
      TakeProfitPoint = NormalizeDouble((GetADRs(PERIOD_D1, DayADR, 1) / TPDevideADR), 0);
      PipStep = NormalizeDouble(GetADRs(PERIOD_D1, DayADR, 1) / PipStepDevideADR, 0);
      
      if(BuyOrSell == BuyOnly || BuyOrSell == BuySell) {
      
         if(GetSignalBuy() == true) {
            
            MagicNumberBuy = GetMagicNumber("BUY");
            TotalOrderBuy = GetTotalOrderBuy();
            
            if ((Hour() >= StartHour && Hour() < EndHour)) {
            
               if(TotalOrderBuy <= 0) {
                  TakeProfitBuy = NormalizeDouble(Ask + (double) TakeProfitPoint * Point, Digits);
                  StopLossBuy = NormalizeDouble(Ask - (double) (TakeProfitPoint * SLMultiplierFromTP) * Point, Digits);
                  TicketOrderSend = OrderSend(Symbol(), OP_BUY, StartingLot, Ask, SlipPage, StopLossBuy, TakeProfitBuy, Symbol() + "_buy_1", MagicNumberBuy, 0, clrLime);
                  if (TicketOrderSend < 0) {
                     Print("Error: ", GetLastError());
                  }               
               }
               
            }
            
            if(TotalOrderBuy > 0) {
               LastBuyPrice = FindLastBuyPrice();
               LastBuyPriceSL = NormalizeDouble(FindLastBuyPriceSL(), Digits);
               if ((LastBuyPrice - Ask) >= (PipStep * Point) && (Ask - LastBuyPriceSL) > (PipStep * Point)) {
                  TakeProfitBuy = NormalizeDouble(Ask + (double) TakeProfitPoint * Point, Digits);
                  NumOfTradesBuy = TotalOrderBuy + 1;
                  TicketOrderSend = OrderSend(Symbol(), OP_BUY, AdditionalLot, Ask, SlipPage, LastBuyPriceSL, TakeProfitBuy, Symbol() + "_buy_" + NumOfTradesBuy, MagicNumberBuy, 0, clrLime);
                  if (TicketOrderSend < 0) {
                     Print("Error: ", GetLastError());
                  }
               }
            }
            
         }
         
      }
      
      if(BuyOrSell == SellOnly || BuyOrSell == BuySell) {
      
         if(GetSignalSell() == true) {
            
            MagicNumberSell = GetMagicNumber("SELL");
            TotalOrderSell = GetTotalOrderSell();
            
            if ((Hour() >= StartHour && Hour() < EndHour)) {
            
               if(TotalOrderSell <= 0) {
                  TakeProfitPoint = NormalizeDouble((GetADRs(PERIOD_D1, DayADR, 1) / TPDevideADR), 0);
                  TakeProfitSell = NormalizeDouble(Bid - (double) TakeProfitPoint * Point, Digits);
                  StopLossSell = NormalizeDouble(Bid + (double) (TakeProfitPoint * SLMultiplierFromTP) * Point, Digits);
                  TicketOrderSend = OrderSend(Symbol(), OP_SELL, StartingLot, Bid, SlipPage, StopLossSell, TakeProfitSell, Symbol() + "_sell_1", MagicNumberSell, 0, clrRed);
               }
               
            }
            
            if(TotalOrderSell > 0) {
               LastSellPrice = FindLastSellPrice();
               LastSellPriceSL = NormalizeDouble(FindLastSellPriceSL(), Digits);
               if ((Bid - LastSellPrice) >= (PipStep * Point) && (LastSellPriceSL - Bid) > (PipStep * Point)) {
                  TakeProfitPoint = NormalizeDouble((GetADRs(PERIOD_D1, DayADR, 1) / TPDevideADR), 0);
                  TakeProfitSell = NormalizeDouble(Bid - (double) TakeProfitPoint * Point, Digits);
                  NumOfTradesSell = TotalOrderSell + 1;
                  TicketOrderSend = OrderSend(Symbol(), OP_SELL, AdditionalLot, Bid, SlipPage, LastSellPriceSL, TakeProfitSell, Symbol() + "_sell_" + NumOfTradesSell, MagicNumberSell, 0, clrLime);
                  if (TicketOrderSend < 0) {
                     Print("Error: ", GetLastError());
                  }
               }
            }
            
         }
      
      }
      
      Info();
      
      return (0);
      
   }

}

//##################### FUNCTION and LIBRARY #######################
bool GetSignalBuy() {
   
   //if(Ask < iMA(Symbol(), PERIOD_CURRENT, 30, 0, MODE_SMA, PRICE_CLOSE, 0)) {
      if(Ask < iMA(Symbol(), PERIOD_CURRENT, 6, 0, MODE_SMA, PRICE_LOW, 0)) {
         return true;
      }
   //}
   return false;
   
}

bool GetSignalSell() {
   
   //if(Bid > iMA(Symbol(), PERIOD_CURRENT, 30, 0, MODE_SMA, PRICE_CLOSE, 0)) {
      if(Bid > iMA(Symbol(), PERIOD_CURRENT, 6, 0, MODE_SMA, PRICE_HIGH, 0)) {
         return true;
      }
   //}
   return false;
   
}

int MinRemoveExpertNow(double MinimumEquity = 0) {

   if (MinimumEquity > 0 && AccountEquity() < MinimumEquity) {
      RemoveAllOrders();
      RemoveAllOrders();
      RemoveAllOrders();
      ExpertRemove();
   }
   return (0);

}

int MaxRemoveExpertNow(double MaximumEquity = 0) {

   if (MaximumEquity > 0 && AccountEquity() > MaximumEquity) {
      RemoveAllOrders();
      RemoveAllOrders();
      RemoveAllOrders();
      ExpertRemove();
   }
   return (0);

}

int EquityRemoveExpertNow(double theStartBalance, double theMaxDailyDrawDown) {
   if(AccountEquity() < (theStartBalance - theMaxDailyDrawDown)) {
      RemoveAllOrders();
      RemoveAllOrders();
      RemoveAllOrders();
      ExpertRemove();
   }
   return (0);
}

void RemoveAllOrders() {
   for (int i = OrdersTotal() - 1; i >= 0; i--) {
      TicketOrderSelect = OrderSelect(i, SELECT_BY_POS);
      if (OrderType() == OP_BUY) {
         TicketOrderClose = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, clrNONE);
      } else if (OrderType() == OP_SELL) {
         TicketOrderClose = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, clrNONE);
      } else {
         TicketOrderDelete = OrderDelete(OrderTicket());
      }

      int MessageError = GetLastError();
      if (MessageError > 0) {
         Print(IntegerToString(MessageError));
      }

      Sleep(100);
      RefreshRates();

   }
}

double GetADRs(int ATR_TimeFrame = PERIOD_D1, int ATR_Counter = 5, int ATR_Shift = 1) {

   double ATR_PipStep;
   ATR_PipStep = iATR(Symbol(), ATR_TimeFrame, ATR_Counter, ATR_Shift);
   ATR_PipStep = MathRound(ATR_PipStep / _Point);
   return ATR_PipStep;

}

void Info() {

   Comment("",
      "----------------------------------------------------------------",
      "\nMoving Average EA",
      "\nStartBalance = ", StartBalance,
      "\nEquity = ", DoubleToString(AccountEquity(), 2),
      "\nEquity Min = ", DoubleToString(EquityMin, 2),
      "\nEquity Max = ", DoubleToString(EquityMax, 2),
      "\nStarting Lot = ", StartingLot,
      "\nAdditional Lot = ", AdditionalLot,
      "\nAverage Daily Range = ", GetADRs(PERIOD_D1, DayADR, 1),
      "\nTakeProfit = ", DoubleToString(TakeProfitPoint, 0),
      "\nPipStep = ", DoubleToString(PipStep, 0),
      "\nSpread = ", DoubleToString(MarketInfo(Symbol(), MODE_SPREAD), 0),
      "\n----------------------------------------------------------------"
   );

}

int GetMagicNumber(string TheOrderType = "BUYSELL") {

   int TheMagicNumberPart;
   switch (MagicNumberPart) {
   case One:
      TheMagicNumberPart = 1;
   case Two:
      TheMagicNumberPart = 2;
      break;
   case Three:
      TheMagicNumberPart = 3;
      break;
   case Four:
      TheMagicNumberPart = 4;
      break;
   case Five:
      TheMagicNumberPart = 5;
      break;
   case Six:
      TheMagicNumberPart = 6;
      break;
   case Seven:
      TheMagicNumberPart = 7;
      break;
   case Eight:
      TheMagicNumberPart = 8;
      break;
   case Nine:
      TheMagicNumberPart = 9;
      break;
   }

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

   for (int i = 0; i < 29; i++) {
      if (StringSymbol[i] == Symbol()) {
         MagicNumberString = MagicNumberString + IntegerToString(i + 1);
      }
   }

   if (TheOrderType == "BUY") {
      MagicNumberString = MagicNumberString + "1" + IntegerToString(TheMagicNumberPart, 0);
      MagicNumberResult = StringToInteger(MagicNumberString);
   } else if (TheOrderType == "SELL") {
      MagicNumberString = MagicNumberString + "2" + IntegerToString(TheMagicNumberPart, 0);
      MagicNumberResult = StringToInteger(MagicNumberString);
   } else if (TheOrderType == "BUYSELL") {
      MagicNumberString = MagicNumberString + "3" + IntegerToString(TheMagicNumberPart, 0);
      MagicNumberResult = StringToInteger(MagicNumberString);
   } else {
      MagicNumberString = IntegerToString(MagicNumberResult, 0) + IntegerToString(TheMagicNumberPart, 0);
      MagicNumberResult = StringToInteger(MagicNumberString);
   }

   return MagicNumberResult;

}

int GetTotalOrderBuy() {
   int countOrderBuy = 0, CountOrder;
   for (CountOrder = OrdersTotal() - 1; CountOrder >= 0; CountOrder--) {
      TicketOrderSelect = OrderSelect(CountOrder, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumberBuy) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberBuy && OrderType() == OP_BUY) {
         countOrderBuy++;
      }

   }
   return (countOrderBuy);
}

int GetTotalOrderSell() {
   int countOrderSell = 0, CountOrder;
   for (CountOrder = OrdersTotal() - 1; CountOrder >= 0; CountOrder--) {
      TicketOrderSelect = OrderSelect(CountOrder, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumberSell) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberSell && OrderType() == OP_SELL) {
         countOrderSell++;
      }

   }
   return (countOrderSell);
}

double FindLastBuyPrice() {
   int LastOrderTicketBuy, TemporaryLastOrderTicketBuy, CountOrder;
   double LastOrderOpenPriceBuy;
   for (CountOrder = OrdersTotal() - 1; CountOrder >= 0; CountOrder--) {
      TicketOrderSelect = OrderSelect(CountOrder, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumberBuy) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberBuy && OrderType() == OP_BUY) {
         TemporaryLastOrderTicketBuy = OrderTicket();
         if (TemporaryLastOrderTicketBuy > LastOrderTicketBuy) {
            LastOrderTicketBuy = TemporaryLastOrderTicketBuy;
            LastOrderOpenPriceBuy = OrderOpenPrice();
         }
      }
   }
   return (LastOrderOpenPriceBuy);
}

double FindLastSellPrice() {
   int LastOrderTicketSell, TemporaryLastOrderTicketSell, CountOrder;
   double LastOrderOpenPriceSell;
   for (CountOrder = OrdersTotal() - 1; CountOrder >= 0; CountOrder--) {
      TicketOrderSelect = OrderSelect(CountOrder, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumberSell) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberSell && OrderType() == OP_SELL) {
         TemporaryLastOrderTicketSell = OrderTicket();
         if (TemporaryLastOrderTicketSell > LastOrderTicketSell) {
            LastOrderTicketSell = TemporaryLastOrderTicketSell;
            LastOrderOpenPriceSell = OrderOpenPrice();
         }
      }
   }
   return (LastOrderOpenPriceSell);
}

double FindLastBuyPriceSL() {
   int LastOrderTicketBuy, TemporaryLastOrderTicketBuy, CountOrder;
   double LastOrderOpenPriceBuySL;
   for (CountOrder = OrdersTotal() - 1; CountOrder >= 0; CountOrder--) {
      TicketOrderSelect = OrderSelect(CountOrder, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumberBuy) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberBuy && OrderType() == OP_BUY) {
         TemporaryLastOrderTicketBuy = OrderTicket();
         if (TemporaryLastOrderTicketBuy > LastOrderTicketBuy) {
            LastOrderTicketBuy = TemporaryLastOrderTicketBuy;
            LastOrderOpenPriceBuySL = OrderStopLoss();
         }
      }
   }
   return (LastOrderOpenPriceBuySL);
}

double FindLastSellPriceSL() {
   int LastOrderTicketSell, TemporaryLastOrderTicketSell, CountOrder;
   double LastOrderOpenPriceSellSL;
   for (CountOrder = OrdersTotal() - 1; CountOrder >= 0; CountOrder--) {
      TicketOrderSelect = OrderSelect(CountOrder, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumberSell) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberSell && OrderType() == OP_SELL) {
         TemporaryLastOrderTicketSell = OrderTicket();
         if (TemporaryLastOrderTicketSell > LastOrderTicketSell) {
            LastOrderTicketSell = TemporaryLastOrderTicketSell;
            LastOrderOpenPriceSellSL = OrderStopLoss();
         }
      }
   }
   return (LastOrderOpenPriceSellSL);
}
