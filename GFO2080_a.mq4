//+------------------------------------------------------------------+
//|                                                      GFO2080.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern int     MagicNumber = 5758;
extern int     Slippage    = 3;
extern double  Lots        = 1;
extern double  TakeProfit  = 30;
extern double  StopLoss    = 30;

int            Ticket_open = 0;
int            Ticket_close = 0;

double iStochastic_h1_main_0 = iStochastic(NULL, PERIOD_H1, 5, 3, 3, MODE_SMA, 0, MODE_MAIN, 0);
double iStochastic_h1_main_1 = iStochastic(NULL, PERIOD_H1, 5, 3, 3, MODE_SMA, 0, MODE_MAIN, 1);
double iStochastic_h1_main_2 = iStochastic(NULL, PERIOD_H1, 5, 3, 3, MODE_SMA, 0, MODE_MAIN, 2);
double iStochastic_h1_main_3 = iStochastic(NULL, PERIOD_H1, 5, 3, 3, MODE_SMA, 0, MODE_MAIN, 3);
double iStochastic_h1_main_4 = iStochastic(NULL, PERIOD_H1, 5, 3, 3, MODE_SMA, 0, MODE_MAIN, 4);
double iStochastic_h1_main_5 = iStochastic(NULL, PERIOD_H1, 5, 3, 3, MODE_SMA, 0, MODE_MAIN, 5);

double iStochastic_h1_signal_0 = iStochastic(NULL, PERIOD_H1, 5, 3, 3, MODE_SMA, 0, MODE_SIGNAL, 0);
double iStochastic_h1_signal_1 = iStochastic(NULL, PERIOD_H1, 5, 3, 3, MODE_SMA, 0, MODE_SIGNAL, 1);
double iStochastic_h1_signal_2 = iStochastic(NULL, PERIOD_H1, 5, 3, 3, MODE_SMA, 0, MODE_SIGNAL, 2);
double iStochastic_h1_signal_3 = iStochastic(NULL, PERIOD_H1, 5, 3, 3, MODE_SMA, 0, MODE_SIGNAL, 3);
double iStochastic_h1_signal_4 = iStochastic(NULL, PERIOD_H1, 5, 3, 3, MODE_SMA, 0, MODE_SIGNAL, 4);
double iStochastic_h1_signal_5 = iStochastic(NULL, PERIOD_H1, 5, 3, 3, MODE_SMA, 0, MODE_SIGNAL, 5);

double iStochastic_m30_main_0 = iStochastic(NULL, PERIOD_M30, 5, 3, 3, MODE_SMA, 0, MODE_MAIN, 0);
double iStochastic_m30_main_1 = iStochastic(NULL, PERIOD_M30, 5, 3, 3, MODE_SMA, 0, MODE_MAIN, 1);
double iStochastic_m30_main_2 = iStochastic(NULL, PERIOD_M30, 5, 3, 3, MODE_SMA, 0, MODE_MAIN, 2);
double iStochastic_m30_main_3 = iStochastic(NULL, PERIOD_M30, 5, 3, 3, MODE_SMA, 0, MODE_MAIN, 3);
double iStochastic_m30_main_4 = iStochastic(NULL, PERIOD_M30, 5, 3, 3, MODE_SMA, 0, MODE_MAIN, 4);
double iStochastic_m30_main_5 = iStochastic(NULL, PERIOD_M30, 5, 3, 3, MODE_SMA, 0, MODE_MAIN, 5);

double iStochastic_m30_signal_0 = iStochastic(NULL, PERIOD_M30, 5, 3, 3, MODE_SMA, 0, MODE_SIGNAL, 0);
double iStochastic_m30_signal_1 = iStochastic(NULL, PERIOD_M30, 5, 3, 3, MODE_SMA, 0, MODE_SIGNAL, 1);
double iStochastic_m30_signal_2 = iStochastic(NULL, PERIOD_M30, 5, 3, 3, MODE_SMA, 0, MODE_SIGNAL, 2);
double iStochastic_m30_signal_3 = iStochastic(NULL, PERIOD_M30, 5, 3, 3, MODE_SMA, 0, MODE_SIGNAL, 3);
double iStochastic_m30_signal_4 = iStochastic(NULL, PERIOD_M30, 5, 3, 3, MODE_SMA, 0, MODE_SIGNAL, 4);
double iStochastic_m30_signal_5 = iStochastic(NULL, PERIOD_M30, 5, 3, 3, MODE_SMA, 0, MODE_SIGNAL, 5);

