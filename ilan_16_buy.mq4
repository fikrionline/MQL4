//+------------------------------------------------------------------+
//|                                     Bismillahirrohmanirrohim.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link "https://www.mql5.com"
#property version "1.1"
#property strict

extern double Stoploss = 50;
extern double TrailStart = 10;
extern double TrailStop = 10;

extern double LotExponent = 1.2;
extern int SlipPage = 3.0;
extern double Lots = 0.01;
extern int lotdecimal = 2;
extern double TakeProfit = 100;
extern double PipStep = 100;
extern int MagicNumber = 5758;
extern string CommentMagic = "Bismillahirrohmanirrohim";

int MaxTrades = 10;
bool UseEquityStop = TRUE;
double MinimalEquity = 9800; //in USD
bool UseTrailingStop = FALSE;
bool UseTimeOut = FALSE;
datetime MaxTradeOpenHours = 48;

double PriceTarget, StartEquity, BuyTarget, SellTarget;
double AveragePrice, SellLimit, BuyLimit;
double LastBuyPrice, LastSellPrice, Spread;
bool flag;
string EAName = "Bismillahirrohmanirrohim";
string CommentEA;
datetime timeprev, expiration;
double NumOfTrades = 0;
double iLots;
int total;
double Stopper = 0.0;
bool TradeNow = FALSE, LongTrade = FALSE, ShortTrade = FALSE;
int ticket, ticketOrder;
bool NewOrdersPlaced = FALSE;
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
   
   int cnt;
   double PrevCl;
   double CurrCl;
   
   if (UseTrailingStop) {
      TrailingAlls(TrailStart, TrailStop, AveragePrice);
   }
   
   if (UseTimeOut) {
      if (TimeCurrent() >= expiration) {
         CloseThisSymbolAll();
         Print("Closed All due to TimeOut");
      }
   }
   
   if (timeprev == Time[0]) {
      return (0);
   }
   timeprev = Time[0];
   
   double CurrentPairProfit = CalculateProfit();
   if (UseEquityStop) {
      if(AccountEquity() < MinimalEquity) {
         CloseThisSymbolAll();
         CloseThisSymbolAll();
         CloseThisSymbolAll();
         CloseThisSymbolAll();
         CloseThisSymbolAll();
         Print("Closed All due to Low Equity");
         NewOrdersPlaced = FALSE;
         ExpertRemove();
      }
   }
   
   total = CountTrades();
   if (total == 0) flag = FALSE;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      ticketOrder = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
         if (OrderType() == OP_BUY) {
            LongTrade = TRUE;
            ShortTrade = FALSE;
            break;
         }
      }
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
         if (OrderType() == OP_SELL) {
            LongTrade = FALSE;
            ShortTrade = TRUE;
            break;
         }
      }
   }
   if (total > 0 && total <= MaxTrades) {
      RefreshRates();
      LastBuyPrice = FindLastBuyPrice();
      LastSellPrice = FindLastSellPrice();
      if (LongTrade && LastBuyPrice - Ask >= PipStep * Point) TradeNow = TRUE;
      if (ShortTrade && Bid - LastSellPrice >= PipStep * Point) TradeNow = TRUE;
   }
   if (total < 1) {
      ShortTrade = FALSE;
      LongTrade = FALSE;
      TradeNow = TRUE;
      StartEquity = AccountEquity();
   }
   if (TradeNow) {
      LastBuyPrice = FindLastBuyPrice();
      LastSellPrice = FindLastSellPrice();
      if (ShortTrade) {
         NumOfTrades = total;
         iLots = NormalizeDouble(Lots * MathPow(LotExponent, NumOfTrades), lotdecimal);
         RefreshRates();
         ticket = OpenPendingOrder(1, iLots, Bid, SlipPage, Ask, 0, 0, CommentMagic, MagicNumber, 0, HotPink);
         if (ticket < 0) {
            Print("Error: ", GetLastError());
            return (0);
         }
         LastSellPrice = FindLastSellPrice();
         TradeNow = FALSE;
         NewOrdersPlaced = TRUE;
      } else {
         if (LongTrade) {
            NumOfTrades = total;
            iLots = NormalizeDouble(Lots * MathPow(LotExponent, NumOfTrades), lotdecimal);
            ticket = OpenPendingOrder(0, iLots, Ask, SlipPage, Bid, 0, 0, CommentMagic, MagicNumber, 0, Lime);
            if (ticket < 0) {
               Print("Error: ", GetLastError());
               return (0);
            }
            LastBuyPrice = FindLastBuyPrice();
            TradeNow = FALSE;
            NewOrdersPlaced = TRUE;
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
            if (iRSI(NULL, PERIOD_H4, 14, PRICE_CLOSE, 1) > 10.0) {
               ticket = OpenPendingOrder(1, iLots, SellLimit, SlipPage, SellLimit, 0, 0, CommentMagic, MagicNumber, 0, HotPink);
               if (ticket < 0) {
                  Print("Error: ", GetLastError());
                  return (0);
               }
               LastBuyPrice = FindLastBuyPrice();
               NewOrdersPlaced = TRUE;
            }
         } else {
            if (iRSI(NULL, PERIOD_H4, 14, PRICE_CLOSE, 1) < 90.0) {
               ticket = OpenPendingOrder(0, iLots, BuyLimit, SlipPage, BuyLimit, 0, 0, CommentMagic, MagicNumber, 0, Lime);
               if (ticket < 0) {
                  Print("Error: ", GetLastError());
                  return (0);
               }
               LastSellPrice = FindLastSellPrice();
               NewOrdersPlaced = TRUE;
            }
         }
         if (ticket > 0) {
            expiration = TimeCurrent() + 60.0 * (60.0 * MaxTradeOpenHours);
         }
         TradeNow = FALSE;
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
               flag = TRUE;
            }
         }
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
            if (OrderType() == OP_SELL) {
               PriceTarget = AveragePrice - TakeProfit * Point;
               SellTarget = PriceTarget;
               Stopper = AveragePrice + Stoploss * Point;
               flag = TRUE;
            }
         }
      }
   }
   if (NewOrdersPlaced) {
      if (flag == TRUE) {
         for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
            ticketOrder = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
            if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) ticketOrder = OrderModify(OrderTicket(), AveragePrice, OrderStopLoss(), PriceTarget, 0, Yellow);
            NewOrdersPlaced = FALSE;
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
            if (OrderType() == OP_BUY) ticketOrder = OrderClose(OrderTicket(), OrderLots(), Bid, SlipPage, Blue);
            if (OrderType() == OP_SELL) ticketOrder = OrderClose(OrderTicket(), OrderLots(), Ask, SlipPage, Red);
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
         ticket = OrderSend(Symbol(), OP_BUY, pLots, Ask, sp, StopLong(Bid, sl), TakeLong(Ask, tp), pComment, pMagic, pDatetime, pColor);
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
         ticket = OrderSend(Symbol(), OP_SELL, pLots, Bid, sp, StopShort(Ask, sl), TakeShort(Bid, tp), pComment, pMagic, pDatetime, pColor);
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
   int cnt;
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
   for (int cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
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
   for (int cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
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
