//+------------------------------------------------------------------+
//|                                                      SignalA.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Bismillahirrohmanirrohim"
#property link      "waddahattar@hotmail.com"
#property version   "1.00"
#property strict

extern int     Step = 66;
extern double  FirstLot = 0.01;
extern double  IncLot = 0.01;
extern int     MagicBuy = 101;
extern int     MagicSell = 201;

double gLotSell = 0;
double gLotBuy = 0;
double LSP, LBP, LotToComment;
int TicketOrder, PermissionToOrder;
string PrepareComment, CommentOrder;

int init() {
   return (0);
}
int deinit() {
   return (0);
}
int start() {

   PermissionToOrder = CanOrderNow();
   
   if(PermissionToOrder == 1) {
   
      if (MyOrdersTotal(MagicBuy) == 0) {
         LotToComment = FirstLot * 100;
         if(LotToComment < 10) {
            PrepareComment = "0" + DoubleToString(LotToComment, 0);
         } else {
            PrepareComment = DoubleToString(LotToComment, 0);
         }
         CommentOrder = Symbol() + "+" + PrepareComment;
         TicketOrder = OrderSend(Symbol(), OP_BUY, FirstLot, Ask, 0, 0, 0, CommentOrder, MagicBuy, 0, Green);
      }
      
      if (MyOrdersTotal(MagicSell) == 0) {
         LotToComment = FirstLot * 100;
         if(LotToComment < 10) {
            PrepareComment = "0" + DoubleToString(LotToComment, 0);
         } else {
            PrepareComment = DoubleToString(LotToComment, 0);
         }
         CommentOrder = Symbol() + "-" + PrepareComment;
         TicketOrder = OrderSend(Symbol(), OP_SELL, FirstLot, Bid, 0, 0, 0, CommentOrder, MagicSell, 0, Red);
      }
   
      LBP = GetLastBuyPrice(MagicBuy);
      LSP = GetLastSellPrice(MagicSell);
   
      if (Bid < LSP) {
         LotToComment = (gLotBuy + IncLot) * 100;
         if(LotToComment < 10) {
            PrepareComment = "0" + DoubleToString(LotToComment, 0);
         } else {
            PrepareComment = DoubleToString(LotToComment, 0);
         }
         CommentOrder = Symbol() + "+" + PrepareComment;
         TicketOrder = OrderSend(Symbol(), OP_BUYSTOP, gLotBuy + IncLot, LBP + Step * Point, 0, 0, 0, CommentOrder, MagicBuy, 0, Red);
   
      }
      
      if (Ask > LBP) {
         LotToComment = (gLotSell + IncLot) * 100;
         if(LotToComment < 10) {
            PrepareComment = "0" + DoubleToString(LotToComment, 0);
         } else {
            PrepareComment = DoubleToString(LotToComment, 0);
         }
         CommentOrder = Symbol() + "-" + PrepareComment;
         TicketOrder = OrderSend(Symbol(), OP_SELLSTOP, gLotSell + IncLot, LSP - Step * Point, 0, 0, 0, CommentOrder, MagicSell, 0, Red);
   
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
      if (OrderMagicNumber() == CheckMagic && OrderSymbol() == Symbol() && (OrderType() == OP_BUY || OrderType() == OP_BUYSTOP)) {
         if(OrderType() == OP_BUYSTOP) {
               return (0);
            }
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
      if (OrderMagicNumber() == CheckMagic && OrderSymbol() == Symbol() && (OrderType() == OP_SELL || OrderType() == OP_SELLSTOP)) {
            if(OrderType() == OP_SELLSTOP) {
               return (100000);
            }
         gLotSell = OrderLots();
         return (OrderOpenPrice());
         break;
      }
   }
   return (100000);
}

int CanOrderNow() {
   
   int CanOrder = 0;
   
   string FileName = "CanOrderNow.csv";
   if(FileIsExist(FileName)) {
      int FileHandle = FileOpen(FileName, FILE_READ | FILE_CSV);
      string FileRead = FileReadString(FileHandle);
   }
   
   return CanOrder;
   
}