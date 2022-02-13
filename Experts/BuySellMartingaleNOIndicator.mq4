#property copyright "MQL5"
#property link "https://www.mql5.com/en/code"
#property description "Martingale EA"

enum TheMultiplier {
   a, //x2
   b, //x1.9
   c, //x1.8
   d, //x1.7
   e, //x1.6
   f, //x1.5
   g, //x1.4
   h, //x1.3 
   i, //x1.2
   j, //x1.1 
   k //x1
};

enum PipStepDevideADR {
   pa, //ADR/10
   pb, //ADR/9
   pc, //ADR/8
   pd, //ADR/7
   pe, //ADR/6
   pf, //ADR/5
   pg, //ADR/4
   ph, //ADR/3 
   pi, //ADR/2
   pj, //ADR/1 
};

enum TakeProfitDevideADR {
   ta, //ADR/20
   tb, //ADR/19
   tc, //ADR/18
   td, //ADR/17
   te, //ADR/16
   tf, //ADR/15
   tg, //ADR/14
   th, //ADR/13 
   ti, //ADR/12
   tj, //ADR/11
   tk, //ADR/10
   tl, //ADR/9
   tm, //ADR/8
   tn, //ADR/7
   to, //ADR/6
   tp, //ADR/5
   tq, //ADR/4
   tr, //ADR/3 
   ts, //ADR/2
   tt, //ADR/1
};

extern double EquityStopEA = 9600.00;
extern int StartHour = 3;
extern int EndHour = 22;
extern double StartingLots = 0.01;
extern TheMultiplier LayerMultiplier = i;
extern PipStepDevideADR PipStepDevide = ph;
extern TakeProfitDevideADR TakeProfitDevide = tk;
extern double TakeProfitPlus = 10;
extern double SlipPage = 5.0;
extern int MaxTrades = 9;

int TicketOrderSend, TicketOrderSelect, TicketOrderModify, TicketOrderClose, TicketOrderDelete, TotalOrderBuy, TotalOrderSell, LastTicket, LastTicketTemp, MagicNumberBuy, NumOfTradesSell, MagicNumberSell, NumOfTradesBuy, cnt;
double PriceTargetBuy, PriceTargetSell, AveragePriceBuy, AveragePriceSell, LastBuyPrice, LastSellPrice, iLotsBuy, iLotsSell, Multiplier, ADRs, PipStep, PipStepDevideResult, TakeProfit, TakeProfitDevideResult, Count;
bool NewOrdersPlacedBuy = FALSE, NewOrdersPlacedSell = FALSE, FirstOrderBuy = FALSE, FirstOrderSell = FALSE;

int init() {
   return (0);
}

int deinit() {
   return (0);
}