double iStochastic_m15_main_0 = iStochastic(NULL, PERIOD_M15, 5, 3, 3, MODE_SMA, 0, MODE_MAIN, 0);
double iStochastic_m15_main_1 = iStochastic(NULL, PERIOD_M15, 5, 3, 3, MODE_SMA, 0, MODE_MAIN, 1);
double iStochastic_m15_main_2 = iStochastic(NULL, PERIOD_M15, 5, 3, 3, MODE_SMA, 0, MODE_MAIN, 2);
double iStochastic_m15_main_3 = iStochastic(NULL, PERIOD_M15, 5, 3, 3, MODE_SMA, 0, MODE_MAIN, 3);
double iStochastic_m15_main_4 = iStochastic(NULL, PERIOD_M15, 5, 3, 3, MODE_SMA, 0, MODE_MAIN, 4);
double iStochastic_m15_main_5 = iStochastic(NULL, PERIOD_M15, 5, 3, 3, MODE_SMA, 0, MODE_MAIN, 5);

double iStochastic_m15_signal_0 = iStochastic(NULL, PERIOD_M15, 5, 3, 3, MODE_SMA, 0, MODE_SIGNAL, 0);
double iStochastic_m15_signal_1 = iStochastic(NULL, PERIOD_M15, 5, 3, 3, MODE_SMA, 0, MODE_SIGNAL, 1);
double iStochastic_m15_signal_2 = iStochastic(NULL, PERIOD_M15, 5, 3, 3, MODE_SMA, 0, MODE_SIGNAL, 2);
double iStochastic_m15_signal_3 = iStochastic(NULL, PERIOD_M15, 5, 3, 3, MODE_SMA, 0, MODE_SIGNAL, 3);
double iStochastic_m15_signal_4 = iStochastic(NULL, PERIOD_M15, 5, 3, 3, MODE_SMA, 0, MODE_SIGNAL, 4);
double iStochastic_m15_signal_5 = iStochastic(NULL, PERIOD_M15, 5, 3, 3, MODE_SMA, 0, MODE_SIGNAL, 5);

//Signal
int Signal() {

   int signal = 0;
   
   if(iStochastic_h1_main_0 > iStochastic_h1_signal_0) {
      signal = 1;
   }
   
   if(iStochastic_h1_main_0 < iStochastic_h1_signal_0) {
      signal = -1;
   }
   
   return(signal);
}

//Check previous order
int PosSelect()
{
   int posi = 0;
   for(int k = OrdersTotal() - 1; k >= 0; k--)
   {
      if(!OrderSelect(k, SELECT_BY_POS))
      {
         break;
      }
      
      if((OrderSymbol() != Symbol()) && (OrderMagicNumber() != MagicNumber))
      {
         continue;
      }
      
      if((OrderCloseTime() == 0) && (OrderSymbol() == Symbol()) && (OrderMagicNumber() == MagicNumber))
      {
         if(OrderType() == OP_BUY)
         {
            posi = 1; //Long position
         }
         if(OrderType() == OP_SELL)
         {
            posi = -1; //Short positon
         }
      }
   }
   return(posi);
}

void OnTick()
{
   int type;
   double price;
   double sl;
   double tp;
   
   if(PosSelect() == 0)
   {
      if(Signal() == 1)//Buy signal and no current chart positions exists
      {
         type = OP_BUY;
         price = Ask;
         sl = StopLoss > 0 ? NormalizeDouble(price - (double)StopLoss*_Point,_Digits):0.0;
         tp = TakeProfit > 0 ? NormalizeDouble(price + (double)TakeProfit*_Point,_Digits):0.0;
         Ticket_open = OrderSend(_Symbol, type, Lots, price, Slippage, 0, 0, "Timed Trade", MagicNumber, 0, CLR_NONE);
      }
      
      if(Signal() == -1)//Sell signal and no current chart positions exists
      {
         type = OP_SELL;
         price = Bid;
         sl = StopLoss > 0 ? NormalizeDouble(price + (double)StopLoss*_Point,_Digits):0.0;
         tp = TakeProfit > 0 ? NormalizeDouble(price - (double)TakeProfit*_Point,_Digits):0.0;
         Ticket_open = OrderSend(_Symbol, type, Lots, price, Slippage, 0, 0, "Timed Trade", MagicNumber, 0, CLR_NONE);
      }
   }
   else
   {
      for (int i=OrdersTotal()-1; i>=0; i--)
      {
         if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
         if(OrderSymbol() != Symbol()) continue;
         if(OrderMagicNumber() != MagicNumber) continue;
         if(OrderMagicNumber() == MagicNumber)
         {            
            if ((TimeCurrent() - OrderOpenTime()) > (1 * 60))
            {
               if (OrderType() == OP_BUY)
               {
                  if(iStochastic_h1_main_0 < iStochastic_h1_signal_0){
                     Ticket_close = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 0, CLR_NONE);
                  }
               }
               if (OrderType() == OP_SELL)
               {
                  if(iStochastic_h1_main_0 > iStochastic_h1_signal_0){
                     Ticket_close = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 0, CLR_NONE);
                  }
               }
            }
         }
      }
   }
   return;
}
