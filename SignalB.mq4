//+------------------------------------------------------------------+
//|                                                      SignalB.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Bismillahirrohmanirrohim"
#property link      "waddahattar@hotmail.com"
#property version   "1.00"
#property strict

extern int     Step = 33;
extern double  FirstLot = 0.01;
extern double  IncLot = 0.01;
extern double  MinProfit = 100000;
extern double  MaxLoss = 100000;
extern int     MaxSlipPage = 9;
extern int     MagicBuy = 101;
extern int     MagicSell = 201;

double gLotSell = 0;
double gLotBuy = 0;
double LSP, LBP, NowEquity, NowBalance, NowFloating, LotToComment;
int TicketOrder;
string PrepareComment, CommentOrder;

int init() {
   GlobalVariableSet("OldBalance", AccountBalance());
   return (0);
}
int deinit() {
   return (0);
}
int start() {

   NowEquity = AccountEquity();
   NowBalance = GlobalVariableGet("OldBalance");
   NowFloating = NowEquity - NowBalance;

   Comment("Balance : " + DoubleToString(NowBalance, 2) + " | Floating: " + DoubleToString(NowFloating, 2));

   if (AccountEquity() > GlobalVariableGet("OldBalance") + MinProfit) {
      DeletePendingOrders(MagicBuy);
      DeletePendingOrders(MagicSell);
      CloseOrders(MagicBuy);
      CloseOrders(MagicSell);
      GlobalVariableSet("OldBalance", 0);
      GlobalVariableSet("OldBalance", AccountBalance());
   }
   
   if (AccountEquity() < GlobalVariableGet("OldBalance") - MaxLoss) {
      DeletePendingOrders(MagicBuy);
      DeletePendingOrders(MagicSell);
      CloseOrders(MagicBuy);
      CloseOrders(MagicSell);
      GlobalVariableSet("OldBalance", 0);
      GlobalVariableSet("OldBalance", AccountBalance());
   }

   if (MyOrdersTotal(MagicBuy) == 0) {
      LotToComment = FirstLot * 100;
      if(LotToComment < 10) {
         PrepareComment = "0" + DoubleToString(LotToComment, 0);
      } else {
         PrepareComment = DoubleToString(LotToComment, 0);
      }
      CommentOrder = PrepareComment + "-" + Symbol();
      TicketOrder = OrderSend(Symbol(), OP_BUY, FirstLot, Ask, MaxSlipPage, 0, 0, CommentOrder, MagicBuy, 0, Green);
   }
   
   if (MyOrdersTotal(MagicSell) == 0) {
      LotToComment = FirstLot * 100;
      if(LotToComment < 10) {
         PrepareComment = "0" + DoubleToString(LotToComment, 0);
      } else {
         PrepareComment = DoubleToString(LotToComment, 0);
      }
      CommentOrder = PrepareComment + "+" + Symbol();
      TicketOrder = OrderSend(Symbol(), OP_SELL, FirstLot, Bid, MaxSlipPage, 0, 0, CommentOrder, MagicSell, 0, Red);
   }

   LBP = GetLastBuyPrice(MagicBuy);
   LSP = GetLastSellPrice(MagicSell);

   if ((LSP - Bid) < 5 * Point) {
      LotToComment = (gLotSell + IncLot) * 100;
      if(LotToComment < 10) {
         PrepareComment = "0" + DoubleToString(LotToComment, 0);
      } else {
         PrepareComment = DoubleToString(LotToComment, 0);
      }
      CommentOrder = PrepareComment + "+" + Symbol();
      TicketOrder = OrderSend(Symbol(), OP_SELLLIMIT, gLotSell + IncLot, LSP + Step * Point, MaxSlipPage, 0, 0, CommentOrder, MagicSell, 0, Red);
   }

   if ((Ask - LBP) < 5 * Point) {
      LotToComment = (gLotBuy + IncLot) * 100;
      if(LotToComment < 10) {
         PrepareComment = "0" + DoubleToString(LotToComment, 0);
      } else {
         PrepareComment = DoubleToString(LotToComment, 0);
      }
      CommentOrder = PrepareComment + "-" + Symbol();
      TicketOrder = OrderSend(Symbol(), OP_BUYLIMIT, gLotBuy + IncLot, LBP - Step * Point, MaxSlipPage, 0, 0, CommentOrder, MagicBuy, 0, Red);
   }

   return (0);
}

int DeletePendingOrders(int CheckMagic) {
   int total = OrdersTotal();

   for (int cnt = total - 1; cnt >= 0; cnt--) {
      TicketOrder = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderMagicNumber() == CheckMagic && OrderSymbol() == Symbol() && (OrderType() != OP_BUY || OrderType() != OP_SELL)) {
         TicketOrder = OrderDelete(OrderTicket());
      }
   }
   return (0);
}

int CloseOrders(int CheckMagic) {
   int total = OrdersTotal();

   for (int cnt = total - 1; cnt >= 0; cnt--) {
      TicketOrder = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderMagicNumber() == CheckMagic && OrderSymbol() == Symbol()) {
         if (OrderType() == OP_BUY) {
            TicketOrder = OrderClose(OrderTicket(), OrderLots(), Bid, MaxSlipPage);
         }

         if (OrderType() == OP_SELL) {
            TicketOrder = OrderClose(OrderTicket(), OrderLots(), Ask, MaxSlipPage);
         }
      }
   }
   return (0);
}

int MyOrdersTotal(int CheckMagic) {
   int c = 0;
   int total = OrdersTotal();

   for (int cnt = 0; cnt < total; cnt++) {
      TicketOrder = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderMagicNumber() == CheckMagic && OrderSymbol() == Symbol()) {
         c++;
      }
   }
   return (c);
}

double GetLastBuyPrice(int CheckMagic) {
   int total = OrdersTotal() - 1;

   for (int cnt = total; cnt >= 0; cnt--) {
      TicketOrder = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderMagicNumber() == CheckMagic && OrderSymbol() == Symbol() && (OrderType() == OP_BUYLIMIT || OrderType() == OP_BUY)) {
         gLotBuy = OrderLots();
         return (OrderOpenPrice());
         break;
      }
   }
   return (0);
}

double GetLastSellPrice(int CheckMagic) {
   int total = OrdersTotal() - 1;

   for (int cnt = total; cnt >= 0; cnt--) {
      TicketOrder = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderMagicNumber() == CheckMagic && OrderSymbol() == Symbol() && (OrderType() == OP_SELLLIMIT || OrderType() == OP_SELL)) {
         gLotSell = OrderLots();
         return (OrderOpenPrice());
         break;
      }
   }
   return (100000);
}