int start() {

   RemoveExpertNow(EquityStopEA);
   
   switch (LayerMultiplier) {
   case a:
      Multiplier = 2;
      break;
   case b:
      Multiplier = 1.9;
      break;
   case c:
      Multiplier = 1.8;
      break;
   case d:
      Multiplier = 1.7;
      break;
   case e:
      Multiplier = 1.6;
      break;
   case f:
      Multiplier = 1.5;
      break;
   case g:
      Multiplier = 1.4;
      break;
   case h:
      Multiplier = 1.3;
      break;
   case i:
      Multiplier = 1.2;
      break;
   case j:
      Multiplier = 1.1;
      break;
   case k:
      Multiplier = 1;
      break;
   }
   
   switch (PipStepDevide) {
   case pa:
      PipStepDevideResult = 10;
      break;
   case pb:
      PipStepDevideResult = 9;
      break;
   case pc:
      PipStepDevideResult = 8;
      break;
   case pd:
      PipStepDevideResult = 7;
      break;
   case pe:
      PipStepDevideResult = 6;
      break;
   case pf:
      PipStepDevideResult = 5;
      break;
   case pg:
      PipStepDevideResult = 4;
      break;
   case ph:
      PipStepDevideResult = 3;
      break;
   case pi:
      PipStepDevideResult = 2;
      break;
   case pj:
      PipStepDevideResult = 1;
      break;
   }
   
   PipStep = NormalizeDouble(GetADRs() / PipStepDevideResult, 2);
   
   switch (TakeProfitDevide) {
   case ta:
      TakeProfitDevideResult = 20;
      break;
   case tb:
      TakeProfitDevideResult = 19;
      break;
   case tc:
      TakeProfitDevideResult = 18;
      break;
   case td:
      TakeProfitDevideResult = 17;
      break;
   case te:
      TakeProfitDevideResult = 16;
      break;
   case tf:
      TakeProfitDevideResult = 15;
      break;
   case tg:
      TakeProfitDevideResult = 14;
      break;
   case th:
      TakeProfitDevideResult = 13;
      break;
   case ti:
      TakeProfitDevideResult = 12;
      break;
   case tj:
      TakeProfitDevideResult = 11;
      break;
   case tk:
      TakeProfitDevideResult = 10;
      break;
   case tl:
      TakeProfitDevideResult = 9;
      break;
   case tm:
      TakeProfitDevideResult = 8;
      break;
   case tn:
      TakeProfitDevideResult = 7;
      break;
   case to:
      TakeProfitDevideResult = 6;
      break;
   case tp:
      TakeProfitDevideResult = 5;
      break;
   case tq:
      TakeProfitDevideResult = 4;
      break;
   case tr:
      TakeProfitDevideResult = 3;
      break;
   case ts:
      TakeProfitDevideResult = 2;
      break;
   case tt:
      TakeProfitDevideResult = 1;
      break;
   }
   
   TakeProfit = NormalizeDouble((GetADRs() / TakeProfitDevideResult) + TakeProfitPlus, 2);
   
   //------ Only for BUY -------------------------------------------------------------------------------------------
   MagicNumberBuy = GetMagicNumber("BUY");
   
   TotalOrderBuy = 0;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      TicketOrderSelect = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberBuy && OrderType() == OP_BUY) {
         
         //Find last buy price
         LastTicketTemp = OrderTicket();
         if (LastTicketTemp > LastTicket) {
            LastTicket = LastTicketTemp;
            LastBuyPrice = OrderOpenPrice();
         }
         
         //Total
         TotalOrderBuy++;
         
      }
      
   }
   
   if(TotalOrderBuy < 1) {
      NumOfTradesBuy = 0;
      iLotsBuy = NormalizeDouble(StartingLots * MathPow(Multiplier, NumOfTradesBuy), 2);      
      if((Hour() >= StartHour || Hour() <= EndHour)) {         
         TicketOrderSend = OrderSend(Symbol(), OP_BUY, iLotsBuy, Ask, SlipPage, 0, 0, Symbol() + "-" + NumOfTradesBuy, MagicNumberBuy, 0, Lime); Print(MagicNumberBuy + "__" + Symbol() + "-" + NumOfTradesBuy);
         if (TicketOrderSend < 0) {
            Print("Error: ", GetLastError());
            return (0);
         }
         NewOrdersPlacedBuy = TRUE;
         FirstOrderBuy = TRUE;
         TotalOrderBuy = 1;
      }
   }
   
   if (TotalOrderBuy > 0 && TotalOrderBuy < MaxTrades) {
      RefreshRates();
      if (LastBuyPrice - Ask >= PipStep * Point) {
         NumOfTradesBuy = TotalOrderBuy;
         iLotsBuy = NormalizeDouble(StartingLots * MathPow(Multiplier, NumOfTradesBuy), 2);
         TicketOrderSend = OrderSend(Symbol(), OP_BUY, iLotsBuy, Ask, SlipPage, 0, 0, Symbol() + "-" + NumOfTradesBuy, MagicNumberBuy, 0, Lime); Print(MagicNumberBuy + "__" + Symbol() + "-" + NumOfTradesBuy);
         if (TicketOrderSend < 0) {
            Print("Error: ", GetLastError());
            return (0);
         }
         NewOrdersPlacedBuy = TRUE;
      }
   }
      AveragePriceBuy = 0;
   Count = 0;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      TicketOrderSelect = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberBuy && OrderType() == OP_BUY) {
         AveragePriceBuy += OrderOpenPrice() * OrderLots();
         Count += OrderLots();
      }
   }
   
   if (TotalOrderBuy > 0) {
      AveragePriceBuy = NormalizeDouble(AveragePriceBuy / Count, Digits);
   }
   
   if (NewOrdersPlacedBuy == TRUE) {
      for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
         TicketOrderSelect = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberBuy && OrderType() == OP_BUY) {
            if(FirstOrderBuy == TRUE) {
               PriceTargetBuy = NormalizeDouble(AveragePriceBuy + (TakeProfit * Point), Digits); Print("Print___" + NormalizeDouble(AveragePriceBuy + (TakeProfit * Point), Digits));
            } else {
               PriceTargetBuy = NormalizeDouble(AveragePriceBuy, Digits);
            }
         }
         TicketOrderModify = OrderModify(OrderTicket(), OrderOpenPrice(), 0, PriceTargetBuy, 0, Yellow);
      }
      NewOrdersPlacedBuy = FALSE;
   }
   //----------------------------------------------------------------------------------------------------------------
   
   //------ Only for SELL -------------------------------------------------------------------------------------------
   MagicNumberSell = GetMagicNumber("SELL");
   
   TotalOrderSell = 0;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      TicketOrderSelect = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberSell && OrderType() == OP_SELL) {
         
         //Find last sell price
         LastTicketTemp = OrderTicket();
         if (LastTicketTemp > LastTicket) {
            LastTicket = LastTicketTemp;
            LastSellPrice = OrderOpenPrice();
         }
         
         //Total
         TotalOrderSell++;
         
      }
      
   }
   
   if(TotalOrderSell < 1) {
      NumOfTradesSell = 0;
      iLotsSell = NormalizeDouble(StartingLots * MathPow(Multiplier, NumOfTradesSell), 2);      
      if((Hour() >= StartHour || Hour() <= EndHour)) {         
         TicketOrderSend = OrderSend(Symbol(), OP_SELL, iLotsSell, Bid, SlipPage, 0, 0, Symbol() + "-" + NumOfTradesSell, MagicNumberSell, 0, Lime); Print(MagicNumberSell + "__" + Symbol() + "-" + NumOfTradesSell);
         if (TicketOrderSend < 0) {
            Print("Error: ", GetLastError());
            return (0);
         }
         NewOrdersPlacedSell = TRUE;
         FirstOrderSell = TRUE;
         TotalOrderSell = 1;
      }
   }
   
   if (TotalOrderSell > 0 && TotalOrderSell < MaxTrades) {
      RefreshRates();
      if (Bid - LastSellPrice >= PipStep * Point) {
         NumOfTradesSell = TotalOrderSell;
         iLotsSell = NormalizeDouble(StartingLots * MathPow(Multiplier, NumOfTradesSell), 2);
         TicketOrderSend = OrderSend(Symbol(), OP_SELL, iLotsSell, Bid, SlipPage, 0, 0, Symbol() + "-" + NumOfTradesSell, MagicNumberSell, 0, Lime); Print(MagicNumberSell + "__" + Symbol() + "-" + NumOfTradesSell);
         if (TicketOrderSend < 0) {
            Print("Error: ", GetLastError());
            return (0);
         }
         NewOrdersPlacedSell = TRUE;
      }
   }
   
   AveragePriceSell = 0;
   Count = 0;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      TicketOrderSelect = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberSell && OrderType() == OP_SELL) {
         AveragePriceSell += OrderOpenPrice() * OrderLots();
         Count += OrderLots();
      }
   }
   
   if (TotalOrderSell > 0) {
      AveragePriceSell = NormalizeDouble(AveragePriceSell / Count, Digits);
   }
   
   if (NewOrdersPlacedSell == TRUE) {
      for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
         TicketOrderSelect = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumberSell && OrderType() == OP_SELL) {
            if(FirstOrderSell == TRUE) {
               PriceTargetSell = NormalizeDouble(AveragePriceSell - (TakeProfit * Point), Digits); Print("Print___" + NormalizeDouble(AveragePriceSell + (TakeProfit * Point), Digits));
            } else {
               PriceTargetSell = NormalizeDouble(AveragePriceSell, Digits);
            }
         }
         TicketOrderModify = OrderModify(OrderTicket(), OrderOpenPrice(), 0, PriceTargetSell, 0, Yellow);
      }
      NewOrdersPlacedSell = FALSE;
   }   
   //----------------------------------------------------------------------------------------------------------------
   
   Info();
   
   return (0);
   
}


void Info() {

   Comment("",
      "Martigale EA",
      "\nEquity = ", DoubleToString(AccountEquity(), 2),
      "\nStarting Lot = ", StartingLots,
      "\nAverage Daily Range = ", GetADRs(),
      "\nPipStep = ", PipStep,
      "\nTakeProfit = ", TakeProfit
   );
   
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

int GetMagicNumber(string TheOrderType = "BUY") {
   
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
