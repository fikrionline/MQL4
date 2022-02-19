//+------------------------------------------------------------------+
//|                                                PyramidMaster.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Bismillahirrohmanirrohim"
#property link      "waddahattar@hotmail.com"
#property version   "1.00"

extern double  EquityStopEA = 9600.00;
//extern int     StartHour = 3;
//extern int     EndHour = 22;
extern int     MaxTrades = 33;
extern int     PipStep = 66;
extern double  FirstLot = 0.01;
extern double  IncLot = 0.00;
extern double  BEPHunterProfit = 10;
extern int     SlipPage = 5;

double LastBuyPrice, LastSellPrice, LotToComment, StartEquity = 0;
int TicketOrder, TicketOrderSend, TicketOrderSelect, TicketOrderClose, TicketOrderDelete, TotalOrderBuy, TotalOrderSell, NumOfTradesBuy, NumOfTradesSell, MagicNumberBuy, MagicNumberSell;
string PrepareComment, CommentOrder;

int init() {
   Comment("");
   return (0);
}

int deinit() {
   Comment("");
   return (0);
}

void OnTick() {

   RemoveExpertNow(EquityStopEA);
   
   MagicNumberBuy = GetMagicNumber("BUY");
   MagicNumberSell = GetMagicNumber("SELL");

   TotalOrderBuy = GetTotalOrderBuy();
   TotalOrderSell = GetTotalOrderSell();
   
   if (TotalOrderBuy > 0 && TotalOrderBuy < MaxTrades) {
      LastBuyPrice = FindLastBuyPrice();
      if ((Ask - LastBuyPrice) >= (PipStep * Point)) {
         NumOfTradesBuy = TotalOrderBuy;
         RefreshRates();
         TicketOrderSend = OrderSend(Symbol(), OP_BUY, FirstLot + (IncLot * NumOfTradesBuy), Ask, SlipPage, 0, 0, Symbol() + "-" + NumOfTradesBuy, MagicNumberBuy, 0, Blue);
         if (TicketOrderSend < 0) {
            Print("Error: ", GetLastError());
         }
      }
   }
   
   if (TotalOrderSell > 0 && TotalOrderSell < MaxTrades) {
      LastSellPrice = FindLastSellPrice();
      if ((LastSellPrice - Bid) >= (PipStep * Point)) {
         NumOfTradesSell = TotalOrderSell;
         RefreshRates();
         TicketOrderSend = OrderSend(Symbol(), OP_SELL, FirstLot + (IncLot * NumOfTradesSell), Bid, SlipPage, 0, 0, Symbol() + "-" + NumOfTradesSell, MagicNumberSell, 0, Red);
         if (TicketOrderSend < 0) {
            Print("Error: ", GetLastError());
         }
      }
   }
   
   if(TotalOrderBuy < 1 && TotalOrderSell < 1) {
      
      if(GetSignalPivot() >= 0) {
      
         StartEquity = AccountEquity();
         
         NumOfTradesBuy = 0;
         TicketOrderSend = OrderSend(Symbol(), OP_BUY, FirstLot, Ask, SlipPage, 0, 0, Symbol() + "-" + IntegerToString(NumOfTradesBuy), MagicNumberBuy, 0, Blue);
         
         NumOfTradesSell = 0;
         TicketOrderSend = OrderSend(Symbol(), OP_SELL, FirstLot, Bid, SlipPage, 0, 0, Symbol() + "-" + IntegerToString(NumOfTradesBuy), MagicNumberSell, 0, Red);
         
      }
      
   }

   Comment(
      "\n Start Balance = " + DoubleToString(StartEquity, 2) +
      "\n Equity: " + DoubleToString(AccountEquity(), 2));
      
   if(AccountEquity() > (StartEquity + BEPHunterProfit)) {
      RemoveAllOrders();
      RefreshRates();
      RemoveAllOrders();
      RefreshRates();
      TotalOrderBuy = 0;
      TotalOrderSell = 0;
   }
   
}

int GetTotalOrderBuy() {
   int countOrderBuy = 0;
   for (int cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
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
   for (int cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
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
   for (int cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      TicketOrderSelect = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumberBuy) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberBuy && OrderType() == OP_BUY) { 
         TemporaryLastOrderTicketBuy = OrderTicket();
         if(TemporaryLastOrderTicketBuy > LastOrderTicketBuy) {
            LastOrderTicketBuy = TemporaryLastOrderTicketBuy;
            LastOrderOpenPriceBuy = OrderOpenPrice();
         }
      }
      
   }
   return (LastOrderOpenPriceBuy);
}

double FindLastSellPrice() {
   int LastOrderTicketSell;
   int TemporaryLastOrderTicketSell;
   double LastOrderOpenPriceSell;
   for (int cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      TicketOrderSelect = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumberSell) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberSell && OrderType() == OP_SELL) { 
         TemporaryLastOrderTicketSell = OrderTicket();
         if(TemporaryLastOrderTicketSell > LastOrderTicketSell) {
            LastOrderTicketSell = TemporaryLastOrderTicketSell;
            LastOrderOpenPriceSell = OrderOpenPrice();
         }
      }
      
   }
   return (LastOrderOpenPriceSell);
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

int RemoveExpertNow(double MinimumEquity = 0) {
   
   if(MinimumEquity > 0 && AccountEquity() < MinimumEquity) {
      RemoveAllOrders();
      RemoveAllOrders();
      RemoveAllOrders();
      ExpertRemove();
   }
   return(0);
   
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

int GetSignalPivot() {

   int SignalResult = 0;
   double ThePivot;
   ThePivot = (iHigh(Symbol(), PERIOD_D1, 1) + iLow(Symbol(), PERIOD_D1, 1) + iClose(Symbol(), PERIOD_D1, 1)) / 3;
   
   if((ThePivot + (SlipPage * Point)) > Ask && (ThePivot - (SlipPage * Point)) < Bid) {
      SignalResult = 1;
   }
   
   return SignalResult;
   
}
