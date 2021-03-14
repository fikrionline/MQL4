//+------------------------------------------------------------------+
//|                                                     CloseAll.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern double PairPrice = 1.00000;
enum TypeOrder
  {
   TypeBuy = 1, //1.003
   TypeSell = 2 //1.00351748471
  };
input TypeOrder ChooseTypeOrder = 1;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
  
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+

void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

void OnTick()
  {
//---
  
  
  }
//+------------------------------------------------------------------+


int start(){   
   if(ChooseTypeOrder == 1)
   {
      RemoveAllOrders();
   return(0);
}
//+------------------------------------------------------------------+


int SelectOrder, CloseOrder, DeletOrder;

void RemoveAllOrders()
{
   for(int i = OrdersTotal() - 1; i >= 0 ; i--)
   {
      SelectOrder = OrderSelect(i, SELECT_BY_POS);
      if(OrderType() == OP_BUY) {
         CloseOrder = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, clrNONE);
      } else if(OrderType() == OP_SELL) {
         CloseOrder = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, clrNONE);
      } else {
         DeletOrder = OrderDelete(OrderTicket());
      }
      
      int MessageError = GetLastError();
      if(MessageError > 0) {
         Print("Unanticipated error " + IntegerToString(MessageError));
      }
      
      Sleep(100);
      
      RefreshRates();
   }
}
