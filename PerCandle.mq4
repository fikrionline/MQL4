//+------------------------------------------------------------------+
//|                                              once_per_candle.mq4 |
//|                                  Copyright � 2009, Qwikisoft.com |
//|                                         http://www.qwikisoft.com |
//+------------------------------------------------------------------+
#property copyright "Copyright � 2009, Qwikisoft.com"
#property link "http://www.qwikisoft.com"

extern int    MagicNumber = 5758;
extern int    Slippage    = 5;
extern double Lots        = 0.01;
//extern double TakeProfit  = 107;
//extern double StopLoss    = 93;

datetime next_candle;
int SelectOrder;
int Ticket_open = 0;
int Ticket_close = 0;
double price, sl, tp;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init() {
   //----
   next_candle = Time[0] + Period();
   //----
   return (0);
}

//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit() {
   //----

   //----
   return (0);
}

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start() {
   //----

   if (next_candle <= Time[0]) {
      next_candle = Time[0] + Period();
      // New candle. Your trading functions here
      
      int total = OrdersTotal();
      for(int i=total-1; i>=0; i--)
      {
         SelectOrder = OrderSelect(i, SELECT_BY_POS);
         int type   = OrderType();      
         bool result = false;
      
         switch(type)
         {
            //Close opened long positions
            case OP_BUY    : result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), Slippage, Aqua );
            break;
            
            //Close opened short positions
            case OP_SELL   : result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), Slippage, Aqua );         
         }
          
      }
      
      if(Signal() == 1) 
      {
      
         type = OP_BUY;
         price = Ask;
         Ticket_open = OrderSend( Symbol(), type, Lots, price, Slippage, sl, 0, "Timed Trade", MagicNumber, 0, CLR_NONE);
         
      } else
      if(Signal() == -1) 
      {
         type = OP_SELL;
         price = Bid;
         Ticket_open = OrderSend(_Symbol, type, Lots, price, Slippage, sl, 0, "Timed Trade", MagicNumber, 0, CLR_NONE);
      }
      
   }
   //----
   return (0);
}
//+------------------------------------------------------------------+

//Signal
int Signal() {

   int signal = 0;

   double LastOpen = iOpen(Symbol(), Period(), 1);
   double LastClose = iClose(Symbol(), Period(), 1);
   
   if(LastClose > LastOpen)
   {
      signal = 1;
   } else
   if(LastClose < LastOpen)
   {
      signal = -1;
   }
   
   return signal;
   
}
