//+------------------------------------------------------------------+
//|                                                           FW.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

extern double EquityStopEA = 9700.0;

enum PriodEnum {
      period1 = PERIOD_M1, //M1
      period2 = PERIOD_M5, //M5
      period3 = PERIOD_M15, // M15
      period4 = PERIOD_M30, // M30
      period5 = PERIOD_H1, // H1
      period6 = PERIOD_H4, //H4
      period7 = PERIOD_D1, //D1
      period8 = PERIOD_W1, //W1
      period9 = PERIOD_MN1 //MN
};

extern PriodEnum OrderPeriod = period6; //BUY TIME FRAME 

extern int StopLoss = 50; // StopLoss
extern int TrailStart = 10;
extern int TrailStop = 10;
extern double LotExponent = 1.2; // Lot Multiplyer e.g 0.1, series: 0.16, 0.26, 0.43 ...
extern bool DynamicPips = TRUE;
extern int DefaultPips = 50;
extern string LastBarNotes = "Number of last bars to calculate volatility";
extern int NumberOfLastBar  = 14; // number of last bars for calculation of volatility
extern int DEL = 3;
extern int SlipPage = 3; // how much the price may differ if the DC prompts requotes (the last time a little change the price)
extern double Lots = 0.01; // LOT SIZE
extern int EquityPerLot = 1000; // EQUITY PER LOT
extern int LotDecimal = 2; // How many decimal places in the lot count 0 - normal items (1) 1 - mini lots (0.1), 2 - micro (0.01)
extern double TakeProfit = 222.0; // Number of pips to close the trade
double Drop = 5000;
extern double RsiMinimum = 30.0; // Lower Boundry RSI
extern double RsiMaximum = 70.0; // Upper Boundry RSI
extern int MagicNumber = 575899; // magic number (Advisor uses this to distinguish trades)
extern double PipStep = 0;
extern int MaxTrades = 11; // the maximum number of simultaneously opened orders
extern bool UseEquityStop = FALSE;
extern double TotalEquityRisk = 10.0;
extern bool UseTrailingStop = TRUE;
extern bool UseTimeOut = FALSE; // use a timeout (to close the treade if they "hang" for too long)
extern double MaxTradeOpenHours = 360.0; // timeout trade hours (how many hovering close the transaction)

