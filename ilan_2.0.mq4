//+------------------------------------------------------------------+
//|                                                     ilan_2.0.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

double Stoploss = 500.0;
double TrailStart = 10.0;
double TrailStop = 10.0;

extern double LotExponent = 1;
extern bool DynamicPips = true;
extern int DefaultPips = 12;
extern int NumberOfBars = 14;
extern int DEL = 3;
extern int slip = 3.0;
extern double Lots = 0.01;
extern int lotdecimal = 2;
extern double TakeProfit = 50.0;

extern double Drop = 500;
extern double RsiMinimum = 30.0;
extern double RsiMaximum = 70.0;
extern int MagicNumber = 2222;
double PipStep = 0;

extern int MaxTrades = 10;
extern bool UseEquityStop = true;
extern double MinumumEquity = 9800.0;
extern bool UseTrailingStop = true;
extern bool UseTimeOut = false;
extern double MaxTradeOpenHours = 48.0;

double PriceTarget, StartEquity, BuyTarget, SellTarget;
double AveragePrice, SellLimit, BuyLimit;
double LastBuyPrice, LastSellPrice, Spread;
bool flag;
string EAName = "Bismillahirrohmanirrohim";
string CommentEA;
datetime timeprev = 0, expiration;
int NumOfTrades = 0;
double iLots;
int cnt = 0, total;
double Stopper = 0.0;
bool TradeNow = false, LongTrade = false, ShortTrade = false;
int ticket, ticketOrder;
bool NewOrdersPlaced = false;
double AccountEquityHighAmt, PrevEquity;

int init() {
   Spread = MarketInfo(Symbol(), MODE_SPREAD) * Point;
   return (0);
}

int deinit() {
   return (0);
}