double PriceTarget, StartEquity, BuyTarget, SellTarget;
double AveragePrice, SellLimit, BuyLimit;
double LastBuyPrice, LastSellPrice, Spread;
bool flag;
string EAName = "FW2022";
datetime timeprev = 0, expiration;
int NumOfTrades = 0;
double iLots, l, ordprof;
int cnt = 0, total;
double Stopper = 0.0;
bool TradeNow = FALSE, LongTrade = FALSE, ShortTrade = FALSE;
int ticket, TicketOrder;
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

   RemoveExpertNow(EquityStopEA);

   l = MathFloor((AccountEquity() / EquityPerLot / 10000) / MarketInfo(Symbol(), 24)) * MarketInfo(Symbol(), 24);
   Lots = l;
   if (Lots < MarketInfo(Symbol(), 23)) Lots = MarketInfo(Symbol(), 23);
   if (Lots > MarketInfo(Symbol(), 25)) Lots = MarketInfo(Symbol(), 25);
   if (DynamicPips) {
      double hival = High[iHighest(NULL, OrderPeriod, MODE_HIGH, NumberOfLastBar, 1)]; // calculate highest and lowest price from last bar to 24 bars ago
      double loval = Low[iLowest(NULL, OrderPeriod, MODE_LOW, NumberOfLastBar, 1)]; // chart used for symbol and time period
      PipStep = NormalizeDouble((hival - loval) / DEL / Point, 0); // calculate pips for spread between orders
      if (PipStep < DefaultPips / DEL) PipStep = NormalizeDouble(DefaultPips / DEL, 0);
      if (PipStep > DefaultPips * DEL) PipStep = NormalizeDouble(DefaultPips * DEL, 0); // if dynamic pips fail, assign pips extreme value
   }

   double PrevCl;
   double CurrCl;
   if (UseTrailingStop) TrailingAlls(TrailStart, TrailStop, AveragePrice);
   if ((iCCI(NULL, 15, 55, 0, 0) > Drop && ShortTrade) || (iCCI(NULL, 15, 55, 0, 0) < (-Drop) && LongTrade)) {
      CloseThisSymbolAll();
      Print("Closed All due to TimeOut");
   }
   if (timeprev == Time[0]) return (0);
   timeprev = Time[0];
   double CurrentPairProfit = CalculateProfit();
   if (UseEquityStop) {
      if (CurrentPairProfit < 0.0 && MathAbs(CurrentPairProfit) > TotalEquityRisk / 100.0 * AccountEquityHigh()) {
         CloseThisSymbolAll();
         Print("Closed All due to Stop Out");
         NewOrdersPlaced = FALSE;
      }
   }
   total = CountTrades();
   if (total == 0) flag = FALSE;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      TicketOrder = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
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
         iLots = NormalizeDouble(Lots * MathPow(LotExponent, NumOfTrades), LotDecimal);
         if (iLots < MarketInfo(Symbol(), 23)) iLots = MarketInfo(Symbol(), 23);
         if (iLots > MarketInfo(Symbol(), 25)) iLots = MarketInfo(Symbol(), 25);
         RefreshRates();
         TicketOrder = OpenPendingOrder(1, iLots, Bid, SlipPage, Ask, 0, 0, EAName + "-" + Symbol() + OrderPeriod + "-" + NumOfTrades + "-" + PipStep, MagicNumber, 0, HotPink);
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
            iLots = NormalizeDouble(Lots * MathPow(LotExponent, NumOfTrades), LotDecimal);
            if (iLots < MarketInfo(Symbol(), 23)) iLots = MarketInfo(Symbol(), 23);
            if (iLots > MarketInfo(Symbol(), 25)) iLots = MarketInfo(Symbol(), 25);
            TicketOrder = OpenPendingOrder(0, iLots, Ask, SlipPage, Bid, 0, 0, EAName + "-" + Symbol() + OrderPeriod + "-" + NumOfTrades + "-" + PipStep, MagicNumber, 0, Lime);
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
      PrevCl = iClose(Symbol(), OrderPeriod, 2);
      CurrCl = iClose(Symbol(), OrderPeriod, 1);
      SellLimit = Bid;
      BuyLimit = Ask;
      if (!LongTrade) {
         NumOfTrades = total;
         iLots = NormalizeDouble(Lots * MathPow(LotExponent, NumOfTrades), LotDecimal);
         if (iLots < MarketInfo(Symbol(), 23)) iLots = MarketInfo(Symbol(), 23);
         if (iLots > MarketInfo(Symbol(), 25)) iLots = MarketInfo(Symbol(), 25);
         if (!LongTrade) {

            TicketOrder = OpenPendingOrder(0, iLots, BuyLimit, SlipPage, BuyLimit, 0, 0, EAName + "-" + Symbol() + OrderPeriod + "-" + NumOfTrades, MagicNumber, 0, Lime);

            if (ticket < 0) {
               Print("Error: ", GetLastError());
               return (0);
            }
            LastBuyPrice = FindLastBuyPrice();
            NewOrdersPlaced = TRUE;

         }
         if (ticket > 0) expiration = datetime(TimeCurrent() + 60.0 * (60.0 * MaxTradeOpenHours));
         TradeNow = FALSE;
      }
   }
   total = CountTrades();
   AveragePrice = 0;
   double Count = 0;
   for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      TicketOrder = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
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
         TicketOrder = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
            if (OrderType() == OP_BUY) {
               PriceTarget = AveragePrice + TakeProfit * Point;
               BuyTarget = PriceTarget;
               Stopper = AveragePrice - StopLoss * Point;
               flag = TRUE;
            }
         }
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
            if (OrderType() == OP_SELL) {
               PriceTarget = AveragePrice - TakeProfit * Point;
               SellTarget = PriceTarget;
               Stopper = AveragePrice + StopLoss * Point;
               flag = TRUE;
            }
         }
      }
   }
   
   if (NewOrdersPlaced) {
      if (flag == TRUE) {
         for (cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
            TicketOrder = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
            if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
               TicketOrder = OrderModify(OrderTicket(), NormalizeDouble(AveragePrice, Digits), NormalizeDouble(OrderStopLoss(), Digits), NormalizeDouble(PriceTarget, Digits), 0, Yellow);
            NewOrdersPlaced = FALSE;
         }
      }
   }
   
   Comment("",
      "\n Balance = ", DoubleToString(AccountBalance(), 2),
      "\n Equity = ", DoubleToString(AccountEquity(), 2),
      "\n Margin = ", DoubleToString(AccountMargin(), 2),
      "\n Free Margin = ", DoubleToString(AccountFreeMargin(), 2),
      "\n Total Orders = ", OrdersTotal(),
      "\n Lots = ", Lots, " --> ", iLots
      );
   if (total > MaxTrades) {
      for (int pos = 0; pos < OrdersTotal(); pos++) {
         TicketOrder = OrderSelect(pos, SELECT_BY_POS);
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
            if (OrderType() == OP_SELL) {
               TicketOrder = OrderClose(OrderTicket(), OrderLots(), Ask, 5, White);
               ordprof = OrderSwap() + OrderProfit() + OrderCommission();
               if (GetLastError() == 0) {
                  SendNotification("Closed order: " + Symbol() + ", " + IntegerToString(OrderType()) + ", " + DoubleToStr(Ask, Digits) + ", " + DoubleToStr(OrderLots(), 2) + ", " + DoubleToStr(ordprof, 2));
               }
               pos = OrdersTotal();
            }
         if (OrderType() == OP_BUY) {
            TicketOrder = OrderClose(OrderTicket(), OrderLots(), Bid, 5, White);
            ordprof = OrderSwap() + OrderProfit() + OrderCommission();
            if (GetLastError() == 0) {
               SendNotification("Closed order: " + Symbol() + ", " + IntegerToString(OrderType()) + ", " + DoubleToStr(Ask, Digits) + ", " + DoubleToStr(OrderLots(), 2) + ", " + DoubleToStr(ordprof, 2));
            }
            pos = OrdersTotal();
         }
      }
   }

   return (0);
}


int CountTrades() {
   int count = 0;
   for (int trade = OrdersTotal() - 1; trade >= 0; trade--) {
      TicketOrder = OrderSelect(trade, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         if (OrderType() == OP_SELL || OrderType() == OP_BUY) count++;
   }
   return (count);
}


void CloseThisSymbolAll() {
   for (int trade = OrdersTotal() - 1; trade >= 0; trade--) {
      TicketOrder = OrderSelect(trade, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol()) {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
            if (OrderType() == OP_BUY)
               TicketOrder = OrderClose(OrderTicket(), OrderLots(), Bid, SlipPage, Blue);
            if (OrderType() == OP_SELL)
               TicketOrder = OrderClose(OrderTicket(), OrderLots(), Ask, SlipPage, Red);
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
         TicketOrder = OrderSend(Symbol(), OP_BUYLIMIT, pLots, pLevel, sp, StopLong(pr, sl), TakeLong(pLevel, tp), pComment, pMagic, pDatetime, pColor);
         err = GetLastError();
         if (err == 0 /* NO_ERROR */ ) {
            SendNotification("pending order: " + Symbol() + ", BuyLimit, " + DoubleToStr(pLevel, Digits) + ", " + DoubleToStr(pLots, 2));
            break;
         }
         if (!(err == 4 /* SERVER_BUSY */ || err == 137 /* BROKER_BUSY */ || err == 146 /* TRADE_CONTEXT_BUSY */ || err == 136 /* OFF_QUOTES */ )) break;
         Sleep(1000);
      }
      break;
   case 4:
      for (c = 0; c < NumberOfTries; c++) {
         TicketOrder = OrderSend(Symbol(), OP_BUYSTOP, pLots, pLevel, sp, StopLong(pr, sl), TakeLong(pLevel, tp), pComment, pMagic, pDatetime, pColor);
         err = GetLastError();
         if (err == 0 /* NO_ERROR */ ) {
            SendNotification("pending order: " + Symbol() + ", BuyStop, " + DoubleToStr(pLevel, Digits) + ", " + DoubleToStr(pLots, 2));
            break;
         }
         if (!(err == 4 /* SERVER_BUSY */ || err == 137 /* BROKER_BUSY */ || err == 146 /* TRADE_CONTEXT_BUSY */ || err == 136 /* OFF_QUOTES */ )) break;
         Sleep(5000);
      }
      break;
   case 0:
      for (c = 0; c < NumberOfTries; c++) {
         RefreshRates();
         TicketOrder = OrderSend(Symbol(), OP_BUY, pLots, NormalizeDouble(Ask, Digits), sp, NormalizeDouble(StopLong(Bid, sl), Digits), NormalizeDouble(TakeLong(Ask, tp), Digits), pComment, pMagic, pDatetime, pColor);
         err = GetLastError();
         if (err == 0 /* NO_ERROR */ ) {
            SendNotification("Open order: " + Symbol() + ", Buy, " + DoubleToStr(Ask, Digits) + ", " + DoubleToStr(pLots, 2));
            break;
         }
         if (!(err == 4 /* SERVER_BUSY */ || err == 137 /* BROKER_BUSY */ || err == 146 /* TRADE_CONTEXT_BUSY */ || err == 136 /* OFF_QUOTES */ )) break;
         Sleep(5000);
      }
      break;
   case 3:
      for (c = 0; c < NumberOfTries; c++) {
         TicketOrder = OrderSend(Symbol(), OP_SELLLIMIT, pLots, pLevel, sp, StopShort(pr, sl), TakeShort(pLevel, tp), pComment, pMagic, pDatetime, pColor);
         err = GetLastError();
         if (err == 0 /* NO_ERROR */ ) {
            SendNotification("pending order: " + Symbol() + ", SellLimit, " + DoubleToStr(pLevel, Digits) + ", " + DoubleToStr(pLots, 2));
            break;
         }
         if (!(err == 4 /* SERVER_BUSY */ || err == 137 /* BROKER_BUSY */ || err == 146 /* TRADE_CONTEXT_BUSY */ || err == 136 /* OFF_QUOTES */ )) break;
         Sleep(5000);
      }
      break;
   case 5:
      for (c = 0; c < NumberOfTries; c++) {
         TicketOrder = OrderSend(Symbol(), OP_SELLSTOP, pLots, pLevel, sp, StopShort(pr, sl), TakeShort(pLevel, tp), pComment, pMagic, pDatetime, pColor);
         err = GetLastError();
         if (err == 0 /* NO_ERROR */ ) {
            SendNotification("pending order: " + Symbol() + ", SellStop, " + DoubleToStr(pLevel, Digits) + ", " + DoubleToStr(pLots, 2));
            break;
         }
         if (!(err == 4 /* SERVER_BUSY */ || err == 137 /* BROKER_BUSY */ || err == 146 /* TRADE_CONTEXT_BUSY */ || err == 136 /* OFF_QUOTES */ )) break;
         Sleep(5000);
      }
      break;
   case 1:
      for (c = 0; c < NumberOfTries; c++) {
         TicketOrder = OrderSend(Symbol(), OP_SELL, pLots, NormalizeDouble(Bid, Digits), sp, NormalizeDouble(StopShort(Ask, sl), Digits), NormalizeDouble(TakeShort(Bid, tp), Digits), pComment, pMagic, pDatetime, pColor);
         err = GetLastError();
         if (err == 0 /* NO_ERROR */ ) {
            SendNotification("Open order: " + Symbol() + ", Sell, " + DoubleToStr(Bid, Digits) + ", " + DoubleToStr(pLots, 2));
            break;
         }
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
      TicketOrder = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         if (OrderType() == OP_BUY || OrderType() == OP_SELL) Profit += OrderProfit();
   }
   return (Profit);
}

void TrailingAlls(int pType, int stop, double AvgPrice) {
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
                  if (stoptrade == 0.0 || (stoptrade != 0.0 && stopcal > stoptrade))
                     TicketOrder = OrderModify(OrderTicket(), AvgPrice, stopcal, OrderTakeProfit(), 0, Aqua);
               }
               if (OrderType() == OP_SELL) {
                  profit = NormalizeDouble((AvgPrice - Ask) / Point, 0);
                  if (profit < pType) continue;
                  stoptrade = OrderStopLoss();
                  stopcal = Ask + stop * Point;
                  if (stoptrade == 0.0 || (stoptrade != 0.0 && stopcal < stoptrade))
                     TicketOrder = OrderModify(OrderTicket(), AvgPrice, stopcal, OrderTakeProfit(), 0, Red);
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
      TicketOrder = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
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
      TicketOrder = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
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
      TicketOrder = OrderSelect(i, SELECT_BY_POS);
      if(OrderType() == OP_BUY) {
         TicketOrder = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, clrNONE);
      } else if(OrderType() == OP_SELL) {
         TicketOrder = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, clrNONE);
      } else {
         TicketOrder = OrderDelete(OrderTicket());
      }
      
      int MessageError = GetLastError();
      if(MessageError > 0) {
         Print("Unanticipated error " + IntegerToString(MessageError));
      }
      
      Sleep(100);      
      RefreshRates();
      
   }
}