int start() {

   CommentEA = "Bismillahirrohmanirrohim";
   CommentEA = CommentEA + "\n" + "Equity: " + DoubleToString(AccountEquity(), 2);   
   Comment(CommentEA);
   
   if (DynamicPips) {
      double hival = High[iHighest(NULL, 0, MODE_HIGH, NumberOfBars, 1)];
      double loval = Low[iLowest(NULL, 0, MODE_LOW, NumberOfBars, 1)];
      PipStep = NormalizeDouble((hival - loval) / DEL / Point, 0);
      if (PipStep < DefaultPips / DEL) PipStep = NormalizeDouble(DefaultPips / DEL, 0);
      if (PipStep > DefaultPips * DEL) PipStep = NormalizeDouble(DefaultPips * DEL, 0);
   }

   double PrevCl;
   double CurrCl;
   if (UseTrailingStop) TrailingAlls(TrailStart, TrailStop, AveragePrice);
   if ((iCCI(NULL, 60, 14, 0, 1) > Drop && ShortTrade) || (iCCI(NULL, 60, 14, 0, 1) < (-Drop) && LongTrade)) {
      CloseThisSymbolAll();
      Print("Closed All due to TimeOut");
   }
   
   if (timeprev == Time[0]) return (0);
   timeprev = Time[0];

   double CurrentPairProfit = CalculateProfit();
   if (UseEquityStop) {
      /*if (CurrentPairProfit < 0.0 && MathAbs(CurrentPairProfit) > TotalEquityRisk / 100.0 * AccountEquityHigh()) {
         CloseThisSymbolAll();
         Print("Closed All due to Stop Out");
         NewOrdersPlaced = false;
      }*/
      if(AccountEquity() < MinumumEquity) {
         CloseThisSymbolAll();
         CloseThisSymbolAll();
         CloseThisSymbolAll();
         CloseThisSymbolAll();
         CloseThisSymbolAll();
         Print("Closed All due to Low Equity");
         NewOrdersPlaced = false;
         ExpertRemove();
      }
   }
   
   total = CountTrades();
   if (total == 0) flag = false;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      ticketOrder = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
         if (OrderType() == OP_BUY) {
            LongTrade = true;
            ShortTrade = true;
            break;
         }
      }
      
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
         if (OrderType() == OP_SELL) {
            LongTrade = true;
            ShortTrade = true;
            break;
         }
      }
   }
   
   if (total > 0 && total <= MaxTrades) {
      RefreshRates();
      LastBuyPrice = FindLastBuyPrice();
      LastSellPrice = FindLastSellPrice();
      if (LongTrade && LastBuyPrice - Ask >= PipStep * Point) TradeNow = true;
      if (ShortTrade && Bid - LastSellPrice >= PipStep * Point) TradeNow = true;
   }
   
   if (total < 1) {
      ShortTrade = false;
      LongTrade = false;
      TradeNow = true;
      StartEquity = AccountEquity();
   }
   
   if (TradeNow) {
      LastBuyPrice = FindLastBuyPrice();
      LastSellPrice = FindLastSellPrice();
      if (ShortTrade) {
         NumOfTrades = total;
         iLots = NormalizeDouble(Lots * MathPow(LotExponent, NumOfTrades), lotdecimal);
         RefreshRates();
         ticket = OpenPendingOrder(1, iLots, Bid, slip, Ask, 0, 0, EAName + "-" + IntegerToString(NumOfTrades) + "-" + DoubleToString(PipStep), MagicNumber, 0, HotPink);
         if (ticket < 0) {
            Print("Error: ", GetLastError());
            return (0);
         }
         LastSellPrice = FindLastSellPrice();
         TradeNow = false;
         NewOrdersPlaced = true;
      } else {
         if (LongTrade) {
            NumOfTrades = total;
            iLots = NormalizeDouble(Lots * MathPow(LotExponent, NumOfTrades), lotdecimal);
            ticket = OpenPendingOrder(0, iLots, Ask, slip, Bid, 0, 0, EAName + "-" + IntegerToString(NumOfTrades) + "-" + DoubleToString(PipStep), MagicNumber, 0, Lime);
            if (ticket < 0) {
               Print("Error: ", GetLastError());
               return (0);
            }
            LastBuyPrice = FindLastBuyPrice();
            TradeNow = false;
            NewOrdersPlaced = true;
         }
      }
   }
   if (TradeNow && total < 1) {
      PrevCl = iClose(Symbol(), 0, 2);
      CurrCl = iClose(Symbol(), 0, 1);
      SellLimit = Bid;
      BuyLimit = Ask;
      if (!ShortTrade && !LongTrade) {
         NumOfTrades = total;
         iLots = NormalizeDouble(Lots * MathPow(LotExponent, NumOfTrades), lotdecimal);
         if (PrevCl > CurrCl) {
            if (iRSI(NULL, PERIOD_H1, 14, PRICE_CLOSE, 1) > RsiMinimum) {
               ticket = OpenPendingOrder(1, iLots, SellLimit, slip, SellLimit, 0, 0, EAName + "-" + IntegerToString(NumOfTrades), MagicNumber, 0, HotPink);
               if (ticket < 0) {
                  Print("Error: ", GetLastError());
                  return (0);
               }
               LastBuyPrice = FindLastBuyPrice();
               NewOrdersPlaced = true;
            }
         } else {
            if (iRSI(NULL, PERIOD_H1, 14, PRICE_CLOSE, 1) < RsiMaximum) {
               ticket = OpenPendingOrder(0, iLots, BuyLimit, slip, BuyLimit, 0, 0, EAName + "-" + IntegerToString(NumOfTrades), MagicNumber, 0, Lime);
               if (ticket < 0) {
                  Print("Error: ", GetLastError());
                  return (0);
               }
               LastSellPrice = FindLastSellPrice();
               NewOrdersPlaced = true;
            }
         }
         if (ticket > 0) expiration = TimeCurrent() + 60.0 * (60.0 * MaxTradeOpenHours);
         TradeNow = false;
      }
   }
   total = CountTrades();
   AveragePrice = 0;
   double Count = 0;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      ticketOrder = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
         if (OrderType() == OP_BUY || OrderType() == OP_SELL) {
            AveragePrice += OrderOpenPrice() * OrderLots();
            Count += OrderLots();
         }
      }
   }
   if (total > 0) AveragePrice = NormalizeDouble(AveragePrice / Count, Digits);
   if (NewOrdersPlaced) {
      for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
         ticketOrder = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
            if (OrderType() == OP_BUY) {
               PriceTarget = AveragePrice + TakeProfit * Point;
               BuyTarget = PriceTarget;
               Stopper = AveragePrice - Stoploss * Point;
               flag = true;
            }
         }
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
            if (OrderType() == OP_SELL) {
               PriceTarget = AveragePrice - TakeProfit * Point;
               SellTarget = PriceTarget;
               Stopper = AveragePrice + Stoploss * Point;
               flag = true;
            }
         }
      }
   }
   if (NewOrdersPlaced) {
      if (flag == true) {
         for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
            ticketOrder = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
            if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) ticketOrder = OrderModify(OrderTicket(), NormalizeDouble(AveragePrice, Digits), NormalizeDouble(OrderStopLoss(), Digits), NormalizeDouble(PriceTarget, Digits), 0, Yellow);
            NewOrdersPlaced = false;
         }
      }
   }
   return (0);
}

int CountTrades() {
   int count = 0;
   for (int trade = OrdersTotal() - 1; trade >= 0; trade--) {
      ticketOrder = OrderSelect(trade, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         if (OrderType() == OP_SELL || OrderType() == OP_BUY) count++;
   }
   return (count);
}

void CloseThisSymbolAll() {
   for (int trade = OrdersTotal() - 1; trade >= 0; trade--) {
      ticketOrder = OrderSelect(trade, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol()) {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
            if (OrderType() == OP_BUY) ticketOrder = OrderClose(OrderTicket(), OrderLots(), Bid, slip, Blue);
            if (OrderType() == OP_SELL) ticketOrder = OrderClose(OrderTicket(), OrderLots(), Ask, slip, Red);
         }
         Sleep(1000);
      }
   }
}

int OpenPendingOrder(int pType, double pLots, double pLevel, int sp, double pr, int sl, int tp, string pComment, int pMagic, int pDatetime, color pColor) {
   int err = 0;
   int c = 0;
   int NumberOfTries = 100;
   switch (pType) {
   case 2:
      for (c = 0; c < NumberOfTries; c++) {
         ticket = OrderSend(Symbol(), OP_BUYLIMIT, pLots, pLevel, sp, StopLong(pr, sl), TakeLong(pLevel, tp), pComment, pMagic, pDatetime, pColor);
         err = GetLastError();
         if (err == 0 /* NO_ERROR */ ) break;
         if (!(err == 4 /* SERVER_BUSY */ || err == 137 /* BROKER_BUSY */ || err == 146 /* TRADE_CONTEXT_BUSY */ || err == 136 /* OFF_QUOTES */ )) break;
         Sleep(1000);
      }
      break;
   case 4:
      for (c = 0; c < NumberOfTries; c++) {
         ticket = OrderSend(Symbol(), OP_BUYSTOP, pLots, pLevel, sp, StopLong(pr, sl), TakeLong(pLevel, tp), pComment, pMagic, pDatetime, pColor);
         err = GetLastError();
         if (err == 0 /* NO_ERROR */ ) break;
         if (!(err == 4 /* SERVER_BUSY */ || err == 137 /* BROKER_BUSY */ || err == 146 /* TRADE_CONTEXT_BUSY */ || err == 136 /* OFF_QUOTES */ )) break;
         Sleep(5000);
      }
      break;
   case 0:
      for (c = 0; c < NumberOfTries; c++) {
         RefreshRates();
         ticket = OrderSend(Symbol(), OP_BUY, pLots, NormalizeDouble(Ask, Digits), sp, NormalizeDouble(StopLong(Bid, sl), Digits), NormalizeDouble(TakeLong(Ask, tp), Digits), pComment, pMagic, pDatetime, pColor);
         err = GetLastError();
         if (err == 0 /* NO_ERROR */ ) break;
         if (!(err == 4 /* SERVER_BUSY */ || err == 137 /* BROKER_BUSY */ || err == 146 /* TRADE_CONTEXT_BUSY */ || err == 136 /* OFF_QUOTES */ )) break;
         Sleep(5000);
      }
      break;
   case 3:
      for (c = 0; c < NumberOfTries; c++) {
         ticket = OrderSend(Symbol(), OP_SELLLIMIT, pLots, pLevel, sp, StopShort(pr, sl), TakeShort(pLevel, tp), pComment, pMagic, pDatetime, pColor);
         err = GetLastError();
         if (err == 0 /* NO_ERROR */ ) break;
         if (!(err == 4 /* SERVER_BUSY */ || err == 137 /* BROKER_BUSY */ || err == 146 /* TRADE_CONTEXT_BUSY */ || err == 136 /* OFF_QUOTES */ )) break;
         Sleep(5000);
      }
      break;
   case 5:
      for (c = 0; c < NumberOfTries; c++) {
         ticket = OrderSend(Symbol(), OP_SELLSTOP, pLots, pLevel, sp, StopShort(pr, sl), TakeShort(pLevel, tp), pComment, pMagic, pDatetime, pColor);
         err = GetLastError();
         if (err == 0 /* NO_ERROR */ ) break;
         if (!(err == 4 /* SERVER_BUSY */ || err == 137 /* BROKER_BUSY */ || err == 146 /* TRADE_CONTEXT_BUSY */ || err == 136 /* OFF_QUOTES */ )) break;
         Sleep(5000);
      }
      break;
   case 1:
      for (c = 0; c < NumberOfTries; c++) {
         ticket = OrderSend(Symbol(), OP_SELL, pLots, NormalizeDouble(Bid, Digits), sp, NormalizeDouble(StopShort(Ask, sl), Digits), NormalizeDouble(TakeShort(Bid, tp), Digits), pComment, pMagic, pDatetime, pColor);
         err = GetLastError();
         if (err == 0 /* NO_ERROR */ ) break;
         if (!(err == 4 /* SERVER_BUSY */ || err == 137 /* BROKER_BUSY */ || err == 146 /* TRADE_CONTEXT_BUSY */ || err == 136 /* OFF_QUOTES */ )) break;
         Sleep(5000);
      }
   }
   return (ticket);
}

double StopLong(double price, int stop) {
   if (stop == 0) return (0);
   else return (price - stop * Point);
}

double StopShort(double price, int stop) {
   if (stop == 0) return (0);
   else return (price + stop * Point);
}

double TakeLong(double price, int stop) {
   if (stop == 0) return (0);
   else return (price + stop * Point);
}

double TakeShort(double price, int stop) {
   if (stop == 0) return (0);
   else return (price - stop * Point);
}

double CalculateProfit() {
   double Profit = 0;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      ticketOrder = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         if (OrderType() == OP_BUY || OrderType() == OP_SELL) Profit += OrderProfit();
   }
   return (Profit);
}

void TrailingAlls(double pType, double stop, double AvgPrice) {
   double profit;
   double stoptrade;
   double stopcal;
   if (stop != 0) {
      for (int trade = OrdersTotal() - 1; trade >= 0; trade--) {
         if (OrderSelect(trade, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
            if (OrderSymbol() == Symbol() || OrderMagicNumber() == MagicNumber) {
               if (OrderType() == OP_BUY) {
                  profit = NormalizeDouble((Bid - AvgPrice) / Point, 0);
                  if (profit < pType) continue;
                  stoptrade = OrderStopLoss();
                  stopcal = Bid - stop * Point;
                  if (stoptrade == 0.0 || (stoptrade != 0.0 && stopcal > stoptrade)) ticketOrder = OrderModify(OrderTicket(), AvgPrice, stopcal, OrderTakeProfit(), 0, Aqua);
               }
               if (OrderType() == OP_SELL) {
                  profit = NormalizeDouble((AvgPrice - Ask) / Point, 0);
                  if (profit < pType) continue;
                  stoptrade = OrderStopLoss();
                  stopcal = Ask + stop * Point;
                  if (stoptrade == 0.0 || (stoptrade != 0.0 && stopcal < stoptrade)) ticketOrder = OrderModify(OrderTicket(), AvgPrice, stopcal, OrderTakeProfit(), 0, Red);
               }
            }
            Sleep(1000);
         }
      }
   }
}

double AccountEquityHigh() {
   if (CountTrades() == 0) AccountEquityHighAmt = AccountEquity();
   if (AccountEquityHighAmt < PrevEquity) AccountEquityHighAmt = PrevEquity;
   else AccountEquityHighAmt = AccountEquity();
   PrevEquity = AccountEquity();
   return (AccountEquityHighAmt);
}

double FindLastBuyPrice() {
   double oldorderopenprice = 0;
   int oldticketnumber;
   double unused = 0;
   int ticketnumber = 0;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      ticketOrder = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber && OrderType() == OP_BUY) {
         oldticketnumber = OrderTicket();
         if (oldticketnumber > ticketnumber) {
            oldorderopenprice = OrderOpenPrice();
            unused = oldorderopenprice;
            ticketnumber = oldticketnumber;
         }
      }
   }
   return (oldorderopenprice);
}

double FindLastSellPrice() {
   double oldorderopenprice = 0;
   int oldticketnumber;
   double unused = 0;
   int ticketnumber = 0;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      ticketOrder = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber && OrderType() == OP_SELL) {
         oldticketnumber = OrderTicket();
         if (oldticketnumber > ticketnumber) {
            oldorderopenprice = OrderOpenPrice();
            unused = oldorderopenprice;
            ticketnumber = oldticketnumber;
         }
      }
   }
   return (oldorderopenprice);
}
